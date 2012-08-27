Chaplin = require 'chaplin'

Month = require 'models/Month'

module.exports = class Year extends Chaplin.Collection

    model: Month

    constructor: ->
        super
        
        # Where do we start?
        now = new Date()
        year = now.getFullYear()
        currentMonth = now.getMonth() + 1
        month = currentMonth - 1

        # Leading month.
        @.push new Month 'month': currentMonth, 'year': year

        # Move month by month.
        while month isnt currentMonth
            @.push new Month 'month': month, 'year': year

            # Previous month.
            month -= 1
            # New year shift?
            if month is 0 then ( month = 12 ; year -= 1 )