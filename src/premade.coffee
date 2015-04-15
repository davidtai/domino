_ = require 'underscore'

module.exports =
  set: (data, state)->
    if state.event.name == 'set'
      newData = state.event.data
    else
      newData = data
    return newData

  static: (data, state)->
    return state.stale

  higherOrder:
    validate: (validateFn, errorField)->
      return (data, state)->
        err = validateFn data
        if !err
          if errorField
            data[errorField] = ''
          else
            data.error = ''
          return data
        else
          original = _.extend {}, state.stale
          if errorField
            original[errorField] = err
          else
            original.error = err
          return original

    # console.logs something
    log: (message) ->
      return (data)->
        console.log message
        return data

    # triggers an event over the children
    triggerChildren: (event) ->
      return (data)->
        for child in @children
          child.trigger event, data
        return data
