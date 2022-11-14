({
    
    hideSpinner : function(component,event,helper){
    	// make Spinner attribute to false for hide loading spinner    
    	component.set("v.Spinner", false);
	},
        //doInit : function(component, event, helper) { --Commented and changed the name of the method By RAJESH PASUPULETI based on CHF-1519
    callMROMessage : function(component, event, helper) {
        var action = component.get("c.getMROMessage");
        if(typeof action === "undefined") {
            console.log('::: undefined action');
        } else {
            action.setParams({
                "serviceJob": component.get("v.recordId") 
            });
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    component.set("v.MROMessages", response.getReturnValue());
                    component.set("v.showSpinner", false);
                    //if(!(response.getReturnValue().length > 0)) {
                        //console.log('::: Recursive Call happen');
                        //this.doInit(component, event, helper);
                    //}
                }
                else {
                    console.log("Failed with state: " + state);
                }
                // helper.hideSpinner(component,event,helper);
            });
            
            // Send action off to be executed
            $A.enqueueAction(action); 
        }
    },
})