({
    retryClick : function (component, event, helper) {
        console.log('::: Retry Called');
        helper.showSpinner(component);
        var action = component.get('c.callFieldActionsService');
        console.log('::: after Retry Called');
        
        action.setParams({
            'woId':component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('sr state::'+state);
            //alert('state:'+state);
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('sr storeResponse::'+storeResponse);
            }else if (state === "ERROR") {
                var errors = response.getError();
                //var staticLabel = $A.get("$Label.c.FSL_Warranty_Technical");
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //alert("Error message: " + errors[0].message);
                    }
                } else {
                    //alert("Unknown error");
                }
            }
            helper.hideSpinner(component);
            //$A.get('e.force:refreshView').fire();
        });  
        $A.enqueueAction(action);
        location.reload();
    },
    
    doInit :  function (component, event, helper) {
        var action = component.get("c.getWorkOrderInfo");
        action.setParams({
            'woId':component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.wo",storeResponse);
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //alert("Error message: " + errors[0].message);
                    }
                } else {
                    //alert("Unknown error");
                }
            }
        });  
        $A.enqueueAction(action);
    }
    
    
})