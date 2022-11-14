function showMenu(id){
	$(".tab-content").css("display","none");
	$("#"+id+"_content").css("display","block");
	$('.headermenu').removeClass('selectedTab');
	$("#"+id+"-menu").addClass('selectedTab');
	clearFormDtls();
	clearSuggestionFormDtls();
	$('.alert').css('display','none');
	
	 
}

function authenticateUser(){
	 var username = document.getElementById('username').value;
	   document.forms['loginForm'].action = "./login.do?username="+username;      
	   document.forms['loginForm'].submit();   
}





function updateUserPollResponse(){
	var pollResponse = $('input:radio[name=pollResponse]:checked').val();
	
	$.ajax({
		type: "POST",
		url : "updateUserPollResponse.do?pollResponse="+pollResponse,
		success : function(result) {
			if(result == 'Success'){
				$('#poll_success').css('display','block');
				$('#poll_results').css('display','block');
				$('#poll_question').css('display','none');
				pollResults();
				window.location.reload(true);
			}
			else{
				
			}
		}
	});
}



