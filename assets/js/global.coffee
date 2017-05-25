Global =
  initialize: ->
    $('#header-user').on 'click', ->
      $('#header-user .dropdown').toggleClass('invisible')

    $('#signout').on 'click', ->
      $.ajax
        url: "/signout"
        data: { _csrf_token: csrf() }
        method: "post"
      .done -> window.location.reload()

module.exports = Global
