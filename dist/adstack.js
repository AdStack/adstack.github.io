(function() {
  var Methods, i;

  Methods = {
    init: function() {
      this._detectSVG();
      this._cacheSelectors();
      this._bindEvents();
      return this._bindPages();
    },
    _detectSVG: function() {
      var svg;

      svg = !!('createElementNS' in document && document.createElementNS('http://www.w3.org/2000/svg', 'svg').createSVGRect);
      if (!svg) {
        return document.body.className += ' no-svg';
      }
    },
    _cacheSelectors: function() {
      this.$document = $(document);
      this.$window = $(window);
      this.$dropdowns = $('.dropdown');
      this.$pricingLabel = $('#pricing-label');
      this.$pricing = $('#pricing');
      this.$about = $('#about');
      return this.$productImages = $('#product-images');
    },
    _bindEvents: function() {
      var $dropdowns, _this;

      _this = this;
      this.$document.on('click', 'a[href="#"]', function(e) {
        return e.preventDefault();
      });
      $dropdowns = this.$dropdowns;
      $dropdowns.click(function(e) {
        e.preventDefault();
        e.stopPropagation();
        return $(this).toggleClass('open');
      });
      $dropdowns.find('a:not([href="#"])').click(function(e) {
        return e.stopPropagation();
      });
      this.$document.on('click', function() {
        return $dropdowns.removeClass('open');
      });
      this.$document.on('click', '.signup', function(e) {
        analytics.track('signup-click');
        return AdStack.Modal({
          content: $('#signup-form').html(),
          validate: function() {
            var emailRegex;

            emailRegex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            if (!this.$modal.find('input[name="name"]').val().length || !this.$modal.find('input[name="name"]').val().match(/\ /g)) {
              alert('Please enter your full name.');
              return false;
            }
            if (!this.$modal.find('input[name="email"]').val().match(emailRegex)) {
              alert('Please enter a valid email address.');
              return false;
            }
            if (!this.$modal.find('input[name="company"]').val().length) {
              alert('Please enter your company.');
              return false;
            }
            return true;
          },
          init: function() {
            _this = this;
            if ($(window).width() >= 1080) {
              this.$modal.find('input[type="text"]').first().focus();
            }
            this.$modal.find('input[name="lead_source"]').val(window.location || '');
            this.$modal.find('.cancel').on('click', function() {
              return _this.close();
            });
            return this.$modal.find('.send').on('click', function() {
              var nameArray;

              if (_this.params.validate.call(_this)) {
                nameArray = _this.$modal.find('input[name="name"]').val().split(' ');
                _this.$modal.find('input[name="first_name"]').val(nameArray[0]);
                _this.$modal.find('input[name="last_name"]').val(nameArray[1]);
                return _this.$modal.find('form').submit();
              }
            });
          }
        });
      });
      return $(document).on('mouseover touchstart', '.member [title]', function() {
        analytics.track('member-mouseover', {
          name: $(this).attr('alt')
        });
        return new AdStack.Tooltip({
          element: this,
          boundingBox: '.row'
        });
      });
    },
    _bindPages: function() {
      var $imageContainer, $pricing, $pricingLabel, $window, headerHeight, headerPosition;

      if (this.$pricingLabel.length) {
        headerPosition = 0;
        headerHeight = 0;
        $pricingLabel = this.$pricingLabel;
        $pricing = this.$pricing;
        $window = this.$window;
        $window.on('resize orientationchange', function() {
          headerHeight = $pricingLabel.height();
          if (!$pricingLabel.hasClass('fixed')) {
            return headerPosition = $pricingLabel.offset().top;
          }
        }).trigger('resize');
        $window.on('scroll touchmove', function() {
          if ($window.scrollTop() > headerPosition) {
            $window.trigger('resize');
            $pricingLabel.addClass('fixed');
            return $pricing.css('marginTop', headerHeight + 'px');
          } else {
            $pricingLabel.removeClass('fixed');
            return $pricing.css('marginTop', 0);
          }
        }).trigger('scroll');
      }
      if (this.$productImages.length) {
        $imageContainer = this.$productImages.find('.image-container');
        return $(window).on('resize', function() {
          var width;

          width = $imageContainer.width();
          return $imageContainer.css('height', (width * 0.204) + 'px');
        }).trigger('resize');
      }
      /*
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
      */

    }
  };

  window.AdStack = window.AdStack || {};

  for (i in Methods) {
    AdStack[i] = Methods[i];
  }

  $(function() {
    return AdStack.init();
  });

}).call(this);

