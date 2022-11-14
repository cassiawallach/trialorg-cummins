/**********************************************************************
Name:CG_CL_UpdateFailureODMStatus (Header level Service)
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
This  Controller is used while re-triggering the ODM Failure service for the below scenarios.
1. Reset the ‘ODM status’ to ‘Yet to be validated’ for all the Child Entities of Failure
2. Reset the all the ODM messages as NULL

===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL                                 
1.0 -     shanthi      06/14/2018           INITIAL DEVELOPMENT 
****************************************************************/


public class CG_CL_UpdateFailureODMStatus
{
    @InvocableMethod(label='updateODMStatusForFailures' description='update odmStatus for the failures and their corresponding child  from Process Builder')
    public static void updateODMStatusForFailures(List<Id> idList){
        system.debug('Entered updateODMStatusForFailures method...');
        updateODMStatusForFailuresCall(idList);
    }
    
    public static void updateODMStatusForFailuresCall(List<Id> idList){
        try{
            system.debug('Entered update failure ODM status class');
            List<CSS_Solution_Component__c> solutionList = new List<CSS_Solution_Component__c>();
            List<String> partsWarranty = new List<String>();
            List<CSS_Solution_Component__c> updatesolutionList = new List<CSS_Solution_Component__c>();
            List<CSS_Parts_Options__c > updatepartOptionList = new List<CSS_Parts_Options__c>();
            List<CSS_Solution_Component__c> updatesolutionList1 = new List<CSS_Solution_Component__c>();
            List<CSS_SRT__c> updateSrtList = new List<CSS_SRT__c>();
            List<CSS_Claims__c> updateClaimsList = new List<CSS_Claims__c>();
            List<CSS_Job_Order__c> updateJobsList = new List<CSS_Job_Order__c>();
            Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap = new Map<string, list<CSS_Parts_Options__c>>();
            String orgtype=css_utility.getOrgType(userinfo.getUserId()); //Added code for story#155918
            boolean infoOnlyClaim = false;
            
            //query solution component record
            solutionList =[Select id,ODM_Status__c,ODM_Status_Message__c,CSS_Account_Formula__c,CSS_Claims__c,Service_Job__c from CSS_Solution_Component__c where Id IN:idList];
            //fetch part warranty accountcode from custom label
            String PartsWarrantyValues = Label.CG_Parts_Warranty;
            String accountTwoDigit=null;
            if(PartsWarrantyValues != null && PartsWarrantyValues != '') {
                partsWarranty = PartsWarrantyValues.split(',');
            }
            //if request coming from solution object
            if(solutionList.size()>0){
                Set<Id> jobIdList = new Set<Id>();
                Set<Id> claimIdList = new Set<Id>();
                Set<Id> updatejobIdList = new Set<Id>();
                Set<Id> updateclaimIdList = new Set<Id>();
                String ytbvCHeckSol='';
                String ytbvCHeckSRT='';
                String ytbvCHeckParts='';
                for(CSS_Solution_Component__c sol : solutionList){
                    if(sol.CSS_Account_Formula__c!=null && sol.CSS_Account_Formula__c!='' && sol.CSS_Account_Formula__c != 'Select One'){
                        accountTwoDigit= sol.CSS_Account_Formula__c.substring(sol.CSS_Account_Formula__c.length()-2, sol.CSS_Account_Formula__c.length());
                    } 
                    system.debug('partsWarranty****'+partsWarranty);
                    system.debug('accountTwoDigit****'+accountTwoDigit);
                    if(partsWarranty!=null && accountTwoDigit!=null && partsWarranty.contains(accountTwoDigit)) {
                        system.debug('insideIf1****');
                        if(sol.Service_Job__c!=null && sol.CSS_Claims__c==null){
                            updatejobIdList.add(sol.Service_Job__c);
                            jobIdList.add(sol.Service_Job__c);
                        }
                        if(sol.CSS_Claims__c!=null) {
                            updateclaimIdList.add(sol.CSS_Claims__c);
                            claimIdList.add(sol.CSS_Claims__c);
                        }        
                    }
                    else{
                        system.debug('insideElse1****');
                        if(sol.Service_Job__c!=null && sol.CSS_Claims__c==null){
                            jobIdList.add(sol.Service_Job__c);
                        }
                        if(sol.CSS_Claims__c!=null) {
                            claimIdList.add(sol.CSS_Claims__c);
                        } 
                    } 
                    
                }
                //Part Warranty Account Code to query failures  start
                //Query the solution component based on jobs 
                if(updatejobIdList.size()>0){
                    for(CSS_Job_Order__c job :[Select id,ODM_Status__c,ODM_Status_Message__c,ODM_Pre_submit_Status__c from CSS_Job_Order__c where id IN:updatejobIdList]){
                       // job.ODM_Status__c='YTBV';
                        //job.ODM_Status_Message__c ='';
                        job.ODM_Pre_submit_Status__c='YTBV';
                        updateJobsList.add(job);
                    }}
                if(jobIdList.size()>0){   
                    for(CSS_Solution_Component__c sol : [Select id,ODM_Status__c,ODM_Status_Message__c,CSS_Account_Formula__c
                                                         from CSS_Solution_Component__c 
                                                         where Service_Job__c IN :jobIdList]){
                                                             if(sol.CSS_Account_Formula__c!=null && sol.CSS_Account_Formula__c!=''  && sol.CSS_Account_Formula__c != 'Select One' && (!sol.CSS_Account_Formula__c.contains('61'))){
                                                                 sol.ODM_Status__c='YTBV';
                                                                 sol.ODM_Status_Message__c ='';
                                                                 updatesolutionList.add(sol);
                                                             }
                                                             else{
                                                                 sol.ODM_Status__c='NA';
                                                                 sol.ODM_Status_Message__c ='';
                                                                 updatesolutionList.add(sol);   
                                                             }
                                                         }
                }
                //Query the solution component based on claims 
                if(updateclaimIdList.size()>0){
                    for(CSS_Claims__c c :[Select id,ODM_Status__c,ODM_Status_Message__c,ODM_Pre_submit_Status__c,Failures_ODM_Status__c, Parts_ODM_Status__c, SRTs_ODM_Status__c from CSS_Claims__c where id IN:updateclaimIdList]){
                        //C.ODM_Status__c='YTBV';
                        //c.ODM_Status_Message__c ='';
                        c.ODM_Pre_submit_Status__c='YTBV';
                        updateClaimsList.add(C);
                    }}
                if(claimIdList.size()>0){
                    system.debug('enter into claimidlist>>>');
                    
                    for(CSS_Solution_Component__c sol : [Select id,ODM_Status__c,ODM_Status_Message__c,CSS_Account_Formula__c
                                                         from CSS_Solution_Component__c 
                                                         where CSS_Claims__c IN :claimIdList]){
                                                             if(sol.CSS_Account_Formula__c!=null && sol.CSS_Account_Formula__c!='' && sol.CSS_Account_Formula__c!='Select One' && (!sol.CSS_Account_Formula__c.contains('61'))){
                                                                 sol.ODM_Status__c='YTBV';
                                                                 sol.ODM_Status_Message__c ='';
                                                                 updatesolutionList.add(sol);
                                                             }
                                                             else{
                                                                 sol.ODM_Status__c='NA';
                                                                 sol.ODM_Status_Message__c ='';
                                                                 updatesolutionList.add(sol);   
                                                             }
                                                         }
                    //Below code is added for story#155918
                    IF(orgtype == 'DLR')
                    {
                        system.debug('Dealor Logic Enter>>>>');
                        //list<CSS_Solution_Component__c> solcomp = [Select id,ODM_Status__c,ODM_Status_Message__c,CSS_Account_Formula__c from CSS_Solution_Component__c where CSS_Claims__c IN :claimIdList and ODM_Status__c!='NA' and CSS_Claims__R.Information_Only_Claim__c=TRUE and CSS_Claims__R.CSS_Job__c=null];
                        //if(solcomp.size()>0)
                        list<CSS_Claims__c> claimslist = [Select id from CSS_Claims__c where ID IN :claimIdList and CSS_Job__c=null and Information_Only_Claim__c = true];
                        IF(claimslist.SIZE()>0)
                        {
                            infoOnlyClaim = true;
                            for(CSS_Solution_Component__c sol:[Select id,ODM_Status__c,ODM_Status_Message__c,CSS_Account_Formula__c from CSS_Solution_Component__c where CSS_Claims__c IN :claimIdList])
                            {
                                sol.ODM_Status__c='NA';
                                sol.ODM_Status_Message__c ='';
                                sol.Info_Only_Claim__c = TRUE;
                                updatesolutionList1.add(sol);  
                            }
                            
                        }
                    }  
                    else if(orgtype == 'DISTR')
                    {
                        system.debug('Distributor logic enters>>>');
                        list<CSS_Solution_Component__c> solcomp = [Select id,ODM_Status__c,ODM_Status_Message__c,CSS_Account_Formula__c from CSS_Solution_Component__c where CSS_Claims__c IN :claimIdList and pay_code__c = 'A'];
                        if(solcomp.size()>0)
                        {
                            infoOnlyClaim = true;
                            system.debug('Distributor enters>>>>>'+solcomp);
                            for(CSS_Solution_Component__c sol:[Select id,ODM_Status__c,ODM_Status_Message__c,CSS_Account_Formula__c from CSS_Solution_Component__c where CSS_Claims__c IN :claimIdList])
                            {
                                sol.ODM_Status__c='NA';
                                sol.ODM_Status_Message__c ='';
                                sol.Info_Only_Claim__c = TRUE;
                                updatesolutionList1.add(sol);  
                                
                            }
                            system.debug('updatesolutionList>>>'+updatesolutionList1);
                        }
                    }
                    //Code end here story#155918
                    
                    
                }
                //Part Warranty Account Code to query failures  end
                
                
                //update parts - in Job Plan we have to check for only parts from ERP.
                if(jobIdList!=null && jobIdList.size()>0){
                    for(CSS_Parts_Options__c parts : [Select id,ODM_Status__c,Service_partnumber__c,ODM_Status_Message__c,Account_Code__c,FailurepartId__r.CSS_Account_Formula__c
                                                      from CSS_Parts_Options__c 
                                                      where Service_Job__c!=null and Service_Job__c in :jobIdList and CSS_Claims__c=null and  (recordtype.name='BMS Parts' or recordtype.name='OtherClaimables' or recordtype.name='TTML') ]){
                                                          
                                                          if(infoOnlyClaim == true){
                                                              parts.ODM_Status__c='NA';
                                                              parts.ODM_Status_Message__c='';
                                                              parts.Info_Only_Claim__c = TRUE;
                                                              updatepartOptionList.add(parts);
                                                          }                                             
                                                          else if(parts.Account_Code__c!=null && parts.Account_Code__c!='' && parts.Account_Code__c != 'Select One' && (!parts.Account_Code__c.contains('61'))){
                                                              parts.ODM_Status__c='YTBV';
                                                              parts.ODM_Status_Message__c='';
                                                              updatepartOptionList.add(parts);
                                                          }
                                                          else{
                                                              parts.ODM_Status__c='NA';
                                                              parts.ODM_Status_Message__c='';
                                                              updatepartOptionList.add(parts);
                                                          }
                                                      }
                }
                
                //update parts - For automated claim
                // All the Parts having account code on ‘Parts From ERP’ and all the Parts having account code from ‘User Requested Parts’ should be passed to the ODM Parts service for the respective account code
                if(claimIdList!=null && claimIdList.size()>0){
                    for(CSS_Parts_Options__c parts : [Select id,ODM_Status__c,ODM_Status_Message__c,Service_partnumber__c,Account_Code__c
                                                      from CSS_Parts_Options__c 
                                                      where CSS_Claims__r.CSS_Job__c!=null and CSS_Claims__c!=null and CSS_Claims__c in :claimIdList and ((recordtype.name='BMS Parts' or recordtype.name='OtherClaimables' or recordtype.name='TTML') or (recordtype.name='Parts' and  Parts_Type__c ='Custom'))]){
                                                          if(infoOnlyClaim == true){
                                                              parts.ODM_Status__c='NA';
                                                              parts.ODM_Status_Message__c='';
                                                              parts.Info_Only_Claim__c = TRUE;
                                                              updatepartOptionList.add(parts);
                                                              continue;
                                                          }       
                                                          if(parts.Account_Code__c!=null && parts.Account_Code__c!='' && parts.Account_Code__c != 'Select One' && (!parts.Account_Code__c.contains('61'))){
                                                              if(parts.Service_partnumber__c!=null && parts.Service_partnumber__c!=''){
                                                                  if(POAccountCodeMap.containsKey(parts.Service_partnumber__c+parts.Account_Code__c)){      
                                                                      parts.ODM_Status__c='NA';
                                                                      parts.ODM_Status_Message__c='';
                                                                      updatepartOptionList.add(parts);
                                                                  }
                                                                  else{
                                                                      POAccountCodeMap.put(parts.Service_partnumber__c+parts.Account_Code__c, new List<CSS_Parts_Options__c> { parts });  
                                                                      parts.ODM_Status__c='YTBV';
                                                                      parts.ODM_Status_Message__c='';
                                                                      updatepartOptionList.add(parts);
                                                                  }
                                                              }
                                                              else{
                                                                  parts.ODM_Status__c='YTBV';
                                                                  parts.ODM_Status_Message__c='';
                                                                  updatepartOptionList.add(parts);
                                                              }
                                                          }
                                                          else{
                                                              parts.ODM_Status__c='NA';
                                                              parts.ODM_Status_Message__c='';
                                                              updatepartOptionList.add(parts);
                                                          }
                                                      }
                }
                
                //update parts -For manual claim
                //All the selected/checked Parts having account code on ‘Campaigns, TRPs and ATCs’ and all the Parts having account code from User Requested Parts should be passed to the ODM Parts service for the respective account code.
                if(claimIdList!=null && claimIdList.size()>0){
                    for(CSS_Parts_Options__c parts : [Select id,ODM_Status__c,ODM_Status_Message__c,Service_partnumber__c,Account_Code__c
                                                      from CSS_Parts_Options__c 
                                                      where CSS_Claims__r.CSS_Job__c=null and CSS_Claims__c!=null and CSS_Claims__c in : claimIdList and ((recordtype.name='Parts'and  Parts_Type__c ='Custom')  or recordtype.name='OtherClaimables' or recordtype.name='TTML' or (FailurepartId__c!=null and FailurepartId__r.Type__c in ('Campaign','TRP','ATC') and selected_part__c=true) )]){
                                                          if(infoOnlyClaim == true){
                                                              parts.ODM_Status__c='NA';
                                                              parts.ODM_Status_Message__c='';   
                                                              parts.Info_Only_Claim__c = TRUE;
                                                              updatepartOptionList.add(parts);
                                                              continue;
                                                          }   
                                                          if(parts.Account_Code__c!=null && parts.Account_Code__c!='' && parts.Account_Code__c != 'Select One' && (!parts.Account_Code__c.contains('61'))){
                                                              if(parts.Service_partnumber__c!=null && parts.Service_partnumber__c!=''){
                                                                  if(POAccountCodeMap.containsKey(parts.Service_partnumber__c+parts.Account_Code__c)){      
                                                                      parts.ODM_Status__c='NA';
                                                                      parts.ODM_Status_Message__c='';
                                                                      updatepartOptionList.add(parts);
                                                                  }
                                                                  else{
                                                                      POAccountCodeMap.put(parts.Service_partnumber__c+parts.Account_Code__c, new List<CSS_Parts_Options__c> { parts });  
                                                                      parts.ODM_Status__c='YTBV';
                                                                      parts.ODM_Status_Message__c='';
                                                                      updatepartOptionList.add(parts);
                                                                  }
                                                              }
                                                              else{
                                                                  parts.ODM_Status__c='YTBV';
                                                                  parts.ODM_Status_Message__c='';
                                                                  updatepartOptionList.add(parts);
                                                              }
                                                              
                                                          }
                                                          else{
                                                              parts.ODM_Status__c='NA';
                                                              parts.ODM_Status_Message__c='';
                                                              updatepartOptionList.add(parts);
                                                          }
                                                      }
                                                      
                    
                }
                
                //update srt for job
                if(jobIdList!=null && jobIdList.size()>0){
                    for(CSS_SRT__c srt : [Select id,ODM_Status__c,ODM_Status_Message__c,AccountCode_Formula__c from CSS_SRT__c where Job_Order__c!=null and Job_Order__c in :jobIdList and CSS_Claims__c=null]){
                        if(infoOnlyClaim == true){
                            srt.ODM_Status__c='NA';
                            srt.ODM_Status_Message__c='';   
                            srt.Info_Only_Claim__c = TRUE;
                            updateSrtList.add(srt);
                            continue;
                        }  
                        if(srt.AccountCode_Formula__c!=null && srt.AccountCode_Formula__c!='' && srt.AccountCode_Formula__c != 'Select One'  && (!srt.AccountCode_Formula__c.contains('61'))){
                            srt.ODM_Status__c='YTBV';
                            srt.ODM_Status_Message__c='';
                            updateSrtList.add(srt);
                        }
                        else{
                            srt.ODM_Status__c='NA';
                            srt.ODM_Status_Message__c='';
                            updateSrtList.add(srt);
                        }
                    }
                }
                
                //update srt for claim
                if(claimIdList!=null && claimIdList.size()>0){
                    for(CSS_SRT__c srt : [Select id,ODM_Status__c,ODM_Status_Message__c,AccountCode_Formula__c from CSS_SRT__c where CSS_Claims__c!=null and CSS_Claims__c in :claimIdList]){
                        if(infoOnlyClaim == true){
                            srt.ODM_Status__c='NA';
                            srt.ODM_Status_Message__c='';   
                            srt.Info_Only_Claim__c = TRUE;
                            updateSrtList.add(srt);
                            continue;
                        }  
                        if(srt.AccountCode_Formula__c!=null && srt.AccountCode_Formula__c!='' && srt.AccountCode_Formula__c != 'Select One' && (!srt.AccountCode_Formula__c.contains('61'))){
                            srt.ODM_Status__c='YTBV';
                            srt.ODM_Status_Message__c='';
                            updateSrtList.add(srt);
                        }
                        else{
                            srt.ODM_Status__c='NA';
                            srt.ODM_Status_Message__c='';
                            updateSrtList.add(srt);
                        }
                    }
                    
                }
                
                //GSSC 241
                if(claimIdList != null && claimIdList.size()>0){
                    if(updatesolutionList != null && updatesolutionList.size()>0){
                        for(CSS_Solution_Component__c sol :updatesolutionList){
                            if(sol.ODM_Status__c == 'YTBV'){
                                ytbvCHeckSol = 'YTBV';
                                break;
                            }
                            else{
                                ytbvCHeckSol = '';
                            }
                        }
                    }
                    
                    if(updatepartOptionList != null && updatepartOptionList.size()>0){
                        for(CSS_Parts_Options__c parts :updatepartOptionList){
                            if(parts.ODM_Status__c == 'YTBV'){
                                ytbvCHeckParts = 'YTBV';
                                break;
                            }
                            else{
                                ytbvCHeckParts = '';
                            }
                        }
                    }
                    
                    if(updateSrtList != null && updateSrtList.size()>0){
                        for(CSS_SRT__c srt :updateSrtList){
                            if(srt.ODM_Status__c == 'YTBV'){
                                ytbvCHeckSRT = 'YTBV';
                                break;
                            }
                            else{
                                ytbvCHeckSRT = '';
                            }
                        }
                        
                    }
                    
                    for(CSS_Claims__c c :[Select id,Failures_ODM_Status__c, Parts_ODM_Status__c, SRTs_ODM_Status__c from CSS_Claims__c where id IN:claimIdList]){
                        if(ytbvCHeckSol == 'YTBV'){
                         system.debug('insideclaimslst***');
                         c.Failures_ODM_Status__c='YTBV';
                        }
                        if(ytbvCHeckSRT == 'YTBV'){
                         system.debug('insideclaimslst***');
                         c.SRTs_ODM_Status__c='YTBV';
                        }
                        if(ytbvCHeckParts=='YTBV'){
                            c.Parts_ODM_Status__c='YTBV';
                        }
                        updateClaimsList.add(C);
                    }
                }
                //GSSC 241
            }
            if(updateJobsList.size()>0){
                update updateJobsList;
            }
            if(updateClaimsList.size()>0){
                system.debug('updateClaimsList enters for update>>>'+updateClaimsList);
                update updateClaimsList;
            }
            if(updatesolutionList.size()>0){
                system.debug('updatesolutionList enters for update>>>'+updatesolutionList);
                update updatesolutionList;
            }
            if(updatepartOptionList.size()>0){
                update updatepartOptionList;
            }
            if(updateSrtList.size()>0){
                update updateSrtList;
            }
            if(updatesolutionList1.size()>0)
            {
                system.debug('updatesolutionList1 enters for update>>>'+updatesolutionList1);
                update updatesolutionList1;
            }
        }
        catch(Exception e)  {
            system.debug('EXCEPTION of updateODMStatusForFailures >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }
    
    
}