class UploadManager
  constructor: ->
    @uploads = []
  addFile: (file, cb) =>
    up = new GridUpload file
    @uploads.push up
    up.start cb

class GridUpload extends ChunkTransfer
  constructor: (@file, @meta = {}) ->
    @started = false
    @reader = new FileAPIReader @file
    super()
  start: (cb) ->
    throw "already started" if @started
    @started = true
    Meteor.call "grid_createFile", @file.name, @file.size, @meta, (@id) =>
      @writer = new GridWriter @id
      super @reader, @writer

class FileAPIReader extends ChunkIO
  get: (chunkID, cb) ->
    pos = @chunkSize * chunkID
    slice = @file.slice(pos, pos + @chunkSize)
    reader = new FileReader
    reader.onload = (frEvent) =>
      data = frEvent.target.result
      cb data
    reader.readAsBinaryString slice
  length: ->
    Math.ceil @file.size / @chunkSize

class GridWriter extends ChunkIO
  constructor: (@fileID) ->
  set: (chunkID, data, cb) =>
    Meteor.call "grid_setChunk", @fileID, chunkID, data, cb
  finish: =>
    Meteor.call "grid_finalize", @fileID
  cancel: =>
    Meteor.call "grid_deleteFile", @fileID

