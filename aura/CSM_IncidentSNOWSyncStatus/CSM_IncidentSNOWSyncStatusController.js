({
    /*doInit : function(component, event, helper) {
                            var action= component.get('c.getIncidentStatus');
                            action.setParams({ recordId : component.get("v.recordId") });
                            action.setCallback(this, function(response){
                                var state = response.getState();
                                if(state == 'SUCCESS') {
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "type": "Success",
                                        "message": 'Incident status sync is completed.'                   
                                        
                                    });
                                    toastEvent.fire();
                                    $A.get('e.force:refreshView').fire(); 
                                }
                            });
                            $A.enqueueAction(action);
                        }*/
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    handleClick: function(component, event, helper) {
        component.set("v.isModalOpen",true);  
    },
    onSubmit : function(component, event, helper) {
        component.set("v.isModalOpen", false);
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
    }
        //<!--this comments use for  Missing cmp data->
})