class ChunkIO
  constructor: (@file, @chunkSize) ->
  get: (chunkID, cb) ->
  set: (chunkID, data, cb) ->
  finish: ->
  length: ->

class ChunkTransfer
  constructor: (options={}) ->
    _.extend this, Backbone.Events # add backbone events
    @maxReqs = options["max_requests"] || 10
    @curReqs = 0
    @started = false
    @finished = false
    @canceled = false
    @chunk = 0
  start: (@src, @dest) =>
    throw "Transfer already started or finished." if @started
    @started = true
    @total = @src.length()
    @trigger "start", @total
    @nextChunk()
  cancel: =>
    throw "Transfer already started or finished." if @started
    throw "Transfer already canceled" if @canceled
    @canceled = true
  pause: =>
    throw "Already paused" if @paused
    throw "Transfer has already completed" if @finished
    @paused = true
  resume: =>
    throw "Transfer is already running" unless @paused
    @paused = false
    @nextChunk()
  nextChunk: =>
    throw "Next chunk requested, but transfer hasn't started." unless @started
    throw "Next chunk requested, but transfer has already finished." if @finished
    return false if @paused
    if @curReqs >= @maxReqs
      return false
    if @curReqs is 0 and @canceled
      @_cancel
      return false
    if @curReqs is 0 and @chunk == @total
      @finish
      return false
    currentChunk = @chunk++
    @curReqs++
    @src.get currentChunk, (data) =>
      @dest.set currentChunk, data, =>
        @curReqs--
        @trigger "progress", @chunk-1, @total
        @nextChunk()
    @nextChunk()
    return true
  _cancel: =>
    @dest.cancel()
    @trigger "cancel"
  finish: =>
    @finished = true
    @dest.finish()
    @trigger "finish"
