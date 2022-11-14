({
    fetchDetails: function(component, event, helper) {
       helper.showDetails(component, event, helper);
     },
     getSolutions :function(component, event, helper)
    {
        var faultID = event.target.getAttribute("data-id");
        console.log('Faultid  ==  '+faultID);
        //console.log('Faultid  ==  '+faultID);
        var woId = component.get("v.recordId");
        
        console.log('woId == '+woId);
        var action = component.get("c.changeRecordDealer");
        action.setParams({
            'workId': woId,
            'faultID':faultID
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS")
            {
                var rid= component.get("v.recordId");              
                
            }
            else if (state === "INCOMPLETE")
            {
                //alert('Response is Incompleted');
            }
            else if (state === "ERROR") 
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                       // alert("Error message: " + 
                            //  errors[0].message);
                    }
                } else {
                   // alert("Unknown error");
                }
            }
           //  location.reload();
        });
        $A.enqueueAction(action);
        
        var cmpEvent = component.getEvent("cmpEvent");
        console.log('Faultid  ==  '+cmpEvent);
        cmpEvent.setParams({
            "faultCode" : faultID });
        cmpEvent.fire();
        
        //alert('woId '+woId);
        //alert('faultID '+faultID);
        //helper.changeRECORDtype(component, event, faultID);
     //  helper.getknowledge(component,event);
    },
	editComp : function(component, event, helper) {
        var ctarget = event.currentTarget;
        var solId = ctarget.dataset.value;
        var faultID = event.target.getAttribute("data-value");
        //alert('faultID'+faultID);
        console.log('faultID'+faultID);
       // component.set("v.faultId",faultID);
		 helper.editCompHelper(component, event, solId,faultID);
     
    },    
 })