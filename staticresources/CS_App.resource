var App = function () {

    function handleMenuHover() {
        jQuery('#nav > li:not(.divider)').hover(function (e) {
            var $this = jQuery(this),
                $fellowItems = ($('.navbar .open').length === 0) ? $this.siblings('.current').children('a') : $('.navbar .open .current');

            $this.siblings('.divider').removeClass('border-hidden');
            $this.prev('.divider').addClass('border-hidden').end().next('.divider').addClass('border-hidden');

            if ($fellowItems.length && e.type === 'mouseenter') {
                if ($('.nav-collapse.in').length)
                    $fellowItems.css({'background-color': '#DC2028'});
                else
                    $fellowItems.css({'background-color': 'transparent'});
            } else if (e.type === 'mouseleave') {
                $fellowItems.css({'background-color': '#990000'});
                $this.siblings('.divider').removeClass('border-hidden');
            }
        });
    }

    return {
        init: function () {
            handleMenuHover();
        }
    };
}();