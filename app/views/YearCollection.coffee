Chaplin = require 'chaplin'

MonthView = require 'views/Month'

module.exports = class YearCollectionView extends Chaplin.CollectionView

    tagName:         'ul'
    container:       '#year'
    containerMethod: 'html'
    autoRender:      true

    getView: (month) -> new MonthView 'model': month