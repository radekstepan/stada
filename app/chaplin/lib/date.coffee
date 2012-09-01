# Takes the format of 'Jan 15, 2007 15:45:00 GMT' and converts it to a relative time
# Ruby strftime: %b %d, %Y %H:%M:%S GMT
Date::time_ago_in_words_with_parsing = ->
    date = new Date
    date.setTime @
    @time_ago_in_words date

Date::time_ago_in_words = (from) ->
    @distance_of_time_in_words new Date, from

Date::distance_of_time_in_words = (to, from) ->
    distance_in_minutes = Math.floor (to - from) / 60000

    if distance_in_minutes < 1440 then 'today'
    else if distance_in_minutes < 2880 then 'yesterday'
    else if distance_in_minutes < 43200 then Math.floor(distance_in_minutes / 1440) + ' days ago'
    else if distance_in_minutes < 86400 then 'about a month ago'
    else if distance_in_minutes < 525960 then Math.floor(distance_in_minutes / 43200) + ' months ago'
    else if distance_in_minutes < 1051199 then 'about a year ago'
    else 'over ' + Math.floor(distance_in_minutes / 525960) + ' years ago'