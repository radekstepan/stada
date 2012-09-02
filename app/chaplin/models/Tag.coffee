Chaplin = require 'chaplin'

module.exports = class Tag extends Chaplin.Model

    defaults:
        count: 1 # if you create me, you obviously start with one occurence of this tag