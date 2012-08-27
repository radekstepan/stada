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
        @delegate 'click', '.save', @save

        # Render activites that we hold.
        for activity in @model.get 'activities'
            activity.key = @activity++
            $(@el).find('.activities').append require('templates/entry_activity') activity

    newActivity: =>
        $(@el).find('.activities').append require('templates/entry_activity') 'key': @activity++

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
                @model.set 'activities': activities, { 'silent': true }
                i++
            else done = true
        
        # Sync the model.
        @model.save()