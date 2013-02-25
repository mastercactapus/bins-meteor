class EditableModel extends Backbone.Model
  defaults: ->
    heading: Headings.generic
    editActions: Headings.edit.actions
    title: ""

  editJSON: ->
    {
      heading: @get("heading")
      editActions: @get("editActions")
      title: @get("title")
    }
