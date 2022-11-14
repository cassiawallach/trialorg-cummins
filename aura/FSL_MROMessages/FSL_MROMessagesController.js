({
    doInit : function(component, event, helper) {
         
         component.set("v.showSpinner", true);
        window.setTimeout(
            $A.getCallback(function() {
                //Console.log('::: Timeout expired- call now');
                helper.callMROMessage(component, event, helper);
                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.getFocusedTabInfo().then(function(response) {
                           console.log('::: working or not');
                    var focusedTabId = response.tabId;
                        workspaceAPI.refreshTab({
                        tabId: focusedTabId,
                        includeAllSubtabs: true
                        });
                    })
             // helper.doInit(component, event, helper); --->Commented by RAJESH PASUPULETI and calling same method above based on CHF-1519
                component.set("v.showSpinner", false);
            }), 9000
        );
        
        
       /* 
        window.setInterval(
            $A.getCallback(function() { 
                helper.doInit(component, event, helper);
            }), 5000
        ); 
        */
    },
    
    // this function automatic call by aura:waiting event  
    //showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
      //  component.set("v.Spinner", true); 
   // },
    
    // this function automatic call by aura:doneWaiting event 
    //hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
      //  component.set("v.Spinner", false);
   // }
    
})