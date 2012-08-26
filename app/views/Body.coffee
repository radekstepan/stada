Chaplin = require 'chaplin'

module.exports = class Body extends Chaplin.View

    container:       'body'
    containerMethod: 'html'
    autoRender:      true

    getTemplateFunction: -> require 'templates/body'