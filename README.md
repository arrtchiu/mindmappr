MindMappr
=========

Sample rails application for real-time events.

For real-time events, you will also need [MindMapprFeed](https://github.com/arrtchiu/mindmappr-feed).

Heroku Deployment
-----------------

1. Clone and deploy mindmappr feed (documentation on mindmappr repo homepage)
2. In your `mindmappr-feed` repo, run `heroku config:get REDISCLOUD_URL`
3. In your `mindmappr` repo, run the following commands:

        heroku create
        git push heroku master
        heroku run rake db:migrate
        heroku config:set REDISCLOUD_URL=redis://the-value-you-got-from-step-two
        heroku config:set MM_FEED_SERVER=http://my-mind-mappr-feed-server.herokuapp.com
