({
 	fetchFaultCodes : function(component, event, helper) {
		helper.fetchPSOFaultCodesHelper(component,event, helper);
        helper.fetchNPSOFaultCodesHelper(component,event, helper);
        helper.fetchfullDetailsHelper(component);
        //STARTS : Added by Lochana for SG-114
        var woId = component.get("v.recordId");
        var action = component.get('c.fetchFTRDetails');
        action.setParams({
            woId : woId 
        });
        action.setCallback(this,function(response){
            if(response.getState()==="SUCCESS"){
                let resp = response.getReturnValue();
                component.set("v.FTRFlag",resp.isFTR);
                if(resp.dealerStagestr === 'Triage & Diagnosis') {
                    component.set("v.woStatus",true);
                }
            }
        });
        $A.enqueueAction(action);
    },

    fetchUpdatedData : function(component, event,helper) {
        	component.set("v.maxSeqFromInsite", null);
            helper.fetchPSOFaultCodesHelper(component,event, helper);
            helper.fetchNPSOFaultCodesHelper(component,event, helper);
            helper.fetchfullDetailsHelper(component);
    },

    //added by Sriprada
    getSolutions :function(component, event, helper)
    {
        var faultID = event.target.getAttribute("data-id");
        var woId = component.get("v.recordId");        
        helper.changeRECORDtype(component, event, helper);
    },

    gotoJobPlan : function(component, event, helper) {
        component.set("v.ShowSpinner", true);
        var action = component.get('c.updateWOStatus');
        var woId = component.get("v.recordId");
        action.setParams({
            woId : woId,
            Status : 'Job Plan'
        });
        action.setCallback(this, function(response) {
            if(response.getState()==="SUCCESS"){
                $A.get('e.force:refreshView').fire();
                //Redirect to Overview tab
                var recId = window.location.href;
                var recId1 = recId.substring(0, recId.lastIndexOf('/'));
                 var tabsetUrl = $A.get("$Label.c.EVL_TabSetToOverview");
                var recId2 = recId1+'/detail?tabset-'+tabsetUrl; 
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({ "url": recId2});   // Pass your community URL
                urlEvent.fire();
            }
            component.set("v.ShowSpinner", false);
        });
        $A.enqueueAction(action);
    },

    gotoRepair : function(component, event, helper) {
        component.set("v.ShowSpinner", true);
        var action = component.get('c.updateWOStatus');
        var woId = component.get("v.recordId");
        action.setParams({
            woId : woId,
            Status : 'Repair'
        });
        action.setCallback(this, function(response) {
            if(response.getState()==="SUCCESS"){
                $A.get('e.force:refreshView').fire();
                //Redirect to Repair tab
                var recId = window.location.href;
                var recId1 = recId.substring(0, recId.lastIndexOf('/'));
                var tabsetUrl = $A.get("$Label.c.EVL_TabSetToRepair");
                var recId2 = recId1+'/detail?tabset-'+tabsetUrl; 
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({ "url": recId2});   // Pass your community URL
                urlEvent.fire();
            }
            component.set("v.ShowSpinner", false);
        });
        $A.enqueueAction(action);
    }    
})