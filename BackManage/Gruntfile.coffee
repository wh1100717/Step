'use strict'

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'

module.exports = (grunt) ->

  # Load grunt tasks automatically
  require('load-grunt-tasks')(grunt)

  # Time how long tasks take. Can help when optimizing build times
  require('time-grunt')(grunt)

  grunt.initConfig {
    BackManage: {
      app: 'app'
      dist: 'dist'
    }
    express: {
      options: {
        port: process.env.PORT or 9000
      }
      dev: {
        options: {
          script: 'server.js'
          debug: true
        }
      }
      prod: {
        options: {
          script: 'dist/server.js'
          node_env: 'production'
        }
      }
    }
    open: {
      server: {
        url: 'http://localhost:<%= express.options.port %>'
      }
    }
    watch: {
      js: {
        files: ['<%= BackManage.app %>/scripts/**/*.js']
        tasks: ['newer:jshint:all']
        options: {
          livereload: true
        }
      }
      styles: {
        files: ['<%= BackManage.app %>/styles/**/*.css']
        tasks: ['newer:copy:styles', 'autoprefixer']
      }
      gruntfile: {
        files: ['Gruntfile.js']
      },
      livereload: {
        files: [
          '<%= BackManage.app %>/views/{,*#*}*.{html,jade}',
          '{.tmp,<%= BackManage.app %>}/styles/{,*#*}*.css',
          '{.tmp,<%= BackManage.app %>}/scripts/{,*#*}*.js',
          '<%= BackManage.app %>/images/{,*#*}*.{png,jpg,jpeg,gif,webp,svg}'
        ]
        options: {
          livereload: true
        }
      },
      express: {
        files: ['server.js', 'lib/**/*.{js,json}']
        tasks: ['newer:jshint:server', 'express:dev', 'wait']
        options: {
          livereload: true
          nospawn: true #Without this option specified express won't be reloaded
        }
      }
    }
    # Make sure code styles are up to par and there are no obvious mistakes
    jshint: {
      options: {
        jshintrc: '.jshintrc'
        reporter: require('jshint-stylish')
      }
      server: {
        options: {
          jshintrc: 'lib/.jshintrc'
        }
        src: ['lib/**/*.js']
      }
      all: []
    }
    # Empties folders to start fresh
    clean: {
      dist: {
        files: [{
          dot: true
          src: [
            '.tmp'
            '<%= BackManage.dist %>/*'
            '!<%= BackManage.dist %>/.git*'
            '!<%= BackManage.dist %>/Procfile'
          ]
        }]
      }
      server: '.tmp'
    }
    # Add vendor prefixed styles
    autoprefixer: {
      options: {
        browsers: ['last 1 version']
      }
      dist: {
        files: [{
          expand: true
          cwd: '.tmp/styles/'
          src: '**/*.css'
          dest: '.tmp/styles/'
        }]
      }
    }
    # Debugging with node inspector
    'node-inspector': {
      custom: {
        options: {
          'web-host': 'localhost'
        }
      }
    }
    # Use nodemon to run server in debug mode with an initial breakpoint
    nodemon: {
      debug: {
        script: 'server.js'
        options: {
          nodeArgs: ['--debug-brk']
          env: {
            PORT: process.env.PORT or 9000
          }
          callback: (nodemon) ->
            nodemon.on 'log', (event) -> console.log event.colour
            nodemon.on('config:update', ->
              setTimeout( ->
                require('open')('http:#localhost:8080/debug?port=5858')
              , 500)
            )
        }
      }
    }
    # Automatically inject Bower components into the app
    bowerInstall: {
      target: {
        src: '<%= BackManage.app %>/views/layout.jade'
      }
    }
    # Renames files for browser caching purposes
    rev: {
      dist: {
        files: {
          src: [
            '<%= BackManage.dist %>/public/scripts/**/*.js'
            '<%= BackManage.dist %>/public/styles/**/*.css'
            '<%= BackManage.dist %>/public/images/**/*.{png,jpg,jpeg,gif,webp,svg}'
            '<%= BackManage.dist %>/public/styles/fonts/*'
          ]
        }
      }
    }
    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare: {
      html: [
        '<%= BackManage.app %>/views/layout.jade'
      ]
      options: {
        dest: '<%= BackManage.dist %>/public'
      }
    }
    # Performs rewrites based on rev and the useminPrepare configuration
    usemin: {
      html: [
        '<%= BackManage.dist %>/views/**/*.html'
        '<%= BackManage.dist %>/views/**/*.jade'
      ]
      css: ['<%= BackManage.dist %>/public/styles/**/*.css']
      options: {
        assetsDirs: ['<%= BackManage.dist %>/public']
      }
    }
    # The following *-min tasks produce minified files in the dist folder
    imagemin: {
      options: {cache: false}
      dist: {
        files: [{
          expand: true
          cwd: '<%= BackManage.app %>/images'
          src: '**/*.{png,jpg,jpeg,gif}'
          dest: '<%= BackManage.dist %>/public/images'
        }]
      }
    }
    svgmin: {
      dist: {
        files: [{
          expand: true
          cwd: '<%= BackManage.app %>/images'
          src: '**/*.svg'
          dest: '<%= BackManage.dist %>/public/images'
        }]
      }
    }
    htmlmin: {
      dist: {
        options: {
          #collapseWhitespace: true,
          #collapseBooleanAttributes: true,
          #removeCommentsFromCDATA: true,
          #removeOptionalTags: true
        },
        files: [{
          expand: true,
          cwd: '<%= BackManage.app %>/views'
          src: ['*.html', 'partials/**/*.html']
          dest: '<%= BackManage.dist %>/views'
        }]
      }
    }
    # Allow the use of non-minsafe AngularJS files. Automatically makes it
    # minsafe compatible so Uglify does not destroy the ng references
    ngmin: {
      dist: {
        files: [{
          expand: true
          cwd: '.tmp/concat/scripts'
          src: '*.js'
          dest: '.tmp/concat/scripts'
        }]
      }
    }
    # Copies remaining files to places other tasks can use
    copy: {
      dist: {
        files: [
          {
            expand: true
            dot: true
            cwd: '<%= BackManage.app %>'
            dest: '<%= BackManage.dist %>/public'
            src: [
              '*.{ico,png,txt}'
              '.htaccess'
              'bower_components/**/*'
              'images/**/*.{webp}'
              'fonts/**/*'
            ]
          }
          {
            expand: true
            dot: true
            cwd: '<%= BackManage.app %>/views'
            dest: '<%= BackManage.dist %>/views'
            src: '**/*.jade'
          }
          {
            expand: true
            cwd: '.tmp/images'
            dest: '<%= BackManage.dist %>/public/images'
            src: ['generated/*']
          }
          {
            expand: true
            dest: '<%= BackManage.dist %>'
            src: [
              'package.json'
              'server.js'
              'lib/**/*'
            ]
          }
        ]
      }
      styles: {
        expand: true
        cwd: '<%= BackManage.app %>/styles'
        dest: '.tmp/styles/'
        src: '**/*.css'
      }
    }
    # Run some tasks in parallel to speed up the build process
    concurrent: {
      server: ['copy:styles']
      test: ['copy:styles']
      debug: {
        tasks: ['nodemon', 'node-inspector']
        options: {logConcurrentOutput: true}
      }
      dist: [
        'copy:styles'
        'imagemin'
        'svgmin'
        'htmlmin'
      ]
    }
    # By default, your `index.html`'s <!-- Usemin block --> will take care of
    # minification. These next options are pre-configured if you do not wish
    # to use the Usemin blocks.
    # cssmin: {
    #   dist: {
    #     files: {
    #       '<%= BackManage.dist %>/styles/main.css': [
    #         '.tmp/styles/**/*.css',
    #         '<%= BackManage.app %>/styles/**/*.css'
    #       ]
    #     }
    #   }
    # },
    # uglify: {
    #   dist: {
    #     files: {
    #       '<%= BackManage.dist %>/scripts/scripts.js': [
    #         '<%= BackManage.dist %>/scripts/scripts.js'
    #       ]
    #     }
    #   }
    # },
    # concat: {
    #   dist: {}
    # },

    # # Test settings
    # env: {
    #   test: {
    #     NODE_ENV: 'test'
    #   }
    # }
  }

  # Used for delaying livereload until after server has restarted
  grunt.registerTask 'wait', ->
    grunt.log.ok 'Waiting for server reload...'
    done = this.async()
    setTimeout ->
      grunt.log.writeln 'Done waiting!'
    , 500

  grunt.registerTask 'express-keepalive', 'Keep grunt running', -> this.async()

  grunt.registerTask 'serve', (target) ->
    return grunt.task.run ['build', 'express:prod', 'open', 'express-keepalive'] if target is 'dist'
    return grunt.task.run ['clean:server', 'bowerInstall', 'concurrent:server', 'autoprefixer', 'concurrent:debug'] if target is 'debug'
    grunt.task.run ['clean:server', 'bowerInstall', 'concurrent:server', 'autoprefixer', 'express:dev', 'open', 'watch']

  grunt.registerTask 'server', -> grunt.task.run ['serve']

  grunt.registerTask 'build', [
    'newer:jshint'
    'clean:dist'
    'bowerInstall'
    'useminPrepare'
    'concurrent:dist'
    'autoprefixer'
    'concat'
    'ngmin'
    'copy:dist'
    'cssmin'
    'uglify'
    'rev'
    'usemin'
  ]

  # grunt.registerTask 'heroku', ->
  #   grunt.log.warn 'The `heroku` task has been deprecated. Use `grunt build` to build for deployment.'
  #   grunt.task.run ['build']


  grunt.registerTask 'default', ['serve']

