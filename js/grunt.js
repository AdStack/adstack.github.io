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
				src: [ '../dist/adstack.js' ],
				dest: '../dist/adstack.js'
			}
		},
		less: {
			production: {
				options: {
					yuicompress: true
				},
				files: {
					"../dist/base.css": "../style/base.less"
				}
			}
		},
		coffee: {
			app: {
				src: [ '*.coffee' ],
				dest: '../dist/adstack.js',
				options: {
					bare: false
				}
			}
		},
		watch: {
			src: {
				files: [ '*.js', '../style/*.less' ],
				tasks: [ 'default' ]
			}
		}
	} );

	grunt.registerTask('default', 'less coffee min');

};