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
            $(@el).addClass 'day'
            # How much activity do we have?
            if @model.get('activities').length isnt 0 then $(@el).addClass 'level6'

            # Register click handler.
            @delegate 'click', @editEntry

    editEntry: ->
        console.log @model
        Mediator.publish 'changeEntry', @model