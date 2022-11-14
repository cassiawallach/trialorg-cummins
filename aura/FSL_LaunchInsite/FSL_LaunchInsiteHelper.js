({
    servicejobname : function(component, event, helper) {
        var isCICOFlag;
        //alert('helper called');
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
                    component.set("v.showPriorityTable",true);  
                    component.set("v.faultCodeMaxSequence",response.getReturnValue().FaultCode_Max_Sequence__c);
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
                else {
                    component.set("v.previoususr"," " );
                }
                //Added by Krishna as part of MV-215
                //Modified by Krishna for TW-52 as part of CICO toggle Switch

                console.log('response.getReturnValue().Clock_In_User_Ids_Formula__c---> inside helper',response.getReturnValue().Clock_In_User_Ids_Formula__c);
                console.log('response.getReturnValue().User__c---> inside helper',response.getReturnValue().User__c);
                console.log('userId-----> inside helper',userId)
                var resultNew = response.getReturnValue().ServiceTerritory;
				console.log('-----41 resultNew',resultNew);
                console.log('----42',response.getReturnValue().isCICOVisible__c);
                for(const cicoToggle in resultNew){
                    if(cicoToggle == 'isVisibileCICO__c'){
                        isCICOFlag = resultNew[cicoToggle];
                    }
                }
                
                console.log('isCICOFlag---->inside helper',isCICOFlag);
                if((response.getReturnValue().Clock_In_User_Ids_Formula__c== null || response.getReturnValue().Clock_In_User_Ids_Formula__c== '' || response.getReturnValue().Clock_In_User_Ids_Formula__c=='undefined') && response.getReturnValue().isCICOVisible__c == true){
                    component.set("v.showlaunch",true);
                    component.set("v.hidelaunchinsite",false);
                    component.set("v.hidelaunchinsitebutton",false);
                } 
                else{
                    if(response.getReturnValue().User__c== null || response.getReturnValue().User__c== ''|| response.getReturnValue().User__c == userId){
                        component.set("v.hidelaunchinsite",true);
                        component.set("v.hidelaunchinsitebutton",false);
                    } 
                    
                    else if(response.getReturnValue().User__c!= null && response.getReturnValue().User__c!= '' && response.getReturnValue().User__c != userId){
                        component.set("v.hidelaunchinsite",false);
                        component.set("v.hidelaunchinsitebutton",true);
                    }
                }
                //location.reload();
            }
            
        	
            
            //commented as part of enabling CICO   
            /* if(response.getReturnValue().User__c== null || response.getReturnValue().User__c== ''|| response.getReturnValue().User__c == userId){
                    component.set("v.hidelaunchinsite",true);
                    component.set("v.hidelaunchinsitebutton",false);
                } 
                
                else if(response.getReturnValue().User__c!= null && response.getReturnValue().User__c!= '' && response.getReturnValue().User__c != userId){
                    component.set("v.hidelaunchinsite",false);
                    component.set("v.hidelaunchinsitebutton",true);
                }
            } */
            else{
                alert('Error message: Unknown error has occurred ');
            }
            
        });
        $A.enqueueAction(action);
    } ,
    
    esnerrormessage : function(component, event, helper) {
        
        var action = component.get("c.getWorkOrderData");
        action.setParams({ workOrderId : component.get("v.recordId") });
        
        action.setCallback( this, function(response) {
            var state = response.getState(); 
            console.log('State*****'+state);
            //{!v.InsiteESN}
            if (state === "SUCCESS") { 
                console.log('responseVal*****'+response.getReturnValue());
                console.log('::: esnerrormessage Data - ' + JSON.stringify(response.getReturnValue()));
                if(response.getReturnValue() != null && (response.getReturnValue().Asset != "undefined"  && response.getReturnValue().Asset != '' && response.getReturnValue().Asset != null))
                {
                    component.set("v.accountId",response.getReturnValue().AccountId);
                    if(response.getReturnValue().ESN_Insite__c !=null && response.getReturnValue().ESN_Insite__c !='' 
                       && response.getReturnValue().Asset.Name != null && response.getReturnValue().Asset.Name != '' 
                       && response.getReturnValue().ESN_Insite__c!=response.getReturnValue().Asset.Name ){
                        if(response.getReturnValue().FSL_Locked_Assest__c  == null){
                            component.set("v.Assetname",response.getReturnValue().Asset.Name);
                            component.set("v.InsiteESN",response.getReturnValue().ESN_Insite__c);
                            component.set("v.isModalOpen",true);
                        }
                        else if(response.getReturnValue().FSL_Locked_Assest__c != response.getReturnValue().ESN_Insite__c){
                            component.set("v.assetLockedErr", true);
                        }
                            else{
                                component.set("v.showPriorityTable",true); 
                                component.set("v.isModalOpen", false);
                                component.set("v.isErrorModalOpen", false);
                                component.set("v.assetBlankModal", false);
                                component.set("v.faultCodeMaxSequence",null);
                                var childComponent = component.find("childCmp");
                                var message = childComponent.messageMethod();   
                                
                            }
                        
                    }
                    else{
                        component.set("v.showPriorityTable",true); 
                        component.set("v.isModalOpen", false);
                        component.set("v.isErrorModalOpen", false);
                        component.set("v.assetBlankModal", false);
                        component.set("v.faultCodeMaxSequence",null);
                        var childComponent = component.find("childCmp");
                        var message = childComponent.messageMethod(); 
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
    //Piyush s
    chckFaultcode : function(component, event, helper) {
        component.set("v.ShowSpinner", true);//added by Piyush for VGRS2-36
        //Fetching max sequence from curent DB
        var action = component.get("c.checkCountFaultcode");
        action.setParams({ strjobId : component.get("v.recordId") });
        
        action.setCallback( this, function(response) {
            var state = response.getState(); 
            console.log('State*****'+state);
            if (state === "SUCCESS") { 
                console.log('responseVal*****'+response.getReturnValue());
                var faultCodeMax = component.get("v.faultCodeMaxSequence")!=''?component.get("v.faultCodeMaxSequence") :0;
                //if any new sequence exists in DB 
                //Commenting temporarily for testing
                //if(response.getReturnValue() != 0 && response.getReturnValue() > component.get("v.faultCodeMaxSequence") ){
                if(response.getReturnValue() != 0){
                    if(response.getReturnValue() != 0){
                        helper.esnerrormessage(component, event, helper);
                        //
                        helper.trackFaultCode(component, event, helper);
                        //Sakthiraj - 08/17/22 - SG-105 - method to call API's for FTR Automation
                        helper.callFTRAutomation(component); 
                    }
                    else{
                        component.set("v.showNoFaultCode",true);
                        
                    }
                }
                else if(response.getReturnValue() == 0 ) {
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
    
    //Piyus - For Capturing Audit track of Get Fault Codes/Solutions
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
                //Commented below lOC as it only refresh if the state is success
                //wanted to refresh in all the conditions so keeping out the side if else loop
                $A.get('e.force:refreshView').fire();
                if( response.getReturnValue().User__c == userId){
                    //Added by Krishna as part of TW-52
                    component.set("v.hidelaunchinsite",true);
                    component.set("v.hidelaunchinsitebutton",false);
                }
                
            } 
            else{
                var errorMsg = action.getError()[0].message;
                component.set("v.errorMsg",errorMsg);
            }
            // location.reload();
          component.set("v.ShowSpinner", false);//added by Piyush VGRS2-327
        });
        $A.enqueueAction(action);
    },
    showSpinner: function (component, event, helper) {
        var spinner = component.find("Spinner");
        console.log('entered spinner helper');
        alert('enteredSpinner');
        $A.util.removeClass(spinner, "slds-hide");
        /*window.setTimeout(
            $A.getCallback(function() { 
                $A.util.addClass(spinner, "slds-hide");
            }), 20000
        );*/
        window.setInterval(            
            $A.getCallback(function() { 
                $A.util.addClass(spinner, "slds-hide");
            }), 10000
        );
    },
    
    hideSpinner: function (component, event, helper) {
        var spinner = component.find("Spinner");
        $A.util.addClass(spinner, "slds-hide");
        /*window.setTimeout(
            $A.getCallback(function() { 
                $A.util.addClass(spinner, "slds-hide");
            }), 20000
        );*/
    },
    //this function is used for take control when user perform any job on get fault code solutions
    updatecontrollusr : function(component, event, helper) {
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
            
        });
        $A.enqueueAction(action);
    }, 
    //Ravi End
    //Sakthiraj - 08/17/22 - SG-105 - Method to call API's for FTR Automation
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
                    this.callGetPartsAndPartReturn(component);
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
                
            } else {
                component.set("v.errorMsg", response.getError()[0].message);
            }
            component.set("v.ShowSpinner", false);
        });
        $A.enqueueAction(action);
    },
    //This method will call Get SRT Parts and Get Part Returns
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
    //Sakthiraj - 08/17/22 - SG-105 - Method to call API's for FTR Automation
    
})