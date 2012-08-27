Chaplin = require 'chaplin'

Day = require 'models/Day'

module.exports = class Month extends Chaplin.Model

    store: window.Store

    defaults:
        'days': []

    year: -> @.get 'year'
    month: -> @.get 'month'

    initialize: ->
        # For this month, generate the days.
        days = 32 - new Date(@year(), @month(), 32).getDate()
        for day in [1...days + 1]
            @newDay day

    # Push a new day onto the stack.
    newDay: (day) ->
        days = @.get('days')
        days.push { 'day': day, 'month': @month(), 'year': @year() }
        @.unset 'days', 'silent': true
        @.set 'days': days