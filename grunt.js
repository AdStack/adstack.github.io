/*
 *  JS build script
 *  Requires grunt, grunt-contrib, grunt-contrib-watch
 */

module.exports = function ( grunt ) {

	grunt.loadNpmTasks( 'grunt-contrib' );
	grunt.loadNpmTasks( 'grunt-contrib-watch' );

	grunt.initConfig( {
		min: {
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
					"dist/base.css": "style/base.less"
				}
			}
		},
		coffee: {
			app: {
				src: [ 'js/*.coffee' ],
				dest: 'dist/adstack.js',
				options: {
					bare: false
				}
			}
		},
		watch: {
			less: {
				files: [ 'style/*.less' ],
				tasks: [ 'compile-less' ]
			},
			js: {
				files: [ 'js/*.js' ],
				tasks: [ 'compile-coffee' ]
			}
		}
	} );

	grunt.registerTask('default', 'less coffee min');
	grunt.registerTask('compile-less', 'less');
	grunt.registerTask('compile-coffee', 'coffee min');

};