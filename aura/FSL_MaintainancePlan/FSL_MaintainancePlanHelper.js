({
    Branchcode : function(component, event, helper) {
        
        var action = component.get("c.getBranchCode");
        action.setParams({ mPID : component.get("v.recordId") });
        action.setCallback( this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") {
                	console.log('response.getReturnValue()##'+response.getReturnValue());
                    component.set("v.branchCode",response.getReturnValue() );
                    helper.openMaintenanceAssetModal(component, helper);
            }
            else{
                alert('Error message: Unknown error has occurred ');
            }
        });
        $A.enqueueAction(action);
    },
    
    
    openMaintenanceAssetModal : function(component, helper) {
        var branchCode = component.get("v.branchCode");
        var assetEvent = $A.get("e.force:createRecord");
        assetEvent.setParams({
            "entityApiName": "MaintenanceAsset",
            "defaultFieldValues": {               
                'Branch_Code__c' : branchCode,
                'Branch_Code_BackendUse__c' : branchCode,
                'MaintenancePlanId' : component.get("v.recordId")
            }
        });
        assetEvent.fire();
        
    },
    
    setRecordId : function(component, event, helper) {
        var pageRef = component.get("v.pageReference");
        var state = pageRef.state;
        var base64Context = state.inContextOfRef;
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));
        component.set("v.recordId", addressableContext.attributes.recordId);
    }
   
})