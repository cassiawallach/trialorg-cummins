({
    doInit : function(component, event, helper) { 
      // alert('karrthik');
       helper.servicejobname(component, event, helper);  
       helper.fetchTakeControl(component, event, helper);
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
       // setTimeout(function(){
       // window.location.reload();
       // }, 30000);

    },
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    //Piyush start
    //Use Insite Product Serial Number Button Select
    useInsite: function(component, event, helper) {
        // Set isModalOpen attribute to false
        // alert('insideuserinsiteon button');
       component.set("v.ShowSpinner", true);//added by Piyush for VGRS2-36
        var action = component.get("c.checkAsset");
        action.setParams({ "assestNum" : component.get("v.InsiteESN"),
                          "accountId": component.get("v.accountId"),
                          "strjobId":component.get("v.recordId")});
        
        action.setCallback( this, function(response) {
            var state = response.getState();    
            if (state === "SUCCESS") {
                if(response.getReturnValue() == "No Assest exist"){
                    //alert('insideuserinsiteon button');
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
                }, 70000);
                
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
           
        });
        $A.enqueueAction(action);
        component.set("v.isModalOpen", false);
    }, 
    
    useCSSEngine: function(component, event, helper) {
        //alert('kkkkinsideuseCSSEngine')
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
    //isRefreshed: function(component, event, helper) {
       // location.reload();
   // }
    
})