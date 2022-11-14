trigger CSS_PSNTrigger on CSS_PSN__c (before update, after insert, after update, before delete){
    system.debug('enterintoPSNTRIGGER');
    List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>(); 
    if(trigger.isDelete){
        claimsAuditLst = [SELECT Id, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c
                                                    FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_PSN__c' ORDER BY Sort_Order__c ASC];
        CG_CL_ClaimsAuditTrailEventHandler.onDeletePSN(Trigger.old, claimsAuditLst);
    }
    else{
        //Added below if else if as part of the defect # 189704
        if(trigger.isAfter && trigger.isInsert){
            claimsAuditLst = [SELECT Id, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c
                                                    FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_PSN__c' ORDER BY Sort_Order__c ASC];
            CG_CL_ClaimsAuditTrailEventHandler.onInsertPSN(Trigger.new, claimsAuditLst);
            
            //Code for updating Calibration error message - GSSC-30
            CG_UtilityForSRT.checkCalibFieldsForClaim(trigger.new);
        }
        else if(trigger.isAfter && trigger.isUpdate){
            claimsAuditLst = [SELECT Id, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c
                                                    FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_PSN__c' ORDER BY Sort_Order__c ASC];
            CG_CL_ClaimsAuditTrailEventHandler.onUpdatePSN(Trigger.new, trigger.oldmap, claimsAuditLst);
            
            //Code for updating Calibration error message - GSSC-30
            CG_UtilityForSRT.checkCalibFieldsForClaim(trigger.new);
            
        }
        for(CSS_PSN__c psnRec : Trigger.new) {
            system.debug('PsnRec.CSS_Claims__r' + PsnRec.CSS_Claims__r);
            system.debug('PsnRec.CSS_Claims__r.IsCopyclaim__c --- ' + PsnRec.CSS_Claims__r.IsCopyclaim__c);
            if(psnRec.Primary__c == null || psnRec.Primary__c == false || psnRec.Primary__c !=true){
                //Commented below if as part of the defect # 189704
                /*if(Trigger.isAfter){
                    if(Trigger.isInsert){
                        claimsAuditLst = [SELECT Id, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c
                                                    FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_PSN__c' ORDER BY Sort_Order__c ASC];
                        CG_CL_ClaimsAuditTrailEventHandler.onInsertPSN(Trigger.new, claimsAuditLst);
                    }
                }*/
                continue;
            }
            system.debug('****psnRec.Siebel_Claim_No__c***'+psnRec.Siebel_Claim_No__c);
            if(psnRec.Siebel_Claim_No__c == null || psnRec.Siebel_Claim_No__c == null) {
                system.debug('****enter into trigger part***');
                if(Trigger.isbefore){
                    if(Trigger.IsUpdate){
                        CG_CL_PSNTriggerHandler.onBeforeUpdate(trigger.new,trigger.oldmap);
                    }
                }
    
                if(Trigger.isAfter){
                    if(Trigger.isInsert){
                        system.debug('in trigger isInsert***');
                        Map<Id,String> mJobESN = new Map<Id,String>();
                        CG_BL_campaigns.callPSNAfterInsert(Trigger.new);
                        //CG_CL_PSNTriggerHandler.callGetServiceProviderDataClaimsonAfterUpdate(Trigger.new);
                        CSS_MakeAndModel.updateEquipmentId(Trigger.new);
                        for(CSS_PSN__c psn : trigger.New){
                            mJobESN.put(psn.CSS_Claims__c,psn.PSN__c);                                   
                        }
    
                        if(system.isFuture()==false){
                            if(!Test.isRunningTest()){
                                System.debug('calling Options PSN INSERT ' + mJobESN);
                                CSS_QuickServe.getJobOptions(mJobESN, true);
                            }
                        }
                    }
                    
                    if(Trigger.isUpdate){
                        system.debug('in trigger isUpdate***');
     //start code as per Story $189313,-By RAJESH 22nd July 2019
            /*    for( CSS_PSN__c psnRecId : Trigger.new) {
                    if(psnRecId.Mileage__c!=trigger.oldMap.get(psnRecId.Id).Mileage__c || psnRecId.ApplicationCode__c!=trigger.oldMap.get(psnRecId.Id).ApplicationCode__c || psnRecId.Mileage_Measure__c!=trigger.oldMap.get(psnRecId.Id).Mileage_Measure__c || psnRecId.Product_Hours__c!=trigger.oldMap.get(psnRecId.Id).Product_Hours__c ){
                        if(psnRecId.Mileage__c != null && psnRecId.ApplicationCode__c != null && psnRecId.Mileage_Measure__c != null && psnRecId.Product_Hours__c != null){
                            system.debug('**enter inside calling the getWarrantyDetailsCoverage service**');
                            set<id> claimRecIds = new set<id>();
                            for(integer i=0;i<trigger.new.size();i++){
                                system.debug('**New PSN Rec Ids**'+trigger.new[i].id);
                                system.debug('**New Claim Rec Ids**'+trigger.new[i].CSS_Claims__c);
                                claimRecIds.add(trigger.new[i].CSS_Claims__c);
                            }
                            CG_GetWarrantyDetailesHelper.getWarrantyDetailesForPSN(claimRecIds);
                        }
                    }
                }    */
      //End code as per Story $189313,-By RAJESH 22nd July 2019
                        Map<Id,String> mJobESN = new Map<Id,String>();
                        CG_BL_Campaigns.callPSNAfterUpdate(Trigger.new,Trigger.oldmap);
                        //EquipmentId and Access udpate changes
                        if((Trigger.new[0].Qsol_Engine_Family_Code__c != Trigger.oldMap.get(Trigger.new[0].Id).Qsol_Engine_Family_Code__c) || (Trigger.new[0].Make__c != Trigger.oldMap.get(Trigger.new[0].Id).Make__c) || (Trigger.new[0].Model__c != Trigger.oldMap.get(Trigger.new[0].Id).Model__c))
                            CSS_MakeAndModel.updateEquipmentId(Trigger.new);
                        //CSS_MakeAndModel.updateEquipmentId(Trigger.new, Trigger.oldMap);
                        for(CSS_PSN__c psn : trigger.New) {
                            if(psn.PSN__c != Trigger.oldMap.get(psn.Id).PSN__c) 
                                mJobESN.put(psn.CSS_Claims__c,psn.PSN__c);                                   
                        }
                        if(!system.isFuture() && !Test.isRunningTest()){               
                            System.debug('calling Options PSN UPDATE ' + mJobESN);
                            CSS_QuickServe.getJobOptions(mJobESN, true);
                        }
                        //Commented below 2 lines as part of the defect # 189704
                        /*claimsAuditLst = [SELECT Id, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c
                                                    FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_PSN__c' ORDER BY Sort_Order__c ASC];
                        CG_CL_ClaimsAuditTrailEventHandler.onUpdatePSN(Trigger.new, trigger.oldmap, claimsAuditLst);*/
                    }
                }
            }
        }
    }
}