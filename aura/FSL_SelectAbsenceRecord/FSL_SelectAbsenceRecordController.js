({
    doInit: function(component, event, helper) {
        helper.setupOperatingHours(component, event, helper);      
        var action = component.get("c.getRecordTypeValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var recordTypes = result.resAbsenceRecordTypes;
                var recordtypeMap = [];
                for(var key in recordTypes){
                    recordtypeMap.push({label: recordTypes[key], value: key});
                }
                component.set("v.recordTypeMap", recordtypeMap);
                component.set("v.selectedRecordTypeId", result.defaultRecordTypeId);
            }
        });
        $A.enqueueAction(action);
    },
    
    
    /**   openNewAbsenceScreen : function(component, helper) {
        var createResrcAbseRec = $A.get("e.force:createRecord");
        createResrcAbseRec.setParams({
            "entityApiName": "ResourceAbsence",
            "defaultFieldValues": {               
                "Start" : component.get("v.startTime"),
                "End" : component.get("v.endTime")
                
            }
        });
        createResrcAbseRec.fire();
    },**/
    
    handleCreateRecord: function(component, event, helper) { 
        var selectedRecordTypeId = component.get("v.selectedRecordTypeId");
        if(selectedRecordTypeId){
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": 'ResourceAbsence',
                "recordTypeId": selectedRecordTypeId,
                "defaultFieldValues": {
                    'Start' : component.get("v.startTime") ,
                    'End' : component.get("v.endTime") 
                }
            });
            createRecordEvent.fire();
        }
    },
})