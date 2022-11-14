({ 
     doInit : function(component, event, helper) {
        component.set("v.showSpinner", true);
         window.setTimeout(
            $A.getCallback(function() {
               component.set("v.showSpinner", false);
            }), 6000
        );
      
    },
    edit : function(component, event, helper) {
       // component.set("v.showSpinner", true);
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.recordId")
           
        });
        
        editRecordEvent.fire();
    }
})