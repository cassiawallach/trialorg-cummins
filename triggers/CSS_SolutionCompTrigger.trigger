trigger CSS_SolutionCompTrigger on CSS_Solution_Component__c (after update,after insert, before insert, before update, before delete) { 
    //****************** This is for GUIDANZ*******************/
    boolean guidanzFlag = false;
    if(!trigger.isdelete) {
        for(CSS_Solution_Component__c solcomp : Trigger.New) {
            if((solcomp.CSS_Classic_SJId__c != null && solcomp.CSS_Classic_SJId__c != '') || solcomp.CSS_Claims__c != null){
                guidanzFlag = true;
                break;
            }
        }  
    } else {
        for(CSS_Solution_Component__c solcomp : Trigger.Old) {
            if((solcomp.CSS_Classic_SJId__c != null && solcomp.CSS_Classic_SJId__c != '') || solcomp.CSS_Claims__c != null){
                guidanzFlag = true;
                break;
            }
        } 
    }
    //****************** This is for GUIDANZ*******************/
    if(guidanzFlag) {
        if(trigger.isBefore){
            if(trigger.isInsert){
                system.debug('in SolCompl trigger of isBefore & isInsert...');
                Set<String> accCodeSet = new Set<String>();
                List<CSS_Solution_Component__c> solCompToUpd = new List<CSS_Solution_Component__c>();
                List<CSS_JobEventTemporary__c> jobEventList = new List<CSS_JobEventTemporary__c>();
                Map<String, String> accCodeCoverageType = new Map<String, String>();
                jobEventList = [SELECT Attribute1__c, Attribute4__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' ]; //AND Attribute4__c =: accCodeSet
                for(CSS_JobEventTemporary__c jobEventTemp : jobEventList)
                {
                    if(jobEventTemp.Attribute4__c != null && !accCodeCoverageType.containsKey(jobEventTemp.Attribute4__c)){
                        accCodeCoverageType.put(jobEventTemp.Attribute4__c.right(2), jobEventTemp.Attribute1__c);
                    }
                }
                
                 // Story 454
               /* Integer solCompRootCauseCounter =0;
                for(CSS_Solution_Component__c solutionCompRC : Trigger.new)
                {
                  if(solutionCompRC.Selected_Component__c==true){   
                    solCompRootCauseCounter = solCompRootCauseCounter+1;
                  }
                }
                
                system.debug('Before insert solCompRootCauseCounter >> ' + solCompRootCauseCounter);*/
                
                for(CSS_Solution_Component__c solutionComp : Trigger.new)
                {
                    if(solutionComp.CSS_Account_Formula__c != '' && solutionComp.CSS_Account_Formula__c != null && !accCodeSet.contains(solutionComp.CSS_Account_Formula__c))
                    {
                        accCodeSet.add(solutionComp.CSS_Account_Formula__c.right(2));
                    }
                    if(solutionComp.CSS_Account_Formula__c != '' && solutionComp.CSS_Account_Formula__c != null && accCodeCoverageType != null){
                        String coverageType = accCodeCoverageType.get(solutionComp.CSS_Account_Formula__c.right(2));
                        system.debug('Coverage Type'+coverageType);
                           solutionComp.CSS_CoverageType__c = coverageType;
                        if(coverageType == 'NPW'){
                            solutionComp.Parts_Warranty__c = 'New Parts Warranty';
                            solutionComp.RoadRelay_Warranty__c = 'N';
                        }
                        else if(coverageType == 'RPW'){
                            solutionComp.Parts_Warranty__c = 'Recon Parts Warranty';
                            solutionComp.RoadRelay_Warranty__c = 'N';
                        }
                        else if(coverageType == 'RRW')
                        {
                            solutionComp.RoadRelay_Warranty__c = 'Y';
                            solutionComp.Parts_Warranty__c = '';
                            solutionComp.Parts_Warranty__c = '';
                        }
                    }
                    //GSSC-453 - START
                    if(solutionComp.Service_Job__c != null){
                        User u = css_utility.getUserAttributes(userInfo.getUserId());
                        String orgType = css_utility.getOrgType(userInfo.getUserId());
                        Boolean isClaimEnabled = css_utility.getclaimsapprove(userInfo.getUserId());
                        if(((u.UserRole.Name != null && u.UserRole.Name.contains('Factory')) || (orgType == 'DISTR') || (orgType == 'DLR' && isClaimEnabled == false)) && solutionComp.Selected_Component__c == true){
                            system.debug('inside if');
                            solutionComp.Root_Cause__c = true;
                            system.debug('B4 insert solutionComp.Root_Cause__c' + solutionComp.Root_Cause__c);
                        }
                        
                           // Below cond. as part of Story 454
                        /* if((orgType == 'DLR' && isClaimEnabled == true) &&  solCompRootCauseCounter ==1){
                           solutionComp.Root_Cause__c = true;
                        }
                        */
                    }
                    //GSSC-453 - END
                }
                system.debug('Account code set'+accCodeSet);
                system.debug('solutionComp'+solCompToUpd);
            }
            else if(trigger.isUpdate){
                for(CSS_Solution_Component__c solutionComp : Trigger.new)
                {
                    //GSSC-453 - START
                    if(solutionComp.Service_Job__c != null && Trigger.oldMap.get(solutionComp.Id).Selected_Component__c != solutionComp.Selected_Component__c){
                        User u = css_utility.getUserAttributes(userInfo.getUserId());
                        String orgType = css_utility.getOrgType(userInfo.getUserId());
                        Boolean isClaimEnabled = css_utility.getclaimsapprove(userInfo.getUserId());
                        system.debug('B4 Update orgType ' +orgType);
                        system.debug('B4 Update isClaimEnabled ' +isClaimEnabled);
                        system.debug('oldmap  ' + Trigger.oldMap.get(solutionComp.Id).Selected_Component__c );
                            system.debug('New ' + solutionComp.Selected_Component__c);
                        if(((u.UserRole.Name != null && u.UserRole.Name.contains('Factory')) || (orgType == 'DISTR') || (orgType == 'DLR' && isClaimEnabled == false)) ){
                             system.debug('inside if');
                            solutionComp.Root_Cause__c = solutionComp.Selected_Component__c;
                            system.debug('B4 update solutionComp.Root_Cause__c' + solutionComp.Root_Cause__c);
                        }
                         
                    }
                    //GSSC-453 - END
                }
                if(RecursiveTriggerHandler.isFirstTimeFailuresTriggerBeforeUpdate == true){
                    system.debug('in SolCompl trigger of isUpdate & isFirstTimeFailuresTriggerBeforeUpdate...');
                    RecursiveTriggerHandler.isFirstTimeFailuresTriggerBeforeUpdate = false;
                    Set<String> accCodeSet = new Set<String>();
                    List<CSS_Solution_Component__c> solCompToUpd = new List<CSS_Solution_Component__c>();
                    List<CSS_JobEventTemporary__c> jobEventList = new List<CSS_JobEventTemporary__c>();
                    Map<String, String> accCodeCoverageType = new Map<String, String>();
                    jobEventList = [SELECT Attribute1__c, Attribute4__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' AND Attribute4__c =: accCodeSet];
                    for(CSS_JobEventTemporary__c jobEventTemp : jobEventList)
                    {
                        if(!accCodeCoverageType.containsKey(jobEventTemp.Attribute4__c)){
                            accCodeCoverageType.put(jobEventTemp.Attribute4__c, jobEventTemp.Attribute1__c);
                        }
                    }
                    system.debug('Job Event Temp'+jobEventList);
                    system.debug('Coverage Type'+accCodeCoverageType);
                    
                    // Story 454
                    /*Integer solCompRootCauseCounterUpdate =0;
                    for(CSS_Solution_Component__c solutionCompRC : Trigger.new)
                    {
                      if(solutionCompRC.Selected_Component__c==true){   
                        solCompRootCauseCounterUpdate = solCompRootCauseCounterUpdate+1;
                      }
                    }
                    
                    system.debug('Before update solCompRootCauseCounterUpdate >> ' + solCompRootCauseCounterUpdate);*/
                    
                    for(CSS_Solution_Component__c solutionComp : Trigger.new)
                    {
                        if(solutionComp.CSS_Account_Formula__c != '' && solutionComp.CSS_Account_Formula__c != null && !accCodeSet.contains(solutionComp.CSS_Account_Formula__c))
                        {
                            accCodeSet.add(solutionComp.CSS_Account_Formula__c);
                        }
                        if(solutionComp.CSS_Account_Formula__c != '' && solutionComp.CSS_Account_Formula__c != null && accCodeCoverageType != null){
                            String coverageType = accCodeCoverageType.get(solutionComp.CSS_Account_Formula__c);
                            system.debug('Coverage Type'+coverageType);
        
                            if(coverageType == 'NPW'){
                                solutionComp.Parts_Warranty__c = 'New Parts Warranty';
                                solutionComp.RoadRelay_Warranty__c = 'N';
                            }
                            else if(coverageType == 'RPW'){
                                solutionComp.Parts_Warranty__c = 'Recon Parts Warranty';
                                solutionComp.RoadRelay_Warranty__c = 'N';
                            }
                            else if(coverageType == 'RRW')
                            {
                                solutionComp.RoadRelay_Warranty__c = 'Y';
                                solutionComp.Parts_Warranty__c = '';
                                solutionComp.Parts_Warranty__c = '';
                            }
                        }
                        /*//GSSC-453 - START
                        if(solutionComp.Service_Job__c != null){
                            User u = css_utility.getUserAttributes(userInfo.getUserId());
                            String orgType = css_utility.getOrgType(userInfo.getUserId());
                            Boolean isClaimEnabled = css_utility.getclaimsapprove(userInfo.getUserId());
                            system.debug('B4 Update orgType ' +orgType);
                            system.debug('B4 Update isClaimEnabled ' +isClaimEnabled);
                            system.debug('oldmap  ' + Trigger.oldMap.get(solutionComp.Id).Selected_Component__c );
                                system.debug('New ' + solutionComp.Selected_Component__c);
                            if(((u.UserRole.Name != null && u.UserRole.Name.contains('Factory')) || (orgType == 'DISTR') || (orgType == 'DLR' && isClaimEnabled == false)) && Trigger.oldMap.get(solutionComp.Id).Selected_Component__c != solutionComp.Selected_Component__c){
                                 system.debug('inside if');
                                solutionComp.Root_Cause__c = solutionComp.Selected_Component__c;
                                system.debug('B4 update solutionComp.Root_Cause__c' + solutionComp.Root_Cause__c);
                            }
                             
                        }
                        //GSSC-453 - END*/
                    }
                   system.debug('Account code set'+accCodeSet);
                    system.debug('solutionComp'+solCompToUpd);
                }
            }
            else if(trigger.isDelete){
                List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
                claimsAuditLst = [SELECT Id, isServicejob__c, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c, Remove_Message__c
                                  FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_Solution_Component__c' ORDER BY Sort_Order__c ASC];
                CG_CL_ClaimsAuditTrailEventHandler.onDeleteFC(Trigger.old, claimsAuditLst); 
            }
        }
        else if(trigger.isAfter){
            if(trigger.isInsert){
                system.debug('in SolCompl trigger of isAfter & isInsert...');
                List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
                List<string> MansolCompAdd = new List<string>();
                List<Id> claimid = new List<Id>();
                List<CSS_PSN__c > psn = new List<CSS_PSN__c >();
                Map<id,string> claimWithEquip = new Map<id,string>();
                Map<id,string> claimWithSM = new Map<id,string>();
                Map<id,string> claimWithEM = new Map<id,string>();
                Boolean callManualClaimSrt = false;
                system.debug('kal**'+Trigger.new);
                claimsAuditLst = [SELECT Id, isServicejob__c, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c, Remove_Message__c
                                  FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_Solution_Component__c' ORDER BY Sort_Order__c ASC];
            
                CG_CL_ClaimsAuditTrailEventHandler.onInsertFC(Trigger.new, claimsAuditLst);
                for(CSS_Solution_Component__c solutionComp : Trigger.new)
                {
                    if(solutionComp.Service_Job__c!=null){
                    }
                    else{
                        claimid.add(solutionComp.CSS_Claims__c);
                    }
                }
                if(claimid.size()>0){
                    psn=[Select id,Equipment_ID__c,CSS_Claims__c,Service_Model__c,Qsol_Engine_Family_Code__c from CSS_PSN__c where CSS_Claims__c in:claimid];
                    if(psn.size()>0){
                        for(CSS_PSN__c p: psn ){
                            claimWithEquip.put(p.CSS_Claims__c,p.Equipment_ID__c);
                            claimWithSM.put(p.CSS_Claims__c,p.Service_Model__c);
                            claimWithEM.put(p.CSS_Claims__c,p.Qsol_Engine_Family_Code__c);
                        }
                    }
                }
                system.debug('claimWithEquip'+claimWithEquip);
                system.debug('claimWithSM'+claimWithEquip);
                 system.debug('claimWithEM'+claimWithEM);
                for(CSS_Solution_Component__c solutionComp : Trigger.new)
                {
                    if(solutionComp.Service_Job__c!=null){
                    }
                    else{//Added "solutionComp.Over_The_Counter__c != true" in below if condition as part of the story GSSC-298
                        if(solutionComp.Selected_Component__c == true && solutionComp.SRT_Fetched__c == false && (solutionComp.Type__c == '' || solutionComp.Type__c == null) && solutionComp.Over_The_Counter__c != true) //Trigger.oldMap.get(solutionComp.Id).Selected_Component__c == false)
                        {
                            system.debug('solutionComp.Selected_Component__c>>>>>'+solutionComp.Selected_Component__c);
                            callManualClaimSrt = true;
                            MansolCompAdd.add(JSON.Serialize(new solCompWrapper(solutionComp.Solutions__c,solutionComp.CSS_Claims__c,claimWithSM.get(solutionComp.CSS_Claims__c),claimWithEquip.get(solutionComp.CSS_Claims__c),solutionComp.id,claimWithEM.get(solutionComp.CSS_Claims__c),solutionComp.Component_Id__c,solutionComp.CSS_Claims__r.Name,0.0, solutionComp.FailCode_Formula__c,solutionComp.CSS_Account_Formula__c,solutionComp.Type__c,solutionComp.CoveredLaborHrs__c,solutionComp.CampaignLaborPercentage__c)));                  
                            system.debug('MansolCompAdd>>>>>'+MansolCompAdd);
                        }
                    }
                }
                
                system.debug('callManualClaimSrt>>>:'+callManualClaimSrt);
                if(!Test.isRunningTest() && callManualClaimSrt == true){
                    callManualClaimSrt = false;
                    system.debug('before calling repairSRTManualClaim...');
                    CSS_SRT.repairSRTManualClaim(MansolCompAdd); 
                    system.debug('called repairSRTManualClaim>>>>>');               
                }
            }
            else if(trigger.isUpdate){ 
                List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
                if(RecursiveTriggerHandler.isFirstTimeFailuresTriggerAfterUpdate == true){
                claimsAuditLst = [SELECT Id, isServicejob__c, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c, Remove_Message__c
                                  FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_Solution_Component__c' ORDER BY Sort_Order__c ASC];
                CG_CL_ClaimsAuditTrailEventHandler.onUpdateFC(Trigger.new, trigger.oldmap, claimsAuditLst);
                //444
                CG_CL_ClaimsAuditTrailEventHandler.onsolcompUpdateFC(Trigger.new, trigger.oldmap, claimsAuditLst);

                
                    system.debug('in SolCompl trigger of isAfter & isUpdate...');
                    RecursiveTriggerHandler.isFirstTimeFailuresTriggerAfterUpdate = false;
                    List<string> solCompAdd = new List<string>();
                    List<string> MansolCompAdd = new List<string>();
                    List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();
                    List<Id> claimid = new List<Id>();
                    List<CSS_PSN__c > psn = new List<CSS_PSN__c >();
                    Map<id,string> claimWithEquip = new Map<id,string>();
                    Map<id,string> claimWithSM = new Map<id,string>();
                    Map<id,string> claimWithEM = new Map<id,string>();
                    Boolean callSrt = false;
                    Boolean callManualClaimSrt = false;
                    Set<String> failCodeAccCodeSetRootCause = new Set<String>(); //GSSC-456
                    system.debug('kal**'+Trigger.new);
                    Id jobId; //GSSC-456
                    boolean selectedpart = false;
                    for(CSS_Solution_Component__c solutionComp : Trigger.new)
                    {
                        if(solutionComp.Service_Job__c!=null){
                            //GSSC-456 - START
                            jobId = solutionComp.Service_Job__c;
                            if(Trigger.oldMap.get(solutionComp.Id).Root_Cause__c == true && solutionComp.Root_Cause__c == false){
                                selectedpart = true;
                                if(solutionComp.FailCode_Formula__c != null && solutionComp.CSS_Account_Formula__c != null &&
                                   solutionComp.FailCode_Formula__c != '' && solutionComp.CSS_Account_Formula__c != '') {
                                	String temp = solutionComp.FailCode_Formula__c.RIGHT(4) + ';;' + solutionComp.CSS_Account_Formula__c;
                                	failCodeAccCodeSetRootCause.add(temp);
                                }
                            }
                            //GSSC-456 - END
                           
                        }
                        else{
                            claimid.add(solutionComp.CSS_Claims__c);
                        }
                    }
                    //GSSC-456 - START
                    if(failCodeAccCodeSetRootCause != null && failCodeAccCodeSetRootCause.size() > 0){
                        CG_CL_SolutionComp_TriggerHandler contr = new CG_CL_SolutionComp_TriggerHandler();
                        contr.deleteChildRecordsOnRootCauseUnSelect(failCodeAccCodeSetRootCause, jobId);
                    }
                    //GSSC-456 - END
                    //
                    if(selectedpart==true){
                    CG_CL_SolutionComp_TriggerHandler contr1 = new CG_CL_SolutionComp_TriggerHandler();
                    contr1.uncheckPartid(failCodeAccCodeSetRootCause, jobId);
                    }
                    
                    //
                    if(claimid.size()>0){
                        psn=[Select id,Equipment_ID__c,CSS_Claims__c,Service_Model__c,Qsol_Engine_Family_Code__c from CSS_PSN__c where CSS_Claims__c in:claimid];
                        if(psn.size()>0){
                            for(CSS_PSN__c p: psn ){
                                claimWithEquip.put(p.CSS_Claims__c,p.Equipment_ID__c);
                                claimWithSM.put(p.CSS_Claims__c,p.Service_Model__c);
                                claimWithEM.put(p.CSS_Claims__c,p.Qsol_Engine_Family_Code__c);
                            }
                        }
                    }
                    for(CSS_Solution_Component__c solutionComp : Trigger.new)
                    {
                        if(solutionComp.Service_Job__c!=null){
                            if(solutionComp.Selected_Component__c == true && solutionComp.SRT_Fetched__c == false && (solutionComp.Type__c == '' || solutionComp.Type__c == null) && solutionComp.GetAccountCodeServiceRun__c == true) //Trigger.oldMap.get(solutionComp.Id).Selected_Component__c == false)
                                //if(solutionComp.Selected_Component__c == true && solutionComp.SRT_Fetched__c == false && (solutionComp.Type__c == '' || solutionComp.Type__c == null)) //Trigger.oldMap.get(solutionComp.Id).Selected_Component__c == false)
                            {
                                system.debug('solutionComp.Selected_Component__c>>>>>'+solutionComp.Selected_Component__c);
                                callSrt = true;
                                solCompAdd.add(JSON.Serialize(new solCompWrapper(solutionComp.Solutions__c,solutionComp.Service_Job__c,solutionComp.Service_Model__c,solutionComp.Equip_ID__c,solutionComp.id,solutionComp.Engine_Family_Code__c,solutionComp.Component_Id__c,solutionComp.Service_Job__r.Name,solutionComp.Service_Job__r.Claim_no__c,solutionComp.FailCode_Formula__c,solutionComp.CSS_Account_Formula__c,solutionComp.Type__c,solutionComp.CoveredLaborHrs__c,solutionComp.CampaignLaborPercentage__c)));                  
                                system.debug('solCompAdd>>>>>'+solCompAdd);
                            }
                            else if(solutionComp.Selected_Component__c == false && Trigger.oldMap.get(solutionComp.Id).Selected_Component__c == true)
                            {
                                callSrt = false;
                                // Do Nothing.
                            }
                        }
                        else{ //Added "solutionComp.Over_The_Counter__c != true" in below if condition as part of the story GSSC-298
                            if(solutionComp.Selected_Component__c == true && solutionComp.SRT_Fetched__c == false && (solutionComp.Type__c == '' || solutionComp.Type__c == null) && solutionComp.Over_The_Counter__c != true) //Trigger.oldMap.get(solutionComp.Id).Selected_Component__c == false)
                            {
                                system.debug('solutionComp.Selected_Component__c>>>>>'+solutionComp.Selected_Component__c);
                                callManualClaimSrt = true;
                                MansolCompAdd.add(JSON.Serialize(new solCompWrapper(solutionComp.Solutions__c,solutionComp.CSS_Claims__c,claimWithSM.get(solutionComp.CSS_Claims__c),claimWithEquip.get(solutionComp.CSS_Claims__c),solutionComp.id,claimWithEM.get(solutionComp.CSS_Claims__c),solutionComp.Component_Id__c,solutionComp.CSS_Claims__r.Name,0.0, solutionComp.FailCode_Formula__c,solutionComp.CSS_Account_Formula__c,solutionComp.Type__c,solutionComp.CoveredLaborHrs__c,solutionComp.CampaignLaborPercentage__c)));                  
                                system.debug('MansolCompAdd>>>>>'+MansolCompAdd);
                            }
                            else if(solutionComp.Selected_Component__c == false && Trigger.oldMap.get(solutionComp.Id).Selected_Component__c == true)
                            {
                                callManualClaimSrt = false;
                                // Do Nothing.
                            }
                        }
                    }
                    
                    system.debug('callSrt--'+callSrt);
                    if(!Test.isRunningTest() && callSrt == true){ 
                        callSrt = false;
                        System.enqueueJob(new CG_JobRepairSRTQueueable(solCompAdd));
                        System.debug('END QUEUEABLE SOLUTION COMPONENT');
                        system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );
        
                    }
                    system.debug('callManualClaimSrt>>:'+callManualClaimSrt+' RecursiveTriggerHandler.isFirstTimeFailuresTriggerAfterUpdate>>:'+RecursiveTriggerHandler.isFirstTimeFailuresTriggerAfterUpdate);
                    if(!Test.isRunningTest() && callManualClaimSrt == true){
                        callManualClaimSrt = false;
                        system.debug('before calling 22 repairSRTManualClaim...');
                        CSS_SRT.repairSRTManualClaim(MansolCompAdd); 
                        system.debug('called 22 repairSRTManualClaim>>>>>');               
                    }
                    List<CSS_Solution_Component__c> lstFASolComp = new List<CSS_Solution_Component__c>();
                    for(CSS_Solution_Component__c solutionComp : Trigger.new){
                        if(solutionComp.Service_Job__c != null && (solutionComp.Type__c == 'Campaign' || solutionComp.Type__c == 'TRP' || solutionComp.Type__c == 'ATC')){
                            if(solutionComp.CSS_Account_Formula__c != Trigger.oldMap.get(solutionComp.Id).CSS_Account_Formula__c && solutionComp.CampaignPartsPercentage__c != null && solutionComp.CampaignPartsPercentage__c != '' && decimal.valueof(solutionComp.CampaignPartsPercentage__c) > 0){ 
                                lstFASolComp.add(solutionComp);
                            }
                        }
                    }
                    CG_CL_UpdateJob_FC_AC_ChildEntities contr = new CG_CL_UpdateJob_FC_AC_ChildEntities();
                    contr.updateFieldActionPartsFailCodeAccCode(lstFASolComp);
                }
            }
            // Anvesh add below code as part of defect GSSC-427
           else if(Trigger.isDelete){
                system.debug('Solcomp trigger call isDelete called');
            List<Id> lstClaimIdsODMFC = new List<Id>();
            for(CSS_Solution_Component__c solutionComp1 : trigger.old){
                    lstClaimIdsODMFC.add(solutionComp1.CSS_Claims__c);
                }
                system.debug(' lstClaimIdsODMFC  >> ' + lstClaimIdsODMFC);
                CG_CL_UpdateFailureODMStatus.updateODMStatusForFailuresCall(lstClaimIdsODMFC);
            }
        }
    }
    
    public class solCompWrapper{
        public id solID{get;set;}
        public id jobID{get;set;}
        public string serviceModel{get;set;}
        public string equipID{get;set;}
        public id compID{get;set;}
        public string efc{get;set;}
        public string compoName{get;set;}
        public string jobName{get;set;}
        public decimal claimID{get;set;}
        public string failCode;
        public string accountCode;
        public string type;
        public string CoveredLaborHrs;
        public string CampaignLaborPercentage;
        public solCompWrapper(id solID,id jobID,string serviceModel,string equipID,id compID,string efc,string compoName,string jobName,decimal claimId,string failCode,string accountCode,string type,string CoveredLaborHrs,string CampaignLaborPercentage){
            this.solID = solID;
            this.jobID = jobID;
            this.serviceModel = serviceModel;
            this.equipID = equipID;
            this.compID = compID;
            this.efc = efc;            
            this.compoName = compoName;
            this.jobName = jobName;
            this.claimId = claimId;
            this.failCode = failCode;
            this.accountCode = accountCode;
            this.type = type;
            this.CoveredLaborHrs = CoveredLaborHrs;
            this.CampaignLaborPercentage = CampaignLaborPercentage;
        }
    }
}