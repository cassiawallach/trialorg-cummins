({
    openSendEmail : function(component, event, helper) {
        var actionAPI = component.find("quickActionAPI");
        var recordId = component.get("v.recordId");
        component.set("v.openSendEmailModal",true);
        console.log('In method');
        var args = {actionName :"WorkOrder.SendEmail", entityName: "WorkOrder"};
        actionAPI.getAvailableActionFields(args).then(function(result){
            console.log('Available Fields are ', JSON.stringify(result));
        }).catch(function(e){
            if(e.errors){
                console.log('Action Field Log Errors are ',e.errors);
                console.error('Full error is ', JSON.stringify(e));
            }
        });
    },
    sendMail: function(component, event, helper) {
        var getEmail = component.get("v.email");
        var getSubject = component.get("v.subject");
        var getbody = component.get("v.body");
        if ($A.util.isEmpty(getEmail) || !getEmail.includes("@") || !getEmail.includes(".com") ) {
           // alert('Please Enter valid Email Address');
          //component.set("v.emailValidation", true);
           // emailValidation
           var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message :$A.get("$Label.c.EVL_PartsEmailValidation"),
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
        } 
        else if($A.util.isEmpty(getbody)){
          // component.set("v.bodyValidation", true); 
            //alert('Please Enter Body');
             var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',                       
                        message :$A.get("$Label.c.EVL_PartsEmailBodyValidation"),
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
        }
        else {
            helper.sendHelper(component, getEmail, getSubject, getbody);
        }
    },
 
    closeMessage: function(component, event, helper) {
        component.set("v.mailStatus", false);
        component.set("v.email", null);
        component.set("v.subject", null);
        //component.set("v.body", null);
        $A.get("e.force:closeQuickAction").fire();
    },
    openIframe: function(component, event, helper) {
        var isopen= component.get("v.openIframe");
        if(isopen){
            component.set("v.openIframe", false);
        }else{
           component.set("v.openIframe", true); 
        }
        
     },
    
    onInputEmailChangeClick: function(component, event, helper) {
         var getEmail = component.get("v.email");
       if ($A.util.isEmpty(getEmail) || !getEmail.includes("@") || !getEmail.includes(".com") ) {
        var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message :$A.get("$Label.c.EVL_PartsEmailValidation"),
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
       }
       
    },
 
    
})