Chaplin = require 'chaplin'

Mediator = require 'chaplin/core/Mediator'

module.exports = class Day extends Chaplin.Model

    defaults:
        'notes': ''
        'activities': []
        'selected': false # are we selected in the View?

    url: -> [ '/api', 'day', @get('year'), @get('month'), @get('day') ].join('/')

    initialize: ->
        # Add which day of the week this is.
        date = new Date @get('year'), @get('month') - 1, @get('day')
        dayOfWeek = date.getDay()
        if dayOfWeek is 0 then dayOfWeek = 7

        @.set 'dayOfWeek': dayOfWeek, { 'silent': true }