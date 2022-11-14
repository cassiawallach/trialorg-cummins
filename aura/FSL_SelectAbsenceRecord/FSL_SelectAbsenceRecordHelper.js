({
    setupOperatingHours : function(component, event, helper) {
        console.log('helper');
        var action = component.get("c.getOperatingHrs");
        action.setCallback( this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") {
                var opHrs = [];
                opHrs = response.getReturnValue();
                if(opHrs.length == 2){
                    component.set("v.startTime", opHrs[0]);
                    component.set("v.endTime", opHrs[1]);
                }
                //helper.openNewAbsenceScreen(component, helper);
            }
            else{
                alert('Error message: Unknown error has occurred ');
            }
        });
        $A.enqueueAction(action);
    },
})