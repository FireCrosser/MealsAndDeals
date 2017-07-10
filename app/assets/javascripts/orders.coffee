weekdays = {"monday": {}, "tuesday": {},
"wednesday": {}, "thursday": {}, "friday": {}}
order = {}

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

loadCoursesData = (pane, date, weekday) ->
  localDate = new Date(date)
  if (weekdays[weekday] == undefined || $.isEmptyObject(weekdays[weekday]))
    coursesWrapper = $('<div></div').appendTo pane
    coursesWrapper.attr class: 'col-md-10 col-md-offset-1 courses-wrapper'
    if localDate.getTime() == todayDate.getTime()
      actionButtonWrapper = $("<div></div>")
      actionButtonWrapper.attr class: 'action-button-wrapper'
      actionButton = $(".action-button").clone()
      $(actionButton).css display: "initial"
      actionButton.appendTo actionButtonWrapper
      actionButtonWrapper.appendTo coursesWrapper
    $.get '/courses',
      date: getFormattedDate(localDate, "%Y-%M-%D"), 
      (data) ->
        weekdays[weekday] = data
        if data.length == 0
          coursesWrapper.append "No courses now"
        else
          for key, value of data
            courseType = $("<div></div>")
            courseType.attr class: 'course-type'
            courseType.data "course-type-id": key 
            courseType.data "toggle": "modal"
            courseType.data "target": "#courses-modal"
            courseTypeName = $("<h3></h3>")
            courseTypeName.attr class: 'course-type-name' 
            courseTypeName.text value.name
            courseAmount = $("<h5></h5>")
            courseAmount.attr class: 'course-type-amount' 
            courseAmount.text "Amount: " + value.courses.length
            courseTypeName.appendTo courseType
            courseAmount.appendTo courseType
            if localDate.getTime() == todayDate.getTime()
              addCourseWrapper = $("<div></div>")
              addCourseWrapper.attr class: 'add-course-wrapper'
              addCourseButton = $("<a></a>")
              addCourseButton.attr type: "button"
              addCourseButton.attr class: 'btn btn-link add-course'
              addCourseButton.text "Add"
              addCourseButton.data "toggle": "modal"
              addCourseButton.data "target": "#add-course-modal"
              addCourseButton.appendTo addCourseWrapper
              addCourseWrapper.appendTo courseType
            courseType.appendTo coursesWrapper

$ ->
  tabs = $("#weekday-tabs")
  for day, data of weekdays
    weekdayTab = $("<li></li>")
    weekdayTab.attr role: "presentation"
    weekdayTab.attr class: "weekday-tab"
    if currentWeekDay.getTime() == todayDate.getTime()
      weekdayTab.addClass "active" 
    dayLink = $("<a></a>")
    dayLink.attr role: "tab"
    dayLink.attr "data-toggle": "tab"
    dayLink.attr "data-date": currentWeekDay
    dayLink.attr "data-weekday": day
    dayLink.attr href: "#" + day.toLowerCase()
    dayLink.text day.charAt(0).toUpperCase() + day.slice(1) + ' ' + getFormattedDate(currentWeekDay, "%D.%M.%Y")
    weekdayTab.append(dayLink)
    tabs.append(weekdayTab)

    weekdayPane = $("<div></div>")
    weekdayPane.attr class: "tab-pane fade in weekday-pane"
    if currentWeekDay.getTime() == todayDate.getTime()
      weekdayPane.addClass "active" 
      loadCoursesData(weekdayPane, todayDate, day)
    weekdayPane.attr role: "tabpanel"
    weekdayPane.attr id: day
    weekdayPane.data "weekday": day
    $("#weekday-panes").append(weekdayPane)

    currentWeekDay.setDate(currentWeekDay.getDate() + 1)

  if todayWeekday > 4
    firstTab = $(".weekday-tab").first()
    firstTabLink = firstTab.find("a").first()
    paneId = firstTabLink.attr "href"
    pane = $('#weekday-panes div' + paneId)
    date = firstTabLink.data "date"
    day = firstTabLink.data "weekday"
    loadCoursesData(pane, date, day)
    firstTab.addClass "active"
    $(".weekday-pane:first").addClass "active"

  $('#weekday-tabs a[data-toggle="tab"]').on "show.bs.tab", (event) ->
    target = $(event.target)[0]
    date = $(target).data "date"
    day = $(target).data "weekday"
    paneId = $(target).attr "href"
    pane = $('#weekday-panes div' + paneId)
    loadCoursesData(pane, date, day)
