Chaplin = require 'chaplin'

BodyView = require 'chaplin/views/Body'

Year = require 'chaplin/models/Year'
YearCollectionView = require 'chaplin/views/YearCollection'

module.exports = class DashboardController extends Chaplin.Controller

    historyURL: (params) -> ''

    index: (params) ->
        new BodyView()

        # Create a new YearCollection that holds the current and the past 11 months.
        new YearCollectionView 'collection': new Year()