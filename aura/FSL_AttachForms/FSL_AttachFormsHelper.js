({
    /*
     *@Desc: Create FORM
     */
    createForm : function(component){
        let action = component.get("c.createForm_apex");
		action.setParams({
			"recordId" : component.get("v.recordId")
		})
		action.setCallback(this,function(response){
			let state = response.getState();
			if(state === "SUCCESS"){
				let result = response.getReturnValue();
				if(result){
					component.set("v.formExists",true);
                    this.showToast('SUCCESS','Form(s) Created Successfully',"success");
                    $A.get('e.force:refreshView').fire();
				}
			} else if(state === "ERROR"){
                let errors = response.getError();
                let message = 'Unknown error'; 
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                this.showToast('ERROR',message,"error");
            }
            component.set("v.isDiabled",false);
            this.hideSpinner(component);
		});
        $A.enqueueAction(action);
    },

    /*
     *@Desc:Show Toast Message
     */
    showToast : function(_title, _message, _type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": _title,
            "message": _message,
            "type": _type
        });
        toastEvent.fire();
    },

    /*
     *@Desc: Show Spinner
     */
    showSpinner : function(component){
        let spinner = component.find("spinner");
        $A.util.removeClass(spinner, "hidden");
    },

    /*
     *@Desc: Hide Spinner
     */
    hideSpinner : function(component){
        let spinner = component.find("spinner");
        $A.util.addClass(spinner, "hidden");
    }

})