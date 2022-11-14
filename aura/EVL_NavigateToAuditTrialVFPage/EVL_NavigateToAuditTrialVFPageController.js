({
	handleClick : function(component, event, helper) {
        var recId = component.get('v.recordId') ;
        
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/"));
        
        window.open(baseURL+'/apex/EVL_ServiceOrderAuditTrialPDFPage?id=' + recId,'_blank');
	}
})