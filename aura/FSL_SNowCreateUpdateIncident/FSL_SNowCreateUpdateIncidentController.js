({//Added New
    doInit: function(cmp,event, helper) {
        helper.checkAttachment(cmp,event, helper);
        var action = cmp.get("c.checkIncidentNo");
        action.setParams({ caseId : cmp.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.incidentnoCheck",response.getReturnValue());
            }});
        $A.enqueueAction(action);
        
    },
    handleChange: function (cmp, event) {
        var changeValue = event.getParam("value");
        if(changeValue ==="Create"){
            cmp.set("v.displayIncOpt",false);
            cmp.set("v.displayIncCreateOpt",true);
        }
        else if(changeValue ==="Update"){
            cmp.set("v.displayIncOpt",false);
            cmp.set("v.incActionType",false);
            var action = cmp.get("c.checkIncidentRecord");
            action.setParams({ caseId : cmp.get("v.recordId") });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    cmp.set("v.incidentControllerObj",response.getReturnValue());
                    if(!$A.util.isEmpty(cmp.get("v.incidentControllerObj"))){
                        var controllerObj = cmp.get("v.incidentControllerObj");
                        if(controllerObj.incidentLst.length > 1){                            
                            cmp.set("v.displayIncidentRec",true);
                            cmp.set("v.incidentToUpdate",controllerObj.incidentLst);
                            var items=[];
                            for(var i=0;i<controllerObj.incidentLst.length;i++){
                                var item={
                                    "label" :controllerObj.incidentLst[i].CSM_Ticket_Incident_Number__c,
                                    "value" :controllerObj.incidentLst[i].Id
                                };
                                items.push(item);
                                cmp.set("v.incRecToUpdate", items);
                            }
                            
                            alert(json.stringify(controllerObj.incidentLst));  
                        }
                        else if(controllerObj.incidentIdLst.length == 1){
                            cmp.set("v.IncidentId",controllerObj.incidentIdLst[0]);
                            cmp.set("v.displayRecordForm",true);
                        }
                    }
                }});
            $A.enqueueAction(action);
            
            
        }
        else {
              cmp.set("v.isModalOpen",true);
            }
        
    },
    handleIncUpd: function (cmp, event) {
        var incRecId = event.getParam("value");
        cmp.set("v.IncidentId",incRecId);
        cmp.set("v.displayIncidentRec",false);
        cmp.set("v.displayRecordForm",true);
        
    },
    createIncident: function (cmp, event) {
        cmp.set("v.incActionType",true);
        var changeValue = event.getParam("value");
        cmp.set("v.displayIncCreateOpt",false);
        cmp.set("v.displayRecordForm",true);
        var action = cmp.get("c.populateIncidentFiled");
        action.setParams({ caseId : cmp.get("v.recordId") });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.incidentControllerObj",response.getReturnValue());
                if(!$A.util.isEmpty(cmp.get("v.incidentControllerObj"))){
                    var controllerObj = cmp.get("v.incidentControllerObj");
                    if(!$A.util.isEmpty(controllerObj.subject)){
                        cmp.set("v.subject",controllerObj.subject);
                    }
                    if(!$A.util.isEmpty(controllerObj.description)){
                        cmp.set("v.description",controllerObj.description);}
                }
            }});
        $A.enqueueAction(action);
    },
    
    
    handleOnLoad: function(component,event, helper) {
        // Set the attribute value.
        // You could also fire an event here instead.
        // helper.sendCaseToServicenNowmethod(component,event, helper);
    },
    
    handleOnSubmit: function(component,event, helper) {
        component.set("v.openmodel",true);
        // Set the attribute value.
        // You could also fire an event here instead.
        // helper.sendCaseToServicenNowmethod(component,event, helper);
    },
    hideModel: function(component, event, helper) {
        component.set("v.openmodel", false);
    },
    
    handleOnSuccess: function(component,event, helper) {
        
        helper.sendCaseToServicenNowmethod(component,event, helper);
    },/*,
                
                    handleOnError: function(component,event, helper) {
                        // Set the attribute value.
                        // You could also fire an event here instead.
                        // helper.sendCaseToServicenNowmethod(component,event, helper);
                    }*/
    uploadAttachements: function(component,event, helper){
        helper.uploadAttachements(component,event, helper);
    },
    
    handleUploadFinished: function(component,event, helper){
         helper.checkAttachment(component,event, helper);
         $A.get('e.force:refreshView').fire(); 
    },
     closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
        component.set("v.incidentOptionsValue",'');
        
    },
    handleClick: function(component, event, helper) {
        component.set("v.isModalOpen",true);  
    },
    onSubmit : function(component, event, helper) {
        component.set("v.isModalOpen", false);
        component.set("v.incidentOptionsValue",'');
        var action= component.get('c.getIncidentStatus');
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var response=response.getReturnValue();
                if($A.util.isEmpty(response.systemError)){
                    if(!$A.util.isEmpty(response.syncIncident)){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "Success",
                            "message":"Incident sync is completed for Incident Number "+response.syncIncident                  
                            
                        });
                        toastEvent.fire();
                    }
                    if(!$A.util.isEmpty(response.failedIncident)){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "Error",
                            "message":"Incident sync is failed for Incident Number "+response.failedIncident                  
                            
                        });
                        toastEvent.fire();
                    }
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "Error",
                        "message":response.systemError                  
                        
                    });
                    toastEvent.fire();
                }
                
                $A.get('e.force:refreshView').fire(); 
            }
        });
        $A.enqueueAction(action);
    },
    oncancel : function(component, event, helper) {
         component.set("v.displayRecordForm",false);  
         component.set("v.incidentOptionsValue",'');
         component.set("v.displayIncidentRec",false);
         component.set("v.displayIncCreateOpt",false);
         component.set("v.displayIncOpt",true);
        
         
       
    }
})