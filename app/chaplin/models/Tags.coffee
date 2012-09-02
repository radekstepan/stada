Chaplin = require 'chaplin'

Mediator = require 'chaplin/core/Mediator'

Tag = require 'chaplin/models/Tag'

module.exports = class Tags extends Chaplin.Collection

    model: Tag

    # Sort by the text of the tag...
    comparator: (tag) -> tag.get 'text'

    # Individually increase the count or create a new Tag.
    mapTag: (tag) ->
        # Do we already have this tag?
        if (r = @where('text': tag)).length is 1
            # Increase its count.
            (model = r.pop()).set 'count': model.get('count') + 1, { 'silent': true }
        else
            # A new tag.
            @add 'text': tag, { 'silent': true }

    # Parse data for day(s) to derive a unique list of tags.
    addTags: (object) ->
        # Determine the nature of the incoming object.
        if object instanceof Array
            # On initial reset.
            for obj in object when obj.tags? and obj.tags.length isnt 0
                @mapTag(tag) for tag in obj.tags
        else
            # Individual object maybe?
            if object.constructor.name is 'Day'
                @mapTag(tag) for tag in object.get 'tags'

        # Recalculate the max tag count and the band.
        @band = (@max = _.max _.map @models, (model) -> model.get 'count') / 6

        # One change event after we have the new max and bands...
        Mediator.publish 'renderTags'