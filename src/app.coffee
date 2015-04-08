MainLoop = require('../lib/seldom').MainLoop
FlowController = require('../lib/seldom').FlowController
h = require 'virtual-dom/h'

$ ()->
  HelloWorldTemplate = (data) ->
    h 'div.text#hello-world', data.message

  class HelloWorldController extends FlowController
    constructor: ->
      super 'body', {message: 'Herro Worrd!'}, true

    init: ->
      @setFlow 'render', @render(HelloWorldTemplate)

  hwc = new HelloWorldController()

MainLoop.start()
