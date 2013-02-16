# ============
# Modal dialog
# ============

class Modal
	constructor: ( @params ) ->
		@show()

	show: ->
		if typeof @params == 'object' and @params.content and !@$modal
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
		if @$modal
			@$modal.remove()
			@$modal = undefined
			@unbindEvents()

	toggle: ->
		if @$modal then @close() else @show()

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

# convenience method to instantiate modal objects
ModalFactory = ( params ) ->
	new Modal params

# Assign Modal under the AdStack namespace
window.AdStack = window.AdStack or {}
window.AdStack.modal = ModalFactory