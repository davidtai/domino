module.exports =
  set: (data)->
    if state.event.name == 'set'
      newData = state.event.data
    else
      newData = data
    @trigger('render', newData)
    return newData

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
