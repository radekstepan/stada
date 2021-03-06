#!/usr/bin/env coffee

flatiron = require 'flatiron'
connect  = require 'connect'
mongodb  = require 'mongodb'
fs       = require 'fs'

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
        console.log "Service started on port #{app.server.address().port}"
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
    app.router.path "/api/reset", ->
        @get ->
            app.db (collection) =>
                collection.remove {}, (err) =>
                    throw err if err

                    # End.
                    @res.writeHead 200
                    @res.end()

    app.router.path "/api/load", ->
        @get ->
            fs.readFile './dump/entries.json', (err, data) =>
                throw err if err
                
                entries = ( (delete entry._id ; entry) for entry in JSON.parse data )

                app.db (collection) =>
                    collection.insert entries, { 'safe': true }, (err) =>
                        throw err if err

                        @res.writeHead 200
                        @res.write 'Data loaded'
                        @res.end()                        


    app.router.path "/api/days", ->
        @get ->
            # Give me all public documents.
            app.db (collection) =>
                collection.find({}, 'sort': 'url').toArray (err, docs) =>
                    throw err if err

                    @res.writeHead 200, "content-type": "application/json"
                    @res.write JSON.stringify docs
                    @res.end()

    app.router.path "/api/day/:year/:month/:day", ->
        @post (year, month, day) ->
            entry = @req.body
            
            # Remove _id.
            delete entry._id

            app.db (collection) =>
                collection.findAndModify
                    'year':  parseInt(year)
                    'month': parseInt(month)
                    'day':   parseInt(day)
                , [], entry, 'upsert': true, (err, object) =>
                    throw err if err

                    # Dump the DB.
                    collection.find({}, 'sort': 'url').toArray (err, docs) =>
                        throw err if err
                        
                        # Open file for writing.
                        fs.open "./dump/entries.json", 'w', 0o0666, (err, id) =>
                            throw err if err
                            
                            # Write file.
                            fs.write id, JSON.stringify(docs, null, "\t"), null, "utf8"

                            # End.
                            @res.writeHead 200
                            @res.end()