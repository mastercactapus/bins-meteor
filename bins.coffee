FILE_CHUNK_SIZE = 262144

ComponentDB = new Meteor.Collection "components"

if Meteor.isClient
  Router = new BinsRouter
  Uploads = new UploadManager
  Search = new SearchInterface ComponentDB, "#searchResults"
  Template.searchHeader.events
    "change, keyup input#searchField": (event)->
      results = Search.updateQuery $(event.currentTarget).val()
    "click #addNewComponent": (event) ->
      $(Template.addEditComponent()).lightbox()
  Meteor.startup ->
    Meteor.subscribe "components"
    Search.updateQuery()

    Backbone.history.start()


blank =
  title: "Atmel ATTiny84"
  type: "IC"
  subType: "Microcontroller"
  tags: ["atmel","ic","microcontroller","attiny","attiny84","84"]
  attrs: [
    fileLabel: "image"
  ,
    fileLabel: "datasheet"
  ,
    propLabel: "specifications"
    props: [
      label: "Voltage"
      value: "3.3v"
    ,
      label: "Nothing"
      value: "something"
    ]
  ]

if Meteor.isServer
  FileGrid = new GridFS "file_grid"
  Meteor.startup ->
    #ComponentDB.insert blank
    # Components.insert title:"555 Timer",tags:["555","timer","ic"]
    # Components.insert title:"Atmel ATTiny84",tags:["atmel","attiny84","tiny84", "84", "microcontroller"]
    # Components.insert title:"LED Mount", tags:["led", "mount", "holder", "mounting", "chrome"]
    # Components.insert title:"Resistor: 220ohm", tags:["resistor","220ohm", "220"]
  Meteor.publish "components", ->
      ComponentDB.find()
    #FileGrid.ensureIndex( { files_id: 1, n: 1 }, { unique: true } );

