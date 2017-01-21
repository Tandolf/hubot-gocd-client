VersionService = require './services/VersionServices'

# Description
#   a script that makes it possible to communicate with gocd
#
# Configuration:
#   GOCD_HOST - the host adress of GOCD (example: http://127.0.0.1:8080)
#
# Commands:
#   hubot gocd version - Will answer with the version of GOCD
#   hubot gocd build <pipeline> - Triggers a pipeline with the given name
#
# Notes:
#   user is hardcoded at the moment
#
# Author:
#   Thomas Andolf <thomas.andolf@gmail.com>

module.exports = (robot) ->
  robot.respond /hello/, (res) ->
    res.reply 'hello!'

  robot.hear /orly/, (res) ->
    res.send 'yarly'

  host = process.env.GOCD_HOST;

  robot.respond /gocd version/i, (conversation) ->
    versionService = new VersionService(robot);
    versionService.get conversation;

  user = 'badger'
  pass = 'badger'
  auth = 'Basic ' + new Buffer(user + ':' + pass).toString('base64')

  robot.respond /gocd build (.*)/i, (msg) ->
    pipeline = msg.match[1]
    robot.http(host + "/go/api/pipelines/" + pipeline + "/schedule")
    .header('Authorization', auth).header('Confirm', 'true')
    .post() (err, res, body) ->
      if err
        msg.reply "Encountered an error :( #{err}"
        return
      if res.statusCode is 200
        msg.reply 'Yes Sir, pipeline: ' + pipeline + ' has been started'
        return
      if res.statusCode is 404
        msg.reply 'Im sorry Sir, but i couldn\'t find the pipeline ' + pipeline + ' for you, can you please check the spelling?'
        return
      if res.statusCode is 409
        msg.reply 'Im sorry Sir, but i couldn\'t start the pipeline ' + pipeline + ' cause it\'s already running!'
        return
      else
        msg.reply 'Im sorry Sir, something went wrong... ' + body
        return
