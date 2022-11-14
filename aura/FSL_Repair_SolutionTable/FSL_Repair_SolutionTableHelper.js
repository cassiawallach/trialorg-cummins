({
    showDetails: function(component, event, helper)
    {    
        //alert('here');
        var action = component.get("c.getSolutionTable");
        action.setParams({
            serviceOrderId : component.get("v.recordId"),
            
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in wrapperList attribute on component.
                component.set('v.wrapperList', response.getReturnValue());
                component.set('v.repairValue', response.getReturnValue());
                component.set('v.diagValue', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    //added by sriprada
    changeRECORDtype : function(component,event,faultID) {
        var woId = component.get("v.recordId");
        console.log('woId == '+woId);
        var action = component.get("c.changeRecord");
        action.setParams({
            'workId': woId,
            'faultID':faultID
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS")
            {
                location.reload();
                /* var rid= component.get("v.recordId");
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": rid,
                    "slideDevName": "SloutionT&D"
                    
                });
                navEvt.fire(); */
                // $A.get('e.force:refreshView').fire();
                
                
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
       $A.enqueueAction(action);
   },
    //Added by Mallika.P to redirect selected repair.
    editCompHelper:function(component,event,solId) {
        var woId = component.get("v.recordId");
        //var fault = component.get("v.faultId");
        console.log('woId == '+woId);
        var action = component.get("c.changesolRecord");
         
        action.setParams({
            'workId': woId,
            'solId':solId,
           
       });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS")
            {
                location.reload();
              
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    }
})