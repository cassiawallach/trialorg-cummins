({
    handleClose : function(component,event,helper) {
        var action = component.get("c.handleCloseModal");
        action.setParams({
            workOrderId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state==="SUCCESS") {
                component.find("overlayLib").notifyClose();
                $A.get('e.force:refreshView').fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                helper.showToast('Error','Error', errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            } 
        }); 
        $A.enqueueAction(action);
        
    },
    handleTAndDRepairJobPlanClose :  function(component,event,helper) {
        var action = component.get("c.handleTAndDRepairJobPlanClose");
        action.setParams({
            workOrderId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            var mapToSend = [];
            if (state==='SUCCESS') {
                component.set("v.cssSolns",JSON.parse(response.getReturnValue()));
                component.set("v.showPopup","true");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            } 
        }); 
        $A.enqueueAction(action);
    },
    getRepairRespPickListValues : function(component, event, helper) {
        var action  = component.get("c.getRepairRespLOVs");
        action.setCallback(this,function(response){
            if (response.getState() === 'SUCCESS') {
                component.set("v.repairRespList",response.getReturnValue());
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