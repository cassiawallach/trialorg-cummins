({
    showDetails: function(component, event, helper)
    {    
       //alert('here');
        var action = component.get('c.wrapRecTable');
        action.setParams({
            serviceOrderId : component.get("v.recordId"),
            spn : component.get("v.spn"),
            cumminsfaultCode : component.get("v.cumminsFaultCode"),
            pcode : component.get("v.pcode"),
            highLevelSymptom : component.get("v.highLevelSymptom"),
            lowLevelSymptom : component.get("v.lowLevelSymptom"),
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in wrapperList attribute on component.
               component.set('v.wrapperList', response.getReturnValue());
           
               
            }
        });
        $A.enqueueAction(action);
    },
   //added by sriprada
   /*  changeRECORDtype : function(component,event,faultID) {
        console.log('changeRECORDtype called $$$$$$$$$$$');
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
                console.log('Result === ' +JSON.stringify(result));
               
                var rid= component.get("v.recordId");
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": rid,
                    "slideDevName": "SloutionT&D"
                    //  location.reload();
                });
                navEvt.fire(); 
                $A.get('e.force:refreshView').fire();
                
                
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
              location.reload();
        });
        $A.enqueueAction(action);   
     }*/
    
    getSolutionsKnw : function(component,event)
    {
        var solID = component.get("v.recordId");
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
    //Added by Mallika.P to redirect selected repair.
    editCompHelper:function(component,event,solId,faultID) {
        var woId = component.get("v.recordId");
        var fault = component.get("v.faultID");
        console.log('woId == '+woId);
        var action = component.get("c.updatesolRecordtd");
         
        action.setParams({
            'workId': woId,
            'solId':solId,
           
       });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS")
            {
                 // var recId = window.location.href.substring(window.location.href.lastIndexOf('/') + 1);
                var recId = window.location.href;
                var recId1 = recId.substring(0, recId.lastIndexOf('/'));
                 var tabsetUrl = $A.get("$Label.c.EVL_TabSetToRepair");
                var recId2 = recId1+'/detail?tabset-'+tabsetUrl+'&TabId=solution'; 
                //var recId2 = recId1+'/detail?tabset-61bfa=15d24&TabId=solution';
                //alert('recId2'+recId2);
              
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({ "url": recId2});   // Pass your community URL
                urlEvent.fire(); 
              
                //location.reload(); // karthik commented
              
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