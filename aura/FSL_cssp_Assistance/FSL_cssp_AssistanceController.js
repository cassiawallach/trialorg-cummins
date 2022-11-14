({
	doinit : function(component, event, helper) {
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
                helper.getMetaData(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    chatUrl : function(component, event, helper) {
       var urlEvent = $A.get("e.force:navigateToURL");
                 urlEvent.setParams({
                 "url": "https://chat.cummins.com/system/templates/chat/cummins/chat.html?subActivity=Chat&entryPointId=1022&templateName=cummins&languageCode=en&countryCode=US&ver=v11"
                });
               urlEvent.fire();
    },
})