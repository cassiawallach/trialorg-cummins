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
                component.set("v.processStep", res.getReturnValue());
            }
        }); 
        $A.enqueueAction(action); 
    },
    
    //Added by Harish - TW-204
      getType : function (component, event, helper){
        var action = component.get('c.getServiceOrderType');
        var txt_recordId = component.get("v.recordId");
        action.setParams({
            woId : txt_recordId
        });
        action.setCallback(this, function(res) { 
            if (res.getState() === 'SUCCESS') { 
                component.set("v.serviceOrderType", res.getReturnValue());
            }
        }); 
        $A.enqueueAction(action); 
    },
    
    getStep : function (component, event, helper){
        var action = component.get('c.getstateStatus');
        var txt_recordId = component.get("v.recordId");
        action.setParams({
            woId : txt_recordId
        });
        action.setCallback(this, function(res) { 
            if (res.getState() === 'SUCCESS') { 
                component.set("v.stateStep", res.getReturnValue());
            }
        }); 
        $A.enqueueAction(action); 
    },
    
    getStep1 : function (component, event, helper){
        var action = component.get('c.getstateStatus1');
        var txt_recordId = component.get("v.recordId");
        action.setParams({
            woId : txt_recordId
        });
        action.setCallback(this, function(res) { 
            if (res.getState() === 'SUCCESS') { 
                component.set("v.stateStep1", res.getReturnValue());
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
        //alert(stage);
        // alert(component.get("v.profileName"));
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
        //  var stageClick = event.target.getAttribute('data-index');
        var stageClick =  component.get("v.chevronClick");
        console.log(stageClick);
        console.log('processStep>>'+component.get("v.processStep"));
        var action  = component.get("c.updateStageAndRecordType");
        action.setParams({
            strWorkOrderId : component.get("v.recordId"),
            stageName : stageClick
        });
        action.setCallback(this,function(response){
            if (response.getState() === 'SUCCESS') { 
                //alert('success');
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
                console.log('sucess', result); 
                // 7/21/22 Naga Anusha Devi Malepati started added code for capturing Integration errors of Send 4Cs to ERP NIN-444
                var send4CsError = $A.get('$Label.c.FSL_Send_4Cs_to_ERP');
                if(!$A.util.isUndefinedOrNull(result) && result.includes(send4CsError)){
                    component.set('v.errorString',result );
                }
                else {
                    var selectedValues = component.get("v.Authorized_Work_Started__c");
                    component.set('v.errorString', '');
                    var currentStage = component.get("v.stateStep");
                    var currentStage1 = component.get("v.stateStep1");
                    var stageClick =  component.get("v.chevronClick");
                    if(component.get("v.profileStageList").includes(stageClick)){
                        this.updateStageAndRecordType(component,event);
                    } 
                }
            }
            else{
                console.log('failing Reason',response.getError());
            }
        });
        // 7/21/22 Naga Anusha Devi Malepati Ends here for capturing Integration errors of Send 4Cs to ERP NIN-444
        $A.enqueueAction(action);
    },
    isWorkOrderCreated : function(component,event,helper){
        var action = component.get("c.isWorkOrderCreated");
        action.setParams({
            workOrderId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state==='SUCCESS') {
              	component.set("v.isWorkOrderCreated",response.getReturnValue());
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
    isTechDispatched : function(component,event,helper){
        var action = component.get("c.isTechDispatched");
        action.setParams({
            workOrderId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state=='SUCCESS') {
              	component.set("v.isTechDispatched",response.getReturnValue());
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
    //Added by Piyush for CT2-199-Start
    checkOpenTimeSheet: function(component, event, helper, currentStage) {
        var action = component.get("c.checkOpenTimeSheet");
        action.setParams({
            workOrderId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                var checkOpenTS = response.getReturnValue();
               // alert(JSON.stringify(checkOpenTS));
                console.log('::: checkOpenTS = '+JSON.stringify(checkOpenTS));
                
               //Modified By Harish as part of TW-134
                if(checkOpenTS.userERP !== 'BMS' && checkOpenTS.woType === 'Internal'){
                   component.set("v.ErrorMsgforOpenTS", true);
                   component.set("v.ErrorMsgforInternalWO", true);
                }/*added by mallika for CT2-166 -end */
                else if(checkOpenTS.isTimeSheetOpen) {
                   // helper.showToast('Error','Error','Service Order Can not close with Open Time Sheet');
                   component.set("v.ErrorMsgforOpenTS", true);
                } 
                else {
                    helper.handleCloseChevron(component,event,helper,currentStage); 
                }
            } else {
                console.log('Unknown Error');
            }
        });
        $A.enqueueAction(action);
    },
// Added by Piyush for CT2-199-End    
    handleCloseChevron : function(component,event,helper,currentStage){
        console.log('In close');
        $A.createComponent("c:FSL_ServiceOrder_LightningPath_Close", 
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
    handleOnChangeHelper : function(component, event, helper){
        component.set("v.showSpinner",true);  
       // alert('Test');
        var action = component.get("c.callBMSWebServices");
        action.setParams({
            workOrderId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            
            if (state==='SUCCESS') {
                var returnVal = response.getReturnValue();
                console.log('Response:'+returnVal);
                  if(returnVal)
                {
                    console.log(returnVal);
                    if(!returnVal.BMSReferenceNumber || returnVal.BMSReferenceNumber === '')
                    {
                        var bmsError = returnVal.errormsg;
                        var errorMsg = bmsError.includes('Guidanz@cummins.com');
                        if(bmsError && errorMsg == true){
                            var ermsg = bmsError;
                        } else{
                            var ermsg = returnVal.errormsg ? returnVal.errormsg : "Send to Assign is not available since ERP WorkOrder doesn't exist";}
                        component.set("v.errorString", ermsg);
                    }
                    else
                    {
                        resultsToast.setParams ({
                            "type": "Success",
                            "title": "Success",
                            "message": "Service Order is updated "
                        });
                        $A.get("e.force:refreshView").fire();
                        var dismissActionPanel = $A.get("e.force:closeQuickAction");
                        dismissActionPanel.fire();
                    }   
                }    
                    
                console.log("callBMSWebServices success")
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
            component.set("v.showSpinner",false);
            
        }); 
        $A.enqueueAction(action);
    }
})