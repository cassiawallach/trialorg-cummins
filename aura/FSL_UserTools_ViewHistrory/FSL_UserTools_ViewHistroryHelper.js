({
	helperrender : function(component, event, helper) {
        
        //  component.set("v.showSpinner",true);
         window.setTimeout(
            $A.getCallback(function() {
                component.set("v.showSpinner", false);
            }), 6000
        );
		
	},
    PSNSearch : function(component, event, helper) {
        console.log('Test Priya');
        var action = component.get("c.startRequest");
        action.setParams({ 
            enteredPSN : component.get("v.searchPSN") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var arrayMapKeys = [];
                console.log("::: From server: " + response.getReturnValue());
                //component.set('v.isPSNValid', response.getReturnValue());
                var result = response.getReturnValue();
                for (var key in result) {
                    if(result['isPSNValid'] === 'TRUE') {
                        component.set('v.isPSNValid', true);
                        component.set('v.showError', false);
                    } else {
                        component.set('v.isPSNValid', false);
                        component.set('v.showError', true);
                    }
                    
                }
                
            } else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("::: Error message: " + errors[0].message);
                    }
                } else {
                    console.log("::: Unknown error");
                }
            }
            
        });
        $A.enqueueAction(action);
    },
})