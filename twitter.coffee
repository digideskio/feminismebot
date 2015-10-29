_     = require('underscore')
Twit  = require('twit')
wfall = require('async-waterfall')

# Tracked token
TRACKED_TOKEN        = process.env.TRACKED_TOKEN or 'féminisme'

twit = new Twit
    consumer_key:         process.env.TW_CONSUMER_KEY
    consumer_secret:      process.env.TW_CONSUMER_SECRET
    access_token:         process.env.TW_ACCESS_TOKEN
    access_token_secret:  process.env.TW_ACCESS_TOKEN_SECRET

stream = exports.stream = ->
    # stream research on public statuses
    st = twit.stream 'statuses/filter', track: TRACKED_TOKEN
    st.on "tweet", (tweet) ->
      # Tweet the new status
      twit.post 'statuses/update', status: replace(tweet.text), ->
        # Print out info
        console.info 'New tweet from https://twitter.com/%s/status/%s', tweet.user.screen_name, tweet.id_str


replace = exports.replace = (text)->
  text.replace /(#?féminisme)/gi, (match, p1)->
    if match[0] is '#' then '#bonSens' else 'bon sens'
