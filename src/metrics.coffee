levelup = require 'levelup'
levelws = require 'level-ws'
db = require('./db')("#{__dirname}/../db/metrics")


module.exports =

  save: (id, metrics, callback) ->
    ws = db.createWriteStream()
    console.log metrics
    ws.on 'error', callback
    ws.on 'close', callback
    for metric in metrics
      {timestamp, value} = metric
      ws.write
        key: "metric:#{id}:#{timestamp}"
        value: value
    console.log "success"
    ws.end()


  get: (id, callback) ->
    metrics = []
    if id
      console.log id
      options =
        start: "metric:#{id}"
        end: "metric:#{parseInt(id) + 1}"
    else
      console.log "empty"
      options = {}

    rs = db.createReadStream options
    console.log options
    rs.on 'data', (data) ->
      [_, _id, timestamp] = data.key.split ':'
      metrics.push
        id: _id
        timestamp: timestamp
        value: data.value
    rs.on 'error', callback
    rs.on 'close', ->
      callback null, metrics

  remove: (id, callback) ->
      this.get id, (err, metricsId) ->
        if !metricsId.length
          callback false
          return

        for m in metricsId
          db.del "metric:#{m.id}:#{m.timestamp}", (err) ->
            callback !err





###  get: (callback) ->
    callback null, [
      timestamp:(new Date '2016-11-04 14:00 UTC').getTime(), value:12
    ,
      timestamp:(new Date '2016-11-05 14:30 UTC').getTime(), value:15
    ]
###


