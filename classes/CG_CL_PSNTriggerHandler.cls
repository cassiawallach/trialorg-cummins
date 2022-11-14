public class CG_CL_PSNTriggerHandler
{
    public static void onBeforeUpdate(List<CSS_PSN__c> newList,Map<id,CSS_PSN__c> oldMap )
    {
        updateCoverageFlag(newlist,oldmap);  
    }

    public static void updateCoverageFlag(List<CSS_PSN__c> newList,Map<id,CSS_PSN__c> oldMap)
    {
        for(CSS_PSN__c psn:newList)
        {
            //if(psn.PSN__c<>null && psn.PSN__c<>oldmap.get(psn.id).psn__c){
            if(psn.PSN__c<>oldmap.get(psn.id).psn__c){
                psn.CoverageFlag__c=true;
                CSS_Claims__c claimRec = [SELECT Id, CoverageResponse__c  FROM CSS_Claims__c WHERE Id = :psn.CSS_Claims__c];
                claimRec.CoverageResponse__c = '';
                update claimRec;
                System.debug('After update....');
            }

        }

    }
    public static void AfterInsert(List<CSS_PSN__c> newList)
      {
            system.debug('isInsert***');
            list<CSS_CampTsbTrp__c> campListToInsert = new list<CSS_CampTsbTrp__c>();
             set<string> oldEsnNums = new set<string>();
             set<Id> jobIds = new set<Id>();
             for( css_psn__c PsnRec: newList) {
                 
                 //Insert records into CampTsbTrp Object with claim id - START
                 User u3 = css_utility.getUserAttributes(userinfo.getUserId()); 
        CSS_accountLanguage__c aLan = css_utility.getLanguage(u3.LanguageLocaleKey);
                 system.debug('userinfo.getUserid**'+userinfo.getUserId());
                 system.debug('User**'+u3);
                 system.debug('aLan**'+aLan);
                 //list for Campaigns to insert.
            list<CSS_JobEventTemporary__c> campTsbTrpList = new list<CSS_JobEventTemporary__c>();
            list<CSS_JobEventTemporary__c> langqsol = new list<CSS_JobEventTemporary__c>();
            
            
            //get Service jobs and thier corresponding Campaigns based on esn numbers and get the first Service job Campaigns to clone for new Service Job.
            if(PsnRec.psn__c != null){
                
                
                list<CSS_JobEventTemporary__c>  jetCampList = [Select Id,Name,Key__c,Attribute1__c,JobOrder__c,Attribute2__c,Attribute3__c,Attribute7__c,Attribute8__c,Attribute9__c from CSS_JobEventTemporary__c where Key__c = :PsnRec.psn__c and Name = 'QSOL' LIMIT 1000];
                
                system.debug('$$$$$$$'+jetCampList);
                if(jetCampList != null && !jetCampList.isEmpty()){
                                       
                    for(CSS_JobEventTemporary__c frlang: jetCampList ){
                        if(frlang.Attribute3__c == alan.CSS_QsolLanguage__c){
                            langqsol.add(frlang);
                        }
                    } 
                    
                    if(campTsbTrpList.isEmpty()){
                        campTsbTrpList.addAll(langqsol);
                    }

                }
                 //List to insert new CampTsbTrp records.
           // list<CSS_CampTsbTrp__c> campListToInsert = new list<CSS_CampTsbTrp__c>();
            if(campTsbTrpList != null && !campTsbTrpList.isEmpty()){
                    for(CSS_JobEventTemporary__c campTsbTrpRec : campTsbTrpList){
                        CSS_CampTsbTrp__c campRec = new CSS_CampTsbTrp__c();
                        campRec.Name = campTsbTrpRec.Attribute1__c;
                        campRec.Type__c = campTsbTrpRec.Attribute2__c;
                        campRec.Cu_Language__c = campTsbTrpRec.Attribute3__c;
                        campRec.Doc_Num__c = campTsbTrpRec.Attribute7__c;
                        campRec.Doc_Title__c = campTsbTrpRec.Attribute8__c;
                        campRec.URL__c = campTsbTrpRec.Attribute9__c;
                        campRec.ESN__c = campTsbTrpRec.Key__c;
                        campRec.CSS_Claims__c = PsnRec.css_claims__c;
                        campListToInsert.add(campRec);
                        //  }  
                        
                    }
                }else{
                    // Added language parameter for quickserve integration - start
                    system.debug('Trigger TEST123');
                    CSS_QuickServe.getQsolDocSave(PsnRec.css_claims__c,PsnRec.pSN__c, aLan.CSS_QsolLanguage__c);
                    // Added language parameter for quickserve integration - end
                    
                }            
              System.debug('in insert $$$$$$$$...'+PsnRec.Failure_Date__c);
              //system.debug('PsnRec.CSS_Claims__r.IsCopyclaim__c -- ' + PsnRec.CSS_Claims__r.IsCopyclaim__c);
              system.debug('PsnRec.CSS_Claims__r.Dealer_Service_Job__c-->'+PsnRec.CSS_Claims__r.Dealer_Service_Job__c);
              system.debug('PsnRec.CSS_Claims__r.CSS_Job__c-->'+PsnRec.CSS_Claims__r.CSS_Job__c);
                string FailureDateString;
                if(PsnRec.Failure_Date__c != null){
                    System.debug('in insert before calling $$$$$$$$...');
                    FailureDateString = DateTime.newInstance(PsnRec.Failure_Date__c.year(),PsnRec.Failure_Date__c.month(),PsnRec.Failure_Date__c.day()).format('dd-MMM-YY');
                    if(PsnRec.CSS_Claims__r.Dealer_Service_Job__c == null && PsnRec.CSS_Claims__r.CSS_Job__c == null){      // && !PsnRec.CSS_Claims__r.IsCopyclaim__c
                        system.debug('inside if condition');
                        CG_BL_Campaigns.callGetCampaignsWebServiceforClaims(PsnRec.PSN__c, FailureDateString, '','', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', PsnRec.CSS_Claims__c);
                    }
                }
            }
                               
             }//End of FOR
                 
                   //insert new CampTsbTrp records.
            if(campListToInsert != null && !campListToInsert.isEmpty()){
                system.debug('***campListToInsert-->'+campListToInsert);
                insert campListToInsert;
            }
             
       // }
        
    
      
    //public static void getFieldActionsandInsert()
}
     public static void AfterUpdate(List<CSS_PSN__c> newList,Map<id,CSS_PSN__c> oldMap)
      {
            system.debug('isUpdate***');
             list<CSS_CampTsbTrp__c> campListToInsert = new list<CSS_CampTsbTrp__c>();
             set<string> oldEsnNums = new set<string>();
             set<Id> jobIds = new set<Id>();
             for( css_psn__c PsnRec: newList) {
                 
              if(PsnRec.PSN__c!=oldMap.get(PsnRec.Id).PSN__c || PsnRec.Failure_Date__c!=oldMap.get(PsnRec.Id).Failure_Date__c) {

                 
                 //Insert records into CampTsbTrp Object with claim id - START
                 User u3 = css_utility.getUserAttributes(userinfo.getUserId()); 
        CSS_accountLanguage__c aLan = css_utility.getLanguage(u3.LanguageLocaleKey);
                 //list for Campaigns to insert.
            list<CSS_JobEventTemporary__c> campTsbTrpList = new list<CSS_JobEventTemporary__c>();
            list<CSS_JobEventTemporary__c> langqsol = new list<CSS_JobEventTemporary__c>();
            
            
            //get Service jobs and thier corresponding Campaigns based on esn numbers and get the first Service job Campaigns to clone for new Service Job.
            if(PsnRec.psn__c != null){
                
                
                list<CSS_JobEventTemporary__c>  jetCampList = [Select Id,Name,Key__c,Attribute1__c,JobOrder__c,Attribute2__c,Attribute3__c,Attribute7__c,Attribute8__c,Attribute9__c from CSS_JobEventTemporary__c where Key__c = :PsnRec.psn__c and Name = 'QSOL' LIMIT 1000];
                
                system.debug('$$$$$$$'+jetCampList);
                if(jetCampList != null && !jetCampList.isEmpty()){
                                       
                    for(CSS_JobEventTemporary__c frlang: jetCampList ){
                        if(frlang.Attribute3__c == alan.CSS_QsolLanguage__c){
                            langqsol.add(frlang);
                        }
                    } 
                    
                    if(campTsbTrpList.isEmpty()){
                        campTsbTrpList.addAll(langqsol);
                    }

                }
                 //List to insert new CampTsbTrp records.
            //list<CSS_CampTsbTrp__c> campListToInsert = new list<CSS_CampTsbTrp__c>();
            if(campTsbTrpList != null && !campTsbTrpList.isEmpty()){
                    for(CSS_JobEventTemporary__c campTsbTrpRec : campTsbTrpList){
                        CSS_CampTsbTrp__c campRec = new CSS_CampTsbTrp__c();
                        campRec.Name = campTsbTrpRec.Attribute1__c;
                        campRec.Type__c = campTsbTrpRec.Attribute2__c;
                        campRec.Cu_Language__c = campTsbTrpRec.Attribute3__c;
                        campRec.Doc_Num__c = campTsbTrpRec.Attribute7__c;
                        campRec.Doc_Title__c = campTsbTrpRec.Attribute8__c;
                        campRec.URL__c = campTsbTrpRec.Attribute9__c;
                        campRec.ESN__c = campTsbTrpRec.Key__c;
                        campRec.CSS_Claims__c = PsnRec.css_claims__c;
                        campListToInsert.add(campRec);
                        //  }  
                        
                    }
                }else{
                    // Added language parameter for quickserve integration - start
                    system.debug('Trigger TEST123');
                    CSS_QuickServe.getQsolDocSave(PsnRec.css_claims__c,PsnRec.pSN__c, aLan.CSS_QsolLanguage__c);
                    // Added language parameter for quickserve integration - end
                    
                }            



                System.debug('in insert $$$$$$$$...'+PsnRec.Failure_Date__c);
                //system.debug('PsnRec.CSS_Claims__r.IsCopyclaim__c --- ' + PsnRec.CSS_Claims__r.IsCopyclaim__c);
                string FailureDateString;
                if(PsnRec.Failure_Date__c != null){     // && !PsnRec.CSS_Claims__r.IsCopyclaim__c
                    System.debug('in insert before calling $$$$$$$$...');
                    FailureDateString = DateTime.newInstance(PsnRec.Failure_Date__c.year(),PsnRec.Failure_Date__c.month(),PsnRec.Failure_Date__c.day()).format('dd-MMM-YY');
                    CG_BL_Campaigns.callGetCampaignsWebServiceforClaims(PsnRec.PSN__c, FailureDateString, '','', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', PsnRec.CSS_Claims__c);
                }
            }
                   if(PsnRec.psn__c!=null && PsnRec.psn__c != oldMap.get(PsnRec.Id).psn__c){
                    System.debug('The id is'+PsnRec.Id);
                    //esnNums.add(cjb.esn__c);
                    if(oldMap.get(PsnRec.Id).psn__c != null){
                        oldEsnNums.add(oldMap.get(PsnRec.Id).psn__c);
                        
                    }                
                    jobIds.add(PsnRec.Id);
                }else if(PsnRec.psn__c==null){
                    jobIds.add(PsnRec.Id);
                }      
             
        }
        
    }//End of For Loop
              if(jobIds != null && !jobIds.isEmpty() && oldEsnNums != null && !oldEsnNums.isEmpty()){
                system.debug('Deleting***');
                list<CSS_CampTsbTrp__c> campTsTrList = [Select Id from CSS_CampTsbTrp__c where css_claims__c IN :jobIds and ESN__c IN :oldEsnNums];
                
                if(campTsTrList != null && !campTsTrList.isEmpty()){
                    
                    delete campTsTrList;
                }
                
            }
                              //insert new CampTsbTrp records.
            if(campListToInsert != null && !campListToInsert.isEmpty()){
                system.debug('***campListToInsert-->'+campListToInsert);
                insert campListToInsert;
            }
            

         }
    
      
    //public static void getFieldActionsandInsert()

}