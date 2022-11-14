// JavaScript Document


//copyright info end

/* file name: commonAll.js

this file cointains the scripts common to all pages in the site

*/

/*document.write('<div id="loading"><br><br>Loading&nbsp;document.&nbsp;Please&nbsp;wait...<br><br> <img src="../images/processing_circle.gif" border="0"></div>');*/


$(document).ready(function(){

	var f=document.createElement("link");
	f.setAttribute("id","favicon");
	f.setAttribute("rel","shortcut icon");
	f.setAttribute("href","../images/favicon.ico");
	document.getElementsByTagName("head")[0].appendChild(f);
	$("#logoDiv").css("cursor","pointer");
	
	/*$("#logoDiv").css("cursor","pointer").click(function(){
				window.location.replace("#");	 
	})*/
})

function changeClass(obj, className){
	obj.className = className;	
}

$(window).load(function() { 
	if($('#loading').length > 0){
		$('#loading').fadeOut(100); 
	}
}); 


//$(function(){
	//$(this).bind("contextmenu", function(e) {e.preventDefault();});
//});



$(function(){
 var adjustHt = 24;					
 var headerHt= $('#headerHolder').height();
 var footerHt= $('.copyrightDiv').height();
 if($('#footerContent').length > 0) footerHt = $('#footerContent').height() + $('.copyrightDiv').height();
 else adjustHt = 24;	

 var commonHeight = headerHt + footerHt + adjustHt ;
 var contentDivHeight = $(window).height() - commonHeight;
 $('.contentDiv').css('min-height', contentDivHeight) ;
});

$(window).resize(function() {
 var adjustHt = 24;					
 var headerHt= $('#headerHolder').height();
 var footerHt= $('.copyrightDiv').height();
 if($('#footerContent').length > 0) footerHt = $('#footerContent').height() + $('.copyrightDiv').height();

 //alert(sliderheight)
 var commonHeight = headerHt + footerHt + adjustHt ;
 var contentDivHeight = $(window).height() - commonHeight;
 $('.contentDiv').css('min-height', contentDivHeight) ;
});


$(function(){
	if($('.printPage').length > 0) $('.printPage').click(function(){window.print(); return false;})
	
	if($('.recommendPage').length > 0){		
		$('.recommendPage').click(function(){
				tb_open_new('popUpRecomend.html?keepThis=true&TB_iframe=true&height=300&width=600','Recomend this page');
				//alert($('.mailcontent').html())
				return false;
				})
	}
	if($('.feedbackPage').length > 0){		
		$('.feedbackPage').click(function(){
				tb_open_new('popUpFeedback.html?keepThis=true&TB_iframe=true&height=290&width=500','Send Feedback'); return false;
				})
	}
	
		   
})

function equalHeight(group) {
  tallest = 0;
  group.each(function() {
    thisHeight = $(this).height();
    if(thisHeight > tallest) {
      tallest = thisHeight;
    }
  });
  group.css("min-height",tallest);
}

