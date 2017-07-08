weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
todayDate = new Date()
todayWeekday = (todayDate.getDay() || 7) - 1 
weekStart = new Date(todayDate)
if todayWeekday <= 4
  weekStart.setDate(weekStart.getDate() - todayWeekday)
  console.log weekStart
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
    weekdayPane.attr role: "tabpanel"
    weekdayPane.attr id: day.toLowerCase()
    weekdayPane.append("<h3>" + day + "</h3>")
    $("#weekday-panes").append(weekdayPane)

    currentWeekDay.setDate(currentWeekDay.getDate() + 1)
        
  if todayWeekday > 4
    $(".weekday-tab:first").addClass "active"
    $(".weekday-pane:first").addClass "active"

