Staða = require 'core/Application'
Store = require 'models/Store'

root = this

$ ->
    # Bootstrap all the day entries.
    $.getJSON '/api/days', (data) ->
        root.Store = new Store data

        # Initialize the Application.
        root.App = new Staða()
        root.App.initialize()