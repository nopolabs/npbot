Fs = require 'fs'
Path = require 'path'

class ScriptLoader
  constructor: (@bot) ->
    @log = @bot.log

  load: (paths...) ->
    for path in paths
      if Array.isArray(path)
        for p in path
          @loadPath(p)
      else
        @loadPath(path)

  loadPath: (path) ->
    @log.info("Loading scripts from " + path);
    path = Path.resolve path
    stats = Fs.statSync(path)
    if stats.isFile()
      @loadFile Path.resolve path
    else
      if Fs.existsSync(path)
        for file in Fs.readdirSync(path).sort()
          @loadFile Path.join path, file

  loadFile: (file) ->
    ext = Path.extname file
    @log.debug "Loading", file, ext
    if require.extensions[ext]
      try
        script = require(file)

        if typeof script is 'function'
          script @bot
        else
         @log.warn "Expected #{file} to assign a function to module.exports, got #{typeof script}"

      catch error
        @log.error "Unable to load #{file}: #{error.stack}"
        process.exit(1)

module.exports = ScriptLoader