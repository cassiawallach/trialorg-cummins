/**********************************************************************
Name:CG_CL_ClaimsAuditTrailEventHandler
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this triggerhandler for inserting audit trail records in custom history object.
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR            DATE                DETAIL  
1.0 -   Vignesh/Rajkumar    2/20/2019      Added code as part of user story 167968
1.1 -   Rajkumar/Vignesh    4/22/2019      Added code as part of user story 179211
2.0 -   Rajkumar/Vignesh    4/23/2019      Added code for FC, POC, SRT, WO stories
3.0 -   Prabhakar           12/16/2019     Added code as part of story GSSC-444
**********************************************************************************************/
public class CG_CL_ClaimsAuditTrailEventHandler {
    public static void onInsertClaim(List<CSS_Claims__c> newList, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            //Added code for GSSC-262
            list<CSS_Claims__c> newClaimModiRec = new list<CSS_Claims__c>();
            for(CSS_Claims__c claimsObj : newList){
                for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                    if(auditRec.Object_Name__c == 'CSS_Claims__c'){
                        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                        //Added code for GSSC-262
                        CSS_Claims__c newClaimRec = new CSS_Claims__c();
                        if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Add')){
                            String newValue = String.valueOf(claimsObj.get(auditRec.Field_Name__c));
                            claimHistory.CSS_Job_Id__c = claimsObj.Id;
                            claimHistory.CSS_Object_Name__c = 'CSS_Claims__c';
                            claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                            claimHistory.CSS_New_Value__c = newValue;
                            system.debug('auditRec.Message__c-->'+auditRec.Message__c);
                            if(auditRec.Field_Name__c == 'Catastrophic__c'){
                                if(claimsObj.get(auditRec.Field_Name__c) == true){
                                    claimHistory.Audit_Message__c = auditRec.Message__c;
                                }
                                else{
                                    continue;
                                }
                            }
                            else{
                                if(auditRec.Dynamic_Message__c == true){
                                    if(newValue != null){
                                        claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue',newValue);
                                    }
                                    else{
                                        continue; 
                                    }
                                }
                                else{
                                    claimHistory.Audit_Message__c = auditRec.Message__c;
                                }
                            }

                            system.debug('**outside if claimsObj.Id**'+claimsObj.Id);
                            newClaimRec.id                        = claimsObj.id;
                            newClaimRec.Last_saved_by__c          = userInfo.getName();
                            //newClaimRec.Last_Saved__c             = css_utility.getFormattedDate(claimsObj.LastModifiedDate);
                            newClaimRec.LastSavedDate__c = claimsObj.LastModifiedDate;
                            //Added code for GSSC-262 
                            if(newClaimRec.LastSavedDate__c !=null && newClaimRec.Last_saved_by__c!=null && !newClaimModiRec.contains(newClaimRec)){
                                newClaimModiRec.add(newClaimRec);
                            }

                            if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                claimHistoryLst.add(claimHistory);
                            }
                        }
                    }
                }
            }
            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
            //Added code for GSSC-262
            if(newClaimModiRec!=null && newClaimModiRec.size()>0)
                update newClaimModiRec;    
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onInsertClaim method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }

    public static void onUpdateClaim(List<CSS_Claims__c> newList,Map<id,CSS_Claims__c> oldMap, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            system.debug('Inside Envent Handler Update**');
            //Added code for GSSC-262
            list<CSS_Claims__c> newClaimModiRec = new list<CSS_Claims__c>();
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            for(CSS_Claims__c claimsObj : newList){
                CSS_Claims__c oldClaim = oldMap.get(claimsObj.id);
                for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                    if(auditRec.Object_Name__c == 'CSS_Claims__c'){
                        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                        //Added code for GSSC-262
                        CSS_Claims__c newClaimRec = new CSS_Claims__c();
                        if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Edit')){
                            system.debug('first-->'+claimsObj.get(auditRec.Field_Name__c));
                            system.debug('second-->'+oldClaim.get(auditRec.Field_Name__c));
                            if(claimsObj.get(auditRec.Field_Name__c) == oldClaim.get(auditRec.Field_Name__c))
                                continue;

                            String oldValue = String.valueOf(oldClaim.get(auditRec.Field_Name__c));
                            String newValue = String.valueOf(claimsObj.get(auditRec.Field_Name__c));

                            if(oldValue == null || oldValue == '') 
                                oldValue = 'Blank';

                            if(newValue == null || newValue == '')
                                newValue = 'Blank';

                            claimHistory.CSS_Job_Id__c = claimsObj.Id;
                            claimHistory.CSS_Object_Name__c = 'CSS_Claims__c';
                            claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                            claimHistory.CSS_New_Value__c = newValue;
                            claimHistory.CSS_Old_Value__c =oldValue;
                            system.debug('****auditRec.Dynamic_Message__c**'+auditRec.Dynamic_Message__c);
                            if(auditRec.Dynamic_Message__c == true){
                                if(auditRec.Field_Name__c == 'Actual_Technician_Time__c'){ 
                                    if(oldValue == 'Blank' && newValue != 'Blank'){
                                        claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue',newValue);
                                    }
                                    else if(oldValue != 'Blank' && newValue != 'Blank'){
                                        claimHistory.Audit_Message__c = auditRec.Edit_Message__c.replace('oldValue',oldValue);
                                        claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('newValue',newValue); 
                                    }
                                    else{
                                        claimHistory.Audit_Message__c = auditRec.Remove_Message__c.replace('oldValue',oldValue);
                                    }
                                    //Added code for GSSC-262
                                    newClaimRec.Id                  = claimsObj.Id;
                                    newClaimRec.Last_saved_by__c    = userInfo.getName();
                                    //newClaimRec.Last_Saved__c       = css_utility.getFormattedDate(claimsObj.LastModifiedDate);
                                    newClaimRec.LastSavedDate__c = claimsObj.LastModifiedDate;
                                }
                                else{
                                    claimHistory.Audit_Message__c = auditRec.Message__c.replace('oldValue',oldValue);
                                    claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('newValue',newValue);
                                    newClaimRec.Id                  = claimsObj.Id;
                                    newClaimRec.Last_saved_by__c    = userInfo.getName();
                                    //newClaimRec.Last_Saved__c       = css_utility.getFormattedDate(claimsObj.LastModifiedDate);
                                    newClaimRec.LastSavedDate__c = claimsObj.LastModifiedDate;


                                }
                            }
                            else{
                                if(auditRec.Field_Name__c != 'Status__c'){
                                    claimHistory.Audit_Message__c = auditRec.Message__c;
                                }
                                else{
                                    if(auditRec.Name.contains(newValue)){
                                        claimHistory.Audit_Message__c = auditRec.Message__c;
                                    }
                                }
                                newClaimRec.Id                  = claimsObj.Id;
                                newClaimRec.Last_saved_by__c    = userInfo.getName();
                                //newClaimRec.Last_Saved__c       = css_utility.getFormattedDate(claimsObj.LastModifiedDate);
                                newClaimRec.LastSavedDate__c = claimsObj.LastModifiedDate;
                            }
                            if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                claimHistoryLst.add(claimHistory);
                            }
                            //Added code for GSSC-262
                            if(newClaimRec.LastSavedDate__c !=null && newClaimRec.Last_saved_by__c!=null && !newClaimModiRec.contains(newClaimRec)){
                                newClaimModiRec.add(newClaimRec);
                            }
                        }
                    }
                }
            }

            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
            //Added code for GSSC-262
            if(newClaimModiRec!=null && newClaimModiRec.size()>0)
                update newClaimModiRec;
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onUpdateClaim method at line>>>>>>>>>>>>> ::  '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }

    public static void onInsertPSN(List<CSS_PSN__c> newList, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            list<CSS_Claims__c> newClaimModiRec = new list<CSS_Claims__c>();
            list<CSS_PSN__c> newPSNModiRec = new list<CSS_PSN__c>();
            system.debug('claimsAuditLst-->'+claimsAuditLst);
            system.debug('newList-->'+newList);
            for(CSS_PSN__c psnObj : newList){
                for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                    if(auditRec.Object_Name__c == 'CSS_PSN__c'){
                        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                        CSS_Claims__c newClaimRec = new CSS_Claims__c();
                        CSS_PSN__c    newPSNRec = new CSS_PSN__c();
                        if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Add')){
                            String newValue = String.valueOf(psnObj.get(auditRec.Field_Name__c));
                            claimHistory.CSS_Job_Id__c = psnObj.CSS_Claims__c;
                            claimHistory.CSS_Object_Name__c = 'CSS_PSN__c';
                            claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                            claimHistory.CSS_New_Value__c = newValue;
                            system.debug('auditRec.Message__c-->'+auditRec.Message__c);
                            if(auditRec.Field_Name__c == 'Name'){
                                if(psnObj.get('Primary__c') != true){
                                    claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue', newValue);
                                }
                                else{
                                    continue;
                                }
                            }
                            else{
                                if(auditRec.Dynamic_Message__c == true){
                                    if(newValue != null){
                                        claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue',newValue);
                                    }
                                    else{
                                        continue;
                                    }
                                }
                                else{
                                    claimHistory.Audit_Message__c = auditRec.Message__c;
                                }
                            }
                            //Added code for GSSC-262
                            system.debug('**outside if psnObj.Id**'+psnObj.Id);
                            newPSNRec.Id                          = psnObj.Id;
                            newClaimRec.id                        = psnObj.CSS_Claims__c;
                            system.debug('**userInfo.getName()**'+userInfo.getName());
                            newClaimRec.Last_saved_by__c          = userInfo.getName();
                            system.debug('**newPSNRec.Last_saved_by__c**'+newClaimRec.Last_saved_by__c);
                            //newClaimRec.Last_Saved__c             = css_utility.getFormattedDate(psnObj.LastModifiedDate);
                            newClaimRec.LastSavedDate__c = psnObj.LastModifiedDate;
                            if(newClaimRec.LastSavedDate__c!=null && newClaimRec.Last_saved_by__c!=null && !newClaimModiRec.contains(newClaimRec)){
                                newClaimModiRec.add(newClaimRec);
                            }
                        }
                        if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                            claimHistoryLst.add(claimHistory);
                        }
                    }
                }
            }
            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
            //Added code for GSSC-262
            if(newClaimModiRec!=null && newClaimModiRec.size()>0)
                update newClaimModiRec;    
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onInsertPSN method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }

    public static void onUpdatePSN(List<CSS_PSN__c> newList,Map<id,CSS_PSN__c> oldMap, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            list<CSS_Claims__c> newClaimModiRec = new list<CSS_Claims__c>();
            list<CSS_PSN__c> newPSNModiRec = new list<CSS_PSN__c>();
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            system.debug('**newList**'+newList);
            for(CSS_PSN__c psnObj : newList){
                CSS_PSN__c oldPSN = oldMap.get(psnObj.id);
                for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                    if(auditRec.Object_Name__c == 'CSS_PSN__c'){
                        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                        CSS_Claims__c newClaimRec = new CSS_Claims__c();
                        CSS_PSN__c    newPSNRec = new CSS_PSN__c();
                        if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Edit')){
                            system.debug('first-->'+psnObj.get(auditRec.Field_Name__c));
                            system.debug('second-->'+oldPSN.get(auditRec.Field_Name__c));
                            if(psnObj.get(auditRec.Field_Name__c) == oldPSN.get(auditRec.Field_Name__c))
                                continue;

                            String oldValue;
                            String newValue;
                            if(!auditRec.Field_Name__c.contains('Date')){
                                oldValue = String.valueOf(oldPSN.get(auditRec.Field_Name__c));
                                newValue = String.valueOf(psnObj.get(auditRec.Field_Name__c));
                            }
                            else{
                                if(oldPSN.get(auditRec.Field_Name__c) != null){
                                    oldValue = css_utility.getFormattedDate(DateTime.valueOf(String.valueof(oldPSN.get(auditRec.Field_Name__c))));
                                }

                                else{
                                    oldValue = '';
                                }
                                if(psnObj.get(auditRec.Field_Name__c) != null){
                                    newValue = css_utility.getFormattedDate(DateTime.valueOf(String.valueof(psnObj.get(auditRec.Field_Name__c))));
                                }
                                else{
                                    newValue = '';
                                }
                                List<String> tempLst = new List<String>();
                                if(oldValue != ''){
                                    oldValue = oldValue.toUpperCase();
                                    tempLst = oldValue.split(' ');
                                    oldValue = tempLst[0]+' '+tempLst[1]+' '+tempLst[2];
                                }
                                if(newValue != ''){
                                    newValue = newValue.toUpperCase();
                                    tempLst = new List<String>();
                                    tempLst = newValue.split(' ');
                                    newValue = tempLst[0]+' '+tempLst[1]+' '+tempLst[2];
                                }
                            }

                            if(oldValue == null || oldValue == '')
                                oldValue = 'Blank';

                            if(newValue == null || newValue == '')
                                newValue = 'Blank';
                            system.debug('psnObj-->'+psnObj);
                            claimHistory.CSS_Job_Id__c = psnObj.CSS_Claims__c;
                            claimHistory.CSS_Object_Name__c = 'CSS_PSN__c';
                            claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                            claimHistory.CSS_New_Value__c = newValue;
                            claimHistory.CSS_Old_Value__c =oldValue;
                            if(auditRec.Dynamic_Message__c == true){
                                claimHistory.Audit_Message__c = auditRec.Message__c.replace('oldValue',oldValue);
                                claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('newValue',newValue);
                                if(auditRec.Field_Name__c.contains('Mileage__c')){
                                    claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('failureMeasure',String.valueof(psnObj.get('Mileage_Measure__c')));
                                }
                            }
                            else{
                                claimHistory.Audit_Message__c = auditRec.Message__c;
                            }
                            if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                claimHistoryLst.add(claimHistory);
                            }
                            //Added code for GSSC-262
                            system.debug('**outside if psnObj.Id**'+psnObj.Id);
                            newPSNRec.Id                          = psnObj.Id;
                            newClaimRec.id                        = psnObj.CSS_Claims__c;
                            system.debug('**userInfo.getName()**'+userInfo.getName());
                            newClaimRec.Last_saved_by__c          = userInfo.getName();
                            system.debug('**newPSNRec.Last_saved_by__c**'+newClaimRec.Last_saved_by__c);
                            //newClaimRec.Last_Saved__c             = css_utility.getFormattedDate(psnObj.LastModifiedDate);
                            newClaimRec.LastSavedDate__c = psnObj.LastModifiedDate;
                            if(newClaimRec.LastSavedDate__c!=null && newClaimRec.Last_saved_by__c!=null && !newClaimModiRec.contains(newClaimRec)){
                                newClaimModiRec.add(newClaimRec);
                            }
                        }


                    }
                }
            }
            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
            //Added code for GSSC-262
            if(newClaimModiRec!=null && newClaimModiRec.size()>0)
                update newClaimModiRec;
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onUpdatePSN method at line>>>>>>>>>>>>> ::  '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }

    public static void onDeletePSN(List<CSS_PSN__c> newList, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            list<CSS_Claims__c> newClaimModiRec = new list<CSS_Claims__c>();
            list<CSS_PSN__c> newPSNModiRec = new list<CSS_PSN__c>();
            for(CSS_PSN__c psnObj : newList){
                for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                    if(auditRec.Object_Name__c == 'CSS_PSN__c'){
                        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                        CSS_Claims__c newClaimRec = new CSS_Claims__c();
                        CSS_PSN__c    newPSNRec = new CSS_PSN__c();
                        if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Delete')){
                            String newValue = String.valueOf(psnObj.get(auditRec.Field_Name__c));
                            claimHistory.CSS_Job_Id__c = psnObj.CSS_Claims__c;
                            claimHistory.CSS_Object_Name__c = 'CSS_PSN__c';
                            claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                            claimHistory.CSS_New_Value__c = newValue;
                            system.debug('auditRec.Message__c-->'+auditRec.Message__c);
                            if(auditRec.Field_Name__c == 'Name'){
                                if(psnObj.get('Primary__c') != true){
                                    claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue', newValue);
                                }
                                else{
                                    continue;
                                }
                            }
                            else{
                                if(auditRec.Dynamic_Message__c == true){
                                    if(newValue != null){
                                        claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue',newValue);
                                    }
                                    else{
                                        continue;
                                    }
                                }
                                else{
                                    claimHistory.Audit_Message__c = auditRec.Message__c;
                                }
                            }
                            //Added code for GSSC-262
                            system.debug('**outside if psnObj.Id**'+psnObj.Id);
                            newPSNRec.Id                          = psnObj.Id;
                            newClaimRec.id                        = psnObj.CSS_Claims__c;
                            system.debug('**userInfo.getName()**'+userInfo.getName());
                            newClaimRec.Last_saved_by__c          = userInfo.getName();
                            system.debug('**newPSNRec.Last_saved_by__c**'+newClaimRec.Last_saved_by__c);
                            //newClaimRec.Last_Saved__c             = css_utility.getFormattedDate(psnObj.LastModifiedDate);
                            newClaimRec.LastSavedDate__c = psnObj.LastModifiedDate;
                            if(newClaimRec.LastSavedDate__c !=null && newClaimRec.Last_saved_by__c!=null && !newClaimModiRec.contains(newClaimRec)){
                                newClaimModiRec.add(newClaimRec);
                            }
                        }
                        if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                            claimHistoryLst.add(claimHistory);
                        }
                    }
                }
            }
            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
            //Added code for GSSC-262
            if(newClaimModiRec!=null && newClaimModiRec.size()>0)
                update newClaimModiRec;    
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onDeletePSN method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }

    //Commented below method as part of the story 179211
    /*public static void onInsertClaimSubmission(List<CSS_Claim_Submission__c> newList, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            for(CSS_Claim_Submission__c claimsSubObj : newList){
                for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                    if(auditRec.Object_Name__c == 'CSS_Claim_Submission__c'){
                        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                        if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Add')){
                            String newValue = String.valueOf(claimsSubObj.get(auditRec.Field_Name__c));
                            claimHistory.CSS_Job_Id__c = claimsSubObj.CSS_Claims__c;
                            claimHistory.CSS_Object_Name__c = 'CSS_Claim_Submission__c';
                            claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                            claimHistory.CSS_New_Value__c = newValue;
                            system.debug('auditRec.Message__c-->'+auditRec.Message__c);
                            if(auditRec.Dynamic_Message__c == true){
                                if(newValue != null){
                                    claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue',newValue);
                                }
                                else{
                                    continue; 
                                }
                            }
                            else{
                                claimHistory.Audit_Message__c = auditRec.Message__c;
                            }
                            claimHistoryLst.add(claimHistory);
                        }
                    }
                }
            }
            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onInsertClaimSubmission method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }*/

    public static void onInsertFC(List<CSS_Solution_Component__c> newList, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            system.debug('in onInsertFC method of audit trail class');
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            list<CSS_Claims__c> newClaimModiRec = new list<CSS_Claims__c>();
            for(CSS_Solution_Component__c fcObj : newList){
                if(fcObj.CSS_Claims__c != null){
                    for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                        if(auditRec.Object_Name__c == 'CSS_Solution_Component__c' && auditRec.isServicejob__c == false){
                            CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                            CSS_Claims__c newClaimRec = new CSS_Claims__c();
                            CSS_Solution_Component__c newSolComRec = new CSS_Solution_Component__c();
                            if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Add')){
                                String newValue = String.valueOf(fcObj.get(auditRec.Field_Name__c));
                                claimHistory.CSS_Job_Id__c = fcObj.CSS_Claims__c;
                                claimHistory.CSS_Object_Name__c = 'CSS_Solution_Component__c';
                                claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                                claimHistory.CSS_New_Value__c = newValue;
                                String fName = String.valueOf(fcObj.get('Name'));
                                if(auditRec.Field_Name__c == 'Name'){
                                    if(fcObj.get('Type__c') != 'Campaign' && fcObj.get('Type__c') != 'ATC' && fcObj.get('Type__c') != 'TRP'){
                                        claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue', newValue);
                                    }
                                    else{
                                        continue;
                                    }
                                }
                                else if(auditRec.Field_Name__c == 'Selected_Component__c'){
                                    if((fcObj.get('Type__c') == 'Campaign' || fcObj.get('Type__c') == 'ATC' || fcObj.get('Type__c') == 'TRP') && fcObj.get('Selected_Component__c') == true){
                                        claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue', fName);
                                    }
                                    else{
                                        continue;
                                    }
                                }
                                system.debug('claimHistory.Audit_Message__c-->'+claimHistory.Audit_Message__c);
                                //Added code for GSSC-262
                                system.debug('**outside if fcObj.Id**'+fcObj.Id);
                                newSolComRec.Id                          = fcObj.Id;
                                newClaimRec.id                        = fcObj.CSS_Claims__c;
                                system.debug('**userInfo.getName()**'+userInfo.getName());
                                newClaimRec.Last_saved_by__c          = userInfo.getName();
                                system.debug('**newPSNRec.Last_saved_by__c**'+newClaimRec.Last_saved_by__c);
                                //newClaimRec.Last_Saved__c             = css_utility.getFormattedDate(fcObj.LastModifiedDate);
                                newClaimRec.LastSavedDate__c = fcObj.LastModifiedDate;
                                if(newClaimRec.LastSavedDate__c !=null && newClaimRec.Last_saved_by__c!=null && !newClaimModiRec.contains(newClaimRec)){
                                    newClaimModiRec.add(newClaimRec);
                                }
                            }
                            if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                claimHistoryLst.add(claimHistory);
                            }
                        }
                    }
                }

            }
            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
            //Added code for GSSC-262
            if(newClaimModiRec!=null && newClaimModiRec.size()>0)
                update newClaimModiRec;    
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onInsertFC method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }

    public static void onUpdateFC(List<CSS_Solution_Component__c> newList,Map<id,CSS_Solution_Component__c> oldMap, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            List<CSS_Solutions__c>lstslns = [select id,name from CSS_Solutions__c where Service_Job__c=:newList[0].Service_Job__c];
            system.debug('newList-->'+newList);
            system.debug('oldMap-->'+oldMap);
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            list<CSS_Claims__c> newClaimModiRec = new list<CSS_Claims__c>();
            for(CSS_Solution_Component__c fcObj : newList){
                if(fcObj.CSS_Claims__c != null){
                    CSS_Solution_Component__c oldFailure = oldMap.get(fcObj.id);
                    for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                        if(auditRec.Object_Name__c == 'CSS_Solution_Component__c' && auditRec.isServicejob__c == false){
                            CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                            CSS_Claims__c newClaimRec = new CSS_Claims__c();
                            CSS_Solution_Component__c newSolComRec = new CSS_Solution_Component__c();
                            if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Edit')){
                                system.debug('first-->'+fcObj.get(auditRec.Field_Name__c));
                                system.debug('second-->'+oldFailure.get(auditRec.Field_Name__c));
                                if(fcObj.get(auditRec.Field_Name__c) == oldFailure.get(auditRec.Field_Name__c))
                                    continue;

                                String oldValue = String.valueOf(oldFailure.get(auditRec.Field_Name__c));
                                String newValue = String.valueOf(fcObj.get(auditRec.Field_Name__c));

                                if(oldValue == null || oldValue == '')
                                    oldValue = 'Blank';

                                if(newValue == null || newValue == '')
                                    newValue = 'Blank';
                                system.debug('fcObj-->'+fcObj);
                                claimHistory.CSS_Job_Id__c = fcObj.CSS_Claims__c;
                                claimHistory.CSS_Object_Name__c = 'CSS_Solution_Component__c';
                                claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                                claimHistory.CSS_New_Value__c = newValue;
                                claimHistory.CSS_Old_Value__c =oldValue;
                                String fName = String.valueOf(fcObj.get('Name'));
                                system.debug('fcObj.get(auditRec.Field_Name__c)-->'+fcObj.get(auditRec.Field_Name__c));
                                if(auditRec.Dynamic_Message__c == true){
                                    if(auditRec.Field_Name__c == 'Selected_Component__c'){ 
                                        if(fcObj.get(auditRec.Field_Name__c) == true){
                                            claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue',fName); 
                                            system.debug('claimHistory.Audit_Message__c-->'+claimHistory.Audit_Message__c);
                                        }
                                        else{
                                            claimHistory.Audit_Message__c = auditRec.Remove_Message__c.replace('newValue',fName);
                                            system.debug('claimHistory.Audit_Message__c-->'+claimHistory.Audit_Message__c);
                                        }
                                    }
                                    else{
                                        if(auditRec.Field_Name__c == 'CSS_Account_Formula__c' && fcObj.get('Type__c') != 'Campaign' && fcObj.get('Type__c') != 'ATC' && fcObj.get('Type__c') != 'TRP'){
                                            claimHistory.Audit_Message__c = auditRec.Message__c.replace('oldValue',oldValue);
                                            claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('newValue',newValue);
                                            claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('failureName',fName);
                                        }
                                        else if(auditRec.Field_Name__c != 'CSS_Account_Formula__c'){
                                            claimHistory.Audit_Message__c = auditRec.Message__c.replace('oldValue',oldValue);
                                            claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('newValue',newValue);
                                            claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('failureName',fName);
                                        }
                                    }
                                }
                                else{
                                    claimHistory.Audit_Message__c = auditRec.Message__c;
                                }
                                //Added code for GSSC-262
                                system.debug('**outside if fcObj.Id**'+fcObj.Id);
                                newSolComRec.Id                          = fcObj.Id;
                                newClaimRec.id                        = fcObj.CSS_Claims__c;
                                system.debug('**userInfo.getName()**'+userInfo.getName());
                                newClaimRec.Last_saved_by__c          = userInfo.getName();
                                system.debug('**newPSNRec.Last_saved_by__c**'+newClaimRec.Last_saved_by__c);
                                //newClaimRec.Last_Saved__c             = css_utility.getFormattedDate(fcObj.LastModifiedDate);
                                newClaimRec.LastSavedDate__c = fcObj.LastModifiedDate;
                                if(newClaimRec.LastSavedDate__c !=null && newClaimRec.Last_saved_by__c!=null && !newClaimModiRec.contains(newClaimRec)){
                                    newClaimModiRec.add(newClaimRec);
                                }


                                if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                    claimHistoryLst.add(claimHistory);
                                }
                                system.debug('Claim History Update FC -->'+claimHistory);
                            }
                        }
                    }
                }

            }
            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
            //Added code for GSSC-262
            if(newClaimModiRec!=null && newClaimModiRec.size()>0)
                update newClaimModiRec;    
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onUpdateFC method at line>>>>>>>>>>>>> ::  '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }

    public static void onDeleteFC(List<CSS_Solution_Component__c> newList, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            list<CSS_Claims__c> newClaimModiRec = new list<CSS_Claims__c>();
            for(CSS_Solution_Component__c fcObj : newList){
                if(fcObj.CSS_Claims__c != null){
                    for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                        if(auditRec.Object_Name__c == 'CSS_Solution_Component__c' && auditRec.isServicejob__c == false){
                            CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                            CSS_Claims__c newClaimRec = new CSS_Claims__c();
                            CSS_Solution_Component__c newSolComRec = new CSS_Solution_Component__c();
                            if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Delete')){
                                String newValue = String.valueOf(fcObj.get(auditRec.Field_Name__c));
                                claimHistory.CSS_Job_Id__c = fcObj.CSS_Claims__c;
                                claimHistory.CSS_Object_Name__c = 'CSS_Solution_Component__c';
                                claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                                claimHistory.CSS_New_Value__c = newValue;
                                system.debug('auditRec.Message__c-->'+auditRec.Message__c);
                                if(auditRec.Field_Name__c == 'Name'){
                                    if(fcObj.get('Type__c') != 'Campaign' && fcObj.get('Type__c') != 'ATC' && fcObj.get('Type__c') != 'TRP'){
                                        claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue', newValue);
                                    }
                                    else{
                                        continue;
                                    }
                                }
                                //Added code for GSSC-262
                                system.debug('**outside if fcObj.Id**'+fcObj.Id);
                                newSolComRec.Id                          = fcObj.Id;
                                newClaimRec.id                        = fcObj.CSS_Claims__c;
                                system.debug('**userInfo.getName()**'+userInfo.getName());
                                newClaimRec.Last_saved_by__c          = userInfo.getName();
                                system.debug('**newPSNRec.Last_saved_by__c**'+newClaimRec.Last_saved_by__c);
                                //newClaimRec.Last_Saved__c             = css_utility.getFormattedDate(fcObj.LastModifiedDate);
                                newClaimRec.LastSavedDate__c = fcObj.LastModifiedDate;
                                if(newClaimRec.LastSavedDate__c !=null && newClaimRec.Last_saved_by__c!=null && !newClaimModiRec.contains(newClaimRec)){
                                    newClaimModiRec.add(newClaimRec);
                                }
                            }
                            if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                claimHistoryLst.add(claimHistory);
                            }
                        }
                    }
                }
            }
            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
            //Added code for GSSC-262
            if(newClaimModiRec!=null && newClaimModiRec.size()>0)
                update newClaimModiRec;     
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onDeleteFC method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }

    public static void onInsertSRT(List<CSS_SRT__c> newList, List<CG_Claim_Audit_Log__c> claimsAuditLst){ 
        try{
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            list<CSS_Claims__c> newClaimModiRec = new list<CSS_Claims__c>();
            Id claimId = newList[0].CSS_Claims__c;
            List<CSS_Claims__c> claim = new List<CSS_Claims__c>();
            if(claimId != null){
                claim = [SELECT Id, CSS_Job__c, Dealer_Service_Job__c FROM CSS_Claims__c WHERE Id =: claimId AND (CSS_Job__c != null OR Dealer_Service_Job__c != null) LIMIT 1];
            }
            system.debug('claim-->'+claim.size());
            for(CSS_SRT__c srtObj : newList){
                if(srtObj.CSS_Claims__c != null){
                    for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                        if(auditRec.Object_Name__c == 'CSS_SRT__c' && auditRec.isServicejob__c == false){
                            CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                            CSS_SRT__c newSRTRec = new CSS_SRT__c();
                            CSS_Claims__c newClaimRec = new CSS_Claims__c();
                            if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Add')){
                                String newValue = String.valueOf(srtObj.get(auditRec.Field_Name__c));
                                claimHistory.CSS_Job_Id__c = srtObj.CSS_Claims__c;
                                claimHistory.CSS_Object_Name__c = 'CSS_SRT__c';
                                claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                                claimHistory.CSS_New_Value__c = newValue;
                                system.debug('auditRec.Message__c-->'+auditRec.Message__c);
                                String srtId = String.valueOf(srtObj.get('SRT_ID__c'));
                                system.debug('Selected??'+srtObj.get('isPerformed__c'));
                                system.debug('auditRec.Field_Name__c-->'+auditRec.Field_Name__c);
                                String srtType = String.valueOf(srtObj.get('Type__c'));
                                if(auditRec.Field_Name__c == 'Name'){
                                    if(srtObj.get('IsPopUpSRT__c') == true){
                                        claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue', srtId);
                                    }
                                }
                                else if(auditRec.Field_Name__c == 'isPerformed__c' && srtObj.get('isPerformed__c') == true && srtObj.get('IsPopUpSRT__c') == false && srtType != 'Overlap'){
                                    claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue', srtId);
                                    //claimHistory.System_Modified__c =  (srtId != '99-999' && claim.size() == 0) ? true : false;
                                    if(srtId != '99-999'){
                                        if(claim.size() == 0){
                                            claimHistory.System_Modified__c = true;
                                        }
                                        else if(claim.size() != 0 && srtObj.get('SRT_From_Job__c') != true){
                                            claimHistory.System_Modified__c = true;
                                        }
                                    }
                                }
                                //Added code for GSSC-262
                                system.debug('**outside if srtObj.Id**'+srtObj.Id);
                                newSRTRec.Id                          = srtObj.Id;
                                newClaimRec.id                        = srtObj.CSS_Claims__c;
                                newClaimRec.Last_saved_by__c          = userInfo.getName();
                                //newClaimRec.Last_Saved__c             = css_utility.getFormattedDate(srtObj.LastModifiedDate);
                                newClaimRec.LastSavedDate__c = srtObj.LastModifiedDate;
                                if(newClaimRec.LastSavedDate__c !=null && newClaimRec.Last_saved_by__c!=null && !newClaimModiRec.contains(newClaimRec)){
                                    newClaimModiRec.add(newClaimRec);
                                }
                            }
                            if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                claimHistoryLst.add(claimHistory);
                            }
                        }
                    }
                }
            }
            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
            //Added code for GSSC-262
            if(newClaimModiRec!=null && newClaimModiRec.size()>0)
                update newClaimModiRec;
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onInsertSRT method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }

    public static void onUpdateSRT(List<CSS_SRT__c> newList,Map<id,CSS_SRT__c> oldMap, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            system.debug('****newList*****'+newList);
            system.debug('****oldMap*****'+oldMap);
            system.debug('****claimsAuditLst*****'+claimsAuditLst);
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            list<CSS_Claims__c> newClaimModiRec = new list<CSS_Claims__c>();
            for(CSS_SRT__c srtObj : newList){
                if(srtObj.CSS_Claims__c != null){
                    CSS_SRT__c oldSRT = oldMap.get(srtObj.id);
                    for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                        if(auditRec.Object_Name__c == 'CSS_SRT__c' && auditRec.isServicejob__c == false){
                            CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                            CSS_SRT__c newSRTRec = new CSS_SRT__c();
                            CSS_Claims__c newClaimRec = new CSS_Claims__c();
                            if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Edit')){
                                system.debug('first-->'+srtObj.get(auditRec.Field_Name__c));
                                system.debug('second-->'+oldSRT.get(auditRec.Field_Name__c));
                                if(srtObj.get(auditRec.Field_Name__c) == oldSRT.get(auditRec.Field_Name__c))
                                    continue;

                                String oldValue = String.valueOf(oldSRT.get(auditRec.Field_Name__c));
                                String newValue = String.valueOf(srtObj.get(auditRec.Field_Name__c));

                                if(oldValue == null || oldValue == '')
                                    oldValue = 'Blank';

                                if(newValue == null || newValue == '')
                                    newValue = 'Blank';
                                system.debug('srtObj-->'+srtObj);
                                claimHistory.CSS_Job_Id__c = srtObj.CSS_Claims__c;
                                claimHistory.CSS_Object_Name__c = 'CSS_SRT__c';
                                claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                                claimHistory.CSS_New_Value__c = newValue;
                                claimHistory.CSS_Old_Value__c =oldValue;
                                String srtId = String.valueOf(srtObj.get('SRT_ID__c'));
                                String overlapHrs = String.valueOf(srtObj.get('Overlap_Hours__c'));
                                String reducedSRTId;
                                if(srtObj.get('Overlap_SRT_Number__c') != null){
                                    reducedSRTId = String.valueOf(srtObj.get('Overlap_SRT_Number__c'));
                                }
                                system.debug('auditRec.Field_Name__c-->'+auditRec.Field_Name__c);
                                system.debug('newValue-->'+newValue);
                                system.debug('oldValue-->'+oldValue);
                                if(auditRec.Dynamic_Message__c == true){
                                    if(auditRec.Field_Name__c == 'isPerformed__c'){ 
                                        if(srtObj.get(auditRec.Field_Name__c) == true){
                                            claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue', srtId); 
                                        }
                                        else{
                                            claimHistory.Audit_Message__c = auditRec.Remove_Message__c.replace('newValue', srtId);
                                        }
                                    }
                                    else{
                                        if(reducedSRTId != null){
                                            claimHistory.Audit_Message__c = auditRec.Message__c.replace('oldValue', overlapHrs);
                                            claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('srtCode', reducedSRTId);
                                            claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('newValue', newValue);
                                            claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('overlapsrtId', srtId);
                                        }
                                        else{
                                            if(srtObj.get('isPerformed__c') == true){
                                                if(auditRec.Field_Name__c == 'SRT_Warrantable__c'){
                                                    if(srtObj.get('AccountCode_Formula__c') != 'Select One' && srtObj.get('AccountCode_Formula__c') != null && srtObj.get('AccountCode_Formula__c') != ''){
                                                        claimHistory.Audit_Message__c = auditRec.Message__c.replace('oldValue', oldValue);
                                                        claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('srtCode', srtId);
                                                        claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('newValue', newValue);
                                                    }
                                                    else{
                                                        continue;
                                                    }
                                                }
                                                else{
                                                    claimHistory.Audit_Message__c = auditRec.Message__c.replace('oldValue', oldValue);
                                                    claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('srtCode', srtId);
                                                    claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('newValue', newValue);
                                                }
                                            }
                                            else{
                                                continue;
                                            }
                                        }

                                    }
                                }
                                else{
                                    claimHistory.Audit_Message__c = auditRec.Message__c;
                                }
                                //Added code for GSSC-262
                                system.debug('**outside if srtObj.Id**'+srtObj.Id);
                                newSRTRec.Id                          = srtObj.Id;
                                newClaimRec.id                        = srtObj.CSS_Claims__c;
                                newClaimRec.Last_saved_by__c          = userInfo.getName();
                                //newClaimRec.Last_Saved__c             = css_utility.getFormattedDate(srtObj.LastModifiedDate);
                                newClaimRec.LastSavedDate__c = srtObj.LastModifiedDate;
                                if(newClaimRec.LastSavedDate__c !=null && newClaimRec.Last_saved_by__c!=null && !newClaimModiRec.contains(newClaimRec)){
                                    newClaimModiRec.add(newClaimRec);
                                }


                                system.debug('claimHistory.Audit_Message__c-->'+claimHistory.Audit_Message__c);
                                if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                    claimHistoryLst.add(claimHistory);
                                }
                            }
                        }
                    }
                }
            }
            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
            //Added code for GSSC-262
            if(newClaimModiRec!=null && newClaimModiRec.size()>0)
                update newClaimModiRec;    
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onUpdateSRT method at line>>>>>>>>>>>>> ::  '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }

    public static void onDeleteSRT(List<CSS_SRT__c> newList, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            list<CSS_Claims__c> newClaimModiRec = new list<CSS_Claims__c>();
            for(CSS_SRT__c srtObj : newList){
                if(srtObj.CSS_Claims__c != null){
                    for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                        if(auditRec.Object_Name__c == 'CSS_SRT__c' && auditRec.isServicejob__c == false){
                            CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                            CSS_SRT__c newSRTRec = new CSS_SRT__c();
                            CSS_Claims__c newClaimRec = new CSS_Claims__c();
                            if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Delete')){
                                String newValue = String.valueOf(srtObj.get(auditRec.Field_Name__c));
                                claimHistory.CSS_Job_Id__c = srtObj.CSS_Claims__c;
                                claimHistory.CSS_Object_Name__c = 'CSS_SRT__c';
                                claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                                claimHistory.CSS_New_Value__c = newValue;
                                system.debug('auditRec.Message__c-->'+auditRec.Message__c);
                                String srtId = String.valueOf(srtObj.get('SRT_ID__c'));
                                String srtType = String.valueOf(srtObj.get('Type__c'));
                                if(auditRec.Field_Name__c == 'Name'){
                                    if(srtType != 'Overlap' && srtObj.get('isPerformed__c') == true){
                                        claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue', srtId);
                                    }
                                }
                                //Added code for GSSC-262
                                system.debug('**outside if srtObj.Id**'+srtObj.Id);
                                newSRTRec.Id                          = srtObj.Id;
                                newClaimRec.id                        = srtObj.CSS_Claims__c;
                                newClaimRec.Last_saved_by__c          = userInfo.getName();
                                //newClaimRec.Last_Saved__c             = css_utility.getFormattedDate(srtObj.LastModifiedDate);
                                newClaimRec.LastSavedDate__c = srtObj.LastModifiedDate;
                                if(newClaimRec.LastSavedDate__c !=null && newClaimRec.Last_saved_by__c!=null && !newClaimModiRec.contains(newClaimRec)){
                                    newClaimModiRec.add(newClaimRec);
                                }

                            }
                            if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                claimHistoryLst.add(claimHistory);
                            }
                        }
                    }
                }
            }
            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
            //Added code for GSSC-262
            if(newClaimModiRec!=null && newClaimModiRec.size()>0)
                update newClaimModiRec;
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onDeleteFC method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }

    public static void onInsertPOC(List<CSS_Parts_Options__c> newList, List<CG_Claim_Audit_Log__c> claimsAuditLst){ 
        try{
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            list<CSS_Claims__c> newClaimModiRec = new list<CSS_Claims__c>();
            for(CSS_Parts_Options__c pocObj : newList){
                if(pocObj.CSS_Claims__c != null){
                    for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                        if(auditRec.Object_Name__c == 'CSS_Parts_Options__c' && auditRec.isServicejob__c == false){
                            CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                            CSS_Parts_Options__c newPartsOptionsRec = new CSS_Parts_Options__c();
                            CSS_Claims__c newClaimRec = new CSS_Claims__c();
                            if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Add')){
                                String newValue = String.valueOf(pocObj.get(auditRec.Field_Name__c));
                                claimHistory.CSS_Job_Id__c = pocObj.CSS_Claims__c;
                                claimHistory.CSS_Object_Name__c = 'CSS_Parts_Options__c';
                                claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                                claimHistory.CSS_New_Value__c = newValue;
                                system.debug('auditRec.Message__c-->'+auditRec.Message__c);
                                String partNum = String.valueOf(pocObj.get('Service_partnumber__c'));
                                String ocItem = String.valueOf(pocObj.get('Item__c'));
                                String ttmlType = String.valueOf(pocObj.get('Type__c'));
                                Id recordTypeId = String.valueOf(pocObj.get('RecordTypeId'));
                                Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                                Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
                                Id recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
                                system.debug('auditRec.Field_Name__c-->'+auditRec.Field_Name__c);
                                system.debug('recordTypeId-->'+recordTypeId);
                                system.debug('recTypeIdOC-->'+recTypeIdOC);
                                system.debug('recTypeIdTTML-->'+recTypeIdTTML);
                                system.debug('recTypeIdpart-->'+recTypeIdpart);
                                if(auditRec.Field_Name__c == 'Name'){
                                    if(recordTypeId  == recTypeIdpart && pocObj.get('Parts_Type__c') == 'Custom'){
                                        claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue', partNum);
                                    }
                                    else if(recordTypeId == recTypeIdOC){
                                        claimHistory.Audit_Message__c = auditRec.Edit_Message__c.replace('newValue', ocItem);
                                    }
                                    else if(recordTypeId == recTypeIdTTML){
                                        claimHistory.Audit_Message__c = auditRec.Remove_Message__c.replace('newValue', ttmlType);
                                    }
                                }
                                else{
                                    if(recordTypeId  == recTypeIdpart && (pocObj.get('Parts_Type__c') == '' || pocObj.get('Parts_Type__c') == null) && pocObj.get(auditRec.Field_Name__c) == true){
                                        claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue', partNum);
                                    }
                                }
                                //Added code for GSSC-262
                                system.debug('**outside if poc.Id**'+pocObj.Id);
                                newPartsOptionsRec.Id                 = pocObj.Id;
                                newClaimRec.id                        = pocObj.CSS_Claims__c;
                                newClaimRec.Last_saved_by__c          = userInfo.getName();
                                //newClaimRec.Last_Saved__c             = css_utility.getFormattedDate(pocObj.LastModifiedDate);
                                newClaimRec.LastSavedDate__c = pocObj.LastModifiedDate;
                                if(newClaimRec.LastSavedDate__c !=null && newClaimRec.Last_saved_by__c!=null && !newClaimModiRec.contains(newClaimRec)){
                                    newClaimModiRec.add(newClaimRec);
                                }
                            }
                            system.debug('claimHistory.Audit_Message__c-->'+claimHistory.Audit_Message__c); 
                            if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                claimHistoryLst.add(claimHistory);
                            }
                        }
                    }
                }
            }
            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
            //Added code for GSSC-262
            if(newClaimModiRec!=null && newClaimModiRec.size()>0)
                update newClaimModiRec; 
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onInsertPOC method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }

    public static void onUpdatePOC(List<CSS_Parts_Options__c> newList,Map<id,CSS_Parts_Options__c> oldMap, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            system.debug('claimsAuditLst--'+claimsAuditLst);
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            list<CSS_Claims__c> newClaimModiRec = new list<CSS_Claims__c>();
            for(CSS_Parts_Options__c pocObj : newList){
                CSS_Parts_Options__c oldPart = oldMap.get(pocObj.id);
                if(pocObj.CSS_Claims__c != null){
                    for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                        if(auditRec.Object_Name__c == 'CSS_Parts_Options__c' && auditRec.isServicejob__c == false){
                            CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                            CSS_Parts_Options__c newPartsOptionsRec = new CSS_Parts_Options__c();
                            CSS_Claims__c newClaimRec = new CSS_Claims__c();
                            if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Edit')){
                                //system.debug('first-->'+pocObj.get(auditRec.Field_Name__c));
                                //system.debug('second-->'+oldPart.get(auditRec.Field_Name__c));
                                if(pocObj.get(auditRec.Field_Name__c) == oldPart.get(auditRec.Field_Name__c))
                                    continue;

                                String oldValue = String.valueOf(oldPart.get(auditRec.Field_Name__c));
                                String newValue = String.valueOf(pocObj.get(auditRec.Field_Name__c));

                                if(oldValue == null || oldValue == '')
                                    oldValue = 'Blank';

                                if(newValue == null || newValue == '')
                                    newValue = 'Blank';
                                system.debug('pocObj-->'+pocObj);
                                claimHistory.CSS_Job_Id__c = pocObj.CSS_Claims__c;
                                claimHistory.CSS_Object_Name__c = 'CSS_Parts_Options__c';
                                claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                                claimHistory.CSS_New_Value__c = newValue;
                                claimHistory.CSS_Old_Value__c =oldValue;
                                String partNum = String.valueOf(pocObj.get('Service_partnumber__c'));
                                String ocItem = String.valueOf(pocObj.get('Item__c'));
                                String ttmlType = String.valueOf(pocObj.get('Type__c'));
                                Id recordTypeId = String.valueOf(pocObj.get('RecordTypeId'));
                                Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                                Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
                                Id recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
                                if(auditRec.Dynamic_Message__c == true){
                                    system.debug('Field Name-->'+auditRec.Field_Name__c);
                                    system.debug('RecordType Id -->'+recordTypeId);
                                    system.debug('Part RecordType Id-->'+recTypeIdpart);
                                    system.debug('Parts Type-->'+pocObj.get('Parts_Type__c'));
                                    if(recordTypeId == recTypeIdpart && auditRec.Edit_Message__c == 'Parts'){
                                        system.debug('inside gsq or fa parts');
                                        if(auditRec.Field_Name__c == 'selected_part__c' && recordTypeId == recTypeIdpart && (pocObj.get('Parts_Type__c') == '' || pocObj.get('Parts_Type__c') == null)){
                                            system.debug('inside gsq or fa parts selected part');
                                            if(pocObj.get(auditRec.Field_Name__c) == true){
                                                claimHistory.Audit_Message__c = auditRec.Message__c.replace('partNum', partNum);
                                                claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('oldValue',oldValue);
                                                claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('newValue',newValue);
                                            }
                                            else{
                                                claimHistory.Audit_Message__c = auditRec.Remove_Message__c.replace('partNum', partNum);
                                                claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('oldValue',oldValue);
                                                claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('newValue',newValue);
                                            }
                                        }
                                        else if(auditRec.Field_Name__c != 'selected_part__c' && recordTypeId == recTypeIdpart){
                                            if(((pocObj.get('Parts_Type__c') == '' || pocObj.get('Parts_Type__c') == null) && pocObj.get('selected_part__c') == true) || 
                                               (pocObj.get('Parts_Type__c') == 'Custom')){
                                                claimHistory.Audit_Message__c = auditRec.Message__c.replace('partNum', partNum);
                                                claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('oldValue',oldValue);
                                                claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('newValue',newValue);

                                            }
                                        }
                                    }
                                    else if(recordTypeId == recTypeIdOC  && auditRec.Edit_Message__c == 'OtherClaimables'){
                                        claimHistory.Audit_Message__c = auditRec.Message__c.replace('ocItem', ocItem);
                                        claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('oldValue',oldValue);
                                        claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('newValue',newValue);
                                    }
                                    else if(recordTypeId == recTypeIdTTML  && auditRec.Edit_Message__c == 'TTML'){
                                        claimHistory.Audit_Message__c = auditRec.Message__c.replace('ttmlType', ttmlType);
                                        claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('oldValue',oldValue);
                                        claimHistory.Audit_Message__c = claimHistory.Audit_Message__c.replace('newValue',newValue);
                                    }
                                }
                                //Added code for GSSC-262
                                system.debug('**outside if poc.Id**'+pocObj.Id);
                                newPartsOptionsRec.Id                 = pocObj.Id;
                                newClaimRec.id                        = pocObj.CSS_Claims__c;
                                newClaimRec.Last_saved_by__c          = userInfo.getName();
                                //newClaimRec.Last_Saved__c             = css_utility.getFormattedDate(pocObj.LastModifiedDate);
                                newClaimRec.LastSavedDate__c = pocObj.LastModifiedDate;
                                if(newClaimRec.LastSavedDate__c !=null && newClaimRec.Last_saved_by__c!=null && !newClaimModiRec.contains(newClaimRec)){
                                    newClaimModiRec.add(newClaimRec);
                                }
                                if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                    claimHistoryLst.add(claimHistory);
                                }
                                system.debug('Final message Parts Edit-->'+claimHistory.Audit_Message__c);
                            }
                        }
                    }
                }
            }
            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
            //Added code for GSSC-262
            if(newClaimModiRec!=null && newClaimModiRec.size()>0)
                update newClaimModiRec;    
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onUpdatePOC method at line>>>>>>>>>>>>> ::  '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }

    public static void onDeletePOC(List<CSS_Parts_Options__c> newList, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            list<CSS_Claims__c> newClaimModiRec = new list<CSS_Claims__c>();
            for(CSS_Parts_Options__c pocObj : newList){
                if(pocObj.CSS_Claims__c != null){
                    for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                        if(auditRec.Object_Name__c == 'CSS_Parts_Options__c' && auditRec.isServicejob__c == false){
                            CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                            CSS_Parts_Options__c newPartsOptionsRec = new CSS_Parts_Options__c();
                            CSS_Claims__c newClaimRec = new CSS_Claims__c();
                            if(auditRec.Action_Type__c != null && auditRec.Action_Type__c.contains('Delete')){
                                String newValue = String.valueOf(pocObj.get(auditRec.Field_Name__c));
                                claimHistory.CSS_Job_Id__c = pocObj.CSS_Claims__c;
                                claimHistory.CSS_Object_Name__c = 'CSS_Parts_Options__c';
                                claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                                claimHistory.CSS_New_Value__c = newValue;
                                system.debug('auditRec.Message__c-->'+auditRec.Message__c);
                                String partNum = String.valueOf(pocObj.get('Service_partnumber__c'));
                                String ocItem = String.valueOf(pocObj.get('Item__c'));
                                String ttmlType = String.valueOf(pocObj.get('Type__c'));
                                Id recordTypeId = String.valueOf(pocObj.get('RecordTypeId'));
                                Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                                Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
                                Id recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
                                system.debug('recordTypeId-->'+recordTypeId);
                                system.debug('recTypeIdpart-->'+recTypeIdpart);
                                system.debug('recTypeIdOC-->'+recTypeIdOC);
                                system.debug('recTypeIdTTML-->'+recTypeIdTTML);
                                system.debug('Parts_Type__c-->'+pocObj.get('Parts_Type__c'));
                                system.debug('Selected Part-->'+pocObj.get('selected_part__c'));
                                if(auditRec.Field_Name__c == 'Name'){
                                    if(recordTypeId == recTypeIdpart){
                                        if(((pocObj.get('Parts_Type__c') == '' || pocObj.get('Parts_Type__c') == null) && pocObj.get('selected_part__c') == true) || 
                                           (pocObj.get('Parts_Type__c') == 'Custom')){
                                            claimHistory.Audit_Message__c = auditRec.Message__c.replace('newValue', partNum);
                                        }
                                    }
                                    else if(recordTypeId == recTypeIdOC){
                                        claimHistory.Audit_Message__c = auditRec.Edit_Message__c.replace('newValue', ocItem);
                                    }
                                    else if(recordTypeId == recTypeIdTTML){
                                        claimHistory.Audit_Message__c = auditRec.Remove_Message__c.replace('newValue', ttmlType);
                                    }
                                }
                                //Added code for GSSC-262
                                system.debug('**outside if poc.Id**'+pocObj.Id);
                                newPartsOptionsRec.Id                 = pocObj.Id;
                                newClaimRec.id                        = pocObj.CSS_Claims__c;
                                newClaimRec.Last_saved_by__c          = userInfo.getName();
                                //newClaimRec.Last_Saved__c             = css_utility.getFormattedDate(pocObj.LastModifiedDate);
                                newClaimRec.LastSavedDate__c = pocObj.LastModifiedDate;
                                if(newClaimRec.LastSavedDate__c !=null && newClaimRec.Last_saved_by__c!=null && !newClaimModiRec.contains(newClaimRec)){
                                    newClaimModiRec.add(newClaimRec);
                                }
                            }
                            if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                claimHistoryLst.add(claimHistory);
                            }
                        }
                    }
                }
            }
            system.debug('**claimHistoryLst**'+claimHistoryLst);
            if(claimHistoryLst != null && claimHistoryLst.size() > 0)
                insert claimHistoryLst;
            //Added code for GSSC-262
            system.debug('**newClaimModiRec**'+newClaimModiRec);  
            if(newClaimModiRec!=null && newClaimModiRec.size()>0)
                update newClaimModiRec;
        }
        catch(Exception ex){
            System.debug('In catch of audit trail handler onDeletePOC method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }
    //Prabhakar added for GSSC-444
    public static void onUpdatetsol(List<CSS_Solutions__c> newList,Map<id,CSS_Solutions__c> oldMap, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            // List<CSS_SymptomQA__c>lstsym = [select id,name,Job_Order__c,(select name,symptom__c  from CSS_Solutions__r) from CSS_SymptomQA__c where Job_Order__c=:newList[0].Service_Job__c ];
            system.debug('entered into audit sol method');
            system.debug('newList-->'+newList);
            system.debug('oldMap-->'+oldMap);
            system.debug('claimsAuditLst-->'+claimsAuditLst);
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            for(CSS_Solutions__c solObj : newList){
                if(solObj.Service_Job__c != null){
                    CSS_Solutions__c oldFailure = oldMap.get(solObj.id);
                    for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                        if(auditRec.Object_Name__c == 'CSS_Solutions__c'){
                            CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                            CSS_Solutions__c newSolutionRec = new CSS_Solutions__c();
                            if(auditRec.Action_Type__c != null && auditRec.isServicejob__c==true && (auditRec.Action_Type__c.contains('Add') || auditRec.Action_Type__c.contains('Edit'))){
                                //
                                system.debug('first-->'+solObj.get(auditRec.Field_Name__c));
                                system.debug('second-->'+oldFailure.get(auditRec.Field_Name__c));
                                if(solObj.get(auditRec.Field_Name__c) == oldFailure.get(auditRec.Field_Name__c))
                                    continue;


                                //
                                String oldValue = String.valueOf(oldFailure.get(auditRec.Field_Name__c));
                                String newValue = String.valueOf(solObj.get(auditRec.Field_Name__c));

                                claimHistory.CSS_Job_Id__c = solObj.Service_Job__c;
                                claimHistory.CSS_Object_Name__c = 'CSS_Solutions__c';
                                claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                                claimHistory.CSS_New_Value__c = newValue;
                                claimHistory.CSS_Old_Value__c =oldValue;

                                String diagReponse = String.valueOf(solObj.get('Diagnostic_Response__c'));
                                String diagcomments = String.valueOf(solObj.get('Diagnostic_notes__c'));
                                integer srank;
                                if(solObj.CSS_Nested_Solutions__c==null){
                                    string solRank = String.valueOf(solObj.get('Rank__c'));
                                    srank = integer.valueOf(solRank)+1;
                                }


                                String solid = String.valueOf(solObj.get('Name'));
                                String solTitle = String.valueOf(solObj.get('Solution_Title__c'));
                                string solnestRank = String.valueOf(solObj.get('Nested_Rank__c'));
                               system.debug('auditRec.Field_Name__c-->'+auditRec.Field_Name__c);
                                if(auditRec.Field_Name__c == 'Diagnostic_Response__c'){
                                    if((solObj.Diagnostic_Response__c!=null && (oldValue==null || oldValue == '') && auditRec.Action_Type__c.contains('Add')) 
                                       || (solObj.CSS_Nested_Solutions__c!=null && solObj.Diagnostic_Response__c!=null && (oldValue==null || oldValue == '') && auditRec.Action_Type__c.contains('Add'))){
                                        auditRec.Message__c = auditRec.Message__c.replace('newValue', newValue);
                                        if(solObj.CSS_Nested_Solutions__c!=null)
                                            auditRec.Message__c = auditRec.Message__c.replace('rank', solnestRank);  
                                        else
                                            //auditRec.Message__c = auditRec.Message__c.replace('rank', solRank);
                                            auditRec.Message__c = auditRec.Message__c.replace('rank', string.valueOf(srank));


                                        auditRec.Message__c = auditRec.Message__c.replace('id', solid);
                                        auditRec.Message__c = auditRec.Message__c.replace('title', solTitle);
                                        claimHistory.Audit_Message__c = auditRec.Message__c;
                                        system.debug('diagresponseadded'+claimHistory.Audit_Message__c);

                                    }
                                    else if((solObj.Diagnostic_Response__c!=null && (oldValue!=null && oldValue != '') && auditRec.Action_Type__c.contains('Edit')) ||
                                            (solObj.CSS_Nested_Solutions__c!=null && solObj.Diagnostic_Response__c!=null && (oldValue!=null && oldValue != '') && auditRec.Action_Type__c.contains('Edit'))){
                                        system.debug('solObj.Diagnostic_Response__c'+solObj.Diagnostic_Response__c);
                                        system.debug('oldValue'+oldValue);
                                        system.debug('auditRec.Action_Type__c'+auditRec.Action_Type__c);
                                        system.debug('solObj.CSS_Nested_Solutions__c'+solObj.CSS_Nested_Solutions__c);

                                        if(solObj.CSS_Nested_Solutions__c!=null)
                                            auditRec.Message__c = auditRec.Message__c.replace('rank', solnestRank);  
                                        else
                                            auditRec.Message__c = auditRec.Message__c.replace('rank', string.valueOf(srank));
                                        //auditRec.Message__c =  auditRec.Message__c.replace('rank', solRank);
                                        auditRec.Message__c =  auditRec.Message__c.replace('Title', solTitle);
                                        auditRec.Message__c =  auditRec.Message__c.replace('SolutionID', solid);
                                        auditRec.Message__c =  auditRec.Message__c.replace('DiagnosticResponseOld', oldValue);
                                        auditRec.Message__c = auditRec.Message__c.replace('DiagnosticResponseNew', newValue);
                                        claimHistory.Audit_Message__c = auditRec.Message__c;
                                        //claimHistory.TechnicianNotes__c = diagcomments;
                                        system.debug('diagresponseupdated'+claimHistory.Audit_Message__c);
                                    }

                                }
                               // system.debug('auditRec.Field_Name__c-->notes'+auditRec.Field_Name__c);
                               else  if(auditRec.Field_Name__c == 'Diagnostic_notes__c'){
                                    system.debug('firstdiagnotes-->'+solObj.get(auditRec.Field_Name__c));
                                    system.debug('seconddiagnotes-->'+oldFailure.get(auditRec.Field_Name__c));
                                    if(solObj.get(auditRec.Field_Name__c) == oldFailure.get(auditRec.Field_Name__c))
                                        continue;
                                    String newValuenotes = String.valueOf(solObj.get(auditRec.Field_Name__c));
                                    String oldValuenotes = String.valueOf(oldFailure.get(auditRec.Field_Name__c));
                                    system.debug('notesnewValue'+newValue);
                                    if((solObj.Diagnostic_notes__c!=null && (oldValuenotes==null || oldValuenotes == '') && auditRec.Action_Type__c.contains('Add'))
                                       || (solObj.CSS_Nested_Solutions__c!=null && solObj.Diagnostic_notes__c!=null && (oldValuenotes==null || oldValuenotes == '') && auditRec.Action_Type__c.contains('Add'))){
                                        if(solObj.CSS_Nested_Solutions__c!=null)
                                            auditRec.Message__c = auditRec.Message__c.replace('rank', solnestRank);  
                                        else
                                            auditRec.Message__c = auditRec.Message__c.replace('rank', string.valueOf(srank));
                                        // auditRec.Message__c =  auditRec.Message__c.replace('rank', solRank);
                                        auditRec.Message__c =  auditRec.Message__c.replace('Title', solTitle);
                                        auditRec.Message__c =  auditRec.Message__c.replace('SolutionID', solid);
                                        claimHistory.Audit_Message__c = auditRec.Message__c;
                                        claimHistory.TechnicianNotes__c = newValuenotes;
                                        system.debug('claimHistory.TechnicianNotes__c'+claimHistory.TechnicianNotes__c);
                                        system.debug('commentAdded'+claimHistory.Audit_Message__c);
                                    }
                                    else if((solObj.Diagnostic_notes__c!=null && (oldValuenotes!=null && oldValuenotes != '') && auditRec.Action_Type__c.contains('Edit'))
                                            || (solObj.CSS_Nested_Solutions__c!=null && solObj.Diagnostic_notes__c!=null && (oldValuenotes!=null && oldValuenotes != '') && auditRec.Action_Type__c.contains('Edit'))){

                                        if(solObj.CSS_Nested_Solutions__c!=null)
                                            auditRec.Message__c = auditRec.Message__c.replace('rank', solnestRank);  
                                        else
                                            auditRec.Message__c = auditRec.Message__c.replace('rank', string.valueOf(srank));
                                        //auditRec.Message__c =  auditRec.Message__c.replace('rank', solRank);
                                        auditRec.Message__c =  auditRec.Message__c.replace('Title', solTitle);
                                        auditRec.Message__c =  auditRec.Message__c.replace('SolutionID', solid);
                                        claimHistory.Audit_Message__c = auditRec.Message__c;
                                        claimHistory.TechnicianNotes__c = newValuenotes;
                                        system.debug('claimHistory.TechnicianNotes__c'+claimHistory.TechnicianNotes__c);
                                        system.debug('commentAdded'+claimHistory.Audit_Message__c);
                                    }

                                }
                                //To capture the  repairresponse
                                else if(auditRec.Field_Name__c == 'Repair_Response__c'){
                                    system.debug('repairreponseoldValue'+oldValue);
                                    system.debug('repairreponsenewValue'+newValue);
                                    if(solObj.Repair_Response__c!=null && (oldValue==null || oldValue == '') && auditRec.Action_Type__c.contains('Add')){
                                        auditRec.Message__c = auditRec.Message__c.replace('newValue', newValue);
                                        auditRec.Message__c = auditRec.Message__c.replace('rank', string.valueOf(srank));
                                        auditRec.Message__c = auditRec.Message__c.replace('id', solid);
                                        auditRec.Message__c = auditRec.Message__c.replace('title', solTitle);
                                        claimHistory.Audit_Message__c = auditRec.Message__c;
                                        system.debug('repairreponseAdd'+claimHistory.Audit_Message__c);
                                    }
                                    else if(solObj.Repair_Response__c!=null && (oldValue!=null && oldValue != '') && auditRec.Action_Type__c.contains('Edit')){
                                        system.debug('repairreponseoldValue'+oldValue);
                                        system.debug('repairreponsenewValue'+newValue);
                                        auditRec.Message__c = auditRec.Message__c.replace('rank', string.valueOf(srank));
                                        auditRec.Message__c =  auditRec.Message__c.replace('Title', solTitle);
                                        auditRec.Message__c =  auditRec.Message__c.replace('SolutionID', solid);
                                        auditRec.Message__c =  auditRec.Message__c.replace('DiagnosticResponseOld', oldValue);
                                        auditRec.Message__c = auditRec.Message__c.replace('DiagnosticResponseNew', newValue);
                                        claimHistory.Audit_Message__c = auditRec.Message__c;
                                        system.debug('diagresponseupdated'+claimHistory.Audit_Message__c);


                                    }

                                }

                                //END
                                //To capture the  repairnotes
                                else if(auditRec.Field_Name__c == 'Repair_Notes__c'){
                                    if(solObj.get(auditRec.Field_Name__c) == oldFailure.get(auditRec.Field_Name__c))
                                        continue;
                                    String newValuenotes = String.valueOf(solObj.get(auditRec.Field_Name__c));
                                    String oldValuenotes = String.valueOf(oldFailure.get(auditRec.Field_Name__c));
                                    if(solObj.Repair_Notes__c!=null && (oldValuenotes==null || oldValuenotes == '') && auditRec.Action_Type__c.contains('Add')){
                                        auditRec.Message__c = auditRec.Message__c.replace('rank', string.valueOf(srank));
                                        auditRec.Message__c =  auditRec.Message__c.replace('Title', solTitle);
                                        auditRec.Message__c =  auditRec.Message__c.replace('SolutionID', solid);
                                        claimHistory.Audit_Message__c = auditRec.Message__c;
                                        claimHistory.TechnicianNotes__c = newValuenotes;
                                        system.debug('claimHistory.TechnicianNotes__c'+claimHistory.TechnicianNotes__c);
                                        system.debug('commentAdded'+claimHistory.Audit_Message__c); 

                                    }
                                    else if(solObj.Repair_Notes__c!=null && (oldValuenotes!=null && oldValuenotes != '') && auditRec.Action_Type__c.contains('Edit')){
                                        auditRec.Message__c = auditRec.Message__c.replace('rank', string.valueOf(srank));
                                        auditRec.Message__c =  auditRec.Message__c.replace('Title', solTitle);
                                        auditRec.Message__c =  auditRec.Message__c.replace('SolutionID', solid);
                                        claimHistory.Audit_Message__c = auditRec.Message__c;
                                        claimHistory.TechnicianNotes__c = newValuenotes;

                                    }

                                }

                                //END

                            }

                            system.debug('claimHistory.Audit_Message__c<><>'+claimHistory.Audit_Message__c);
                            if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                claimHistoryLst.add(claimHistory);
                            }

                        }

                    }

                }


            }
            system.debug('**prabhuclaimHistoryLst**'+claimHistoryLst);
            if(claimHistoryLst != null && claimHistoryLst.size() > 0){
                insert claimHistoryLst;
                system.debug('finalinsertrecord'+claimHistoryLst);
            }

        }
        catch(Exception ex){
            System.debug('In catch of audit trail solution handler method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }

    }
    public static void onInsertSymtomQA(List<CSS_SymptomQA__c> newList, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            system.debug('enteredintosymtomqamethod');
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            for(CSS_SymptomQA__c symtomaq : newList){
                if(symtomaq.Job_Order__c!=null){
                    for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                        if(auditRec.Object_Name__c=='CSS_SymptomQA__c'){
                            CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                            CSS_SymptomQA__c newSolutionRec = new CSS_SymptomQA__c();
                            if(auditRec.Action_Type__c != null && auditRec.isServicejob__c==true && (auditRec.Action_Type__c.contains('Add'))){
                                String newValue = String.valueOf(symtomaq.get(auditRec.Field_Name__c));
                                system.debug('newvalue of symcode name'+newValue);
                                claimHistory.CSS_Job_Id__c = symtomaq.Job_Order__c;
                                claimHistory.CSS_Object_Name__c = 'CSS_SymptomQA__c';
                                claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                                claimHistory.CSS_New_Value__c = newValue;
                                if(auditRec.Field_Name__c == 'Name'){
                                    auditRec.Message__c = auditRec.Message__c.replace('samplecode', newValue);
                                    claimHistory.Audit_Message__c = auditRec.Message__c;

                                }


                            }
                            if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                claimHistoryLst.add(claimHistory);
                            }

                        }

                    }

                }

            }
            system.debug('**prabhusymptomsearchlist**'+claimHistoryLst);
            if(claimHistoryLst != null && claimHistoryLst.size() > 0){
                insert claimHistoryLst;
                system.debug('finalinsertrecord'+claimHistoryLst);
            }


        }
        catch(Exception ex){
            System.debug('In catch of audit trail symptom  handler method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    public static void onInsertFaultcode(List<CSS_Fault_Code__c> newList, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            system.debug('enteredintosymtomqamethod');
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            system.debug('newList<><>'+newList);
            for(CSS_Fault_Code__c symtomaq : newList){
                if(symtomaq.Job_Order__c!=null){
                    for(CG_Claim_Audit_Log__c auditRec : claimsAuditLst){
                        if(auditRec.Object_Name__c=='CSS_Fault_Code__c'){
                            CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                            CSS_SymptomQA__c newSolutionRec = new CSS_SymptomQA__c();
                            if(auditRec.Action_Type__c != null && auditRec.isServicejob__c==true && (auditRec.Action_Type__c.contains('Add'))){
                                String newValue = String.valueOf(symtomaq.get(auditRec.Field_Name__c));
                                //system.debug('newValue<><>'+newValue);
                                system.debug('newvalue of symcode name'+newValue);
                                claimHistory.CSS_Job_Id__c = symtomaq.Job_Order__c;
                                claimHistory.CSS_Object_Name__c = 'CSS_Fault_Code__c';
                                claimHistory.CSS_Field_Name__c = auditRec.Field_Name__c;
                                claimHistory.CSS_New_Value__c = newValue;
                               // if(auditRec.Field_Name__c == 'Name'){
                               string auditmessgaes = auditRec.Message__c.replace('samplecode', newValue);
                               system.debug('auditmessgaes<><'+auditmessgaes);
                                   // auditRec.Message__c = auditRec.Message__c.replace('samplecode', newValue);
                                    claimHistory.Audit_Message__c = auditmessgaes;
                                    system.debug('claimHistory.Audit_Message__c<><>'+claimHistory.Audit_Message__c);

                               // }


                            }
                            if(claimHistory.Audit_Message__c != null && claimHistory.Audit_Message__c != ''){
                                claimHistoryLst.add(claimHistory);
                                system.debug('claimHistoryLst><><>'+claimHistoryLst);
                            }

                        }

                    }

                }

            }
            system.debug('**prabhusymptomsearchlist**'+claimHistoryLst);
            if(claimHistoryLst != null && claimHistoryLst.size() > 0){
                insert claimHistoryLst;
                system.debug('finalinsertrecord'+claimHistoryLst);
            }


        }
        catch(Exception ex){
            System.debug('In catch of audit trail symptom  handler method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    //
    public static void onsolcompUpdateFC(List<CSS_Solution_Component__c> newList,Map<id,CSS_Solution_Component__c> oldMap, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            system.debug('enteredintosolcomp');
            Map<ID, CSS_Solutions__c> oppMap = new Map<ID, CSS_Solutions__c> ([select id,Name,Diagnostic_Response__c,Solution_Title__c,Rank__c,CSS_Nested_Solutions__c,Nested_Rank__c from CSS_Solutions__c where id =: newList[0].Solutions__c]);

            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();

            for(CSS_Solution_Component__c solObj:newList){
                CSS_Solution_Component__c oldFailure = oldMap.get(solObj.id);
                if(solobj.Service_Job__c != null && solobj.Solutions__c != null){
                    if(solObj.get('Selected_Component__c') == oldFailure.get('Selected_Component__c'))
                        continue;
                    CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                    String oldValue = String.valueOf(oldFailure.get('Selected_Component__c'));
                    String newValue = String.valueOf(solObj.get('Selected_Component__c'));
                    claimHistory.CSS_Job_Id__c = solObj.Service_Job__c;
                    claimHistory.CSS_Object_Name__c = 'CSS_Solution_Component__c';
                    claimHistory.CSS_Field_Name__c = string.valueOf(solObj.get('Selected_Component__c'));
                    claimHistory.CSS_New_Value__c = newValue;
                    claimHistory.CSS_Old_Value__c =oldValue;
                    String Fname = String.valueOf(solObj.get('Name'));
                    //
                    CSS_Solutions__c tempSol = new CSS_Solutions__c();
                    //String tempSolId = (String)solObj.get('Solutions__c');
                    Id tempSolId = (Id)solObj.get('Solutions__c');
                    tempSol = oppMap.get(tempSolId);
                    system.debug('tempSol>>>'+tempSol);
                    system.debug('tempSol.Diagnostic_Response__c'+tempSol.Diagnostic_Response__c);
                    //
                    system.debug('Fnamep'+Fname);
                    system.debug('solObj.Selected_Component__c'+solObj.Selected_Component__c);
                    // string solposition = tempSol.
                    String solid = tempSol.Name;
                    String solTitle = tempSol.Solution_Title__c;
                    integer srank;
                    string nestrank;
                    if(tempSol.CSS_Nested_Solutions__c==null){
                        string solRank = String.valueOf(tempSol.get('Rank__c'));
                        srank = integer.valueOf(solRank)+1;
                        //auditRec.Message__c = auditRec.Message__c.replace('rank',string.valueOf(srank));
                    }
                    else {
                        nestrank = String.valueOf(tempSol.get('Nested_Rank__c'));

                    }
                    if(solObj.Selected_Component__c==true){
                        string fNames = solObj.name;
                        if(tempSol.CSS_Nested_Solutions__c==null)
                            claimHistory.Audit_Message__c =  '('+srank+')'+'-'+solid+'-'+solTitle+'-' +'<b>' +fNames + '</b>' +' Selected';
                        else
                            claimHistory.Audit_Message__c =  '('+nestrank+')'+'-'+solid+'-'+solTitle+'-' +'<b>' +fNames + '</b>' +' Selected';  


                    }
                  
                    else if(solObj.Selected_Component__c==false){
                        string fNames = solObj.name;
                        // claimHistory.Audit_Message__c = 'Selectedcompone unchecked'+aa;
                        if(tempSol.CSS_Nested_Solutions__c==null)
                            claimHistory.Audit_Message__c =  '('+srank+')' +'-'+solid+'-'+solTitle+'-'+'<b>'+fNames+'</b> ' +' unselected';
                        else
                            claimHistory.Audit_Message__c =  '('+nestrank+')'+'-'+solid+'-'+solTitle+'-' +'<b>' +fNames + '</b>' +' Selected'; 

                    }
                    system.debug('claimHistory.Audit_Message__c'+claimHistory.Audit_Message__c);
                    if(claimHistory.Audit_Message__c!=null  && claimHistory.Audit_Message__c != ''){
                        claimHistoryLst.add(claimHistory);
                    }
                }


            }
            system.debug('**solcomname**'+claimHistoryLst);
            if(claimHistoryLst != null && claimHistoryLst.size() > 0){
                insert claimHistoryLst;
                system.debug('finalinsertrecord'+claimHistoryLst);
            }

        }
        catch(Exception ex){
            System.debug('In catch of solcomp audit trail symptom  handler method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
               
    }
    //
    public static void onPartsUpdate(List<CSS_Parts_Options__c> newList,Map<id,CSS_Parts_Options__c> oldMap, List<CG_Claim_Audit_Log__c> claimsAuditLst){
        try{
            system.debug('entered into partsupdate');
            Map<ID, CSS_Solutions__c> oppMap = new Map<ID, CSS_Solutions__c> ([select id,Name,Diagnostic_Response__c,Solution_Title__c,Rank__c,CSS_Nested_Solutions__c,Nested_Rank__c from CSS_Solutions__c where id =: newList[0].Solutions__c]);
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            system.debug('newList>>>'+newList);
            for(CSS_Parts_Options__c partObj:newList){
                CSS_Parts_Options__c oldPart = oldMap.get(partObj.id);
                CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                if(partObj.Service_Job__c!=null && partObj.Solutions__c!=null){
                    system.debug('entered intoif');
                    //  if(partObj.get('selected_part__c') == oldPart.get('selected_part__c'))
                    //   continue;
                    //if(partObj.get('Replacement_Reason__c') == oldPart.get('Replacement_Reason__c'))
                    // continue;
                    //if(partObj.get('Quantity__c') == oldPart.get('Quantity__c'))
                    //  continue;



                    //  CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                    String oldValue = String.valueOf(oldPart.get('selected_part__c'));
                    String newValue = String.valueOf(partObj.get('selected_part__c'));
                    claimHistory.CSS_Job_Id__c = partObj.Service_Job__c;
                    claimHistory.CSS_Object_Name__c = 'CSS_Parts_Options__c';
                    claimHistory.CSS_Field_Name__c = string.valueOf(partObj.get('selected_part__c'));
                    claimHistory.CSS_New_Value__c = newValue;
                    claimHistory.CSS_Old_Value__c =oldValue;
                    String partName = String.valueOf(partObj.get('Part_Name__c'));
                    CSS_Solutions__c tempSol = new CSS_Solutions__c();
                    Id tempSolId = (Id)partObj.get('Solutions__c');
                    tempSol = oppMap.get(tempSolId);
                    system.debug('tempSol>>>'+tempSol);
                    //system.debug('tempSol.Diagnostic_Response__c'+tempSol.Diagnostic_Response__c);
                    //
                    system.debug('partName'+partName);
                    system.debug('partObj.selected_part__c'+partObj.selected_part__c);
                    system.debug('partObj.partObj.Quantity__c'+partObj.Quantity__c);
                    system.debug('partObj.partObj.Replacement_Reason__c'+partObj.Replacement_Reason__c);
                    String solid;
                    String solTitle;
                    if(tempSol != null){
                        solid = tempSol.Name;
                        solTitle = tempSol.Solution_Title__c;
                    }
                    integer srank;
                    string nestrank;
                    String newValueqty = String.valueOf(partObj.get('Quantity__c'));
                    String oldValueqty = String.valueOf(oldPart.get('Quantity__c'));
                    String newValuereplc= String.valueOf(partObj.get('Replacement_Reason__c'));
                    String oldValuereplc = String.valueOf(oldPart.get('Replacement_Reason__c'));

                    if(tempSol != null && tempSol.CSS_Nested_Solutions__c==null){
                        string solRank = String.valueOf(tempSol.get('Rank__c'));
                        srank = integer.valueOf(solRank)+1;
                        //auditRec.Message__c = auditRec.Message__c.replace('rank',string.valueOf(srank));
                    }
                    else {
                        //nestrank = String.valueOf(tempSol.get('Nested_Rank__c'));

                    }
                    if(partObj.selected_part__c==true && oldValue!=newValue){
                        system.debug('entered into true');
                        string partNumber = partObj.Service_partnumber__c;
                        if(tempSol != null && tempSol.CSS_Nested_Solutions__c==null)
                           // claimHistory.Audit_Message__c =  '('+srank+')'+'-'+solid+'-'+solTitle+'-' +'<b>' +fNames + '</b>' +' Selected';
                            claimHistory.Audit_Message__c =  '('+srank+')'+'-'+solid+'-'+solTitle+'-' +'Selected Part '+'<b>' +partNumber + '</b>';
                        else
                           // claimHistory.Audit_Message__c =  '('+nestrank+')'+'-'+solid+'-'+solTitle+'-' +'<b>' +fNames + '</b>' +' Selected';
                            claimHistory.Audit_Message__c =  '('+nestrank+')'+'-'+solid+'-'+solTitle+'-'  +'Selected Part '+'<b>'+partNumber + '</b>';
                        system.debug('claimHistory.Audit_Message__c'+claimHistory.Audit_Message__c);


                    }
                    else if(partObj.selected_part__c==false && oldValue!=newValue){
                        system.debug('entered into false');
                        string partNumber = partObj.Service_partnumber__c;
                        // claimHistory.Audit_Message__c = 'Selectedcompone unchecked'+aa;
                        if(tempSol != null && tempSol.CSS_Nested_Solutions__c==null)
                            claimHistory.Audit_Message__c =  '('+srank+')' +'-'+solid+'-'+solTitle+'-'+'unselected Part '+'<b>'+partNumber+'</b> ';
                        else
                            claimHistory.Audit_Message__c =  '('+nestrank+')'+'-'+solid+'-'+solTitle+'-' +'unselected Part '+'<b>' +partNumber+'</b>';
                        system.debug('claimHistory.Audit_Message__c'+claimHistory.Audit_Message__c);

                    }
                    CSS_JobHistory__c claimHistory1 = new CSS_JobHistory__c();
                    CSS_JobHistory__c claimHistory2 = new CSS_JobHistory__c();

                    claimHistory1.CSS_Job_Id__c = partObj.Service_Job__c;
                    claimHistory1.CSS_Object_Name__c = 'CSS_Parts_Options__c';
                    claimHistory1.CSS_Field_Name__c = string.valueOf(partObj.get('Quantity__c'));
                    claimHistory1.CSS_New_Value__c = newValueqty;
                    claimHistory1.CSS_Old_Value__c =oldValueqty;
                    
                    claimHistory2.CSS_Job_Id__c = partObj.Service_Job__c;
                    claimHistory2.CSS_Object_Name__c = 'CSS_Parts_Options__c';
                    claimHistory2.CSS_Field_Name__c = string.valueOf(partObj.get('Replacement_Reason__c'));
                    claimHistory2.CSS_New_Value__c = newValuereplc;
                    claimHistory2.CSS_Old_Value__c =oldValuereplc;
                    system.debug('oldValueqty'+oldValueqty);
                    system.debug('newValueqty'+newValueqty);
                     system.debug('oldValuereplc><><'+oldValuereplc);
                    system.debug('newValuereplc>>'+newValuereplc);
                    string partNumbers = partObj.Service_partnumber__c;
                   /* if(partObj.Quantity__c!=null && oldValueqty==newValueqty){
                        
                       if(tempSol.CSS_Nested_Solutions__c==null)
                            //claimHistory.Audit_Message__c =  '('+srank+')' +'-'+solid+'-'+solTitle+'-'+'<b>'+fNames+'</b> ' +' unselected';
                            claimHistory1.Audit_Message__c =  '('+srank+')'+'-'+solid+'-'+solTitle+'-'+partNumbers +'-' +'<b>'+'Part Quantity '+'</b>'+'Added' +'<b>'+newValueqty+'</b>';

                        else
                            claimHistory1.Audit_Message__c =  '('+nestrank+')'+'-'+solid+'-'+solTitle+'-'+partNumbers +'-' +'<b>'+'Part Quantity '+'</b>'+'Added'  +'<b>'+newValueqty+'</b>';
  
                        
                    }
                    if(partObj.Replacement_Reason__c!=null && partObj.Replacement_Reason__c!='' && oldValuereplc==newValuereplc){
                        system.debug('entered into Replacement_Reason__c');
                        //  if(partObj.get('Replacement_Reason__c') == oldPart.get('Replacement_Reason__c'))
                        // continue;
                        if(tempSol.CSS_Nested_Solutions__c==null)
                            claimHistory2.Audit_Message__c =  '('+srank+')'+'-'+solid+'-'+solTitle+'-'+partNumbers +'-' +'<b>'+' Part Replacement/Repair Reason '+'</b>'+'Added'  +'<b>'+newValuereplc+'</b>';
                        else
                            claimHistory2.Audit_Message__c =  '('+nestrank+')'+'-'+solid+'-'+solTitle+'-'+partNumbers +'-' +'<b>'+' Part Replacement/Repair Reason '+'</b>'+'Added'  +'<b>'+newValuereplc+'</b>';

                        system.debug('entered into Replacement_Reason__c'+claimHistory2.Audit_Message__c);
                    }*/
                    if(partObj.Quantity__c!=null && oldValueqty!=newValueqty && partObj.selected_part__c==true){
                        system.debug('entered into Quantity__c');
                        // if(partObj.get('Quantity__c') == oldPart.get('Quantity__c'))
                        // continue;
                        if(tempSol != null && tempSol.CSS_Nested_Solutions__c==null)
                            //claimHistory.Audit_Message__c =  '('+srank+')' +'-'+solid+'-'+solTitle+'-'+'<b>'+fNames+'</b> ' +' unselected';
                            claimHistory1.Audit_Message__c =  '('+srank+')'+'-'+solid+'-'+solTitle+'-'+partNumbers +'-' +'<b>'+'Part Quantity '+'</b>'+'Changed' + ' from ' +'<b>' +oldValueqty + '</b>' +' to ' +'<b>'+newValueqty+'</b>';

                        else
                            claimHistory1.Audit_Message__c =  '('+nestrank+')'+'-'+solid+'-'+solTitle+'-'+partNumbers +'-' +'<b>'+'Part Quantity '+'</b>'+'Changed' + ' from ' +'<b>' +oldValueqty + '</b>' +' to ' +'<b>'+newValueqty+'</b>';

                        system.debug('entered into qty'+claimHistory1.Audit_Message__c);
                    }

                    if(partObj.Replacement_Reason__c!=null && partObj.Replacement_Reason__c!='' && oldValuereplc!=newValuereplc && partObj.selected_part__c==true){
                        system.debug('entered into Replacement_Reason__c');
                        //  if(partObj.get('Replacement_Reason__c') == oldPart.get('Replacement_Reason__c'))
                        // continue;
                        if(tempSol != null && tempSol.CSS_Nested_Solutions__c==null)
                            claimHistory2.Audit_Message__c =  '('+srank+')'+'-'+solid+'-'+solTitle+'-'+partNumbers +'-' +'<b>'+' Part Replacement/Repair Reason '+'</b>'+'Changed' + ' from ' +'<b>' +oldValuereplc + '</b>' +' to ' +'<b>'+newValuereplc+'</b>';
                        else
                            claimHistory2.Audit_Message__c =  '('+nestrank+')'+'-'+solid+'-'+solTitle+'-'+partNumbers +'-' +'<b>'+' Part Replacement/Repair Reason '+'</b>'+'Changed' + ' from ' +'<b>' +oldValuereplc + '</b>' +' to ' +'<b>'+newValuereplc+'</b>';

                        system.debug('entered into Replacement_Reason__c'+claimHistory2.Audit_Message__c);
                    }
                    system.debug('claimHistory.Audit_Message__c'+claimHistory.Audit_Message__c);
                    if(claimHistory.Audit_Message__c!=null  && claimHistory.Audit_Message__c != ''){
                        claimHistoryLst.add(claimHistory);
                    }
                    system.debug('claimHistory1.Audit_Message__c'+claimHistory1.Audit_Message__c);
                    if(claimHistory1.Audit_Message__c!=null  && claimHistory1.Audit_Message__c != ''){
                        claimHistoryLst.add(claimHistory1);
                    }
                    system.debug('claimHistory2.Audit_Message__c'+claimHistory2.Audit_Message__c);
                    if(claimHistory2.Audit_Message__c!=null  && claimHistory2.Audit_Message__c != ''){
                        claimHistoryLst.add(claimHistory2);
                    }
                }


            }
            system.debug('**solcomname**'+claimHistoryLst);
            if(claimHistoryLst != null && claimHistoryLst.size() > 0){
                 insert claimHistoryLst;
                system.debug('finalinsertrecord'+claimHistoryLst);
            }

        }
        catch(Exception ex){
            System.debug('In catch of partsupdate audit trail symptom  handler method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());

        }

    }
    public static void onInsertaccessSRT(List<CSS_SRT__c> newList){
        try{
            system.debug('entered into accesssrtmethod');
            Map<ID, CSS_Solutions__c> oppMap = new Map<ID, CSS_Solutions__c> ([select id,Name,Diagnostic_Response__c,Solution_Title__c,Rank__c,CSS_Nested_Solutions__c,
                                                                               Nested_Rank__c from CSS_Solutions__c where id =: newList[0].Solution_Number__c]);
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            system.debug('newList>>>'+newList);
            for(CSS_SRT__c accsrt:newList){
                CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                if(accsrt.Job_Order__c != null && accsrt.Solution_Number__c!=null && accsrt.SRT_AccessiblityCheck__c==true){
                    String newValuesrtId = String.valueOf(accsrt.get('SRT_ID__c'));
                    String newValuesrrqty = String.valueOf(accsrt.get('SRT_Quantity__c'));
                    system.debug('newValuesrtId>>'+newValuesrtId);
                    system.debug('newValuesrrqty>>'+newValuesrrqty);
                    claimHistory.CSS_Job_Id__c = accsrt.Job_Order__c;
                    claimHistory.CSS_Object_Name__c = 'CSS_SRT__c';
                    claimHistory.CSS_Field_Name__c = String.valueOf(accsrt.get('SRT_ID__c'));
                    claimHistory.CSS_New_Value__c = newValuesrtId;
                    CSS_Solutions__c tempSol = new CSS_Solutions__c();
                    Id tempSolId = (Id)accsrt.get('Solution_Number__c');
                    tempSol = oppMap.get(tempSolId);
                    system.debug('tempSol>>>'+tempSol);
                    String solid = tempSol.Name;
                    String solTitle = tempSol.Solution_Title__c;
                    integer srank;
                    string nestrank;
                    
                    if(tempSol.CSS_Nested_Solutions__c==null){
                        string solRank = String.valueOf(tempSol.get('Rank__c'));
                        srank = integer.valueOf(solRank)+1;
                        //auditRec.Message__c = auditRec.Message__c.replace('rank',string.valueOf(srank));
                    }
                    else {
                        nestrank = String.valueOf(tempSol.get('Nested_Rank__c'));

                    }
                    if(accsrt.Solution_Number__c!=null && accsrt.SRT_AccessiblityCheck__c==true && accsrt.Type__c.contains('Access') && accsrt.SRT_ID__c!=null){
                        system.debug('enterintoactionmsg>>>');
                        if(tempSol.CSS_Nested_Solutions__c==null)
                            claimHistory.Audit_Message__c =  '('+srank+')'+'-'+solid+'-'+solTitle+'-' +'Access SRT '+'('+'<b>'+newValuesrtId +'</b>'+')'+' selected';
                        else
                            claimHistory.Audit_Message__c =  '('+nestrank+')'+'-'+solid+'-'+solTitle+'-' +'Access SRT '+'('+'<b>'+newValuesrtId +'</b>'+')'+' selected';  

                    }
                    CSS_JobHistory__c claimHistory1 = new CSS_JobHistory__c();
                    claimHistory1.CSS_Job_Id__c = accsrt.Job_Order__c;
                    claimHistory1.CSS_Object_Name__c = 'CSS_SRT__c';
                    claimHistory1.CSS_Field_Name__c = String.valueOf(accsrt.get('SRT_Quantity__c'));
                    claimHistory1.CSS_New_Value__c = newValuesrrqty;
                    if(accsrt.Solution_Number__c!=null && accsrt.SRT_AccessiblityCheck__c==true && accsrt.Type__c.contains('Access') && accsrt.SRT_ID__c!=null && accsrt.SRT_Quantity__c!=null){
                        if(tempSol.CSS_Nested_Solutions__c==null)
                            claimHistory1.Audit_Message__c =  '('+srank+')'+'-'+solid+'-'+solTitle+'-' +'Access SRT '+'('+'<b>'+newValuesrtId +'</b>'+')'+' Quantity '+'<b>'+newValuesrrqty +'</b>'+' Added';
                        else
                            claimHistory1.Audit_Message__c =  '('+nestrank+')'+'-'+solid+'-'+solTitle+'-' +'Access SRT '+'('+'<b>'+newValuesrtId +'</b>'+')'+' Quantity '+'<b>'+newValuesrrqty +'</b>'+' Added';

                    }
                    system.debug('claimHistory.Audit_Message__c'+claimHistory.Audit_Message__c);
                    if(claimHistory.Audit_Message__c!=null  && claimHistory.Audit_Message__c != ''){
                        claimHistoryLst.add(claimHistory);
                    }
                    system.debug('claimHistory1.Audit_Message__c'+claimHistory1.Audit_Message__c);
                    if(claimHistory1.Audit_Message__c!=null  && claimHistory1.Audit_Message__c != ''){
                        claimHistoryLst.add(claimHistory1);
                    }
                
                }
            
            }
            system.debug('**srthistory**'+claimHistoryLst);
            if(claimHistoryLst != null && claimHistoryLst.size() > 0){
                insert claimHistoryLst;
                system.debug('finalinsertrecord'+claimHistoryLst);
            }
            

        }
        catch(Exception ex){
            System.debug('In catch of accessSRT audit trail symptom  handler method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());

        }
    }
    public static void onUpdateaccessSRT(List<CSS_SRT__c> newList,Map<id,CSS_SRT__c> oldMap){
        try{
            Map<ID, CSS_Solutions__c> oppMap = new Map<ID, CSS_Solutions__c> ([select id,Name,Diagnostic_Response__c,Solution_Title__c,Rank__c,CSS_Nested_Solutions__c,Nested_Rank__c 
                                                                               from CSS_Solutions__c where id =: newList[0].Solution_Number__c]);
            List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
            system.debug('newList>>>'+newList);
            for(CSS_SRT__c accsrt:newList){
                CSS_SRT__c oldPart = oldMap.get(accsrt.id);
                CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                if(accsrt.Job_Order__c!=null && accsrt.Solution_Number__c!=null && accsrt.SRT_AccessiblityCheck__c==true && accsrt.Type__c.contains('Access') && accsrt.SRT_ID__c!=null){
                    if(accsrt.get('SRT_Quantity__c') == oldPart.get('SRT_Quantity__c'))
                       continue;
                    String oldValue = String.valueOf(oldPart.get('SRT_Quantity__c'));
                    String newValue = String.valueOf(accsrt.get('SRT_Quantity__c'));
                    String newValuesrtId = String.valueOf(accsrt.get('SRT_ID__c'));
                    claimHistory.CSS_Job_Id__c = accsrt.Job_Order__c;
                    claimHistory.CSS_Object_Name__c = 'CSS_SRT__c';
                    claimHistory.CSS_Field_Name__c = 'SRT_Quantity__c';
                    claimHistory.CSS_New_Value__c = newValue;
                    claimHistory.CSS_Old_Value__c =oldValue;
                    CSS_Solutions__c tempSol = new CSS_Solutions__c();
                    Id tempSolId = (Id)accsrt.get('Solution_Number__c');
                    tempSol = oppMap.get(tempSolId);
                    system.debug('tempSol>>>'+tempSol);
                    String solid = tempSol.Name;
                    String solTitle = tempSol.Solution_Title__c;
                    integer srank;
                    string nestrank;
                    
                    if(tempSol.CSS_Nested_Solutions__c==null){
                        string solRank = String.valueOf(tempSol.get('Rank__c'));
                        srank = integer.valueOf(solRank)+1;
                        //auditRec.Message__c = auditRec.Message__c.replace('rank',string.valueOf(srank));
                    }
                    else {
                        nestrank = String.valueOf(tempSol.get('Nested_Rank__c'));

                    }
                    String accesSrtId = String.valueOf(accsrt.get('SRT_ID__c'));
                    if(accsrt.SRT_Quantity__c!=null){
                        if(tempSol.CSS_Nested_Solutions__c==null)
                        claimHistory.Audit_Message__c =  '('+srank+')'+'-'+solid+'-'+solTitle+'-' +'Access SRT '+'('+'<b>'+newValuesrtId +'</b>'+')'+' Quantity '+'changed from '+'<b>'+oldValue +'</b>'+' to '+'<b>'+newValue+'</b>';
                    else
                        claimHistory.Audit_Message__c =  '('+nestrank+')'+'-'+solid+'-'+solTitle+'-' +'Access SRT '+'('+'<b>'+newValuesrtId +'</b>'+')'+' Quantity '+'changed from '+'<b>'+oldValue +'</b>'+' to '+'<b>'+newValue+'</b>';
                  

                     system.debug('accsrtclaimHistory.Audit_Message__c>>>'+claimHistory.Audit_Message__c);
                    
                    
                    }
                    system.debug('claimHistory.Audit_Message__c'+claimHistory.Audit_Message__c);
                    if(claimHistory.Audit_Message__c!=null  && claimHistory.Audit_Message__c != ''){
                        claimHistoryLst.add(claimHistory);
                    }
                
                }
            
            
            }
            system.debug('**srthistory**'+claimHistoryLst);
            if(claimHistoryLst != null && claimHistoryLst.size() > 0){
                insert claimHistoryLst;
                system.debug('finalinsertrecord'+claimHistoryLst);
            }

        }
        catch(Exception ex){
            System.debug('In catch of accessSRT audit trail symptom  handler method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());

        }  
    }
     public static void onDeleteacessSRT(List<CSS_SRT__c> newList){
         try{
             system.debug('entered into access srt delete>>>');
             Map<ID, CSS_Solutions__c> oppMap = new Map<ID, CSS_Solutions__c> ([select id,Name,Diagnostic_Response__c,Solution_Title__c,Rank__c,CSS_Nested_Solutions__c,Nested_Rank__c 
                                                                                from CSS_Solutions__c where id =: newList[0].Solution_Number__c]);
             List<CSS_JobHistory__c> claimHistoryLst = new List<CSS_JobHistory__c>();
             system.debug('newList>>>'+newList);
             for(CSS_SRT__c accsrt:newList){
                 CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
                 if(accsrt.Job_Order__c!=null && accsrt.Solution_Number__c!=null && accsrt.SRT_AccessiblityCheck__c==true && accsrt.Type__c.contains('Access') 
                    && accsrt.SRT_ID__c!=null){
                    String newValuesrtId = String.valueOf(accsrt.get('SRT_ID__c'));
                    String newValue = String.valueOf(accsrt.get('Name'));
                    claimHistory.CSS_Job_Id__c = accsrt.Job_Order__c;
                    claimHistory.CSS_Object_Name__c = 'CSS_SRT__c';
                    claimHistory.CSS_Field_Name__c = 'Name';
                    claimHistory.CSS_New_Value__c = newValue;
                    //claimHistory.CSS_Old_Value__c =oldValue;
                    CSS_Solutions__c tempSol = new CSS_Solutions__c();
                    Id tempSolId = (Id)accsrt.get('Solution_Number__c');
                    tempSol = oppMap.get(tempSolId);
                    system.debug('tempSol>>>'+tempSol);
                    String solid = tempSol.Name;
                    String solTitle = tempSol.Solution_Title__c;
                    integer srank;
                    string nestrank;
                    
                    if(tempSol.CSS_Nested_Solutions__c==null){
                        string solRank = String.valueOf(tempSol.get('Rank__c'));
                        srank = integer.valueOf(solRank)+1;
                        //auditRec.Message__c = auditRec.Message__c.replace('rank',string.valueOf(srank));
                    }
                    else {
                        nestrank = String.valueOf(tempSol.get('Nested_Rank__c'));

                    }
                    String accesSrtId = String.valueOf(accsrt.get('SRT_ID__c'));
                     if(accsrt.Solution_Number__c!=null && accsrt.SRT_AccessiblityCheck__c==true && accsrt.Type__c.contains('Access') 
                        && accsrt.SRT_ID__c!=null){
                         if(tempSol.CSS_Nested_Solutions__c==null)
                             claimHistory.Audit_Message__c =  '('+srank+')'+'-'+solid+'-'+solTitle+'-' +'Deleted '+'Access SRT '+'('+'<b>'+newValuesrtId +'</b>'+')';
                         else
                             claimHistory.Audit_Message__c =  '('+nestrank+')'+'-'+solid+'-'+solTitle+'-' +'Deleted '+'Access SRT '+'('+'<b>'+newValuesrtId +'</b>'+')';


                         system.debug('accsrtclaimHistory.Audit_Message__c>>>'+claimHistory.Audit_Message__c);


                     }
                     system.debug('claimHistory.Audit_Message__c'+claimHistory.Audit_Message__c);
                     if(claimHistory.Audit_Message__c!=null  && claimHistory.Audit_Message__c != ''){
                         claimHistoryLst.add(claimHistory);
                     }
                 
                 }

             }
             system.debug('**srthistory**'+claimHistoryLst);
             if(claimHistoryLst != null && claimHistoryLst.size() > 0){
                 insert claimHistoryLst;
                 system.debug('finalinsertrecord'+claimHistoryLst);
             }
         
         }
         catch(Exception ex){
            System.debug('In catch of accessSRTDelete audit trail symptom  handler method at line>>>>>>>>>>>>> :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());

        }
         
     
     }


}