should = require 'should'
user = require '../src/user.coffee'

describe 'my first test list', () ->
  it 'should get a user w/ right parameters', (done) ->
    # do smth user
    user.get "marie", (res) ->
      res.should.equal "marie"
      done()
