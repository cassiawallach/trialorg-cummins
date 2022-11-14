({
	doInit : function(component, event, helper) {
        // Prepare the action to load account record
        var action = component.get("c.getRecommendationsCount");
        action.setParams({"scId": component.get("v.recordId")});
 
        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.numRecords", response.getReturnValue());
            } else {
                console.log('Problem getting, response state: ' + state);
            }
        });
        $A.enqueueAction(action);
	}
})