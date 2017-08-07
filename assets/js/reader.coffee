Reader =
  loadBookData: (book) ->
    Reader.book = book
    Reader.book.chapters = []

  loadChapterData: (chapter) ->
    Reader.book.chapters.push(chapter)

    key = Reader.book.slug + chapter.id
    if localStorage.getItem("#{key} > draft")
      remote = chapter.sync_time or 0
      local = +localStorage.getItem("#{key} > sync") || 0
      if remote > local
        localStorage.removeItem("#{key} > draft")
        localStorage.removeItem("#{key} > sync")


  initialize: ->
    Reader.createEditors()
    Reader.addListeners()
    # Reader.resetSidebar(true)

  createEditors: ->
    Reader.book.chapters.sort (a, b) -> a.order - b.order

    new MediumEditor("#title", {
      disableEditing: true,
      toolbar: false
    }).setContent(Reader.book.title)

    for chapter in Reader.book.chapters
      $('<div class="title"></div>').appendTo $('#editor')
      $('<div class="text"></div>').appendTo $('#editor')
      $('<hr>').appendTo $('#editor')

      new MediumEditor($('#editor .title').last(), {
        disableEditing: true,
        toolbar: false
      }).setContent(chapter.title)

      new MediumEditor($('#editor .text').last(), {
        disableEditing: true,
        toolbar: false
      }).setContent(chapter.text)

  addListeners: ->
    console.log("addListeners")


  resetSidebar: (repopulate) ->
    Reader.book.chapters.sort (a, b) -> a.order - b.order

    if repopulate
      list = $('.chapter-list')
      list.empty()
      $.each Reader.book.chapters, (i, chapter) ->
        defaultTitle = "Chapter #{chapter.order}"
        storedTitle  = Reader.restoreChanges(chapter.order).title
        title = "<span class='title'>#{storedTitle or defaultTitle}</span>"

        storedDraft = Reader.restoreChanges(chapter.order).draft
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
                 #{if Reader.book.chapters.length > 1 then remove else ''}
               </div>
               """
        list.prepend body

      Reader.resetSidebarIcons()
    if Reader.currentChapter
      $('.set-chapter.current').removeClass('current')
      $(".set-chapter[data-order='#{Reader.currentChapter}']").addClass('current')


module.exports = Reader
