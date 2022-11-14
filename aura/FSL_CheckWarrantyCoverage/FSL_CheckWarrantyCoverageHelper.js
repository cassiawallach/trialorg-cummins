({
    doInit : function(component, event, helper) {
        helper.getRegionsData(component, event, helper);
        helper.getApplicationData(component, event, helper);   
        helper.getTerritoryData(component,event,helper);
        
    },
    getUserRegionTeritory : function(component,event,helper){
        var actionProfile = component.get("c.requredProfile");
        actionProfile.setCallback(this, function(responseProfile){
            var stateProfile = responseProfile.getState();
            if (stateProfile === "SUCCESS"){
                if(responseProfile.getReturnValue()){
                    var action = component.get("c.getUserRegionTerrValues");
                    action.setCallback(this, function(response){
                        var state = response.getState();
                        if (state === "SUCCESS"){
                            var result = response.getReturnValue();
                            var regionValues =  component.get("v.regionList");
                            let regionListStrigified = JSON.stringify(regionValues);
                            var containsReg = regionListStrigified.includes(result.Region);
                            
                            var measureValues =  component.get("v.radioOptions");
                            let measureStrigified = JSON.stringify(measureValues);
                            var measrVal = measureStrigified.includes(result.Mileage_Measure);
                            
                            if(measrVal){
                                component.set("v.searchRadioVal",result.Mileage_Measure);
                            }
                            if(containsReg){
                                component.set("v.selectedRegion",result.Region);
                                this.onRegionSelect(component, event, helper);
                            }
                        } 
                    });
                    $A.enqueueAction(action);  
                }
            }
        });
        $A.enqueueAction(actionProfile);
        
    } , 
    onRegionSelect : function(component, event, helper) {
        var action = component.get("c.getTerritoryValues");
        helper.sendSerachtoParent(component, event, helper);
        action.setParams({ 
            regionSelected : component.get("v.selectedRegion")   
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var results = response.getReturnValue();
            if (state === "SUCCESS") {
                console.log(results);
                for (var index = 0; index < results.length; index++) {
                    console.log(results[index].Value);
                    if(results[index].Value == component.get('v.selectedTerritory')){
                        results[index].selected =true;
                    }
                }
                component.set('v.territoryList', results);
                var action1 = component.get("c.getUserRegionTerrValues");
                action1.setCallback(this, function(response1){
                    var state1 = response1.getState();
                    if (state1 === "SUCCESS"){
                        var result1 = response1.getReturnValue();
                        
                        var territoryValues =  component.get("v.territoryList");
                        
                        let territoryListStrigified = JSON.stringify(territoryValues);
                        var containsTer = territoryListStrigified.includes(result1.Territory);
                        
                        if(containsTer == true){
                            component.set("v.selectedTerritory",result1.Territory);
                        }
                    } 
                });
                $A.enqueueAction(action1);
                //component.set('v.selectedTerritory', component.get('v.selectedTerritory')); 
                
            } 
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
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
    searchWarrantyCoverage: function(component, event, helper) {
        if(!component.get('v.isPSNValid')){
            console.log('v.isPSNValid'+ component.get('v.isPSNValid'));
            console.log('!v.isPSNValid'+ !component.get('v.isPSNValid'));
            console.log('v.nonCumminsAssetFlag in searchWarrantyCoverage'+ component.get('v.nonCumminsAssetFlag'));
            console.log('v.isWarrantyFlag in searchWarrantyCoverage'+ component.get('v.noWarrantyFlag'));
            console.log('!v.nonCumminsAssetFlag in searchWarrantyCoverage'+ !component.get('v.nonCumminsAssetFlag'));
            console.log('!v.noWarrantyFlag in searchWarrantyCoverage'+ !component.get('v.noWarrantyFlag'));
            
            
            
            if(component.get('v.noWarrantyFlag') == false && component.get('v.nonCumminsAssetFlag') == false){ 
                console.log('inside if');// Added:CT3-485 Charan
               component.set('v.isWarrantyFlag', false);   //Added:CT3-485 Charan
               component.set('v.isNonCumminsAssetFlag',false);   

              /* if(component.get('v.nonCumminsAssetFlag')){
                component.set('v.isNonCumminsAsset', true); 
                }*/
                console.log('v.isWarrantyFlag in searchWarrantyCoverage'+component.get('v.isWarrantyFlag'));
                console.log('v.isNonCumminsAsset in searchWarrantyCoverage'+component.get('v.isNonCumminsAsset'));
                var userId = $A.get("$SObjectType.CurrentUser.Id");
                console.log(userId);
                console.log(component.get('v.selectedTerritory'));
                console.log('::: Warranty Coverage Called');
                component.set('v.disableSearch',true);
                var startDate = component.get('v.warrantyDate');
                var validForm = component.find('searchForm').reduce(function(validField, inputCmp) {
                    // Displays error messages for invalid fields
                    inputCmp.showHelpMessageIfInvalid();
                    return validField && inputCmp.get('v.validity').valid;
                }, true);
                var serviceValue = component.find("inputService").get('v.checked'); 
                
                var inputService = component.find('inputService');
                if((startDate == null && !serviceValue) || ((startDate != null && serviceValue) ) ){
                    inputService.setCustomValidity("Enter Warranty Start Date or Select Before In Service");
                    inputService.reportValidity();
                    var el = component.find("inputWSDField").get("v.value");
                    var inputWSDField = component.find('inputWSDField');
                    console.log(inputWSDField);
                    if(el != null){
                        
                    }else{
                        // inputService.setCustomValidity("Enter Warranty Start Date or Select Before In Service");
                        
                        inputWSDField.reportValidity();
                    }
                    
                }
                
                if(validForm && (startDate != null || serviceValue)) {
                    helper.showSpinner(component);
                    var action = component.get('c.fetchWarrantyCoverage');
                    //CT3-498, Dinesh Yadav, Added failureDate 
                    var params = {
                        'esnValue' : component.get('v.psnValue'),
                        'appValue' : component.get('v.selectedApp'),
                        'regionValue' : component.get('v.selectedRegion'),
                        'terrValue' : component.get('v.selectedTerritory'),
                        'warrantyStartDate' : component.get('v.warrantyDate'),
                        'failureDate' : component.get('v.failureDate'),
                        'prodMileage' :  component.get('v.prodMileage'),
                        'prodMileageType' : component.find('MileageType').get('v.value'),
                        'prodHour' : component.get('v.prodHours'),
                        'displayCoverage' : component.find('displayCoverage').get('v.value')
                    };
                    
                    var parameters = JSON.stringify(params);
                    action.setParams({
                        "config":parameters
                    });
                    
                    action.setCallback(this, function(response){
                        var state = response.getState();
                        if(state === "SUCCESS"){
                            // helper.hideSpinner(component);
                            var results = response.getReturnValue();
                            console.log(':::Results = '+results);
         					// code changes starts PHOEN-27 ----- Naveen Goud  
                            if(results != null && results != ''){
                            component.set("v.warrantyCoverageList", response.getReturnValue());
                            //Charan--Starts CT3-281 22-01-2021 corrected Miles/kilometers
                            var changeValue = component.find('displayCoverage').get('v.value')
                            
                            var temp = component.get('v.warrantyCoverageList');
                            for(var i = 0, size = temp.length; i < size ; i++ ) {
                                var item = temp[i];
                                
                                
                                // if(changeValue == 'Kilometers') {
                                item.CoverageKM = Math.round(item.CoverageMiles/0.621371);
                                item.CoverageMiles = Math.round(item.CoverageMiles);
                                
                                //}
                            }
                            component.set('v.warrantyCoverageList', temp);
                            component.set('v.isCoveregeEmpty', false);
                            }
                            else{
                                component.set('v.isCoveregeEmpty', true);
                            }
                            //Charan--Ends CT3-281
                           /* if(response.getReturnValue() == null) {
                                component.set('v.isCoveregeEmpty', true);
                            } else {
                                component.set('v.isCoveregeEmpty', false);
                            }*/
                            
                            //Code changes ends PHOEN-27 ----Naveen Goud
                            // helper.hideSpinner(component);  
                        } else {
                            console.log('::: Error in fetching Warranty Coverage');
                        }
                        //START CT3-7.
                        console.log(':::entermycode');
                        var action_1 = component.get('c.fetchFieldActions');
                        
                        var params = {
                            'esnValue' : component.get('v.psnValue'),
                            'regionValue' : component.get('v.selectedRegion'),
                            'terrValue' : component.get('v.selectedTerritory'),
                            'failureDate' : component.get('v.failureDate')
                        };
                        var parameters = JSON.stringify(params);
                        //console.log('parameters_1::'+parameters);
                        action_1.setParams({
                            "config":parameters
                        });
                        //console.log('config_1::'+config);
                        action_1.setCallback(this, function(response){
                            var state1 = response.getState();
                            if(state1 === "SUCCESS"){
                                //helper.hideSpinner(component);
                                var results1 = response.getReturnValue();
                                console.log(':::Results11 = '+results1);
                                //Code changes starts PHOEN-27 ---- Naveen Goud
                                if(results1 != null || results1 != ''){
                                component.set("v.FieldActionList", response.getReturnValue());
                                var myFieldActions = component.get("v.FieldActionList");
                                console.log('myFieldActions**'+myFieldActions);
                                //if(myFieldActions)
                                console.log('mycount**'+myFieldActions.length);
                                component.set("v.faCount", myFieldActions.length);
                                //console.log('FACout:'+c.faCount);
                                //component.set("v.faCount", c.faCount);
                                //console.log(':::v.FieldActionList = '+v.FieldActionList);
                               component.set('v.isFAEmpty', false);
                                }
                                else{
                                    component.set('v.isFAEmpty', true);
                                }
                              /*  if(response.getReturnValue() == null) {
                                    component.set('v.isFAEmpty', true);
                                } else {
                                    component.set('v.isFAEmpty', false);
                                }*/
                                 //Code changes ends PHOEN-27 ---- Naveen Goud
                            } else {
                                console.log('::: Error in fetching Campaign Details');
                                component.set('v.isServiceFailure', true);
                                
                            } 
                            helper.hideSpinner(component); 
                        }); 
                        $A.enqueueAction(action_1); 
                    }); 
                    //helper.hideSpinner(component);
                    $A.enqueueAction(action);
                }
                component.set('v.disableSearch',false);
                
                // helper.hideSpinner(component);  
                
            } else   //Added:CT3-485 Charan -Starts
            {
                console.log('inside else');
                if(component.get('v.noWarrantyFlag') == true){	
                	component.set('v.isWarrantyFlag', true);
                }
                else if(component.get('v.nonCumminsAssetFlag') == true){
                	component.set('v.isNonCumminsAssetFlag',true);
                }
                
                console.log('v.isWarrantyFlag in else'+component.get('v.isWarrantyFlag'));
                console.log('v.isNonCumminsAsset in else'+component.get('v.isNonCumminsAssetFlag'));
            }  // Added:CT3-485 Charan -Ends
        }
    },
    getRegionsData : function(component, event, helper) {
        var action = component.get("c.getRegionValues");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var results = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set('v.regionList', results);
                console.log(results);
                this.getUserRegionTeritory(component,event,helper);
            } 
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error getRegionsData");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    getApplicationData : function(component, event, helper) {
        var action = component.get("c.getApplicationList");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var results = response.getReturnValue();
            console.log(':::Application List - '+results);
            if (state === "SUCCESS") {
                component.set('v.applicationList', results);
            } 
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error getApplicationList");
                    }
                }
        });
        $A.enqueueAction(action);        
    },
    
    showSpinner: function (component, event, helper) {
        var spinner = component.find("Spinner");
        //alert('enteredSpinner');
        $A.util.removeClass(spinner, "slds-hide");
        /*window.setTimeout(
            $A.getCallback(function() { 
                $A.util.addClass(spinner, "slds-hide");
            }), 20000
        );*/
        /*window.setInterval(            
            $A.getCallback(function() { 
                $A.util.addClass(spinner, "slds-hide");
            }), 10000
        );*/
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
    sendSerachtoParent : function(component, event, helper) {
        
    },
    getTerritoryData : function(component, event, helper) {
        
    },
})