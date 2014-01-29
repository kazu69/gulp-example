# http://markgoodyear.com/2014/01/getting-started-with-gulp/

gulp = require 'gulp'

# Load plugins
sass = require 'gulp-ruby-sass'
autoprefixer = require 'gulp-autoprefixer'
minifycss = require 'gulp-minify-css'
jshint = require 'gulp-jshint'
uglify = require 'gulp-uglify'
imagemin = require 'gulp-imagemin'
rename = require 'gulp-rename'
clean = require 'gulp-clean'
concat = require 'gulp-concat'
notify = require 'gulp-notify'
cache = require 'gulp-cache'
livereload = require 'gulp-livereload'
lr = require 'tiny-lr'
server = lr();

# Styles
gulp.task 'styles', ->
  gulp.src('src/**/*.scss')
  .pipe sass({ style: 'expanded' })
  .pipe autoprefixer('last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4')
  .pipe gulp.dest('dist/assets/css')
  .pipe rename({suffix: '.min'})
  .pipe minifycss()
  .pipe gulp.dest('dist/assets/css')
  .pipe livereload(server)
  .pipe notify({ message: 'Styles task complete' })

# Scripts
gulp.task 'scripts', ->
  gulp.src('src/scripts/**/*.js')
  .pipe jshint('.jshintrc')
  .pipe jshint.reporter('default')
  .pipe concat('main.js')
  .pipe gulp.dest('dist/assets/js')
  .pipe rename({suffix: '.min'})
  .pipe uglify()
  .pipe gulp.dest('dist/assets/js')
  .pipe livereload(server)
  .pipe notify({ message: 'Scripts task complete' })

# Images
gulp.task 'images', ->
  gulp.src('src/images/**/*')
  .pipe imagemin({ optimizationLevel: 3, progressive: true, interlaced: true })
  .pipe gulp.dest('dist/assets/img')
  .pipe livereload(server)
  .pipe notify({ message: 'Images task complete' })

# Celan
gulp.task 'clean', ->
  gulp.src(['dist/assets/css', 'dist/assets/js', 'dist/assets/img'], { read: false })
  .pipe clean()

# Default task
gulp.task 'default', ['clean'], ->
  gulp.run 'styles', 'scripts', 'images'

# Watch
gulp.task 'watch', ->
  #Watch .scss files
  gulp.watch 'src/styles/**/*.scss', (event) ->
    console.log "File #{event.path} was #{event.type}, running tasks..."
    gulp.run 'styles'

  # Watch .js files
  gulp.watch 'src/scripts/**/*.js', (event) ->
    console.log "File #{event.path} was #{event.type}, running tasks..."
    gulp.run 'scripts'

  # Watch image files
  gulp.watch 'src/images/**/*', (event) ->
    console.log "File #{event.path} was #{event.type}, running tasks..."
    gulp.run 'images'

  # Listen on port 35729
  server.listen 35729, (error) ->
    console.log error if error
