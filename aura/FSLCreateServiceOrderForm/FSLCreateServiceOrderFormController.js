({
    doInit : function(component, event, helper) {
        if(component.get("v.pageReference") != null)
            component.set('v.recordId',component.get("v.pageReference").state.c__soid);
    },
    
    SaveRecord : function(component, helper) {
        var tempRecord = component.get("v.selectedLookUpRecord");
        var action = component.get('c.createForm'); 
        action.setParams({
            "tempId" : tempRecord.Id,
            "soId" : component.get('v.recordId')
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({
                    "recordId": a.getReturnValue()
                });
                editRecordEvent.fire();
                
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get('v.recordId'),
                });
                navEvt.fire();
                var workspaceAPI = component.find("workspace");
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                    var focusedTabId = response.tabId;
                    workspaceAPI.closeTab({tabId: focusedTabId});
                })
                .catch(function(error) {
                    console.log(error);
                });
                
            }
            
            
        });
        $A.enqueueAction(action);
    }
})