({
    doInit : function(component, event, helper) {
      this.fetchSRTCodes(component, event, helper);  
    },
    showSpinner: function (component, event, helper) {
        var spinner = component.find("SRTSpinner");
        $A.util.removeClass(spinner, "slds-hide"); 
    },
    
    hideSpinner: function (component, event, helper) {
        var spinner = component.find("SRTSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    fetchSRTCodes : function(component, event, helper) {
        console.log('::: Fetch SRT BEGIN');
        var pType = component.get("v.srtType");
        var pRecId = component.get("v.recordId");
        var action = component.get("c.fetchSRTCodes");
        console.log('::: Params = '+pType+' and '+pRecId);
        action.setParams({
            "workOrderId" : pRecId,
            "srtType" : pType
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('::: Callback Status = '+state);
            if(state === "SUCCESS"){
                
                component.set("v.savedSRTs", response.getReturnValue()); 
                console.log('::: Saved SRTs = '+response.getReturnValue());
            } else {
                console.log('::: Error in fetching Saved SRTs');
            }
        });
        $A.enqueueAction(action); 
    },
    
    closemodalhelper:function (component, event, helper) {
      component.find("searchCode").set("v.value", null);
		component.find("groupSelect").set("v.value", null);
        component.set("v.searchResults", null);
        component.set("v.pRecordSelected", false);
        component.set("v.AddedResults", null);
        component.set("v.pRecordAdded", false); 
        component.set("v.isModalOpen", false);
        component.set("v.AccessCheck", true );
        component.set("v.AdminCheck", true );
        component.set("v.DiagnosticCheck", true );
        component.set("v.RepairCheck", true );
        component.set("v.pTooManyRecordsFound", false);
        component.set("v.pNoRecordsFound", false);  
    },
    
    saveSRTRec :function (component, event, helper) {
        var params = component.get("v.AddedResults");
        var addResult =JSON.stringify(params);
        var srtType = component.get("v.srtType");
        if(srtType == 'Diagnostic'){
            srtType = 'Diagnosis';
        }
        if(srtType == 'Field Actions'){
            srtType = 'Field Action';
        }
        var action = component.get("c.saveSRT");
        action.setParams({
            "SRTAdd" : addResult,
            "serviceOrderId" : component.get("v.recordId"),
            "srtType" : srtType
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('response');
                this.closemodalhelper(component, event, helper);
                $A.get('e.force:refreshView').fire();
            } else {
                console.log('::: Error');
            }
        });
        $A.enqueueAction(action); 
    }
})