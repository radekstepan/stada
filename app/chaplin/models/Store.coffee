Chaplin = require 'chaplin'

Day = require 'chaplin/models/Day'

module.exports = class Store extends Chaplin.Collection

    model: Day

    # Init the maximum...
    max: 0

    initialize: (opts...) ->
        super

        # When init all server days, calculate the max and bands.
        @updateActivePoints(data.activities) for data in opts[0]

    # Reduce the points of a day.
    updateActivePoints: (activities) ->
        # Local maximum.
        max = _.reduce(activities, ( (a, b) -> a += b.points ), 0)
        # Is it global?
        if max > @max
            @max = max
            @band = @max / 6