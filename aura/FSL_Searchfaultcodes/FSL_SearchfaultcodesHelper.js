({
    
    fetchTypePicklist : function(component)
    
    {
        alert(component.find("searchField3").get("v.value"));
        
        var action = component.get("c.getSymptos");
        
        action.setParams({
              
            
            'keyWord': component.find("searchField3").get("v.value")
            
        });
        
        
        action.setCallback(this, function(a)
                           
                           {
                               
                               var state = a.getState();
                               
                               if (state === "SUCCESS")
                                   
                               {
                                   
                                   if(a.getReturnValue().size() > 0)
                                       
                                       component.set("v.TypePicklist", a.getReturnValue());
                               } 
                           });
        $A.enqueueAction(action);
    },
    //Modified Ravi to search Pcode or Fault code or FSL SPN FMI
    searchfalutecodes : function(component,helper,event) {
        var action = component.get("c.getfaultcodes");
        action.setParams({
            'searchPcode': component.get("v.PcodesearchString"),
            'searchSPN': component.get("v.SPNFMIsearchString"),
            'strfaultcodes': component.get("v.searchString"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('DATA =='+storeResponse);
                if (storeResponse.length == 0) {
                    component.set("v.Message", true);
                } else {
                    component.set("v.Message", false);
                }
                
                component.set("v.searchResult", storeResponse); 
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    searchPcodes : function(component,helper,event) {
        var action = component.get("c.getsearchresults");
        console.log('pram = '+component.get("v.PcodesearchString"));
        action.setParams({
            'searchPcode': component.get("v.PcodesearchString")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('data =='+storeResponse);
                if (storeResponse.length == 0) {
                    component.set("v.Message2", true);
                } else {
                    component.set("v.Message2", false);
                }
                
                component.set("v.FSLPOCDEsearchResult", storeResponse); 
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    SPNFMIsearchPcodes : function(component,helper,event) {
        var action = component.get("c.getsearchspnresults");
        action.setParams({
            'searchSPNcode': component.get("v.getsearchspnresults")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                if (storeResponse.length == 0) {
                    component.set("v.Message3", true);
                } else {
                    component.set("v.Message3", false);
                }
                
                component.set("v.SPNFMIsearchResult", storeResponse); 
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    //added by sriprada
    changeRECORDtype : function(component,event,faultID) {
        var woId = component.get("v.workOrderId");
        console.log('woId == '+woId);
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
                location.reload();
                /* var rid= component.get("v.recordId");
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": rid,
                    "slideDevName": "SloutionT&D"
                    
                });
                navEvt.fire(); */
               // $A.get('e.force:refreshView').fire();
                
                
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    showHidesearchstring : function(component,event,helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var woId = component.get("v.recordId");
        console.log('woId == '+woId);
        var action = component.get("c.showHidesearchstring");
        action.setParams({
            'strservicejobid': woId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
               component.set("v.bolFaultTypeFC",response.getReturnValue().FaultTypeFC);
               component.set("v.bolFaultTypePCode",response.getReturnValue().FaultTypePCode); 
               component.set("v.bolFaultTypeSPNFMI",response.getReturnValue().FaultTypeSPNFMI); 
               component.set("v.bolShowFCErrorMsg",response.getReturnValue().ShowFCErrorMsg); 
                // Added Ravi to hide/show the faultcode search fields based on take controll user value 
                //component.set("v.userProfileName",response.getReturnValue().userProfileName);
                if(response.getReturnValue().strusr  == null || response.getReturnValue().strusr  == ''|| response.getReturnValue().strusr  == userId){
                    component.set("v.usrcontrol",true);   
                } 
                else if(response.getReturnValue().strusr  != null && response.getReturnValue().strusr  != '' && response.getReturnValue().strusr  != userId){
                    component.set("v.usrcontrol",false);
                }
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
            //this.populateTableHelper(component,event,helper);
        });
        $A.enqueueAction(action);
    } ,
    // By Mallika
    populateTableHelper : function(component, event, helper){
     // component.set("v.showTable",true);
        var childCmp = component.find('childCmp');
        var cumCode = component.find("CumminsFCode").get("v.value");
        var pcode = component.find("CumminsPCode").get("v.value");
        var spn = component.find("CumminsSPNCode").get("v.value");
		//var cumCode = component.get("v.objworkorder.FSL_Fault_Code__c");
       // var pcode = component.get("v.objworkorder.FSL_PCode__c");
       // var spn = component.get("v.objworkorder.FSL_SPN_FMI__c");
        var highLevelSymptom = component.get("v.searchSymptom");
        var lowLevelSymptom = component.get("v.selectedSymptom");
        if(lowLevelSymptom == undefined){
          lowLevelSymptom=''; 
          //   alert('in lowLevelSymptom '+lowLevelSymptom);
        }
         if(highLevelSymptom == undefined){
          highLevelSymptom=''; 
          //   alert('in highLevelSymptom '+highLevelSymptom);
        } 
        var recordId = component.get("v.recordId");
        console.log('v,recordid - '+recordId);

      // alert('recordId'+recordId); 
        //alert('cumCode'+cumCode);
        // alert('pcode'+pcode);
        //  alert('spn'+spn);
        // alert('lowLevelSymptom '+lowLevelSymptom);
		childCmp.sampleMethod(cumCode,pcode,spn,highLevelSymptom,lowLevelSymptom,recordId);  
        this.updatecontrollusr(component, event, helper);// Commented by Ravikanth for reload issue
    },
    
    //Piyush - Function to keep Audit trial for Search Fault Code 
    trackSearchFaultCode : function(component, event, helper) {
        var action = component.get("c.captureSearchFaultCode");
        var pCode = component.get("v.objworkorder.FSL_PCode__c");
       // var faultCode = component.get("v.objworkorder.FSL_Fault_Code__c");
         var faultCode = component.find("CumminsFCode").get("v.value");
        var spnfmiCode = component.get("v.objworkorder.FSL_SPN_FMI__c");
        var symtpomCategory = component.get("v.searchSymptom");
        var symptom = component.get("v.selectedSymptom");
        
        var config = {
                      'pCode' : pCode,
                      'faultCode' : faultCode,
                      'spnfmiCode' : spnfmiCode,
                      'symtpomCategory' : symtpomCategory,
                      'symptom' : symptom
                     };
        var configJSON = JSON.stringify(config);
        console.log('::: JSON String - '+configJSON);
        action.setParams({ 
            workOrderId : component.get("v.recordId"),
            config : configJSON
        });
        action.setCallback( this, function(response) {
            var state = response.getState(); 
            if (state === "SUCCESS") { 
                console.log('Saved Search Fault Codes or Symptoms');
            } else {
                console.log('::: Error while Search Fault Codes or Symptoms');
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    updatecontrollusr : function(component, event, helper) {
        
        var action = component.get("c.hidetakecontrol");
        action.setParams({ 
            strjobId : component.get("v.recordId")
        });
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
    //commented by Piyush for VGRS2-321
 /*   showSpinner : function (component, event, helper) {
        var spinner = component.find('mySpinner');
        $A.util.removeClass(spinner, "slds-hide");
        window.setInterval(
            $A.getCallback(function() { 
                $A.util.addClass(spinner, "slds-hide");
            }), 10000
        );
    }, */
    getRecordType : function(component, event, helper){
        
		var action = component.get("c.getWorkOrderRecordType");
        action.setParams({
            workOrderId : component.get("v.recordId")
        });
        alert('getRecordType');
        action.setCallback(this,function(response){
            alert('getRecordType');
            var state = response.getState();
            alert(state)
            if(state==="SUCCESS"){
                 console.log("*********** Repair section"+response.getReturnValue());
                alert(response.getReturnValue())
                
                if(response.getReturnValue()==="T&D"){
                    component.set("v.isRecordTypeRepair",true);
                }
            }
            else{
                alert("Fail");
                 console.log("Fail");
            }
           
            
        });
         $A.enqueueAction(action);
    }
})