class UploadManager
  constructor: ->
    @uploads = []
  addStart: (file,cb) ->
    up = new ClientUpload file, (finish) ->
      console.log finish
    @uploads.push up
    up.start cb
  domTrigger: (event, model) =>
    target = event.target
    if target.files.length > 0
      file = target.files[0]
      name = target.name
      @addStart file, (id) =>
        console.log "file created"
        $(target).attr "data-file-id", id

class FileStreamReader
  constructor: (file) ->
    @file = file
    @pos = 0
    @md5 = CryptoJS.algo.MD5.create()
  size: ->
    @file.size
  seek: (pos) ->
    @pos = pos
  read: (cb) ->
    return false if @eof()
    end = Math.min(@file.size, @pos + FILE_CHUNK_SIZE)
    slice = @file.slice(@pos,end)
    @pos = end
    console.log(@pos)
    reader = new FileReader
    reader.onload = (frEvent) =>
      data = frEvent.target.result
      #@md5.update data
      cb data
    reader.readAsBinaryString slice
    return true
  eof: ->
    @pos == @file.size
  finish: ->
    @md5.finalize().toString()

class ClientUpload
  constructor: (file, @finish_cb, @progress_cb) ->
    @reader = new FileStreamReader file
    @name = file.name
    @bps = -1
    @chunk = 0
    @timeout = null

    @timeoutFlag = false
    @transmitFlag = false

    @inProgress = false
  # start the transfer, cb will be called with the new file id if provided
  start: (cb) ->
    throw "Already in progress or finished" if @inProgress
    @inProgress = true
    Meteor.call "file_create", @name, @reader.size(), (err,id) =>
      console.log "created"
      throw "Did not receive file id" unless id
      @id = id
      @queueTransmit()
      if cb then cb id
  speedLimit: (KiB_sec) ->
    @bps = KiB_sec * 1024
    @sendChunk()
  calcWaitTime: ->
    (FILE_CHUNK_SIZE / @bps) * 1000
  queueTransmit: ->
    Meteor.clearTimeout @timeout
    wait = @calcWaitTime()
    console.log wait
    @timeout = Meteor.setTimeout @sendChunk, (if wait > 0 then wait else 1)
  sendChunk: =>
    console.log "sendChunk"
    # If transmitting, then set the timeout flag and return
    if @transmitFlag
      @timeoutFlag = true
      return false
    # if done transmitting execute finish
    if @reader.eof()
      return @finish()
    # set the transmit flag
    @transmitFlag = true
    # queue the next transmit
    @queueTransmit()
    # read the next chunk
    @reader.read (data) =>
      # call the progress callback if set
      @progress_cb @toJSON() if @progress_cb
      # Send the chunk to the server
      Meteor.call "file_save_chunk", @id, @chunk, data, (err,retr) =>
        @chunk += 1
        # we are no longer transmitting
        @transmitFlag = false
        # send the next chunk if we have timed out
        @sendChunk() if @timeoutFlag

  finish: ->
    Meteor.clearTimeout @timeout
    hash = @reader.finish()
    Meteor.call "file_finalize", @id, (err,retr) =>
      data =
        localMD5: hash
        remoteMD5: retr
        totalSize: @reader.size()
        fileId: @id
        filename: @name
      if @finish_cb then @finish_cb data
  toJSON: ->
    pos = @reader.pos
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
