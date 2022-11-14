({
    
    //added by Sriprada
    getSolutions :function(component, event, helper)
    {
        var faultID = event.target.getAttribute("data-id");
  		console.log('Faultid  ==  '+faultID);
    //added by sruthi          
        var woId = component.get("v.workOrderId");
        console.log('woId == '+woId);
		let errorProWO = "";
        
        var action_ProWO = component.get("c.validateProductOnWO");
        action_ProWO.setParams({
            'workOrderId': woId
        });
        
        var action = component.get("c.changeRecord");
        var tbName = 'Triage & Diagnosis';
        console.log('tabName == '+tbName);

        action.setParams({
            'workId': woId,
            'faultID':faultID,
            'TabName': tbName
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var resp = response.getReturnValue();
			
            action_ProWO.setCallback(this, function(responseProWO){
                var stateProWO = responseProWO.getState();
                console.log('stateProWO::'+stateProWO);
                errorProWO = responseProWO.getReturnValue();
                console.log('errorProWO**'+errorProWO);
                
                if(errorProWO.includes("error")){
                    component.set("v.isOpen", true);
                    //$A.util.addClass(spinner, "slds-hide");
                    //$A.util.addClass(spinner, "slds-hide");
                    //component.set("v.errorMsg",$A.get("$Label.c.EVL_MileageHours_Error_Message"));
                    if(errorProWO.includes("mileage")){
                        component.set("v.isMileageErr",true);
                        component.set("v.errorMsg",$A.get("$Label.c.EVL_Product_Mileage_popupmsg"));
                    }
                    if(errorProWO.includes("hours")){
                        component.set("v.isHoursErr",true);
                        component.set("v.errorMsg",$A.get("$Label.c.EVL_Product_Hours_popupmsg_msg"));
                    }
                }
                else{
            console.log(state);
            if (state === "SUCCESS")
            {
                /* Added/Updated by Sriprada for POC of MakeModel lockdown before proceeding to Troubleshooting*/

                var tstMsg = $A.get("$Label.c.EVL_MakeModel");
                if(resp == 'No data' || resp == undefined){
                    var toastEventError = $A.get("e.force:showToast");
                    toastEventError.setParams({
                        message: tstMsg,
                        type: 'error',
                    });
                    toastEventError.fire();

                } else if(resp == 'Success'){
                    console.log('ValidateErr::'+resp);
  					var rid= component.get("v.recordId");  
                    var cmpEvent = component.getEvent("cmpEvent");
                    console.log('Faultid  ==  '+cmpEvent);
                    cmpEvent.setParams({
                        "faultCode" : faultID });
                    cmpEvent.fire();
 
                }  /* Code ends here --- Sriprada */
            }
            else if (state === "INCOMPLETE")
            {
                //alert('Response is Incompleted');
            }
                else if (state === "ERROR") 
                {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            // alert("Error message: " + 
                            //  errors[0].message);
                        }
                    } else {
                        // alert("Unknown error");
                    }
                }
                }
            //  location.reload();
            });
            $A.enqueueAction(action_ProWO);
        });
        $A.enqueueAction(action);
        
        
      /*  var cmpEvent = component.getEvent("cmpEvent");
        console.log('Faultid  ==  '+cmpEvent);
        cmpEvent.setParams({
            "faultCode" : faultID });
        cmpEvent.fire();*/
        
    },  
    
    closeWind: function(component, event, helper) {
        component.set("v.isOpen", false);
        if(component.get("v.isMileageErr") || component.get("v.isHoursErr")){
            var recWOId = component.get("v.workOrderId");
            var recHours = component.get("v.hoursNum");
            var recMileage = component.get("v.mileageNum");
            var action_updWO = component.get("c.updateWO");
            action_updWO.setParams({
                'workOrderId': recWOId,
                'hours': recHours,
                'mileage': recMileage
            });
            action_updWO.setCallback(this, function(responseUpdWO){
                var stateUpdWO = responseUpdWO.getState();
                console.log('stateUpdWO::'+stateUpdWO);
                console.log('responseUpdWO::'+responseUpdWO.getReturnValue());
                component.set("v.isMileageErr",false);  // Added by Sruthi VGRS2-132 11/2/2021
                component.set("v.isHoursErr",false);	//  Added by Sruthi VGRS2-132 11/2/2021
                $A.get('e.force:refreshView').fire();
            });
            $A.enqueueAction(action_updWO);
        }
        
    },
    
    editComp : function(component, event, helper) {
        var workOrderId = component.get("v.workOrderId");
        var ctarget = event.currentTarget;
        var solId = ctarget.dataset.value;
        // var faultID = event.target.getAttribute("data-id");
        // component.set("v.faultId",faultID);
        helper.editCompHelper(component, event, solId);
        
    }
})