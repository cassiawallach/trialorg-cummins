/**********************************************************************
Name:CG_CL_ClaimsTriggerHandler
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this triggerhandler for calling getServiceProviderDataClaims after update of claims location.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL  
1.0 -   Arpita Sarangee    4/2/2018      Added code as part of user story 137880
***********************************************************************/
public class CG_CL_ClaimsTriggerHandler
{ 
    public static boolean flag=false;
    public static void onAfterUpdate(List<CSS_Claims__c> newList,Map<id,CSS_Claims__c> oldMap){
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        Set<Id> claimsIds = new Set<Id>();
        try{
            if(flag==false){ 
                for(CSS_Claims__c claimsObj:newList){
                    //system.debug('claimsObj.Location_Code__c**'+claimsObj.Location_Code__c);
                    //system.debug('oldMap.get(claimsObj.id).Location_Code__c**'+oldMap.get(claimsObj.id).Location_Code__c);
                    if(claimsObj.Location_Code__c !=oldMap.get(claimsObj.id).Location_Code__c){
                        claimsIds.add(claimsObj.Id); 
                    }
                }
                if(claimsIds!=null){
                    psnList = [select id,psn__c,failure_date__c, CSS_Claims__c, CSS_Claims__r.Location_Code__c, Primary__c from css_psn__c where Primary__c = true and CSS_Claims__c in :claimsIds];
                }            

                if(psnList !=null){
                    for(CSS_PSN__c psnObj : psnList){
                        //system.debug('in afterupdateclaimstriggerhandler $$$$$$$$...');
                        //system.debug('psnObj**'+psnObj);
                        string FailureDateString;
                        string SPCode;
                        string ServiceModelName='';
                        Id claimID;
                        if(psnObj.Failure_Date__c != null &&  psnObj.CSS_Claims__r.Location_Code__c != null){
                            //System.debug('in afterupdatetriggerhandler before calling qwebservice$$$$$$$$...');
                            FailureDateString = DateTime.newInstance(psnObj.Failure_Date__c.year(),psnObj.Failure_Date__c.month(),psnObj.Failure_Date__c.day()).format('dd-MMM-YY');
                            SPCode = psnObj.CSS_Claims__r.Location_Code__c.split('-')[1];
                            claimID = psnObj.CSS_Claims__c;
                            //System.debug('***SP Code***'+SPCode+'*****ServiceModelName*****'+ServiceModelName+'*****FailureDateString*****'+FailureDateString+'*****ClaimId****'+claimID);
                            updateEPRFlag(SPCode, ServiceModelName, FailureDateString, claimID);
                        }
                    }
                }
            }
        }
        catch(Exception ex){
            System.debug('first in catch of claimstriggerhandler>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());   
        }
    }

    @future(callout=true)
    public static void updateEPRFlag(String SPCode,String ServiceModelName,String FailureDateString, Id claimId){
        system.debug('insideupdateEPRFlag**');
        CSS_FN_SIEBEL.getServiceProviderDataClaims(SPCode, ServiceModelName, FailureDateString, claimId);  
    }

    public static void changeOwnerInfo(List<CSS_Claims__c> ClaimRecords)
    {
        List<CSS_Claims__c> lstClaims = new List<CSS_Claims__c>();

        List<String> Locations = new List<String>();

        for(CSS_Claims__c ul : ClaimRecords ){
            Locations.add('CQ' + '-' + ul.Location_Code__c);
            system.debug('Claimslocations' + ' ' +locations);
        }

        List<Group> queues= [select id, Name from Group where Type='Queue' AND Name IN:Locations];
        system.debug('queues' + ' ' +queues);

        Map<string,ID> mapClaimsSpecificLoc = new Map<string,ID>();

        for(Group q:queues){

            if(!mapClaimsSpecificLoc.containsKey(q.Name))
                mapClaimsSpecificLoc.put(q.Name,q.id);
            system.debug('mapClaimsSpecificLoc-->'+mapClaimsSpecificLoc);
        }

        for(CSS_Claims__c ClaimsList: ClaimRecords) {
            if(ClaimsList != null && ClaimsList.Location_Code__c != null && ClaimsList.Location_Code__c != '') {
                system.debug('EACH CLAIM RECORD FOR ClaimsList.Location_Code__c-->'+ClaimsList.Location_Code__c);
                CSS_Claims__c claim = new CSS_Claims__c();
                claim.Id = ClaimsList.Id;
                claim.OwnerId  = mapClaimsSpecificLoc.get('CQ-'+ClaimsList.Location_Code__c);
                system.debug('EACH CLAIM RECORD FOR SP-->'+claim);
                lstClaims.add(claim);
            }
        } 

        system.debug('lstClaims-->'+lstClaims);
        if(lstClaims.size()>0)
            update lstClaims; 
    }
    ////Method for creating a record into CSS_JobHistory__c object when claim is created as per story #180130 14th May 2019
     public static void creatingJobHistoryRecord(List<CSS_Claims__c> ClaimRecords){
         list<CSS_JobHistory__c> listHistRec = new list<CSS_JobHistory__c>();
         for(CSS_Claims__c ClaimsList: ClaimRecords) {
             if(ClaimsList != null && (ClaimsList.CSS_Job__c!=null || ClaimsList.Dealer_Service_Job__c!=null)) {
                 CSS_JobHistory__c histRec = new CSS_JobHistory__c();
                 
                 //histRec.CSS_Job_Id__c     = ClaimsList.CSS_Job__c;
                 histRec.CSS_Job_Id__c     = ClaimsList.CSS_Job__c!=null ? ClaimsList.CSS_Job__c : ClaimsList.Dealer_Service_Job__c;
                 histRec.CSS_Field_Name__c = ClaimsList.name;
                 histRec.CSS_Old_Value__c  = 'InsertionPass';
                 histRec.CSS_New_Value__c  = ClaimsList.name; 
                 listHistRec.add(histRec);
             }
         }
          system.debug('*****insertion record listHistRec****'+listHistRec);
          if(listHistRec.size()>0)
            insert listHistRec;
     }
    //Method for creating a record into CSS_JobHistory__c object when claim is deleted as per story #180130 14th May 2019. 
         public static void deletingJobHistoryRecord(List<CSS_Claims__c> ClaimRecords){
             system.debug('*****inside deletingJobHistoryRecord****');
         list<CSS_JobHistory__c> listHistRec = new list<CSS_JobHistory__c>();
         for(CSS_Claims__c ClaimsList: ClaimRecords) {
             if(ClaimsList != null && (ClaimsList.CSS_Job__c!=null || ClaimsList.Dealer_Service_Job__c!=null)) {
                 CSS_JobHistory__c histRec = new CSS_JobHistory__c();
                 
                 //histRec.CSS_Job_Id__c     = ClaimsList.CSS_Job__c;
                 histRec.CSS_Job_Id__c     = ClaimsList.CSS_Job__c!=null ? ClaimsList.CSS_Job__c : ClaimsList.Dealer_Service_Job__c;
                 histRec.CSS_Field_Name__c = ClaimsList.name;
                 histRec.CSS_Old_Value__c  = 'DeletionPass';
                 histRec.CSS_New_Value__c  = ClaimsList.name; 
                 listHistRec.add(histRec);
             }
         }
          system.debug('***** Deletion record listHistRec****'+listHistRec);
          if(listHistRec.size()>0)
            insert listHistRec;
     }
    //End
}