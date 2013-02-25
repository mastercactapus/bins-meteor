class GridFS
  constructor: (name) ->
    @files  = new Meteor.Collection "#{name}.files"
    @chunks = new Meteor.Collection "#{name}.chunks"

  createFile: (filename, length) ->
    id = @files.insert {filename, length, FILE_CHUNK_SIZE, uploadDate: new Date}

  saveChunk: (files_id, n, data) ->
    return false if data % FILE_CHUNK_SIZE != 0
    chunks = ChunkIt data, FILE_CHUNK_SIZE
    @chunks.insert {files_id, n: n++, chunk} for chunk in chunks
    true

  finalize: (files_id) ->
    numChunks = Math.ceil(file.length / file.chunkSize)
    chunks = @chunks.find({files_id},{data:1})
    return false unless chunks.count() == numChunks
    md5 = CryptoJS.algo.MD5.create()
    chunks.sort({n:1}).forEach (chunk) ->
      md5.update chunk.data
    hash = md5.finalize().toString()
    @files.update
      _id: files_id
      $set: {md5: hash}
