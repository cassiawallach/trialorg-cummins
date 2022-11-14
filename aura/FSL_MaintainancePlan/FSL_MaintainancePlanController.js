({
    doInit : function(component, event, helper) { 
        helper.setRecordId(component, event, helper);
        //component.set('v.recordId',component.get("v.pageReference").state.c__mpid);
        //Mallika Changes Starts
       /*
        var pageReference = component.get("v.pageReference");
        
        const maintainenceId = pageReference.state.ws;
        //const recId = maintainenceId.substring(maintainenceId.indexOf('MaintenancePlan/')+1,maintainenceId.indexOf('MaintenancePlan/')+19);
        //alert(JSON.stringify(recId));
        var parentId = maintainenceId.replace('/lightning/r/MaintenancePlan/','');
        parentId = parentId.substring(0,18);
        //component.set('v.recordId',parentId);
        //Mallika Changes Ends
        */
        helper.Branchcode(component, event, helper);
    },
    
})