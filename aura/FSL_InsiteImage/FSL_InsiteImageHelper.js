({
	setBeforeImage : function(component, event, helper) {
		var action = component.get("c.updateBeforeImage");
        console.log(':::Image='+component.get("v.imageCode"));
        action.setParams({ 
            image : component.get("v.imageVal"), 
            workOrderId : component.get("v.recordId") 
        });
        
        action.setCallback( this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") { 
                console.log(':::Successfully updated before image');
            }
        });
        $A.enqueueAction(action);
	},
    
    setAfterImage : function(component, event, helper) {
		var action = component.get("c.updateAfterImage");
        console.log(':::Image='+component.get("v.imageCode"));
        action.setParams({ 
            image : component.get("v.imageVal"), 
            workOrderId : component.get("v.recordId") 
        });
        
        action.setCallback( this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") { 
                console.log(':::Successfully updated before image');
            }
        });
        $A.enqueueAction(action);
	},
})