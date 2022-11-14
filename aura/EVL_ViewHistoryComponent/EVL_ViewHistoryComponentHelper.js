({
	helperrender : function(component, event, helper) {
        //component.set("v.showSpinner",true);
         window.setTimeout(
            $A.getCallback(function() { 
                component.set("v.showSpinner", false);
            }), 6000
        );
		
	}
})