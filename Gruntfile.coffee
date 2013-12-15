_ = require 'underscore'

module.exports = (grunt) ->

  # index.html template
  index_tmpl =  """
                !!!
                %html
                  %head
                    %meta{:charset => "utf-8"}/
                    %meta{:'http-equiv' => "X-UA-Compatible", :content => "IE=edge,chrome=1"}/
                    %meta{:name => "viewport", :content => "width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"}/
                    %title
                      Document
                    %link{:rel => "stylesheet", :href => "css/main.css"}/
                  %body
                    #main
                    %script{:'data-main' => "scripts/main", :src => "scripts/libraries/requirejs/require.js"}
                """

  # main.js template
  main_tmpl = """
              requirejs.config

                appDir: '../'
                baseUrl: 'scripts'

                paths:

                  'jquery'            : 'libraries/jquery/jquery'
                  'underscore'        : 'libraries/underscore/underscore'
                  'backbone'          : 'libraries/backbone/backbone'

                  # Plugins
                  'text'              : 'libraries/text/text'
                  'spin'              : 'libraries/spin.js/spin'

                  # Moment
                  'momentpt'          : 'libraries/momentjs/lang/pt'
                  'moment'            : 'libraries/momentjs/moment'

                  # Bootstrap
                  'transition'        : 'libraries/bootstrap-sass/js/transition'
                  'dropdown'          : 'libraries/bootstrap-sass/js/dropdown'

                  # jQuery UI
                  'jquery.ui.core'          : 'libraries/jquery-ui/ui/jquery.ui.core'
                  'jquery.ui.autocomplete'  : 'libraries/jquery-ui/ui/jquery.ui.autocomplete'
                  'jquery.ui.widget'        : 'libraries/jquery-ui/ui/jquery.ui.widget'


                shim:

                  'backbone':

                    deps: ['underscore', 'jquery']
                    exports: 'Backbone'

                  'dropdown'    : ['transition']
                  'transition'  : ['jquery']
                  'momentpt'    : ['moment']


              require ['app'], (app) ->

                do app.init
              """


  # app.js template
  app_tmpl =  """
              define (require) ->

                "use strict"

                Backbone = require 'backbone'

                App =

                  init: ->

                    console.log "Application initialized."
              """


  # App build template
  build_tmpl =  """
                ({

                  baseUrl: '../scripts',
                  name: 'main',
                  out: '../../../dist/scripts/main.min.js',

                  paths: {

                    requireLib:   '../scripts/libraries/requirejs/require',
                    jquery:       '../scripts/libraries/jquery/jquery.min',
                    underscore:   '../scripts/libraries/underscore/underscore-min',
                    backbone:     '../scripts/libraries/backbone/backbone-min',
                    text:         '../scripts/libraries/text/text',
                    spin:         '../scripts/libraries/spin.js/dist/spin.min',

                    momentpt:     '../scripts/libraries/momentjs/lang/pt',
                    moment:       '../scripts/libraries/momentjs/min/moment.min',

                    transition:   '../scripts/libraries/bootstrap-sass/js/transition',
                    dropdown:     '../scripts/libraries/bootstrap-sass/js/dropdown'

                  },

                  shim: {

                    backbone: {
                      deps: ['underscore', 'jquery'],
                      exports: 'Backbone'
                    },

                    dropdown    : ['transition'],
                    transition  : ['jquery'],

                    momentpt    : ['moment']

                  },

                  include: ['requireLib'],

                  skipDirOptimize: true,

                  optimize: 'uglify2'

                })
                """

  css_build = """
              ({

              optimizeCss: 'standard',
              cssIn: '../css/main.css',
              out: '../../../dist/css/stylesheet.min.css'

              })
              """

  html_build =  """
                <!DOCTYPE html>
                <html>
                  <head>
                    <meta charset='utf-8'>
                    <meta content='IE=edge,chrome=1' http-equiv='X-UA-Compatible'>
                    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
                    <title>Document</title>
                    <link rel="stylesheet" href="css/stylesheet.min.css">
                  </head>
                  <body>
                    <div id="main"></div>
                    <script src='scripts/main.min.js'></script>
                  </body>
                </html>
                """




  # Grunt config
  grunt.initConfig

    appSrc: 'application/_src'
    assets: 'application/httpdocs'

    coffee:

      compile:

        files: [
          expand: yes
          cwd: '<%= appSrc %>'
          src: ['**/*.coffee']
          dest: '<%= assets %>'
          ext: '.js'
        ]


    haml:

      compile:

        files: [
          expand: yes
          cwd: '<%= appSrc %>'
          src: ['**/*.haml']
          dest: '<%= assets %>'
          ext: '.html'
        ]


    sass:

      compile:

        options:
          style: 'expanded'
          compass: yes
          lineNumbers: yes

        files: [
          expand: yes
          cwd: '<%= appSrc %>'
          src: ['**/*.scss']
          dest: '<%= assets %>/css'
          ext: '.css'
        ]


    coffeelint:

      check:
        files: [
          expand: yes
          cwd: '<%= appSrc %>'
          src: ['**/*.coffee']
        ]



    watch:

      scss:
        files: ['<%= appSrc %>/**/*.scss']
        tasks: ['newer:sass:compile', 'notify:msg']

      hamlc:
        files: ['<%= appSrc %>/**/*.haml']
        tasks: ['newer:haml:compile', 'notify:msg']

      coffeescript:
        files: ['<%= appSrc %>/**/*.coffee']
        tasks: ['newer:coffee:compile', 'notify:msg', 'newer:coffeelint:check']




    notify:

      msg:
        options:
          title: 'Running watch:compile..'
          message: 'Done, without errors.'




    shell:

      options:
        stdout: yes
        stderr: yes

      dist:
        command: [
          'r.js -o application/httpdocs/build/application.build.js'
          'r.js -o application/httpdocs/build/css.build.js'
        ].join '&&'

      init:
        command: 'bower install'



  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-haml'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-newer'
  grunt.loadNpmTasks 'grunt-notify'
  grunt.loadNpmTasks 'grunt-shell'


  grunt.registerTask 'default', ['watch']


  # Build task
  grunt.task.registerTask 'build', 'builds dist folder', ->

    grunt.task.run ['shell:dist']
    grunt.file.write "dist/index.html", _.template html_build, {}


  # Application init task
  grunt.task.registerTask 'init', 'creates application structure', ->

    grunt.task.run ['shell:init']

    src = "application/_src"

    # Application base files
    grunt.file.write "#{src}/scripts/app.coffee",  _.template app_tmpl, {}
    grunt.file.write "#{src}/scripts/main.coffee", _.template main_tmpl, {}
    grunt.file.write "#{src}/main.scss"
    grunt.file.write "#{src}/index.haml", _.template index_tmpl, {}

    # Build files
    grunt.file.write "application/httpdocs/build/application.build.js", _.template build_tmpl, {}
    grunt.file.write "application/httpdocs/build/css.build.js", _.template css_build, {}

    grunt.task.run ['coffee', 'haml', 'sass', 'watch']








