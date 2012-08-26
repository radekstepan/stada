Chaplin = require 'chaplin'

Month = require 'models/Month'

module.exports = class YearCollection extends Chaplin.Collection

    model: Month

    constructor: ->
        super
        
        # Where do we start?
        now = new Date()
        year = now.getFullYear()
        currentMonth = now.getMonth() + 1
        month = currentMonth - 11

        # Shift in the past year.
        if month < 1 then ( month += 12 ; year -= 1 )

        # Move month by month.
        while month isnt currentMonth
            @.push new Month 'month': month, 'year': year

            # Next month.
            month += 1
            # New year shift?
            if month > 12 then ( month = 1 ; year += 1 )

        # And the current month.
        @.push new Month 'month': month, 'year': year