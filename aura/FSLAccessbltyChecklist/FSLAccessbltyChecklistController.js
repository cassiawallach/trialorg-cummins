({
    
    doInit: function(component, event, helper)
    {
        var accSrtCheck;
        console.log('accessibilitySRT init ');
        //helper.getColumnHeaders(component, event);
        //helper.getSRTsHelper(component, event);
        var solId = component.get("v.cssSolId"); 
        var action = component.get("c.getAccSRTCheck");
        action.setParams({
            "solId": solId
        });

        action.setCallback(this, function(response){
        var state = response.getState();
        if (component.isValid() && state === "SUCCESS") {
            accSrtCheck = response.getReturnValue();
            //component.set("v.position", accSrtCheck);
            console.log('accSrtCheck**'+accSrtCheck.No_Access_SRT_required__c);
            component.find("checkbox").set("v.value",accSrtCheck.No_Access_SRT_required__c);
            //component.find("checkboxdis").set("v.value",accSrtCheck.No_Access_SRT_required__c);
            console.log('mycheckbox**'+component.find("checkbox").get("v.value"));
            component.set("v.AccessSRTCheckbox",accSrtCheck.No_Access_SRT_required__c);
            //console.log('checkboxdis**'+component.find("checkboxdis").get("v.value"));
        }
    });
    $A.enqueueAction(action);

    
    var action_1 = component.get("c.getSRTCount");
        action_1.setParams({
            "solId": solId
        });

        action_1.setCallback(this, function(response){
        var state1 = response.getState();
        if (component.isValid() && state1 === "SUCCESS") {
            var srtCount = response.getReturnValue();
            //component.set("v.position", accSrtCheck);
            console.log('srtCount**'+srtCount);
            if(srtCount>0)
            component.set("v.disableNoAccSRT",true);
            //component.set("v.accSrtCount",srtCount);
            //component.find("checkbox").set("v.value",false);
            //console.log('mycheckboxAfterCount**'+component.find("checkbox").get("v.value"));
        }
    });
    $A.enqueueAction(action_1);
        
    },
    assignQty: function(component, event, helper) {
        var getAllId = component.find("selectCB");
        console.log('getAllId>'+getAllId);
        // If the local ID is unique[in single record case], find() returns the component. not array
        console.log(Array.isArray(getAllId));
        if(Array.isArray(getAllId))
        {
            for (var i = 0; i < getAllId.length; i++)
            {
                console.log('current qty>'+component.find("qty")[i].get("v.value"));
                if (getAllId[i].get("v.value") == true)
                {
                    if(component.find("qty")[i].get("v.value") == null || component.find("qty")[i].get("v.value") == 0)                    
                        component.find("qty")[i].set("v.value", 1);
                    console.log('inside if when is true');
                }
                else if(component.find("qty")[i].get("v.value") != null && component.find("qty")[i].get("v.value") > 0)
                    component.find("qty")[i].set("v.value", null);//assigning null on de selecting row 9/6.
                
            }
        }
        helper.saveSelectedHelper(component, event);//added by vinod 10-2
    },
    setQtyForAllRows: function(component, event, helper) {
        var selectAllBox = component.find("selectAllCB");
        // If the local ID is unique[in single record case], find() returns the component. not array
        console.log(Array.isArray(getAllId));
        var valueToSetOnQty=0;
        if(selectAllBox.get("v.value") == true)
           var valueToSetOnQty=1;
        var getAllId = component.find("selectCB");
        for (var i = 0; i < getAllId.length; i++)
        {
           // valueToSetOnQty == 0 ? getAllId[i].set("v.value",false) : getAllId[i].set("v.value",true);
           // if(component.find("qty")[i].get("v.value") == 0 || component.find("qty")[i].get("v.value") == 1)
              //  component.find("qty")[i].set("v.value", valueToSetOnQty);
        }
    },
    
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
     showSpinner: function(component, event, helper) {
        component.set("v.showspinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.showspinner", false);
    }, 
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        //component.set("v.isOpen", false);
        component.set("v.openModelCmp", false); 
         // Added by Sailaja Guntupalli CT3-120 Defect fix 
         var orginalSRTList = component.get("v.orginalSRTList");
        
        component.set('v.PaginationList',JSON.parse(JSON.stringify(orginalSRTList)));
        helper.saveSelectedHelper(component, event); //Added by Murali for CT3-633 changes
        //console.log('Console=1===PaginationList====',component.get('v.PaginationList')); 
        //console.log('Console=6=rectosave===',component.get('v.recsToSave'));
        console.log("component.get('v.cssSRTs')" , component.get('v.cssSRTs'));
        
    },    
    saveSRTs: function(component, event, helper)
    {
        // Display alert message on the click on the "Like and Close" button from Model Footer 
        // and set set the "isOpen" attribute to "False for close the model Box.
        component.set("v.hasValidData",true);
        helper.saveSelectedHelper(component, event);
        //console.log('after ::'+component.get("v.hasValidData"));
       
        if(component.get("v.hasValidData") == true){
            helper.saveSRTsHelper(component,event);
        }
		else {
            console.log('*** AccessSRTCheckbox false');
            component.set("v.AccessSRTCheckbox",false);
            component.set('v.disableNoAccSRT', false);
        }
    },
    /* javaScript function for pagination */
    navigation: function(component, event, helper) {
        console.log(1);
        var sObjectList = component.get("v.cssSRTs");
        console.log(2);
        var end = component.get("v.endPage");
        console.log(3);
        var start = component.get("v.startPage");
        console.log(4);
        var pageSize = component.get("v.pageSize");
        console.log(5);
        var whichBtn = event.getSource().get("v.name");
        console.log('6'+whichBtn);
        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
            console.log(7);
            console.log(component.get("v.currentPage") );
            console.log(8);
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
    },
    saveSelected: function(component, event, helper) {
        helper.saveSelectedHelper(component, event);
    },
    onCheck:function(component, event, helper){
        var NoAccSRTCheck = component.find("checkbox").get("v.value");
        console.log('NoAccSRTCheck**'+NoAccSRTCheck);
        console.log(component.get("v.openModelCmp"));
        var solId = component.get("v.cssSolId"); 
        var action = component.get("c.saveAccSRTCheck");
        action.setParams({
            "solId": solId,
            "accSRTCheck": NoAccSRTCheck
        });

        action.setCallback(this, function(response){
        var state = response.getState();
        if (component.isValid() && state === "SUCCESS") {
            var mysolution = response.getReturnValue();
            component.set("v.AccessSRTCheckbox", mysolution.No_Access_SRT_required__c);
            console.log('mysolutioncheck**'+mysolution.No_Access_SRT_required__c);

           // component.find("checkbox").set("v.value",mysolution.No_Access_SRT_required__c);
           // console.log('mycheckbox**'+component.find("checkbox").get("v.value"));
        }
    });
    $A.enqueueAction(action);
     
     /*if(NoAccSRTCheck){
        component.set("v.openModelCmp",false);
        component.set("v.disableOpenAccSRT",true);
        console.log('openModel::'+component.get("v.openModelCmp"));
     }
     else {
        component.set("v.openModelCmp",true);
        component.set("v.disableOpenAccSRT",false);
        console.log('openModelELSE::'+component.get("v.openModelCmp"));
        //checkurlink();
      }*/

    },
    checkurlink:function(component,event,helper)
    {
        /*var spinner = component.find('mySpinner');
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
        */
       console.log('Entered Checkurlink');
       //var SRTCheck = component.find("checkbox").get("v.value");
       //console.log('SRTCheck**'+SRTCheck);
       //var SRTCheckdisabled = component.find("checkboxdis").get("v.value");
      // console.log('SRTCheckdisabled**'+SRTCheckdisabled);
       if(component.get("v.AccessSRTCheckbox") == false){
        component.set("v.showSpinner",true);
        console.log('after true>'+component.get("v.showSpinner"));
        //helper.showSpinner(component, event, helper);
        if(component.get("v.fetchSRT") == true)
           helper.getSRTsHelper(component, event);
        else
        {
            component.set("v.showSpinner",false);
            component.set("v.openModelCmp",true);
            console.log(component.get("v.openModelCmp"));
        }
        helper.logAccessSRTAuditEventHelper(component, event, helper);
    }
        //component.set("v.showSpinner", false);
        //console.log('after false>'+$A.util.hasClass(spinner, "slds-show")+'<flag>'+component.get("v.showSpinner"));
        //component.set("v.showspinner", false);        
        /*
        $A.util.removeClass(component.find("hwDiv"), "slds-hide");
        $A.util.addClass(component.find("hwDiv"), "slds-show");*/
    },
    validateQty:function(component,event,helper)
    {
        var inp = event.getSource();
        var val=inp.get('v.value');
        if(val > 9999 || val <= 0)
        {
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams ({
                "type": "Error",
                "message": $A.get("$Label.c.FSL_Quantity")
            });
            resultsToast.fire();            
        }
        console.log('abc'+val);
    }
    })