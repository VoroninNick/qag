$.fn.extend({
    contentChanged: function(options) {
        var checkForContentChanged, settings;
        settings = {
            pollPeriod: 500
        };
        settings = $.extend(settings, options);
        checkForContentChanged = function(target, stop) {
            var $this, current, e, previous;
            $this = $(target);
            previous = $this.data('lastValue');
            current = $this.val();
            $this.data('lastValue', current);
            e = $.Event('contentChanged', {
                previous: previous,
                current: current,
                hasContent: current && current !== ''
            });
            if (previous !== current) {
                $this.trigger(e);
            }
            if (!stop) {
                return $this.data('pollTimeout', setTimeout(((function(_this) {
                    return function() {
                        return checkForContentChanged(target);
                    };
                })(this)), settings.pollPeriod));
            }
        };
        return this.each(function() {
            var $this, current, onFocus;
            if (this.nodeName !== 'INPUT' && this.nodeName !== 'TEXTAREA') {
                $.error('contentChanged only works for input elements');
            }
            $this = $(this);
            $this.data('content-changed', true);
            current = $this.val();
            $this.data('lastValue', current);
            onFocus = (function(_this) {
                return function() {
                    var pollTimeout;
                    pollTimeout = $this.data('pollTimeout');
                    if (pollTimeout) {
                        clearTimeout(pollTimeout);
                    }
                    return $this.data('pollTimeout', setTimeout((function() {
                        return checkForContentChanged(_this);
                    }), settings.pollPeriod));
                };
            })(this);
            if ($this.is(':focus')) {
                onFocus();
            }
            $this.focus(onFocus);
            return $this.blur(function() {
                var pollTimeout;
                pollTimeout = $(this).data('pollTimeout');
                if (pollTimeout) {
                    clearTimeout(pollTimeout);
                }
                return checkForContentChanged(this, true);
            });
        });
    }
});

$(function() {
    if ('oninput' in document.body) {
        return $('body').on('input', function(e) {
            var $this, current, previous;
            $this = $(e.target);
            previous = $this.data('lastValue');
            current = $this.val();
            $this.data('lastValue', current);
            e = $.Event('contentChanged', {
                previous: previous,
                current: current,
                hasContent: current && current !== ''
            });
            return $this.trigger(e);
        });
    } else {
        return $('body').on('focus.content-changed', 'input, textarea', function(e) {
            var $this;
            if (this.nodeName !== 'INPUT' && this.nodeName !== 'TEXTAREA') {
                return;
            }
            $this = $(this);
            if (!$this.data('content-changed')) {
                return $this.contentChanged();
            }
        });
    }
});
