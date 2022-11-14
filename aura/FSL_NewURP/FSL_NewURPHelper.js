({
    createObjectData: function(component, event) {
        var RowItemList = component.get("v.cssPartsList");
        console.log('RowItemList::'+RowItemList);
        
        for(var i=0;i<10;i++){ //  Anvesh Added For loop as part of CT3-11 Story
         RowItemList.push({
                'sobjectType': 'FSL_Custom_Part__c',
                'Name': '',
                'Part_Number__c': '',
                'Replacement_Reason__c': '',
                'Notes__c': '',
                'Service_Order__c':''
            });
        }
        
         // console.log('newRows::'+newRows.length);
        console.log('in add parts secction::'+RowItemList.length);
        // set the updated list to attribute (contactList) again    
        component.set("v.cssPartsList", RowItemList);
        component.set("v.listSize",RowItemList.length);
    },
    // helper function for check if first Name is not null/blank on save  
    validateRequired: function(component, event) {
        var isValid = true;
         var resultsToast = $A.get("e.force:showToast");
        var cssPartsRows = component.get("v.cssPartsList");//contactList");
        console.log('cssPartsRows length :: '+cssPartsRows.length);
        if(cssPartsRows.length > 0)
        {
            for (var indexVar = 0; indexVar < cssPartsRows.length; indexVar++) {
                console.log('in for loop');
                console.log(cssPartsRows[indexVar].Name);
                //added undefined check by vinod yelala 8/27
     // if (cssPartsRows[indexVar].Part_Number__c != '' && (cssPartsRows[indexVar].Name == undefined || cssPartsRows[indexVar].Name == '')) {
            
                if (cssPartsRows[indexVar].Name == undefined || cssPartsRows[indexVar].Name == '') {
                    isValid = false;
                    resultsToast.setParams ({
                        "type": "Error",
                        "message": "Part Name field is missing"
                    });
                    resultsToast.fire();
                }
            }
        }
        else
        {
            resultsToast.setParams ({
                "type": "Error",
                "message": "No Rows is/are added to Save."
            });
            resultsToast.fire();
             isValid = false;
        }
        return isValid;
    },
    getReplReasons : function (component, event)
    {
        var action2 = component.get("c.getRepairReasonLOVs");      
        action2.setCallback(this, function(response){
            var state = response.getState(); 
            console.log(state);
            if (state === "SUCCESS")
            {
                component.set("v.repRsnLOVs",response.getReturnValue());
                console.log('repair reason picklist values::'+component.get("v.repRsnLOVs"));
            }
        });
        $A.enqueueAction(action2);
    },
    getPartsonWorkOrder : function (component, event, isInit)
    {
        var action = component.get("c.getCSSParts");
        action.setParams({
            "woId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState(); 
            console.log(state);
            var RowItemListAB = component.get("v.cssPartsList");
            console.log('size after delete performed::'+RowItemListAB.length);
            if (state === "SUCCESS")
            {
                //component.set("v.repRsnLOVs",response.getReturnValue());                
                var rowItemList=response.getReturnValue();
                console.log(response.getReturnValue()+'\n size of rows::'+rowItemList.length);
                //alert('isInit::'+isInit);
                if(rowItemList.length > 0)
                {
                    component.set("v.cssPartsList", rowItemList);
                    component.set("v.listSize",rowItemList.length);
                }
                else if(isInit == true)
                {
                    // alert('in else');
                    var RowItemListA = component.get("v.cssPartsList");
                    RowItemListA.push({
                        'sobjectType': 'FSL_Custom_Part__c',
                        'Name': '',
                        'Part_Number__c': '',
                        'Replacement_Reason__c': '',
                        'Notes__c': '',
                        'Service_Order__c':''                        
                    });
                    // set the updated list to attribute (contactList) again    
                    component.set("v.cssPartsList", RowItemListA);
                    component.set("v.listSize",RowItemListA.length);
                }
                else if(rowItemList.length == 0)
                {
                    var RowItemListA = [];
                    RowItemListA.push({
                        'sobjectType': 'FSL_Custom_Part__c',
                        'Name': '',
                        'Part_Number__c': '',
                        'Replacement_Reason__c': '',
                        'Notes__c': '',
                        'Service_Order__c':''                          
                    });
                    // set the updated list to attribute (contactList) again    
                    component.set("v.cssPartsList", RowItemListA);
                    component.set("v.listSize",RowItemListA.length);
                }
                //console.log('repair reason picklist values::'+component.get("v.repRsnLOVs"));
            }
            console.log('in gets parts on wo');
        });
        $A.enqueueAction(action);
    }
})