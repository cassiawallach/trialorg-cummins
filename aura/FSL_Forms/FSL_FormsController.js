({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
    },
    
    InShopJSA : function(component, event, helper) {
    	var recordId = component.get('v.recordId');
		window.open('/apex/FSL_InShopJSA?id=' + recordId+'&copybtn=false','_blank');
       
    },
    
    openForms : function(component, event, helper) {
        var rectarget = event.currentTarget;
        var WOId = rectarget.getAttribute("data-id");
        
        var nameTarget = event.currentTarget;
        var pageName = nameTarget.getAttribute("data-name");
        
        var jobIdTarget = event.currentTarget;
        var jobId = jobIdTarget.getAttribute("data-jobId");
        component.set("v.jobId", jobId);
        
        var statusTarget = event.currentTarget;
        var status = statusTarget.getAttribute("data-status");
        console.log(':::Status = '+status);
        
        //Check Link Active
        helper.getFormStatus(component, event,helper);
        //Refresh the Component
        helper.doInitHelper(component, event,helper);
              
        window.setTimeout(
            $A.getCallback(function() {
                var linkStatus;
                if(status === 'true') {
                    linkStatus  = status;
                } else {
                    linkStatus = component.get('v.isLinkActive');
                }
                console.log('::: Link Status = '+linkStatus+' and '+component.get('v.isLinkActive'));
                var vfUrl = '/apex/'+pageName+'?Id=' + WOId + '&jformId='+jobId+'&copybtn='+linkStatus;
                window.open(vfUrl,'_blank')
            }), 1000
        ); 
    },
    
    refreshView : function(component, event, helper) {
        var action = component.get("c.fetchFormsDetails");
        action.setParams({
            workOrderId : component.get("v.recordId")
        });
        action.setCallback(component,
            function(response) {
                var state = response.getState();
                if (state === 'SUCCESS'){
                    $A.get('e.force:refreshView').fire();
                } else {
                     
                }
            }
        );
        $A.enqueueAction(action);
    },
    
    FieldServiceJSA : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        window.open('/apex/FSL_FieldServiceJSA?id=' + recordId+'&copybtn=false','_blank');  
    },
    
    MarineJSA : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        window.open('/apex/FSL_MarineJSA?id=' + recordId+'&copybtn=false','_blank');
    },
    
    PowerGenJSA : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        window.open('/apex/FSL_PowerGenJSA?id=' + recordId+'&copybtn=false','_blank');
    }
    
})