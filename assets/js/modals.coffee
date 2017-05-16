Modals =
  initialize: ->
    csrf = ->
      $('meta[name="csrf-token"]').attr('content')

    # TODO: disable submit buttons so there are no multiple requests

    $('#signin-submit').on 'click', ->
      email = $('#user_email').val().trim()
      valid = /.+@.+\..+/
      return unless valid.test email
      $.ajax
        url: '/signin'
        method: 'post'
        data: {
          _csrf_token: csrf(),
          email: email
        }
      .done ->
        $('#signin').modal('hide')
        $('#signin_ok').modal()

    $('#username-submit').on 'click', ->
      name = $('#user_name').val().trim()
      return if name.length is 0
      $.ajax
        url: '/username'
        method: 'post'
        data: {
          _csrf_token: csrf(),
          name: name
        }
      .done ->
        $('#username').modal('hide')
        $('#header-user > .name').text("@#{name}")
      .fail ->
        $('#username-taken').fadeIn()
        setTimeout(->
          $('#username-taken').fadeOut()
        , 3000)

    $('#new-book-submit').on 'click', ->
      title = $('#book_title').val().trim()
      description = $('#book_description').val().trim()
      if title.length is 0
        $('#book_title').addClass('has-danger').focus()
        return
      if description.length is 0
        $('#book_description').addClass('has-danger').focus()
        return
      $.ajax
        url: '/write/new'
        method: 'post'
        data: {
          _csrf_token: csrf(),
          title: title,
          description: description
        }
      .done -> location.reload()


    $('#username-taken').hide()

    $('.modal-body').on 'keypress', (e) ->
      return true if $(@).closest('.modal').css('display') is 'none'
      if e.keyCode is 13
        e.preventDefault()
        $(@).parent().find('.modal-footer > .link').click()

    $('.modal').on 'shown.bs.modal', ->
      $(@).find('[autofocus]').focus()

    if window.init_modal
      $(window.init_modal).modal()

module.exports = Modals
