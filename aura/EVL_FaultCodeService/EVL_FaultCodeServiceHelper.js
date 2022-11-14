({
    fetchPSOFaultCodesHelper : function(component,event, helper) {
        console.log('Inside Faultcode');
        component.set("v.ShowSpinner", true);//added by Piyush for VGRS2-36
        var action = component.get("c.fetchPriorityFaultCodes");
        action.setParams({
            "JobId" : component.get("v.recordId"),
            "maxSeq":component.get("v.maxSeqFromInsite") 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.PSOfalutCode" , response.getReturnValue());
                component.set("v.priorityRecieved",true);
            }
          component.set("v.ShowSpinner", false);//added by Piyush for VGRS2-36
        });
        $A.enqueueAction(action); 
    },
    fetchNPSOFaultCodesHelper : function(component,event, helper) {
       component.set("v.ShowSpinner", true);//added by Piyush for VGRS2-36
        var action = component.get("c.fetchNonPriorityFaultCodes");
        action.setParams({
            "JobId" : component.get("v.recordId"),
            "maxSeq":component.get("v.maxSeqFromInsite") 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.NPSOfalutCode" , response.getReturnValue());
                component.set("v.NonpriorityRecieved",true);                
            }
        component.set("v.ShowSpinner", false);//added by Piyush for VGRS2-36
        });
        $A.enqueueAction(action); 
    },
    
    fetchfullDetailsHelper : function(component) {
        component.set("v.ShowSpinner", true);//added by Piyush for VGRS2-36
        var action = component.get("c.fetchPriorityDetMap");
        action.setParams({
            "JobId" : component.get("v.recordId"),
            "maxSequence":component.get("v.maxSeqFromInsite")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
               var result = response.getReturnValue();
                var arrayMapKeys = [];
                var activesec = null;
                for(var key in result){
                    var arrayInnerMapKeys = [];
                    var iresult = result[key];
                    for(var ikey in iresult){
                    	arrayInnerMapKeys.push({key: ikey, value: iresult[ikey]}); 
                    }
                    arrayMapKeys.push({key: key, value: arrayInnerMapKeys});
                }
                component.set("v.faultcodeValues", arrayMapKeys);
            }
           component.set("v.ShowSpinner", false);//added by Piyush for VGRS2-36
        });
        $A.enqueueAction(action); 
    }   
    
})