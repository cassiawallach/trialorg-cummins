({
    
    checkCompatibility : function(component, event, helper){
        var objectName = component.get("v.sObjectName");
        if(objectName){
            var channel = helper.getChannelName(component, event, helper, objectName);
            if(channel){
                component.set("v.channel", channel);
                component.set("v.isSupported", true);
            } else{
                component.set("v.isSupported", false);
            } 
        } else{
            component.set("v.isSupported", false);
        }
    },
    
    getChannelName : function(component, event, helper, objectName) {
        var isSupported = false;
        var channel = '/data/';
        //If it is custom object, then it is supported
        if(objectName.includes("__c")){
            objectName = objectName.slice(0, -3);
            channel += objectName + "__ChangeEvent";
            isSupported = true;
        }else {//Standard Object
            var supportedStandardObject = component.get("v.supportedStandardObject");
            if(supportedStandardObject && supportedStandardObject.includes(objectName)){
                supportedStandardObject.forEach(obj => {
                    if(obj.toLowerCase().indexOf(objectName.toLowerCase()) != -1){
                    channel += objectName + "ChangeEvent";
                    isSupported = true;
                } 
                                                });
            }            
        }
        if(isSupported){
            return channel;
        } else{
            return null;
        } 
    },
    
    receiveNotification: function (component, event, helper) {
        component.set('v.subscription', null);
        component.set('v.notifications', []);
        
        const empApi = component.find('empApi');
        // Define an error handler function that prints the error to the console.
        const errorHandler = function (message) {
            console.error('Received error ', JSON.stringify(message));
        };
        // Register empApi error listener and pass in the error handler function.
        empApi.onError($A.getCallback(errorHandler));
        this.subscribe(component, event, helper);
        //helper.displayToast(component, 'success', 'Ready to receive notifications.');
    },
    
    subscribe: function (component, event, helper) {
        const empApi = component.find('empApi');
        const channel = component.get('v.channel');
        const replayId = -1;
        
        const callback = function (message) {
            helper.handleMessage(component, event, helper, message);
        };
        empApi.onError(function(error){
            console.log("Received error ", error);
        });
        // Subscribe to the channel and save the returned subscription object.
        empApi.subscribe(channel, replayId, $A.getCallback(callback)).then($A.getCallback(function (newSubscription) {
            console.log('Subscribed to channel ' + channel);
            component.set('v.subscription', newSubscription);
        }));
        
    },
    
    unsubscribe: function (component, event, helper) {
        const empApi = component.find('empApi');
        const channel = component.get('v.subscription').channel;
        const callback = function (message) {
            console.log('Unsubscribed from channel ' + message.channel);
        };
        // Unsubscribe from the channel using the subscription object.
        empApi.unsubscribe(component.get('v.subscription'), $A.getCallback(callback));
    },
    
    // Displays the given toast message.
    displayToast: function (component, type, message) {
        const toastEvent = $A.get('e.force:showToast');
        if(toastEvent){
            toastEvent.setParams({
                type: type,
                message: message
            });
            toastEvent.fire();
        }
    },
    
    
    handleMessage : function(component, event, helper, message) {
        const data = message.data;
        Array.from(data.payload.ChangeEventHeader.recordIds).forEach( recordId => {
            helper.notifyParent(component, event, helper, data);
        });
        },
            
            notifyParent : function(component, event, helper, data) {
                const record = data.payload;
                const eventType = data.payload.ChangeEventHeader.changeType;
                const entityName = data.payload.ChangeEventHeader.entityName;
                const changedFields = data.payload.ChangeEventHeader.changedFields;
                const recordIds = data.payload.ChangeEventHeader.recordIds;
                const userId = data.payload.ChangeEventHeader.commitUser.substring(0,15);
                const signedInUser= $A.get("$SObjectType.CurrentUser.Id").substring(0,15);
                
                //Fire the component event to notify parent component
                var RecordsChangeEvent = component.getEvent("FSL_RecordsChangeEvent");
                
                if(RecordsChangeEvent) {
                    
                    RecordsChangeEvent.setParams({"messageData": data,
                                                  "record": record,
                                                  "eventType": eventType,
                                                  "entityName": entityName,
                                                  "changedFields": changedFields,
                                                  "recordIds": recordIds,
                                                  "userId":userId});
                    RecordsChangeEvent.fire();  
                }
            }
        })