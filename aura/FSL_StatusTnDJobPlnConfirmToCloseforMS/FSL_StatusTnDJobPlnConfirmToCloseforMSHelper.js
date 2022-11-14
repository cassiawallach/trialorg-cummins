({
	getRepairRespList : function(component, event, helper) {
		var action  = component.get("c.getRepairRespLOVs");
       action.setCallback(this,function(response){
           if (response.getState() === 'SUCCESS') {
               component.set("v.repairRespList",response.getReturnValue());
           }
       });
       $A.enqueueAction(action);
	},
    getSolnDetailsHelper : function(component, event, helper) {
        console.log('entered fetch sol details');
		var action  = component.get("c.getSolnDetails");
         action.setParams({
           woId : component.get("v.recordId")
       });
       action.setCallback(this,function(response){
           //alert('fetch sol details call back status>'+response.getState() );
           if (response.getState() === 'SUCCESS') {
               component.set("v.cssSolns",response.getReturnValue());
           }
       });
       $A.enqueueAction(action);
	}
})