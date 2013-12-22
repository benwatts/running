module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    sass: {
      dist: {
        options: {
          style: 'expanded',
          debugInfo: true,
          lineNumbers: false
        },
        files: {
          'css/build/style.css': 'css/style.scss'
        }
      }
    },

    coffee: {
      compileJoinedWithMaps: {
        options: {
          sourceMap: true,
          join: true
        },
        files: {
          'js/build/app.js': 'js/*.coffee'
        }
      }
    },

    watch: {
      options: {
        livereload: true
      },
      css: {
        files: ['css/*.scss'],
        tasks: ['sass'],
        options: {
          spawn: false
        }
      },
      js: {
        files: ['js/*.coffee'],
        tasks: ['coffee'],
        options: {
          spawn: false
        }
      },
      html: {
        files: ['index.html']
      },
      gruntfile: {
        files: ['Gruntfile.js']
      }
    },

  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-livereload');
  grunt.loadNpmTasks('grunt-contrib-sass');
  //grunt.loadNpmTasks('grunt-contrib-uglify');

  grunt.registerTask('default', ['watch', 'sass', 'coffee', 'livereload']);

};
