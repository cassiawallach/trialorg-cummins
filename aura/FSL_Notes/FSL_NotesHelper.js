({
    fetchNotes : function(component, event, helper) {
        var action = component.get("c.fetchNoteRecords");
        action.setParams({
            recordId : component.get("v.recordId"),
            sortOrder : component.find("InputSelect").get("v.value")
        });
        var writernote = [], technote = [], supnote = [], journote = [], partnote = [];
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS") {
                var returns = response.getReturnValue();
                returns.forEach(function(note){
                    if(note.nTitle === "SERVICENOTES") //TW-84 Karthik Pedditi
                        writernote.push(note);
                    else if(note.nTitle === "TECHNICIANNOTES")
                        technote.push(note);
                    else if(note.nTitle === "JOBSTATUSNOTES") //TW-84 Karthik Pedditi
                        supnote.push(note);
                    else if(note.nTitle === "CUSTOMERNOTES") //TW-84 Karthik Pedditi
                        journote.push(note);
                    else if(note.nTitle === "PARTSPROFESSIONAL")
                        partnote.push(note);
                });
                component.set("v.WriterNoteList",writernote);
                component.set("v.TechNoteList",technote);
                component.set("v.SupNoteList",supnote);
                component.set("v.JournalNoteList",journote);
                component.set("v.PartNoteList",partnote);
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchUser : function(component, event, helper) {
        var action = component.get("c.fetchUser");
        action.setParams({
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS") {
                var profileName = response.getReturnValue();
                console.log(':::Profile Name-'+profileName);
                component.set("v.userProfile", profileName);
            } else {
                console.log('Error');
            }
        });
        $A.enqueueAction(action);                   
    },
})