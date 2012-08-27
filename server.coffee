#!/usr/bin/env coffee

flatiron = require 'flatiron'
connect  = require 'connect'
mongodb  = require 'mongodb'

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

    # MongoDB.
    db = null
    # Add a collection plugin.
    app.use
        name: "mongodb"
        attach: (options) ->
            app.db = (done) ->
                collection = (done) ->
                    db.collection 'entries', (err, coll) ->
                        throw err if err
                        done coll

                unless db?
                    mongodb.Db.connect 'mongodb://localhost:27017/stada', (err, connection) ->
                        db = connection
                        throw err if err
                        collection done
                else
                    collection done

    # API.
    app.router.path "/entries.json", ->
        @get ->
            # Give me all public documents.
            app.db (collection) =>                
                collection.find({}, 'sort': 'url').toArray (err, docs) =>
                    throw err if err

                    @res.writeHead 200, "content-type": "application/json"
                    @res.write JSON.stringify docs
                    @res.end()         