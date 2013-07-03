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
		@$about = $ '#about'
		@$productImages = $ '#product-images'

	_bindEvents: ->
		_this = this
		_emailRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

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

		# mailto form
		@$document.on 'click', 'a[href^="#mailto:"]', ( e ) ->
			e.preventDefault()
			analytics.track 'mailto-click'
			subject = decodeURIComponent( $( this ).attr( 'href' ).split( '?' )[ 1 ] )
				.split( '=' )[ 1 ]

			AdStack.Modal

				content: $( '#mailto-form' ).html()

				validate: ->
					if !@$modal.find('input[name="email"]').val().match _emailRegex
						alert 'Please enter a valid email address.'
						return false
					true

				init: ->
					_this = this
					if $( window ).width() >= 1080
						@$modal.find( 'input[type="text"]' ).first().focus()
						@$modal.find( 'input[name="lead_source"]' ).val window.location || ''
						@$modal.find( '.cancel' ).on 'click', ->
							_this.close()
						@$modal.find( '.send' ).on 'click', ->
							if _this.params.validate.call _this
								_this.$modal.find('input[name="company"]').val(subject)
								_this.$modal.find('form').submit()

		# signup popup
		@$document.on 'click', '.signup', ( e ) ->
			analytics.track 'signup-click',
				page: window.location.href
			AdStack.Modal

				content: $( '#signup-form' ).html()

				validate: ->
					if !@$modal.find( 'input[name="name"]' ).val().length || !@$modal.find( 'input[name="name"]' ).val().match(/\ /g)
						alert 'Please enter your full name.'
						return false
					if !@$modal.find( 'input[name="email"]' ).val().match _emailRegex
						alert 'Please enter a valid email address.'
						return false
					if !@$modal.find( 'input[name="company"]' ).val().length
						alert 'Please enter your company.'
						return false
					true

				init: ->
					_this = this
					if $( window ).width() >= 1080
						@$modal.find( 'input[type="text"]' ).first().focus()
					@$modal.find( 'input[name="lead_source"]' ).val window.location || ''
					@$modal.find( '.cancel' ).on 'click', ->
						_this.close()
					@$modal.find( '.send' ).on 'click', ->
						if _this.params.validate.call _this
							nameArray = _this.$modal.find( 'input[name="name"]' ).val().split(' ')
							_this.$modal.find( 'input[name="first_name"]' )
								.val( nameArray[0] )
							_this.$modal.find( 'input[name="last_name"]' )
								.val( nameArray[1] )
							_this.$modal.find('form').submit()

		# tooltips
		$(document).on 'mouseover touchstart', '.member [title]', ->

			analytics.track 'member-mouseover',
				name: $(this).attr 'alt'

			new AdStack.Tooltip
				element: this
				boundingBox: '.row'

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
				$imageContainer.css 'height', ( width * 0.21 ) + 'px'
			).trigger 'resize'

		# randomize team member order
		###
		if @$about.length
			$members = $ '.member'
			rowCount = [0..$( '.member-row' ).first().children().length - 1]

			# cut off the blank one
			$last = $members.eq(-1).clone()
			$members = $members.not $members.eq -1

			$clone = $members.clone()

			# fisher-yates algorithm
			randomArray = [0..$members.length - 1]
			for i in randomArray
				r = Math.floor Math.random() * $members.length
				e = randomArray[i]
				randomArray[i] = randomArray[r]
				randomArray[r] = e

			$( '.member-row' ).each (t) ->
				$this = $ this
				$this.empty()
				for z in rowCount
					$this.append $clone.eq randomArray[t * rowCount.length + z]

			$( '.member-row' ).last().append $last
		###


window.AdStack = window.AdStack or {}

for i of Methods
	AdStack[i] = Methods[i]

$ ->
	AdStack.init()