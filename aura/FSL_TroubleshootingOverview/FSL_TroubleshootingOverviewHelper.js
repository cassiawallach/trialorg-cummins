({
    jobplanDetailsHelper : function(component, event, helper) {
        var action = component.get('c.tsOverview');
        action.setParams({
            serviceOrderId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") { 
                //set response value in wrapperList attribute on component.
                component.set('v.wrapperList', response.getReturnValue());   
                if(("v.workOrderRecord").Type__c == 'Dealer'){
                    component.set("v.Headertitle", true)
                }
                console.log('sollist ### '+JSON.stringify(response.getReturnValue()));
            }
        });
        $A.enqueueAction(action);
        
         var action1 = component.get('c.getStatus');
        action1.setParams({
            recId : component.get("v.recordId")
        });
        action1.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in FailureMeasureValues attribute on component.
                component.set('v.disableButtons', response.getReturnValue());
            }
        });
        $A.enqueueAction(action1);
    },
    editCompHelper : function(component, event, helper) {
        //component.set("v.isOpen", true);
        var target = event.target
        // alert(target.getAttribute("name"));
        component.set("v.FaultCode",target.getAttribute("name"));
        var RecordId = component.get("v.selectedRecordId");
        //  alert('RecordId => '+RecordId);
        var action = component.get("c.UpdateSolComp");
        //component.set("v.faultype",target.getAttribute("FC_Type__c"));
        //alert('***faultype*** => '+action.ftype);
        action.setParams({ recId: RecordId });
        action.setCallback(this, function(response){
            var result = response.getReturnValue();
            component.set("v.faultype",result[0].FC_Type__c);
            component.set("v.PartWarrentyDate",result[0].Part_Warranty_Start_Date__c);
            component.set("v.FailureDate",result[0].Failure_Date__c);
            component.set("v.updateAccountCode",result[0].FSL_Account_Code__c);
            // alert('account code:'+result[0].FSL_Account_Code__c);
            if(result[0].FSL_Account_Code__c == 'NEW PARTS WARRANTY - 62' || result[0].FSL_Account_Code__c == 'RECON PARTS WARRANTY - 97'){
                component.set("v.CustomerPossPartSelected","Yes");
                component.set("v.selectedFailureMeasure",result[0].Failure_Measure__c);
            } else if(result[0].FSL_Account_Code__c == 'PARTS WARRANTY - DEFECT FROM STOCK - 35' || result[0].FSL_Account_Code__c == 'RECON PART - DEFECT FROM STOCK - 41') {
                component.set("v.CustomerPossPartSelected", 'No');
                component.set('v.selectedFailureMeasure', result[0].Failure_Measure__c);
            }
            if(response.getState()==="SUCCESS" && component.isValid()){
                // alert(response.getState());
                component.set("v.EditRec",response.getReturnValue());
                component.set("v.isOpen", true); // add this line after you populate and not before that.
                this.getAccountCodeCoverageType(component,event);
            }
        });
        $A.enqueueAction(action);
    },
    getAccountCodeCoverageType : function(component, event, helper) {
        var action = component.get("c.getAccountCodeCoverageType");
        var RecordId = component.get("v.selectedRecordId");
        //alert('RecordId => '+RecordId);
        action.setParams({
            strSolComId :component.get("v.selectedRecordId")
        });
        action.setCallback(this,function(response){
            if(response.getState()==="SUCCESS" && component.isValid()){
                //alert(response.getReturnValue());
                component.set("v.selectedAccountCode", response.getReturnValue());
                // component.set("v.isValidApprovalCode",true);
            }
        });
        $A.enqueueAction(action);
        
    },
    CloseDialog : function(component, event, helper) {
        component.set("v.isOpen", false);
        
    },
    
    getCoverageType:function(component, event){
        var action = component.get("c.getCoverageTypeFromApex");
        var accountId = component.find("accountCode").get("v.value");
        action.setParams({ 
            strAccountId: accountId.toString()
        }); 
        
        action.setCallback(this, function(response){
            //alert(response.getState());             
            //alert(response.getReturnValue());
            var profileName = component.get("v.ProfileName");
            var userInfo = component.get("v.userInfo");
            if(response.getState()=="SUCCESS" && component.isValid()){
                component.set("v.selectedAccountCode", response.getReturnValue());
                component.set("v.isValidApprovalCode",true);
				console.log('-----mileage '+userInfo.FSL_Mileage_Measure__c);
                //Adding Condition to make required
                let accCode = response.getReturnValue();
                if(accCode == 'NPW' || accCode == 'RPW') {
                    console.log('::: AccCode = '+accCode);
                    //component.set('v.requiredCheck', true);
                    //Radiot Button auto selected
                    if(accountId == 'NEW PARTS WARRANTY - 62' 
                       || accountId == 'RECON PARTS WARRANTY - 97'
                       || accountId == 'CONNECTED PRODUCTS - PC' 
                       || accountId == 'SERVICE TOOL WARRANTY - 52') 
                    {
                        component.set("v.CustomerPossPartSelected", 'Yes');
                        if(profileName == 'EVL_Dealer_Advanced' || profileName == 'EVL_Dealer_Technician' || profileName == 'EVL_Dealer_Readonly'){
                            component.set('v.selectedFailureMeasure', userInfo.FSL_Mileage_Measure__c);
                        }
                        else{
                            component.set('v.selectedFailureMeasure', 'Kilometers');
                        }
                    } else if(accountId == 'PARTS WARRANTY - DEFECT FROM STOCK - 35' || accountId == 'RECON PART - DEFECT FROM STOCK - 41') {
                        component.set("v.CustomerPossPartSelected", 'No');
                        if(profileName == 'EVL_Dealer_Advanced' || profileName == 'EVL_Dealer_Technician' || profileName == 'EVL_Dealer_Readonly'){
                            component.set('v.selectedFailureMeasure', userInfo.FSL_Mileage_Measure__c);
                        }
                        else{
                            component.set('v.selectedFailureMeasure', 'Kilometers');
                        }
                    }
                }
                
            }else if (response.getState() === "ERROR") {
                component.set("v.selectedAccountCode", "");
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        }); 
        $A.enqueueAction(action);	
    },
    saveRecHelper : function(component,event,dummy) {
        // Getting below field values based aura:id 
        var coverageValueChecks = component.get("v.noCoverageFoundCheck"); //Added CT3-277
        //Added CT3-277
       if(coverageValueChecks)
       {
          dummy = ''; 
       }
       
       var FailMode = component.find("FailModeId").get("v.value");
        var resultsToast = $A.get("e.force:showToast");
        component.set("v.isValidApprovalCode",true);
        component.set("v.blnValidateFailure",false);
        
        // alert(component.get("v.blnValidateFailure"));
        
        //Fetching selectedAccountCode to validate approval code if coverage type is POL or OTH
        var CoverageType = component.get("v.selectedAccountCode");
        // var accountCode  = component.find("accountCode").get("v.value");
        
        var action = component.get("c.saveAccountCode");
        console.log('AccountCodefromCheckCoverage:'+dummy);

        action.setParams({
            strRecordId : component.get("v.selectedRecordId"),
            accountCode  : dummy
        });
        action.setCallback(this, function(response){
            //  alert(response.getState());
        });
        $A.enqueueAction(action);	
        
        //console.log('mallika test'+accountCode);
        var ac = dummy.includes('70');
        
        var errMessage ;
        var errCount=0;
        var type = component.get("v.faultype");
        if(FailMode !== '' && ac == true && type == 'Symptom'){ 
            component.set("v.blnValidateFailure",true); 
            var FCName = component.find("CumminsCode").get("v.value");
            if(FCName == null){
                errMessage = 'Fault Code';
                errCount++;
            }
            else{
                var FCName = component.find("CumminsCode");
            }
        }
        
        if(FailMode !== '' && ((CoverageType == 'NPW') || (CoverageType == 'RPW'))){
            var failureDateCheck;
            var FailureDate = component.find("FailureDateId").get("v.value"); // added by Mallika
            var partsWarrantyDateCheck;
            var partsWarrantyDate = component.find("PartWarrantyId").get("v.value"); 
            var PartFailureComparision;
            var FailModeCheck='false';
            var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"); // added by Mallika
            console.log('failure Date'+FailureDate+'partsWarrantyDate'+partsWarrantyDate);
            //added By Mallika
            
            if(FailureDate==undefined){
                FailureDate=component.get("v.FailureDate");
            }
            if(partsWarrantyDate==undefined){
                partsWarrantyDate=component.get("v.partsWarrantyDate");
            }
            console.log('failure Date'+FailureDate+'partsWarrantyDate'+partsWarrantyDate);
            if(FailureDate<partsWarrantyDate)
            {
                console.log('failure date cannot be less than partwarrenty date');
                document.getElementById("partsWarrantyFailureError").innerHTML = 'Failure date cannot be less than Part Warranty Start Date';
                var cmpTarget = component.find('PartWarrantyId');
                $A.util.addClass(cmpTarget, 'slds-has-error');
                console.log('enterted if date check');
                PartFailureComparision='true';
            }
            else{
                console.log('enterted else date check'+failureDateCheck);
                var cmpTarget = component.find('PartWarrantyId');
                $A.util.removeClass(cmpTarget, 'slds-has-error');
                document.getElementById("partsWarrantyFailureError").innerHTML = '';
                PartFailureComparision='false'
            }
            if(FailureDate>today)
            {
                document.getElementById("failureDateError").innerHTML = 'Failure Date cannot be greater than Today';
                var cmpTarget = component.find('FailureDateId');
                $A.util.addClass(cmpTarget, 'slds-has-error');
                console.log('enterted if date check');
                failureDateCheck='true';
            }
            else{
                console.log('enterted else date check'+failureDateCheck);
                var cmpTarget = component.find('FailureDateId');
                $A.util.removeClass(cmpTarget, 'slds-has-error');
                document.getElementById("failureDateError").innerHTML = '';
                failureDateCheck='false'
            }
            
            
            if(partsWarrantyDate>today)
            {
                document.getElementById("partsWarrantyDateError").innerHTML = 'Part Warranty Start Date cannot be greater than Today';
                var cmpTarget = component.find('PartWarrantyId');
                $A.util.addClass(cmpTarget, 'slds-has-error');
                console.log('enterted if date check');
                partsWarrantyDateCheck='true';
            }
            else{
                console.log('enterted else date check'+failureDateCheck);
                var cmpTarget = component.find('PartWarrantyId');
                $A.util.removeClass(cmpTarget, 'slds-has-error');
                document.getElementById("partsWarrantyDateError").innerHTML = '';
                partsWarrantyDateCheck='false';
                console.log('enterted mallika date check'+partsWarrantyDateCheck);
            }
        }
        // Mallika code ended here 
        
        if(CoverageType == 'NPW' || CoverageType == 'RPW'){
            component.set("v.blnValidateFailure",true);
            var PartWarranty = component.find("PartWarrantyId").get("v.value");
            
            if(PartWarranty == null){
                // this.showToastMessage(component, event, "Error Message", "Please select Part Warranty Start Date", "error");
                errCount++;
                if(errMessage){
                    errMessage = errMessage + ' , Part Warranty Start Date';
                }
                else{
                    errMessage = 'Part Warranty Start Date';
                }
            }
        }
        if(CoverageType == 'NPW'  || CoverageType == 'RPW'){
            component.set("v.blnValidateFailure",true);
            var FailureDate = component.find("FailureDateId").get("v.value");
            if(FailureDate == null ){
                errCount++;
                if(errMessage){
                    errMessage = errMessage + ' , Failure Date';
                }
                else{
                    errMessage = 'Failure Date';
                }
                // this.showToastMessage(component, event, "Error Message", "Please select Failure Date", "error");
            }
        }
        if(CoverageType == 'NPW' || CoverageType == 'RPW'){
            component.set("v.blnValidateFailure",true);
            var FailurePoint = component.find("FailurePointId").get("v.value");
            if(FailurePoint == null){
                errCount++;
                if(errMessage){
                    errMessage = errMessage + ' , Failure Point';
                }
                else{
                    errMessage = 'Failure Point';
                }
                //this.showToastMessage(component, event, "Error Message", "Please select Failure Point", "error");
            }
        }
        
        if((FailMode == null && dummy != 'DISTRIBUTOR WARRANTY - DW' && !coverageValueChecks ) || (FailMode == '' && dummy != 'DISTRIBUTOR WARRANTY - DW' && !coverageValueChecks)){
            var FailModeCheck='true';
            component.set("v.blnValidateFailure",true);
            errCount++;
            
            if(errMessage){
                errMessage = errMessage + ' , Fail Mode';
            }
            else{
                // var failMode =  component.find("FailModeId");
                errMessage = 'Fail Mode';
            }
            //this.showToastMessage(component, event, "Error Message", "Please populate Fail Mode", "error");
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
        // added by Mallika when there is no Error commit the records
        else{
            if(failureDateCheck=='false' && partsWarrantyDateCheck=='false' && PartFailureComparision=='false' && FailModeCheck=='false'){
                
                console.log('entered to submit');
                component.find("editForm").submit();
                this.showToastMessage(component, event, "Success Message", "Saved Successfully!!", "success");
                component.set("v.isOpen", false);
                window.location.reload();
            }
        }
        
        
        if(!component.get("v.blnValidateFailure")){
            component.set("v.blnValidateFailure",true);
            component.find("editForm").submit();
            this.showToastMessage(component, event, "Success Message", "Saved Successfully!!", "success");
            component.set("v.isOpen", false);
            window.location.reload();
        }    
    },
    
    showToastMessage : function(component, event, strTitle, strMessage, strType) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : strTitle,
            message:strMessage,
            duration:' 5000',
            key: 'info_alt',
            type: strType,
            mode: 'pester'
        });
        toastEvent.fire();
    },
    coverageCheck:function(component,accountId,helper)
    {
        var cmpObj = component.get("v.EditRec[0]");
        // alert('AccCode:'+accountId);
        // alert('CompObj:'+cmpObj);
        component.set("v.showSpinner",true); 
        //cmpObj.Account_Code__c = accountId;
        cmpObj.FSL_Account_Code__c = accountId;
        //Added by Charan for CT3-465
        if(accountId == null)    
        {
           accountId =''; 
        }
        //Added by Mallika
        if(accountId == 'NEW PARTS WARRANTY - 62' || accountId == 'RECON PARTS WARRANTY - 97' || 
           accountId == 'PARTS WARRANTY - DEFECT FROM STOCK - 35' || accountId == 'RECON PART - DEFECT FROM STOCK - 41')
        {
            
            cmpObj.Part_Warranty_Start_Date__c = component.find("PartWarrantyId").get("v.value");
            cmpObj.Failure_Date__c = component.find("FailureDateId").get("v.value");
            cmpObj.Failure_Point__c = component.find("FailurePointId").get("v.value"); }
        //mallika code ended here
        console.log('cmpObj : '+ JSON.stringify(cmpObj));
        
        var action = component.get("c.getCoverageApex");
        action.setParams({ 
            solCmp: cmpObj
        }); 
        action.setCallback(this, function(response){
            component.set("v.showSpinner",false); 
            var result = response.getReturnValue();
            //alert(response.getState());             
            //alert(response.getReturnValue());
            if(response.getState()=="SUCCESS" && component.isValid())
            {
                console.log('MSG :'+response.getReturnValue());
				var resultTrim = response.getReturnValue();
				if(resultTrim != ''){
					resultTrim = resultTrim.trim();
				}
				
                if(result == '' || result  == null || result == 'DISTRIBUTOR WARRANTY - DW' || resultTrim == 'No Coverage Found'){
                    component.set("v.coverageMsg", "Coverage not Found");
                    //Added CT3-277
                    var accCodeValue = accountId;
                    if(accCodeValue == 'DISTRIBUTOR WARRANTY - DW')
                    {
                        component.find("accountCode").set("v.value","");  
                        //component.set("v.AccountCodecheck","");
                        component.set("v.noCoverageFoundCheck",true); 
                        this.showToastMessage(component, event, "Error Message", "No coverage found", "error");
                    }
                }
                else{
                component.set("v.noCoverageFoundCheck",false); //Added CT3-277
                console.log('checkpk :'+response.getReturnValue());
                component.set("v.coverageMsg", "Coverage Found - "+response.getReturnValue());  
                if(accountId == '' || (accountId == 'DISTRIBUTOR WARRANTY - DW' && result != 'DISTRIBUTOR WARRANTY - DW') ){ //Added CT3-277
                    //component.set("v.AccountCodecheck",response.getReturnValue());
                    component.find("accountCode").set("v.value",response.getReturnValue());  //Added CT3-277
                        component.set("v.coverageMsg","Coverage Found:"+' '+response.getReturnValue());
                        component.set("v.hideCheck", false);
                        cmpObj.FSL_Account_Code__c =  component.find("accountCode").get("v.value");  //Added CT3-277
                        console.log('checkUpdatedAC :'+cmpObj.FSL_Account_Code__c);
                        var dummy = component.find("accountCode").get("v.value");  //Added CT3-277
                        console.log('dummyVal:***'+dummy);
                      	
                        this.failureCoverageCheck(component,event,dummy);
                        this.getCoverageType(component,event);
                    }
                    
                   if(component.get("v.saveRecHelperCheck"))
                    {
                       
                        if(accountId == 'NEW PARTS WARRANTY - 62'){
                            var flag = component.get("v.CustomerPossPartSelected");
                            if(flag == 'No'){
                                accountId = "PARTS WARRANTY - DEFECT FROM STOCK - 35";
                                component.find("accountCode").set("v.value",accountId); //Added CT3-277
                                //component.set("v.AccountCodecheck",accountId);
                            
                            }else{
                                component.find("accountCode").set("v.value",accountId); //Added CT3-277
                                //component.set("v.AccountCodecheck",accountId);                           
                             }
                            } 
                        else{
                            component.find("accountCode").set("v.value",accountId); //Added CT3-277
                           // component.set("v.AccountCodecheck",accountId);                        
                        }
                        
                        
                        if(accountId == 'RECON PARTS WARRANTY - 97'){
                            var flag = component.get("v.CustomerPossPartSelected");
                            if(flag == 'No'){
                                accountId = "RECON PART - DEFECT FROM STOCK - 41";
                                component.find("accountCode").set("v.value",accountId); //Added CT3-277
                               // component.set("v.AccountCodecheck",accountId);
                                
                            }else{
                                component.find("accountCode").set("v.value",accountId); //Added CT3-277
                               // component.set("v.AccountCodecheck",accountId);
                            }
                        }
                        else{
                            component.find("accountCode").set("v.value",accountId); //Added CT3-277
                            //component.set("v.AccountCodecheck",accountId);
                        }  

                        if(accountId == 'PARTS WARRANTY - DEFECT FROM STOCK - 35'){
                            var flag = component.get("v.CustomerPossPartSelected");
                            //  alert('flag:'+ flag);
                            if(flag == 'Yes'){
                                accountId = "NEW PARTS WARRANTY - 62";
                                // cmpObj.FSL_Account_Code__c = accountId;
                                // component.set("v.EditRec.FSL_Account_Code__c",accountId);
                                 //  component.set("v.AccountCodecheck",accountId);
                                // alert('tempAcc:'+tempACC);
                                component.find("accountCode").set("v.value",accountId); //Added CT3-277
                                
                            }else{
                                component.find("accountCode").set("v.value",accountId); //Added CT3-277
                                //component.set("v.AccountCodecheck",accountId);
                            }
                        }
                        else{
                            component.find("accountCode").set("v.value",accountId); //Added CT3-277
                          //  component.set("v.AccountCodecheck",accountId);
                        }
                        
                        if(accountId == 'RECON PART - DEFECT FROM STOCK - 41'){
                            var flag = component.get("v.CustomerPossPartSelected");
                            if(flag == 'Yes'){
                                accountId = "RECON PARTS WARRANTY - 97";
                                component.find("accountCode").set("v.value",accountId); //Added CT3-277
                               // component.set("v.AccountCodecheck",accountId);
                            }else{
                                component.find("accountCode").set("v.value",accountId); //Added CT3-277
                                //component.set("v.AccountCodecheck",accountId);
                            }
                        }
                        else{
                            component.find("accountCode").set("v.value",accountId); //Added CT3-277
                         //   component.set("v.AccountCodecheck",accountId);
                        }
                        
                        
                       // cmpObj.FSL_Account_Code__c = component.get("v.AccountCodecheck");
                       // var dummy = component.get("v.AccountCodecheck");
                        cmpObj.FSL_Account_Code__c = component.find("accountCode").get("v.value");//Added CT3-277
                       var dummy = component.find("accountCode").get("v.value"); //Added CT3-277
                        this.saveRecHelper(component,event,dummy);
                    }
                }
            }
            else if (response.getState() === "ERROR") 
            {                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown error");
                }
            }
        }); 
        $A.enqueueAction(action);	
    },
    changeRECORDtype : function(component,event,faultID) {
        var woId = component.get("v.recordId");
        //alert(solId);
        //alert(faultID);
        var action = component.get("c.changeRecord");
        action.setParams({
            'workId': woId,
            'faultID':faultID
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS")
            {
                console.log(component.get("v.workOrderRecord").Type__c);
                if(component.get("v.workOrderRecord").Type__c == 'Dealer'){
                    var recId = window.location.href;
                var recId1 = recId.substring(0, recId.lastIndexOf('/'));
                 var tabsetUrl = $A.get("$Label.c.EVL_TabSetToTND");
                var recId2 = recId1+'/detail?tabset-'+tabsetUrl+'&TabId=solution&solId='+component.get("v.solId");
              
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({ "url": recId2});   
                urlEvent.fire();
                    var compEvent = component.getEvent("sampleComponentEvent");
                    compEvent.fire();
                }
                else{
                   location.reload(); 
                }
                
            }else if (state === "INCOMPLETE") {
                // alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // alert("Error message: " + 
                        //   errors[0].message);
                    }
                } else {
                    // alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    checkcoverageHelper : function(component, event, helper) {
        var accountId = component.find("accountCode").get("v.value");
        var FailMode = component.find("FailModeId").get("v.value");
        var CoverageType = component.get("v.selectedAccountCode");
        console.log('$$$$::: FailMode - '+FailMode+'accountId:- '+accountId);
        var partsWarrantyDate;
        var PartFailureComparision;
        var failureDate;
        var failureDateCheck;
        var failurePoint;
        var failurePointCheck;
        var FailModeCheck;
        if(component.find("PartWarrantyId") != undefined) {
            partsWarrantyDate  = component.find("PartWarrantyId").get("v.value");
            // alert("WSD:"+partsWarrantyDate);
            if(partsWarrantyDate == null ) {
                document.getElementById("partsWarrantyDateError").innerHTML = 'Complete Part Warranty Start Date field ';
                var cmpTarget = component.find('PartWarrantyId');
                $A.util.addClass(cmpTarget, 'slds-has-error');
                PartFailureComparision='true';
            } 
            else { 
                PartFailureComparision = 'false' 
            }
        }
        
        // Fail Mode check when empty
        if(FailMode == null && (accountId == '' ||accountId == undefined)) { //Added CT3-277
            document.getElementById("FailModeError").innerHTML = 'Fail Mode is missing';
            var cmpTarget = component.find('FailModeId');
            $A.util.addClass(cmpTarget, 'slds-has-error');
        } 
        else { 
            if(component.find("FailureDateId") != undefined) {
                failureDate  = component.find("FailureDateId").get("v.value");
                if(failureDate == null) {
                    document.getElementById("partsWarrantyFailureError").innerHTML = 'Complete Failure Date field ';
                    var cmpTarget = component.find('FailureDateId');
                    $A.util.addClass(cmpTarget, 'slds-has-error');
                    failureDateCheck='true';
                } else { failureDateCheck = 'false' }
            } 
            
            //FailurePointId
            if(component.find("FailurePointId") != undefined) {
                failurePoint  = component.find("FailurePointId").get("v.value");
                if(failurePoint == null || failurePoint == "") {
                    document.getElementById("failurePointError").innerHTML = 'Complete Failure Point field ';
                    var cmpTarget = component.find('FailurePointId');
                    $A.util.addClass(cmpTarget, 'slds-has-error');
                    failurePointCheck='true';
                } else { failurePointCheck='false' }
            } 
            
            if(PartFailureComparision == 'false' && failureDateCheck == 'false' && failurePointCheck == 'false' && (CoverageType == 'NPW' || CoverageType == 'RPW')) {
              
                if(accountId) {
                    
                    this.coverageCheck(component,accountId);  
                    component.set("v.coverageMsg","");
                } 
            } 
            else if(accountId != 'NEW PARTS WARRANTY - 62' && accountId != 'RECON PARTS WARRANTY - 97' && 
                    accountId != 'PARTS WARRANTY - DEFECT FROM STOCK - 35' && accountId != 'RECON PART - DEFECT FROM STOCK - 41') 
            {
               
                if(accountId) {
                    
                    this.coverageCheck(component,accountId);  
                    component.set("v.coverageMsg","");
                } else {
                    
                    var check = component.get("v.saveRecHelperCheck");
                    if(check == false){
                       
                        var cmpTarget = component.find('accountCode');
                        $A.util.addClass(cmpTarget, 'slds-has-error');
                        
                          this.coverageCheck(component,accountId);  

                        //component.set("v.coverageMsg","Please select any Account Code in order to Check Coverage!"); 
                    } else{
                        component.set("v.blnValidateFailure",true);
                        component.find("editForm").submit();
                        this.showToastMessage(component, event, "Success Message", "Saved Successfully!!", "success");
                        component.set("v.isOpen", false);
                        window.location.reload();
                    }
                }
            }
        }
        
    },
    
    failureCoverageCheck : function(component,event,dummy) {
        var RecordId = component.get("v.selectedRecordId");
    	var cmpObj = component.get("v.EditRec[0]");
        var accountId = component.find("accountCode").get("v.value");
   		// component.set("v.hideCheck", false);

        component.set("v.blnValidateFailure",false);
        var action = component.get("c.saveAccountCode");
         action.setParams({
            strRecordId : component.get("v.selectedRecordId"),
            accountCode  : dummy
        });
        action.setCallback(this, function(response){
            //component.set("v.showSpinner",false);  
        });
        $A.enqueueAction(action);
		//var ac = component.find("accountCode").set("v.AccountCodecheck",dummy);
        component.find("editForm").submit();
        this.showToastMessage(component, event, "Success Message", "Saved Successfully!!", "success");
        console.log('AC Update:'+cmpObj.FSL_Account_Code__c);
        component.set("v.isOpen", true);
     
    },
    
})