# Import a module
http = require 'http'
user = require './user.coffee'
url = require 'url'
fs = require 'fs'
express = require 'express'
metrics = require './metrics.coffee'
app = express()

app.set 'port', 1337
app.listen app.get('port'), () ->
	console.log "server listening on #{app.get 'port'}"

app.use '/', express.static "#{__dirname}/../public"

app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'pug'

app.get '/', (req, res) ->
	res.render 'index', {}

app.get '/metrics.json', (req, res) ->
	metrics.get (err, data) ->
		throw next err if err
		res.status(200).json data


