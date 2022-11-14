({
    // Added by Piyush for VGRS2-231
    getIsDelaerProfile : function(component,event) {
        var action = component.get("c.isdealerProfile");
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state+response.getReturnValue());
            if (state === "SUCCESS") {
                component.set("v.isDealer",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    }
   // VGRS2-231 End 
})