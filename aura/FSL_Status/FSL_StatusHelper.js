({
    chechCustomerCreditMessageCode: function(component, event, helper){
        var action = component.get("c.checkCustomerMessageCode");
        var recId = component.get("v.recordId");
        action.setParams({
            "serviceJob" : recId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if(state === "SUCCESS") {
                if(result) {
                    component.set("v.errorString","Send to Assign not available for this Payer, please select a different Payer");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchCurrentUserERP : function(component, event, helper) {
        var action = component.get('c.getCurrentUserERP');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log('::: Current User ERP = '+response.getReturnValue());
                component.set('v.currentUserErp', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    //validation
    valdateAndUpdateWorkOrder: function(component, event,toupdate,helper)
    {
        //alert('recId:'+recId);
        var currentUserERP = component.get('v.currentUserErp');
        var action = component.get("c.getWorkOrder");
        var recId = component.get("v.recordId");
        action.setParams({
            "objectID" : recId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if(toupdate) {
                // result = component.get("v.WorkOrderObject");
            }
            console.log('Result === ' +JSON.stringify(result));
            var resultsToast = $A.get("e.force:showToast");
            if(state === "SUCCESS") {
                this.insertstagingvalues(component, event, helper); // Added by Ravikanth when click on send to assign and confirm
                if(result) {
                    console.log('Account***'+result.AccountId);
                    if(result.AssetId && currentUserERP == 'BMS' && $A.util.isUndefinedOrNull(result.Asset.Unit_Number__c)) {
                        component.set("v.errorString",'Unit number is not available on Asset');
                    } else {
                        if(result.AccountId != null && result.Account.IAM_Service_Provider_Code__c != null) {
                            var str = result.Account.IAM_Service_Provider_Code__c;
                            var cc = str.includes('SERV');
                        }
                        if(result.AccountId && cc == true && !result.Customer_Name__c)
                        {
                            component.set("v.errorString","Please fill out the required information within the Cash Customer Tab to proceed");
                        } 
                        component.set("v.WorkOrder.AccountId",result.AccountId);
                        
                        //Piyush start
                        var msg = result.Customer_Credit_Error_Msg__c;
                        //console.log('msg***'+msg);
                        if (!$A.util.isUndefinedOrNull(msg)) {
                            var i = msg.indexOf(">");
                            var j = msg.indexOf("</");
                            var rawMsg = msg.substring(i+1, j);
                            if(rawMsg == 'Send to Assign not available for this Payer, please select a different Payer')
                            {
                                component.set("v.errorString",rawMsg);
                            }
                        }      //Piyush end
                        if(result.Process_Step__c =='Intake') 
                        {
                            component.set("v.isIntake",true);
                        }
                        /* if(!$A.util.isUndefinedOrNull(result.AssetId) && $A.util.isUndefinedOrNull(result.Asset.Unit_Number__c)) {
                        //console.log('abc');
                        resultsToast.setParams ({
                            "type": "Error",
                            "title": "Unit number is not available on Asset",
                            "message": "Please make sure to capture the unit number on Asset record"
                        });
                        resultsToast.fire();
                    } */
                        if(result.Process_Step__c =='Schedule') 
                        {
                            component.set("v.isSchedule",true);
                            //  this.updateWorkOrder(component,event,result);
                            // component.get("v.WorkOrderObject",result);
                        }
                        var errMessage ;
                        var errCount=0;
                        if(!result.AccountId)
                        {
                            errMessage = 'Account';
                            errCount++;
                            
                        }
                        // else if(!result.ContactId && result.Cash_Payment__c == false) {
                        if(!result.ContactId) 
                        {
                            errCount++;
                            if(errMessage){
                                errMessage = errMessage + ' , Contact';
                            }
                            else{
                                errMessage = 'Contact';
                            }
                            
                        }
                        if(!result.WorkTypeId) {
                            errCount++;
                            if(errMessage){
                                errMessage = errMessage + ' , WorkType';
                            }
                            else{
                                errMessage = 'WorkType';
                            }
                            
                        }
                        if(!result.FSL_Sub_Type__c) {
                            errCount++;
                            if(errMessage){
                                errMessage = errMessage + ' , SubType';
                            }
                            else{
                                errMessage = 'SubType';
                            }
                            
                        }
                        if(!result.General_Symptoms__c) {
                            errCount++;
                            if(errMessage) {
                                errMessage = errMessage + ' , GeneralSymptoms';
                            }
                            else {
                                errMessage = 'GeneralSymptoms';
                            }
                        } 
                        //CT3-495 adding Make & Model for validation before send to assign Start
                        if((!result.AssetId==''||!result.AssetId==null)&&!result.Make__c) {
                            errCount++;
                            if(errMessage) {
                                errMessage = errMessage + $A.get("$Label.c.FSL_Make_Validation");
                            }
                            else {
                                errMessage = $A.get("$Label.c.FSL_Make");
                            }
                        }  
                        if((!result.AssetId==''||!result.AssetId==null)&&!result.Model__c) {
                            errCount++;
                            if(errMessage) {
                                errMessage = errMessage + $A.get("$Label.c.FSL_Model_Validation");
                            }
                            else {
                                errMessage = $A.get("$Label.c.FSL_Model");
                            }
                        }              
                        //CT3-495 adding Make and Model for validation before send to assign End 
                        if(result.Repair_Location__c == 'Mobile' && !result.Repair_Site_Address__c) {
                            errCount++;
                            if(errMessage) {
                                errMessage = errMessage + ' , Repair Site';
                            }
                            else {
                                errMessage = 'Repair Site';
                            }
                        }
                        
                        if(errMessage){
                            if(errCount < 2){
                                errMessage = errMessage + " field is missing";
                            }
                            else{
                                errMessage = errMessage + " fields are missing";
                                
                            }
                            var dismissActionPanel = $A.get("e.force:closeQuickAction");
                            dismissActionPanel.fire();
                            resultsToast.setParams ({
                                "type": "Error",
                                "message": errMessage
                            });
                            resultsToast.fire();
                            
                        }
                        else {
                            if(toupdate) {
                                this.updateWorkOrder(component,event,result);
                            }
                        }
                    }
                    
                }
            }
            else {
                
            }
        });
        $A.enqueueAction(action);
    },
    updateWorkOrder: function(component, event, workOrder)
    {
        // alert('Test')
        component.set("v.showSpinner",true);
        var Substatus=component.get("v.Substatus");
        // var action = component.get("c.setViewStat");
        var wo = workOrder;
        var action = component.get("c.updateWorkOrder");
        // var action = componenr.get("c.fetchUser");
        // var action = result.getReturnValue();
        action.setParams({
            "wo": wo
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('state' + state);
            var resultsToast = $A.get("e.force:showToast");
            if(state === "SUCCESS")
            {
                var returnVal = response.getReturnValue();
                // alert('temp');
                component.set("v.temp",true);
                // this.updateWOComment(component,event,helper);               
                //component.set("v.WorkOrderObject",result);
                // component.set("v.temp",true);
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
                        var errorMsg = '';
                        //Component created to get customer metadata errors
                        var action1 = component.get("c.getCustomMetaDataTypesForErrors");
                        var erMsg = ermsg;
                        if (returnVal.errormsg.endsWith('Timeout exceeded')) {
                            ermsg = ermsg.slice(ermsg.length - 16);
                        } else {
                            ermsg = ermsg.substring(0, 10);
                        }
                        action1.setParams({
                            errorCode: ermsg
                        });
                        action1.setCallback(this, function (response) {
                            var state = response.getState();
                            var result = response.getReturnValue();
                            console.log('state' + state);
                            if (state === "SUCCESS") {
                                errorMsg = result;
                                component.set("v.errorString", errorMsg);
                                component.set("v.showSpinner", false);
                            }
                        });
                    if (returnVal.isMWErrorSwitchActive && (ermsg.startsWith('OSB') || ermsg.startsWith('Unsupporte') ||
                            returnVal.errormsg.endsWith('Timeout exceeded'))) {
                        console.log('In the if loop to enqueue');
                        component.set("v.isMWErrors", true); //Enabling the dropdown display to show original error
                        $A.enqueueAction(action1);
                    } else {
                            console.log('In the else loop');
                            component.set("v.showSpinner", false);
                        }
                        if(ermsg.startsWith('Unsupporte')){
                           component.set("v.isMWErrors", false);
                        }
                        component.set('v.errorCode', erMsg); //To show original error message in dropdown
                        console.log('isMWErrorSwitchActive value is ' + returnVal.isMWErrorSwitchActive);
                        component.set('v.mwErrorSwitch', returnVal.isMWErrorSwitchActive);
                        if (returnVal.isMWErrorSwitchActive) {
                            ermsg = ermsg;
                        } else {
                            ermsg = errorMsg;
                        }
                        if (!returnVal.isMWErrorSwitchActive || (!(ermsg.startsWith('OSB')) && !(returnVal.errormsg.endsWith('Timeout exceeded')))) {
                            component.set("v.errorString", erMsg);
                            component.set("v.isMWErrors", false);
                        }
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
            }
            else if (state == "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        resultsToast.setParams ({
                            "type": "Error",
                            "title": "Update Error",
                            "message": "The update validation returned an error: " + errors[0].message
                        })
                    }
                }
                else {
                    resultsToast.setParams ({
                        "title": "Update Unknown Error",
                        "message": "The update returned an error: " + state
                    });
                }
            }
                else {
                    resultsToast.setParams ({
                        "title": "Update Unknown Error",
                        "message": "The update returned an error: " + state
                    });
                }
            resultsToast.fire();
            //This is the key to getting the page to refresh
            //$A.get("e.force:refreshView").fire(); //This closes the Action Window
            //var dismissActionPanel = $A.get("e.force:closeQuickAction");
            // dismissActionPanel.fire();
            // component.set("v.showSpinner",false);
        });
        //This calls the Apex Controller and the code will restart on the setCallback line.*/
        $A.enqueueAction(action);
    },
    //Wo Comment Inbound	
    updateWOComment: function(component, event, helper){	
        //alert('i am inside');	
        //debugger;	
        //var wo = workOrder;	
        var action = component.get("c.calloutCommentInbound");	
        var sdatastr = component.get("v.recordId");	
        //alert('sdatastr'+sdatastr);	
        // var action = componenr.get("c.fetchUser");	
        // var action = result.getReturnValue();	
        action.setParams({	
            "woId" : sdatastr+''	
        });	
        action.setCallback(this, function(response) {	
            var state = response.getState();	
            var result = response.getReturnValue();	
            if(state === "SUCCESS") {	
                console.log('sucess'+result);	
            }	
            else{	
                console.log('failing'+result);	
            }	
        });	
        $A.enqueueAction(action);	
    },
    // Added by Ravikanth 
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
                console.log('failing'+result);
            }
        });
        $A.enqueueAction(action);
    }
})