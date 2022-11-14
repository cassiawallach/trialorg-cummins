({
    fetchDetails: function(component, event, helper) {
       helper.showDetails(component, event, helper);
       //this.doAction(component,event);
    },
 	doAction : function(component, event) {
        //alert();
        component.set("v.ShowSpinner", true);//added by Piyush VGRS2-321
		var params = event.getParam('arguments');
		if (params) {
			var cumCode = params.cumCode;
            var pcode = params.pcode;
            var spn = params.spn;
            var highLevelSymptom = params.highLevelSymptom;
            var lowLevelSymptom = params.lowLevelSymptom;
            var recordId = params.recordId;
            //var recordId ='0WO1D0000004dBMWAY';
         // alert('param1**'+cumCode+'*record id*'+recordId);
            var action = component.get('c.wrapRec');
        action.setParams({
            serviceOrderId : recordId,
            spn : spn,
            cumminsfaultCode : cumCode,
            pcode : pcode,
            highLevelSymptom : highLevelSymptom,
            lowLevelSymptom : lowLevelSymptom,
        });
            //alert();
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in wrapperList attribute on component.
                console.log('Success of GetSolutionsTable doAction Method');
                component.set('v.wrapperList', response.getReturnValue());
                component.set("v.ShowSpinner", false);//added by Piyush VGRS2-321
                  //added by sai as part of CT1-400
                var appEvent = $A.get("e.c:EVL_PathChange");  
                appEvent.setParams({ "statusValue" : "Triage & Diagnosis" });   
                appEvent.fire();
                
                var ExAppEvent = $A.get("e.c:EVL_RefreshComponent");
                // Set here event attribute value
                ExAppEvent.setParams({"Description" : "Refresh Make And Model Cmp"});
                ExAppEvent.fire();
              
            }
            else{
                console.log('Error of GetSolutionsTable doAction Method');
            }
            component.set("v.ShowSpinner", false);//added by Piyush VGRS2-321
        });
        $A.enqueueAction(action);
    
			// add your code here
		}
    },
    
    //added by Sriprada
    getSolutions :function(component, event, helper)
    {
        console.log("krishna");
        var faultID = event.target.getAttribute("data-id");
  		console.log('Faultid  ==  '+faultID);
        var recWOId = component.get("v.recordId");
        let errorProWO = "";
        
        var action_ProWO = component.get("c.validateProductOnWO");
        action_ProWO.setParams({
            'workOrderId': recWOId
        });
        
        
            //component.find("setOfTabs").set("v.selectedTabId", "solution");
            //var ace = component.find("setOfTabs");	//.get("v.selectedTabId");	//, "solution");
            //console.log("krishna"+ ace);
            
        //console.log('getSolutions called $$$$$$$$$$$');
        //var faultID = event.target.getAttribute("data-id");
  		//console.log('Faultid  ==  '+faultID);
        // var childCmp2 = component.find("childCmp2");
        //childCmp2.sampleMethodDisSol(recordId); 
        
       
        var woId = component.get("v.recordId");
        console.log('woId == '+woId);
        var action = component.get("c.changeRecord");
        var tbName = 'Triage & Diagnosis';
       
        
        action.setParams({
            'workId': woId,
            'faultID':faultID,
            'TabName': tbName
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var resp = response.getReturnValue();
            
            console.log('StateCheck:::'+state);
            console.log('StateCheck:::'+resp);
            
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

            if (state === "SUCCESS")
            {
                console.log('ValidateCheck::'+resp);
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
                    
                } /* Code ends here --- Sriprada */
                
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
        
        /*    var cmpEvent = component.getEvent("cmpEvent");
        console.log('Faultid  ==  '+cmpEvent);
        cmpEvent.setParams({
            "faultCode" : faultID });
        cmpEvent.fire();
        */
    },
    
    closeWind: function(component, event, helper) {
        component.set("v.isOpen", false);
        if(component.get("v.isMileageErr") || component.get("v.isHoursErr")){
            var recWOId = component.get("v.recordId");
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
         var ctarget = event.currentTarget;
        var solId = ctarget.dataset.value;
        var faultID = event.target.getAttribute("data-value");
       // component.set("v.faultId",faultID);
         //alert('karthiki  PR'+faultID);
		 helper.editCompHelper(component, event, solId,faultID);
     
    },   
    
 })