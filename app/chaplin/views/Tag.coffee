Chaplin = require 'chaplin'

Mediator = require 'chaplin/core/Mediator'

module.exports = class TagView extends Chaplin.View

    tagName:   'li'

    getTemplateFunction: -> require 'chaplin/templates/tag'

    afterRender: ->
        super

        $(@el).attr 'data-view', @cid

        # Add the tag level.
        lvl = Math.ceil @model.get('count') / @model.collection.band
        $(@el).addClass "tag level#{lvl}"

        # Init Foundation3 form theme after a slight delay...
        setTimeout ( => $(@el).foundationCustomForms() ), 0

        # Event.
        @delegate 'click', @toggle

    # Toggle the state of this tag.
    toggle: ->
        @model.set 'selected': status = !@model.get('selected')

        # Toggle the fake and actual checkbox...
        $(@el).find('input[type="checkbox"]').attr 'checked': status
        $(@el).find('span.checkbox').toggleClass 'checked'

        # Say to main View to re-render.
        Mediator.publish 'renderMonths'

        # Do not propagate further.
        false