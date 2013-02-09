# AdStack
# Base include
# Requires: jQuery
# Author: Dali Zheng


# AdStack namespace
AdStack =

	init: ->
		@detectSVG()
		@cacheSelectors()
		@bindEvents()
		@bindPages()

	detectSVG: ->
		svg = !!( 'createElementNS' of document and
		document.createElementNS( 'http://www.w3.org/2000/svg', 'svg' ).createSVGRect )
		if !svg then document.body.className += ' no-svg'

	cacheSelectors: ->
		@$document = $ document
		@$window = $ window
		@$dropdowns = $ '.dropdown'
		@$pricingLabel = $ '#pricing-label'
		@$pricing = $ '#pricing'

	bindEvents: ->
		# suppress blank hash links
		@$document.on 'click', 'a[href="#"]', ( e ) ->
			e.preventDefault()
		# dropdowns
		$dropdowns = @$dropdowns
		$dropdowns.click ( e ) ->
			e.preventDefault()
			e.stopPropagation()
			$( this ).toggleClass 'open'
		$dropdowns.find( 'a:not([href="#"])' ).click ( e ) ->
			e.stopPropagation()
		@$document.on 'click', ->
			$dropdowns.removeClass 'open'

	bindPages: ->
		# pricing page fixed header
		if @$pricingLabel.length
			headerPosition = 0
			headerHeight = 0
			$pricingLabel = @$pricingLabel
			$pricing = @$pricing
			$window = @$window
			$window.on( 'resize', ->
				headerHeight = $pricingLabel.outerHeight()
				if !$pricingLabel.hasClass 'fixed'
					headerPosition = $pricingLabel.offset().top
			).trigger 'resize'
			$window.on( 'scroll', ->
				if $window.scrollTop() > headerPosition
					$window.trigger 'resize'
					$pricingLabel.addClass 'fixed'
					$pricing.css 'marginTop', headerHeight + 'px'
				else
					$pricingLabel.removeClass 'fixed'
					$pricing.css 'marginTop', 0
			).trigger 'scroll'

$ ->
	AdStack.init()