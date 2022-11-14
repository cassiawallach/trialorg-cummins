({
	openActionWindow : function(component, event, helper) {
        var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};
		var lang = getUrlParameter('language');
        var dynamicurl = $A.get("$Label.IDM_checkpassword");
         
        window.open('https://cumminscss.force.com/cd/cummins_login_pc?appid=a1a61000009Hdbm&language='+lang+'/services/oauth2/authorize?client_id=3MVG9KI2HHAq33RwAXm3BYDBT4F56kjWAKj31LxJBoTSSJDzmNkseWHgqPxMwja1sJk4naT7J6yCOE0TL2joT&redirect_uri=connecteddiagnostics://mobilesdk/detect/oauth/done&display=touch&response_type=token','_self');
	}
})