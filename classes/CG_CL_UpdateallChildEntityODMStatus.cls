/**********************************************************************
Name:CG_CL_UpdatePartsOptionsODMStatus (Header level Service)
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
This  Controller is used while re-triggering the ODM Job/Claim service for the below scenarios.
1. Reset the ‘ODM status’ to ‘Yet to be validated’ for all the Child Entities of Job/Claim
2. Reset the all the ODM messages as NULL

===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL                                 
1.0 -     kalpana vemula      06/14/2018           INITIAL DEVELOPMENT 
***********************************************************************/
public class CG_CL_UpdateallChildEntityODMStatus
{
    @InvocableMethod(label='updateODMStatusForChildEntity' description='update odmStatus of SolComp,Parts & SRTS of  Job or Claim  from Process Builder')
    public static void updateODMStatusForChildEntity(List<Id> idList){
        try{
            String orgtype=css_utility.getOrgType(userinfo.getUserId());
            List<CSS_Job_Order__c> updateServiceJobList = new List<CSS_Job_Order__c>();
            List<Css_Claims__c> updateClaimsList = new List<Css_Claims__c>();
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            List<CSS_Solution_Component__c> updatesolCompList = new List<CSS_Solution_Component__c>();
            List<CSS_Parts_Options__c > updatepartOptionList = new List<CSS_Parts_Options__c>();
            List<CSS_SRT__c> updateSrtList = new List<CSS_SRT__c>();
            Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap = new Map<string, list<CSS_Parts_Options__c>>();  
            boolean dealerInfoOnlyClaim = false;
            boolean distInfoOnlyClaim = false;
            //update Job Records
            for(css_job_order__c job: [Select id,ODM_Status__c,ODM_Status_Message__c,ODM_Pre_submit_Status__c,ODM_Pre_submit_Status_Message__c from css_job_order__c where Id IN:idList])
            {
                job.ODM_Status__c='YTBV';
                job.ODM_Pre_submit_Status__c='YTBV';
                job.ODM_Pre_submit_Status_Message__c = '';
                job.ODM_Status_Message__c ='';
                updateServiceJobList.add(job);
            }
            //update Claim Records
            for(Css_Claims__c claim: [Select id,ODM_Status__c,ODM_Status_Message__c,Information_Only_Claim__c,ODM_Pre_submit_Status__c,ODM_Pre_submit_Status_Message__c from Css_Claims__c where Id IN:idList])
            {
                //claim.ODM_Status__c='YTBV';
                claim.ODM_Pre_submit_Status__c='YTBV';
                claim.ODM_Pre_submit_Status_Message__c = '';
                //claim.ODM_Status_Message__c ='';
                if(claim.Information_Only_Claim__c == true){
                    dealerInfoOnlyClaim = true;
                }
                updateClaimsList.add(claim);
            }  


            if(updateServiceJobList!=null && updateServiceJobList.size()>0){
                //query solution component record
                solCompList =[Select id,ODM_Status__c,ODM_Status_Message__c,CSS_Claims__c,Service_Job__c,Css_Account_Formula__c from CSS_Solution_Component__c where Service_job__c IN :idList];

                //if request coming from solution object
                if(solCompList != null && solCompList.size()>0){ 
                    for(CSS_Solution_Component__c sol : solCompList){
                        if(sol.Css_Account_Formula__c != '' && sol.Css_Account_Formula__c != null && sol.Css_Account_Formula__c != 'Select One' && (!sol.Css_Account_Formula__c.contains('61'))){
                            sol.ODM_Status__c='YTBV';
                            sol.ODM_Status_Message__c='';
                        }
                        else {
                            sol.ODM_Status__c='NA';
                            sol.ODM_Status_Message__c='';
                        }
                        updatesolCompList.add(sol); 
                    }
                }

                //update parts and srt based on service Job
                //if(updatesolCompList != null && updatesolCompList.size()>0){
                for(CSS_Parts_Options__c parts : [Select id,ODM_Status__c,ODM_Status_Message__c,Account_Code__c
                                                  from CSS_Parts_Options__c 

                                                  where Service_job__c IN :idList  and RecordType.Name != 'Parts' and RecordType.Name != 'Options']){
                    if(parts.Account_Code__c != '' && parts.Account_Code__c != null && parts.Account_Code__c != 'Select One' && (!parts.Account_Code__c.contains('61'))){
                        parts.ODM_Status__c='YTBV';
                        parts.ODM_Status_Message__c='';
                    }
                    else {
                        parts.ODM_Status__c='NA';
                        parts.ODM_Status_Message__c='';
                    }

                    updatepartOptionList.add(parts);
                }

                for(CSS_SRT__c srt : [Select id,ODM_Status__c,ODM_Status_Message__c,AccountCode_Formula__c
                                      from CSS_SRT__c 
                                      where Job_Order__c IN :idList]){
                    if(srt.AccountCode_Formula__c != '' && srt.AccountCode_Formula__c != null && srt.AccountCode_Formula__c != 'Select One' && (!srt.AccountCode_Formula__c.contains('61'))){ 
                        srt.ODM_Status__c='YTBV';
                        srt.ODM_Status_Message__c='';
                    }
                    else {
                        srt.ODM_Status__c='NA';
                        srt.ODM_Status_Message__c='';
                    }
                    updateSrtList.add(srt);
                }
            }
                //Update odm for the header level claim start
                if(updateClaimsList!=null && updateClaimsList.size()>0){
                    //query solution component record
                    solCompList =[Select id,ODM_Status__c,ODM_Status_Message__c,CSS_Account_Formula__c,CSS_Claims__c,Service_Job__c from CSS_Solution_Component__c where CSS_Claims__c IN :idList];
					list<CSS_Solution_Component__c> solcomp = [Select id from CSS_Solution_Component__c where CSS_Claims__c IN :idList and pay_code__c = 'A'];
                    
                    if(solcomp!= null && solcomp.size()>0){
                        distInfoOnlyClaim = true;
                    }
                    //if request coming from solution object
                    if(solCompList != null && solCompList.size()>0){ 
                        for(CSS_Solution_Component__c sol : solCompList){
                            if((orgtype == 'DLR' && dealerInfoOnlyClaim == true) || (distInfoOnlyClaim == true && orgtype=='DISTR')){
                            sol.ODM_Status__c='NA';
                            sol.ODM_Status_Message__c='';
                        }
                           else if(sol.Css_Account_Formula__c != '' && sol.Css_Account_Formula__c != null && sol.Css_Account_Formula__c != 'Select One' && (!sol.Css_Account_Formula__c.contains('61'))){
                                sol.ODM_Status__c='YTBV';
                                sol.ODM_Status_Message__c='';
                                updatesolCompList.add(sol); 
                            }
                            else {
                                sol.ODM_Status__c='NA';
                                sol.ODM_Status_Message__c='';
                                updatesolCompList.add(sol); 
                            }
                            
                        }
                    }

                    //update parts - For automated claim
                    // All the Parts having account code on ‘Parts From ERP’ and all the Parts having account code from ‘User Requested Parts’ should be passed to the ODM Parts service for the respective account code

                    for(CSS_Parts_Options__c parts : [Select id,ODM_Status__c,ODM_Status_Message__c,Account_Code__c,Service_partnumber__c
                                                      from CSS_Parts_Options__c 
                                                      where CSS_Claims__r.CSS_Job__c!=null and CSS_Claims__c!=null and CSS_Claims__c IN :idList and ((recordtype.name='BMS Parts' or recordtype.name='OtherClaimables' or recordtype.name='TTML') or (recordtype.name='Parts' and  Parts_Type__c ='Custom'))]){
                        if(parts.Account_Code__c != '' && parts.Account_Code__c != null && (!parts.Account_Code__c.contains('61'))){
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

                    //update parts -For manual claim
                    //All the selected/checked Parts having account code on ‘Campaigns, TRPs and ATCs’ and all the Parts having account code from User Requested Parts should be passed to the ODM Parts service for the respective account code.
                    for(CSS_Parts_Options__c parts : [Select id,ODM_Status__c,ODM_Status_Message__c,Account_Code__c,Service_partnumber__c
                                                      from CSS_Parts_Options__c 
                                                      where CSS_Claims__r.CSS_Job__c=null and CSS_Claims__c!=null and CSS_Claims__c IN :idList and ((recordtype.name='Parts'and  Parts_Type__c ='Custom')  or recordtype.name='OtherClaimables' or recordtype.name='TTML' or recordtype.name='Parts' or (FailurepartId__c!=null and FailurepartId__r.Type__c in ('Campaign','TRP','ATC') and selected_part__c=true) )]){
                        if((orgtype == 'DLR' && dealerInfoOnlyClaim == true) || (distInfoOnlyClaim == true && orgtype=='DISTR')){
                            parts.ODM_Status__c='NA';
                            parts.ODM_Status_Message__c='';
                        }
                         else if(parts.Account_Code__c != '' && parts.Account_Code__c != null && parts.Account_Code__c != 'Select One' && (!parts.Account_Code__c.contains('61'))){
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

                    for(CSS_SRT__c srt : [Select id,ODM_Status__c,ODM_Status_Message__c,AccountCode_Formula__c
                                          from CSS_SRT__c 
                                          where CSS_Claims__c IN :idList]){
						if((orgtype == 'DLR' && dealerInfoOnlyClaim == true) || (distInfoOnlyClaim == true && orgtype=='DISTR')){
                            srt.ODM_Status__c='NA';
                            srt.ODM_Status_Message__c='';
                        }
                        else if(srt.AccountCode_Formula__c != '' && srt.AccountCode_Formula__c != null && srt.AccountCode_Formula__c != 'Select One' && (!srt.AccountCode_Formula__c.contains('61'))){
                            srt.ODM_Status__c='YTBV';
                            srt.ODM_Status_Message__c='';
                             updateSrtList.add(srt);
                        }
                        else
                        {
                            srt.ODM_Status__c='NA';
                            srt.ODM_Status_Message__c='';
                             updateSrtList.add(srt);
                        }

                       }
                }

                //Update odm for the header level claim end       

                if(updateServiceJobList.size()>0){
                    update updateServiceJobList;
                }
                if(updateClaimsList.size()>0){
                    update updateClaimsList;
                }
                if(updatesolCompList.size()>0){
                    update updatesolCompList;
                }
                if(updatepartOptionList.size()>0){
                    update updatepartOptionList;
                }
                if(updateSrtList.size()>0){
                    update updateSrtList;
                }
            
        }
        catch(Exception e)  {
            system.debug('EXCEPTION of updateODMStatusForPartswarranty >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }
}