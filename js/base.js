/*
 *  AdStack
 *  Base include
 *  Requires: jQuery
 *  Author: Dali Zheng
 */

( function () {
	
	var _root = this;

	// svg detection
	var svg = !!( 'createElementNS' in document &&
		document.createElementNS( 'http://www.w3.org/2000/svg', 'svg' ).createSVGRect );
	if (!svg) document.body.className += ' no-svg';

} ).call( this );