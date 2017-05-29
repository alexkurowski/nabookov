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
      Writer.chapterToRemove = $(@).closest('.set-chapter').data('order')
      $('#remove_chapter').modal()

    $('.chapter-list').on 'click', '.set-chapter', ->
      Writer.editChapter $(@).data('order')

    $('#new-chapter').on 'click', Writer.newChapter

    $(document).on 'scroll', -> switchClass('#fixed-actions', 'shown', scrollY is 0)
    switchClass('#fixed-actions', 'shown', scrollY is 0)

    setInterval(Writer.storeChanges, 2000)

    $('#manage-chapters').on 'click', (e) ->
      e.stopPropagation()
      Writer.resetManageList()
      $('#manage_chapters').modal()

  resetManageList: ->
    hidden = (condition) -> if condition then '' else 'hidden'

    allChapters = $('.set-chapter').length
    list = $('.manage-chapter-list')

    list.empty()
    $('.set-chapter').each (i, el) ->
      chapter = Writer.getChapter $(el).data('order')
      count = allChapters - i
      text = localStorage.getItem("#{Writer.book.slug}#{chapter.id} > draft") or chapter.text
      words = text.replace(/<.*?>/g, ' ')
                  .trim()
                  .split(' ')
                  .filter((str) -> !!str)
                  .length

      body = """
             <div class='chapter' data-chapter='#{chapter.id}' data-order='#{chapter.order}'>
               <div class='top'>
                 <span class='count float-left'>#{count}: </span>
                 <span class='title'>#{chapter.title}</span>
                 <span class='words float-right'>#{words} word#{plural words}</span>
               </div>
               <span class='visible true  #{hidden chapter.visible}'>Published</span>
               <span class='visible false #{hidden not chapter.visible}'>Private</span>
               <span class='locked  true  #{hidden chapter.locked}'>Paid only</span>
               <span class='locked  false #{hidden not chapter.locked}'>Free</span>
               <span class='update'>Submit changes</span>
             </div>
             """
      list.prepend body


  resetSidebar: (repopulate) ->
    Writer.book.chapters.sort (a, b) -> a.order - b.order

    if repopulate
      list = $('.chapter-list')
      list.empty()
      $.each Writer.book.chapters, (i, chapter) ->
        defaultTitle = "Chapter #{chapter.order}"
        storedTitle  = Writer.restoreChanges(chapter.order).title
        title = "<span class='title'>#{storedTitle or defaultTitle}</span>"

        icon   = "<span class='icon edited invisible'><i class='fa fa-pencil'></i></span>"
        remove = "<span class='remove'><i class='fa fa-trash'></i></span>"

        body = """
               <div class='set-chapter' data-order='#{chapter.order}'>
                 #{icon}
                 #{title}
                 #{if Writer.book.chapters.length > 1 then remove else ''}
               </div>
               """
        list.prepend body

      Writer.resetSidebarIcons()
    if Writer.currentChapter
      $('.set-chapter.current').removeClass('current')
      $(".set-chapter[data-order='#{Writer.currentChapter}']").addClass('current')

  resetSidebarIcons: ->
    $.each Writer.book.chapters, (i, chapter) ->
      if localStorage.getItem("#{Writer.book.slug}#{chapter.id} > title") isnt chapter.title or
         localStorage.getItem("#{Writer.book.slug}#{chapter.id} > draft") isnt chapter.text
        $(".set-chapter[data-order='#{chapter.order}'] .icon").removeClass('invisible')


  storeChanges: ->
    return unless window.localStorage
    chapter = Writer.getCurrentChapter()
    key = Writer.book.slug + chapter.id

    newTitle = Writer.title.getContent()
    newDraft = Writer.draft.getContent()
    titleChanged = localStorage.getItem("#{key} > title") isnt newTitle
    draftChanged = localStorage.getItem("#{key} > draft") isnt newDraft

    localStorage.setItem("#{key} > title", newTitle)
    localStorage.setItem("#{key} > draft", newDraft)

    Writer.resetSidebar(true) if titleChanged
    Writer.resetSidebarIcons() if draftChanged

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
    unless ignoreChanges
      return if Writer.currentChapter is +chapterOrder
      Writer.storeChanges() if Writer.currentChapter

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
