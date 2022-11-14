({
    createObjectData: function(component, event) {
        //alert('1');
        var isInit;
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
                //var rowItemList=component.get("v.cssPartsList"); 
                console.log(response.getReturnValue()+'\n size of rows::'+rowItemList.length);
                // alert('isInit::'+isInit);
                if(rowItemList.length > 0)
                {
                    component.set("v.cssPartsList", rowItemList);
                    component.set("v.listSize",rowItemList.length);
                    var noofrows = rowItemList.length;
                    noofrows = noofrows + 30;
                    //alert('Parts List Length--'+noofrows);
                    var RowItemList = component.get("v.cssPartsList"); 
                    console.log('RowItemList 1 '+RowItemList.length);
                    //if(rowItemList.length < 10){
                        //for(var i=RowItemList.length; i<10;i++){
                          for(var i=0; i<10;i++){
                            RowItemList.push({
                                'sobjectType': 'FSL_Custom_Part__c',
                                'Name': '',
                                'Part_Number__c': '',
                                'Replacement_Reason__c': '',
                                'Notes__c': '',
                                'Service_Order__c':''   
                            });
                        }
                        
                        component.set("v.cssPartsList", RowItemList);
                        component.set("v.listSize",RowItemList.length);
                    //}
                    console.log('in add parts secction::'+RowItemList.length);
                    //component.set("v.cssPartsList", rowItemList);
                    //component.set("v.listSize",rowItemList.length);
                }
                else if(isInit == true)
                {
                    alert('in Init');
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
                    console.log('in add parts secction 2 '+RowItemListA.length);
                }
                    else if(rowItemList.length == 0)
                    {
                        
                        var RowItemList = component.get("v.cssPartsList"); 
                        console.log('RowItemList 3 '+RowItemList.length);
                        //Anvesh added below code
                        for(var i=0; i<10;i++){
                            RowItemList.push({
                                'sobjectType': 'FSL_Custom_Part__c',
                                'Name': '',
                                'Part_Number__c': '',
                                'Replacement_Reason__c': '',
                                'Notes__c': '',
                                'Service_Order__c':''   
                            });
                        }
                        
                        component.set("v.cssPartsList", RowItemList);
                        component.set("v.listSize",RowItemList.length);
                        console.log('in add parts secction 3 '+RowItemList.length);
                        
                    }
                        else
                        {
                            
                            var RowItemList = component.get("v.cssPartsList"); 
                            //Anvesh added below code
                            for(var i=0; i<10;i++){
                                RowItemList.push({
                                    'sobjectType': 'FSL_Custom_Part__c',
                                    'Name': '',
                                    'Part_Number__c': '',
                                    'Replacement_Reason__c': '',
                                    'Notes__c': '',
                                    'Service_Order__c':''   
                                });
                            }
                            
                            component.set("v.cssPartsList", RowItemList);
                            component.set("v.listSize",RowItemList.length);
                            console.log('in add parts secction 4 '+RowItemList.length);
                        }
                //console.log('repair reason picklist values::'+component.get("v.repRsnLOVs"));
            }
            console.log('in gets parts on wo');
        });
        $A.enqueueAction(action);
        
        /* var RowItemList = component.get("v.cssPartsList"); 
        //Anvesh added below code
        for(var i=0; i<10;i++){
        RowItemList.push({
            'sobjectType': 'FSL_Custom_Part__c',
            'Name': '',
            'Part_Number__c': '',
            'Replacement_Reason__c': '',
            'Notes__c': '',
            'Service_Order__c':''   
        });
    }
        console.log('in add parts secction::'+RowItemList.length);
       
        component.set("v.cssPartsList", RowItemList);
        component.set("v.listSize",RowItemList.length);*/
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
                var partNo = ''; //added by Sruthi as part of VGRS2-251 02/18
                var notes = '';
                var replacementReason = '';
                if(cssPartsRows[indexVar].Part_Number__c){
                    partNo = (cssPartsRows[indexVar].Part_Number__c).trim();
                }
                if(cssPartsRows[indexVar].Notes__c){
                    notes = (cssPartsRows[indexVar].Notes__c).trim();
                }
                if(cssPartsRows[indexVar].Replacement_Reason__c){
                    replacementReason = (cssPartsRows[indexVar].Replacement_Reason__c).trim();
                }
                //added undefined check by vinod yelala 8/27
                //Modified by Devon Sumbry 11/01/2020
                if(
                    (cssPartsRows[indexVar].Name == undefined || cssPartsRows[indexVar].Name == '')                     
                    &&
                     ((cssPartsRows[indexVar].Quantity__c != undefined && cssPartsRows[indexVar].Quantity__c != '') || (notes) || (partNo) || (replacementReason && replacementReason != 'Customer Pay')))
                     {
                    isValid = false;
                    resultsToast.setParams ({
                        "type": "Error",
                        "message": "Part Name field is required "
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
                console.log(response.getReturnValue()+ rowItemList , '\n size of rows::'+rowItemList.length);
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
    },
    sortHelper: function(component, event, sortFieldName) {
        var currentDir = component.get("v.arrowDirection");
        
        if (currentDir == 'arrowdown') {
            // set the arrowDirection attribute for conditionally rendred arrow sign  
            component.set("v.arrowDirection", 'arrowup');
            // set the isAsc flag to true for sort in Assending order.  
            component.set("v.isAsc", true);
        } else {
            component.set("v.arrowDirection", 'arrowdown');
            component.set("v.isAsc", false);
        }
        // call the onLoad function for call server side method with pass sortFieldName 
        this.onLoad(component, event, sortFieldName);
    },
    onLoad: function(component, event, sortField) {
        //call apex class method
        var action = component.get('c.fetchcustompart');
        
        // pass the apex method parameters to action 
        action.setParams({
            'sortField': sortField,
            'isAsc': component.get("v.isAsc"),
            "woId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListOfContact attribute on component.
                component.set('v.cssPartsList', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    getPartsList: function(component, event) {
        var rowItemListAdd=component.get("v.cssPartsList");
        //var rowItemListSize=component.get("v.listSize");
        console.log('in add parts secction::'+rowItemListAdd.length);
        for(var i=0; i<10;i++){
            rowItemListAdd.push({
                'sobjectType': 'FSL_Custom_Part__c',
                'Name': '',
                'Part_Number__c': '',
                'Replacement_Reason__c': '',
                'Notes__c': '',
                'Service_Order__c':''   
            });
        }
                    
        component.set("v.cssPartsList", rowItemListAdd);
        component.set("v.listSize",rowItemListAdd.length);
        console.log('in add parts secction After Add'+rowItemListAdd.length);
        $A.enqueueAction(action);
    }
})