Chaplin = require 'chaplin'

module.exports = class DayView extends Chaplin.View

    tagName: 'td'

    getTemplateFunction: -> require 'templates/day'

    afterRender: ->
        if @model? then $(@el).addClass 'day'