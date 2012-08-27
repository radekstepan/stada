Chaplin = require 'chaplin'

DayView = require 'views/Day'

module.exports = class MonthView extends Chaplin.View

    tagName: 'li'

    getTemplateFunction: -> require 'templates/month'

    afterRender: ->
        super

        $(@el).addClass 'month'

        # Render the days.       
        week = @appendWeek()

        days = @model.get 'days'

        # Leading days in the previous month...
        for i in [1...days[0].get('dayOfWeek')]
            week.append (new DayView()).render().el

        # Append the actual days.
        for model in days
            day = new DayView 'model': model
            week.append day.render().el
            # Week shift?
            if i % 7 is 0 then week = @appendWeek()
            i++

    appendWeek: ->
        table = $(@el).find('table tbody')
        table.append require('templates/week')()
        table.find('tr:last-child')