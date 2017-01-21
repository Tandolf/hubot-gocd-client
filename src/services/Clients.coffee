class Client

  constructor: (robot, path) ->
    @robot = robot.http(process.env.GOCD_HOST + '/go/api' + path)
    .header('Accept', 'application/vnd.go.cd.v1+json')

module.exports = Client


