FILE_CHUNK_SIZE = 262144

Components = new ComponentCollection
Datasheets = new DatasheetCollection
Cabinets = new CabinetCollection


Test = new Meteor.Collection "testdb"

if Meteor.isClient
  Router = new BinsRouter
  Uploads = new UploadManager
  Meteor.startup ->
    Template.editGeneric.events
      "change input[type=file]": Uploads.domTrigger
    Router.on "route:new_datasheet", (actions) ->
      $("#mainApp").empty().append Meteor.render -> Template.editGeneric (new Datasheet).editJSON()
    Router.on "route:new_cabinet", (actions) ->
      $("#mainApp").empty().append Meteor.render -> Template.editGeneric (new Cabinet).editJSON()
    Router.on "route:new_component", (actions) ->
      $("#mainApp").empty().append Meteor.render -> Template.editGeneric (new Component).editJSON()

    Backbone.history.start()

if Meteor.isServer
  FileGrid = new GridFS "file_grid"
  Meteor.startup ->
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

    
