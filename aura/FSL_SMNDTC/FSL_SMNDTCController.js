({
    doInit : function(component, event, helper) {
        
        helper.checkForAssetData(component, event, helper);
        //execute callApexMethod() again after 5 sec each
       // window.setInterval(helper.checkForAssetData(component, event, helper),5000,);
        //execute again after 5 sec each
        /* window.setInterval(
           $A.getCallback(function() { 
                helper.checkForAssetData(component, event, helper);
            }), 8000 
        );  */
    },
     refreshPage : function(component, event, helper) {
         $A.get('e.force:refreshView').fire();
     }
})