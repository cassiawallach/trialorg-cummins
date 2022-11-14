({
     doInit : function(component, event, helper) {   
       var action = component.get("c.fetechWorkOrder");
        action.setParams({ strjobId : component.get("v.recordId") });
        
        action.setCallback( this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") { 
                
                if(!$A.util.isUndefinedOrNull(response.getReturnValue().After_Image__c)) {
                    component.set("v.checkAfterImage" , true);
                }
                console.log('*** Success...'+response.getReturnValue().INSITE_Work_Order_Image_Name__c+' and '+response.getReturnValue().FaultCode_Max_Sequence__c);
                
                if( (!$A.util.isUndefinedOrNull(response.getReturnValue().INSITE_Work_Order_Image_Name__c))
                   && (!$A.util.isUndefinedOrNull(response.getReturnValue().FaultCode_Max_Sequence__c))){
                    if(response.getReturnValue().INSITE_Work_Order_Image_Name__c != "NA"){
                        component.set("v.imageCode",true);
                        
                        if(($A.util.isUndefinedOrNull(response.getReturnValue().Before_Image__c))) {
                            component.set("v.imageVal", response.getReturnValue().INSITE_Work_Order_Image_Name__c);
                            helper.setBeforeImage(component, event, helper);
                        }
                        
                        if((!$A.util.isUndefinedOrNull(response.getReturnValue().Before_Image__c)) && (response.getReturnValue().Before_Image__c !== response.getReturnValue().INSITE_Work_Order_Image_Name__c)) {
                            console.log('*** After Update Condition');
                            component.set("v.imageVal", response.getReturnValue().INSITE_Work_Order_Image_Name__c);
                            helper.setAfterImage(component, event, helper);
                        }
                        
                       
                    }
                }
                
            }
        });
        $A.enqueueAction(action); 
    }, 
    
    afterImage : function(component, event, helper) {
        var btnValue = event.getSource().get('v.value');
        console.log('::: Button Value = '+btnValue);
        //getFile
        var action = component.get("c.getAfterImageFile");
        action.setParams({ 
            workOrderId : component.get("v.recordId"),
            buttonType : btnValue
        });
        
        action.setCallback( this, function(response) {
            var state = response.getState(); 
            console.log('State*****'+state);
            if (state === "SUCCESS") { 
                var attid = response.getReturnValue();
                //CT1: 503 PiyushR Reading the Browser URL to identify the Community URL '/s/'
                let urlString = window.location.href;
                let baseURL = urlString.substring(0, urlString.indexOf("/s/"));
                console.log(baseURL); 
                var urlEvent = $A.get("e.force:navigateToURL");
                //If not community URL 
                if(baseURL == 'undefined') {
                    urlEvent.setParams({
                    "url": '/servlet/servlet.FileDownload?file=' + attid
                	});
                } else { // If Community URL
                    urlEvent.setParams({
                    "url": baseURL+'/servlet/servlet.FileDownload?file=' + attid
                    });
                }
                urlEvent.fire();
                
            }
            
        });
        $A.enqueueAction(action);
    },
    
    beforeImage : function(component, event, helper) {
        var btnValue = event.getSource().get('v.value');
        console.log('::: Button Value = '+btnValue);
        //getFile
        var action = component.get("c.getFile");
        action.setParams({ 
            workOrderId : component.get("v.recordId"),
            buttonType : btnValue
        });
        
        action.setCallback( this, function(response) {
            var state = response.getState(); 
            console.log('State*****'+state);
            if (state === "SUCCESS") { 
            	var attid = response.getReturnValue();
                //CT1: 503 PiyushR Reading the Browser URL to identify the Community URL '/s/'
                let urlString = window.location.href;
                let baseURL = urlString.substring(0, urlString.indexOf("/s/"));
                console.log(baseURL);
                var urlEvent = $A.get("e.force:navigateToURL");
				//If not community URL                
                if(baseURL == 'undefined') {
                    urlEvent.setParams({
                    "url": '/servlet/servlet.FileDownload?file=' + attid
                	});
                } else { // If Community URL
                    urlEvent.setParams({
                    "url": baseURL+'/servlet/servlet.FileDownload?file=' + attid
                    });
                }
                
                urlEvent.fire();
                
            }
                
        });
        $A.enqueueAction(action);
	}
})