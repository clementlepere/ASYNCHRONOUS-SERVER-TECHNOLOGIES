should = require('should')
user = require('../src/user')

describe 'my first test list', ->

  it 'should return lepere (get)', ->
    user.get 'lepere',  (done) ->
      done.should.equal "lepere"

  it 'should not return lepere (get)', ->
    user.get 'test', (done) ->
      done.should.be.not.equal 'lepere'

  it 'should return lepere (save)', ->
    user.save 'lepere', (done) ->
      done.should.equal 'lepere'