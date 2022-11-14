({

    
    getSOAssertId : function(component, event) {
        var recId = component.get("v.recordId");
          
        var action = component.get("c.getAssetId");
        action.setParams({
            recordId : recId 
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set('v.AssetId', response.getReturnValue());
            } else if(state === "ERROR"){
                var errors = response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
                    }
                }else{
                    console.log("Unknown error"); 
                }
            }
        });
        $A.enqueueAction(action);  
    },

    fetchcoverageHelper : function(component, event, helper) {

        component.set('v.coveragecolms', [
                {label: 'Coverage Definition Type', fieldName: 'Definition_Type__c', type: 'text'},
                {label: 'Coverage Type', fieldName: 'Coverage_Type__c', type: 'text'},
                {label: 'Coverage Miles/Km/Hr/Mw Hr', fieldName: 'Coverage_Miles_Km_Hr_Mw_Hr__c', type: 'Phone'},
                {label: 'Status', fieldName: 'Status__c', type: 'url '},
                {label: 'Warranty Start Date', fieldName: 'Warranty_Start_Date__c', type: 'text'},
                {label: 'Warranty End Date', fieldName: 'Warranty_End_Date_Formula__c', type: 'text'},
                {label: 'Deductible', fieldName: 'Deductible__c', type: 'Phone'},
                {label: 'Warranty Administration Manual', fieldName: 'Warranty_Manual_URL__c', type: 'url '}
            ]);
        var action = component.get("c.fetchCoverages");
        action.setParams({
            woid : '0WO3C0000015AbzWAE'
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.coverageList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    
    fetchcertificateHelper : function(component, event, helper) { 
    
        component.set('v.certificatecolms', [
                {label: 'Coverage Type', fieldName: 'Coverage_Type__c', type: 'text'},
                {label: 'Certificate', fieldName: 'Certificate__c', type: 'Phone'},
                {label: 'Status', fieldName: 'Status__c', type: 'text'},
                {label: 'Start Date', fieldName: 'Start_Date_Formula__c', type: 'url '},
                {label: 'Expiry Date', fieldName: 'Expiry_Date_Formula__c', type: 'text'}, 
                {label: 'Begin Mi/Km/Hr', fieldName: 'Begin_Mi_Km_Hr__c', type: 'Phone'},
                {label: 'End Mi/Km/Hr', fieldName: 'End_Mi_Km_Hr__c', type: 'url '},
                {label: 'Deductible', fieldName: 'Deductible__c', type: 'url '},
                {label: 'Warranty Administration Manual', fieldName: 'Warranty_Admin_Manual_URL__c', type: 'url '}
            ]);
        var action = component.get("c.fetchCertificates");
        action.setParams({
            woid : '0WO3C0000015AbzWAE'
        });
        action.setCallback(this, function(response){
            var state = response.getState();    
            if (state === "SUCCESS") {
                component.set("v.certificateList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }

})