# AdStack
# Base include
# Requires: jQuery
# Author: Dali Zheng


# svg detection
svg = !!( 'createElementNS' of document and
	document.createElementNS( 'http://www.w3.org/2000/svg', 'svg' ).createSVGRect )
if !svg then document.body.className += ' no-svg'

# suppress blank hash links
$( document ).on 'click', 'a[href="#"]', ( e ) ->
	e.preventDefault()

# dropdowns
$( document ).on 'click', '.dropdown', ( e ) ->
	e.preventDefault()
	e.stopPropagation()
	$( this ).toggleClass 'open'

$( document ).on 'click', '.dropdown a', ( e ) ->
	e.stopPropagation()

$( document ).on 'click', ->
		$( '.dropdown' ).removeClass 'open'