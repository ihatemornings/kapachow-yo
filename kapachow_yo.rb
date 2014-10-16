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
        unread_emails = @gmail.mailbox(CONFIG['gmail_label']).emails(:unread)
        puts "Found #{unread_emails.size} unread messages" if @debug
        unread_emails.each { |email| email.mark(:read) }
        return unread_emails.size
    end

    def send_yo
        link = CONFIG['yo_link']
        begin
            if link
                Yo.all!({ :link => link })
            else
                Yo.all!
            end
        rescue YoRateLimitExceeded
            sleep(60)
            send_yo
        end
    end
end

KapachowYo.new
