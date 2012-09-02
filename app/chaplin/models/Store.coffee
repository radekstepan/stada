Chaplin = require 'chaplin'

Day = require 'chaplin/models/Day'
Tags = require 'chaplin/models/Tags'

module.exports = class Store extends Chaplin.Collection

    model: Day

    # Tags Collection.
    tags: null

    initialize: (data) ->
        super

        # Update Tags when we change Days.
        @on 'change', ( (day) -> @tags.addTags day ), @

        # Init new Tags Collection.
        @tags = new Tags()
        @tags.addTags data

        # When init all server days, calculate the max and bands.
        @updateMaxPoints data

    # Recalculate the global maximum of points in all models.
    updateMaxPoints: (data = @models) ->
        @max = -Infinity

        # A more verbose, but easier to debug...
        for day in data
            # Models or Objects?
            if day.constructor.name is 'Day'
                activs = day.get 'activities'
            else
                activs = day.activities
            # Actual reduce.
            max = _.reduce activs, ( (a, b) -> a += b.points ), 0
            if max > @max then @band = (@max = max) / 6

    selectDay: (model) -> model.set 'selected': true, { 'silent': true }