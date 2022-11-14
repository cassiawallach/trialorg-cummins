({
	 getoverview : function(component,event)
    {
        var woID = component.get("v.recordId");
        console.log('woID == '+woID);        
        var action = component.get("c.getFCOverview");
        action.setParams({
            'workOrderId': woID
        });
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               console.log(state);
                               if (state === "SUCCESS")
                               {
                                   var data = response.getReturnValue();
                                   console.log('OverView data =: '+data);
                                   component.set("v.overViewDetail",JSON.parse(data));
                                   
                               }else if (state === "INCOMPLETE")
                               {
                                   // alert('Response is Incompleted');
                               }else if (state === "ERROR") {
                                   var errors = response.getError();
                                   if (errors) {
                                       if (errors[0] && errors[0].message) {
                                           // alert("Error message: " + errors[0].message);
                                       }
                                   } else {
                                       // alert("Unknown error");
                                   }
                               }
                           });
        $A.enqueueAction(action);
    },
})