(function() {
  var Modal, ModalFactory;

  Modal = (function() {
    function Modal(params) {
      this.params = params;
      this.show();
    }

    Modal.prototype.show = function() {
      if (typeof this.params === 'object' && this.params.content && !this.$modal) {
        this.$modal = $('<div id="modal" />').appendTo(document.body);
        this.$modalBody = $('<div class="modal-body" />').appendTo(this.$modal).css({
          display: 'inline-block',
          position: 'absolute',
          opacity: 0.01
        }).html(this.params.content).animate({
          'opacity': 1
        }, 200);
        this.bindEvents();
        if (typeof this.params.init === 'function') {
          return this.params.init.call(this);
        }
      }
    };

    Modal.prototype.close = function() {
      if (this.$modal) {
        this.$modal.remove();
        this.$modal = void 0;
        return this.unbindEvents();
      }
    };

    Modal.prototype.toggle = function() {
      if (this.$modal) {
        return this.close();
      } else {
        return this.show();
      }
    };

    Modal.prototype.bindEvents = function() {
      var $window, _this;

      _this = this;
      $window = $(window);
      $window.on('keydown.modal', function(e) {
        if (e.keyCode === 27) {
          return _this.close();
        }
      });
      return $window.on('resize.modal', function() {
        var $modalBody, dimensions, left, top;

        $modalBody = _this.$modalBody;
        dimensions = {
          width: parseInt($modalBody.width(), 10) + parseInt($modalBody.css('border-left-width'), 10) * 2,
          height: parseInt($modalBody.height(), 10) + parseInt($modalBody.css('border-top-width'), 10) * 2
        };
        left = $window.width() / 2 - dimensions.width / 2;
        top = $window.height() / 2 - dimensions.height / 2;
        return $modalBody.css({
          left: left,
          top: top < 0 ? 0 : top
        });
      }).trigger('resize');
    };

    Modal.prototype.unbindEvents = function() {
      return $(window).off('.modal');
    };

    return Modal;

  })();

  ModalFactory = function(params) {
    return new Modal(params);
  };

  window.AdStack = window.AdStack || {};

  AdStack.Modal = ModalFactory;

}).call(this);

(function() {
  var Tooltip;

  Tooltip = (function() {
    function Tooltip(params) {
      if (typeof params === 'object') {
        this.$this = $(params.element);
        this.title = typeof this.$this.attr('data-title') === 'string' ? this.$this.attr('data-title') : this.$this.attr('title');
        this.$boundingBox = this.$this.parents(params.boundingBox).first();
        this.arrowSize = params.arrowSize || 17;
        this.show();
      }
    }

    Tooltip.prototype.show = function() {
      this.$this.attr('data-title', this.title);
      this.$this.attr('title', '');
      this.$tooltip = $('<div class="tooltip" />').appendTo(document.body);
      $('<p>' + this.title + '</p>').appendTo(this.$tooltip);
      this.$arrow = $('<div class="arrow" />').appendTo(this.$tooltip);
      this.position();
      this.bindEvents();
      return this.$tooltip.animate({
        opacity: 1
      }, 150);
    };

    Tooltip.prototype.position = function() {
      var xOffset, yOffset;

      xOffset = this.$this.offset().left + this.$this.width() / 2 - this.$tooltip.width() / 2;
      if (xOffset < this.$boundingBox.offset().left) {
        xOffset = this.$boundingBox.offset().left;
        this.$arrow.css('left', (this.$this.offset().left - this.$boundingBox.offset().left + this.$this.width() / 2) + 'px');
      }
      if (this.$this.offset().left + this.$tooltip.width() / 2 > this.$boundingBox.offset().left + this.$boundingBox.width()) {
        xOffset = this.$boundingBox.offset().left + this.$boundingBox.width() - this.$tooltip.width();
        this.$arrow.css({
          left: 'auto',
          right: (this.$boundingBox.offset().left + this.$boundingBox.width() - this.$this.offset().left - this.$this.width() + this.$this.width() / 2) + 'px'
        });
      }
      yOffset = this.$this.offset().top - this.$tooltip.height() - this.arrowSize;
      return this.$tooltip.css({
        opacity: 0.01,
        left: xOffset,
        top: yOffset
      });
    };

    Tooltip.prototype.bindEvents = function() {
      var _this;

      _this = this;
      return this.$this.on('mouseout touchend', function() {
        return _this.destroy();
      });
    };

    Tooltip.prototype.destroy = function() {
      this.$tooltip.remove();
      this.$this.attr('title', this.$this.attr('data-title'));
      return delete this;
    };

    return Tooltip;

  })();

  window.AdStack = window.AdStack || {};

  AdStack.Tooltip = Tooltip;

}).call(this);
