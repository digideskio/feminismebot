# Load any undefined ENV variables
envfile = __dirname + '/.env'
require('node-env-file')(envfile) if require('fs').existsSync(envfile)

# Tracked token
TRACKED_TOKEN = process.env.TRACKED_TOKEN or 'féminisme'
GENERAL_OUTPUT = 'Now streaming on [' + TRACKED_TOKEN + ']'
# Web server port
PORT = process.env.PORT or 9000

Twit = require('twit')

twit = new Twit
    consumer_key:         process.env.TW_CONSUMER_KEY
    consumer_secret:      process.env.TW_CONSUMER_SECRET
    access_token:         process.env.TW_ACCESS_TOKEN
    access_token_secret:  process.env.TW_ACCESS_TOKEN_SECRET

# Dummy noop fonction
noop = (->)

stream = exports.stream = ->
  console.log GENERAL_OUTPUT
  # stream research on public statuses
  st = twit.stream 'statuses/filter', track: TRACKED_TOKEN
  st.on "tweet", (tweet) ->
    # Tweet the new status
    twit.post 'statuses/update', status: replace(tweet.text), ->
      # Print out info
      console.log 'New tweet from https://twitter.com/%s/status/%s', tweet.user.screen_name, tweet.id_str
      # Favorites the original status
      twit.post 'favorites/create', id: tweet.id_str, noop

replace = exports.replace = (text)->
  text.replace /(#?féminisme)/gi, (match, p1)->
    if match[0] is '#' then '#bonSens' else 'bon sens'

# Start monitoring
do stream

# Minimalistic web-server to keep the service up
require('http').createServer( (req, res)->
  res.writeHead 200, 'Content-Type': 'text/plain;charset=utf-8'
  res.end GENERAL_OUTPUT
).listen(PORT)
