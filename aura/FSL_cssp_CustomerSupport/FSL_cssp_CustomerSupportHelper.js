({
	getMetaData : function(component, event, helper) {
		var action = component.get("c.getMetaData");
        action.setParams({ country : component.get("v.userInfo").Address.country });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
                component.set("v.metaObj", storeResponse);
            }
        });
        $A.enqueueAction(action);
	},
    /*getLocaleSidKeyLabal : function(component, event, helper) {
		var action = component.get("c.getLocaleSidKeyLabal");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
                component.set("v.localeLabal", storeResponse);
            }
        });
        $A.enqueueAction(action);
	},*/
    
})