Chaplin = require 'chaplin'

module.exports = class Month extends Chaplin.View

    tagName: 'li'

    getTemplateFunction: -> require 'templates/month'