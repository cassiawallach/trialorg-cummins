({
    handleClick : function(component, event, helper) {        
        var action = component.get("c.updateAssetDetails");       
        action.setParams({ 'serviceReqId' : component.get("v.recordId") });	
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state=='SUCCESS') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "Service Order Updated Successfully"
                });
                toastEvent.fire();
                helper.showHide(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            } 
        });
        $A.enqueueAction(action);
        
    }, 
    
    onRecordIdChange : function (component, event, helper) {
        
        var serviceOrd = component.get('v.serviceOrd');
        
        if(!serviceOrd) {
            
            helper.onRecordIdChange(component, event);
            
        }
        
    }
})