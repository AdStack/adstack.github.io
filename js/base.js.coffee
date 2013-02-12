# AdStack
# Base include
# Requires: jQuery
# Author: Dali Zheng

'use strict'

Methods =
	init: ->
		@_detectSVG()
		@_cacheSelectors()
		@_bindEvents()
		@_bindPages()

	_detectSVG: ->
		svg = !!( 'createElementNS' of document and
		document.createElementNS( 'http://www.w3.org/2000/svg', 'svg' ).createSVGRect )
		if !svg then document.body.className += ' no-svg'

	_cacheSelectors: ->
		@$document = $ document
		@$window = $ window
		@$dropdowns = $ '.dropdown'
		@$pricingLabel = $ '#pricing-label'
		@$pricing = $ '#pricing'

	_bindEvents: ->
		_this = this

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

		# signup popup
		@$document.on 'click', '.signup', ( e ) ->
			AdStack.modal
				content: $( '#signup-form' ).html()
				init: ->
					_this = this
					if $( window ).width() >= 800
						@$modal.find( 'input:first-of-type' ).focus()
					@$modal.find( '.cancel' ).on 'click', ->
						_this.close()
					@$modal.find( '.send' ).on 'click', ->
						alert 'post'

	_bindPages: ->
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

AdStack = window.AdStack or {}
for i of Methods
	AdStack[i] = Methods[i]
window.AdStack = AdStack

$ ->
	window.AdStack.init()