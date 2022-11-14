({
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
                component.set("v.showPopup",true);
                var retJSON = component.get("v.cssSolns");
                for(var i=0;i<retJSON.length;i++){
                  //  alert(retJSON[i].Id+":"+retJSON[i].repairResponse)
                    if(retJSON[i].repairResponse==='Repair performed but didnot resolve the root cause.' || retJSON[i].repairResponse=== 'Repair not performed.'){
                        component.set("v.resolutionSection",true);
                    } else{
                        component.set("v.resolutionSection",false);
                    }
                }
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
    
    getLoggedinUserInfo : function(component, event, helper) {
      //  var action  = component.get("c.GetLoggedInUserProfileName");
      //  GetLoggedInUserInfo
      //  //By Priyanka 2/3/2019  for fetching both role and profile instead of using two different methods VGRS2-323
        var action  = component.get("c.GetLoggedInUserDetail");
        action.setCallback(this,function(response){
            if (response.getState() === 'SUCCESS') {
                var res = response.getReturnValue();
                console.log('ProfileValue'+res);
                // By Priyanka VGRS2-323
                if(res.Profile.Name === 'EVL_Dealer_Technician' ||(res.UserRole != null && res.UserRole.Name ==="Factory")){
                    console.log('ProfileValue2'+res);
                   component.set("v.DisableClose",true); 
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    handleClose : function(component,event,helper) {
        var gag=component.get("v.recordId");
        var resolutionmsg;
         component.set("v.showSpinner",true); // By Priyanka for VGRS2-330
        //Sruthi Changes to include Resolution
        var isresolution = component.get("v.resolutionSection");
        if(isresolution){
            var resolutionmsg = component.find("resolutionmsg").get("v.value");
            console.log('-----resolurion'+resolutionmsg);
        }
        else{
            resolutionmsg = null;
        }
        
        var action = component.get("c.handleCloseModal");
        action.setParams({
            workOrderId : component.get("v.recordId"),
            resolution : resolutionmsg
        });
        action.setCallback(this,function(response){
             component.set("v.showSpinner",false); // By Priyanka for VGRS2-330
            var state = response.getState();
            console.log('State:::'+state);
            if (state==='SUCCESS') {
                console.log('TestttttInsiteState');
                location.reload();
                component.find("overlayLibClose").notifyClose();
              //  $A.get('e.force:refreshView').fire();
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