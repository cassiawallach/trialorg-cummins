({
    handleCancelModal : function(component, event, helper) {
        component.find("overlayLib").notifyClose();
    },
    handleIntakeClose:function(component, event, helper) {
        helper.handleClose(component, event, helper);
    },
    handleScheduleClose : function(component, event, helper) {
        if(component.get("v.WorkOrder.Type__c") != 'Internal'){
            component.find("recordScheduleForm").submit();
            helper.handleClose(component, event, helper);
        }
        else{
           helper.handleClose(component, event, helper);
        }        
    },
    
    handleSolutionClose : function(component, event, helper) {
        var isClose = false;
        var retJSON = component.get("v.cssSolns")
        for(var i=0;i<retJSON.length;i++){
            console.log(retJSON[i].Id+":"+retJSON[i].repairResponse)
            if(retJSON[i].repairResponse===''){
                helper.showToast('Error','Error','Please select repair response for all the solutions');
                isClose = true;
                break;
            }
        }
        if(!isClose){
            helper.handleClose(component, event, helper);
        }
        
        
    },
    loadChevron :function(component, event, helper) {
        if(component.get("v.currentStage") == 'Triage & Diagnosis' || 
           component.get("v.currentStage") == 'Repair' || 
           component.get("v.currentStage") == 'Job Plan'){
            helper.handleTAndDRepairJobPlanClose(component, event, helper);
            helper.getRepairRespPickListValues(component, event, helper);
        }
    },
    handleRepairValueChange:function(component, event, helper) {
        //Getting css solution Id 
        var selectedItem = event.getSource().get("v.class");
        //Getting selected pick list value from repair response
        var selectedValue = event.getSource().get("v.value");
        var retJSON = component.get("v.cssSolns");
        //Iterating over through all the solutions and if matches id , 
        //assigning selected repair response to the key value
        for(var i=0;i<retJSON.length;i++){
            if(retJSON[i].Id === selectedItem ){
                retJSON[i].repairResponse = selectedValue;
                break; 
            }
        }
        
        
    }
    
    
})