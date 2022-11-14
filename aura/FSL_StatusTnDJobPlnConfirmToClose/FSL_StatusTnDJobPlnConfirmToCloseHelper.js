({
	getResolutionsList : function(component, event, helper) {
		var action  = component.get("c.getResolutions");
       action.setCallback(this,function(response){
           if (response.getState() === 'SUCCESS') {
               component.set("v.resolnList",response.getReturnValue());
           }
       });
       $A.enqueueAction(action);
	}
})