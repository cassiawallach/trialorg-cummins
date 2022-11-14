({
    doInit : function(component, event, helper) {
        helper.callApex(component, event, helper);
        
        component.set("v.showSpinner", true);
         window.setTimeout(
            $A.getCallback(function() {
                
                component.set("v.showSpinner", false);
            }), 9000
        );
        
        
       /*
		window.setInterval(
            $A.getCallback(function() { 
                helper.callApex(component, event, helper);
            }), 5000
        ); 
		*/    
    },
    upRec: function(component, event, helper) {
        helper.callCustomerCreditMessage(component, event, helper);
        component.set("v.showSpinner", true);
         window.setTimeout(
            $A.getCallback(function() {
                
                component.set("v.showSpinner", false);
            }), 9000
        );
    }

})