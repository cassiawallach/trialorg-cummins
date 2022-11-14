({
    doinit : function(component, event, helper) {
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
             if (state === "SUCCESS") {
                
                var storeResponse = response.getReturnValue();
                // set current user information on userInfo attribute
                component.set("v.userInfo", storeResponse);
                helper.getMetaData(component, event, helper);
            
            }
        });
        $A.enqueueAction(action);
        
        //component.set("chatUrl","https://chat.cummins.com/system/templates/chat/cummins/chat.html?subActivity=Chat&entryPointId=1022&templateName=cummins&languageCode=en&countryCode=US&ver=v11");
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    
    likenClose: function(component, event, helper) {
        // Display alert message on the click on the "Like and Close" button from Model Footer 
        // and set set the "isOpen" attribute to "False for close the model Box.      
        component.set("v.isOpen", false);
    },
    chatUrl : function(component, event, helper) {
       var urlEvent = $A.get("e.force:navigateToURL");
                 urlEvent.setParams({
                 "url": "https://chat.cummins.com/system/templates/chat/cummins/chat.html?subActivity=Chat&entryPointId=1022&templateName=cummins&languageCode=en&countryCode=US&ver=v11"
                });
               urlEvent.fire();
    },
})