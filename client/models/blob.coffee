# A single drawer inside a cabinet, can have different sizes
class Drawer extends Backbone.Model
  defaults: ->

    # An image/icon to display for this drawer
    image: null

    # The width of the drawer face in cm (for labels -- future release)
    labelWidth:5

    # The height of the drawer face in cm (for labels -- future release)
    labelHeight:2

    # A label to display on the face of the drawer
    label: null

    # Toggles weather this drawer is selected or not
    selected: false

    # Indicates a count for this drawer (e.g. required number or stock count)
    count: -1
    
    # Indicates which cabinet this drawer is in [id]
    cabinet: ""
