#!/usr/bin/env ruby
# encoding: UTF-8
require 'gmail'
require 'yaml'
require 'yo-ruby'

class KapachowYo

    CONFIG = begin
        YAML.load(File.open("config.yml"))
    rescue ArgumentError => e
        puts "Could not parse your config file: #{e.message}"
    end

    # ----

    def initialize
        fail unless CONFIG
        @gmail = nil
        @debug = CONFIG['debug_logging']
        @yo_attempts = 0
        Yo.api_key = CONFIG['yo_api_key']
        check
    end

    def check
        @gmail = Gmail.new(CONFIG['gmail_username'], CONFIG['gmail_password'])
        send_yo if new_subscription_count > 0
        @gmail.logout
    end

    private

    def new_subscription_count
        begin
            unread_emails = @gmail.mailbox(CONFIG['gmail_label']).emails(:unread)
            puts "Found #{unread_emails.size} unread messages" if @debug
            unread_emails.each { |email| email.mark(:read) }
            return unread_emails.size
        rescue Net::IMAP::ByeResponseError
            puts "Gmail error. I'll try again next time."
            return 0
        end
    end

    def send_yo
        puts "Yo attempts so far: #{@yo_attempts}" if @debug
        return if @yo_attempts > 5

        link = CONFIG['yo_link']
        begin
            if link
                puts "Sending Yo with link #{link}" if @debug
                Yo.all!({ :link => link })
            else
                puts "Sending Yo with no link" if @debug
                Yo.all!
            end
        rescue YoRateLimitExceeded
            puts "Too many Yos sent. Waiting a minute..." if @debug
            @yo_attempts += 1
            sleep(60)
            send_yo
        end
    end
end

KapachowYo.new
