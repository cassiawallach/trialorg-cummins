({  
    getUploadedFiles : function(component, event){
        var idListJSON=JSON.stringify(component.get("v.DocIds"));
        var action = component.get("c.getFiles");  
        action.setParams({  
            "recordId": component.get("v.recordId"),
            "DocIds1": idListJSON,
           "createddate":component.get("v.startDatetime")
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var docids = [];
                console.log('DocuIds  -- '+JSON.stringify(response.getReturnValue()));
                var result = response.getReturnValue();           
                component.set("v.files",result); 
                result.forEach(record => docids.push(record.Id));
                component.set("v.Ids",docids); 
            }  
        });  
        $A.enqueueAction(action); 
    },
    
    deleteUploadedFile : function(component, event) {  
        var action = component.get("c.deleteFile");    
        action.setParams({
            "contentDocumentId": event.currentTarget.id            
        });  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                this.getUploadedFiles(component);
                component.set("v.showSpinner", false); 
                // show toast on file deleted successfully
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": "File has been deleted successfully!",
                    "type": "success",
                    "duration" : 2000
                });
                toastEvent.fire();
            }  
        });  
        $A.enqueueAction(action);  
    },  
})