({
    doInit: function(component, event, helper) {    
    },
    
    onButtonPressed: function(component, event, helper) {debugger;
        var isValidInput = helper.validateInput(component, event, helper);
        if(isValidInput){
            helper.createAppointments(component, event, helper);
        }
    }
})