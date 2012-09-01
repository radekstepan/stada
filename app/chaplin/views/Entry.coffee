Chaplin = require 'chaplin'

Mediator = require 'chaplin/core/Mediator'

module.exports = class Entry extends Chaplin.View

    container:       '#entry'
    containerMethod: 'html'

    # Number of activities we have.
    activity: 0

    getTemplateFunction: -> require 'chaplin/templates/entry'

    getTemplateData: ->
        date = new Date [@model.get('year'), @model.get('month'), @model.get('day')].join('-')

        out = @model.toJSON()
        out.relative = date.time_ago_in_words_with_parsing()
        out

    initialize: ->
        super

        Mediator.subscribe 'changeEntry', (@model) => @render()

    afterRender: ->
        super

        @delegate 'click', '.moar', @newActivity
        @delegate 'click', '.save', @save

        # Render activites that we hold.
        for activity in @model.get 'activities'
            activity.key = @activity++
            $(@el).find('.activities').append require('chaplin/templates/entry_activity') activity

    newActivity: =>
        $(@el).find('.activities').append require('chaplin/templates/entry_activity') 'key': @activity++

    save: =>
        # Serialize form fields.
        attr = {}
        for object in $(@el).find('form').serializeArray()
            attr[object.name] = object.value

        # Update the model, reset the activities as we will re-create them anew.
        @model.set { 'notes': attr.notes, 'activities': [] }, { 'silent': true }
        done = false ; i = 0
        while not done
            if attr["activity-#{i}"]?
                activities = @model.get('activities')
                activities.push 'text': attr["activity-#{i}"], 'points': parseInt(attr["points-#{i}"])
                @model.unset 'activities', { 'silent': true }
                @model.set 'activities': activities
                i++
            else done = true

        # Sync the model.
        @model.save()