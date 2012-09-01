Chaplin = require 'chaplin'

Mediator = require 'chaplin/core/Mediator'

EntryView = require 'chaplin/views/Entry'

module.exports = class Body extends Chaplin.View

    container:       'body'
    containerMethod: 'html'
    autoRender:      true

    getTemplateFunction: -> require 'chaplin/templates/body'

    store: window.Store

    afterRender: ->
        super

        @delegate 'click', '#today', @todayEntry

        @entry = new EntryView()

    todayEntry: ->
        # Find the model corresponding to today.
        now = new Date()
        models = @store.where
            'year':  now.getFullYear()
            'month': now.getMonth() + 1
            'day':   now.getDate()

        Mediator.publish 'changeEntry', models.pop()