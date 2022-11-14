({
    doInit:  function(component, event, helper){  
        var today = new Date();
        console.log('before update  '+today.toISOString());
        component.set("v.startDatetime", today.toISOString());
        
    },  
    
    previewFile : function(component, event, helper){  
        $A.get('e.lightning:openFiles').fire({ 
            recordIds: [event.currentTarget.id]
        });  
    },  
    
    uploadFinished : function(component, event, helper) { 
        
        var filesIds =  component.get("v.DocIds");
        var uploadedFiles = event.getParam("files");
        
        uploadedFiles.forEach(file =>  filesIds.push(file.documentId));
        component.set("v.DocIds", filesIds);
        
        helper.getUploadedFiles(component, event);    
        
        var toastEvent = $A.get("e.force:showToast");
        // show toast on file uploaded successfully 
        toastEvent.setParams({
            "message": "Files have been uploaded successfully!",
            "type": "success",
            "duration" : 2000
        });
        toastEvent.fire();
    }, 
    
    deleteSelectedFile : function(component, event, helper){
        if( confirm("Are you sure you want to delete this file?")){
            component.set("v.showSpinner", true); 
            helper.deleteUploadedFile(component, event);                
        }
    }, 
    itemsChange : function(component, event, helper){
        var cmpEvent = component.getEvent("sampleCmpEvent"); 
        //Set event attribute value
        cmpEvent.setParams({"Ids" : component.get("v.DocIds")}); 
        cmpEvent.fire(); 
    }, 
})