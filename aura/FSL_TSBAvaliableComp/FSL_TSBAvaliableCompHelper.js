({
    getData : function(component,helper){
        // call apex class method
        var action = component.get("c.getAccountRecords");
        action.setParams({
            "initialRows" : component.get("v.initialRows"), //how many rows to load during initialization
            "strservicejobid" : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            var toastReference = $A.get("e.force:showToast");
            if(state == "SUCCESS"){
                var TSBWrapper = response.getReturnValue();
                if(TSBWrapper.success){
                    // set total rows count from response wrapper
                    component.set("v.totalRows",TSBWrapper.totalRecords);  
                    
                    var TSBList = TSBWrapper.TSBsList;
                    // play a for each loop on list of account and set Account URL in custom 'accountName' field
                    TSBList.forEach(function(record){
                        record.linkName = record.URL__c;
                        record.Doc_Title__c = record.Doc_Num__c + ' - ' + record.Doc_Title__c;
                        
                    });
                    // set the updated response on TSBData aura attribute  
                    component.set("v.TSBData",TSBList);
                    
                }
                else{ // if any server side error, display error msg from response
                    toastReference.setParams({
                        "type" : "Error",
                        "title" : "Error",
                        "message" : accountWrapper.message,
                        "mode" : "sticky"
                    }); 
                    toastReference.fire();
                }
            }
            else{ // if any callback error, display error msg
                toastReference.setParams({
                    "type" : "Error",
                    "title" : "Error",
                    "message" : 'An error occurred during Initialization '+state,
                    "mode" : "sticky"
                });
                toastReference.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    loadData : function(component){
        return new Promise($A.getCallback(function(resolve){
            var limit = component.get("v.initialRows");
            var offset = component.get("v.currentCount");
            var totalRows = component.get("v.totalRows");
            if(limit + offset > totalRows){
                limit = totalRows - offset;
            }
            var action = component.get("c.loadAccountRecords");
            action.setParams({
                "rowLimit" :  limit,
                "rowOffset" : offset,
                "strservicejobid" : component.get("v.recordId")
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                var newData = response.getReturnValue();
                // play a for each loop on list of new accounts and set Account URL in custom 'accountName' field
                newData.forEach(function(record){
                    
                    record.linkName = record.URL__c; //CT3-134
                    record.Doc_Title__c = record.Doc_Num__c + ' - ' + record.Doc_Title__c;
                });
                resolve(newData);
                var currentCount = component.get("v.currentCount");
                currentCount += component.get("v.initialRows");
                // set the current count with number of records loaded 
                component.set("v.currentCount",currentCount);
            });
            $A.enqueueAction(action);
        }));
    },
    
    hideshowtoggle : function(component,event,secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
    
    insertviewedTSBs : function(row,component,event,helper) {
        window.open(row.FSL_URL__c);
        var action = component.get("c.TSBviewed");
        action.setParams({
            "serviceorderId" : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var TSBWrapper = response.getReturnValue();           
            }
        });
        $A.enqueueAction(action);
    }
})