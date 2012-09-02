Chaplin = require 'chaplin'

Mediator = require 'chaplin/core/Mediator'

TagView = require 'chaplin/views/Tag'

module.exports = class TagsCollectionView extends Chaplin.CollectionView

    tagName:           'ul'
    container:         '#tags'
    containerMethod:   'append'
    autoRender:        false # otherwise we render twice and lose bindings!
    animationDuration: 0

    getView: (tag) -> new TagView 'model': tag

    getTemplateFunction: -> require 'chaplin/templates/tags'

    afterRender: ->
        super

        # Events on all tags.
        @delegate 'click', '.clear', @clear
        @delegate 'click', '.select', @select

    clear: ->
        console.log 'clear'

    select: ->
        console.log 'select'