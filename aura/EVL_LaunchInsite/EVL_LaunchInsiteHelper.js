({
    servicejobname : function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.getjobordernumber");
        action.setParams({ strjobId : component.get("v.recordId") });
        
        action.setCallback( this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") { 
                //Piyush settup value for fault code table pinned.
                if($A.util.isUndefinedOrNull(response.getReturnValue().FaultCode_Max_Sequence__c)){
                    component.set("v.faultCodeMaxSequence",0);
                }
                else {
                    component.set("v.ShowSpinner", true);//added by Piyush for VGRS2-36
                    component.set("v.showPriorityTable",true);  
                    //alert('FaultCode_Max_Sequence__c - '+response.getReturnValue().FaultCode_Max_Sequence__c); 
                    component.set("v.faultCodeMaxSequence",response.getReturnValue().FaultCode_Max_Sequence__c);
                    component.set("v.ShowSpinner", false);//added by Piyush for VGRS2-36
                } 
                //Piyush settup value End
                component.set("v.servicejobname",response.getReturnValue().WorkOrderNumber);
                if(response.getReturnValue().Contact != null && response.getReturnValue().Contact.Name != null ){
                    component.set("v.ContactName",response.getReturnValue().Contact.Name);
                }
                component.set("v.InsiteESN",response.getReturnValue().ESN_Insite__c);
                // Added Ravi -setup take controll user name value to attribute 
                
                if( response.getReturnValue().User__c != null  && response.getReturnValue().User__r.Name != null ){
                    component.set("v.previoususr",response.getReturnValue().User__r.Name );
                }
                else if(response.getReturnValue().User__c == null || response.getReturnValue().User__c === 'undefined'){
                    component.set("v.previoususr",response.getReturnValue().CreatedBy.Name );
                } 
                else {
                    component.set("v.previoususr"," " );
                } 
                /*Condition updated to Consider EVL Technicians - Sruthi
                if(((response.getReturnValue().User__c == null || response.getReturnValue().User__c == '') && response.getReturnValue().CreatedById == userId) || response.getReturnValue().User__c == userId || (userLoc != null && userLoc == response.getReturnValue().Service_Location_Code__c)){
                    component.set("v.hidelaunchinsite",true);
                    component.set("v.hidelaunchinsitebutton",false);
                } 
                
                else if(response.getReturnValue().User__c == null || response.getReturnValue().User__c == '' || (response.getReturnValue().User__c!= null && response.getReturnValue().User__c!= '' && response.getReturnValue().User__c != userId)){
                    component.set("v.hidelaunchinsite",false);
                    component.set("v.hidelaunchinsitebutton",true);
                }*/
                    /*else if(response.getReturnValue().EVL_Assigned_Technician__c && response.getReturnValue().User__c != userId){ //Condition included to Consider EVL Technicians - Sruthi
                        component.set("v.hidelaunchinsite",false);
                        component.set("v.hidelaunchinsitebutton",true);alert('Inside 3');
                    }*/
            } 
            else{
                alert('Error message: Unknown error has occurred ');
            }
            
        });
        $A.enqueueAction(action);
    } ,
    
    fetchTakeControl : function(component, event, helper){
		
		var actionCon = component.get("c.fetchTakeControl");
        actionCon.setParams({ strjobId : component.get("v.recordId") }); 
        
        actionCon.setCallback( this, function(response) {
            var state = response.getState();
            
            
            if (state === "SUCCESS") { 
                
                
                if(response.getReturnValue()){
                    component.set("v.hidelaunchinsite",true);
                    component.set("v.hidelaunchinsitebutton",false);
                } 
                
                else {
                    component.set("v.hidelaunchinsite",false);
                    component.set("v.hidelaunchinsitebutton",true);
                }
            } 
            
        });
        $A.enqueueAction(actionCon);
    },
    
    esnerrormessage : function(component, event, helper) {
        
        var action = component.get("c.getWorkOrderData");
        action.setParams({ workOrderId : component.get("v.recordId") });
        // alert('PsnERROrkarthik');
        action.setCallback( this, function(response) {
            var state = response.getState(); 
            //alert('state>>>>>>>>'+state);
            console.log('State*****In esnerror'+state);
            //{!v.InsiteESN}
            if (state === "SUCCESS") { 
                console.log('responseVal*****>>>'+response.getReturnValue());
                console.log('::: esnerrormessage Data - ' + JSON.stringify(response.getReturnValue()));
                if(response.getReturnValue() != null && (response.getReturnValue().Asset != "undefined"  && response.getReturnValue().Asset != '' && response.getReturnValue().Asset != null))
                {
                    component.set("v.accountId",response.getReturnValue().AccountId);
                    if(response.getReturnValue().ESN_Insite__c !=null && response.getReturnValue().ESN_Insite__c !='' 
                       && response.getReturnValue().Asset.Name != null && response.getReturnValue().Asset.Name != '' 
                       && response.getReturnValue().ESN_Insite__c!=response.getReturnValue().Asset.Name ){
                        if(response.getReturnValue().FSL_Locked_Assest__c  == null){
                            // alert('esnerrormessagebefore popup');
                            component.set("v.Assetname",response.getReturnValue().Asset.Name);
                            component.set("v.InsiteESN",response.getReturnValue().ESN_Insite__c);
                            component.set("v.isModalOpen",true);
                        }
                        else if(response.getReturnValue().FSL_Locked_Assest__c != response.getReturnValue().ESN_Insite__c){
                            component.set("v.assetLockedErr", true);
                        }
                            else{
                                component.set("v.ShowSpinner", true);//added by Piyush for VGRS2-36
                                component.set("v.showPriorityTable",true); 
                                component.set("v.isModalOpen", false);
                                component.set("v.isErrorModalOpen", false);
                                component.set("v.assetBlankModal", false);
                                component.set("v.faultCodeMaxSequence",null);
                                var appEvent = $A.get("e.c:EVL_PathChange");
                                appEvent.setParams({"statusValue" : "Triage & Diagnosis"}); 
                                appEvent.fire();
                                var childComponent = component.find("childCmp");
                                var message = childComponent.messageMethod(); 
                                component.set("v.ShowSpinner", false);//added by Piyush for VGRS2-36
                         	  /*  var appEvent = $A.get("e.c:EVL_PathChange");
                                appEvent.setParams({"statusValue" : "Triage & Diagnosis"}); 
                                appEvent.fire(); */
                          	  // $A.get('e.force:refreshView').fire(); 
                                
                            }
                        
                    }
                    else{
                        component.set("v.ShowSpinner", true);//added by Piyush for VGRS2-36
                        component.set("v.showPriorityTable",true); 
                        component.set("v.isModalOpen", false);
                        component.set("v.isErrorModalOpen", false);
                        component.set("v.assetBlankModal", false);
                        component.set("v.faultCodeMaxSequence",null);
                        var appEvent = $A.get("e.c:EVL_PathChange");
                        appEvent.setParams({"statusValue" : "Triage & Diagnosis"}); 
                        appEvent.fire();
                        var childComponent = component.find("childCmp");
                        var message = childComponent.messageMethod(); 
                        component.set("v.ShowSpinner", false);//added by Piyush for VGRS2-36
                      /* var appEvent = $A.get("e.c:EVL_PathChange");
                        appEvent.setParams({"statusValue" : "Triage & Diagnosis"}); 
                        appEvent.fire(); */
                      //  $A.get('e.force:refreshView').fire(); 
                    }
                } else {
                    component.set("v.assetBlankModal", true);
                }
            } 
            else{
                component.set("v.assetBlankModal", true);
            }
            
        });
        $A.enqueueAction(action);
    } ,
    //Piyush 
    chckFaultcode : function(component, event, helper) {
         component.set("v.ShowSpinner", true);//added by Piyush for VGRS2-36
        //Fetching max sequence from curent DB
        var action = component.get("c.checkCountFaultcode");
        action.setParams({ strjobId : component.get("v.recordId") });
        // alert('tttttttttcheckfalut');
        action.setCallback( this, function(response) {
            var state = response.getState(); 
            console.log('State*****'+state);
            if (state === "SUCCESS") {
                
                console.log('responseVal*KKKKKKK****'+response.getReturnValue());
                var faultCodeMax = component.get("v.faultCodeMaxSequence")!=''?component.get("v.faultCodeMaxSequence") :0;
                //if any new sequence exists in DB 
                //Commenting temporarily for testing
                //if(response.getReturnValue() != 0 && response.getReturnValue() > component.get("v.faultCodeMaxSequence") ){
                if(response.getReturnValue() != 0){
                    helper.esnerrormessage(component, event, helper);
                    helper.trackFaultCode(component, event, helper);
                    //Sakthiraj - 07/28/22 - SG-82 and SG-83 - method to call API's for FTR Automation
                    helper.callFTRAutomation(component); 
                } else if(response.getReturnValue() == 0 ) {
                    component.set("v.showNoFaultCode",true);
                }
            } 
            else{
                alert('Error message: Unknown error has occurred ');
            }
          component.set("v.ShowSpinner", false);//added by Piyush for VGRS2-36
        });
        $A.enqueueAction(action);
    } ,
    
    //Piyush - For Capturing Audit track of Get Fault Codes/Solutions
    trackFaultCode: function(component, event, helper) {
        var action = component.get("c.captureFaultCodeAuditTrack");
        action.setParams({ 
            workOrderId : component.get("v.recordId") 
        });
        action.setCallback( this, function(response) {
            var state = response.getState(); 
            if (state === "SUCCESS") { 
                console.log('Saved Get Fault Codes/Solutions');
            } else {
                console.log('::: Error while Get Fault Codes/Solutions Audit Track');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    //Piyush - For Capturing Audit track of Launch Insite
    trackLaunchInsite : function(component, event, helper) {
        var action = component.get("c.captureLaunchInsiteAuditTrack");
        action.setParams({ 
            workOrderId : component.get("v.recordId") 
        });
        action.setCallback( this, function(response) {
            var state = response.getState(); 
            if (state === "SUCCESS") { 
                console.log('Saved Launch INSITE');
            } else {
                console.log('::: Error while Launch Insite Audit Track');
            }
            
            
        });
        $A.enqueueAction(action);
    },
    
    //Piyush e
    // Added Ravi 
    hidelauchinsite : function(component, event, helper) {
        component.set("v.ShowSpinner", true);//added by Piyush VGRS2-327
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.hidetakecontrol");
        action.setParams({ strjobId : component.get("v.recordId") });
        action.setCallback( this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") { 
                 location.reload();
                
             //   $A.get('e.force:refreshView').fire();
                if( response.getReturnValue().User__c == userId){
                    
                    // component.set("v.hidelaunchinsite",true);
                    // component.set("v.hidelaunchinsitebutton",false);
                }
                
            } 
            else{
                var errorMsg = action.getError()[0].message;
                component.set("v.errorMsg",errorMsg);
            }
           component.set("v.ShowSpinner", false);//added by Piyush VGRS2-327 
        });
        $A.enqueueAction(action);
    },
    //this function is used for take control when user perform any job on get fault code solutions
    updatecontrollusr : function(component, event, helper) {
       // component.set("v.ShowSpinner", true);//added by Piyush for VGRS2-36
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.hidetakecontrol");
        action.setParams({ strjobId : component.get("v.recordId") });
        action.setCallback( this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") { 
                
            } 
            else{
                var errorMsg = action.getError()[0].message;
                component.set("v.errorMsg",errorMsg);
            }
         //  component.set("v.ShowSpinner", false); //added by Piyush for VGRS2-36
        });
        $A.enqueueAction(action);
    },
    //Ravi End
    //Sakthiraj - 07/28/22 - SG-82 and SG-83 - Method to call API's for FTR Automation
    //This method will call Get solutions API
    callFTRAutomation: function(component) {
        component.set("v.ShowSpinner", true);
        var action = component.get("c.getSolutionsForFTR");
        action.setParams({ woId : component.get("v.recordId") });
        action.setCallback( this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") { 
                if(response.getReturnValue()){
                    this.callGetOptions(component);
                }
            } else {
                component.set("v.errorMsg", response.getError()[0].message);
                component.set("v.ShowSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    // This method will call Get options, GET SRT Repait and Get Detail coverage
    callGetOptions: function(component) {
        component.set("v.ShowSpinner", true);
        var action = component.get("c.callGetOptionsAndOtherApis");
        action.setParams({ serviceOrderId : component.get("v.recordId") });
        action.setCallback( this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") { 
                this.callGetPartsAndPartReturn(component);
            } else {
                component.set("v.errorMsg", response.getError()[0].message);
            }
            component.set("v.ShowSpinner", false);
        });
        $A.enqueueAction(action);
    },
    //FTR API Automation End - Sakthiraj - SG-82 and SG-83
    //This method will call Get SRT Parts and Get Part Returns - SG-99
    callGetPartsAndPartReturn: function(component) {
        component.set("v.ShowSpinner", true);
        var action = component.get("c.callGetPartsAndPartReturn");
        action.setParams({ serviceOrderId : component.get("v.recordId") });
        action.setCallback( this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") { 
                
            } else {
                component.set("v.errorMsg", response.getError()[0].message);
            }
            component.set("v.ShowSpinner", false);
        });
        $A.enqueueAction(action);
    }
})