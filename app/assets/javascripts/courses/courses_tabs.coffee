weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
todayDate = new Date()
todayDate.setDate(todayDate.getDate() + 1)
todayWeekday = (todayDate.getDay() || 7) - 1 
weekStart = new Date(todayDate)
if todayWeekday <= 4
  weekStart.setDate(weekStart.getDate() - todayWeekday)
else
  weekStart.setDate(weekStart.getDate() + 7 - todayWeekday)
currentWeekDay = new Date(weekStart)

coursesData = []

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
  localDate = new Date(date)
  if (pane.find ".courses-wrapper").length == 0
    coursesWrapper = $('<div></div').appendTo pane
    coursesWrapper.attr class: 'col-md-10 col-md-offset-1 courses-wrapper'
    if localDate.getTime() == todayDate.getTime()
      acwtButtonWrapper = $('<div></div>')
      acwtButtonWrapper.appendTo coursesWrapper
      addCourseWithTypeButton = $('<button></button>')
      addCourseWithTypeButton.attr class: 'btn btn-default add-course-with-type'
      addCourseWithTypeButton.attr type: 'button'
      addCourseWithTypeButton.attr 'data-toggle': 'modal'
      addCourseWithTypeButton.attr 'data-target': '#add-course-with-type-modal'
      addCourseWithTypeButton.attr id: '#add-course-with-type-button'
      addCourseWithTypeButton.text "Add course"
      addCourseWithTypeButton.appendTo acwtButtonWrapper
    $.get '/courses',
      date: getFormattedDate(localDate, "%Y-%M-%D"), 
      (data) ->
        coursesData = data
        if data.length == 0
          coursesWrapper.append "No courses now"
        else
          for key, value of data
            courseType = $("<div></div>")
            courseType.attr class: 'course-type'
            courseType.attr "data-course-type-id":key 
            courseType.attr "data-toggle": "modal"
            courseType.attr "data-target": "#courses-modal"
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
              addCourseButton.attr "data-toggle": "modal"
              addCourseButton.attr "data-target": "#add-course-modal"
              addCourseButton.appendTo addCourseWrapper
              addCourseWrapper.appendTo courseType
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
    dayLink.attr "data-date": currentWeekDay
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

  $("#weekday-panes").on "click", ".course-type", (event) ->
    event.stopPropagation()
    courseType = $(event.target).closest(".course-type")
    if event.target.tagName == "A"
      $("#course_course_type_id").attr value: $(courseType).data "course-type-id"
      $("#add-course-modal .modal-title").first().text "Add course to \"" + 
        courseType.find(".course-type-name")[0].innerText + "\" group"
      $("#add-course-modal").modal("show")
    else
      modal = $("#courses-modal")

      courseTypeId = courseType.data "course-type-id"
      console.log courseTypeId
      $(modal).attr "data-course-type-id": courseTypeId
      console.log coursesData
      courses = coursesData[courseTypeId].courses
      modalBody = $(modal).find(".modal-body").first()
      for course in courses
        courseDiv = $("<div></dev>")
        courseDiv.attr class: "course-radio row"
        courseDiv.attr "data-id": course.id
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
      $(event.target).parent()
        .find(".course-radio").removeClass "course-selected"
        $(event.target).addClass "course-selected"

  $("#courses-modal").on "hidden.bs.modal", (event) ->
    $("#courses-modal").removeAttr "data-course-type-id" 
    $(event.target).find(".modal-body").first().empty()

