({
	doInit: function(component, event, helper) {
        var action = component.get("c.getConnectedDiagnostics");
       
        var UsertoolPSN = component.get("v.jobESN");
         //alert('UsertoolPSN>>>>'+UsertoolPSN);
        action.setParams({
            wordOrderId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var returnList = response.getReturnValue();
            component.set("v.AlertList", returnList);  
            //alert('returnList>>>>'+returnList);
        });
        $A.enqueueAction(action); 
    },
})