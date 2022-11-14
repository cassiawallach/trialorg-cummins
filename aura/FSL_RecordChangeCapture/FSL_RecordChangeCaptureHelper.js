({
    /*
     * This method will call the server side action to get user name
     * Once user name retrieved, it will show a warning toast to the user
     * */
    getUser : function(component, userId, eventType, entityName) {
        /*var action = component.get("c.getUserName");
        action.setParams({
            "userId" : userId
        });*/
        //action.setCallback(this,function(response) {
        //var state = response.getState();
        //if (state === "SUCCESS") { 
        // pass returned value to callback function
        //var userName = response.getReturnValue(); 
        /*this.showToast({
                    "title":`Record ${eventType}ED`,
                    "type": "warning",
                    "message": `This record has been ${eventType}D by ${userName}`
                });*/
        
        //Auto refresh the page to get latest details if auto refresh is selected
        var autorefreshflag  = component.get("v.autoRefresh");
        console.log('auto refresh falg::'+autorefreshflag);
        if(component.get("v.autoRefresh") === "Yes") {
          //  console.log('inside auto refresh block');
            //this.assignAvlFAs(component, event , Helper); // Cmomented tis his line for refresh
            //this.getAvlFAs(component, event, helper);//--Removed the Helper argument  to troubleshott the refresh -- vinod 12-1
          //  console.log('inside function getAvlFAs');
        //call apex class method
        var action = component.get('c.getAvailableFAs');
        var wId = component.get("v.recordId");
        action.setParams({
            woId: wId
        });
        action.setCallback(this, function(response) {
            //store state of response
           // console.log('inside getavailable fs');
            var state = response.getState();
            console.log('state::'+state);
            if (state === "SUCCESS") {
                // alert(response.getReturnValue());
                component.set('v.ListOfAvailFAs', response.getReturnValue());
                this.getReqComFAs(component, event);//, helper);
               // console.log('list of fs'+component.get('v.ListOfAvailFAs'));
               
            }
        });
        $A.enqueueAction(action);
            this.autoRefresh();
            //$A.get('e.force:refreshView').fire();
        }
        /*} else if (state === "ERROR") {
                // generic error handler
                var errors = response.getError();
                if (errors) {
                    console.error("Error is getting username: ", errors);
                }
                return null;
            }*/
        //});
        //$A.enqueueAction(action);
    },
    /**
     * Get change event object name from 
     * current page's object
     * */
    getChannelName : function(objectName) {
        var isSupported = false;
        //If it is custom object, then it is supported
        if(objectName.includes("__c")){//Custom Object
            objectName = objectName.slice(0, -3); //removing __c from the end
            objectName += "__ChangeEvent"; //appending __ChangeEvent in the end of custom object
            isSupported = true;
        } 
        //check if it is one of the supported standard object from static resource
        else {//Standard Object
            //iterate over supported object list
            window.supportedObjectForChangeEvents.forEach (obj => {
                if(obj.toLowerCase().indexOf(objectName.toLowerCase()) != -1) {
                    //Match found, Object is supported
                    objectName += "ChangeEvent" //appending ChangeEvent in the end of standard object
                    isSupported = true;
               }
            });
        }
        if(isSupported === true){//is object supported, return channel name
           // console.log('Inside Object Supported');
            return `/data/${objectName}`;
        } else{//if object not supported, return null
            return null;
        }
    },
    /*
     * This function displays toast based on the parameter values passed to it
     * */
    showToast : function(params) {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        } else{
            alert(params.message);
        }
    },
    /*
     * This function is to get and set the Available Field Actions count
     * */
    getAvlFAs: function(component, event, helper) {
        console.log('inside function getAvlFAs');
        //call apex class method
        var action = component.get('c.getAvailableFAs');
        var wId = component.get("v.recordId");
        action.setParams({
            woId: wId
        });
        action.setCallback(this, function(response) {
            //store state of response
            console.log('inside getavailable fs');
            var state = response.getState();
            console.log('state::'+state);
            if (state === "SUCCESS") {
                // alert(response.getReturnValue());
                component.set('v.ListOfAvailFAs', response.getReturnValue());
                this.getReqComFAs(component, event, helper);
              //  console.log('list of fs'+component.get('v.ListOfAvailFAs'));
            }
        });
        $A.enqueueAction(action);
    },
    
   
    /*
     * This function is to get and set the Required to Complete Field Actions count
     * */
    getReqComFAs: function(component, event){//, helper) {
        //call apex class method
        var action = component.get('c.getReqToCompFAs');
        var wId = component.get("v.recordId");
        action.setParams({
            woId: wId
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                // alert(response.getReturnValue());
                component.set('v.ListOfReqComFAs', response.getReturnValue());
                this.autoRefresh();
            }
        });
        $A.enqueueAction(action);
    },
    /**
     * Auto refresh the page to get latets details
     * */
    autoRefresh : function(){
      //  console.log('inside the autoRefresh function');
        //location.reload();
        var refreshEvent = $A.get('e.force:refreshView');
        if(refreshEvent){
            refreshEvent.fire();
           // console.log('Inside Auto Refresh IF');
        } else {
           // console.log('Inside Auto Refresh ELSE');
           // console.error("Auto refresh is not supported in current context");
        }
    }
})