# Description
#   Listen for tweets from account API keys are from.
#   Also add a string to the HUBOT_TWITTER_TRACK variable
#   for extra names or phrases to track against
#
# Dependencies:
#   "ntwitter": "0.5.0"
#
# Configuration:
#   HUBOT_TWITTER_ROOM            Which room to send tweets to
#   HUBOT_TWITTER_TRACK           Which extra names/handles/phrases to track
#   HUBOT_TWITTER_CONSUMER_KEY
#   HUBOT_TWITTER_CONSUMER_SECRET
#   HUBOT_TWITTER_TOKEN_KEY
#   HUBOT_TWITTER_TOKEN_SECRET
#
# Commands:
#   Hubot Twitter Lurker: Listens to twitter - is non-interactive. For now. Muwahahahahahaha.
#
# Author:
#   fideloper

hubot_twitter_bot = false

hubot_twitter_room = process.env.HUBOT_TWITTER_ROOM
hubot_twitter_track = process.env.HUBOT_TWITTER_TRACK

hubot_twitter_consumer_key = process.env.HUBOT_TWITTER_CONSUMER_KEY
hubot_twitter_consumer_secret = process.env.HUBOT_TWITTER_CONSUMER_SECRET
hubot_twitter_token_key = process.env.HUBOT_TWITTER_TOKEN_KEY
hubot_twitter_token_secret = process.env.HUBOT_TWITTER_TOKEN_SECRET

module.exports = (robot) ->

  hubot_twitter_bot = robot

  # Setup listener
  twitter = require 'ntwitter'

  twit = new twitter(
    consumer_key: hubot_twitter_consumer_key
    consumer_secret: hubot_twitter_consumer_secret
    access_token_key: hubot_twitter_token_key
    access_token_secret: hubot_twitter_token_secret
  )

  handle_connect twit


handle_connect = (twit)->
  twit.stream "user",
    track: hubot_twitter_track
    with: "user"
  , (stream) ->
    handle_stream stream

handle_stream = (stream) ->
  stream.on('error', handle_error)
  stream.on('data', handle_data)

handle_error = (err, data) ->
  console.log(err, data)

handle_data = (data) ->
  hubot_twitter_bot.messageRoom hubot_twitter_room, "https://twitter.com/" + data.user.screen_name + "/status/" + data.id_str  if data.text


