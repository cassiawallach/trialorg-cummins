({
    checkCompatibility : function(component, event, helper) {
        //get current object
        //var objectName = component.get("v.sObjectName");
        var objectName = 'CSS_Solution_Component__c';
        component.set("v.modifiedObjectName", objectName);
        console.log('Inside Check Compatibility');
        //Check is object name is not undefined/null
        if(objectName) {
            //Get channel name for change event
            var channelName = helper.getChannelName(objectName);
            console.log('channelName::'+channelName);
            //Check if channel name is not null or undefined
            if(channelName) {
                component.set("v.channelName", channelName);
                //setting supported varibale true
                component.set("v.isSupported", true);
            } else {
                //Object does not support change event
                component.set("v.isSupported", false);
            }
        } else {
            //Object name is undefined or null, hence component will not support this page
            component.set("v.isSupported", false);
        }
        helper.getAvlFAs(component, event, helper);
    },
    
    /**
     * Handling the message when change event is fired.
     * */
    handleMessage : function(component, event, helper) {
        console.log('Inside handlemessage');
        const message = event.getParam('recordData');
        const eventType = message.payload.ChangeEventHeader.changeType;
        const entityName = message.payload.ChangeEventHeader.entityName;
        const fieldsChanged = message.payload.ChangeEventHeader.changedFields; 
        const userId = message.payload.ChangeEventHeader.commitUser.substring(0,15); //15 digit id of transaction commit user
        const signedInUser= $A.get("$SObjectType.CurrentUser.Id").substring(0,15); //15 digit id of logged in user
        var changeMatch = 'LastModifiedDate'; //FSL_FA_Service_Order__c
        var checkCustField = fieldsChanged.indexOf(changeMatch);
        console.log('Field Mismatch is '+checkCustField);
        /**
         * Conditions:
         * - Change Type should not be create
         * - Record Id must present in modified recordIds
         * - User who modified the record should not be logged in user
         * */
        //if(!(eventType === "CREATE")) {
            //Condition 1 - Change type is not "created"
            Array.from(message.payload.ChangeEventHeader.recordIds).forEach( recordId => {
                //if(recordId === component.get("v.recordId")){ //&& !(signedInUser === userId)
                    //Condition 2 - Record Id match found &&
                    //Condition 3 - commit user is not logged in user
                
                    //Display console log with changed values
                    console.log(`${eventType} event captured on ${entityName} by user id ${userId}`);
        			console.log('fieldsChanged are--'+fieldsChanged);
                    console.log("Values changed are:"+message.payload);
                    /*for(k in message.payload){
                        if(k){
                            console.log('Field Names--'+`Field Name: ${k} | New Value:${message.payload[k]}`);
                        }
                    }*/
        			var objectNameChanged = component.get("v.modifiedObjectName");
                	console.log('objectNameChanged--'+objectNameChanged);
        			if(objectNameChanged == 'CSS_Solution_Component__c'){
                        //Now call helper function to get user name and display toast
                        helper.getUser(component, userId, eventType, entityName);
        			}
            	//}
        	});
        //}
    }, 
                doInit: function(component, event, helper){
                  //  alert(component.get("v.recordId"));
                    var Caseid = component.get("v.simpleRecord.CaseId");
                    var action = component.get("c.totalCommunications");
                    action.setParams({"RecordID": component.get("v.recordId") });
                    action.setCallback(this,function(response){
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            component.set("v.TotalCommunicationsCount",response.getReturnValue());
                        } 
                        else {
                            console.log(state);
                        }
                     });       
                    $A.enqueueAction(action);     
                  /*  var action = component.get("c.updatetotalCommunications");
                    action.setCallback(this,function(response){
                        var state = response.getState();
                        if (state === "SUCCESS") {
                           // component.set("v.TotalCommunicationsCount",response.getReturnValue());
                        } 
                        else {
                            console.log(state);
                        }
                     });       
                    $A.enqueueAction(action); */
                }
})