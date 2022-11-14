({
    laborMultiplerDefaultValue : function(component, event, helper) {
        
        var action = component.get("c.getLaborMultiplierDetails");
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if (state === "SUCCESS") {
                if(response.getReturnValue()== null || response.getReturnValue()== ''){
                    component.set("v.laborMultipler",response.getReturnValue() );  
                }
                else{
                    component.set("v.laborMultipler",response.getReturnValue().Id );
                }
                helper.openCaseModal(component, helper);
            }
            else{
                alert('Error message: Unknown error has occurred ');
            }
        });
        $A.enqueueAction(action);
    },
    
    
    openCaseModal : function(component, helper) {
        var laborMultId = component.get("v.laborMultipler");
        var createCaseEvent = $A.get("e.force:createRecord");
        createCaseEvent.setParams({
            "entityApiName": "Asset",
            "defaultFieldValues": {               
                'Labor_Multiplier__c' : laborMultId
            }
        });
        createCaseEvent.fire();
        
    }
    
    
   
})