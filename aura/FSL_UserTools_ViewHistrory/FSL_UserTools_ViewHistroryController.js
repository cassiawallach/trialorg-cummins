({ 
     doInit : function(component, event, helper) {
      var onSerach =event.getParam('arguments'); 
        console.log(onSerach.fromParentSearch);
         
       //  if(onSerach.fromParentSearch || (document.URL.toLowerCase().includes("evolution")==false)){
         if(onSerach.fromParentSearch ){  
             component.set("v.showComponent", true);
              component.set("v.showSpinner", true);
         window.setTimeout(
            $A.getCallback(function() {
               component.set("v.showSpinner", false);
            }), 10000
        );
          helper.PSNSearch(component, event, helper);
         var action = component.get("c.getProfileInfo");
         action.setCallback(this, function(response) {
             var state = response.getState();
             if(state == "SUCCESS" && component.isValid()){
                 console.log("success") ;
                 var result = response.getReturnValue();
                 console.log(result);
                 console.log(result.Name);
                 component.set("v.ProfileName", result.Name);
                 if(result.Name == 'EVL_Dealer_Advanced' || result.Name == 'EVL_Dealer_Readonly' || result.Name == 'EVL_Dealer_Readonly' || result.Name == 'System Administrator'){
                     component.set("v.DealerProfile", true);
                 }else{
                      component.set("v.DealerProfile", false);
                 }
                     
             }else{
                 console.error("fail:" + response.getError()[0].message); 
             }
         });
         $A.enqueueAction(action);
       /* var urlEvent = $A.get("e.force:navigateToURL");
          console.log('kkkdoinit'+urlEvent);
        urlEvent.setParams({
            "url":"/apex/dsfs__DocuSign_CreateEnvelope"
        });
        urlEvent.fire();
 */
         }
         //Added by Rama to not show history component on change of psn
         else{
                 component.set("v.showComponent", false); 
             }
  },
    edit : function(component, event, helper) {
        
        // component.set("v.showSpinner", true);
         var editRecordEvent = $A.get("e.force:editRecord");
         editRecordEvent.setParams({
             "recordId": component.get("v.recordId")
            
         });
         
         editRecordEvent.fire();
     },
     updatePSN : function(component, event, helper) {
         let onSearch = event.getParam('arguments'); 
         if(onSearch) {
             component.set('v.parentPSN', event.getParam('arguments')['parentPSN']);
         }
  }
 })