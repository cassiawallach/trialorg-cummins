({
    loadChevron : function(component, event, helper) {
        helper.loadChevron(component, event, helper);
        helper.getStage(component, event, helper);
        helper.getStep(component, event, helper);
         helper.getStep1(component, event, helper);
        helper.isWorkOrderCreated(component,event,helper);
        helper.isTechDispatched(component,event,helper);	
        helper.getType(component, event, helper);
        
        /*helper.checkForMostLikelyOnSoln(component, event, helper);
        helper.checkForRepairSolnHelper(component, event, helper); */
         
    },
   //Added by Piyush for CT2-199-Start
    closeErrorModel: function(component, event, helper) {
        component.set("v.ErrorMsgforOpenTS", false);
    },
    //Added by Piyush for CT2-199-End
    navigateToRecord :function(component, event, helper){
        var isVisited = event.target.getAttribute('name');
        var chevronClick = event.target.getAttribute('data-index');
        var currentStage = component.get("v.processStep");
        var type = component.get("v.serviceOrderType");
        var profileName = component.get("v.profileName");
        //var stageClick = chevronClick;//component.get("v.chevronClick");//added by vinod 9/5
        //component.set("v.chevronClick",chevronClick);
        console.log('v.isTechDispatched"::'+component.get("v.isTechDispatched"));
        console.log('isVisited :: '+isVisited); 
        console.log('profileStageList '+component.get("v.profileStageList"));
        console.log('v.chevronClick::'+chevronClick +' :currentStage: '+currentStage);
        console.log('If Condition::'+component.get("v.profileStageList").includes(chevronClick));
        if(component.get("v.profileStageList") == null || component.get("v.profileStageList") ==''){
            helper.loadChevron(component, event, helper);
        }
        console.log('profileStageList '+component.get("v.profileStageList"));
        
        if(component.get("v.profileStageList").includes(chevronClick))
        {
            //Added by Harish
            if(type != 'Internal' && profileName == 'CSS_Service_Technician' && chevronClick == 'Intake'){
               return;
            }
            /*Below validations is for if user click on Close*/
            if(chevronClick =='Close'){
                if(currentStage != 'Close'){
                  //Commented by DivyaSri Srirangam as part of TW-111

                  //helper.handleCloseChevron(component,event,helper,currentStage); //Commented by Piyush for CT2-199
                  //Commenting to fix close error
                  //UnCommented by DivyaSri Srirangam as part of TW-111
                    helper.checkOpenTimeSheet(component, event, helper, currentStage);  //Added by Piyush for CT2-199
                }
            }
            
            /*Below validations is for if CurrentStage/Process step equal to Intake*/
            if(currentStage == 'Intake')
            {
                /*Guidanz will allow a user to access Job Plan 
                 * once the Service Job is in Intake status
                 */
                if(chevronClick=='Intake') {
                    component.set("v.isExtendable",true);
                    component.set("v.statusValue","Intake");
                    component.set("v.chevronClick",chevronClick);
                }
                if(chevronClick=='Job Plan') {
                    component.set("v.statusValue","Job Plan");
                    component.set("v.isExtendable",true);
                    component.set("v.chevronClick",chevronClick);
                }
                
            } 
            /* Users can only navigate from Scheduling 
               * to Job Plan on Intake Complete and not any other chevrons. 
             */
            //Below validations is for if CurrentStage/Process step equal to Schedule
            if(currentStage == 'Schedule')
            {
                if(chevronClick == 'Intake')
                {
                    helper.showToast('Error','Error','Intake cannot be accessed after WO creation');
                }
                if(chevronClick=='Schedule')
                {
                    component.set("v.statusValue","Scheduled");
                    component.set("v.isExtendable",true);
                    component.set("v.chevronClick",chevronClick);
                }
                if(chevronClick=='Job Plan')
                {
                    component.set("v.statusValue","Job Plan");
                    component.set("v.isExtendable",true);
                    component.set("v.chevronClick",chevronClick);
                }      
            }
            //Below validations is for if CurrentStage/Process step equal to Triage & Diagnosis
            if(currentStage == 'Triage & Diagnosis')
            {
                if(chevronClick == 'Intake')
                {
                    helper.showToast('Error','Error','Intake cannot be accessed after WO creation');
                }
                if(chevronClick == 'Schedule')
                {
                    helper.showToast('Error','Error','Schedule cannot be accessed after any one of the Service Appointment is dispatched');
                }
                if(chevronClick=='Triage & Diagnosis')
                {
                    component.set("v.statusValue","Triage & Diagnosis");
                    component.set("v.isExtendable",true);
                    component.set("v.chevronClick",chevronClick);
                }
                if(chevronClick=='Job Plan')
                {
                    component.set("v.statusValue","Job Plan");
                    component.set("v.isExtendable",true);
                    component.set("v.chevronClick",chevronClick);
                }
                if(chevronClick=='Repair')
                {
                    component.set("v.statusValue","Repair");
                    component.set("v.isExtendable",true);
                    component.set("v.chevronClick",chevronClick);
                }
            }
            //Below validations is for if CurrentStage/Process step equal to Job plan
            if(currentStage == 'Job Plan'){
                if(chevronClick=='Job Plan')
                {
                    component.set("v.statusValue","Job Plan");
                    component.set("v.isExtendable",true);
                    component.set("v.chevronClick",chevronClick);
                }
                if(chevronClick=='Triage & Diagnosis')
                {
                    if(component.get("v.isTechDispatched"))
                    {
                        component.set("v.statusValue","Triage & Diagnosis");
                        component.set("v.isExtendable",true);
                        component.set("v.chevronClick",chevronClick);
                    }
                }
                /*Users can only navigate between Intake and
                 *  Job Plan and not any other chevrons before Intake complete.
                 */ 
                //Added type by harish - tw-204
                if(!component.get("v.isWorkOrderCreated") || type == 'Internal'){
                    if(chevronClick=='Intake')
                    {
                        component.set("v.statusValue","Intake");
                        component.set("v.isExtendable",true);
                        component.set("v.chevronClick",chevronClick);
                    }
                }
                if(component.get("v.isWorkOrderCreated")) {
                     //Added type by harish -tw-204
                    if(chevronClick == 'Intake' && type != 'Internal') {
                        helper.showToast('Error','Error','Intake cannot be accessed after WO creation');
                    }
                }             
                /*Users can only navigate from Schedule to
                 *  Job Plan and not vice versa after technician dispatched.
                 */ 
                if(chevronClick=='Triage & Diagnosis')
                {
                    if(component.get("v.isTechDispatched")){
                        component.set("v.statusValue","Triage & Diagnosis");
                        component.set("v.isExtendable",true);
                        component.set("v.chevronClick",chevronClick);
                    }
                }
                if(chevronClick=='Repair')
                {
                    if(component.get("v.isTechDispatched")){
                        component.set("v.statusValue","Repair");
                        component.set("v.isExtendable",true);
                        component.set("v.chevronClick",chevronClick);
                    }
                }
                
            }
            if(currentStage == 'Repair') {
                if(chevronClick == 'Intake')
                {
                    helper.showToast('Error','Error','Intake cannot be accessed after WO creation');
                }
                if(chevronClick == 'Schedule')
                {
                    helper.showToast('Error','Error','Schedule cannot be accessed after any one of the Service Appointment is dispatched');
                }
                if(chevronClick=='Triage & Diagnosis')
                {
                    component.set("v.statusValue","Triage & Diagnosis");
                    component.set("v.isExtendable",true);
                    component.set("v.chevronClick",chevronClick);
                }
                if(chevronClick == 'Job Plan')
                {
                    component.set("v.statusValue","Job Plan");
                    component.set("v.isExtendable",true);
                    component.set("v.chevronClick",chevronClick);
                }
                if(chevronClick=='Repair')
                {
                    component.set("v.statusValue","Repair");
                    component.set("v.isExtendable",true);
                    component.set("v.chevronClick",chevronClick);
                }
            }
            
            
        }
    },
    
    // Added by Ravikanth
    handleSuccess: function(component, event, helper) {
        helper.insertstagingvalues(component, event, helper) // Added by Ravikanth
        // Commented lines 221 to 231 as calling the lines from helper Naga Anusha Devi Malepati 7/21/22 for capturing Integration errors of Send 4Cs to ERP NIN-444
		/*var selectedValues = component.get("v.Authorized_Work_Started__c"); // called from helper
        //action.setParams({ 
          //  recId : txt_recordId
        //});
        var currentStage = component.get("v.stateStep"); // 
        var currentStage1 = component.get("v.stateStep1"); // 
        var stageClick =  component.get("v.chevronClick"); // 
        if(component.get("v.profileStageList").includes(stageClick)){ // 
            helper.updateStageAndRecordType(component,event,helper); // 
        
        }*/ 
        // Naga Anusha Devi Malepati Ends here 7/21/22 commented for capturing Integration errors of Send 4Cs to ERP NIN-444
    },
    
    handleOnLoad : function(component, event, helper) {}, 
    handleOnChange : function(component, event, helper){
        var selectedValue = event.getSource().get("v.value");
        if(selectedValue==="Troubleshooting Complete" || selectedValue==="Send Account Updates" ){
            helper.handleOnChangeHelper(component, event, helper);
            
        }
        
    }
  

})