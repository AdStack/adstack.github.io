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


# pricing fixed position header
$ ->
	if $( '#pricing-label' ).length
		$header = $ '#pricing-label'
		$pricing = $ '#pricing'
		headerPosition = 0
		headerHeight = 0
		$( window ).on( 'resize', ->
			if !$header.hasClass 'fixed' then headerPosition = $header.offset().top
			headerHeight = $header.outerHeight()
		).trigger 'resize'
		$( window ).on( 'scroll', ->
			if $( window ).scrollTop() > headerPosition
				$( window ).trigger 'resize'
				$header.addClass 'fixed'
				$pricing.css 'marginTop', headerHeight + 'px'
			else
				$header.removeClass 'fixed'
				$pricing.css 'marginTop', 0
		).trigger 'scroll'