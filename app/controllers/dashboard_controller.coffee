Chaplin = require 'chaplin'

module.exports = class DashboardController extends Chaplin.Controller

    historyURL: (params) -> ''

    index: (params) -> console.log 'index'