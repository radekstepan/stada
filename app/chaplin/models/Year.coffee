Chaplin = require 'chaplin'

Month = require 'chaplin/models/Month'

module.exports = class Year extends Chaplin.Collection

    model: Month

    constructor: ->
        super

        # Where do we start?
        now = new Date()
        year = now.getFullYear()
        currentMonth = now.getMonth() + 1 # 1 indexed

        # Leading month.
        @.push new Month 'month': currentMonth, 'year': year

        # Show 11 more months.
        month = currentMonth
        for i in [0...11]
            # Shift down by 1.
            month -= 1
            # New year shift?
            if month is 0 then ( month = 12 ; year -= 1 )

            @.push new Month 'month': month, 'year': year