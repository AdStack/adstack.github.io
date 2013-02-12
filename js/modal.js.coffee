# ============
# Modal dialog
# ============

'use strict'

ModalFactory = ( params ) ->
	return new Modal params

Modal = ( params ) ->
	@params = params
	@show()

Modal.prototype =

	constructor: Modal

	show: ->
		if typeof @params == 'object' and @params.content and !$( '#modal' ).length
			@$modal = $( '<div id="modal" />' ).appendTo document.body
			@$modalBody = $( '<div class="modal-body" />' ).appendTo( @$modal )
				.css(
					display: 'inline-block'
					position: 'absolute'
				).html( @params.content )
				.hide().fadeIn 250
			@bindEvents()
			if typeof @params.init == 'function'
				@params.init.call this

	close: ->
		if @$modal.length
			@$modal.remove()
			@unbindEvents()

	bindEvents: ->
		_this = this
		$window = $ window

		$window.on 'keydown.modal', ( e ) ->
			if e.keyCode == 27 then _this.close()

		$window.on( 'resize.modal', ->
			dimensions =
				width: _this.$modalBody.outerWidth()
				height: _this.$modalBody.outerHeight()
			left = $window.width() / 2 - dimensions.width / 2
			top = $window.height() / 2 - dimensions.height / 2
			_this.$modalBody.css
				left: left
				top: if top < 0 then 0 else top
		).trigger( 'resize' )

	unbindEvents: ->
		$( window ).off '.modal'

# Assign Modal under the AdStack namespace
AdStack = window.AdStack or {}
AdStack.modal = ModalFactory
window.AdStack = AdStack