class FileStreamReader
  constructor: (file) ->
    @file = file
    @pos = 0
    @md5 = CryptoJS.algo.MD5.create()
  size: ->
    @file.size
  pos: ->
    @pos
  seek: (pos) ->
    @pos = pos
  read: (cb) ->
    return false if @eof()
    end = Math.min(@file.size, @pos + FILE_CHUNK_SIZE)
    slice = @file.slice(@pos,end)
    @pos = end
    reader = new FileReader
    reader.onload = (frEvent) =>
      data = frEvent.target.result
      @md5.update data
      cb data
    reader.readAsBinaryString slice
    return true
  eof: ->
    @pos == @file.size
  finish: ->
    @md5.finalize().toString()

class ClientUpload
  constructor: (file, finish_cb, progress_cb) ->
    @reader = new FileStreamReader file
    @bps = -1
    @chunk = 0
    @timeout = null
    @sendFlag = false
    @inProgress = false
    @saturated = false
    @progressCB = progress_cb
    @finishCB = finish_cb
  start: ->
    throw "Already in progress or finished" if @inProgress
    @inProgress = true
    Meteor.call "file_create", (id) =>
      @id = id
      @sendChunk()
  speedLimit: (KiB_sec) ->
    @bps = KiB_sec * 1024
    @sendChunk()
  calcWaitTime: ->
    (FILE_CHUNK_SIZE / @bps) * 1000
  setTimeout: ->
    Meteor.clearTimeout @timeout
    @timeout = Meteor.setTimeout @sendChunk, @calcWaitTime()
  sendChunk: ->
    @setTimeout()
    if @sendFlag
      @saturated = true
      return false
    @sendFlag = true
    do_next = @reader.read (data) =>
      @progressCB @toJSON()
      Meteor.call "file_save_chunk", @id, @chunk, data, (err,retr) =>
        @chunk += 1
        @sendFlag = false
        if @saturated
          @saturated = false
          @sendChunk()
    @finish() unless do_next
  finish: ->
    Meteor.clearTimeout @timeout
    hash = @reader.finish()
    Meteor.call "file_finalize", @id, (err,retr) ->
      @finishCB
        localMD5: hash
        remoteMD5: retr
        totalSize: @reader.size()
        fileId: @id
        filename: @name
  toJSON: ->
    pos = @reader.pos()
    size = @reader.size()
    {
      fileId: @id
      pos: pos
      size: size
      progress: (pos / size)*100
      progressString: BytesToString(pos) + " of " + BytesToString(size)
      remainingString: BytesToString(size - pos)
      filename: @name
    }
