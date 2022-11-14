({
    handleSubmit:function(component, event, helper) {
        if(component.get("v.FailureCodes").includes(component.find('inptid').get('v.value')) || component.get("v.FailureCodes").includes(component.find('cmfid').get('v.value'))){
            component.set('v.disabled', false);
            var staticLabel = $A.get("$Label.c.EVL_Selected_Failure_Is_Already_Associated");
            component.set("v.displayerror" , staticLabel);
        }else if((component.find('inptid').get('v.value') == null || component.find('inptid').get('v.value') == '')  && (component.find('cmfid').get('v.value') == null || component.find('cmfid').get('v.value') =='')) {
            component.set('v.disabled', false);
            var staticLabel = $A.get("$Label.c.FSLFailureErrorMessageempty");
            component.set("v.displayerror" , staticLabel);
        }else if((component.find('inptid').get('v.value') != '' && component.find('inptid').get('v.value') !=null ) && (component.find('cmfid').get('v.value') != '' && component.find('cmfid').get('v.value') != null )) {
            component.set('v.disabled', false);
            var staticLabel = $A.get("$Label.c.FSLFailureErrorMessage");
            component.set("v.displayerror" , staticLabel );
        }else {
            component.set('v.disabled', true);
            component.set('v.showSpinner', true);
            var failCodes = component.get("v.FailureCodes")
            if(component.find('inptid').get('v.value')!=null){
                failCodes.push(component.find('inptid').get('v.value'));
            }else{
                failCodes.push(component.find('cmfid').get('v.value'));
            }
            helper.insertsolutioncomp(component, event, helper);
        }
        
    },
    handleFailureNameChange : function(component,event,helper){
       
        var selectedValue = event.getSource().get("v.value");
        
        var failCodes = component.get("v.FailureCodes")
        if(failCodes.includes(selectedValue)){
            helper.showToast('Error','Error','The selected failure is already associated with the solution. Please choose another failure.');
        }
        
    },
    
    cancelmodelwindow:function(component, event, helper) {
        component.set("v.showAddfailure",false);
    },
    
})