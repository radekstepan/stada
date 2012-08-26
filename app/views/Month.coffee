Chaplin = require 'chaplin'

module.exports = class MonthView extends Chaplin.View

    tagName: 'li'

    getTemplateFunction: -> require 'templates/month'