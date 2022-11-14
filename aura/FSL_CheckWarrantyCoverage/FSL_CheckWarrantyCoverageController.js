({
    doInit : function(component, event, helper) {
        helper.doInit(component, event, helper);
	}, 
    
    searchWarrantyCoverage:function(component, event, helper) {
             window.setTimeout(
     $A.getCallback(function() {
               helper.searchWarrantyCoverage(component, event, helper);   
     }), 2000
);
    },
    retryClick : function (component, event, helper) {
        console.log('::: Retry Called');
        //alert('Hello Bhavishya'); 
        helper.showSpinner(component);
        var action_2 = component.get('c.fetchFieldActions');
        console.log('::: after Retry Called');
        //alert('Hello Druvan');
        
        var params = {
            'esnValue' : component.get('v.psnValue'),
            'regionValue' : component.get('v.selectedRegion'),
            'terrValue' : component.get('v.selectedTerritory'),
            'failureDate' : component.get('v.failureDate')
        };
        //console.log('params_1::'+params);
        var parameters = JSON.stringify(params);
        //console.log('parameters_1::'+parameters);
        action_2.setParams({
            "config":parameters
        });
        //console.log('config_1::'+config);
        action_2.setCallback(this, function(response){
                var state1 = response.getState();
                console.log('state1**'+state1);
                if(state1 === "SUCCESS"){
                    helper.hideSpinner(component);
                    var results1 = response.getReturnValue();
                    console.log(':::Results11 = '+results1);
                    component.set("v.FieldActionList", response.getReturnValue());
                    var myFieldActions = component.get("v.FieldActionList");
                    console.log('myFieldActions**'+myFieldActions);
                    if(myFieldActions != null){
                    console.log('mycount**'+myFieldActions.length);
                    component.set("v.faCount", myFieldActions.length);
                    component.set('v.isServiceFailure', false);
                    }
                    //console.log('FACout:'+c.faCount);
                    //component.set("v.faCount", c.faCount);
                    //console.log(':::v.FieldActionList = '+v.FieldActionList);
                    if(response.getReturnValue() == null) {
                        component.set('v.isFAEmpty', true);
                    } else {
                        component.set('v.isFAEmpty', false);
                    }
                } 
                //else if (state === "ERROR") {
                    else{
                        console.log('::test');
                    var errors = response.getError();
                    console.log(':::errors'+errors);
                   // helper.hideSpinnertwo(component);  
                    //var staticLabel = $A.get("$Label.c.FSL_Warranty_Technical");
                   /* if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " + 
                                  errors[0].message);
                        }
                    } else {
                        alert("Unknown error");
                    }*/
                }
                helper.hideSpinner(component);  
            }); 
            $A.enqueueAction(action_2); 
        //location.reload();
    },
    
    handleDateChange : function(component, event, helper) {
        console.log('::: Warranty Startdate Changed='+component.find("inputWSDField").get("v.value"));
        var inputService = component.find('inputService');
        var dateValue = component.find("inputWSDField").get("v.value");
        var dateField = component.find("inputWSDField");
        if(dateValue != null) {
            component.set('v.disabledBIS', true);
            
            inputService.setCustomValidity("");
             inputService.reportValidity();
            dateField.setCustomValidity("");
             dateField.reportValidity();
            
        } else {
            component.set('v.disabledBIS', false);
        }
         
    },
   
    handleServiceChange : function(component, event, helper) {
        var inputService = component.find('inputService');
        var serviceValue = component.find("inputService").get('v.checked');
        console.log('Test2345');
        console.log('$$$ serviceValue = '+serviceValue);
        if(serviceValue) {
            component.set('v.readOnlyWSD', true);
            component.set('v.isrequiredWSD',false);
             console.log('Test1234');
            inputService.setCustomValidity("");
            inputService.reportValidity();
            //var el = component.find("inputWSDField").get("v.value");
            var inputWSDField = component.find('inputWSDField');
             console.log(inputWSDField);
           
              inputWSDField.setCustomValidity('');
              
                inputWSDField.reportValidity();
            
        } else {
            component.set('v.readOnlyWSD', false);
        }
          
 
    },
    
    hideErrors : function(component, event, helper) {
        var el = component.find("inputWSDField");
        $A.util.removeClass(el, "slds-has-error"); // remove red border
        $A.util.addClass(el, "hide-error-message"); // hide error message
    },
     
    /* CT3-92 Added by Sailaja Guntupalli for custom validation on product hours,commented out for future story 
    validateProdHours : function(component, event, helper) {
        var field = component.find(event.getSource().getLocalId());
        var val = field.get("v.value");
        if(val > 999999.9) {
            component.set('v.isProdHourValid', true);
             component.set('v.disableSearch', true);
        } else {
            component.set('v.isProdHourValid', false);
            component.set('v.disableSearch', false);
        }
    },*/
	psnChange : function(component, event, helper) {
        console.log('::: PSN Value - changed'+component.get("v.psnValue") );
        component.set('v.disableSearch',false);
        component.set('v.warrantyDate',null);
        component.set('v.warrantyCoverageList',null);	// PHOEN-27 ----Naveen Goud 
        component.set('v.FieldActionList',null);		// PHOEN-27 ----Naveen Goud 
        component.set('v.isWarrantyFlag',false);		// PHOEN-27 ----Naveen Goud
        component.set('v.isNonCumminsAssetFlag',false);	// PHOEN-27 ----Naveen Goud
        component.set('v.faCount',null);				// PHOEN-27 ----Naveen Goud
        var action = component.get("c.startRequest");
        action.setParams({ 
            psnValue : component.get("v.psnValue") 
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var results = response.getReturnValue();
            console.log(state);
            console.log(results);
            
            if (state === "SUCCESS" ) {
                if(!$A.util.isEmpty(results)) {
                    component.set('v.isPSNValid', false);
                    
                    console.log('results[0].NonCumminsAssetFlag',results[0]);
                    console.log('results[0].NowarrantyFlag',results[0].NowarrantyFlag);
                    console.log('results[0].NonCumminsAssetFlag',results[0].NonCumminsAssetFlag);
                    
                    component.set('v.noWarrantyFlag', false);  // Added:CT3-485 Charan
                    component.set('v.nonCumminsAssetFlag', false); 
                    component.set('v.isWarrantyFlag', false);   //Added:CT3-485 Charan
                    component.set('v.isNonCumminsAssetFlag',false);
                    
                    component.set('v.noWarrantyFlag', results[0].NowarrantyFlag);  // Added:CT3-485 Charan
                    component.set('v.nonCumminsAssetFlag', results[0].NonCumminsAssetFlag); 
                    if(results[0].pickListWrapperList != null) {
                        console.log('::: Applications - '+results[0].pickListWrapperList);
                        component.set('v.applicationList', results[0].pickListWrapperList);
                    } else {
                        component.set('v.applicationList', "");
                    }
                    if(results[0].warrantyStartDate != null) {
                        console.log('::: Warranty Date - '+results[0].warrantyStartDate);
                        
                        component.set('v.warrantyDate', results[0].warrantyStartDate);
                        component.set('v.readOnlyWSD', true);
                        component.set('v.disabledBIS', true);
                    } else {
                        component.set('v.readOnlyWSD', false);
                        component.set('v.disabledBIS', false);
                    }
                    if(results[0].Application != null) {
                        console.log('::: Application - '+results[0].Application);
                        component.set('v.selectedApp', results[0].Application); 
                    } else {
                        component.set('v.selectedApp', "");
                    }
                      if(results[0].Region != null) {
                        console.log('::: Region - '+results[0].Region);
                        component.set('v.selectedRegion', results[0].Region); 
                    } else {
                         if(results[0].profileCheckIsDealer){
                         component.set('v.selectedRegion', "");
                        }
                    }
                      if(results[0].Territory != null) {
                        console.log('::: Territory - '+results[0].Territory);
                           component.set('v.selectedTerritory', results[0].Territory); 
                          helper.onRegionSelect(component, event, helper);
                           component.set('v.selectedTerritory', results[0].Territory); 
                       
                    } else {
                        if(results[0].profileCheckIsDealer){
                       component.set('v.selectedTerritory', "");
                        }
                    }
                     if(results[0].Mileage_Measure != null) {
                        console.log('::: Mileage_Measure - '+results[0].Mileage_Measure);
                        component.set('v.searchRadioVal', results[0].Mileage_Measure); 
                    } else {
                        if(results[0].profileCheckIsDealer){
                       component.set('v.searchRadioVal', "");
                        }
                    }
                } else {
                    //component.set('v.applicationList', "");
                    component.set('v.isPSNValid', true);
                    component.set('v.warrantyDate', "");
                    component.set('v.selectedApp', "");
                    component.set('v.readOnlyWSD', false);
                    component.set('v.disabledBIS', false);
                }
                
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
    // Added by Sailaja Guntupalli to redirect to error page for non available QSOL Link content
    loadErrorPage : function(component,event,helper){
        window.open('/apex/FSL_FieldActionsError', '_blank');
 },
    handleAppCodeChange : function(component, event, helper){
        component.set('v.disableSearch',false);
        helper.sendSerachtoParent(component, event, helper);
    },
    
    onRegionSelect : function(component, event, helper) {
        helper.onRegionSelect(component, event, helper);
    },
   
    handleProdMileageChange : function(component, event, helper) {
        var changeValue = event.getParam("value");
        var temp = component.get('v.prodMileage');
        component.set('v.prodMileage', Math.ceil(temp));
    },
    handleProdHoursChange : function(component, event, helper) {
        var changeValue = event.getParam("value");
        var temp = component.get('v.prodHours');
        component.set('v.prodHours', (Math.floor(temp *10)/10));
    },
    handleMileKMChange : function(component, event, helper) {
        var changeValue = event.getParam("value");
        var temp = component.get('v.warrantyCoverageList');
        for(var i = 0, size = temp.length; i < size ; i++ ) {
            var item = temp[i];
            if(changeValue == 'Miles') {
                item.CoverageMiles = Math.round(item.CoverageMiles*0.621371);
            }
            if(changeValue == 'Kilometers') {
                item.CoverageMiles = Math.round(item.CoverageMiles/0.621371);
            }
        }
        component.set('v.warrantyCoverageList', temp);
    },
})