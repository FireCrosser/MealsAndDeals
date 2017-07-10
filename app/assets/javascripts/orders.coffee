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

loadOrdersData = (pane, date, weekday) ->
  localDate = new Date(date)
  if (weekdays[weekday] == undefined || $.isEmptyObject(weekdays[weekday]))
    ordersWrapper = $('<div></div').appendTo pane
    ordersWrapper.attr class: 'col-md-10 col-md-offset-1 orders-wrapper'
    ordersPanel = $('.orders').first()
    panelId = 0
    $.get '/orders',
      date: getFormattedDate(localDate, "%Y-%M-%D"), 
      (data) ->
        console.log data
        weekdays[weekday] = data
        if data.length != 0
          for key, value of data
            user = value.user
            orderPanel = $('#order-panel-sample').clone()
            orderPanel.show()
            panelHeader = $(orderPanel).find(".order-header").first()
            panelHeader.attr "data-target": "#order-panel-content-" + panelId
            panelHeaderText = $(panelHeader).find(".order-header-text").first()
            console.log panelHeader
            panelHeader.text '#' + value.id + ', created at: ' + value.created_at
            panelBody = $(orderPanel).find(".order-body").first()
            panelBody.attr id: "order-panel-content-" + panelId
            tBody = $(panelBody).find("tbody").first()
            lunchCost = 0
            for course in value.courses
              tr = $("<tr></tr>").appendTo tBody
              nameTd = $("<td></td>").appendTo tr
              nameTd.text course.name
              priceTd = $("<td></td>").appendTo tr
              priceTd.text course.price
              typeTd = $("<td></td>").appendTo tr
              typeTd.text course.course_type.name
              lunchCost += course.price
            lunchCostHeader = $("<h5><?h5>").appendTo panelBody
            lunchCostHeader.attr class: "order-cost"
            lunchCostHeader.text "Lunch cost: " + lunchCost
            orderPanel.appendTo ordersPanel
            panelId++

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
      loadOrdersData(weekdayPane, todayDate, day)
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
    loadOrdersData(pane, date, day)
    firstTab.addClass "active"
    $(".weekday-pane:first").addClass "active"

  $('#weekday-tabs a[data-toggle="tab"]').on "show.bs.tab", (event) ->
    target = $(event.target)[0]
    date = $(target).data "date"
    day = $(target).data "weekday"
    paneId = $(target).attr "href"
    pane = $('#weekday-panes div' + paneId)
    loadOrdersData(pane, date, day)
