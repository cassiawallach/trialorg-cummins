({
    sendCaseToServicenNowmethod : function(component, event, helper) {
        component.set("v.loaded",true);
        var record = event.getParam("response");//added
        //changes start 
        var auraName=event.getSource().getLocalId();
        console.log('auraName=='+auraName);
        var incidentaction=false; 
        if(auraName=="sendAttachment"){
            incidentaction =true;
        }
        var actincup=component.get("v.incActionType");
        //changes end
        console.log('actionTYPE=='+incidentaction);
        console.log('incActionType=='+actincup);
        var myAttribute = component.get("v.recordId");
        console.log('recordId=='+myAttribute);
        var action = component.get("c.sendCaseToServicenNowmethod");
        //modified
        action.setParams({ "incidentId" : myAttribute,"IncidentAction" : incidentaction,"incActionType" :actincup});//added IncidentAction
        action.setCallback(this, function(a) {
            var state = a.getState();
            var respMessage;
            var responseType;
            if (state === "SUCCESS") {
                component.set("v.incidentControllerObj",a.getReturnValue());
                console.log('server output'+JSON.stringify(a.getReturnValue()));
                if(!$A.util.isEmpty(component.get("v.incidentControllerObj"))){
                    var controllerObj = component.get("v.incidentControllerObj");
                    // component.set("v.IncidentId",controllerObj.incidentId);
                    //component.set("v.incidentNoCheck",controllerObj.incidentNocheck);
                    component.set("v.displayRecordForm",false);
                    component.set("v.displayIncOpt",true);
                    
                    respMessage=controllerObj.respMessage;
                    responseType=controllerObj.responseType;
                    // alert('respMessage'+respMessage);
                    //if(!$A.util.isEmpty(component.get("v.incidentNoCheck"))){
                    //  setTimeout(location.reload.bind(location), 2000);}
                }
                component.set("v.loaded",false);
                component.set("v.incidentOptionsValue",'');
                if(auraName==='sendAttachment'){
                    component.set("v.displayRecordForm",false);
                    component.set("v.showAttachementOption",false);
                    component.set("v.displayIncOpt",true);
                 }
                else if(auraName==='IncidentForm' && responseType==='Success') {
                    component.set("v.displayIncOpt",false);
                    component.set("v.showAttachementOption",true);
                }
               
                     var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": responseType,
                    "message": respMessage                   
                       
                });
                toastEvent.fire();
                
                 if(responseType==='Success'){
                    $A.get('e.force:refreshView').fire();
                } 
               }   
        });
        $A.enqueueAction(action);
    },
    uploadAttachements: function(component,event, helper){
        var optionValue = event.getParam("value");
        if(optionValue=='No'){
            component.set("v.displayIncOpt",true);
            component.set("v.showAttachementOption",false);
            component.set("v.isFileUpload",false); 
            component.set("v.incidentOptionsValue",'');
        }
        else if(optionValue=='Yes'){
            component.set("v.isFileUpload",true); 
            component.set("v.incidentOptionsValue",'');
        }
    },
    handleUploadFinished: function(component,event, helper){
        
    },
    checkAttachment:function(component,event, helper){
          var action = component.get("c.checkAttachment");
        action.setParams({ incidentId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isFileAttached",response.getReturnValue());
            }});
        $A.enqueueAction(action);
    }
    
})