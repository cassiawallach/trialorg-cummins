({
    callFAAPI : function (component, event, helper) {
        component.set("v.showSpinner", true);
        // alert("Unable to retrieve Warranty Information. Please contact support at Guidanz@cummins.com " + event.getSource().get("v.label"));
        //component.set("v.mylabel", staticLabel);
        var action = component.get("c.getFADetails");
        action.setParams({
            'woId':component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state::'+state);
            window.setTimeout(
                $A.getCallback(function() {
                    component.set("v.showSpinner", false);
                    if (state === "SUCCESS") {
                        var storeResponse = response.getReturnValue();
                        location.reload();
            		} else if (state === "ERROR") {
                		var errors = response.getError();
                		var staticLabel = $A.get("$Label.c.FSL_Warranty_Technical");
                		if (errors) {
                    		if (errors[0] && errors[0].message) {
                        		alert("Error message: " + 
                              	errors[0].message);
                    		}
                		} else {
                    	alert("Unknown error");
                		}
            		}												
              }), 10000
        	);
        });  
        $A.enqueueAction(action);
        
    }
    ,
    doInit :  function (component, event, helper) {
        component.set("v.showSpinner", false);
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
                var staticLabel = $A.get("$Label.c.FSL_Warranty_Technical");
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });  
        $A.enqueueAction(action);
    }
});