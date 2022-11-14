({
	handlePSNSearch : function(component, event, helper) {
        component.set("v.showSpinner", true);
		console.log('::: PSN Value Searched - '+component.get("v.searchValuePSN") );
        var onSerach =event.getParam('arguments'); 
        console.log(onSerach.fromParentSearch);
        if(onSerach.fromParentSearch ){
             var action = component.get("c.SearchClaimHistory");
        action.setParams({ 
            selectedPSN : component.get("v.searchValuePSN") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var actionResponse = response.getReturnValue();
                if(!$A.util.isEmpty(response.getReturnValue()) && actionResponse[0].isExceptionFlag) {
                    component.set('v.isClaimIntException', true);
                }
                else{
                    component.set('v.ClaimList', response.getReturnValue());
                    if($A.util.isEmpty(response.getReturnValue())) {
                        component.set('v.isClaimListEmpty', true);
                    } else {
                        component.set('v.isClaimListEmpty', false);
                    }
                }
                component.set("v.showSpinner", false);
            } 
            else if (state === "INCOMPLETE") {
                // do something
                component.set("v.showSpinner", false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
        }
        else{
            component.set("v.showSpinner", false);
        }
       
    },
    
    openModal: function(component, event, helper) {
        component.set("v.isPopupOpen", true);
        helper.getClaimsDetails(component, event, helper);
        //component.find('childlwc').getFiredFromAura();
    },
    
    closeModal: function(component, event, helper) {
        component.set("v.isPopupOpen", false);
    },

})