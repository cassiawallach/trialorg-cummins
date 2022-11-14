({
    updateCommunication_helper : function(component){
        var recordId = component.get("v.recordId");
        let action = component.get("c.updateType");
        action.setParams({
            "Workid" : component.get("v.recordId")
        })
        action.setCallback(this,function(response){
            let state = response.getState();
            if(state === "SUCCESS"){
                let result = response.getReturnValue();
                $A.get('e.force:refreshView').fire(); 
            } else if(state === "ERROR"){
                let errors = response.getError();
                let message = 'Unknown error'; 
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                this.showToast('ERROR',message,"error");
            }
        });
        $A.enqueueAction(action);
    }
    
})