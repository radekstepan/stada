Chaplin = require 'chaplin'

MonthView = require 'views/Month'

module.exports = class YearCollectionView extends Chaplin.CollectionView

    tagName:           'ul'
    container:         '#calendar'
    containerMethod:   'html'
    autoRender:        true
    animationDuration: 0

    getView: (month) -> new MonthView 'model': month