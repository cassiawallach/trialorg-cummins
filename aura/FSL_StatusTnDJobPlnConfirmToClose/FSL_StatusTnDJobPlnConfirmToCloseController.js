({
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        console.log('open model');
        //component.set("v.isModalOpen", true);
        helper.getResolutionsList(component, event, helper);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
       
    },
    
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        console.log(component.get("v.feedback"));
        console.log(component.get("v.selectedResoln"));
        var action  = component.get("c.closeJobFromTndnJPforNoMostLikly");
        action.setParams({
            strWorkOrderId : component.get("v.recordId"),
            stageName : 'Close',
            feedback:component.get("v.feedback"),
            resoln:component.get("v.selectedResoln")
        });
        action.setCallback(this,function(response){
            if (response.getState() === 'SUCCESS') { 
                 /*var resultsToast = $A.get("e.force:showToast");                    
                    resultsToast.setParams ({
                        "type": "Success",
                        "title": $A.get("Job is closed successfully"),
                        "message": $A.get("Job is closed successfully")
                    });
                    resultsToast.fire();	*/
                location.reload();
            }
        });
        $A.enqueueAction(action);
        component.set("v.isModalOpen", false);
    },
})