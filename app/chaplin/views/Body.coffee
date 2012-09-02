Chaplin = require 'chaplin'

Mediator = require 'chaplin/core/Mediator'

EntryView = require 'chaplin/views/Entry'
TagsCollectionView = require 'chaplin/views/TagsCollection'

module.exports = class Body extends Chaplin.View

    container:       'body'
    containerMethod: 'html'
    autoRender:      true

    getTemplateFunction: -> require 'chaplin/templates/body'

    store: window.Store

    afterRender: ->
        super

        @delegate 'click', '#today', @todayEntry

        # Edit/View and entry Day.
        @entry = new EntryView()

        # Sidebar Tag filtering.
        Mediator.subscribe 'renderTags', @renderFilter, @
        Mediator.publish 'renderTags'

    # Sidebar Tag filtering.
    renderFilter: ->
        @filter?.dispose()
        @filter = new TagsCollectionView 'collection': @store.tags

    todayEntry: ->
        # Find the model corresponding to today.
        now = new Date()
        models = @store.where
            'year':  now.getFullYear()
            'month': now.getMonth() + 1
            'day':   now.getDate()

        Mediator.publish 'changeEntry', models.pop()