({
    doInit: function(component, event, helper) {
        component.set('v.pDuplicate', false);
        helper.doInit(component, event, helper);
        console.log('::: Record Id doInit PNew = '+component.get("v.recordId"));
        console.log(':::srtType'+component.get("v.srtType"));
        var action = component.get("c.getSRTGroupDesc");
        var groupDesc = component.find("InputGroup");
        var opts=[];
        action.setCallback(this, function(a) {
            
            var groupFields = [];
            var returnList = a.getReturnValue();
            for(var key in returnList) {
                groupFields.push({value:returnList[key], key:returnList[key]});
            }
            
            component.set("v.srtGroups", groupFields);    
            
        });
        $A.enqueueAction(action); 
    },
    
    searchSRT : function(component, event, helper){
        helper.showSpinner(component);  
        var action = component.get("c.getSRTSearchResultInsert");
        var params = {"Config" : [
            {"type" : "Access", "isChecked":document.getElementById("checkbox-47").checked ? true : false},
            {"type" : "Admin", "isChecked":document.getElementById("checkbox-48").checked ? true : false},
            {"type" : "Diagnostic", "isChecked":document.getElementById("checkbox-49").checked ? true : false},
            {"type" : "Repair", "isChecked":document.getElementById("checkbox-50").checked ? true : false}
        ]};
        var parameters = JSON.stringify(params);
        
        var searcCode = component.find("searchCode").get("v.value");
        var groupValue = component.find("groupSelect").get("v.value");
        console.log(':::Search Code = '+searcCode);
        console.log(':::groupValue = '+groupValue);
        console.log('::: Record Id = '+component.get("v.recordId"));
        action.setParams({
            "config":parameters,
            "pCode" : searcCode,
            "pGroup" : groupValue,
            "WORecordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.searchResults", response.getReturnValue()); 
                console.log('::: Search Result - '+component.get("v.searchResults"));
                helper.hideSpinner(component);
                if(!$A.util.isEmpty(component.get("v.searchResults"))){ 
                    if(component.get("v.searchResults").length > 0) {
                        component.set("v.pRecordSelected", true);
                        component.set("v.pNoRecordsFound", false);
                        if(component.get("v.searchResults").length > 100) {
                            component.set("v.pTooManyRecordsFound", true);
                        }
                    } else {
                        component.set("v.pNoRecordsFound", true);
                        component.set("v.pRecordSelected", false);
                        component.set("v.pTooManyRecordsFound", false);
                    }
                } else {
                    component.set("v.pNoRecordsFound", true);
                    component.set("v.pTooManyRecordsFound", false);
                }
            } else {
                console.log('::: Error in fetching SRT Details');
            }
        });
        $A.enqueueAction(action); 
    },
    
    AddSelectedSRT: function(component, event, helper){
        
    },
    
    addSelectedSRT: function(component, event, helper) {
        var recId = component.get("v.recordId");
        var selectedRecords = [];
        var selectedCodes = 'SRTs (';//NIN-7
        component.set('v.pDuplicate', false);
        // Check Save SRT Codes
        var addedRecordNames = [];
        var savedList = component.get('v.savedSRTs');
        for(var i=0; i<savedList.length; i++) {
            addedRecordNames.push(savedList[i].Name);
        }
        
        var addedRcords = (component.get("v.AddedResults")) ? component.get("v.AddedResults") : [];
        
        for(var r = 0; r < addedRcords.length; r++) {
            addedRecordNames.push(addedRcords[r].Name);
        }
        
        
        console.log(':::Added Records - '+addedRcords);
        var checkvalue = component.find("checkSRT");
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedRecords.push(checkvalue.get("v.text"));
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedRecords.push(checkvalue[i].get("v.text"));
                }
            }
        }
        
        // NIN-7 Start
        var srtCodes = new Array();
        for (var q= 0 ; q < selectedRecords.length ; q++){
            srtCodes.push(selectedRecords[q].Name);
        }
        
        var srtJSON = JSON.stringify(srtCodes);
        console.log('srtJSON--'+srtJSON);
        
        var action = component.get('c.findDuplicateSRT');
		action.setParams({
            "srtCodes" : srtJSON,
            "soId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                
                //dupSRTs = response.getReturnValue();
                component.set("v.duplicateSRTs", response.getReturnValue());
                var dupSRTs = component.get("v.duplicateSRTs");
                console.log('dupSRTs--'+dupSRTs);
                
                for(var i=0; i<dupSRTs.length; i++) {
                    console.log('dupSRT Value--'+dupSRTs[i].Name);
                    component.set('v.pDuplicate', true);
                	selectedCodes = selectedCodes.concat(dupSRTs[i].Name+', ');                    
                    console.log('selectedCodes dup--'+selectedCodes);
                }
                
                component.set('v.pDuplicateMsg', selectedCodes+') have already been applied. Please confirm that the additional quantity is needed.');
                
                /*for(var key in dupSRTs) {
                    console.log('dupSRT Value--'+dupSRTs[key]);
                    component.set('v.pDuplicate', true);
                	selectedCodes = selectedCodes.concat(dupSRTs[key]+', ');
                    //groupFields.push({value:returnList[key], key:returnList[key]});
                }*/
                
                /*for(var k=0; k < dupSRTs.length; k++) {
                	component.set('v.pDuplicate', true);
                	selectedCodes = selectedCodes.concat(dupSRTs[k].Name+', ');
                }*/
            }
        }); 
        $A.enqueueAction(action);
        // NIN-7 End
        
       /* var codeList = ['19-361-00', '19-360-00', '19-052-00', '19-710-00', '00-140-00', '19-053-00', '17-004-00', '19-0FZ-00', '19-0FV-00', '19-0FY-00', '99-901-00', '99-902-00', '99-903-00', '17-902-00', '17-901-00'];
        var selectedCodes = 'SRTs (';
        for(var j=0; j< selectedRecords.length; j++) {
            if(addedRecordNames.includes(selectedRecords[j].Name) && !codeList.includes(selectedRecords[j].Name)) {
                component.set('v.pDuplicate', true);
                //component.set('v.pDuplicateMsg', 'Code selected - '+selectedRecords[j].Name+' is already added');
                selectedCodes = selectedCodes.concat(selectedRecords[j].Name+', ')
            }
        }*/
        
        console.log('selectedCodes dup111--'+selectedCodes);
        //component.set('v.pDuplicateMsg', selectedCodes+') have already been applied. Please confirm that the additional quantity is needed.');
        
        console.log(':::selectedRecords - '+selectedRecords);
        addedRcords = addedRcords.concat(selectedRecords);
        
        const result = [];        
        const map = new Map();
        
        for (const item of addedRcords) {
            //if(!map.has(item.Name)){
            map.set(item.Name, true);
            result.push({
                Name: item.Name,
                SRT_Type__c: item.SRT_Type__c,
                SRT_DESCRIPTION__c: item.SRT_DESCRIPTION__c,
                Access_Code_A__c:item. Access_Code_A__c,
                Access_Code_B__c:item. Access_Code_B__c,
                Access_Code_C__c:item. Access_Code_C__c,
                Access_Code_D__c:item. Access_Code_D__c,
                Access_Code_R__c:item. Access_Code_R__c,
                Equipment_Id__c:item.Equipment_Id__c,
                StepId__c :item.StepId__c
            });
            //}
        }
        
        console.log(':::result = '+JSON.stringify(result));
        component.set("v.AddedResults", result);
        
        component.set("v.pRecordAdded", true);
        
        
        for (var i = 0; i < checkvalue.length; i++) {
            if (checkvalue[i].get("v.value") == true) {
                checkvalue[i].set("v.value", false);
            }
        }
    },
    
    removeRow: function(component, event, helper) {
        var SRTList = component.get("v.AddedResults");
        var index = event.currentTarget.dataset.rowIndex;
        SRTList.splice(index, 1);
        component.set("v.AddedResults", SRTList);
        console.log(index);
    },
    
    accessChanged: function(component, event) {
        component.set("v.AccessCheck", document.getElementById("checkbox-47").checked );
        component.set("v.AdminCheck", document.getElementById("checkbox-48").checked );
        component.set("v.DiagnosticCheck", document.getElementById("checkbox-49").checked );
        component.set("v.RepairCheck", document.getElementById("checkbox-50").checked );
    },
    
    handleModalPopup : function(component, event, helper) {
        component.set("v.isModalOpen",true);
    },
    
    closeModal: function(component, event, helper) {
        /*component.find("searchCode").set("v.value", null);
		component.find("groupSelect").set("v.value", null);
        component.set("v.searchResults", null);
        component.set("v.pRecordSelected", false);
        component.set("v.AddedResults", null);
        component.set("v.pRecordAdded", false); 
        component.set("v.isModalOpen", false);
        component.set("v.AccessCheck", true );
        component.set("v.AdminCheck", true );
        component.set("v.DiagnosticCheck", true );
        component.set("v.RepairCheck", true );
        component.set("v.pTooManyRecordsFound", false);
        component.set("v.pNoRecordsFound", false);*/
        helper.closemodalhelper(component, event, helper);
    },
    saveSRTs: function(component, event, helper) {
        console.log('added rows');
        console.log(component.get("v.AddedResults"));
        //Added by Mallika
        helper.saveSRTRec(component, event, helper);
    }
})