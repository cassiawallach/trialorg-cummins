({
    fetchPSOFaultCodesHelper : function(component,event, helper) {
        component.set("v.ShowSpinner", true);//added by Piyush for VGRS2-36
        var action = component.get("c.fetchPriorityFaultCodes");
        action.setParams({
            "JobId" : component.get("v.recordId"),
            "maxSeq":component.get("v.maxSeqFromInsite") 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            // alert('State***'+state);
            if (state === "SUCCESS") {
                //helper.fetchNPSOFaultCodesHelper(component);
                console.log('###'+response.getReturnValue());
                component.set("v.PSOfalutCode" , response.getReturnValue());
                component.set("v.priorityRecieved",true);
            }
            component.set("v.ShowSpinner", false);//added by Piyush for VGRS2-36
        });
        $A.enqueueAction(action); 
    },
    fetchNPSOFaultCodesHelper : function(component,event, helper) {
        console.log('test1');
       component.set("v.ShowSpinner", true);//added by Piyush for VGRS2-36
        var action = component.get("c.fetchNonPriorityFaultCodes");
        action.setParams({
            "JobId" : component.get("v.recordId"),
            "maxSeq":component.get("v.maxSeqFromInsite") 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            // alert('State***'+state);
            if (state === "SUCCESS") {
                console.log('###'+response.getReturnValue());
                component.set("v.NPSOfalutCode" , response.getReturnValue());
                component.set("v.NonpriorityRecieved",true);
                if(component.get("v.fetchLatest")){
                	$A.get('e.force:refreshView').fire();    
                } 
                
            }
            component.set("v.ShowSpinner", false);//added by Piyush for VGRS2-36
        });
        $A.enqueueAction(action); 
    },
    
   /* fetchPriorityDetailsHelper : function(component) {
        console.log('test222');
        var action = component.get("c.fetchPriorityDetails");
        action.setParams({
            "JobId" : component.get("v.recordId"),
            "maxSequence":component.get("v.maxSeqFromInsite")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            // alert('State***'+state);
            if (state === "SUCCESS") {
               var result = response.getReturnValue();
                var arrayMapKeys = [];
                var activesec = null;
                for(var key in result){
                    if(activesec==null){
                        activesec = key;
                    }
                    arrayMapKeys.push({key: key, value: result[key]});
                }
                component.set("v.faultcodeValues", arrayMapKeys);
            }
        });
        $A.enqueueAction(action); 
    },*/
    fetchfullDetailsHelper : function(component) {
        component.set("v.ShowSpinner", true);//added by Piyush for VGRS2-36
        var action = component.get("c.fetchPriorityDetMap");
        action.setParams({
            "JobId" : component.get("v.recordId"),
            "maxSequence":component.get("v.maxSeqFromInsite")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert('State***'+state);
            if (state === "SUCCESS") {
               var result = response.getReturnValue();
                var arrayMapKeys = [];
                var activesec = null;
                for(var key in result){
                   // console.log('key***'+key);
                    var arrayInnerMapKeys = [];
                    var iresult = result[key];
                    for(var ikey in iresult){
                        console.log('ikey***'+ikey);
                    	arrayInnerMapKeys.push({key: ikey, value: iresult[ikey]});   
                        console.log('***'+iresult[ikey]);
                    }
                    arrayMapKeys.push({key: key, value: arrayInnerMapKeys});
                    //console.log('arrayInnerMapKeys***'+arrayInnerMapKeys);
                }
                component.set("v.faultcodeValues", arrayMapKeys);
            }
            component.set("v.ShowSpinner", false);//added by Piyush for VGRS2-36
        });
        $A.enqueueAction(action); 
    },
    
    
})