# Assertions and Stubbing
chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

{ expect } = chai

# TestBot



describe 'foo', ->
  describe 'bar', ->
    it 'should return -1 when the value is not present', ->
      assert.equal -1, [1,2,3].indexOf(4)
