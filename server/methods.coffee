Meteor.methods
  "file_create": (filename, length) ->
    FileGrid.createFile filename, length
  "file_save_chunk": (id, n, data) ->
    FileGrid.saveChunk id, n, data
  "file_finalize": (id) ->
    FileGrid.finalize id
