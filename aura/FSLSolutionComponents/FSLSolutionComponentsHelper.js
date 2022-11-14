({
    insertsolutioncomp: function(component, event, helper) {
        
        var failName ;
        if( component.find('inptid').get('v.value') != null  ) {
            failName = component.find('inptid').get('v.value') ;
        }
        else if(component.find('cmfid').get('v.value') != null){
            failName = component.find('cmfid').get('v.value') ;
        }
       
        var woids = component.get("v.recordId") ;
        var action = component.get("c.getfailurename");
        action.setParams({
            'strcnt': failName ,
            'strfmode': component.find('inptFMid').get('v.value') ,
            'solid':component.get("v.cssSolId") ,
            'strrecId' : woids ,
            'cusfailid' : component.find('cmfid').get('v.value'),
            'woId':component.get("v.recordId")//added by vinod yellala 6/12 - for failure add parts
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                alert('kkk'+storeResponse);
               // helper.showSuccessToast(component,helper,event);
               
               // $A.get("e.force:refreshView").fire();               
                
            }else if (state === "INCOMPLETE") {
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
      //  $A.get("e.force:refreshView").fire();    
        $A.enqueueAction(action);
    },
    showSuccessToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success Message',
            message: 'CSS Solution component has been inserted successfully',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    getsolsCompsHelper: function(component, event, helper) {
        component.set("v.showSpinner",true);//added by Piyush VGRS2-328  
        var eventParam = event.getParam('solCmpId');   
        console.log('eventParam'+eventParam);
        var action = component.get("c.getSolComps");
        console.log('cssoldid::'+component.get("v.cssSolId"));
        console.log('urlName::'+component.get("v.urlName"));
        action.setParams({
            'knowId': component.get("v.cssSolId"),
            'urlName':component.get("v.urlName"),
            'woId':component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS")
            {
                var data = response.getReturnValue();
                console.log('response from method::'+JSON.stringify(data));
                var fslComps=[];  
                var fslCompParts=[];
                var yxxx=[];
                for( var key in data)
                {
                    console.log('key.CSSCompsWrp.compId::'+data[key]);
                    fslComps.push({compId:key, comp:key});
                    //fslComps.push({compId:key.CSSCompsWrp.compId, comp:key});
                    fslCompParts.push({compId:key, comp:data[key]});
                    yxxx=data[key];
                    console.log(yxxx.length);
                }
                console.log('fslComps::'+JSON.stringify(fslComps));
                console.log('fslCompParts::'+JSON.stringify(fslCompParts));
                component.set("v.fuelComps", fslComps);
                component.set("v.fuelCompsParts", fslCompParts);
                component.set("v.fuelCompsPartsABC", data);
                var cmpEvent = component.getEvent("AddSolComps");
                cmpEvent.setParams({"solComps" : component.get("v.selectedComps"),
                                    "unselectedSolComps" : component.get("v.deSelectedComps"),
                                    "selectedParts" : component.get("v.selectedParts"),
                                    "deSelectedParts" : component.get("v.selectedParts"),
                                    "cssSolComps":component.get("v.fuelCompsPartsABC")});
                cmpEvent.fire();
                console.log('event fired');
            }
            component.set("v.showSpinner",false);//added by Piyush VGRS2-328 
        });
        $A.enqueueAction(action);
    },
    getReplReasonLOVs: function(component, event, helper) {
        component.set("v.showSpinner",true);//added by Piyush VGRS2-328 
        var action2 = component.get("c.getRepairReasonLOVs");
        console.log('cssoldid::'+component.get("v.cssSolId"));        
        action2.setCallback(this, function(response){
            var state = response.getState(); 
            console.log(state);
            if (state === "SUCCESS")
            {
                component.set("v.repRsnLOVs",response.getReturnValue());
                console.log('repair reason picklist values::'+component.get("v.repRsnLOVs"));
            }
            component.set("v.showSpinner",true);//added by Piyush VGRS2-328 
        });
        $A.enqueueAction(action2);
    },
    getFailureCodes: function(component, event, helper) {
        component.set("v.showSpinner",true);//added by Piyush VGRS2-328
        var action = component.get("c.getFailures");
        action.setParams({
            solutionId: component.get("v.cssSolId")
        });
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if (state === "SUCCESS")
            {
                component.set("v.FailureCodes",response.getReturnValue());
            }
          component.set("v.showSpinner",false);  //added by Piyush VGRS2-328
        });
        $A.enqueueAction(action);
    }
})