/**********************************************************************
Name:CG_CL_UpdatePartsOptionsODMStatus
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
This  Controller is used while re-triggering the ODM Parts service for the below scenarios.
1. Reset the ‘ODM status’ to ‘Yet to be validated’ for all the PArts with account code.
2. For all the parts without the account code, set the ODM status as ‘Not Applicable’.
3. Reset the all the ODM messages as NULL

===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL                                 
1.0 -     kalpana vemula      06/14/2018           INITIAL DEVELOPMENT 
***********************************************************************/
public class CG_CL_UpdatePartsOptionsODMStatus
{
    @InvocableMethod(label='updatePartsODMStatus' description='update Parts odmStatus from Process Builder')
    public static void updatePartsODMStatus(List<Id> idList)
    {    
    	updatePartsODMStatusMethod(idList);
    }
    
    public static void updatePartsODMStatusMethod(List<Id> idList){
        
        String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile
        List<Css_Job_Order__c> jobList = new List<Css_Job_Order__c>();
        List<Css_Job_Order__c> updatejobList = new List<Css_Job_Order__c>();
        List<Css_Claims__c> claimList = new List<Css_Claims__c>();
        List<Css_Claims__c> updateclaimList = new List<Css_Claims__c>();
        List<CSS_Parts_Options__C> jobpartList = new List<CSS_Parts_Options__C>();
        List<CSS_Parts_Options__C> claimpartList = new List<CSS_Parts_Options__C>();
        List<CSS_Parts_Options__C> updatejobpartList = new List<CSS_Parts_Options__C>();
        List<CSS_Parts_Options__C> updateclaimpartList = new List<CSS_Parts_Options__C>();
        List<CSS_Parts_Options__C> updateclaimpartList1 = new List<CSS_Parts_Options__C>();
        List<CSS_Solution_Component__c> solutionList = new List<CSS_Solution_Component__c>();//SolutionList
        //Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap = new Map<string, list<CSS_Parts_Options__c>>();  
        try
        {
            system.debug('idList1 '+idList);
            system.debug('idList2 '+idList.size());
            //system.debug('idList3 '+);
            if(idList != null && idList.size() > 0){
                system.debug('idList '+idList);
            //jobList = [Select id,ODM_Pre_submit_Status__c from css_job_order__c where id IN :idList and ODM_Status__c != 'NA'];
            claimList = [Select id,ODM_Pre_submit_Status__c,Information_Only_Claim__c,Parts_ODM_Status__c from css_claims__c where id IN :idList and ODM_Status__c != 'NA'];
            //jobpartList = [Select id,ODM_Status__c,Account_Code__c,ODM_Status_Message__c,Service_Job__c from CSS_Parts_Options__C where Service_Job__c IN :idList and ODM_Status__c != 'NA'and RecordType.Name != 'Parts' and RecordType.Name != 'Options'];
            //system.debug('jobList'+jobList);
            //system.debug('claimList'+claimList);
            //system.debug('PartsList**'+jobpartList);
            }
            if(claimList != null && claimList.size()>0)
            {
                system.debug('inside else');
                list<CSS_Parts_Options__c> partsqrylst = new list<CSS_Parts_Options__c>();
                if(orgtype == 'DISTR'){
                    partsqrylst = [Select id,ODM_Status__c,ODM_Status_Message__c,Service_partnumber__c,Account_Code__c
                                   from CSS_Parts_Options__c 
                                   where CSS_Claims__r.CSS_Job__c!=null and CSS_Claims__c!=null and CSS_Claims__c IN :idList and (recordtype.name='BMS Parts' or (recordtype.name='Parts' and Parts_Type__c='Custom'))];
                }
                if(orgtype == 'DLR'){
                    partsqrylst = [Select id,ODM_Status__c,ODM_Status_Message__c,Service_partnumber__c,Account_Code__c
                                   from CSS_Parts_Options__c 
                                   where CSS_Claims__r.CSS_Job__c!=null and CSS_Claims__c!=null and CSS_Claims__c IN :idList and recordtype.name='Parts'];
                }
                for(CSS_Parts_Options__c parts : partsqrylst)
                {
                    if(parts.Account_Code__c != '' && parts.Account_Code__c != null && parts.Account_Code__c != 'Select One' && (!parts.Account_Code__c.contains('61'))){

                        /*if(parts.Service_partnumber__c != null && parts.Service_partnumber__c != '' && POAccountCodeMap.containsKey(parts.Service_partnumber__c+parts.Account_Code__c)){      
                            parts.ODM_Status__c='NA';
                            parts.ODM_Status_Message__c='';
                            ///updateclaimpartList.add(parts);
                        }
                        else{*/
                            //POAccountCodeMap.put(parts.Service_partnumber__c+parts.Account_Code__c, new List<CSS_Parts_Options__c> { parts });  
                            parts.ODM_Status__c='YTBV';
                            parts.ODM_Status_Message__c='';
                            // updatepartOptionList.add(parts);
                        //}
                    }
                    else{
                        parts.ODM_Status__c='NA';
                        parts.ODM_Status_Message__c='';
                    }
                    updateclaimpartList.add(parts);
                }

                //update parts -For manual claim
                //All the selected/checked Parts having account code on ‘Campaigns, TRPs and ATCs’ and all the Parts having account code from User Requested Parts should be passed to the ODM Parts service for the respective account code.
                for(CSS_Parts_Options__c parts : [Select id,ODM_Status__c,ODM_Status_Message__c,Service_partnumber__c,Account_Code__c
                                                  from CSS_Parts_Options__c 
                                                  where CSS_Claims__r.CSS_Job__c=null and CSS_Claims__c!=null and CSS_Claims__c IN :idList and recordtype.name='Parts' and selected_part__c=true])
                {
                    if(parts.Account_Code__c != '' && parts.Account_Code__c != null && parts.Account_Code__c != 'Select One' && (!parts.Account_Code__c.contains('61'))){
                        /*if(parts.Service_partnumber__c != null && parts.Service_partnumber__c != '' && POAccountCodeMap.containsKey(parts.Service_partnumber__c+parts.Account_Code__c))
                        {      
                            parts.ODM_Status__c='NA';
                            parts.ODM_Status_Message__c='';
                            // updatepartOptionList.add(parts);
                        }
                        else
                        {*/
                            //POAccountCodeMap.put(parts.Service_partnumber__c+parts.Account_Code__c, new List<CSS_Parts_Options__c> { parts });  
                            parts.ODM_Status__c='YTBV';
                            parts.ODM_Status_Message__c='';
                            //updatepartOptionList.add(parts);
                        //}
                    }
                    else
                    {
                        parts.ODM_Status__c='NA';
                        parts.ODM_Status_Message__c='';
                    }
                    updateclaimpartList.add(parts);
                }  
            }

           
            if(claimList != null && claimList.size()>0)
            {
                //GSSC-241 Start
                String ytbvCheckParts='';
                if(updateclaimpartList !=null && updateclaimpartList.size()>0){
                    for(CSS_Parts_Options__c parts:updateclaimpartList){
                        if(parts.ODM_Status__c=='YTBV'){
                            ytbvCheckParts='YTBV';
                            break;
                        }
                        else if(parts.ODM_Status__c=='NA'){
                            ytbvCheckParts='NA';
                        }
                        else{
                            ytbvCheckParts='';
                        }
                    }
                }
                //GSSC-241 End

                for(css_claims__c claim: claimList)
                {//code below added part of story #155918
                    if(orgtype == 'DLR')//Dealers will not be eligible for information only automated claims, so check for manual claim only
                    {
                        //If the information only check box is checked then claims cannot receive warranty reimbursement. 
                        if(claim.Information_Only_Claim__c!=null && claim.Information_Only_Claim__c==true && (claim.CSS_Job__c==null || claim.CSS_Job__c=='')) 
                        { 
                            for(CSS_Parts_Options__c parts1 : [Select id,ODM_Status__c,ODM_Status_Message__c,Service_partnumber__c,Account_Code__c
                                                               from CSS_Parts_Options__c where CSS_Claims__r.CSS_Job__c=null and CSS_Claims__c!=null and CSS_Claims__c =:claim.id])
                            {
                                parts1.ODM_Status__c='NA';
                                parts1.ODM_Status_Message__c='';
                                parts1.Info_Only_Claim__c = TRUE;
                                if(parts1.ODM_Status__c=='NA')
                                    system.debug('*************Sucess Dealer .*************');
                                updateclaimpartList1.add(parts1);
                            }

                        }
                    }
                    else if(orgtype == 'DISTR')//Distributor eligible for automated and manual claim hence no condition
                    {

                        solutionList=[Select id,ODM_Status__c,ODM_Status_Message__c,CSS_Account_Formula__c from CSS_Solution_Component__c where CSS_Claims__c = :claim.id and Pay_Code__c ='A'];


                        if(solutionList!=null && solutionList.size()>0 )
                        {

                            for(CSS_Parts_Options__c parts1 : [Select id,ODM_Status__c,ODM_Status_Message__c,Service_partnumber__c,Account_Code__c
                                                               from CSS_Parts_Options__c where CSS_Claims__c!=null and CSS_Claims__c =:claim.id])
                            { 
                                parts1.ODM_Status__c='NA';
                                parts1.ODM_Status_Message__c='';
                                parts1.Info_Only_Claim__c = TRUE;
                                if(parts1.ODM_Status__c=='NA')
                                    system.debug('*************Sucess Distributor .*************');
                                updateclaimpartList1.add(parts1);
                            }

                        }
                    }    
                    //code ended part of story #155918
                    
                    //GSSC-241
                    if(ytbvCheckParts=='YTBV'){
                        claim.Parts_ODM_Status__c='YTBV';
                        system.debug('If ytbvCheckParts >>' +  claim.Parts_ODM_Status__c);
                    }
                    else if(ytbvCheckParts=='NA'){
                        claim.Parts_ODM_Status__c='NA';
                    }
                    else{
                        claim.Parts_ODM_Status__c='';
                    }
                    claim.ODM_Pre_submit_Status__c = 'YTBV';    
                    updateclaimList.add(claim);
                     system.debug('Today updateclaimList >>' +  updateclaimList);
                }
            }
            
              if(updateclaimList != null && updateclaimList.size() >0)
            {
                update updateclaimList;
            }

            if(updatejobpartList != null && updatejobpartList.size() >0)
            {
                update updatejobpartList;
            }
            if(updateclaimpartList != null && updateclaimpartList.size() >0)
            {
                update updateclaimpartList;
            }
            if(updateclaimpartList1!=null && updateclaimpartList1.size()>0)
            {
                update updateclaimpartList1;
            }
            system.debug('Updated**');
        }
        catch(Exception ex)  
        {
            system.debug('EXCEPTION of updatePartODMStatus from process builder >>> '+ex.getMessage() + ' ' + ex.getLineNumber() + ' ' +ex.getCause());
        }
        
    }

}