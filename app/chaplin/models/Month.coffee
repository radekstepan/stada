Chaplin = require 'chaplin'

Day = require 'chaplin/models/Day'

module.exports = class Month extends Chaplin.Model

    store: window.Store

    initialize: ->
        # Add the days.
        @.set 'days': []

        # For this month, generate the days.
        days = 32 - new Date(@attributes.year, @attributes.month - 1, 32).getDate()
        for day in [1...days + 1]
            @newDay day

    # Push a new day onto the stack.
    newDay: (day) ->
        # Do we have this day already?
        r = @store.where 'day': day, 'month': @attributes.month, 'year': @attributes.year
        if r.length is 0
            # Store.
            day = new Day { 'day': day, 'month': @attributes.month, 'year': @attributes.year }
            @store.push day, 'silent': true
        else
            day = r.pop() # poop it...

        # Local.
        days = @.get('days')
        days.push day
        @.unset 'days', 'silent': true
        @.set 'days': days