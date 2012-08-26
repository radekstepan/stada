Chaplin = require 'chaplin'

BodyView = require 'views/Body'

YearCollection = require 'models/YearCollection'
YearCollectionView = require 'views/YearCollection'

module.exports = class DashboardController extends Chaplin.Controller

    historyURL: (params) -> ''

    index: (params) ->
        new BodyView()

        # Create a new YearCollection that holds the current and the past 11 months.
        new YearCollectionView 'collection': new YearCollection()