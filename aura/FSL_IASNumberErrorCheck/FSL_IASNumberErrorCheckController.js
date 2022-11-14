({
    doInit : function(component, event, helper) {
        
        var woId = component.get("v.recordId");
        var action = component.get("c.displayerrormessage");  
        action.setParams({
            workorderId :woId
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") { 
                var staticLabel = $A.get("$Label.c.FSL_IASNumber");
                component.set("v.errorString", staticLabel);
                //set response value in wrapperList attribute on component.
                component.set('v.IASNumber', response.getReturnValue().IAS_Number__c); 
                console.log('component test' + component.get('v.IASNumber'));
            }
        });
        $A.enqueueAction(action);
    }
})