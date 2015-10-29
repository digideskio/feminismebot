# Load any undefined ENV variables
envfile = __dirname + '/.env'
require('node-env-file')(envfile) if require('fs').existsSync(envfile)

twitter = require("./twitter")
do twitter.stream
