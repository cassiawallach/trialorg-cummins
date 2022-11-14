var App = function () {

    function handleSearch() {
        jQuery('.search').click(function () {
            if (jQuery('.search-btn').hasClass('icon-search')) {
                jQuery('.search-open').fadeIn(500);
                jQuery('.search-btn').removeClass('icon-search');
                jQuery('.search-btn').addClass('icon-remove');
            } else {
                jQuery('.search-open').fadeOut(500);
                jQuery('.search-btn').addClass('icon-search');
                jQuery('.search-btn').removeClass('icon-remove');
            }
        });
    }
}();