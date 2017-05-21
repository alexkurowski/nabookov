Writer =
  createEditors: ->
    @title = new MediumEditor("#title", {
      placeholder: {
        text: "Chapter Title"
      },
      disableReturn: true,
      toolbar: false
    })

    @draft = new MediumEditor("#draft", {
      placeholder: {
        text: "Chapter Text"
      },
      toolbar: {
        buttons: ['bold', 'italic', 'underline', 'h3', 'h5', 'justifyLeft', 'justifyCenter', 'justifyRight', 'justifyFull']
      }
    })

  resetSidebar: ->
    $('#sidebar-toggle').on 'click', ->
      $('#write').toggleClass("show-sidebar")

    $('.chapter-list').on 'click', '.set-chapter', ->
      Writer.editChapter $(@).data('chapter')

    list = $('.chapter-list')
    list.empty()
    $.each @book.chapters, (i, chapter) ->
      default_title = "Chapter #{i + 1}"
      list.append "<div class='set-chapter' data-chapter='#{i}'>
                     #{chapter.title or default_title}
                   </div>"


  loadBookData: (book) ->
    @book = book
    @book.chapters = []

  loadChapterData: (chapter) ->
    @book.chapters.push(chapter)

  editChapter: (chapter_id) ->
    return if @current_chapter is +chapter_id
    @current_chapter = +chapter_id
    $('.chapter-list').children().removeClass('current')
    $( $('.chapter-list').children()[@current_chapter] ).addClass('current')

    chapter = @book.chapters[@current_chapter]
    @title.setContent(chapter.title)
    @draft.setContent(chapter.text)

  initialize: ->
    @book.chapters.sort (a, b) -> a.order - b.order

    @createEditors()
    @resetSidebar()
    @editChapter @book.chapters.length - 1

module.exports = Writer
