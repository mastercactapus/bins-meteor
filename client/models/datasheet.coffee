# Datasheet object
class Datasheet extends EditableModel
  defaults: ->

    # The datasheet Id
    dsId: ""
    
    # The datasheet size
    dsSize: ""

    # A short description/title for this datasheet
    title: ""

    # A longer description of this datasheet
    description: ""

    # Any tags to be added for search
    tags: []

    # Selects the datasheet heading
    heading: Headings.datasheet

    # Selects the standard edit actions
    editActions: Headings.edit.actions

  editJSON: ->
    out = super
    out["attributes"] = [
      {label: "Description", name: "description", textarea:true, value: @get("description")}
      {label: "Search Tags", name: "tags", type:"text", placeholder: "Comma, separated, list...", value: @get("tags").join(", ")}
      {label: "Datasheet", fileupload:true, name: "binData"}
    ]
    out
