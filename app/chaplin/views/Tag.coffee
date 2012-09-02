Chaplin = require 'chaplin'

module.exports = class TagView extends Chaplin.View

    tagName:    'li'

    getTemplateFunction: -> require 'chaplin/templates/tag'

    afterRender: ->
        super

        $(@el).attr 'data-view', @cid

        # Add the tag level.
        lvl = Math.ceil @model.get('count') / @model.collection.band
        $(@el).addClass "tag level#{lvl}"