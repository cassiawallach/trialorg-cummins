({
   openModel: function(component, event, helper) {
       // Set isModalOpen attribute to true
       //component.set("v.isModalOpen", true);
   },
  
   closeModel: function(component, event, helper) {
       // Set isModalOpen attribute to false  
       component.set("v.isModalOpen", false);
      
   },
  
   submitDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
       var action  = component.get("c.closeWorkOrderFromIntake");
       action.setParams({
           strWorkOrderId : component.get("v.recordId"),
           stageName : component.get("v.processStatus")
           
       });
       action.setCallback(this,function(response){
           //alert('Call back status'+response.getState());
           if (response.getState() === 'SUCCESS') { 
              location.reload();
               $A.get('e.force:refreshView').fire();
           }
       });
       $A.enqueueAction(action);
       component.set("v.isModalOpen", false);
   },
})