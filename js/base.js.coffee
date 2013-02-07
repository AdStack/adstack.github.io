# AdStack
# Base include
# Requires: jQuery
# Author: Dali Zheng


# svg detection
svg = !!( 'createElementNS' of document and
	document.createElementNS( 'http://www.w3.org/2000/svg', 'svg' ).createSVGRect )
if !svg then document.body.className += ' no-svg'