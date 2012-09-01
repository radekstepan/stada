Chaplin = require 'chaplin'

DayView = require 'chaplin/views/Day'

module.exports = class MonthView extends Chaplin.View

    tagName:    'li'
    autoRender: true

    getTemplateFunction: -> require 'chaplin/templates/month'

    afterRender: ->
        super

        $(@el).attr 'data-view', @cid

        $(@el).addClass 'month'

        # Render the days.       
        week = @appendWeek()

        days = @model.get 'days'

        # Leading days in the previous month...
        for i in [1...days[0].get('dayOfWeek')]
            week.append (new DayView()).render().el

        # Append the actual days.
        for model in days
            @subviews.push new DayView 'model': model, 'container': week
            # Week shift?
            if i % 7 is 0 then week = @appendWeek()
            i++

    appendWeek: ->
        table = $(@el).find('table tbody')
        table.append require('chaplin/templates/week')()
        table.find('tr:last-child')