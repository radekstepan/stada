Chaplin = require 'chaplin'
Layout = require 'core/Layout'
routes = require 'core/routes'

# The application object.
module.exports = class Staða extends Chaplin.Application

    title: 'Staða'

    data: {}

    initialize: ->
        super

        # Initialize core components
        @initDispatcher()
        @initLayout()
        @initMediator()

        # Register all routes and start routing
        @initRouter routes

        # Freeze the application instance to prevent further changes
        Object.freeze? @

    # Override standard layout initializer.
    initLayout: ->
        # Use an application-specific Layout class. Currently this adds
        # no features to the standard Chaplin Layout, it’s an empty placeholder.
        @layout = new Layout {@title}

    # Create additional mediator properties.
    initMediator: ->
        # Create a user property
        Chaplin.mediator.user = null
        # Add additional application-specific properties and methods
        # Seal the mediator
        Chaplin.mediator.seal()