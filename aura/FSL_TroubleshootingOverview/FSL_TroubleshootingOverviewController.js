({
    
    jobplanDetails : function(component, event, helper) {
        helper.jobplanDetailsHelper(component, event, helper);
        
        // Added By Sriprada to check Profile Name - Dealers
        var action2 = component.get("c.getProfileInfo");
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS" && component.isValid()) {
                console.log("success") ;
                var result = response.getReturnValue();
                console.log(result);
                console.log(result.Name);
                component.set("v.ProfileName", result.Name);
                if(result.Name == 'EVL_Dealer_Advanced' || result.Name == 'EVL_Dealer_Technician' || result.Name == 'EVL_Dealer_Readonly') {
                    component.set("v.DealerProfile", true);
                    component.find("accordion").set('v.activeSectionName', 'A');
                    
                } else {
                    component.set("v.DealerProfile", false);
                }
            } else {
                console.error("fail:" + response.getError()[0].message); 
            }
        });
        $A.enqueueAction(action2);
        
        //Sruthi Changes to get User Info
        var actionUser = component.get('c.fetchUserInfo');
        actionUser.setCallback(this, function(responseUser) {
            //store state of response
            var state = responseUser.getState();
            if (state === "SUCCESS") {
                var resultUser = responseUser.getReturnValue();
                //set response value
                component.set('v.userInfo', resultUser);
                //By Priyanka for VGRS2-17
                if(resultUser.UserRole.Name == "Factory")
                {
                    component.set('v.isFactoryRole', true);  
                }
            }
        });
        $A.enqueueAction(actionUser);
        //Added by Shirisha ROAD-477
        var actionFlag = component.get('c.fetchFTRFlag');
        var woId = component.get("v.recordId");
        console.log('#### recordId :: '+woId);
        actionFlag.setParams({
            woId : woId
        });
        actionFlag.setCallback(this,function(response){
            //console.log('#### response ::'+response); 
            if(response.getState()==="SUCCESS"){
                component.set("v.FTRFlag", response.getReturnValue());
                if(response.getReturnValue() == true){
                    component.set("v.showTroubleshooting", false);
                }
            }
        });
        $A.enqueueAction(actionFlag);
        // end
    },
    
    editComp : function(component, event, helper) {
        component.set("v.coverageMsg",'');
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        console.log('css solution component Id'+id_str);
        component.set("v.selectedRecordId",id_str);
        component.set("v.isOpen", true);
        component.set("v.hideCheck", true);
        helper.editCompHelper(component, event, helper);
        
        // alert(component.find("accountCode").get("v.value"));
        //helper.getCoverageType(component,event);
        // var cmpTarget = component.find('accountCode');
        // $A.util.removeClass(cmpTarget, 'slds-has-error');
    },
    CloseDialog : function(component, event, helper) {
        component.set("v.isOpen", false);
        $A.get('e.force:refreshView').fire(); //CT3-277 
        
    },
    SaveRecord : function(component, event, helper){
        component.set('v.saveRecHelperCheck' , true);
        component.set('v.hideCheck' , true);
        
        //this.CheckCoverage(component, event, helper);
        var accountId = component.find("accountCode").get("v.value"); //Added CT3-277
        // var type = component.get("v.faultype");
        // alert(accountId);
        
        console.log('::: accountId - '+accountId);
        
        //Added CT3-277
        if(accountId == 'DISTRIBUTOR WARRANTY - DW' || component.set("v.AccountCodecheck") == 'DISTRIBUTOR WARRANTY - DW')
        {
            var iscovcheck = true;   
        }
        else
        {
            var iscovcheck = component.get("v.noCoverageFoundCheck");   
        }
        
        if(!iscovcheck) 
        {
            
            helper.checkcoverageHelper(component, event, helper);
        }
        else
        {
            helper.saveRecHelper(component,event,accountId);
        }
        //helper.saveRecHelper(component, event, helper);
        
        
    },
    getSolutions : function(component, event, helper){
        var solId = event.target.id;
        var faultID = event.target.getAttribute("data-id");
        console.log('solId is:'+solId);
        console.log('Faultid  ==  '+faultID);
        component.set("v.solId",solId);
        var woId = component.get("v.recordId");
        var action = component.get("c.getFaultId");
        action.setParams({
            woId : woId,
            faultID : faultID
        });
        action.setCallback(this,function(response){
            if(response.getState()==="SUCCESS"){
                //alert(response.getReturnValue());
                component.set("v.FaultcodeID", response.getReturnValue());
                var faultID = component.get("v.FaultcodeID");
                helper.changeRECORDtype(component, event, faultID);
            }
        });
        $A.enqueueAction(action);
        
        //helper.changeRECORDtype(component, event, faultID);
    },
    
    handlePartWSDChange : function(component, event, helper) {
        var partsWarrantyDate  = component.find("PartWarrantyId").get("v.value");
        if(partsWarrantyDate != null) {
            document.getElementById("partsWarrantyDateError").innerHTML = '';
            var cmpTarget = component.find('PartWarrantyId');
            $A.util.removeClass(cmpTarget, 'slds-has-error');
        }
    },
    
    handleFailureDateChange : function(component, event, helper) {
        var failureDate  = component.find("FailureDateId").get("v.value");
        if(failureDate != null) {
            document.getElementById("partsWarrantyFailureError").innerHTML = '';
            var cmpTarget = component.find('FailureDateId');
            $A.util.removeClass(cmpTarget, 'slds-has-error');
        }
    },
    
    handleFailurePointChange : function(component, event, helper) {
        var failurePoint  = component.find("FailurePointId").get("v.value");
        if(failurePoint != null) {
            document.getElementById("failurePointError").innerHTML = '';
            var cmpTarget = component.find('FailurePointId');
            $A.util.removeClass(cmpTarget, 'slds-has-error');
        }
    },
    
    CheckCoverage: function(component, event, helper)
    {
        component.set('v.saveRecHelperCheck' , false);
        helper.checkcoverageHelper(component, event, helper);
        //  var accountId = component.find("accountCode").get("v.value");
        // this.coverageCheck(component, event, helper);
    },
    
    fetchCoverageType:function(component, event,helper)
    {
        if(document.getElementById("partsWarrantyDateError") != null) {
            document.getElementById("partsWarrantyDateError").innerHTML = '';
            var cmpTarget = component.find('PartWarrantyId');
            $A.util.removeClass(cmpTarget, 'slds-has-error');
        }
        if(document.getElementById("partsWarrantyFailureError") != null) {
            document.getElementById("partsWarrantyFailureError").innerHTML = '';
            var cmpTarget = component.find('FailureDateId');
            $A.util.removeClass(cmpTarget, 'slds-has-error');
        }
        if(document.getElementById("failurePointError") != null) {
            document.getElementById("failurePointError").innerHTML = '';
            var cmpTarget = component.find('FailurePointId');
            $A.util.removeClass(cmpTarget, 'slds-has-error');
        }
        //
        var accountId = component.find("accountCode").get("v.value");
        if(accountId == ('NEW PARTS WARRANTY - 62' || 'PARTS WARRANTY - DEFECT FROM STOCK - 35' ||'RECON PARTS WARRANTY - 97'|| 'RECON PART - DEFECT FROM STOCK - 41')){
            if(component.find('PartWarrantyId') != undefined) {
                if(component.find('PartWarrantyId').get('v.value') != null) {
                    component.find('PartWarrantyId').set('v.value', null);
                }
            } 
            if(component.find('FailureDateId') != undefined ) {
                if(component.find('FailureDateId').get('v.value') != null) {
                    component.find('FailureDateId').set('v.value', null);
                }
            } 
            if(component.find('FailurePointId') != undefined) {
                if(component.find('FailurePointId').get('v.value') != null) {
                    component.find('FailurePointId').set('v.value', null);
                }
            }
        }
        helper.getCoverageType(component);	 
        component.set("v.coverageMsg", "") ;  
        var cmpTarget = component.find('accountCode');
        // alert(cmpTarget.get("v.value"));
        // component.set("v.selectedAccountCode","NPW");
        console.log('$$$$AccountCode:'+cmpTarget.get("v.value"));
        $A.util.removeClass(cmpTarget, 'slds-has-error');   
        
    },
    
    
    onWhatToUse: function(component, event) {
        var selected = event.currentTarget.value;
        component.set("v.CustomerPossPartSelected", selected);
    },
    
    doInitInCustomComponent: function(component, event, helper) {
        debugger;
        helper.jobplanDetailsHelper(component, event, helper);
    },
    
    //Added as part of NIN-34
    doInit : function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        
        const valuesCustomerPossPart = [
            {'label': $A.get("$Label.c.css_Yes"), 'value': 'Yes' },                                           
            {'label': $A.get("$Label.c.CSS_No"), 'value': 'No' }
        ];
        
        component.set('v.CustomerPossPart', valuesCustomerPossPart);
        
        const valuesfailureMeasure = [
            {'label' : $A.get("$Label.c.CSS_Miles"), 'value' : 'Miles'},
            {'label' : $A.get("$Label.c.CSS_Kilometers"), 'value' : 'Kilometers'},
            {'label' : $A.get("$Label.c.css_hours"), 'value' : 'Hours'}
        ];
        
        component.set('v.FailureMeasureValues', valuesfailureMeasure);
    }
    
    
})