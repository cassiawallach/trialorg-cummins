({
    
    // function call on component Load
    doInit: function(component, event, helper) {
        console.log('in dynamica init method');
        var recsSize=[];
        recsSize = component.get("v.cssPartsList");
        console.log('recsSize::'+recsSize);
        // create a Default RowItem [Contact Instance] on first time Component Load
        // by call this helper function 
        var action = component.get("c.getWoInfo");
        action.setParams({
            "woId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
          var state = response.getState();
            console.log(state);
            if (state === "SUCCESS")
            {
                var woObj = response.getReturnValue();
                component.set("v.woType",woObj.Type__c);
            }
        });
        $A.enqueueAction(action);
        helper.createObjectData(component, event); // Anvesh added for default 10 rows to display as part of CT3-11 story
        //helper.getPartsonWorkOrder(component, event, true);   // Anvesh commented for default 10 rows               
        helper.getReplReasons(component, event);
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
                
                var action1 = component.get("c.getProfileInfo");
               
                action1.setCallback(this, function(response) {
                     
                    var state1 = response.getState();
                     
                    if(state1 == "SUCCESS" && component.isValid()){
                        console.log("successppp") ;
                        var result = response.getReturnValue();
                        console.log(result);
                        console.log(result.Name);
                        if(result.Name == 'EVL_Dealer_Advanced' || result.Name == 'EVL_Dealer_Technician' || result.Name == 'EVL_Dealer_Readonly'){
                            component.set("v.ProfileCheck", false);
                            
                        }else{
                            component.set("v.ProfileCheck", true);
                        }
                        
                    }else{
                        console.error("fail:" + response.getError()[0].message); 
                    }
                    
                });
                $A.enqueueAction(action1);
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
                        // if response   if success then reset/blank the 'contactList' Attribute 
                        // and call the common helper method for create a default Object Data to Contact List 
                        component.set("v.contactList", []);
                        //helper.createObjectData(component, event);
                        component.set("v.isOpen", false);                        
                        resultsToast.setParams ({
                            "type": "Success",
                            "message": $A.get("$Label.c.Parts_are_added_to_the_Service_Order")

                        });
                        
                        resultsToast.fire();
                        component.set("v.saveInProgress",false);
                        helper.getPartsonWorkOrder(component, event, false);   
                        
                        var profilecheck = component.get("v.ProfileCheck");
                        //Sruthi Mudireddy CT1-728 (7/30/2021)-- Adding condition for parts not to refresh during T&D
                        //Priyanka VGRS2-15
                        if((profilecheck  && (component.get("v.roleName") !="Factory" && !component.get("v.isTroubleShoot")) ) || (!profilecheck && !component.get("v.isTroubleShoot"))){ // added by karthik G  to check for dealer's not to navigate Ct1-183
                            $A.get('e.force:refreshView').fire(); //Harsha Ragam for bug CT3-97 to update list view on user requested parts
                        }
                        console.log('save success222');
                        //component.getEvent("ReloadCustPartsEvt").fire(); 
                        //location.reload();
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
        
        //helper.createObjectData(component, event);
        helper.getPartsList(component, event);
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
                         "message": "Parts are removed from the Service Order"
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
        var AllRowsList=[];
        AllRowsList = component.get("v.cssPartsList");
        var templist=AllRowsList;
        var indxElm;
        console.log('current length>>'+AllRowsList.length);
        console.log('Current Lemgth>>');
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
    },
    reloadCustParts: function(component, event, helper) {
        console.log('fired on change of related list');
        component.set("v.cssPartsList", component.get("v.reloadedPartsList"));
    },
    refreshScreenData: function(component, event, helper) {
        helper.getPartsonWorkOrder(component, event, false);         
    },
    sortQuantity: function(component, event, helper) {
        component.set("v.selectedTabsoft", 'Quantity__c');
        // call the helper function with pass sortField Name   
        helper.sortHelper(component, event, 'Quantity__c');
    },
    sortpart: function(component, event, helper) {
        component.set("v.selectedTabsoft", 'Part_Number__c');
        // call the helper function with pass sortField Name   
        helper.sortHelper(component, event, 'Part_Number__c');
    },
     sortpart: function(component, event, helper) {
        component.set("v.selectedTabsoft", 'Part_Number__c');
        // call the helper function with pass sortField Name   
        helper.sortHelper(component, event, 'Part_Number__c');
    },
    sortName: function(component, event, helper) {
        component.set("v.selectedTabsoft", 'Name');
        // call the helper function with pass sortField Name   
        helper.sortHelper(component, event, 'Name');
    },
    sortReplacement: function(component, event, helper) {
        component.set("v.selectedTabsoft", 'Replacement_Reason__c');
        // call the helper function with pass sortField Name   
        helper.sortHelper(component, event, 'Replacement_Reason__c');
    },
    sortnotes: function(component, event, helper) {
        component.set("v.selectedTabsoft", 'Notes__c');
        // call the helper function with pass sortField Name   
        helper.sortHelper(component, event, 'Notes__c');
    },
    
    
})