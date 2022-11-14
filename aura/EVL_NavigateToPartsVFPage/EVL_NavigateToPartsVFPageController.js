({
	handleClick : function(component, event, helper) {
        var recId = component.get('v.recordId') ;
        
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/s/"));
        
        window.open(baseURL+'/apex/EVL_ServiceOrderPartsPDFPage?id=' + recId,'_blank');
	},
    openSendEmail: function(component, evt, helper) {
        var modalBody;
         var recId = component.get("v.recordId");
        $A.createComponent("c:EVL_SendEmailParts", {
            recordId :recId,
        },
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: $A.get("$Label.c.EVL_SendEmail"),
                       //EVL_SendEmail
                       body: modalBody,
                       showCloseButton: true,
                       cssClass: "mymodal"
                      
                   })
               }
           });
    }
})