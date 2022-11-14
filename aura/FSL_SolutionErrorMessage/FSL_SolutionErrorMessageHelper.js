({
    displayerrMessage: function(component,event) {
        
         var recId = component.get("v.recordId");
         var action = component.get("c.displayerrormessage");
       
        console.log('*** record id = '+recId);
        
        action.setParams({
            "workorderId" : recId
        });
        
         action.setCallback(this, function(response) {
            var state = response.getState();
             var result = response.getReturnValue();
             
               if(state == "SUCCESS") {
                if(result) {
                    var staticLabel = $A.get("$Label.c.FSL_Solution_Error_Msg");
                    console.log('::: Result = '+result); 
                    if(result.Process_Step__c == 'Triage & Diagnosis'){
                    component.set("v.errorString",staticLabel);
                    }
                    else if (result.Process_Step__c == 'Repair'){
                    var staticLabel1 = $A.get("$Label.c.FSL_Repair_Solution_Error_Msg");
                    component.set("v.errorString",staticLabel1);
                    }
                }
               }
             
             
         });
        $A.enqueueAction(action);
    }
          
                          
})