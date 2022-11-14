({
    helperrender: function(component, event, helper) {
        
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.showSpinner", false);
            }), 3000
        );
     
    }
})