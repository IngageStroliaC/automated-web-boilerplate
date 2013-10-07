module.exports = (grunt) ->

  # load package.json as an object into a variable called pkg
  pkg = grunt.file.readJSON 'package.json'

  # runs grunt.loadNpmTasks on every dependency in package.json devDependencies that starts with 'grunt-'
  # this saves us the hassle of needing to load each one manually
  grunt.loadNpmTasks dep for dep, ver of pkg.devDependencies when 'grunt-' is dep.slice 0, 6

  # task specific information
  taskOptions =
    dev:
      task: 'dev'
      pkg: pkg
      min: ''
    prod:
      task: 'prod'
      pkg: pkg
      min: '.min'

  # creates an object with a processContent function that will handle appropriate
  # replacements in copied files
  copyOps = (taskName) ->
    processContent: (content, srcpath) ->
      grunt.template.process content, data: taskOptions[taskName]

  # initConfig sets up the grunt task options
  grunt.initConfig
    pkg: pkg

  # the clean task removes the directories specified and all their content
    clean: ['public']

  # the copy task will copy all files from src, within the cwd location, to the dest folder
  # glob patterns are used to determine which files to copy
    copy:
      bin:
        files: [
          expand: true, cwd: 'dev/', src: ['**/*.{png,jpg,gif,ico,pdf}'], dest: 'public/'
        ]
      dev:
        options: copyOps 'dev'
        files: [
          expand: true, cwd: 'dev/', src: ['**', '!**/*.min.*','!**/*.{png,jpg,gif,ico,pdf}'], dest: 'public/'
        ]
      prod:
        options: copyOps 'prod'
        files: [
          expand: true, cwd: 'dev/', src: ['**/*.{svg,html}', '**/*.min.{css,js,map}','!**/*.{png,jpg,gif,ico,pdf}'], dest: 'public/'
        ]

  # create a task called dev that will run whenever we call 'grunt dev' from the command line
  grunt.registerTask 'dev', ['clean', 'copy:dev', 'copy:bin']

  # create a task called prod that will run whenever we call 'grunt prod' from the command line
  grunt.registerTask 'prod', ['clean', 'copy:prod', 'copy:bin']

  # set up the default to run whenever 'grunt' is called from the command line without args.
  grunt.registerTask 'default', ['dev']