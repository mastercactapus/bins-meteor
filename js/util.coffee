BytesToString = (bytes) ->
  labels = ["Bytes", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"]
  suffix = 0
  while bytes > 999
    suffix += 1
    bytes /= 1024
  bytes.toFixed( suffix ? 2 : 0 ) + labels[suffix]

ChunkIt = (data, size) ->
  return data unless data.length > size
  chunk_count = Math.ceil(data.length/size)
  console.log "count", chunk_count
  chunks = []
  chunks[n] = data[(n*size)...size] for n in [0...chunk_count]
  chunks
