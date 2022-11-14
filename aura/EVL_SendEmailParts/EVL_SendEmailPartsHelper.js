({
    sendHelper: function(component, getEmail, getSubject, getbody) {
        // call the server side controller method 	
        var action = component.get("c.sendMailMethod");
        // set the 3 params to sendMailMethod method 
          console.log(getEmail);
        console.log(getSubject);
        console.log(getbody);
        console.log(component.get("v.recordId"));
        action.setParams({
            'mMail': getEmail,
            'mSubject': getSubject,
            'mbody': getbody,
            'recordId':component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if state of server response is comes "SUCCESS",
                // display the success message box by set mailStatus attribute to true
                if(storeResponse){
                    component.set("v.mailStatus", true);
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'There is an Error sending Email',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                
            }else{
                console.log('TEstfail');
            }
 
        });
        $A.enqueueAction(action);
    },
})