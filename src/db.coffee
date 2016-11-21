levelup = require 'level'
levelws = require 'level-ws'

module.exports = (path) ->
  return levelws levelup path