Chaplin = require 'chaplin'

Mediator = require 'chaplin/core/Mediator'

TagView = require 'chaplin/views/Tag'

module.exports = class TagsCollectionView extends Chaplin.CollectionView

    tagName:           'ul'
    container:         '#tags'
    containerMethod:   'html'
    autoRender:        false # otherwise we render twice and lose bindings!
    animationDuration: 0

    getView: (tag) -> new TagView 'model': tag