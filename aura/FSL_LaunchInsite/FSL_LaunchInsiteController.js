({
    doInit : function(component, event, helper) {  
        helper.servicejobname(component, event, helper); 
        // component.set("v.showPriorityTable",false);
    },   
    launchinsite : function(component, event, helper) {
        
        var WorkOrderNumber = component.get("v.servicejobname");
        var CustomerName = component.get("v.ContactName");
        var userId = $A.get('$SObjectType.CurrentUser.Id');
        var urlEvent = $A.get("e.force:navigateToURL");
        helper.trackLaunchInsite(component, event, helper);
        var fldVal1 =  WorkOrderNumber + '| CUSTNAME:' + CustomerName + '| TECHID:' + userId + '| SESNID:'; 
        urlEvent.setParams({"url": 'INSITE: ACTION:GetEngineInformation| CJOD:' + fldVal1 });
        urlEvent.fire();      
    },
    warningmsg : function(component, event, helper) {
        //Piyush start
        helper.chckFaultcode(component, event, helper)
        //helper.esnerrormessage(component, event, helper);
        // Piyush End
        var msgk =component.get("v.Assetname");
        //var msg = msgk +" <br />"+Use CSS Engine Serial Number" + "<br />" + "Keep the current ESN value in the CSS jon";
        var msg= "Use CSS Engine Serial Number" + "<br />" + "Keep the current ESN value in the CSS jon";
        // compoent.set("v.errormesaage",msg);
        //only Line 25 added ravikanth it is used for take control when we click on get fault codes the user id will save on backend
        helper.updatecontrollusr(component, event, helper);
    },
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    //Piyush start
    //Use Insite Product Serial Number Button Select
    useInsite: function(component, event, helper) {
        // Set isModalOpen attribute to false
        /* console.log('before initial spinner controller');
        helper.showSpinner(component);
        console.log('after initial spinner controller'); */
        component.set("v.ShowSpinner", true);//added by Piyush for VGRS2-36
        var action = component.get("c.checkAsset");
        action.setParams({ "assestNum" : component.get("v.InsiteESN"),
                          "accountId": component.get("v.accountId"),
                          "strjobId":component.get("v.recordId")});
        
        action.setCallback( this, function(response) {
            var state = response.getState();    
            if (state === "SUCCESS") {
                if(response.getReturnValue() == "No Assest exist"){
                    component.set("v.ShowSpinner", false);//added by Piyush for VGRS2-36
                    component.set("v.isErrorModalOpen",true); 
                    component.set("v.assetBlankModal", false);
                    component.set("v.showPriorityTable",false); 
                }
                else{
                    component.set("v.showPriorityTable",true); 
                    //component.set("v.showPriorityTable",true); 
                    component.set("v.isModalOpen", false);
                    component.set("v.isErrorModalOpen", false);
                    component.set("v.assetBlankModal", false);
                    component.set("v.faultCodeMaxSequence",null);
                    component.set("v.ShowSpinner", false); //added by Piyush for VGRS2-36
                    // component.set("v.fetchLatest",true);
                    var childComponent = component.find("childCmp");
                    var message = childComponent.messageMethod();
                    
                }
                 setTimeout(function(){
                    window.location.reload();
                }, 10000);

                              
            }else {
                var errorMsg = action.getError()[0].message;
                console.log(errorMsg);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: 'Error',
                    type: 'error',
                    message: errorMsg,
                    mode: 'sticky'
                });
                toastEvent.fire();
            }   
           /* console.log('before spinner respone controller');
            helper.hideSpinner(component); 
            console.log('after spinner respone controller'); */
        });
        $A.enqueueAction(action);
        component.set("v.isModalOpen", false);
    }, 
    
    useCSSEngine: function(component, event, helper) {
        // Set isModalOpen attribute to false
        component.set("v.ShowSpinner", true);//added by Piyush VGRS2-36
        component.set("v.showPriorityTable",true); 
        component.set("v.isModalOpen", false);
        component.set("v.isErrorModalOpen", false);
        component.set("v.assetBlankModal", false);
        component.set("v.faultCodeMaxSequence",null);
        // component.set("v.fetchLatest",true);
        var childComponent = component.find("childCmp");
        var message = childComponent.messageMethod();
        component.set("v.ShowSpinner", false);//added by Piyush VGRS2-36
    },
    
    closeAssetErrorModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.assetLockedErr", false);
    },
    //Piyush end
    closeErrorModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isErrorModalOpen", false);
        component.set("v.assetBlankModal", false);
        component.set("v.assetBlankModal", false);
    },
    takecontroll: function(component, event, helper) {
        
        component.set("v.isopenModelTakecontroll", true);
    },
    
    updatetakecontrolusr: function(component, event, helper) {
        component.set("v.isopenModelTakecontroll", false);
        helper.hidelauchinsite(component, event, helper);
    },
    closeNofaultErrorModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.showNoFaultCode", false);
        component.set("v.isopenModelTakecontroll", false); // Added Ravikanth
    },
    //Added Ravikanth to refresh the page after updating the controll user
    isRefreshed: function(component, event, helper) {
        //location.reload();
    },
    // line 139 to 147 commented as part of enabling CICO
   /* handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "CHANGED") {
            

            $A.get('e.force:refreshView').fire();
            
            
            }
    }*/
    //Modified by Krishna for TW-52 as part of CICO toggle Switch
    handleRecordUpdated: function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        //component.set("v.showPriorityTable",false);
        //component.set("v.showPriorityTable",true);
        // alert('recordupdate called');
        var eventParams = event.getParams();
        console.log('eventParams.changeType------>Controller'+eventParams.changeType);
        console.log('component.get("v.record").Clock_In_User_Ids_Formula__c ------>Controller'+component.get("v.record").Clock_In_User_Ids_Formula__c);
        console.log('userId----->Controller'+userId);
        console.log('component.get("v.record.User__r.Id")'+component.get("v.record.User__r.Id"));
        console.log('component.get("v.record").isCICOVisible__c'+component.get("v.record").isCICOVisible__c);
        if(eventParams.changeType === "CHANGED") {
            if(component.get("v.record").Clock_In_User_Ids_Formula__c != null && (component.get("v.record.User__r.Id") == 'undefined' || component.get("v.record.User__r.Id") == null || component.get("v.record.User__r.Id") == '')){
                console.log('+++161');
                component.set("v.showlaunch",false);
                component.set("v.hidelaunchinsite",false);
                component.set("v.hidelaunchinsitebutton",true);
            }
            //Added by Krishna as part of MV-215
            if(component.get("v.record").Clock_In_User_Ids_Formula__c == null && component.get("v.record").isCICOVisible__c == true){
                component.set("v.showlaunch",true);
                component.set("v.hidelaunchinsite",false);
                component.set("v.hidelaunchinsitebutton",false);
            }
            
            if(component.get("v.record.User__r.Id") == userId && component.get("v.record").Clock_In_User_Ids_Formula__c != null){
                component.set("v.hidelaunchinsite",true);
                component.set("v.hidelaunchinsitebutton",false);
                component.set("v.showlaunch",false);
            } 
            
            else if((component.get("v.record.User__r.Id") != null && component.get("v.record.User__r.Id") != '' && component.get("v.record.User__r.Id") != userId) && component.get("v.record").Clock_In_User_Ids_Formula__c != null){
                component.set("v.hidelaunchinsite",false);
                component.set("v.hidelaunchinsitebutton",true);
                component.set("v.showlaunch",false);
            }
			//location.reload();
			$A.get('e.force:refreshView').fire(); //Added By Krishna as part of TW-73
        }
    }   
})