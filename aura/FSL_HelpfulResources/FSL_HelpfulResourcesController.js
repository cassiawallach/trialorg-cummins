({
    handlePSNSearch : function(component, event, helper) {
        helper.getIsDelaerProfile(component, event); //Added by Piyush for VGRS2-231
        var onSerach =event.getParam('arguments'); 
        if(onSerach.fromParentSearch){
            console.log('::: PSN Value Karthik>>>>>> - '+component.get("v.searchPSN"));
            component.set('v.showComponent', true);
            var action = component.get("c.startRequest");
            action.setParams({ 
                enteredPSN : component.get("v.searchPSN") 
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var arrayMapKeys = [];
                    console.log("::: From server: " + response.getReturnValue());
                    //component.set('v.isPSNValid', response.getReturnValue());
                    var result = response.getReturnValue();
                    component.set('v.linkMap', result);
                    for (var key in result) {
                        if(result['isPSNValid'] === 'TRUE') {
                            component.set('v.isPSNValid', true);
                            component.set('v.showError', false);
                        } else {
                            component.set('v.isPSNValid', false);
                            component.set('v.showError', true);
                        }
                        if(key === 'partlink') {
                            component.set('v.partlink', result[key]);
                        } else if (key === 'servicelink'){
                            component.set('v.servicelink', result[key]);
                        } else if (key === 'dataPlatelink') {
                            component.set('v.dataPlatelink', result[key]);
                        }else if(key === 'smnfmilink') {
                            component.set('v.spnfmiLink', result[key]);
                        } else if(key === 'ecmlink') {
                            component.set('v.ecmLink', result[key]);
                        }else if (key === 'wiringdiagramlink') {  // Story CT2-78
                            component.set('v.wiringdiagramlink', result[key]);
                            
                        }
                    }
                    
                } else if (state === "INCOMPLETE") {
                    // do something
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("::: Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("::: Unknown error");
                    }
                }
                
            });
            $A.enqueueAction(action);
        }
    },
    
    handlePartCatalogLink : function(component, event, helper) {
        alert('Clicked - Parts Catalog');
    },
    
    handleServiceManualLink: function(component, event, helper) {
        console.log('::: PSN Value in Seearc Manual - '+component.get("v.searchPSN") );
        var action = component.get("c.getService");
        action.setParams({ 
            psnValue : component.get("v.searchPSN") 
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                alert("::: From server: " + response.getReturnValue());
                component.set('v.serviceURL', response.getReturnValue());
            } else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("::: Error message Service Link: " + errors[0].message);
                    }
                } else {
                    console.log("::: Unknown error Service Link");
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    
    handleDataPlateLink : function(component, event, helper) {
        alert('clicked - Data Plate');
    },
    
    handleSPNFMILink : function(component, event, helper) {
        alert('clicked - SPN/FMI');
    },
    
    handleRevisionHistoryLink : function(component, event, helper) {
        alert('clicked - ECM Calibration Revision History');
    },
    
    handleWiringDiagram : function(component, event, helper) { 
        
    },
})