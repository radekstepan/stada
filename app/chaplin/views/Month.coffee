Chaplin = require 'chaplin'

Mediator = require 'chaplin/core/Mediator'

DayView = require 'chaplin/views/Day'

module.exports = class MonthView extends Chaplin.View

    tagName:    'li'

    getTemplateFunction: -> require 'chaplin/templates/month'

    initialize: ->
        super

        # When days tell us to change, we change...
        Mediator.subscribe 'renderMonths', @render

    afterRender: ->
        super

        # Clear any previous days.
        view.dispose() for view in @subviews

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