FILE_CHUNK_SIZE = 262144

Components = new ComponentCollection
Datasheets = new DatasheetCollection
Cabinets = new CabinetCollection

if Meteor.isClient
  Router = new BinsRouter
  Uploads = new UploadManager
  Search = new SearchInterface Components, "#searchResults"
  Template.searchHeader.events
    "change, keyup input#searchField": (event)-> results = Search.updateQuery $(event.currentTarget).val()
  Meteor.startup ->
    Meteor.subscribe "components"
    Search.updateQuery()

    Backbone.history.start()

if Meteor.isServer
  FileGrid = new GridFS "file_grid"
  Meteor.startup ->
    # Components.insert title:"555 Timer",tags:["555","timer","ic"]
    # Components.insert title:"Atmel ATTiny84",tags:["atmel","attiny84","tiny84", "84", "microcontroller"]
    # Components.insert title:"LED Mount", tags:["led", "mount", "holder", "mounting", "chrome"]
    # Components.insert title:"Resistor: 220ohm", tags:["resistor","220ohm", "220"]
  Meteor.publish "components", ->
      Components.find()
    #FileGrid.ensureIndex( { files_id: 1, n: 1 }, { unique: true } );
    Meteor.methods
      "file_create": (filename, length) ->
        console.log "create call"
        id = FileGrid.createFile filename, length
        console.log "create return"
        id
      "file_save_chunk": (id, n, data) ->
        FileGrid.saveChunk id, n, data
      "file_finalize": (id) ->
        FileGrid.finalize id

    
