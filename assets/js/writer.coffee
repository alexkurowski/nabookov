Writer =
  loadBookData: (book) ->
    Writer.book = book
    Writer.book.chapters = []

  loadChapterData: (chapter) ->
    Writer.book.chapters.push(chapter)


  initialize: ->
    Writer.createEditors()
    Writer.addListeners()
    Writer.resetSidebar(true)
    Writer.editChapter Writer.book.chapters[-1..][0].order

  createEditors: ->
    Writer.title = new MediumEditor("#title", {
      placeholder: {
        text: "Chapter Title"
      },
      disableReturn: true,
      toolbar: false
    })

    Writer.draft = new MediumEditor("#draft", {
      placeholder: {
        text: "Type here..."
      },
      toolbar: {
        buttons: ['bold', 'italic', 'underline', 'h3', 'h5', 'justifyLeft', 'justifyCenter', 'justifyRight', 'justifyFull']
      }
    })

  addListeners: ->
    $('#sidebar-toggle').on 'click', ->
      $('#write').toggleClass("show-sidebar")

    $('.chapter-list').on 'click', '.set-chapter .remove', (e) ->
      e.stopPropagation()
      Writer.chapterToRemove = $(@).closest('.set-chapter').data('chapter')
      $('#remove_chapter').modal()

    $('.chapter-list').on 'click', '.set-chapter', ->
      Writer.editChapter $(@).data('chapter')

    $('#new-chapter > div').on 'click', Writer.newChapter

    setInterval(Writer.storeChanges, 2000)

  resetSidebar: (repopulate) ->
    Writer.book.chapters.sort (a, b) -> a.order - b.order

    console.log("resetSidebar, repopulate: " + repopulate)
    if repopulate
      list = $('.chapter-list')
      list.empty()
      $.each Writer.book.chapters, (i, chapter) ->
        defaultChapter = "Chapter #{chapter.order}"
        storedTitle    = Writer.restoreChanges(chapter.order).title
        title  = "<span class='title'>#{storedTitle or defaultChapter}</span>"
        remove = "<span class='remove'
                        data-toggle='modal'
                        data-target='#remove_chapter'><i class='fa fa-trash'></i></span>"

        list.prepend "<div class='set-chapter' data-chapter='#{chapter.order}'>
                       #{title}
                       #{if Writer.book.chapters.length > 1 then remove else ''}
                     </div>"
    if Writer.currentChapter
      $('.set-chapter.current').removeClass('current')
      $(".set-chapter[data-chapter='#{Writer.currentChapter}']").addClass('current')


  storeChanges: ->
    return unless window.localStorage
    key = Writer.book.slug + Writer.getCurrentChapter().id

    newTitle = Writer.title.getContent()
    titleChanged = localStorage.getItem("#{key} > title") isnt newTitle
    newDraft = Writer.draft.getContent()

    localStorage.setItem("#{key} > title", newTitle)
    localStorage.setItem("#{key} > draft", newDraft)

    Writer.resetSidebar(true) if titleChanged

  restoreChanges: (order) ->
    chapter = if order
                Writer.getChapter(order)
              else
                Writer.getCurrentChapter()
    return { title: '', draft: '' } unless chapter
    title   = chapter.title
    draft   = chapter.draft
    if window.localStorage
      key = Writer.book.slug + chapter.id
      title = localStorage.getItem("#{key} > title") || title
      draft = localStorage.getItem("#{key} > draft") || draft
    { title: title, draft: draft }


  getChapterIndex: (order) ->
    result = null
    $.each Writer.book.chapters, (i, ch) -> result = i if ch.order is order
    result

  getChapter: (order) ->
    result = null
    $.each Writer.book.chapters, (_, ch) -> result = ch if ch.order is order
    result

  getCurrentChapter: ->
    Writer.getChapter(Writer.currentChapter)

  newChapter: ->
    $.ajax
      url: "/write/chp"
      method: "post"
      data: {
        _csrf_token: csrf()
        slug: Writer.book.slug
      }
    .done (response) ->
      Writer.loadChapterData(JSON.parse(response))
      Writer.resetSidebar(true)

  editChapter: (chapterOrder, ignoreChanges) ->
    return if Writer.currentChapter is +chapterOrder and not ignoreChanges
    Writer.storeChanges() if Writer.currentChapter and not ignoreChanges
    Writer.currentChapter = +chapterOrder
    Writer.resetSidebar()

    chapter = Writer.restoreChanges()
    Writer.title.setContent( chapter.title )
    Writer.draft.setContent( chapter.draft )

  removeChapter: ->
    Writer.storeChanges()
    $.ajax
      url: "/write/rch"
      method: "post"
      data: {
        _csrf_token: csrf()
        slug: Writer.book.slug
        order: Writer.chapterToRemove
      }
    .done (response) ->
      if response is 'ok'
        index = Writer.getChapterIndex(Writer.chapterToRemove)
        chaptersBefore = Writer.book.chapters.slice(0, index)
        chaptersAfter  = Writer.book.chapters.slice(index + 1)
        Writer.book.chapters = chaptersBefore.concat(chaptersAfter)

        for chapter in Writer.book.chapters
          if chapter.order > Writer.chapterToRemove
            chapter.order = chapter.order - 1

        console.log( 'Writer.book.chapters.length' )
        console.log( Writer.book.chapters.length )
        console.log( 'Writer.currentChapter' )
        console.log( Writer.currentChapter )

        switchChapters = Writer.currentChapter == Writer.chapterToRemove
        if Writer.currentChapter > Writer.chapterToRemove
          Writer.currentChapter -= 1
        else if Writer.currentChapter == Writer.chapterToRemove
          # TODO: check if this works (previously it was applying changes
          #       from a removed chapter to a new one)
          if Writer.currentChapter == 1
            Writer.editChapter(Writer.currentChapter, true)
          else
            Writer.editChapter(Writer.currentChapter - 1, true)
        Writer.resetSidebar(true)

module.exports = Writer
