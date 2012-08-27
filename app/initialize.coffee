Staða = require 'core/Application'

Store = require 'models/Store'

$ ->
    window.Store = new Store()

    # Initialize the Application.
    window.App = new Staða()
    window.App.initialize()