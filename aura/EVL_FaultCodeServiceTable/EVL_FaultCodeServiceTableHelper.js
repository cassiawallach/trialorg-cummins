({
     //added by sriprada
    changeRECORDtype : function(component,event,faultID) {
       // alert('testttttinsidetable');
        var woId = component.get("v.workOrderId");
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
    
    getknowledge : function(component,event)
    { 
        var solID = component.get("v.workOrderId");
        console.log('solID == '+solID);
        var action = component.get("c.getknowledge");
        action.setParams({
            'solutionId': solID
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS")
            {
                var data = response.getReturnValue();
                console.log('data = '+JSON.stringify(data));
                component.set("v.knowledgeList", data);// Adding values in Aura attribute variable.
                
            }else if (state === "INCOMPLETE")
            {
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
     editCompHelper:function(component,event,solId) {
        var woId = component.get("v.workOrderId");
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
                //location.reload();
               var recId = window.location.href;
                var recId1 = recId.substring(0, recId.lastIndexOf('/'));
                 var tabsetUrl = $A.get("$Label.c.EVL_TabSetToRepair");
                var recId2 = recId1+'/detail?tabset-'+tabsetUrl+'&TabId=solution'; 
                //var recId2 = recId1+'/detail?tabset-61bfa=15d24&TabId=solution';
                //alert('recId2'+recId2);
              
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({ "url": recId2});   // Pass your community URL
                urlEvent.fire(); 
                
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " +  errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    }
})