# AdStack
# Base include
# Requires: jQuery
# Author: Dali Zheng

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
		@$productImages = $ '#product-images'

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
			analytics.track 'signup-click'
			AdStack.modal
				content: $( '#signup-form' ).html()
				validate: ->
					emailRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
					if @$modal.find( 'input[name="email"]' ).val().match emailRegex
						return true
					else
						alert 'Please enter a valid email address.'
						return false
				init: ->
					_this = this
					if $( window ).width() >= 1080
						@$modal.find( 'input[type="text"]' ).first().focus()
					@$modal.find( 'input[name="lead_source"]' ).val window.location || ''
					@$modal.find( '.cancel' ).on 'click', ->
						_this.close()
					@$modal.find( '.send' ).on 'click', ->
						if _this.params.validate.call _this
							_this.$modal.find( 'input[name="last_name"]' )
								.val( _this.$modal.find( 'input[name="email"]' ).val() )
							_this.$modal.find('form').submit()

	_bindPages: ->
		# pricing page fixed header
		if @$pricingLabel.length
			headerPosition = 0
			headerHeight = 0
			$pricingLabel = @$pricingLabel
			$pricing = @$pricing
			$window = @$window
			$window.on( 'resize orientationchange', ->
				headerHeight = $pricingLabel.height()
				if !$pricingLabel.hasClass 'fixed'
					headerPosition = $pricingLabel.offset().top
			).trigger 'resize'
			$window.on( 'scroll touchmove', ->
				if $window.scrollTop() > headerPosition
					$window.trigger 'resize'
					$pricingLabel.addClass 'fixed'
					$pricing.css 'marginTop', headerHeight + 'px'
				else
					$pricingLabel.removeClass 'fixed'
					$pricing.css 'marginTop', 0
			).trigger 'scroll'
		# liveoptimizer page height ratio
		if @$productImages.length
			$imageContainer = @$productImages.find '.image-container'
			$( window ).on( 'resize', ->
				width = $imageContainer.width()
				$imageContainer.css 'height', ( width * 0.206 ) + 'px'
			).trigger 'resize'


window.AdStack = window.AdStack or {}
for i of Methods
	window.AdStack[i] = Methods[i]

$ ->
	window.AdStack.init()