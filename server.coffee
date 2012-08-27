#!/usr/bin/env coffee

flatiron = require 'flatiron'
connect  = require 'connect'

# Export for Brunch.
exports.startServer = (port, dir) ->
    app = flatiron.app
    app.use flatiron.plugins.http,
        'before': [
            # Have a nice favicon.
            connect.favicon()
            # Static file serving.
            connect.static "./#{dir}"
        ]

    app.start port, (err) ->
        throw err if err