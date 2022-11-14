({
    callWarrantyAPI : function (component, event, helper) {
        // alert("Unable to retrieve Warranty Information. Please contact support at Guidanz@cummins.com " + event.getSource().get("v.label"));
        //component.set("v.mylabel", staticLabel);
        component.set("v.loaded", true);
        var action = component.get("c.getWarrantyDetailsNew");
        action.setParams({
            'woId':component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state::'+state);
            var submitPage = true;
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.wo getWarrantyDetails",storeResponse.wo);
                
                var validChk = false;               
        		var strErrorMessage = '';
                
                console.log(storeResponse.ErrorType);
                // component.set("v.isNoWarranty",storeResponse.Asset.No_Warranty__c); //Added:Charan    
                if(storeResponse.ErrorType == 'Application_Missing'){
                    validChk = true; 
                    submitPage = false;
                    strErrorMessage = $A.get("$Label.c.FSL_Application_Service_Order");
                }
              if(storeResponse.ErrorType == 'Non_CumminsAsset'){
                  console.log('Non_CumminsAsset in refresh warranty details' + storeResponse.ErrorType);
                    validChk = true; 
                  console.log('submitPage status1 :: '+submitPage);
                  submitPage = false;
                  console.log('submitPage status2 :: '+submitPage);
                    strErrorMessage = $A.get("$Label.c.FSL_NON_CumminsAsset_For_Warranty");
                  console.log('strErrorMessage :: '+strErrorMessage);
                } 
                else if(storeResponse.ErrorType == 'Mileage'){
                    validChk = true; 
                    submitPage = false;
                    strErrorMessage = $A.get("$Label.c.FSL_Product_Mileage_in_the_Service_Order");
                }
                else if(storeResponse.ErrorType == 'Mileage_Measure'){
                    validChk = true; 
                    submitPage = false;
                    strErrorMessage = $A.get("$Label.c.FSL_Failure_Measure_Work_Order");
                }
                else if(storeResponse.ErrorType == 'Hours_Missing'){
                    validChk = true; 
                    submitPage = false;
                    strErrorMessage = $A.get("$Label.c.FSL_Product_Hours_Service_Order");
                }
                component.set("v.ShowErrorMsg",validChk);
                component.set("v.ErrorMessage",strErrorMessage); 
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                var staticLabel = $A.get("$Label.c.FSL_Warranty_Technical");
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        
                    }
                } else {
                    
                }
            }
            
            console.log('submitPage :: '+submitPage);
            console.log('v.ErrorMessage :: '+strErrorMessage);
            component.set("v.loaded", false);
            if(submitPage == true){
                location.reload();
                console.log('submitPage true:: '+submitPage);
            }
            
        });  
        $A.enqueueAction(action);
       
        
    },
    doInit :  function (component, event, helper) {
       var action = component.get("c.getWorkOrderInfo");
        action.setParams({
            'woId':component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.wo",storeResponse.wo);
                
                var validChk = false;
        		var strErrorMessage = '';
                
                console.log(storeResponse.ErrorType);
                // component.set("v.isNoWarranty",storeResponse.Asset.No_Warranty__c); //Added:Charan    
                if(storeResponse.ErrorType == 'No_Warranty'){
                    validChk = true; 
                    strErrorMessage = $A.get("$Label.c.FSL_NO_applicable_Warranty_coverage_Message");
                }
                /* Added change in getWarrantyDetailsNew method
                 * else if(storeResponse.ErrorType == 'Application_Missing'){
                    //validChk = true; 
                    strErrorMessage = $A.get("$Label.c.FSL_Application_Service_Order");
                }
                else if(storeResponse.ErrorType == 'Mileage'){
                   // validChk = true; 
                    strErrorMessage = $A.get("$Label.c.FSL_Product_Mileage_in_the_Service_Order");
                }
                else if(storeResponse.ErrorType == 'Mileage_Measure'){
                    //validChk = true; 
                    strErrorMessage = $A.get("$Label.c.FSL_Failure_Measure_Work_Order");
                }
                else if(storeResponse.ErrorType == 'Hours_Missing'){
                    //validChk = true; 
                    strErrorMessage = $A.get("$Label.c.FSL_Product_Hours_Service_Order");
                }*/
                
                component.set("v.isNoWarranty",validChk);
                component.set("v.ErrorMessage",strErrorMessage);
            }else if (state === "ERROR") {
                var errors = response.getError();
                var staticLabel = $A.get("$Label.c.FSL_Warranty_Technical");
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
    }
});