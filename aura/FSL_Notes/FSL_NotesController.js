({
    doInit: function(component, event, helper) {
        helper.fetchNotes(component, event, helper);
        helper.fetchUser(component, event, helper);
        // Initialize input select options CT3-169 - Modified by Sailaja for custom translations to be applied
        var jobSortOption1 = $A.get("$Label.c.FSL_Job_Notes_Old_To_New");
        var jobSortOption2 = $A.get("$Label.c.FSL_Job_Notes_New_To_Old");
        var opts = [
            { "class": "optionClass", label: jobSortOption1 ? jobSortOption1 : 'Oldest to Newest', value: "asc", selected: "true" },
            { "class": "optionClass", label: jobSortOption2 ? jobSortOption2 :'Newest to Oldest', value: "desc" }

        ];
        component.find("InputSelect").set("v.options", opts);
    },
    
    checkNotesValue: function(component, event, helper) {
        var notesData = component.get("v.textAreaValue");
        if(notesData === undefined || notesData === null || notesData === '' || notesData.trim() == "") {
            component.set("v.btndisable", true);
        } else {
            component.set("v.btndisable", false);
        }
    },
    
    onChange : function(component, event, helper) {
        var dynamicSort = component.find("InputSelect");
        var sortValue = dynamicSort.get("v.value");
        helper.fetchNotes(component, event, helper);
    },
    //TW-84 Karthik Pedditi
    openModal: function(component, event, helper) {
        component.set("v.isPopupOpen", true);
        var rectarget = event.currentTarget;
        var noteStr = rectarget.getAttribute("data-notes");
        component.set('v.notesType', noteStr);
        if(noteStr === 'SERVICENOTES') {
           // component.set('v.notesDesc', "Service Notes:");
          component.set('v.notesDesc', $A.get("$Label.c.FSL_WRITERNOTES"));
        } else if(noteStr === 'TECHNICIANNOTES') {
           // component.set('v.notesDesc', "Technician Notes:");
           component.set('v.notesDesc', $A.get("$Label.c.FSL_TECHNICIANNOTES"));
        } else if(noteStr === 'JOBSTATUSNOTES') {
          //  component.set('v.notesDesc', "Job Status Notes:");
               component.set('v.notesDesc', $A.get("$Label.c.FSL_SUPERVISORNOTES"));
        } else if(noteStr === 'CUSTOMERNOTES') {
          //  component.set('v.notesDesc', "Customer Notes / Approvals:");
           component.set('v.notesDesc', $A.get("$Label.c.FSL_JOURNALNOTES"));
        } else if(noteStr === 'PARTSPROFESSIONAL') {
           // component.set('v.notesDesc', "Parts Professional:");
            component.set('v.notesDesc', $A.get("$Label.c.FSL_PARTSPROFESSIONAL"));
        }
    },
    
    closeModal: function(component, event, helper) {
        component.set("v.isPopupOpen", false);
        component.set("v.textAreaValue", '');
        component.set("v.btndisable", true);
    },
    
    handleKeyup : function(component, event, helper) {
        var elem = event.getSource().get('v.value');
        var max = 4000;
        var remaining = max - elem.length;
        
        component.set('v.charsRemaining', remaining);
    },
    
    saveNotes : function(component, event, helper) {
        //CT3-84 Technician Job notes are duplicating start
        component.set("v.btndisable", true);
       // CT3-84 Technician Job notes are duplicating end
        var params = {
            recId : component.get("v.recordId"),
            noteType : component.get("v.notesType"),
            noteValue : component.get("v.textAreaValue")
        };
        var config = JSON.stringify(params);
        
        var action = component.get("c.saveNotesDetails");
        action.setParams({
            configData : config
        });
        
        action.setCallback(this, function(a){
            if(a.getState() === "SUCCESS"){
                //TW-87 Karthik Pedditi
                if(a.getReturnValue()!==null && a.getReturnValue()!=='RECORD_INSERTED'){
                    // Prepare a toast UI message
                    
                    //Start of changes for NIN-407 done by Adam
                    var resultVal = a.getReturnValue();
                    if(resultVal.includes('WO has been closed')||resultVal.includes('CSS job id')){
                        //console.log(resultVal);
                        var action1 = component.get("c.getCustomMetaDataTypesForErrors");
                        
                        resultVal = resultVal.substring(0,2);
                        
                        var errorMessage = '';
                        action1.setParams({
                            errorCode: resultVal
                        });
                        
                        action1.setCallback(this, function (response) {
                            var state = response.getState();
                            var result = response.getReturnValue();
                            console.log('state' + state);
                            console.log(result);
                            if (state === "SUCCESS") {
                                errorMessage = result;
                                component.set("v.errorMessage", result);
                                console.log(errorMessage);
                                var resultsToast = $A.get("e.force:showToast");
                                resultsToast.setParams({
                                    "type" : "error",
                                    "message": errorMessage
                                });
                                $A.get("e.force:closeQuickAction").fire();
                                resultsToast.fire();
                            }else{
                                console.log('FAIL');
                                var resultsToast = $A.get("e.force:showToast");
                                resultsToast.setParams({
                                    "type" : "error",
                                    "message": a.getReturnValue()
                                });
                                $A.get("e.force:closeQuickAction").fire();
                                resultsToast.fire();
                            }
                        });
                        $A.enqueueAction(action1);
                        console.log(errorMessage);
                    }else{
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "type" : "error",
                            "message": a.getReturnValue()
                        });
                        $A.get("e.force:closeQuickAction").fire();
                        resultsToast.fire();
                    }
                    
                    //End of 407 Changes
                    
                      
                component.set("v.isPopupOpen", true);    
                }else{
                //End TW-87
                var resultToast = $A.get("e.force:showToast");
                var jobNoteAdd = $A.get("$Label.c.EVL_Job_Notes_are_added_to_Service_Order");
                resultToast.setParams({
                    "type" : "success",
                    "message": jobNoteAdd
                });
                resultToast.fire();
                component.set("v.isPopupOpen", false);
                component.set("v.textAreaValue", '');
              //  component.set("v.btndisable", true);
                helper.fetchNotes(component, event, helper);
                }
            }
        });
        $A.enqueueAction(action);
    },
})