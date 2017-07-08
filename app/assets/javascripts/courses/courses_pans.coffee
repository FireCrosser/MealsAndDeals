$ ->
  $('#weekday-tabs a[data-toggle="tab"]').on "shown.bs.tab", (event) ->
    target = $(event.target)
    date = target.attr "data-date"
    paneId = target.attr "href"
    pane = $('#weekday-panes div' + paneId)
    if (pane.find ".courses-wrapper").length == 0
      coursesWrapper = $('<div></div').appendTo pane
      coursesWrapper.attr class: 'courses-wrapper'
      $.get '/courses',
        date: date,
        (data) ->
          text = $('<h3></h3>').appendTo coursesWrapper
          if data.length == 0
            text.append "No courses now"
          else
            text.append data[0].name

