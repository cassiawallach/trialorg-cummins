({
    validateInput: function(component, event, helper) {debugger;
        var allInput = ['noOfTechAppointment','techDuration','noOfBayAppointment', 'bayDuration']
        this.clearValidity(component, allInput);
        var noOfTechAppointment = component.get("v.noOfTechAppointment");
        var techDuration = component.get("v.techDuration");
        var noOfBayAppointment = component.get("v.noOfBayAppointment");
        var bayDuration = component.get("v.bayDuration");
        
        const ValidityMsg_noOfTechAppointment = 'No. of Tech appointments to be created field is required.';
        const ValidityMsg_techDuration = 'Duration is required.';
        const ValidityMsg_noOfBayAppointment = 'No. of Bay appointments to be created field is required.';
        const ValidityMsg_bayDuration = 'Duration is required.';
        const ValidityMsg_noOfTechAppointment15 = 'Not more than 15 Tech appointments can be created at a time.';                                               
        const ValidityMsg_noOfBayAppointment15 = 'Not more than 15 Bay appointments can be created at a time.';  
        const ValidityMsg_noOfAppointment0 = 'Atleast one appointment needs to be created at a time';                                               
       
                                                       
        if(!noOfTechAppointment && !noOfBayAppointment){
            this.reportValidity(component,'noOfTechAppointment', ValidityMsg_noOfTechAppointment);
            this.reportValidity(component,'noOfBayAppointment', ValidityMsg_noOfBayAppointment);
            return false;
        }
       else if(noOfTechAppointment && noOfTechAppointment == 0){
            this.reportValidity(component,'noOfTechAppointment', ValidityMsg_noOfAppointment0);
            return false;
        } 
        else if(noOfBayAppointment && noOfBayAppointment == 0){
            this.reportValidity(component,'noOfBayAppointment', ValidityMsg_noOfAppointment0);
            return false;
        }
         else {
            if(noOfTechAppointment){
                if(noOfTechAppointment > 15){
                    this.reportValidity(component,'noOfTechAppointment', ValidityMsg_noOfTechAppointment15);
                    return false;
                }
                if(!techDuration || techDuration <= 0){
                    this.reportValidity(component,'techDuration', ValidityMsg_techDuration);
                    return false;
                }
            }else{
                if(techDuration || techDuration > 0){
                    this.reportValidity(component,'noOfTechAppointment', ValidityMsg_noOfTechAppointment);
                    return false;
                }
            }
            
            if(noOfBayAppointment){
                if(noOfBayAppointment > 15){
                    this.reportValidity(component,'noOfBayAppointment', ValidityMsg_noOfBayAppointment15);
                    return false;
                }
                if(!bayDuration || bayDuration <= 0){
                    this.reportValidity(component,'bayDuration', ValidityMsg_bayDuration);
                    return false;
                }
            }else {
                if(bayDuration || bayDuration > 0){
                    this.reportValidity(component,'noOfBayAppointment', ValidityMsg_noOfBayAppointment);
                    return false;
                }
            }
        }
        return true;
    },
    
    reportValidity: function(component, inputCmpName, validationMsg) {
        var inputCmp = component.find(inputCmpName);
        if(inputCmp){
            inputCmp.setCustomValidity(validationMsg);
            inputCmp.reportValidity();
        }
    },
    
    clearValidity: function(component, inputCmpNameList) {
        if(inputCmpNameList && inputCmpNameList.length > 0){
            for(var i=0; i<inputCmpNameList.length; i++ ){
                var inputCmp = component.find(inputCmpNameList[i]);
                if(inputCmp){
                    inputCmp.setCustomValidity("");
                    inputCmp.reportValidity();
                }
            }
        }
    },
    
    createAppointments: function(component, event, helper) {
        component.set("v.isLoading",true);
        var inputParamsWrap = {};
        inputParamsWrap['serviceOrderId'] = component.get("v.recordId");
        inputParamsWrap['techAppointments'] = component.get("v.noOfTechAppointment") ? component.get("v.noOfTechAppointment") : 0;
        inputParamsWrap['techDuration'] = component.get("v.techDuration") ? component.get("v.techDuration") : 0;
        inputParamsWrap['bayAppointments'] = component.get("v.noOfBayAppointment") ? component.get("v.noOfBayAppointment") : 0;
        inputParamsWrap['bayDuration'] = component.get("v.bayDuration") ? component.get("v.bayDuration") : 0;
        inputParamsWrap = JSON.stringify(inputParamsWrap);
        
        var action = component.get("c.CreateServiceAppointment");
        action.setParams({
            "inputParams": inputParamsWrap
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.isLoading",false);
                var result = response.getReturnValue();
                
                var type='success';
                var msg='Service Appointment created successfully!';
                var title='Success';
                this.showToast(title,type,msg);
                $A.get('e.force:refreshView').fire();
                
           }else if (state === "ERROR"){
                let errors = response.getError();
                let message = 'Unknown error';
                component.set("v.isLoading",false);
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                var type='Error';
                var title='Warning';
                this.showToast(title,type,message);
            }         
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(title,type,msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": msg,
            "type":type
        });
        toastEvent.fire();
    }
    
})