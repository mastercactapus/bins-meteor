FILE_CHUNK_SIZE = 262144

Components = new ComponentCollection
Datasheets = new DatasheetCollection
Cabinets = new CabinetCollection


Test = new Meteor.Collection "testdb"

if Meteor.isClient
  Router = new BinsRouter
  Meteor.startup ->
    Router.on "route:new_datasheet", (actions) ->
      $("#mainApp").empty().append Meteor.render ->
        Template.editGeneric (new Datasheet).editJSON()
    Router.on "route:new_cabinet", (actions) ->
      $("#mainApp").empty().append Meteor.render ->
        Template.editGeneric (new Cabinet).editJSON()
    Router.on "route:new_component", (actions) ->
      $("#mainApp").empty().append Meteor.render ->
        Template.editGeneric (new Component).editJSON()

    Backbone.history.start()

if Meteor.isServer
  FileGrid = new GridFS "file_grid"
  Meteor.startup ->
    
