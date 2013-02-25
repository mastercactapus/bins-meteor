
# A basic electronic component
class Component extends EditableModel
  defaults: ->
    # The ids of any describing datasheets
    datasheets: []

    # The number of components available
    stock: -1

    # Title of this component
    title: "Red LED"

    # Description of the component
    description: "90 degree red led, red lens"

    # Additional tags (for searching)
    tags: []

    # an array of file ids
    images: []

    # The id of the cabinet thsi component resides in
    cabinetId: ""

    # The index of the drawer this component is in
    drawer: 0

    # Selects the datasheet heading
    heading: Headings.datasheet

    # Selects the standard edit actions
    editActions: Headings.edit.actions

  editJSON: ->
    out = super
    out["attributes"] = [
      {label: "Description", name: "description", textarea:true, value: @get("description")}
      {label: "Stock Count", name: "stock", type:"text", placeholder: "Estimated quantity", value: @get("stock")}
      {label: "Search Tags", name: "tags", type:"text", placeholder: "Comma, separated, list...", value: @get("tags").join(", ")}
      {label: "Images", name: "images", imagelist:true, value: @get("tags").join(", ")}

    ]
    out
