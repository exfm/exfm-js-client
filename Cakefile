{exec} = require 'child_process'

task 'build', 'Build project', ->
  exec 'coffee --compile exfm.coffee', (err, stdout, stderr) ->
    console.log stdout + stderr
