Fs = require 'fs'
Path = require 'path'

class ScriptLoader
  constructor: (@bot) ->
    @log = @bot.log

  load: (paths...) ->
    path = Path.resolve paths...
    @log.debug "Loading scripts from #{path}", process.cwd()
    if Fs.existsSync(path)
      for file in Fs.readdirSync(path).sort()
        @loadFile path, file

  loadFile: (path, file) ->
    ext  = Path.extname file
    full = Path.join path, Path.basename(file, ext)
    @log.debug "Loading", full
    if require.extensions[ext]
      try
        script = require(full)

        if typeof script is 'function'
          script @bot
        else
         @log.warn "Expected #{full} to assign a function to module.exports, got #{typeof script}"

      catch error
        @log.error "Unable to load #{full}: #{error.stack}"
        process.exit(1)

module.exports = ScriptLoader