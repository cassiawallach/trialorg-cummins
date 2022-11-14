({
    doInit : function(component, event, helper)
    {
        helper.getSolutionsKnw(component,event);
       // helper.getoverview(component,event);
        helper.hideshowspec(component, event, helper);
        
    },
    handleChange : function(component, event, helper)
    {
      // alert(component.get("v.comment"));
    },
    //added for showing or hiding solution components based on solution details.
    showSolutionComponent:function (component, event, helper)
    {
        console.log(component.find("surveyButtons").get("v.value"));
        console.log(component.find("surveyButtons").get("v.options"));
        console.log('entered show solution component');
        if(component.find("surveyButtons").get("v.value") == 'Most likely the solution.Repair recommended.')
        {
            console.log('inside if');
            // alert('test');
            $A.util.removeClass(component.find("fslsolComp"), "slds-hide");
            $A.util.addClass(component.find("fslsolComp"), "slds-show");
        }
        else
        {
            console.log($A.util.hasClass(component.find("fslsolComp"), "slds-show"));
            if($A.util.hasClass(component.find("fslsolComp"), "slds-show"))
            {
                $A.util.removeClass(component.find("fslsolComp"), "slds-show");
                $A.util.addClass(component.find("fslsolComp"), "slds-hide");
            }
        } 
    },
    // for getting solution id from selected accordian-- by Mallika
    setLPTsListView: function(component,event,helper)
    {
        helper.resetRadioButton(component,event,helper); //236 changes by Murali 2/15/22
       helper.setLPTsListViewHelper(component,event,helper);
   },
    // for updating solution record from selected accordian-- by Mallika
    updateSol: function(component,event,helper)
    {
        component.set("v.showspinner",true);
        component.set("v.showSpinner",true);
        console.log('InupdateSol**'+component.get("v.selectComps"));
       helper.updateSolHelper(component,event,helper);
        
   },
    // for showing alert if radiobutton,comments are not entered-- by Mallika
    closeWind: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    checkurlink:function(component,event,helper)
    {
        component.set("v.openModelCmp", true);
        console.log(component.get("v.openModelCmp"));
        /*
        $A.util.removeClass(component.find("hwDiv"), "slds-hide");
        $A.util.addClass(component.find("hwDiv"), "slds-show");*/
    },
    Showsolutioncomponent2:function(component, event, helper)
    {
        var strvalue = event.getParam("pickvalues"); 
        if(strvalue == undefined)
            strvalue = event.getParam("repairPickListValue"); 
        //console.log(event.getParam("repairPickListValue"));
        console.log('strvalue>>'+strvalue);
        //Set the handler attributes based on event data 
        component.set("v.childevevalue",strvalue );
        //added for repair radio buttons - by vinod yellala
        /* ||
           strvalue == 'Repair Successful.' ||
           strvalue == 'Repair Successful with additional parts/procedures.' ||
           strvalue == 'Repair performed but didnot resolve the root cause.'*/
        //changed for uncommited error
        if(strvalue == 'Most likely the solution. Repair recommended.')
        {
            component.set("v.showSolComps",true);
            //helper.insertViewedSolutionOnDiagAudit(component,event,helper);//added by vinod on 7/18-commented for uncommited error 8/7/2019
        }
        else
            component.set("v.showSolComps",false);
        if(strvalue == 'Repair Successful.' ||
           strvalue == 'Repair Successful with additional parts/procedures.' ||
           strvalue == 'Repair performed but didnot resolve the root cause.')
            component.set("v.hideAddFailureBtn",true);
        else
            component.set("v.hideAddFailureBtn",false);
        
        component.set("v.showSolComp", true);
        var whichOne = event.getSource().getLocalId();
        var indexvar = event.getParam("selectedIdx");//event.getSource().get("v.messageWhenValueMissing");
        console.log("indexvar:::" + indexvar);
        component.set("v.selectIndx", indexvar)
        /* if(strvalue == 'Most likely the solution. Repair recommended.')//added for uncommited error 8/7/2019
        {
            helper.insertViewedSolutionOnDiagAudit(component,event,helper);
        } */
    },
    collectSolComps:function(component, event)
    {
        console.log('fired after selection');
        var selectedSolComps = event.getParam("solComps");
        console.log('message>>'+selectedSolComps);
        component.set("v.selectComps",selectedSolComps);
        var deSelectedSolComps = event.getParam("unselectedSolComps");
        console.log('deSelectedSolComps>>'+deSelectedSolComps);
        component.set("v.deSelectedSolComps",deSelectedSolComps);
        var selectedParts = event.getParam("selectedParts");
        component.set("v.selectedParts",selectedParts);
        console.log('selectedParts::'+selectedParts);
        var deSelectedParts = event.getParam("deSelectedParts");
        component.set("v.deSelectedParts",deSelectedParts);
        var cssSolComps = event.getParam("cssSolComps");
        component.set("v.cssSolComps",cssSolComps);
        console.log('cssSolComps::'+cssSolComps);
        /*var partIdReplsRsn = event.getParam("partIdReplsRsn");
        component.set("v.partIdReplsRsn",partIdReplsRsn);
        console.log('partIdReplsRsn::'+partIdReplsRsn);
        */
    },
    handleRepairCont: function(component, event,helper){        
       //var solId = event.target.id;
       //helper.continueToSolutionInRepair(component,solId);
       component.set("v.showspinner",true);
       component.set("v.showSpinner",true);
        console.log('InupdateSolRepair**'+component.get("v.selectComps"));
       helper.continueToSolutionInRepair(component,event,helper); //CT3-26, commented above line and added this.
    },
     handleValueChange:function(component,event,helper){
          //added by Mani  PHEON - 33 -->
          var checkload = component.get("v.isreloads");
          if(checkload !== true){
              //added by Mani  PHEON - 33 -->
         helper.insertViewedSolutionOnRepair(component,event,helper);
          }
    },
    //Added Ravikanth CT2-5 
    // Ravikanth Commented 134 to 149 for April release
 /*handleRecordUpdated: function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        //alert(userId);
        var eventParams = event.getParams();
     //  alert(component.get("v.record").Clock_In_User_Ids__c);
        
            if((component.get("v.record.User__r.Id")== null || component.get("v.record.User__r.Id") == ''|| component.get("v.record.User__r.Id") == userId)  && component.get("v.record").Clock_In_User_Ids__c !=null ){
               
                component.set("v.hidelaunchinsite",true);
            } 
            else if((component.get("v.record.User__r.Id")!= null && component.get("v.record.User__r.Id") != '' && component.get("v.record.User__r.Id") != userId) || component.get("v.record").Clock_In_User_Ids__c == null){
                component.set("v.hidelaunchinsite",false);
            } 
    } */
    
})