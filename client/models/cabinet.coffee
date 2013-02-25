# A cabinet, contains drawers and shows layout
class Cabinet extends EditableModel
  defaults: ->

    # Number of drawers vertically
    height: 4

    # Number of drawers horizontally
    width: 5

    # A label/name for the cabinet
    label: ""

    # A longer description for this cabinet
    description: ""

    # The heading used for rendering
    heading: Headings.cabinet

    # Selects the standard edit actions
    editActions: Headings.edit.actions

  editJSON: ->
    out = super
    out["attributes"] = [
      {label: "Description", name: "description", textarea:true, value: @get("description")}
      {label: "Drawers Horizontally", name: "width", type: "number", value: @get("width")}
      {label: "Drawers Vertically", name: "height", type: "number", value: @get("height")}
    ]
    out
