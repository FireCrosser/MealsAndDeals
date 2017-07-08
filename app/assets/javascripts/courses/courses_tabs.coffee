weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
todayDate = new Date()
todayWeekday = (todayDate.getDay() || 7) - 1 
weekStart = new Date(todayDate)
if todayWeekday <= 4
  weekStart.setDate(weekStart.getDate() - todayWeekday)
else
  weekStart.setDate(weekStart.getDate() + 7 - todayWeekday)
currentWeekDay = new Date(weekStart)


getFormattedDate = (date, format) ->
  day = date.getDate()
  month = date.getMonth() + 1
  year = date.getFullYear()
  if day < 10
    day = "0" + day
  if month < 10
    month = "0" + month
  return format
    .replace("%D", day)
    .replace("%M", month)
    .replace("%Y", year)

loadCoursesData = (pane, date) ->
  if (pane.find ".courses-wrapper").length == 0
    coursesWrapper = $('<div></div').appendTo pane
    coursesWrapper.attr class: 'col-md-10 col-md-offset-1 courses-wrapper'
    $.get '/courses',
      date: date,
      (data) ->
        if data.length == 0
          coursesWrapper.append "No courses now"
        else
          for key, value of data
            courseType = $("<div></div>")
            courseType.attr class: 'course-type'
            courseType.attr "data-toggle": "modal"
            courseType.attr "data-target": "#coursesModal"
            courseTypeName = $("<h3></h3>")
            courseTypeName.text value.name
            courseAmount = $("<h5></h5>")
            courseAmount.text "Amount: " + value.courses.length
            courseTypeName.appendTo courseType
            courseAmount.appendTo courseType
            courseType.appendTo coursesWrapper


$ ->
  tabs = $("#weekday-tabs")
  for day in weekdays
    weekdayTab = $("<li></li>")
    weekdayTab.attr role: "presentation"
    weekdayTab.attr class: "weekday-tab"
    if currentWeekDay.getTime() == todayDate.getTime()
      weekdayTab.addClass "active" 
    dayLink = $("<a></a>")
    dayLink.attr role: "tab"
    dayLink.attr "data-toggle": "tab"
    dayLink.attr "data-date": getFormattedDate(currentWeekDay, "%Y-%M-%D")
    dayLink.attr href: "#" + day.toLowerCase()
    dayLink.text day + ' ' + getFormattedDate(currentWeekDay, "%D.%M.%Y")
    weekdayTab.append(dayLink)
    tabs.append(weekdayTab)

    weekdayPane = $("<div></div>")
    weekdayPane.attr class: "tab-pane fade in weekday-pane"
    if currentWeekDay.getTime() == todayDate.getTime()
      weekdayPane.addClass "active" 
      loadCoursesData(weekdayPane, todayDate)
    weekdayPane.attr role: "tabpanel"
    weekdayPane.attr id: day.toLowerCase()
    $("#weekday-panes").append(weekdayPane)

    currentWeekDay.setDate(currentWeekDay.getDate() + 1)
        
  if todayWeekday > 4
    firstTab = $(".weekday-tab").first()
    firstTabLink = firstTab.find("a").first()
    paneId = firstTabLink.attr "href"
    pane = $('#weekday-panes div' + paneId)
    date = firstTabLink.attr "data-date"
    loadCoursesData(pane, date)
    firstTab.addClass "active"
    $(".weekday-pane:first").addClass "active"

  $('#weekday-tabs a[data-toggle="tab"]').on "shown.bs.tab", (event) ->
    target = $(event.target)
    date = target.attr "data-date"
    paneId = target.attr "href"
    pane = $('#weekday-panes div' + paneId)
    loadCoursesData(pane, date)
