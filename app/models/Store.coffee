Chaplin = require 'chaplin'

Day = require 'models/Day'

module.exports = class Store extends Chaplin.Collection

    model: Day