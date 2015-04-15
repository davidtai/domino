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
