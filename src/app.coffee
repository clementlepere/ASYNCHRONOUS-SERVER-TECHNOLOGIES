# Import a module
http = require 'http'
user = require './user.coffee'
url = require 'url'
fs = require 'fs'

# Declare an http server
http.createServer (req, res) ->

  path = url.parse(req.url).pathname

  user.get "cesar", (id) ->
    # Write a response header
    res.writeHead 200,
      'Content-Type': 'text/plain'

    # Write a response content
    #res.end('Hello World\n');`
    res.end "hello #{id}" # "hello" + id

# Start the server
.listen 1337, '127.0.0.1', () ->
  console.log "running on 127.0.0.1:1337"
