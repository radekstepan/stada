#!/usr/bin/env coffee

flatiron = require 'flatiron'
connect  = require 'connect'
sqlite3  = require('sqlite3').verbose()

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

    # SQLite3.   
    db = null
    app.use
        name: "sqlite"
        attach: (options) ->
            app.db = (done) ->
                app.log.info "Use Sqlite"
                unless db?
                    app.log.info "New db"
                    db = new sqlite3.Database './db.sqlite3'
                    db.on 'error', (err) -> throw err
                    db.on 'open', ->
                        app.log.info "DB open"
                        #db.run 'CREATE TABLE "entries" ("text" TEXT, "key" INTEGER PRIMARY KEY ASC AUTOINCREMENT)'
                        done()
                else
                    app.log.info "Reuse old"
                    done()

    # API.
    app.router.path "/entries.json", ->
        @get ->
            # Give me all public documents.
            app.db =>
                app.log.info "Querying"

                db.all 'SELECT * FROM entries', (err, data) =>
                    throw err if err

                    @res.writeHead 200, "content-type": "application/json"
                    @res.write JSON.stringify data
                    @res.end()            