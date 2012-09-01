Chaplin = require 'chaplin'

module.exports = class Day extends Chaplin.Model

    defaults:
        'notes': ''
        'activities': []

    url: -> [ '/api', 'day', @get('year'), @get('month'), @get('day') ].join('/')

    initialize: ->
        # Add which day of the week this is.
        date = new Date @get('year'), @get('month') - 1, @get('day')
        dayOfWeek = date.getDay()
        if dayOfWeek is 0 then dayOfWeek = 7

        @.set 'dayOfWeek': dayOfWeek, { 'silent': true }