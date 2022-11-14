({
    
    //added by Sriprada
    getSolutions :function(component, event, helper)
    {
        var faultID = event.target.getAttribute("data-id");
        // console.log('Falutid  ==  '+faultID);
        // var woId = component.get("v.recordId");
        
        helper.changeRECORDtype(component, event, faultID);
        //  helper.getknowledge(component,event);
    },  
    
    editComp : function(component, event, helper) {
        var workOrderId = component.get("v.workOrderId");
        var ctarget = event.currentTarget;
        var solId = ctarget.dataset.value;
        // var faultID = event.target.getAttribute("data-id");
        // component.set("v.faultId",faultID);
        helper.editCompHelper(component, event, solId);
        
    }
})