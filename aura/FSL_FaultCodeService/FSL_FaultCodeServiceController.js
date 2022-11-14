({
 	fetchFaultCodes : function(component, event, helper) {
		helper.fetchPSOFaultCodesHelper(component,event, helper);
        helper.fetchNPSOFaultCodesHelper(component,event, helper);
        //helper.fetchPriorityDetailsHelper(component);
        helper.fetchfullDetailsHelper(component);
  		//Start Road-468 - Rajender added on 07/25/2022
  		//To get the FTR value
        var FTRFlag = component.get('c.fetchFTRFlag');
        var woId = component.get("v.recordId");
        console.log('workOrderId >>>>> :: '+woId);
        FTRFlag.setParams({
            woId : woId
        });
        FTRFlag.setCallback(this,function(response){
            if(response.getState()==="SUCCESS"){
                component.set("v.FTRFlag", response.getReturnValue());
            }
            console.log('FTRFlag >>>>> :: '+FTRFlag);
        });
        $A.enqueueAction(FTRFlag);
        
        //To get the workorder process step value
        var woStatus = component.get('c.getWOStatus');
        var woId = component.get("v.recordId");
        console.log('workOrderId >>>>> :: '+woId);
        woStatus.setParams({
            woId : woId
        });
        woStatus.setCallback(this, function(response){
            if(response.getState()==="SUCCESS"){
                component.set("v.woStatus", response.getReturnValue());
            }
            console.log('woStatus >>>>> :: '+woStatus);
        });
        $A.enqueueAction(woStatus);
        //End Road-468 - Rajender added on 07/25/2022
    },
    fetchUpdatedData : function(component, event,helper) {
        	component.set("v.maxSeqFromInsite", null);
            helper.fetchPSOFaultCodesHelper(component,event, helper);
            helper.fetchNPSOFaultCodesHelper(component,event, helper);
            //helper.fetchPriorityDetailsHelper(component);
            helper.fetchfullDetailsHelper(component);
        setTimeout(function(){
            location.reload(); 
        }, 10000);

    },
     //added by Sriprada
    getSolutions :function(component, event, helper)
    {
        var faultID = event.target.getAttribute("data-id");
        console.log('Faultid  ==  '+faultID);
        var woId = component.get("v.recordId");
        
        helper.changeRECORDtype(component, event, helper);
       // helper.getSolutionsKnw(component,event);
    },

    //Start Road-468 - Rajender added on 07/25/2022
    gotoJobPlan : function(component, event, helper) {
        component.set("v.ShowSpinner", true);
        var JB = component.get('c.updateStatustoJobPlan');
        var woId = component.get("v.recordId");
        console.log('workOrderId >>>>> :: '+woId);
        JB.setParams({
            woId : woId
        });
        JB.setCallback(this, function(response) {
            if(response.getState()==="SUCCESS"){
                $A.get('e.force:refreshView').fire();
            }
            component.set("v.ShowSpinner", false);
        });
        $A.enqueueAction(JB);
    },
    
    gotoRepair : function(component, event, helper) {
        component.set("v.ShowSpinner", true);
        var JB = component.get('c.updateStatustoRepair');
        var woId = component.get("v.recordId");
        console.log('workOrderId >>>>> :: '+woId);
        JB.setParams({
            woId : woId
        });
        JB.setCallback(this, function(response) {
            if(response.getState()==="SUCCESS"){
                $A.get('e.force:refreshView').fire();
            }
            component.set("v.ShowSpinner", false);
        });
        $A.enqueueAction(JB);
    }//End Road-468 - Rajender added on 07/25/2022    
    
})