({
    doInit : function(component, event, helper)
    {
         
        component.set("v.ShowDisSols",'true');

 // Added by Sriprada for VGRS2-6 to check fault code insertion on WO : 10/20/2021    
        var action1 = component.get('c.fetchFCSolData');
        console.log('IntoInit:::s');
        action1.setParams({
            "recordId" : component.get("v.recordId")            
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log('State::'+state);
            if(state === "SUCCESS") {
                var appErrMsg = response.getReturnValue();
                console.log('InitappErrMsg'+appErrMsg);
                
                if(appErrMsg == true){
                    component.set('v.DiagnosticErrMsg', false);
                    component.set('v.errSolMsg', false);
                    
                    component.set('v.faultID', true);
                    helper.getoverview(component,event); // Added by Sriprada for Overview display under Repair solutions tab : 10/20/2021
                    
                    helper.getSolutionsKnw(component,event);
                    
                } else{
                    
                    component.set('v.faultID', false);
                    
                    
                }
            }
        });
        $A.enqueueAction(action1); //Code end here -- Sriprada
        helper.hideshowspec(component, event, helper);
        helper.getWorkOrderRecordType(component, event, helper);
    },
    
    doAction : function(component, event, helper)
    {   
		//component.set("v.ShowDisSols",'true');
        var fault = event.getParam('arguments');
       component.set("v.FAULTCODEID", fault.faultCodeId);
        component.set("v.ShowDisSols",'true');

        helper.getSolutionsKnw(component,event);
        helper.getoverview(component,event); // Added by Sriprada for Overview display under Repair solutions tab : 10/20/2021
        helper.hideshowspec(component, event, helper);
        
        //helper.getSolutionsKnw(component,event);
        //helper.hideshowspec(component, event, helper);
        //helper.getWorkOrderRecordType(component, event, helper);
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
       var sections = component.get("v.activeSections");
       component.set("v.activeSectionsSelected", sections);
       console.log(component.get("v.selectComps"));
       helper.updateSolHelper(component,event,helper);
       helper.getSolutionsKnw(component,event);	//Krishna updated new code for Binding knowledgeList
       
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
        var strvalue = event.getParam("repairPickListValue"); 
        console.log('strvalue>>'+strvalue);
        //alert('strvalue '+strvalue);
        //Set the handler attributes based on event data 
        component.set("v.childevevalue",strvalue );
        component.set("v.showSolComp", true);
        var whichOne = event.getSource().getLocalId();
        var indexvar = event.getParam("selectedIdx");//event.getSource().get("v.messageWhenValueMissing");
        console.log("indexvar:::" + indexvar);
        component.set("v.selectIndx", indexvar)
        //added for repair radio buttons - by vinod yellala
        if(strvalue == 'Repair Successful.' ||
           strvalue == 'Repair Successful with additional parts/procedures.' ||
           strvalue == 'Repair performed but didnot resolve the root cause.')
        {
            component.set("v.showSolComps",true);
        }
        else
            component.set("v.showSolComps",false);
        if(strvalue == 'Repair Successful.' ||
           strvalue == 'Repair Successful with additional parts/procedures.' ||
           strvalue == 'Repair performed but didnot resolve the root cause.')
            component.set("v.hideAddFailureBtn",true);
        else
            component.set("v.hideAddFailureBtn",false);
        //component.find("surveyButtons").get("v.value")
        // console.log("indexvar:::" + indexvar); 
       
        //console.log(component.find("hiddenRowIndx").get("v.value"));
        //console.log(component.find("accidn").get("v.value"));
       //alert('showing on click of radio buton');
    },
    /*collectSolComps:function(component, event)
    {
        console.log('fired after selection');
        var selectedSolComps = event.getParam("solComps");
        console.log('message>>'+selectedSolComps);
        component.set("v.selectComps",selectedSolComps);
        //alert(component.get("v.selectComps"))
    },*/
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
        console.log('deSelectedParts::'+deSelectedParts);
        var cssSolComps = event.getParam("cssSolComps");
        component.set("v.cssSolComps",cssSolComps);
        console.log('cssSolComps::'+cssSolComps);
        /*var partIdReplsRsn = event.getParam("partIdReplsRsn");
        component.set("v.partIdReplsRsn",partIdReplsRsn);
        console.log('partIdReplsRsn::'+partIdReplsRsn);
        */
    },
    
    handleValueChange:function(component,event,helper){
         helper.insertViewedSolutionOnRepair(component,event,helper);
    },
    handleDigReturn: function(component, event,helper){        
        console.log('sssss');
        var solId = event.target.id;
       // alert(solId);
        //console.log('solId >>>>>>'+solId)
       //  var ctarget = event.currentTarget;
       //  var solId = ctarget.dataset.value;
       // var woId = component.get("v.recordId");
        helper.returnToSolutionInDiagnostic(component,solId);
    }
    
})