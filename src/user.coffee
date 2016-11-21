db = require('./db')("#{__dirname}/../db/user")

module.exports =

#Get a user by username
  get: (username, callback) ->
    user = {}
    rs = db.createReadStream
      gte: "user:#{username}"
    rs.on 'data', (data) ->
      #parsing logic
      [_, _username] = data.key.split ':'
      [_password, _name, _email] = data.value.split ':'
      if _username == username
        user=
          username: _username
          password: _password
          name: _name
          email: _email
    rs.on 'error', callback
    rs.on 'close', ->
      callback null, user

#Save a user with its info
  save: (username, password, name, email, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write
      key: "user:#{username}"
      value: "#{password}:#{name}:#{email}"
    ws.end()

#Delete a user by username
  remove: (username, callback) ->
    db.del "user:#{username}", (err) ->
      callback !err