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
            
            # How much activity did we diddly do? If we have deselected all then band will be 0!
            if @model.get('activities').length isnt 0 and @model.collection.band isnt 0
                pts = 0
                pts += activ.points for activ in @model.get('activities') when @model.collection.isTagSelected(activ.tag)
                
                # Ceil and assign band.
                lvl = Math.ceil pts / @model.collection.band

                # Check it is within the range.
                assert lvl in [0...7], "Level is set to `#{lvl}`"
                assert @model.collection.band?, 'Band is not set'

                # Finally set it if we got some points...
                if pts isnt 0
                    $(@el).addClass "level#{lvl}"
                else
                    # No notes too?
                    if @model.get('notes').length is 0 then $(@el).addClass 'empty'

            else
                # Did we at least save some notes?
                if @model.get('notes').length is 0 then $(@el).addClass 'empty'

            # Register click handler.
            @delegate 'click', @editEntry

    editEntry: ->
        $(@el).addClass 'selected'
        Mediator.publish 'changeEntry', @model