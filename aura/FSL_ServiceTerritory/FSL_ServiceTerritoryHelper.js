({
    serviceterritorylocationcode : function(component, event, helper) {
        
        var action = component.get("c.getServiceTerritorydetails");
        action.setCallback( this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") {
                if(response.getReturnValue()== null || response.getReturnValue()== ''){
                    component.set("v.serviceterritory",response.getReturnValue() );  
                }
                else{
                    component.set("v.serviceterritory",response.getReturnValue().Id );
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
        var servicetrID = component.get("v.serviceterritory");
        var createCaseEvent = $A.get("e.force:createRecord");
        createCaseEvent.setParams({
            "entityApiName": "WorkOrder",
            "defaultFieldValues": {               
                'ServiceTerritoryId' : servicetrID,
                'Service_Team_Contact__c': $A.get("$SObjectType.CurrentUser.Id")               
            }
        });
        createCaseEvent.fire();
        
    }
    
    
   
})