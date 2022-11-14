({
    showHide : function(component ) {
        var hideButton = component.find("updateAssetButton");
        $A.util.toggleClass(hideButton, "slds-hide");
    }, 
    
    onRecordIdChange : function (component, event) {
        
        
        console.log('Calling serviceOrd ');
        var serviceOrd = component.get('v.serviceOrd');
        
        if(!serviceOrd) {
            
            var action = component.get("c.fetchServiceOrder");       
            action.setParams({ 'serviceReqId' : component.get("v.recordId") });	
            // Create a callback that is executed after 
            // the server-side action returns
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state=='SUCCESS') {
                    
                    serviceOrd = response.getReturnValue();
                    console.log(JSON.stringify(serviceOrd));
                    component.set('v.serviceOrd', serviceOrd);
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
            
        }
        
    }
})