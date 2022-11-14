({
    
    doAction : function(component, event, helper)
    {     
   
         component.set("v.ShowDisSols",'true');
        // alert('dpintitkkkindisplay');
        var fault = event.getParam('arguments');
        
       component.set("v.FAULTCODEID", fault.faultCodeId);
        helper.getoverview(component,event);

        helper.getSolutionsKnw(component,event);
        helper.hideshowspec(component, event, helper);
          
    },
    
    displaySolution: function(component, event, helper)
    {
        var fault = event.getParam('arguments');
        
       component.set("v.FAULTCODEID", fault.faultCodeId);
    
         //component.set("v.ShowDisSols",'true');
        
    },
    doInit : function(component, event, helper)
    {
       //alert('kkkarthikindoinit');
        
        var UrlTnd = window.location.href;
         console.log('kkkk>>>'+UrlTnd);
        if(window.location.href.indexOf("solId") > -1) {
            component.set("v.ShowDisSols",'true');
           helper.getSolutionsKnw(component,event);
        helper.hideshowspec(component, event, helper);
         //removing extra id from url   
         var URl =  helper.removeParam("solId",window.location.href); 
        console.log('karthikGidinsidedisplaydoin>>>'+URl);
        window.history.pushState({}, '', URl);
    }
      
        
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
       helper.setLPTsListViewHelper(component,event,helper);
   },
    // for updating solution record from selected accordian-- by Mallika
    updateSol: function(component,event,helper)
    {
       // component.set("v.showspinner",true);
        console.log(component.get("v.selectComps"));
        var spinner = component.find('mySpinner');
        $A.util.removeClass(spinner, "slds-hide");

        var recWOId = component.get("v.recordId");
        var solID = component.get("v.SoluId");
        var resval= component.get("v.childevevalue");
        var  commvalue= component.get("v.comment");
        var  childflag=component.get("v.childSol"); 
        var parentValue=component.get("v.parentsol");
        var parentuserstamp=component.get("v.parentuserstamp");
        var errorBool = false;
        let errorProWO = "";
        if(resval == undefined){
            component.set("v.isOpen", true);
            component.set("v.errorMsg",'Please be sure a solution button is selected and comments are entered to continue');
            component.set("v.showSpinner",true);
            $A.util.addClass(spinner, "slds-hide");

        }
        console.log('resval**'+resval);
         if(resval == 'Could not perform the solution verification'){
            helper.updateSolHelper(component,event,helper);

        }
        var action_ProWO = component.get("c.validateProductOnWO");
        action_ProWO.setParams({
            'workOrderId': recWOId
        });
        if((resval == 'Most likely the solution. Repair recommended.'|| resval == 'Not the solution. Continue troubleshooting.')){
        	if(commvalue == null || commvalue == ''){
                console.log('Inside Comments If**');
            	component.set("v.isOpen", true);
            	//$A.util.addClass(spinner, "slds-hide");
                $A.util.addClass(spinner, "slds-hide");
            	component.set("v.errorMsg",'Please enter comments before saving');
            } else {
                console.log('Inside SRT Check'+ solID);
                var action_1 = component.get("c.getAccSRTCheck");
                action_1.setParams({
                    'solId': solID
                });
                console.log('Inside SRT Check1'+ solID);
                action_1.setCallback(this, function(response){
                    console.log('call back'+ response);
                    var state1 = response.getState();
                    console.log('state1::'+state1);
                    errorBool = response.getReturnValue();
                    console.log('errorBool**'+errorBool);
                    
                    if(errorBool == true){
                        component.set("v.isOpen", true);
                        //$A.util.addClass(spinner, "slds-hide");
                        $A.util.addClass(spinner, "slds-hide");
                        component.set("v.errorMsg",'Please select Access SRTs from Open the Access SRT checklist or click No Access SRT required checkbox');
                    }
                    else{
                        
                        action_ProWO.setCallback(this, function(responseProWO){
                            var stateProWO = responseProWO.getState();
                            console.log('stateProWO::'+stateProWO);
                            errorProWO = responseProWO.getReturnValue();
                            console.log('errorProWO**'+errorProWO);
                            if(errorProWO.includes("error")){
                                component.set("v.isOpen", true);
                                //$A.util.addClass(spinner, "slds-hide");
                                $A.util.addClass(spinner, "slds-hide");
                                //component.set("v.errorMsg",$A.get("$Label.c.EVL_MileageHours_Error_Message"));
                                if(errorProWO.includes("mileage")){
                                    component.set("v.isMileageErr",true);
                                    component.set("v.errorMsg",$A.get("$Label.c.EVL_Product_Mileage_popupmsg"));
                                }
                                if(errorProWO.includes("hours")){
                                    component.set("v.isHoursErr",true);
                                    component.set("v.errorMsg",$A.get("$Label.c.EVL_Product_Hours_popupmsg_msg"));
                                }
                            }
                            else{
                                helper.updateSolHelper(component,event,helper);
                                helper.getSolutionsKnw(component,event);	//updated new code for Binding knowledgeList 
                                setTimeout(function()
                                           { 
                                              // $A.get('e.force:refreshView').fire();
                                           }, 4500);
                                /*      var EVL_PathChange = $A.get("e.c:EVL_PathChange");  
                        appEvent.setParams({ "jobStatus" : "Repair" });   //FIRE CHANGE EVENT
                        EVL_PathChange.fire(); */ //commented by sai as part of CT1-400
                            }
                        });
                        $A.enqueueAction(action_ProWO);
                    }
                });
                $A.util.addClass(spinner, "slds-hide");

                console.log('Inside SRT Check2'+ solID);
                $A.enqueueAction(action_1);
            }
            
        }
   },
    // for showing alert if radiobutton,comments are not entered-- by Mallika
    closeWind: function(component, event, helper) {
        component.set("v.isOpen", false);
        if(component.get("v.isMileageErr") || component.get("v.isHoursErr")){
            var recWOId = component.get("v.recordId");
            var recHours = component.get("v.hoursNum");
            var recMileage = component.get("v.mileageNum");
            var action_updWO = component.get("c.updateWO");
            action_updWO.setParams({
                'workOrderId': recWOId,
                'hours': recHours,
                'mileage': recMileage
            });
            action_updWO.setCallback(this, function(responseUpdWO){
                var stateUpdWO = responseUpdWO.getState();
                console.log('stateUpdWO::'+stateUpdWO);
                console.log('responseUpdWO::'+responseUpdWO.getReturnValue());
                component.set("v.isMileageErr",false);  // Added by Sruthi VGRS2-132 11/2/2021
                component.set("v.isHoursErr",false);	//  Added by Sruthi VGRS2-132 11/2/2021
                });
            $A.enqueueAction(action_updWO);
        }
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
       var solId = event.target.id;
       helper.continueToSolutionInRepair(component,solId);
    },
     handleValueChange:function(component,event,helper){
         //added by Mani  PHEON - 33 -->
          var checkload = component.get("v.isreloads");
          if(checkload !== true){
              //added by Mani  PHEON - 33 -->
         helper.insertViewedSolutionOnRepair(component,event,helper);
          }
    },
})