# event.js
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


module.exports = class EventEmitter
  events: null
  constructor: ->
    @events = {}

  # add a namespaced listener
  on: (name, listener, namespace = '') ->
    # add listener to event map, create missing hashes for namespace and event name
    if !(namespacedEvents = @events[namespace])?
      namespacedEvents = @events[namespace] = {}

    if !(namedEvents = namespacedEvents[name])?
      namedEvents = namespacedEvents[name] = []

    namedEvents.push listener

  # add a namespaced listener that only executes once
  once: (name, listener, namespace) ->
    # modify the listener function to off itself
    l2 = () =>
      listener.apply @, arguments
      @off.call @, name, l2, namespace

    @on name, l2, namespace

  trigger: (name, data, namespace = '') ->
    # execute event in namespace, abort if namespae or event name does not exist
    namespacedEvents = @events[namespace]
    if !namespacedEvents?
      return

    namedEvents = namespacedEvents[name]
    if !namedEvents?
      return

    for listener in namedEvents
      listener.call(@, data)

  # removed a namespaced listener
  off: (name, listener, namespace = '') ->
    # abort off if namespace or event name does not exist
    namespacedEvents = @events[namespace]
    if !namespacedEvents?
      return

    namedEvents = namespacedEvents[name]
    if !namedEvents?
      return

    # return the listener removed if true, otherwise return null
    for i, v of namedEvents
      if listener == v
        namedEvents.splice i, 1
        return v

    return null

  # various other ways of removing listeners
  offAll: () ->
    #delete everything
    for k, v of @events
      delete @events[k]

  offNamespace: (namespace) ->
    # delete a whole namespace
    delete @events[namespace]

  offEvents: (name) ->
    # loop over namespaces and delete everything associated with event
    for namespacedEvents of @events
      delete namespacedEvents[name]

  offNamespacedEvents: (name, namespace = '') ->
    # delete everything associated with event in a specific namespace
    if !(namespacedEvents = @events[namespace])?
      namespacedEvents = @events[namespace] = {}

    delete namespacedEvents[name]

  # diagnostic
  isEmpty: ()->
    for k, v of @events
      return false
    return true

