Chaplin = require 'chaplin'

Mediator = require 'chaplin/core/Mediator'

module.exports = class Entry extends Chaplin.View

    container:       '#entry'
    containerMethod: 'html'

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

        # Number of activities we have.
        @activity = 0

        @delegate 'click', '.moar', @newActivity
        @delegate 'click', '.save', @save

        # Render activites that we hold.
        for activity in @model.get 'activities'
            activity.key = @activity++
            $(@el).find('.activities').append require('chaplin/templates/entry_activity') activity

        # Custom Foundation3 form.
        $(@el).foundationCustomForms()

    newActivity: =>
        $(@el).find('.activities').append require('chaplin/templates/entry_activity') 'key': @activity++
        # Custom Foundation3 form.
        $(@el).foundationCustomForms()

    save: =>
        # Serialize form fields.
        attr = {}
        for object in $(@el).find('form').serializeArray()
            attr[object.name] = object.value

        # Update the model, reset the activities as we will re-create them anew.
        @model.set { 'notes': attr.notes, 'activities': [] }, { 'silent': true }
        done = false ; i = 0
        while not done
            # Only save activities that have some text to them...
            if attr["activity-#{i}"]? and attr["activity-#{i}"].length isnt 0
                activities = @model.get('activities')
                activities.push 'text': attr["activity-#{i}"], 'points': parseInt(attr["points-#{i}"])
                @model.unset 'activities', { 'silent': true }
                @model.set 'activities': activities, { 'silent': true }
                i++
            else done = true

        # Sync the model.
        @model.save()

        # Fire one change event for all of our editing...
        @model.change()

        # Remove us.
        $(@el).remove()