Chaplin = require 'chaplin'

Mediator = require 'chaplin/core/Mediator'

module.exports = class DayView extends Chaplin.View

    tagName:         'td'
    autoRender:      true
    containerMethod: 'append'

    getTemplateFunction: -> require 'chaplin/templates/day'

    afterRender: ->
        super

        $(@el).attr 'data-view', @cid

        # Are we not a filler?
        if @model?

            # If we change activities of a Day...
            @modelBind 'change:activities', ->
                console.log 'fire'
                # Update the Store max?
                @model.collection.updateActivePoints @model.get('activities')
                # Finally, re-render all months.
                Mediator.publish 'renderMonths'
            , @

            $(@el).addClass 'day'
            # How much activity did we diddly do?
            if @model.get('activities').length isnt 0
                lvl = Math.ceil _.reduce(@model.get('activities'), ( (a, b) -> a += b.points ), 0) / @model.collection.band
                $(@el).addClass "level#{lvl}"

            # Register click handler.
            @delegate 'click', @editEntry

    editEntry: -> Mediator.publish 'changeEntry', @model