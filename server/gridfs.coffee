class GridFS
  constructor: (name) ->
    @files  = new Meteor.Collection "#{name}.files"
    @chunks = new Meteor.Collection "#{name}.chunks"
  createFile: (filename, length, meta={}) =>
    id = @files.insert {filename:filename, metadata:meta, length:length, chunkSize: FILE_CHUNK_SIZE, uploadDate: new Date}
    id
  setChunk: (files_id, n, data) =>
    @chunks.insert {files_id, n, data}
    true
  deleteFile: (files_id) =>
    @chunks.remove {files_id}
    @files.remove {_id: files_id}
    true
  getChunk: (files_id, n) =>
    @chunks.findOne({files_id, n},{fields:{data:1}}).fetch()[0].data
  finalize: (files_id) =>
    file = @files.findOne {_id: files_id}
    throw "file not found" unless file
    numChunks = Math.ceil(file.length / file.chunkSize)
    chunks = @chunks.find {files_id: files_id},
      fields: {data:1}
      sort: {n:1}
    return false unless chunks.count() == numChunks
    md5 = CryptoJS.algo.MD5.create()
    chunks.forEach (chunk) ->
      md5.update chunk.data
    hash = md5.finalize().toString()
    @files.update {_id: files_id}, {$set: {md5: hash}}
    hash
