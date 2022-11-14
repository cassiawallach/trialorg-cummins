({
    fetchDetails: function(component, event, helper) {
       helper.showDetails(component, event, helper);
     },
     getSolutions :function(component, event, helper)
    {
        var faultID = event.target.getAttribute("data-id");
        console.log('Faultid  ==  '+faultID);
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