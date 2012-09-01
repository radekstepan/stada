Chaplin = require 'chaplin'

require 'chaplin/lib/assert' # assertions

require 'chaplin/core/Mediator' # our mediator

Layout = require 'chaplin/core/Layout'
routes = require 'chaplin/core/routes'

# The application object.
module.exports = class Staða extends Chaplin.Application

    title: 'Staða'

    data: {}

    initialize: ->
        super

        # Initialize core components
        @initDispatcher
            'controllerPath':   'chaplin/controllers/'
            'controllerSuffix': ''
        
        @initLayout()

        # Register all routes and start routing
        @initRouter routes

        # Freeze the application instance to prevent further changes
        Object.freeze? @

    # Override standard layout initializer.
    initLayout: ->
        # Use an application-specific Layout class. Currently this adds
        # no features to the standard Chaplin Layout, it’s an empty placeholder.
        @layout = new Layout {@title}