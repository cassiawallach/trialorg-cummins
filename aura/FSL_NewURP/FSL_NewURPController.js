({
    
    // function call on component Load
    doInit: function(component, event, helper) {
        console.log('in dynamica init method');
        var recsSize=[];
        recsSize = component.get("v.cssPartsList");
        console.log('recsSize::'+recsSize);
        // create a Default RowItem [Contact Instance] on first time Component Load
        // by call this helper function 
        helper.createObjectData(component, event); // Anvesh added for default 10 rows to display as part of CT3-11 story
        //helper.getPartsonWorkOrder(component, event, true);   // Anvesh commented for default 10 rows from cretaeobjectdata      
        helper.getReplReasons(component, event);
        
        //  Anvesh Added as part of CT3-11 Story
        //  Below code is to get the parent record Id from overrideAction component
        var pageRef = component.get("v.pageReference");
        var state = pageRef.state; // state holds any query params
        var base64Context = state.inContextOfRef;
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));
        console.log('addressableContext ' + addressableContext);
        component.set("v.recordId", addressableContext.attributes.recordId);
    },
    
    // function for save the Records 
    Save: function(component, event, helper) {
        // first call the helper function in if block which will return true or false.
        // this helper function check the "first Name" will not be blank on each row.
        console.log('save success & save in progress flag::'+component.get("v.saveInProgress")+':have valid data::'+helper.validateRequired(component, event));
        //if(component.get("v.saveInProgress") == false)
        {
            component.set("v.showSpinner",true);
            component.set("v.saveInProgress",true);
            if (helper.validateRequired(component, event)) {
                // call the apex class method for save the Contact List
                // with pass the contact List attribute to method param.  
                var resultsToast = $A.get("e.force:showToast");
                var recsToSaveA = [];
                recsToSaveA = component.get("v.cssPartsList");
                console.log('recsToSaveA ::'+recsToSaveA.length);
                console.log('work order id::'+component.get("v.recordId"));
                
                var action = component.get("c.saveParts");
                action.setParams({
                    "partsToInsrt": component.get("v.cssPartsList"),
                    "woId" : component.get("v.recordId")
                });
                // set call back 
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    console.log('save method called - Status:'+state)
                    if (state === "SUCCESS") {
                        console.log('save success');
                        // if response if success then reset/blank the 'contactList' Attribute 
                        // and call the common helper method for create a default Object Data to Contact List 
                        component.set("v.contactList", []);
                        //helper.createObjectData(component, event);
                        component.set("v.isOpen", false);                        
                        resultsToast.setParams ({
                            "type": "Success",
                            "message": "Custom Parts are added to the Service Order"
                        });
                        
                        resultsToast.fire();
                        component.set("v.saveInProgress",false);
                        helper.getPartsonWorkOrder(component, event, false);    
                        //$A.get('e.force:refreshView').fire();
                        console.log('save success222');
                        
                        //   Anvesh Added below code as part of CT3-11 Story
                        component.find("navService").navigate({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId : component.get("v.recordId"), 
                                actionName: 'view',  //Valid values include clone, edit, and view.
                                objectApiName: 'WorkOrder' //The API name of the record’s object
                            }}, true) 
                        
                    }
                    //component.set("v.showSpinner",false);
                });
                // enqueue the server side action  
                $A.enqueueAction(action);
            }
        }
    },
    
    // function for create new object Row in Contact List 
    addNewRow: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event);
    },
    
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.cssPartsList");//contactList");
        var partsToDel = component.get("v.cssPartsToDel");
        console.log('size before	 adding element to list>>'+partsToDel.length);
        partsToDel.push(AllRowsList[index]);
        component.set("v.cssPartsToDel",partsToDel);
        console.log('size after adding element to list>>'+partsToDel.length);
        var action2 = component.get("c.deleteCSSParts"); 
        action2.setParams({
            "partsToDel": component.get("v.cssPartsToDel")
        });
        action2.setCallback(this, function(response){
            var state = response.getState(); 
            console.log(state);
            if (state === "SUCCESS")
            {
                console.log(response.getReturnValue());
                var resultsToast = $A.get("e.force:showToast");
                if(response.getReturnValue() == true)
                {
                    console.log('inside delete block');
                    partsToDel=[];
                    component.set("v.cssPartsToDel",partsToDel);
                    AllRowsList.splice(index, 1);
                    component.set("v.cssPartsList", AllRowsList);
                    
                    component.set("v.listSize",AllRowsList.length);
                    //helper.getPartsonWorkOrder(component, event, false);
                    console.log('total parts size after removing element::'+AllRowsList.length);
                    resultsToast.setParams ({
                        "type": "Success",
                        "message": "Custom Parts are removed from the Service Order"
                    });
                    resultsToast.fire();
                    //location.reload();//changed by yellala vinod 5-2
                    //
                }
                else
                {
                    resultsToast.setParams ({
                        "type": "Error",
                        "title": "Error occured while deleting parts from service order.",
                        "message": "Please check with admin."
                    });
                }
            }
        });
        $A.enqueueAction(action2);        
    },
    closeModel: function(component, event, helper) {
        console.log('close modal');
        var AllRowsList=[];
        AllRowsList = component.get("v.cssPartsList");
        var templist=AllRowsList;
        var indxElm;
        console.log('current length>>'+AllRowsList.length);
        //console.log('templist>> ' +templist.length);
        for( var i=0;i<AllRowsList.length;i++)
        {
            console.log('i value>'+i+'<>'+AllRowsList[i].Service_Order__c);
            if(AllRowsList[i].Service_Order__c == '' || AllRowsList[i].Service_Order__c == undefined)
            {
                indxElm=templist.indexOf(AllRowsList[i]);
                console.log('before remove>'+templist.length);
                templist.splice(indxElm, 1);  
                console.log('after remove>'+templist.length);
                i--;
            }
        }
        component.set("v.cssPartsList", templist);
        component.set("v.listSize",templist.length);
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
        
        //   Anvesh Added below code as part of CT3-11 Story
        component.find("navService").navigate({
            type: 'standard__recordPage',
            attributes: {
                recordId : component.get("v.recordId"), 
                actionName: 'view',  //Valid values include clone, edit, and view.
                objectApiName: 'WorkOrder' //The API name of the record’s object
            }}, true) 
    },
    reloadCustParts: function(component, event, helper) {
        console.log('fired on change of related list');
        component.set("v.cssPartsList", component.get("v.reloadedPartsList"));
    },
    refreshScreenData: function(component, event, helper) {
        helper.getPartsonWorkOrder(component, event, false);         
    }
    
})