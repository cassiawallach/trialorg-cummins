({
    insertsolutioncomp: function(component, event, helper) {
        var failName ;
        if( component.find('inptid').get('v.value') != null  ) {
            failName = component.find('inptid').get('v.value') ;
        }
        else if(component.find('cmfid').get('v.value') != null){
            failName = component.find('cmfid').get('v.value') ;
        }        
        var woids = component.get("v.recordId") ;
        var action = component.get("c.getfailurename");
        action.setParams({
            'strcnt': failName ,
            'strfmode': component.find('inptFMid').get('v.value') ,
            'solid':component.get("v.cssSolId") ,
            'strrecId' : woids ,
            'cusfailid' : component.find('cmfid').get('v.value'),
            'woId':component.get("v.recordId")//added by vinod yellala 6/12 - for failure add parts
        });
        action.setCallback(this, function(response)  {
            var state = response.getState();
           //alert('check in actionkarthik+ inside getfailurename'+state);
            console.log('state>>'+state);
            if (state === "SUCCESS") {
              //  alert('check');
                var storeResponse = response.getReturnValue();
                var fslshowfailureEvt = component.getEvent('FailshowEvent');
                fslshowfailureEvt.setParams({  
                    "solCmpId" : storeResponse  
                });
                fslshowfailureEvt.fire();
                component.set('v.showSpinner', false);
                component.set("v.showAddfailure",false);
            }else if (state === "INCOMPLETE") {
             alert('INCOMPLETE');                
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
    showToast : function(type,title,Message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":type,
            "title": title,
            "message": Message
        });
        toastEvent.fire();
    },
})