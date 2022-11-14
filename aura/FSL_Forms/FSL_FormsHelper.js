({
    doInitHelper : function(component, event, helper) {
        var action = component.get("c.fetchFormsDetails");
        action.setParams({
            workOrderId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var pRes = response.getReturnValue();
                if(pRes.length > 0){
                    component.set('v.formsList', pRes);
                }else{
                    // if there is no records then display message
                    component.set("v.pNoRecordsFound" , true);
                } 
            }
            else{
                console.log('::: Error in fetchFormsDetails');
            }
        });
        $A.enqueueAction(action);  
    },
    
    getFormStatus : function(component, event, helper) {
        var action = component.get("c.getFormStatus");
        action.setParams({
            jobId : component.get("v.jobId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var pRes = response.getReturnValue();
                console.log('### Response Value = '+pRes);
                component.set('v.isLinkActive', pRes);
            }
            else{
                console.log('::: Error in fetchFormsDetails');
            }
        });
        $A.enqueueAction(action);  
    },
    
})