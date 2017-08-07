Writer =
  settings:
    localSaveEvery: 2000 # ms
    remoteSaveEvery: 10 # every nth local save

  saveCounter: 0


  loadBookData: (book) ->
    Writer.book = book
    Writer.book.chapters = []

  loadChapterData: (chapter) ->
    Writer.book.chapters.push(chapter)

    key = Writer.book.slug + chapter.id
    if localStorage.getItem("#{key} > draft")
      remote = chapter.sync_time or 0
      local = +localStorage.getItem("#{key} > sync") || 0
      if remote > local
        localStorage.removeItem("#{key} > draft")
        localStorage.removeItem("#{key} > sync")


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

    $('#new-chapter').on 'click', Writer.newChapter

    $('.chapter-list').on 'click', '.set-chapter .remove', (e) ->
      e.stopPropagation()
      Writer.chapterToRemove = $(@).closest('.set-chapter').data('order')
      $('#remove_chapter').modal()

    $('#manage_chapter').on 'click', '.draft-submit', (e) ->
      Writer.storeChanges()
      Writer.updateDraft()

    $('#manage_chapter').on 'click', '.publish-submit', (e) ->
      Writer.storeChanges()
      Writer.updateText()

    $('#manage_chapter').on 'click', '.remove', (e) ->
      e.stopPropagation()
      Writer.chapterToRemove = Writer.currentChapter
      $('#manage_chapter').modal('hide')
      $('#remove_chapter').modal()

    $('#manage-chapter').on 'click', (e) ->
      e.stopPropagation()
      $('#write').removeClass("show-sidebar")
      Writer.resetManageList()
      $('#manage_chapter').modal()

    $('.chapter-list').on 'click', '.set-chapter', ->
      Writer.editChapter $(@).data('order')

    setTimeout (-> $('#fixed-actions').removeClass('shown')), 2000

    setInterval(Writer.storeChanges, Writer.settings.localSaveEvery)

  resetManageList: ->
    hidden = (condition) -> if condition then '' else 'hidden'

    modal = $('#manage_chapter')
    el = $('.set-chapter.current')
    chapter = Writer.getChapter $(el).data('order')
    chapterCount = $('.set-chapter').length

    order = $(el).data('order')
    title = $(el).find('.title').text().trim()
    text  = localStorage.getItem("#{Writer.book.slug}#{chapter.id} > draft") or chapter.draft
    words = text.replace(/<.*?>/g, ' ')
                .trim()
                .split(' ')
                .filter((str) -> !!str)
                .length

    modal.find('.modal-title').text("Chapter #{order}")
    modal.find('.title').text("Title: '#{title}'")
    modal.find('.word-count').text("#{words} word#{plural words}")

    switchClass(modal.find('.remove-option'), 'hidden', chapterCount is 1)

    body = """
           <div class='chapter' data-chapter='#{chapter.id}' data-order='#{chapter.order}'>
             <div class='top'>
               <span class='words float-right'>#{words} word#{plural words}</span>
               <span class='title'>#{title}</span>
             </div>
             <div class='publish link-btn'>Publish</div>
             <div class='update link-btn'>Upload as draft</div>
             <span class='visible true  #{hidden chapter.visible}'>Publish</span>
             <span class='visible false #{hidden not chapter.visible}'>Private</span>
             <span class='locked  true  #{hidden chapter.locked}'>Paid only</span>
             <span class='locked  false #{hidden not chapter.locked}'>Free</span>
             <div class='clearfix'></div>
           </div>
           """


  resetSidebar: (repopulate) ->
    Writer.book.chapters.sort (a, b) -> a.order - b.order

    if repopulate
      list = $('.chapter-list')
      list.empty()
      $.each Writer.book.chapters, (i, chapter) ->
        defaultTitle = "Chapter #{chapter.order}"
        storedTitle  = Writer.restoreChanges(chapter.order).title
        title = "<span class='title'>#{storedTitle or defaultTitle}</span>"

        storedDraft = Writer.restoreChanges(chapter.order).draft
        text = (storedDraft or chapter.draft or chapter.draft)
        hasText = false
        hasText = text.replace(/<.+?>/g, '').length > 0 if text

        icon   = "<span class='icon edited invisible' title='Unsubmitted changes'><i class='fa fa-pencil'></i></span>"
        remove = "<span class='remove' title='Delete chapter'><i class='fa fa-trash'></i></span>"
        remove = '' if hasText

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
         localStorage.getItem("#{Writer.book.slug}#{chapter.id} > draft") isnt chapter.draft
        $(".set-chapter[data-order='#{chapter.order}'] .icon").removeClass('invisible')


  updateDraft: ->
    $('#manage_chapter').modal('hide')

    chapter = Writer.getCurrentChapter()
    title = Writer.title.getContent()
    draft = Writer.draft.getContent()

    $.ajax
      url: '/write/upd'
      method: 'post'
      data: {
        _csrf_token: csrf()
        book: Writer.book.slug
        chapter: chapter.id
        title: title
        draft: draft
        sync_time: +new Date
      }


  updateText: ->
    $('#manage_chapter').modal('hide')

    chapter = Writer.getCurrentChapter()
    title = Writer.title.getContent()
    draft = Writer.draft.getContent()

    $.ajax
      url: '/write/pbl'
      method: 'post'
      data: {
        _csrf_token: csrf()
        book: Writer.book.slug
        chapter: chapter.id
        title: title
        draft: draft
        sync_time: +new Date
      }


  storeChanges: ->
    return unless window.localStorage
    chapter = Writer.getCurrentChapter()

    newTitle = Writer.title.getContent()
    newDraft = Writer.draft.getContent()
    titleChanged = localStorage.getItem("#{key} > title") isnt newTitle
    draftChanged = localStorage.getItem("#{key} > draft") isnt newDraft

    key = Writer.book.slug + chapter.id
    localStorage.setItem("#{key} > title", newTitle)
    localStorage.setItem("#{key} > draft", newDraft)
    localStorage.setItem("#{key} > sync", +new Date)

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
          if Writer.currentChapter == 1
            Writer.editChapter(Writer.currentChapter, true)
          else
            Writer.editChapter(Writer.currentChapter - 1, true)
        Writer.resetSidebar(true)

module.exports = Writer
