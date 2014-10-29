# Kapa-chow! Yo

When someone subscribes to your band on Bandcamp they send you an email with "Kapa-chow!" in the subject. I thought it might be fun for everyone in the band to get a Yo too, so I made this. It checks a folder in your Gmail account and sends a Yo if there are any unread Kapa-chow! emails (and marks them as read).

## Installation

Requires Ruby 1.9.3 and the ruby-gmail and yo-ruby gems.

You'll also need a Gmail account and a Yo API key, which you can get from [the Yo API site](http://yoapi.justyo.co/). Create an account with a name you'll remember (like "[band name]NEWSUBSCRIBERS"). Send a Yo to that name from your phone to subscribe to it (your bandmates can do that too).

1. Clone the project to your server
2. Copy `config.sample.yml` to `config.yml` and enter your Gmail/Yo details
3. Add a line to your crontab to run the script every minute. I use RVM to manage Ruby versions, so I have this line in `/etc/crontab`:

```
*  *    * * *   ben     cd /home/ben/kapachow-yo && /home/ben/.rvm/wrappers/ruby-2.1.3/ruby /home/ben/kapachow-yo/kapachow_yo.rb -s >> /home/ben/log/kapachow-yo
```

Without RVM you could probably do something like:

```
*  *    * * *   ben     cd /home/ben/kapachow-yo && ruby /home/ben/kapachow-yo/kapachow_yo.rb -s >> /home/ben/log/kapachow-yo
```

I'm also logging the debug output to a file. If you don't need to do that either:

```
*  *    * * *   ben     cd /home/ben/kapachow-yo && ruby /home/ben/kapachow-yo/kapachow_yo.rb -s >> /dev/null
```

To test it, mark an email in your Gmail folder to unread and wait for the script to run. You should get a Yo. If not, set `debug: true` in config.yml and run `ruby ./kapachow_yo.rb` – you should see "Found n unread messages" and maybe something about sending a Yo. If you see an error, you'll have to fix it. :)
