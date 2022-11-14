({
	helperMethod : function() {
		
	},
    
    showSpinner: function (component, event, helper) {
        var spinner = component.find("Spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
     
    hideSpinner: function (component, event, helper) {
        var spinner = component.find("Spinner");
        $A.util.addClass(spinner, "slds-hide");
    }
})