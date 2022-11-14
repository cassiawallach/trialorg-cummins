function responsiveMobileMenu() {
    $('.rmm').each(function () {
        $(this).children('ul').addClass('rmm-main-list');	// mark main menu list
        var $style = $(this).attr('data-menu-style');	// get menu style
        if (typeof $style == 'undefined' || $style == false) {
            $(this).addClass('graphite'); // set graphite style if style is not defined
        }
        else {
            $(this).addClass($style);
        }


        /* 	width of menu list (non-toggled) */

        var $width = 0;
        $(this).find('ul li').each(function () {
            $width += $(this).outerWidth();
        });
        if ($width == 0) {
            $width = 1023;
        }
        // if modern browser

        if ($.support.leadingWhitespace) {
            $(this).css('max-width', $width * 1.30 + 'px');
        }
        //
        else {
            $(this).css('width', $width * 1.30 + 'px');
        }
    });
}
function getMobileMenu() {

    /* 	build toggled dropdown menu list */

    $('.rmm').each(function () {
        var menutitle = $(this).attr("data-menu-title");
        if (menutitle == "") {
            menutitle = "Menu";
        }
        else if (menutitle == undefined) {
            menutitle = "Menu";
        }
        var $menulist = $(this).children('.rmm-main-list').html();
        var $menucontrols = "<div class='rmm-toggled-controls'><div class='rmm-toggled-title'>" + menutitle + "</div><div class='rmm-button'></div></div>";
        $(this).prepend("<div class='rmm-toggled rmm-closed'>" + $menucontrols + "<ul class='box-shadow'>" + $menulist + "</ul></div>");

    });
}

function adaptMenu() {

    /* 	toggle menu on resize */

    $('.rmm').each(function () {
        var $width = $(this).css('max-width');
        $width = $width.replace('px', '');
        if ($(this).parent().width() < $width * 1.05) {
            $(this).children('.rmm-main-list').hide(0);
            $(this).children('.rmm-toggled').show(0);
        }
        else {
            $(this).children('.rmm-main-list').show(0);
            $(this).children('.rmm-toggled').hide(0);
        }
    });

}

$(function () {

    responsiveMobileMenu();
    getMobileMenu();
    adaptMenu();

    /* slide down mobile menu on click */

    /* TJG EDIT
     $('.rmm-toggled, .rmm-toggled .rmm-button').click(function(){
     if ( $(this).is(".rmm-closed")) {
     $(this).find('ul').stop().show(300);
     $(this).removeClass("rmm-closed");
     }

     else {
     $(this).find('ul').stop().hide(300);
     $(this).addClass("rmm-closed");
     }

     }); */

    // We rewrote this function to get rid of the menu "hiding" when you click an element.
    // it wasn't a big issue until you want to show a submenu after a click, then it becomes
    // an annoyance.
    $('.rmm-toggled .rmm-button').click(function () {
        // The previous function actually never clicked the "button".  If it had, the menu wouldn't work.
        // The clicked actually occured on the menu div.  We removed the menu div click in the selector
        // above, so now we need to get that div to make the following code work.
        var menuParent = $(this).closest(".rmm-toggled");
        if ($(menuParent).is(".rmm-closed")) {
            $(menuParent).find('ul.box-shadow').stop().show(300);
            $(menuParent).removeClass("rmm-closed");
        }

        else {
            $(menuParent).find('ul').stop().hide(300);
            $(menuParent).addClass("rmm-closed");
        }

    });


    /* TJG ADDED */
    // Hides menu on mouseout
    //$('.rmm-toggled').on("mouseleave", function(){
    //	$('.rmm-toggled .rmm-button').click();
    //});

    /*WDF Edit */
    // Removed the click handler as it was simulating a click whenever your mouse left the .rmm-button container.
    // This was causing the menu to open and close whenever you moved your mouse over that container even if it was hidden.
    // Changed the class that was being targeted to the dropdown itself.
    // Added hide effect to the .box-shadow on mouseleave.
    // Added another function with the toggleClass action to add the .rmm-closed class to the menu.
    // This was to prevent having to click the hamburger icon twice after initial close, to re-show the menu.

    $('.rmm-toggled').on("mouseleave", function () {
        $('.rmm-toggled .box-shadow').hide();
        $('.rmm-toggled').toggleClass('rmm-closed');
    });
    // Along with css changes, has submenu open on click
    $(".box-shadow li.has-subnav > a").on("click", function (e) {
        //$(this).parent().toggleClass("open");
        $(this).siblings("ul").toggle();
        e.preventDefault();
    });

});

/* 	hide mobile menu on resize */
$(window).resize(function () {
    adaptMenu();
});