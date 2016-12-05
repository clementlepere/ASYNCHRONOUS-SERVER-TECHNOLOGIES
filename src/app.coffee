http = require 'http'
user = require './user'
metrics = require './metrics'
url = require 'url'
express = require 'express'
bodyparser = require 'body-parser'
morgan = require 'morgan'
session = require 'express-session'
LevelStore = require('level-session-store')(session)

app = express()

app.use morgan 'dev'
app.set 'port', 1337

urlencodedParser = bodyparser.urlencoded({extended:true})
urljsonParser =  bodyparser.json()

#tell express to use pug views
app.set('view engine', 'pug')
app.set('views', "#{__dirname}/../views")

app.use '/', express.static "#{__dirname}/../public"

app.use session
  secret: 'MyAppSecret'
  store: new LevelStore '../db/sessions'
  resave: true
  saveUninitialized: true

app.get '/login', (req, res) ->
  console.log (req.session.username)
  res.render 'login'

app.get '/signup', (req, res) ->
  res.render 'signup'

app.post '/login', urlencodedParser, (req, res) ->
  user.get req.body.username, (err, data) ->
    console.log (data)
    return next err if err
    if req.body.password == data.password
      req.session.loggedIn = true
      req.session.username = data.username
      res.redirect '/'
    else
      res.redirect '/login'
  
app.get '/list/:username', (req, res) ->
  user.get req.params.username, (err, data) ->
    throw next err if err
    res.status(200).json data

app.post '/signup', urlencodedParser, (req, res) ->
  user.save req.body.username, req.body.password, req.body.name, req.body.email, (err) ->
    throw next err if err
    res.status(200).send()
    res.redirect 'login'

app.get '/logout', (req, res) ->
  delete req.session.loggedIn
  delete req.session.username
  res.redirect '/login'

authCheck = (req, res, next) ->
  unless req.session.loggedIn == true
    res.redirect '/login'
  else
    next()

app.get '/', authCheck, (req, res) ->
  res.render 'index', name : req.session.username


app.get "/metrics(/:id)?", (req, res) ->
  metrics.get req.params.id, (err, data) ->
    throw next err if err
    res.status(200).json data

app.get '/metrics.json', (req,res) ->
  metrics.get req.session.username, (err, metric)->
    res.status(200).json metric

app.post '/insert', (req,res)->
  console.log req
  console.log "body:", req.body
  met =
  [
    {
      timestamp: req.body.timestamp1,
      value: req.body.value1
    }
  ]
  metrics.save req.session.username, met, (err)->
    if err
      res.status(500)
    else
      res.status(200)

app.post '/', (req, res, next) ->
  console.log(req.body)
  res.json(req.body)


app.post "/metrics/:id", urlencodedParser, (req, res) ->
  metrics.save req.params.id, req.body, (err) ->
    throw next err if err
    res.status(200).send()

app.delete "/metrics(/:id)?", (req, res) ->
  metrics.remove req.params.id, (err) ->
    throw next err if err
    res.status(200).send()

app.listen app.get('port'), () ->
  console.log "listening on port #{app.get 'port' }"
