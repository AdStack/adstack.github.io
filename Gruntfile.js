module.exports = function ( grunt ) {

	grunt.initConfig( {
		uglify: {
			dist: {
				src: [ 'dist/adstack.js' ],
				dest: 'dist/adstack.js'
			}
		},
		less: {
			production: {
				options: {
					yuicompress: true
				},
				files: {
					'dist/base.css': 'style/base.less'
				}
			}
		},
		coffee: {
			compile: {
				files: {
					'dist/adstack.js': [ 'js/*.coffee' ]
				},
				options: {
					bare: false
				}
			}
		},
		watch: {
			less: {
				files: [ 'style/*.less' ],
				tasks: 'less'
			},
			js: {
				files: [ 'js/*.coffee' ],
				tasks: [ 'coffee', 'uglify' ]
			}
		}
	} );

	grunt.loadNpmTasks( 'grunt-contrib-less' );
	grunt.loadNpmTasks( 'grunt-contrib-coffee' );
	grunt.loadNpmTasks( 'grunt-contrib-uglify' );
	grunt.loadNpmTasks( 'grunt-contrib-watch' );

	grunt.registerTask( 'default', ['less', 'coffee', 'uglify'] );

};