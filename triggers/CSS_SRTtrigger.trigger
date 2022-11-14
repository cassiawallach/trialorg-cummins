trigger CSS_SRTtrigger on CSS_SRT__c (Before insert, Before update, Before delete, After insert, After update, After delete) {
    system.debug('SRT Trigger call');
    Id serJobId;
    Id claimId;
    List<CSS_SRT__c> lstSRTjob = new List<CSS_SRT__c>();
    List<CSS_SRT__c> lstSRTclaim = new List<CSS_SRT__c>();
    List<CSS_SRT__c> lstSRTjobDel = new List<CSS_SRT__c>();
    List<CSS_SRT__c> lstSRTclaimDel = new List<CSS_SRT__c>();
    Set<Id> setSRTjob = new Set<Id>();
    Set<Id> setSRTclaim = new Set<Id>();
    List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
    List<CSS_SRT__c> SRTHrsExtendedJob;
    List<CSS_SRT__c> SRTHrsExtendedClaims;
    if(trigger.isBefore){
        if(trigger.isInsert){
            for(CSS_SRT__c srtNew : trigger.new){
                if(!string.isBlank(srtNew.Job_Order__c)){
                    serJobId = srtNew.Job_Order__c;
                }
                if(!string.isBlank(srtNew.CSS_Claims__c)){
                    claimId = srtNew.CSS_Claims__c;
                }
                if(srtNew.Job_Order__c != null && srtNew.Type__c!=null && srtNew.isPerformed__c!=null ){
                    if(((srtNew.isPerformed__c == true && !srtNew.Type__c.contains('Overlap') && !srtNew.Type__c.contains('Campaign') && !srtNew.Type__c.contains('TRP') && !srtNew.Type__c.contains('ATC') && !srtNew.Type__c.contains('Field Action')))
                       || (srtNew.isPerformed__c == true && srtNew.Component_Id__r.Performed_Review__c==true && (srtNew.Component_Id__r.Type__c.equalsIgnoreCase('Campaign') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('ATC') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('TRP'))))
                    {
                        lstSRTjob.add(srtNew);
                    }
                }
                else if(srtNew.CSS_Claims__c != null){
                    if(((srtNew.isPerformed__c == true && !srtNew.Type__c.contains('Overlap') && !srtNew.Type__c.contains('Campaign') && !srtNew.Type__c.contains('TRP') && !srtNew.Type__c.contains('ATC') && !srtNew.Type__c.contains('Field Action')))
                       || (srtNew.isPerformed__c == true && srtNew.Component_Id__r.Performed_Review__c==true && (srtNew.Component_Id__r.Type__c.equalsIgnoreCase('Campaign') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('ATC') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('TRP'))))
                    {
                        system.debug('SRT Claim is getting insert>>'+srtNew);
                        lstSRTclaim.add(srtNew);
                    }
                }
            }
            if(serJobId!=null){
                SRTHrsExtendedJob = new List<CSS_SRT__c>([Select id, Flex_Flag__c, Extended_Hours__c,type__c,SRT_Time__c,Job_Order__c, Solution_Number__c ,SRT_Category__c,isPerformed__c
                                                          from CSS_SRT__c where Job_Order__c =: serJobId AND
                                                          ((isPerformed__c=true and Type__c NOT IN ('Campaign','ATC','TRP','Overlap','Field Action')) 
                                                           OR ( isPerformed__c=true AND Component_Id__r.Performed_Review__c=true AND Component_Id__r.Type__c IN ('Campaign','ATC','TRP')))]);
                system.debug(' Trigger Query Initail SRTHrsExtendedJob>>' + SRTHrsExtendedJob);
            }
            if(claimId!=null){
                SRTHrsExtendedClaims = new List<CSS_SRT__c>([Select id, Flex_Flag__c, Extended_Hours__c,type__c,SRT_Time__c,Job_Order__c, Solution_Number__c ,SRT_Category__c,isPerformed__c
                                                             from CSS_SRT__c where CSS_Claims__c =: claimId AND
                                                             ((isPerformed__c=true and Type__c NOT IN ('Campaign','ATC','TRP','Overlap','Field Action')) 
                                                              OR ( isPerformed__c=true AND Component_Id__r.Selected_Component__c=true AND Component_Id__r.Type__c IN ('Campaign','ATC','TRP')))]);
                system.debug('Trigger Query Initail SRTHrsExtendedClaims>>' + SRTHrsExtendedClaims);
            }
            if(SRTHrsExtendedJob!=null && SRTHrsExtendedJob.size() > 0){
                lstSRTjob.addAll(SRTHrsExtendedJob);
            }
            if(SRTHrsExtendedClaims!=null && SRTHrsExtendedClaims.size() > 0){
                lstSRTclaim.addAll(SRTHrsExtendedClaims);
            }
            system.debug('**lstSRTclaim size**'+lstSRTclaim.size());
            if(lstSRTjob.size()>0 || lstSRTclaim.size()>0)
                CG_CL_TotalSRTHoursCalculation.CalcualteExthrs(lstSRTjob, lstSRTclaim, serJobId, claimId);
        }
        else if(trigger.isUpdate && RecursiveTriggerHandler.isFirstTimeSRTsTriggerBeforeUpdate == true){
            RecursiveTriggerHandler.isFirstTimeSRTsTriggerBeforeUpdate = false;
            /*
            for(CSS_SRT__c srtNew : trigger.new){
                if(!string.isBlank(srtNew.Job_Order__c)){
                    serJobId = srtNew.Job_Order__c;
                }
                if(!string.isBlank(srtNew.CSS_Claims__c)){
                    claimId = srtNew.CSS_Claims__c;
                }
                if(srtNew.Job_Order__c != null && srtNew.Type__c!=null && srtNew.isPerformed__c!=null ){
                    if(((srtNew.isPerformed__c == true && !srtNew.Type__c.contains('Overlap') && !srtNew.Type__c.contains('Campaign') && !srtNew.Type__c.contains('TRP') && !srtNew.Type__c.contains('ATC') && !srtNew.Type__c.contains('Field Action')))
                       || (srtNew.isPerformed__c == true && srtNew.Component_Id__r.Performed_Review__c==true && (srtNew.Component_Id__r.Type__c.equalsIgnoreCase('Campaign') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('ATC') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('TRP'))))
                    {
                        lstSRTjob.add(srtNew);
                        setSRTjob.add(srtNew.Id);
                    }
                }
                else if(srtNew.CSS_Claims__c != null){
                    if(((srtNew.isPerformed__c == true && !srtNew.Type__c.contains('Overlap') && !srtNew.Type__c.contains('Campaign') && !srtNew.Type__c.contains('TRP') && !srtNew.Type__c.contains('ATC') && !srtNew.Type__c.contains('Field Action')))
                       || (srtNew.isPerformed__c == true && srtNew.Component_Id__r.Performed_Review__c==true && (srtNew.Component_Id__r.Type__c.equalsIgnoreCase('Campaign') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('ATC') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('TRP'))))
                    {
                        lstSRTclaim.add(srtNew);
                        setSRTclaim.add(srtNew.Id);
                    }
                }
            }
            if(serJobId!=null){
                SRTHrsExtendedJob = new List<CSS_SRT__c>([Select id, Extended_Hours__c,type__c,Job_Order__c, Solution_Number__c ,SRT_Category__c,isPerformed__c
                                                          from CSS_SRT__c where Job_Order__c =: serJobId AND
                                                          ((isPerformed__c=true and Type__c NOT IN ('Campaign','ATC','TRP','Overlap','Field Action')) 
                                                           OR ( isPerformed__c=true AND Component_Id__r.Performed_Review__c=true AND Component_Id__r.Type__c IN ('Campaign','ATC','TRP')))]);
                system.debug(' Trigger Query Initail SRTHrsExtendedJob>>' + SRTHrsExtendedJob);
            }
            if(claimId!=null){
                SRTHrsExtendedClaims = new List<CSS_SRT__c>([Select id, Extended_Hours__c,type__c,Job_Order__c, Solution_Number__c ,SRT_Category__c,isPerformed__c
                                                             from CSS_SRT__c where CSS_Claims__c =: claimId AND
                                                             ((isPerformed__c=true and Type__c NOT IN ('Campaign','ATC','TRP','Overlap','Field Action')) 
                                                              OR ( isPerformed__c=true AND Component_Id__r.Selected_Component__c=true AND Component_Id__r.Type__c IN ('Campaign','ATC','TRP')))]);
                system.debug('Trigger Query Initail SRTHrsExtendedClaims>>' + SRTHrsExtendedClaims);
            }
            if(SRTHrsExtendedJob!=null && SRTHrsExtendedJob.size() > 0){
                for(CSS_SRT__c srtOld : SRTHrsExtendedJob){
                    if(!setSRTjob.contains(srtOld.Id)){
                        lstSRTjob.add(srtOld);
                    }
                }
            }
            if(SRTHrsExtendedClaims!=null && SRTHrsExtendedClaims.size() > 0){
                for(CSS_SRT__c srtOld : SRTHrsExtendedClaims){
                    if(!setSRTclaim.contains(srtOld.Id)){
                        lstSRTclaim.add(srtOld);
                    }
                }
            }
            //if(lstSRTjob.size()>0 || lstSRTclaim.size()>0) //commented by RAJESH 3rd May 2019
            CG_CL_TotalSRTHoursCalculation.CalcualteExthrs(lstSRTjob,lstSRTclaim,serJobId,claimId);
            */
        }
        else if(trigger.isDelete){
            claimsAuditLst = [SELECT Id, isServicejob__c, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c, Remove_Message__c
                          FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_SRT__c' ORDER BY Sort_Order__c ASC];
            CG_CL_ClaimsAuditTrailEventHandler.onDeleteSRT(Trigger.old, claimsAuditLst);
            
            for(CSS_SRT__c srtNew : trigger.old){
                if(!string.isBlank(srtNew.Job_Order__c)){
                    serJobId = srtNew.Job_Order__c;
                }
                if(!string.isBlank(srtNew.CSS_Claims__c)){
                    claimId = srtNew.CSS_Claims__c;
                }
                if(srtNew.Job_Order__c != null){
                    if(((srtNew.isPerformed__c == true && !srtNew.Type__c.contains('Overlap') && !srtNew.Type__c.contains('Campaign') && !srtNew.Type__c.contains('TRP') && !srtNew.Type__c.contains('ATC') && !srtNew.Type__c.contains('Field Action')))
                       || (srtNew.isPerformed__c == true && srtNew.Component_Id__r.Performed_Review__c==true && (srtNew.Component_Id__r.Type__c.equalsIgnoreCase('Campaign') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('ATC') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('TRP'))))
                    {
                        lstSRTjob.add(srtNew);
                        setSRTjob.add(srtNew.Id);
                    }
                }
                else if(srtNew.CSS_Claims__c != null){
                    if(((srtNew.isPerformed__c == true && !srtNew.Type__c.contains('Overlap') && !srtNew.Type__c.contains('Campaign') && !srtNew.Type__c.contains('TRP') && !srtNew.Type__c.contains('ATC') && !srtNew.Type__c.contains('Field Action')))
                       || (srtNew.isPerformed__c == true && srtNew.Component_Id__r.Performed_Review__c==true && (srtNew.Component_Id__r.Type__c.equalsIgnoreCase('Campaign') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('ATC') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('TRP'))))
                    {
                        system.debug('SRT Claim is getting delete>>'+srtNew);
                        lstSRTclaim.add(srtNew);
                        setSRTclaim.add(srtNew.Id);
                    }
                }
            }
            if(serJobId!=null){
                SRTHrsExtendedJob = new List<CSS_SRT__c>([Select id, Flex_Flag__c, Extended_Hours__c,type__c,SRT_Time__c,Job_Order__c, Solution_Number__c ,SRT_Category__c,isPerformed__c
                                                          from CSS_SRT__c where Job_Order__c =: serJobId AND
                                                          ((isPerformed__c=true and Type__c NOT IN ('Campaign','ATC','TRP','Overlap','Field Action')) 
                                                           OR ( isPerformed__c=true AND Component_Id__r.Performed_Review__c=true AND Component_Id__r.Type__c IN ('Campaign','ATC','TRP')))]);
                system.debug(' Trigger Query Initail SRTHrsExtendedJob>>' + SRTHrsExtendedJob);
            }
            if(claimId!=null){
                SRTHrsExtendedClaims = new List<CSS_SRT__c>([Select id, Flex_Flag__c, Extended_Hours__c,type__c,SRT_Time__c,Job_Order__c, Solution_Number__c ,SRT_Category__c,isPerformed__c
                                                             from CSS_SRT__c where CSS_Claims__c =: claimId AND
                                                             ((isPerformed__c=true and Type__c NOT IN ('Campaign','ATC','TRP','Overlap','Field Action')) 
                                                              OR ( isPerformed__c=true AND Component_Id__r.Selected_Component__c=true AND Component_Id__r.Type__c IN ('Campaign','ATC','TRP')))]);
                system.debug('Trigger Query Initail SRTHrsExtendedClaims>>' + SRTHrsExtendedClaims);
            }
            if(SRTHrsExtendedJob!=null && SRTHrsExtendedJob.size() > 0){
                for(CSS_SRT__c srtOld : SRTHrsExtendedJob){
                    if(!setSRTjob.contains(srtOld.Id)){
                        lstSRTjobDel.add(srtOld);
                    }
                }
            }
            if(SRTHrsExtendedClaims!=null && SRTHrsExtendedClaims.size() > 0){
                for(CSS_SRT__c srtOld : SRTHrsExtendedClaims){
                    if(!setSRTclaim.contains(srtOld.Id)){
                        lstSRTclaimDel.add(srtOld);
                    }
                }
            }
            //if(lstSRTjobDel.size()>0 || lstSRTclaimDel.size()>0)
            CG_CL_TotalSRTHoursCalculation.CalcualteExthrs(lstSRTjobDel,lstSRTclaimDel,serJobId,claimId);
        }
    }
    else if(trigger.isAfter){
        if(trigger.isInsert){
            System.debug('in isAfter & isInsert');
            claimsAuditLst = [SELECT Id, isServicejob__c, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c, Remove_Message__c
                              FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_SRT__c' ORDER BY Sort_Order__c ASC];
            CG_CL_ClaimsAuditTrailEventHandler.onInsertSRT(Trigger.new, claimsAuditLst);
            CG_CL_ClaimsAuditTrailEventHandler.onInsertaccessSRT(Trigger.new);
            
            //Code for updating Calibration error message - GSSC-30
            if(RecursiveTriggerHandler.isFirstTimeSRTsTriggerAfterInsert == true){  //101 SOQL issue fix
                RecursiveTriggerHandler.isFirstTimeSRTsTriggerAfterInsert = false;  //101 SOQL issue fix
                CG_UtilityForSRT.checkCalibFieldsForSRT(trigger.new);
            }
            
        }
        else if(trigger.isUpdate){
            System.debug('in isAfter & isUpdate');
                        
            //Code for updating Calibration error message - GSSC-30
            if(RecursiveTriggerHandler.isFirstTimeSRTsTriggerAfterUpdate == true){  //101 SOQL issue fix
                RecursiveTriggerHandler.isFirstTimeSRTsTriggerAfterUpdate = false;  //101 SOQL issue fix
                CG_UtilityForSRT.checkCalibFieldsForSRT(trigger.new);
                CG_CL_ClaimsAuditTrailEventHandler.onUpdateaccessSRT(Trigger.new, trigger.oldmap);
                System.debug('in isAfterupdate');
            }
            
            for(CSS_SRT__c srtNew : trigger.new){
                
                if(!string.isBlank(srtNew.Job_Order__c)){
                    serJobId = srtNew.Job_Order__c;
                }
                if(!string.isBlank(srtNew.CSS_Claims__c)){
                    claimId = srtNew.CSS_Claims__c;
                }
                if(srtNew.Job_Order__c != null && srtNew.Type__c!=null && srtNew.isPerformed__c!=null ){
                    if(((srtNew.isPerformed__c == true && !srtNew.Type__c.contains('Overlap') && !srtNew.Type__c.contains('Campaign') && !srtNew.Type__c.contains('TRP') && !srtNew.Type__c.contains('ATC') && !srtNew.Type__c.contains('Field Action')))
                       || (srtNew.isPerformed__c == true && srtNew.Component_Id__r.Performed_Review__c==true && (srtNew.Component_Id__r.Type__c.equalsIgnoreCase('Campaign') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('ATC') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('TRP'))))
                    {
                        lstSRTjob.add(srtNew);
                        setSRTjob.add(srtNew.Id);
                    }
                }
                else if(srtNew.CSS_Claims__c != null){
                    if(((srtNew.isPerformed__c == true && !srtNew.Type__c.contains('Overlap') && !srtNew.Type__c.contains('Campaign') && !srtNew.Type__c.contains('TRP') && !srtNew.Type__c.contains('ATC') && !srtNew.Type__c.contains('Field Action')))
                       || (srtNew.isPerformed__c == true && srtNew.Component_Id__r.Performed_Review__c==true && (srtNew.Component_Id__r.Type__c.equalsIgnoreCase('Campaign') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('ATC') || srtNew.Component_Id__r.Type__c.equalsIgnoreCase('TRP'))))
                    {
                        lstSRTclaim.add(srtNew);
                        setSRTclaim.add(srtNew.Id);
                    }
                }
            }
            
            //if(lstSRTjob.size()>0 || lstSRTclaim.size()>0) //commented by RAJESH 3rd May 2019
            //CG_CL_TotalSRTHoursCalculation.CalcualteExthrs(lstSRTjob,lstSRTclaim,serJobId,claimId);//---> commented by krishna for GSSC-191
            
            if(RecursiveTriggerHandler.isFirstTimeSRTsTriggerAfterUpdate) {
                RecursiveTriggerHandler.isFirstTimeSRTsTriggerAfterUpdate = false;
                if(serJobId!=null){
                    SRTHrsExtendedJob = new List<CSS_SRT__c>([Select id, Flex_Flag__c, Extended_Hours__c,type__c,SRT_Time__c,Job_Order__c, Solution_Number__c ,SRT_Category__c,isPerformed__c
                                                              from CSS_SRT__c where Job_Order__c =: serJobId AND
                                                              ((isPerformed__c=true and Type__c NOT IN ('Campaign','ATC','TRP','Overlap','Field Action')) 
                                                               OR ( isPerformed__c=true AND Component_Id__r.Performed_Review__c=true AND Component_Id__r.Type__c IN ('Campaign','ATC','TRP')))]);
                    system.debug(' Trigger Query Initail SRTHrsExtendedJob>>' + SRTHrsExtendedJob);
                }
                if(claimId!=null){
                    SRTHrsExtendedClaims = new List<CSS_SRT__c>([Select id, Extended_Hours__c,Flex_Flag__c,SRT_Time__c,type__c,Job_Order__c, Solution_Number__c ,SRT_Category__c,isPerformed__c
                                                                 from CSS_SRT__c where CSS_Claims__c =: claimId AND
                                                                 ((isPerformed__c=true and Type__c NOT IN ('Campaign','ATC','TRP','Overlap','Field Action')) 
                                                                  OR ( isPerformed__c=true AND Component_Id__r.Selected_Component__c=true AND Component_Id__r.Type__c IN ('Campaign','ATC','TRP')))]);
                    system.debug('Trigger Query Initail SRTHrsExtendedClaims>>' + SRTHrsExtendedClaims);
                }
                if(SRTHrsExtendedJob!=null && SRTHrsExtendedJob.size() > 0){
                    for(CSS_SRT__c srtOld : SRTHrsExtendedJob){
                        if(!setSRTjob.contains(srtOld.Id)){
                            lstSRTjob.add(srtOld);
                        }
                    }
                }
                if(SRTHrsExtendedClaims!=null && SRTHrsExtendedClaims.size() > 0){
                    for(CSS_SRT__c srtOld : SRTHrsExtendedClaims){
                        if(!setSRTclaim.contains(srtOld.Id)){
                            lstSRTclaim.add(srtOld);
                        }
                    }
                }
                CG_CL_TotalSRTHoursCalculation.CalcualteExthrs(lstSRTjob,lstSRTclaim,serJobId,claimId);     //---> Added by krishna for GSSC-191
                claimsAuditLst = [SELECT Id, isServicejob__c, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c, Remove_Message__c
                                  FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_SRT__c' ORDER BY Sort_Order__c ASC];
                CG_CL_ClaimsAuditTrailEventHandler.onUpdateSRT(Trigger.new, trigger.oldmap, claimsAuditLst);
                CG_CL_ClaimsAuditTrailEventHandler.onUpdateaccessSRT(Trigger.new, trigger.oldmap);
            } 
            
        }else if(trigger.isDelete){
            System.debug('in isAfter & isDelete');
            CG_CL_ClaimsAuditTrailEventHandler.onDeleteacessSRT(trigger.old);
            //Code for updating Calibration error message - GSSC-30
            CG_UtilityForSRT.checkCalibFieldsForSRT(trigger.old);
            
          //  Id claimIdODM;
            List<Id> lstClaimIdsODM = new List<Id>();
             for(CSS_SRT__c srtNew1 : trigger.old){
                 
                if(!string.isBlank(srtNew1.CSS_Claims__c)){
                 lstClaimIdsODM.add(srtNew1.CSS_Claims__c);
                }
             }
            
            system.debug(' lstClaimIdsODM ' + lstClaimIdsODM);
            CG_CL_UpdateSRTODMStatus.updateSRTODMStatusMethod(lstClaimIdsODM);
        }
    }
}