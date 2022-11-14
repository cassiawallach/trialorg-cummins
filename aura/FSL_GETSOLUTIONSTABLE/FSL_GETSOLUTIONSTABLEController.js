({
    fetchDetails: function(component, event, helper) {
        helper.showDetails(component, event, helper);
        //this.doAction(component,event);
    },
    doAction : function(component, event) {
        component.set("v.ShowSpinner", true);//added by Piyush VGRS2-321
        var params = event.getParam('arguments');
        if (params) {
            var cumCode = params.cumCode;
            var pcode = params.pcode;
            var spn = params.spn;
            var highLevelSymptom = params.highLevelSymptom;
            var lowLevelSymptom = params.lowLevelSymptom;
            var recordId = params.recordId;
            //var recordId ='0WO1D0000004dBMWAY';
            // alert('param1**'+cumCode+'*record id*'+recordId);
            var action = component.get('c.wrapRec');
            action.setParams({
                serviceOrderId : recordId,
                spn : spn,
                cumminsfaultCode : cumCode,
                pcode : pcode,
                highLevelSymptom : highLevelSymptom,
                lowLevelSymptom : lowLevelSymptom,
            });
            action.setCallback(this, function(response) {
                //store state of response
                var state = response.getState();
                if (state === "SUCCESS") {
                    //set response value in wrapperList attribute on component.
                    component.set('v.wrapperList', response.getReturnValue());
                    $A.get('e.force:refreshView').fire(); // Added by Ramya VGRS2-501
                }
                component.set("v.ShowSpinner", false);//added by Piyush VGRS2-321
            });
            $A.enqueueAction(action);
            
            // add your code here
        }
    },
    
    //added by Sriprada
    getSolutions :function(component, event, helper)
    {
        var faultID = event.target.getAttribute("data-id");
        console.log('Faultid  ==  '+faultID);
        var woId = component.get("v.recordId");
        //alert('woId '+woId);
        //alert('faultID '+faultID);
        helper.changeRECORDtype(component, event, faultID);
        //  helper.getknowledge(component,event);
    },
    editComp : function(component, event, helper) {
        var ctarget = event.currentTarget;
        var solId = ctarget.dataset.value;
        // var faultID = event.target.getAttribute("data-id");
        // component.set("v.faultId",faultID);
        helper.editCompHelper(component, event, solId);
        
    },   
    
})