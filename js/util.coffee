BytesToString = (bytes) ->
  labels = ["Bytes", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"]
  suffix = 0
  while bytes > 999
    suffix += 1
    bytes /= 1024
  bytes.toFixed( suffix ? 2 : 0 ) + labels[suffix]
