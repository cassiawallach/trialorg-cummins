'use strict';

function renderRTLElsDirection(val) {

  var direction = window.parent.document.querySelector('html').getAttribute('dir');
  if (direction === 'rtl') {
    $(val).attr("dir", "rtl");
    // var rtlDirectionEls = window.parent.document.getElementsByClassName('LightboxContainer');
    // var rtlChildren =  Array.from(rtlDirectionEls).length > 0 ?  Array.from(rtlDirectionEls[0].children) : null;
    // console.log(rtlChildren, 'children');
    // if(rtlChildren) {
    //      rtlChildren.forEach(el => {
    //         if($(el).prop('tagName') == 'IFRAME') {
    //            var docEl = el.contentDocument || el.contentWindow.document;
    //            $(docEl).attr("dir", "rtl");
    //      }
    //   })

    //  }
  }
};