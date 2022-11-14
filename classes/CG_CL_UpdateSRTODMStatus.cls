/**********************************************************************
Name:CG_CL_UpdateSRTODMStatus
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
This  Controller is used while re-triggering the ODM SRT service for the below scenarios.
1. Reset the ‘ODM status’ to ‘Yet to be validated’ for all the SRTs with account code.
2. For all the SRTs without the account code, set the ODM status as ‘Not Applicable’.
3. Reset the all the ODM messages as NULL

===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL                                 
1.0 -      Arpita Sarangee      06/14/2018           INITIAL DEVELOPMENT 
***********************************************************************/
public class CG_CL_UpdateSRTODMStatus{
    
    @InvocableMethod(label='updateSRTODMStatus' description='update SRT odmStatus from Process Builder')
    public static void updateSRTODMStatus(List<Id> idList){
    
       updateSRTODMStatusMethod(idList);
        
    }
    
    public static void updateSRTODMStatusMethod(List<Id> idList){
    
         List<CSS_SRT__c> srtJobList = new List<CSS_SRT__c>();
        List<CSS_SRT__c> srtClaimList = new List<CSS_SRT__c>();        
        List<CSS_SRT__c> updateSrtJobList = new List<CSS_SRT__c>();
        List<CSS_SRT__c> updateSrtClaimList = new List<CSS_SRT__c>();
        List<CSS_SRT__c> updateSrtClaimList1 = new List<CSS_SRT__c>();
        List<Css_Job_Order__c> serviceJobList = new List<Css_Job_Order__c>();
        List<Css_Job_Order__c> updateServiceJobList = new List<Css_Job_Order__c>();
        List<Css_Claims__c> claimList = new List<Css_Claims__c>();
        List<Css_Claims__c> updateClaimList = new List<Css_Claims__c>();
        List<CSS_Parts_Options__c> partsClaimsList = new List<CSS_Parts_Options__c>(); //Added as part of GSSC-194
        List<CSS_Parts_Options__c> updatePartsClaimsList = new List<CSS_Parts_Options__c>(); //Added as part of GSSC-194
        try{
            String orgtype=css_utility.getOrgType(userinfo.getUserId()); // code is added for story#155918
            system.debug('****updateSRTODMStatus***'+idList);
            srtJobList = [Select id,ODM_Status__c,AccountCode_Formula__c,ODM_Status_Message__c,Job_Order__c from CSS_SRT__c where Job_Order__c IN :idList];
            srtClaimList = [Select id,ODM_Status__c,AccountCode_Formula__c,ODM_Status_Message__c,CSS_Claims__c from CSS_SRT__c where CSS_Claims__c IN :idList];
            serviceJobList = [Select id,ODM_Pre_submit_Status__c from css_job_order__c where id IN :idList];
            claimList = [Select id,ODM_Pre_submit_Status__c,Information_Only_Claim__c,SRTs_ODM_Status__c from css_claims__c where id IN :idList];
            //Below query is added as part of GSSC-194
            partsClaimsList = [Select Id, ODM_Status__c, Account_Code__c, ODM_Status_Message__c, CSS_Claims__c FROM CSS_Parts_Options__c WHERE CSS_Claims__c IN :idList];
            
            if(srtJobList != null && srtJobList.size()>0){
                
                for(CSS_SRT__c srt : srtJobList){
                    if(srt.AccountCode_Formula__c != '' && srt.AccountCode_Formula__c != null && srt.AccountCode_Formula__c != 'Select One' && !srt.AccountCode_Formula__c.contains('61')){
                        srt.ODM_Status__c='YTBV';
                        srt.ODM_Status_Message__c ='';
                    }
                    else{
                        srt.ODM_Status__c='NA';
                        srt.ODM_Status_Message__c ='';
                    }
                    updateSrtJobList.add(srt);
                }
            
            }
            
            else if(srtClaimList != null && srtClaimList.size() >0){
                system.debug('srtClaimList logic enters>>>');
                for(CSS_SRT__c srt : srtClaimList){
                    if(srt.AccountCode_Formula__c != '' && srt.AccountCode_Formula__c != null && srt.AccountCode_Formula__c != 'Select One' && !srt.AccountCode_Formula__c.contains('61')){
                        srt.ODM_Status__c='YTBV';
                        srt.ODM_Status_Message__c ='';
                    }
                    else{
                        srt.ODM_Status__c='NA';
                        srt.ODM_Status_Message__c ='';
                    }
                    updateSrtClaimList.add(srt);
                }
//Below code is added for story#155918
                
            if(orgtype == 'DLR')
  {
  IF(claimlist != null && claimlist.SIZE()>0 && claimlist[0].Information_Only_Claim__c != null && claimlist[0].Information_Only_Claim__c == true)
  {
  for(CSS_SRT__c srt : srtClaimList){
srt.ODM_Status__c='NA';
                        srt.ODM_Status_Message__c ='';
                        srt.Info_Only_Claim__c = TRUE;
                          updateSrtClaimList1.add(srt);
  }
  //Below for loop is added as part of GSSC-194
  for(CSS_Parts_Options__c parts : partsClaimsList){
parts.ODM_Status__c='NA';
                        parts.ODM_Status_Message__c ='';
                        parts.Info_Only_Claim__c = TRUE;
                        updatePartsClaimsList.add(parts);
  }
  }
  
  }
  
 else if(orgtype=='DISTR')
  {
      system.debug('Distributor logic enters>>>');
   list<CSS_Solution_Component__c> solcomp = [Select id,ODM_Status__c,ODM_Status_Message__c,CSS_Account_Formula__c from CSS_Solution_Component__c where CSS_Claims__c IN :idList and pay_code__c = 'A'];
   if(solcomp.size()>0)
   {
       system.debug('srtClaimList logic enters>>>'+srtClaimList);
   for(CSS_SRT__c srt : srtClaimList){
srt.ODM_Status__c='NA';
                        srt.ODM_Status_Message__c ='';
                        srt.Info_Only_Claim__c = TRUE;
                         updateSrtClaimList1.add(srt);
  }
 system.debug('updateSrtClaimList1 logic enters>>>'+updateSrtClaimList1);
   }
  }
            
            }
 //Code end here story#155918
            if(serviceJobList != null && serviceJobList.size()>0){
                for(Css_Job_Order__c jobObj : serviceJobList){
                    jobObj.ODM_Pre_submit_Status__c = 'YTBV';
                    updateServiceJobList.add(jobObj);
                }
            
            }
            if(claimList != null && claimList.size()>0){
                //GSSC-241 Start
                String ytbvCheckSRT='';
                if(updateSrtClaimList !=null && updateSrtClaimList.size()>0){
                    for(CSS_SRT__c srt:updateSrtClaimList){
                        if(srt.ODM_Status__c=='YTBV'){
                            ytbvCheckSRT='YTBV';
                            break;
                        }
                        else if(srt.ODM_Status__c=='NA'){
                            ytbvCheckSRT='NA';
                        }
                        else{
                            ytbvCheckSRT='';
                        }
                    }
                }
                //GSSC-241 End
                for(css_claims__c claimObj : claimList){
                    //GSSC-241
                    if(ytbvCheckSRT=='YTBV'){
                        claimObj.SRTs_ODM_Status__c='YTBV';
                    }
                    else if(ytbvCheckSRT=='NA'){
                        claimObj.SRTs_ODM_Status__c='NA';
                    }
                    else{
                        claimObj.SRTs_ODM_Status__c='';
                    }
                    claimObj.ODM_Pre_submit_Status__c = 'YTBV';
                    updateClaimList.add(claimObj);
                }
            
            }
            
            
            if(updateSrtJobList != null && updateSrtJobList .size() >0){
                update updateSrtJobList;
            }
            
            
            if(updateSrtClaimList != null && updateSrtClaimList.size() >0){
                update updateSrtClaimList;
            }
            
            if(updateServiceJobList != null && updateServiceJobList .size() >0){
                update updateServiceJobList;
            }
            
            if(updateClaimList != null && updateClaimList.size() >0){
                update updateClaimList;
            }
            
            if(updateSrtClaimList1!=null && updateSrtClaimList.size()>0)
            {
                 system.debug('final updateSrtClaimList1 logic enters>>>'+updateSrtClaimList1);
                update updateSrtClaimList1;
            }
            if(updatePartsClaimsList != null && updatePartsClaimsList.size() > 0){
                update updatePartsClaimsList;
            }
        }
        catch(Exception ex)  {
            system.debug('EXCEPTION of updateSRTODMStatus >>> '+ex.getMessage() + ' ' + ex.getLineNumber() + ' ' +ex.getCause());
        }
    
    }
}