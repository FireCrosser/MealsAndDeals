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
      $(actionButton).css display: "inline"
      actionButton.appendTo actionButtonWrapper
      actionButtonWrapper.appendTo coursesWrapper
    $.get '/courses',
      date: getFormattedDate(localDate, "%Y-%M-%D"), 
      (data) ->
        weekdays[weekday] = data
        if data.length == 0
          coursesWrapper.append "No scourses now"
        else
          for key, value of data
            courseType = $("<div></div>")
            courseType.attr class: 'course-type'
            courseType.data "course-type-id": value.id 
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
              actionButton2Wrapper = $('.action-button-2-wrapper')
              if actionButton2Wrapper.length != 0
                $(actionButton2Wrapper[0]).clone().css('display', '')
                  .appendTo courseType
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
    dayLink.data "date": currentWeekDay
    dayLink.data "weekday": day
    dayLink.attr href: "#" + day.toLowerCase()
    dayLink.text day.charAt(0).toUpperCase() + day.slice(1) + ' ' + getFormattedDate(currentWeekDay, "%D.%M.%Y")
    weekdayTab.append dayLink
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

  $("#weekday-panes").on "click", ".course-type", (event) ->
    event.stopPropagation()
    courseType = $(event.target).closest(".course-type")[0]
    if event.target.tagName == "A"
      $("#course_course_type_id")
        .attr value: $(courseType).data "course-type-id"
      $("#add-course-modal .modal-title").first().text "Add course to \"" + 
        $(courseType).find(".course-type-name")[0].innerText + "\" group"
      $("#add-course-modal").modal("show")
    else
      modal = $("#courses-modal")

      courseTypeId = $(courseType).data "course-type-id"
      $(modal).data "course-type-id": courseTypeId
      weekday = $(event.target).closest(".weekday-pane").data "weekday"
      courses = weekdays[weekday][courseTypeId - 1].courses
      modalBody = $(modal).find(".modal-body").first()
      for course in courses
        courseDiv = $("<div></dev>")
        courseDiv.attr class: "course-radio row"
        courseDiv.data "id": course.id
        courseImage = $("<img/>")
        courseImage.attr src: course.image.url
        courseImage.addClass "course-image"
        courseDesc = $("<h4></h4>")
        courseDesc.attr class: "course-image"
        courseDesc.text course.name + ", price: " + course.price
        courseImage.appendTo courseDiv
        courseDesc.appendTo courseDiv
        courseDiv.appendTo modalBody
      $(modal).modal("show")

  $("#courses-modal").find(".modal-body")
    .first().on "click", ".course-radio", (event) ->
      target = event.target
      $(target).closest('.modal-body')
        .find(".course-radio").removeClass "course-selected"
      course = target
      courseTypeId = $("#courses-modal").data "course-type-id"
      if target.getClass != 'course-radio'
        course = $(target).closest('.course-radio')
      $(course).addClass "course-selected"
      order[courseTypeId] = $(course).data "id"

  $("#courses-modal").on "hidden.bs.modal", (event) ->
    $("#courses-modal").data "course-type-id": "" 
    $(event.target).find(".modal-body").first().empty()

  $("#weekday-panes").on "click", "#make-order-button", (event) ->
    alert = $(".alert").first()
    alertContent = $(alert).find(".alert-content").first()
    message = ""
    $.post "orders",
      "courses": order,
      (data) ->
        if data.code == 200
          alert.addClass "alert-success"
          alertContent.text data.message
        else
          alert.addClass "alert-danger"
          alertContent.text Object.values(data.errors).join(' | ')
        alert.css display: "initial"

  processCreatingCourse = (modalId, data) ->
    $(modalId).modal 'hide'
    alert = $(".alert").first()
    alertContent = $(alert).find(".alert-content").first()
    if data.code == 200
      alert.addClass "alert-success"
      alertContent.text data.message
    else
      alert.addClass "alert-danger"
      alertContent.text Object.values(data.errors).join(' | ')
    alert.css display: "initial"


  $('#add-course-modal').find('form').first().on "ajax:success",
    (event, data, status, xhr) ->
      processCreatingCourse('#add-course-modal', data)

  $('#add-course-with-type-modal').find('form').first().on "ajax:success",
    (event, data, status, xhr) ->
      processCreatingCourse('#add-course-with-type-modal', data)
