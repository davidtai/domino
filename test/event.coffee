chai = require('chai')
chai.config.includeStack = true
should = chai.should()

EventEmitter = require '../lib/event'

describe 'EventEmitter.on/EventEmitter.trigger', ->
  beforeEach ()->
    ee = new EventEmitter()
    ee.offAll()

  it 'should register a listener', ->
    run = false

    ee = new EventEmitter()
    ee.isEmpty().should.be.true
    ee.on 'blah', ()-> run = true
    ee.isEmpty().should.be.false

    ee.trigger 'blah'

    run.should.be.true

  it 'should register a listener with namespace', ->
    run = false

    ee = new EventEmitter()
    ee.isEmpty().should.be.true
    ee.on 'blah', ()->
      run = true
    , 'namespace'
    ee.isEmpty().should.be.false

    ee.trigger 'blah'
    run.should.be.false

    ee.trigger 'blah', '', 'namespace'
    run.should.be.true

describe 'EventEmitter.once/EventEmitter.trigger', ->
  beforeEach ()->
    ee = new EventEmitter()
    ee.offAll()

  it 'should register a listener triggerable once', ->
    toggle = false

    ee = new EventEmitter()
    ee.isEmpty().should.be.true
    ee.once 'blah', ()-> toggle = !toggle
    ee.isEmpty().should.be.false

    ee.trigger 'blah'
    toggle.should.be.true

    ee.trigger 'blah'
    toggle.should.be.true

  it 'should register a listener with namespace triggerable once', ->
    toggle = false

    ee = new EventEmitter()
    ee.isEmpty().should.be.true
    ee.once 'blah', ()->
      toggle = !toggle
    , 'namespace'
    ee.isEmpty().should.be.false

    ee.trigger 'blah'
    toggle.should.be.false

    ee.trigger 'blah', '', 'namespace'
    toggle.should.be.true

    ee.trigger 'blah', '', 'namespace'
    toggle.should.be.true

describe 'EventEmitter.off', ->
  beforeEach ()->
    ee = new EventEmitter()
    ee.offAll()

  it 'should unregister a specific listener', ->
    toggle = false
    func = ()-> toggle = !toggle

    ee = new EventEmitter()
    ee.isEmpty().should.be.true
    ee.on 'blah', func
    ee.isEmpty().should.be.false

    ee.trigger 'blah'
    toggle.should.be.true

    # should have no effect
    ee.off 'blah', ()-> toggle = !toggle

    ee.trigger 'blah'
    toggle.should.be.false

    ee.off 'blah', func
    ee.trigger 'blah'
    toggle.should.be.false

    ee.trigger 'blah'
    toggle.should.be.false
