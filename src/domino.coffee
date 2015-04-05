# Domino.js
# Copyright (c) 2015 David Tai
#
#Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
# SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
# RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
# CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
# CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

# A FlowState is a dictionary of meta data with some special fields (listed below)
class FlowState
  # data is data value before a flow is executed
  data: null
  # dom is the root dom object
  dom: null
  # event is the event object if flow is triggered by an event
  event: null

# A FlowController maps events to 'flows' which are basically a list monadic binds
# to be executed by the FlowController monad
class FlowController
  # HScript root to render
  _h: null

  # Last rendered dom element
  _dom: null

  # Member storing the last data rendered, get this using .data
  _data: null

  # Template HTML to be converted to hscript
  html: ''

  # Define events with Backbone style eventing syntax
  # Event handler will be added to root element
  #
  # Example
  # events:
  #   'css.selector': 'flowName(see below)'
  events: null

  # Define flows to be used with eventing
  # Flows are a collection of functions each with the form of
  # (data, state) -> returns processedData
  # where
  #  - data is either the pre-Flow data passed when passed into the first function
  #    or the processedData from the previous function
  #  - state contains a FlowState object
  #  - processedData is the data to pass into the next function
  #    (typically a modified version of data)
  #
  # Each function's @ is set to its flow controller.  Note: It is ill-advised to stick state
  # onto @, instead stick state onto the state object to make it scoped to the duration of
  # each flow
  #
  # Example
  # flows:
  #   flowName:
  #     sanitize {sanitizationRules:''}
  #     validate {validationRules:''}
  #     render renderFunction, 'template'
  #
  flows: null

  constructor: ()->
    Object.defineProperty(@, 'data', {
      get: ()->
        return @_data
      set: (data)->

        return @_data = data
    })
    @init.apply @, arguments

  init: ()->

  bind: ()->

  flow: (flowName) ->
