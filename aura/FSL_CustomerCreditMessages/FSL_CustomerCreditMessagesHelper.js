({
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    
   
    callApex : function(component,event,helper){
        
        var action = component.get("c.getCustomerCreditMessageData");
        
        if(typeof action === "undefined") {
            console.log('::: undefined action');
        } else {
            action.setParams({
                "serviceJob": component.get("v.recordId") 
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                //console.log('****'+component.isvalid());
                if (state === "SUCCESS") {
                    console.log('*****'+response.getReturnValue());
                    component.set("v.CustomerCreditMessages", response.getReturnValue());
                    // $A.get("e.force:refreshView").fire();
                    component.set("v.showSpinner", false);
                }
                else {
                    console.log("Failed with state: " + state);
                }
                //helper.hideSpinner(component,event,helper);
            });
            
            // Send action off to be executed
            $A.enqueueAction(action); 
        }
        
    },
    callCustomerCreditMessage: function(component,event,helper){
        var action = component.get("c.updateCreditMessageData");
                if(typeof action === "undefined") {
            console.log('::: undefined action');
        } else {
            action.setParams({
                "serviceJob": component.get("v.recordId") 
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                //console.log('****'+component.isvalid());
                if (state === "SUCCESS") {
                    console.log('*****'+response.getReturnValue());
                    component.set("v.CustomerCreditMessages", response.getReturnValue());
                    // $A.get("e.force:refreshView").fire();
                    component.set("v.showSpinner", false);
                }
                else {
                    console.log("Failed with state: " + state);
                }
                //helper.hideSpinner(component,event,helper);
            });
            
            // Send action off to be executed
            $A.enqueueAction(action); 
        }
        
        
    }
})