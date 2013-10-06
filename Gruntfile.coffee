module.exports = (grunt) ->

  # load package.json as an object into a variable called pkg
  pkg = grunt.file.readJSON 'package.json'

  # runs grunt.loadNpmTasks on every dependency in package.json devDependencies that starts with 'grunt-'
  # this saves us the hassle of needing to load each one manually
  grunt.loadNpmTasks dep for dep, ver of pkg.devDependencies when 'grunt-' is dep.slice 0, 6

  # initConfig sets up the grunt task options
  grunt.initConfig
    pkg: pkg

  # the clean task removes the directories specified and all their content
    clean: ['public']

  # the copy task will copy all files from src, within the cwd location, to the dest folder
  # glob patterns are used to determine which files to copy
    copy:
      dev:
        files: [
          expand: true, cwd: 'dev/', src: ['**'], dest: 'public/'
        ]

  # create a task called dev that will run whenever we call 'grunt dev' from the command line
  grunt.registerTask 'dev', ['clean', 'copy:dev']

  # set up the default to run whenever 'grunt' is called from the command line without args.
  grunt.registerTask 'default', ['dev']