Chaplin = require 'chaplin'

Mediator = require 'chaplin/core/Mediator'

module.exports = class DayView extends Chaplin.View

    tagName:         'td'
    autoRender:      true
    containerMethod: 'append'

    getTemplateFunction: -> require 'chaplin/templates/day'

    initialize: ->
        super

        # If someone is editing a Day and it is not this Day, then remove the selected attr.
        Mediator.subscribe 'changeEntry', ( (model) -> if model isnt @model then $(@el).removeClass('selected') ), @

    afterRender: ->
        super

        $(@el).attr 'data-view', @cid

        # Are we not a filler?
        if @model?

            # Did we change the Model?
            @modelBind 'change', ->
                # Update the Store max?
                @model.collection.updateMaxPoints()
                # Finally, re-render all months.
                Mediator.publish 'renderMonths'
            , @

            $(@el).addClass 'day'
            # How much activity did we diddly do?
            if @model.get('activities').length isnt 0
                lvl = Math.ceil _.reduce(@model.get('activities'), ( (a, b) -> a += b.points ), 0) / @model.collection.band
                $(@el).addClass "level#{lvl}"
            else
                # Did we at least save some notes?
                if @model.get('notes').length is 0 then $(@el).addClass 'empty'

            # Register click handler.
            @delegate 'click', @editEntry

    editEntry: ->
        $(@el).addClass 'selected'
        Mediator.publish 'changeEntry', @model