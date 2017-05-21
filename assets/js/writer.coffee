Writer =
  initialize: ->
    @draft = new MediumEditor("#draft", {
      toolbar: {
        buttons: ['bold', 'italic', 'underline', 'h2', 'h3']
      }
    })

module.exports = Writer
