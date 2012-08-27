Chaplin = require 'chaplin'

module.exports = class Entry extends Chaplin.View

    container:       '#entry'
    containerMethod: 'html'

    # Number of activities we have.
    activity: 0

    getTemplateFunction: -> require 'templates/entry'

    getTemplateData: ->
        out = @model.toJSON()
        out.relative = moment([@model.get('year'), @model.get('month'), @model.get('day')].join('-'), 'YYYY-MM-DD').fromNow()
        out

    initialize: ->
        super

        Chaplin.mediator.subscribe 'changeEntry', (@model) => @render()

    afterRender: ->
        super

        @delegate 'click', '.moar', @newActivity

    newActivity: =>
        $(@el).find('.activities').append require('templates/entry_activity') 'key': @activity++