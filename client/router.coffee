class BinsRouter extends Backbone.Router
  routes:
    "components/:id": "viewComponent"
    "components/:id/uploadImage"  : "uploadImage"
    "components/:id/uploadDatasheet"  : "uploadDatasheet"
    "components/:id/delete"  : "deleteComponent"

  uploadFile: (placeholder,cb) ->
    bootbox.confirm Template.uploadDialog({placeholder:placeholder}), (result)->
      if result is yes
        label = $("#uploadTitle").val()
        files  = $("#uploadFile")[0].files
        if label.length < 3
          bootbox.alert "Label too short (less than 3 chars) aborting..."
          return cb false
        else if files.length < 1
          bootbox.alert "No files selected, aborting..."
          return cb false
        else
          cb true, files[0],label
      else
        cb false
  uploadImage: (_id) ->
    @navigate "components/" + _id, {trigger:false,replace:true}
    @uploadFile "Image label/name (e.g. pinout)", (res,file,label) ->
      if res is yes
        Uploads.addStart file, (id) ->
          Components.update {_id}, {$push:{images:{label, id}}}    
  uploadDatasheet: (_id) ->
    @navigate "components/" + _id, {trigger:false,replace:true}
    @uploadFile "Datasheet label/name (e.g. sumary, full)", (res,file,label) ->
      if res is yes
        Uploads.addStart file, (id) ->
          Components.update {_id}, {$push:{datasheets:{label, id}}} 
  viewComponent: (_id) ->
    $("#infoView").empty().append Meteor.render ->
      Template.componentInfo Components.find({_id}).fetch()[0]
  deleteComponent: (_id) ->
    res = Components.find {_id}
    if res.count() > 0
      component = res.fetch()[0]
      bootbox.confirm "Delete component: \"#{component.title}\"?", (result) =>
        if result is yes
          Components.remove {_id} if result
          @navigate "", {trigger:true,replace:true}
        else
          @navigate "components/" + _id, {trigger:true,replace:true}
