Client = require './Clients'

class VersionService extends Client

  constructor: (robot) ->
    super(robot, '/version')

  get: (conversation) ->
    @robot.get() (err, res, body) ->
      if err
        conversation.reply "Encountered an error :( #{err}"
        return
      data = JSON.parse body
      conversation.reply data.version

module.exports = VersionService
