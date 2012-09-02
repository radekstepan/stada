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

        # When tags get (de-)selected, recalculate the max points for activities.
        # Use convoluted call to not pass Tag on...
        @tags.on 'change:selected', ( -> @updateMaxPoints() ), @

        # When init all server days, calculate the max and bands.
        @updateMaxPoints data, true

    # Check if Tag is selected or not in our inner Collection.
    isTagSelected: (tag) -> (@tags.where 'text': tag, 'selected': true).length isnt 0

    # Recalculate the global maximum of points in all models.
    updateMaxPoints: (data, init = false) ->
        data = @models unless init
        @max = -Infinity

        # A more verbose, but easier to debug...
        for day in data
            # Models or Objects?
            if day.constructor.name is 'Day'
                activs = day.get 'activities'
            else
                activs = day.activities
            
            # Get the local max.
            max = 0
            max += activ.points for activ in activs when @isTagSelected activ.tag
            if max > @max then @band = (@max = max) / 6

        assert @max >= 0, "Max is set to #{@max}"

    selectDay: (model) -> model.set 'selected': true, { 'silent': true }