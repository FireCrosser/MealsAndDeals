$ ->
  $('.user-row').on "click", (event) ->
    window.location = $(event.target).closest('tr').attr "href"
