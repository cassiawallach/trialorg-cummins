({
    sendMail: function(component, event, helper) {
        var getEmail = component.get("v.Email");
        var getccEmail = component.get("v.ccEmail");
        var getSubject = component.get("v.subject");
        var getbody = component.get("v.bodytext")+ component.get("v.CasethreadId");
        var getrecid = component.get("v.recordId");
        var docIds = component.get("v.Ids");
        var mailBody = getbody
        
        // check if Email field is Empty or not contains @ so display a alert message 
        // otherwise call call and pass the fields value to helper method    
        if ($A.util.isEmpty(getEmail) || !getEmail.includes("@")) {
            alert('Please Enter valid Email Address');
        } else {
            component.set('v.isButtonActive',true);
            helper.sendHelper(component, event, helper,getEmail,getccEmail, getSubject, getbody,getrecid, docIds );
        }
    },
    
    // when user click on the close buttton on message popup ,
    closeMessage: function(component, event, helper) {
        component.set("v.mailStatus", false);
        component.set("v.Email", null);
        component.set("v.ccEmail", null);
        component.set("v.subject", null);
        component.set("v.bodytext", null);
        component.set("v.Ids", null);
        component.set("v.buttonClicked", false);
    },
    
    handleClick: function(component, event, helper) {
        component.set("v.buttonClicked", true);
        component.set('v.isButtonActive',false);
    },
    
    closeModal: function(component, event, helper) {
        component.set("v.buttonClicked", false);
        component.set("v.bodytext", null);
       // $A.get('e.force:refreshView').fire();
    },
    
    handleUploadFinished: function(component, event, helper) {
        //Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        console.log('uploadedFiles====== '+JSON.stringify(uploadedFiles));
        //Show success message – with no of files uploaded
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type" : "success",
            "message": uploadedFiles.length+" files has been uploaded successfully!"
        });
        toastEvent.fire();
        
        $A.get('e.force:refreshView').fire();
        
        //Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        var existingrecords = component.get("v.Ids");
        
        var listofIds = [];
        for(var i = 0; i < uploadedFiles.length; i++ ){
            listofIds.push(uploadedFiles[i].documentId);
        }
        // alert('existingrecords==== '+existingrecords);
        if(existingrecords  != '' && existingrecords  != undefined){
            var finalDocIds = listofIds.concat(existingrecords);
            component.set("v.Ids", finalDocIds);
        }
        else{
            component.set("v.Ids", listofIds);
        }
        
    },
    
    doInit: function(component, event, helper) {
        var action1 = component.get("c.getCaseThreadID");
        action1.setParams({
            'ServiceOrderId': component.get('v.recordId')
        });
        
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.CasethreadId",response.getReturnValue() );
            }
            else {
              
            } 
        });
        $A.enqueueAction(action1);
    },
    
   parentComponentEvent : function(component, event) { 
        //Get the event message attribute
        var message = event.getParam("Ids"); 
        component.set("v.Ids", message);         
    }  
    
    
    
})