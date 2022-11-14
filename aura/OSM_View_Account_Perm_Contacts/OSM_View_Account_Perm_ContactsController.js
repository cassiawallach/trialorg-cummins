({
    doInit : function(component,event,helper) {
        var action= component.get("c.getPermContacts");
        action.setParams({
            "accountId":component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state= response.getState();
            console.log('response %o',response.getReturnValue());
            console.log('response state %o',state);
            //   $A.log(response);
            if(state == "SUCCESS"){
                component.set("v.Contacts",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    viewRecord : function(component, event, helper) {
        var navEvent = $A.get("e.force:navigateToSObject");
        var idx = event.target.getAttribute('data-index');
        var contact = component.get("v.Contacts")[idx];
        if(navEvent){
            navEvent.setParams({
                 recordId: contact.Id,
                 slideDevName: "detail"
            });
            navEvent.fire(); 
        }

   },
   navigateToRecord : function(component, event, helper) {
       var recordId = event.getParam("recordId");
       window.location.href = '/one/one.app#/sObject/'+recordId+'/view';
   },
})