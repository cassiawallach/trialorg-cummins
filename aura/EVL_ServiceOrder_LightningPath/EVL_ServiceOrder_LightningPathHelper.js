({
    loadChevron : function(component, event, helper) {
        var action = component.get('c.getChevronData');
        var txt_recordId = component.get("v.recordId");
        var txt_FieldName = component.get("v.fieldName");
        action.setParams({
            recId : txt_recordId
        });
        action.setCallback(this, function(res) { 
            helper.handleCallback(component, event, helper,res); 
        }); 
        $A.enqueueAction(action); 
        helper.GetLoggedInUserProfileName(component, event, helper);
     },
    getStage : function (component, event, helper){
        var action = component.get('c.getProcessStatus');
        var txt_recordId = component.get("v.recordId");
        action.setParams({
            woId : txt_recordId
        });
        action.setCallback(this, function(res) { 
            if (res.getState() === 'SUCCESS') { 
                console.log('Anirudh testttttttttt'+res.getReturnValue());
                component.set("v.processStep", res.getReturnValue());
            }
        }); 
        $A.enqueueAction(action); 
    },
    
    getRepair : function (component, event, helper){
        var action = component.get('c.getRepairmsg');
        var txt_recordId = component.get("v.recordId");
        action.setParams({
            woId : txt_recordId
        });
        action.setCallback(this, function(res) { 
            if (res.getState() === 'SUCCESS') { 
                console.log('Sai testttttttttt'+res.getReturnValue());
                component.set("v.RepairClose", res.getReturnValue());
            }
        }); 
        $A.enqueueAction(action); 
        
        
    },
	checkForMostLikelyOnSoln: function(component, event, helper){
        var action = component.get('c.checkForMostLikely');
        var txt_recordId = component.get("v.recordId");
        action.setParams({
            woId : txt_recordId
        });
        action.setCallback(this, function(res) { 
            if (res.getState() === 'SUCCESS')  
            {
                component.set("v.isMostLikelySelected", res.getReturnValue());
                console.log(component.get("v.isMostLikelySelected"));
               // alert( res.getReturnValue());
            }
        }); 
        
        $A.enqueueAction(action); 
    },
    checkForRepairSolnHelper: function(component, event, helper){
        var action = component.get('c.checkForRepairSelection');
        var txt_recordId = component.get("v.recordId");
        action.setParams({
            woId : txt_recordId
        });
        //action.setStorable();  
              
        action.setCallback(this, function(res) { 
            if (res.getState() === 'SUCCESS')  
            {
                component.set("v.isRepairSelected", res.getReturnValue());
                //component.set("v.isMostLikelySelected", false	);
                console.log(component.get("v.isMostLikelySelected"));
               // alert( res.getReturnValue());
                
            }
            
        }); 
        
        $A.enqueueAction(action); 
    },
    handleCallback : function(component, event, helper,res){
        if (res.getState() === 'SUCCESS') { 
            var retJSON = JSON.parse(res.getReturnValue());
            component.set("v.records",retJSON);
        }
    },
    GetLoggedInUserProfileName : function(component, event, helper){
        var action = component.get("c.GetLoggedInUserProfileName");
        action.setCallback(this,function(response){
            if (response.getState() === 'SUCCESS') { 
                var proName = response.getReturnValue();
                component.set("v.profileName",proName);
                helper.isStageActiveForLoggedInUser(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    isStageActiveForLoggedInUser : function(component,event,helper){
        var action = component.get("c.isStageActiveFor");
        component.set("v.isActiveForUser",false);
        action.setParams({
            loggedInProfileName : component.get("v.profileName")
        });
        action.setCallback(this,function(response){
            if (response.getState() === 'SUCCESS') { 
                var stages = response.getReturnValue();
                component.set("v.profileStageList",stages);
            }
            
        });        
        $A.enqueueAction(action); 
    },
    updateStageAndRecordType : function(component,event,helper){
        var stageClick =  component.get("v.chevronClick");
        var action  = component.get("c.updateStageAndRecordType");
        action.setParams({
            strWorkOrderId : component.get("v.recordId"),
            stageName : stageClick
        });
        action.setCallback(this,function(response){
            if (response.getState() === 'SUCCESS') { 
                component.find("recordViewForm").submit();//commented by vinod 9/6
                component.set("v.isExtendable",false);
                $A.get('e.force:refreshView').fire();
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
 	insertstagingvalues : function(component, event, helper){
        var action = component.get("c.insertMakeModelStaging"); 
        action.setParams({
            "servicejobid" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if(state === "SUCCESS") {
                console.log('sucess'+result);
            }
            else{
                console.log('failing Reason'+result);
            }
        });
        $A.enqueueAction(action);
    },
    handleCloseChevron : function(component,event,helper,currentStage){
        $A.createComponent("c:EVL_ServiceOrder_LightningPath_Close", 
                           {
                               currentStage: currentStage,
                               recordId	: component.get("v.recordId")		
                           },
                           function(result, status) {
                               if (status === "SUCCESS") {
                                   component.find('overlayLib').showCustomModal({
                                       header: "Guidanz Job Cummins",
                                       body: result, 
                                       showCloseButton: true,
                                   })
                               }                               
                           });
    },
    
    handleClose : function(component,event,helper){
        var gag=component.get("v.recordId");
        var action = component.get("c.handleCloseRep");
        action.setParams({
            workOrderId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state==='SUCCESS') {
                $A.get('e.force:refreshView').fire();
                location.reload();
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
    
    getLoggedinUserInfo : function(component, event, helper) {
        var action  = component.get("c.GetLoggedInUserProfileName");
        action.setCallback(this,function(response){
            if (response.getState() === 'SUCCESS') {
                var res = response.getReturnValue();
                component.set("v.logguserprof",res);                 
            }
        });
        $A.enqueueAction(action);
    }
})