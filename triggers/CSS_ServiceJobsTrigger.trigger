trigger CSS_ServiceJobsTrigger on CSS_Job_Order__c (before insert,before update,before delete,after insert,after update,after undelete) {

    //CSS_accountLanguage__c aLan = css_utility.getLanguage((String)Cache.Session.get('local.CSSPartition.UserLanguageLocaleKey'));
    //  public list<user> userlang{get; set;}
   
    CSS_Trigger_Controller__c triggerActive = new CSS_Trigger_Controller__c();
    triggerActive = CSS_Trigger_Controller__c.getValues('Service Job Trigger');
    system.debug('triggerActive'+triggerActive);
    if(triggerActive != null && triggerActive.Service_Job_Trigger_Active__c == true){

        //Before Insert 
        if(Trigger.isBefore) 
        {
            //CSS_ServiceJob Before Insert Helper 
            if(Trigger.isInsert)
            {
                if(css_checkRecursive.runOnce()){
                    CSS_serviceJobRecentVisit rv = new CSS_serviceJobRecentVisit();
                    rv.assignToSharing(trigger.new,trigger.oldmap);
                }

            }
            //CSS_ServiceJob Before Update Helper
            else if(Trigger.isUpdate){
                Boolean deAdminEnabled = trigger.new[0].Account__r.Data_Exchange_Enabled__c;//css_utility.getDEEnabled(userinfo.getUserId());
                if(css_checkRecursive.runOnce()){
                    CSS_serviceJobRecentVisit rv = new CSS_serviceJobRecentVisit();
                    rv.assignToSharing(trigger.new,trigger.oldmap);
                }
                if(deAdminEnabled == true){
                    system.debug('Inside Trigger');
                    CSS_DataExchangeHelper rvDataExchange = new CSS_DataExchangeHelper();
                    rvDataExchange.insertDEParent(trigger.new,trigger.oldmap);
                }

            }
            //CSS_ServiceJob Before Delete Helper
            else if(Trigger.isDelete){

            }

        }

        //Code for Inserting Campaigns
        if(Trigger.isAfter) {
            if(Trigger.isInsert) {
                for( CSS_Job_Order__c jobRecId : Trigger.new) {
                    System.debug('in insert $$$$$$$$...'+jobRecId.Failure_Date__c);
                    string FailureDateString;
                    if(jobRecId.Failure_Date__c != null){
                        System.debug('in insert before calling $$$$$$$$...');
                        FailureDateString = DateTime.newInstance(jobRecId.Failure_Date__c.year(),jobRecId.Failure_Date__c.month(),jobRecId.Failure_Date__c.day()).format('dd-MMM-YY');
                        CG_BL_Campaigns.callGetCampaignsWebService(jobRecId.ESN__c, FailureDateString, jobRecId.Region__c, jobRecId.Territory_Class__c, 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', jobRecId.Name, jobRecId.Id);
                    }
                }
            }
            if(Trigger.IsUpdate) {
                for( CSS_Job_Order__c jobRecId : Trigger.new) {
                    System.debug('in update $$$$$$$$...'+jobRecId.Failure_Date__c);
                     if(jobRecId.ESN__c!=trigger.oldMap.get(jobRecId.Id).ESN__c || jobRecId.Failure_Date__c!=trigger.oldMap.get(jobRecId.Id).Failure_Date__c || jobRecId.Mileage__c!=trigger.oldMap.get(jobRecId.Id).Mileage__c || jobRecId.ApplicationCode__c!=trigger.oldMap.get(jobRecId.Id).ApplicationCode__c || jobRecId.Mileage_Measure__c!=trigger.oldMap.get(jobRecId.Id).Mileage_Measure__c || jobRecId.CSS_Hours__c!=trigger.oldMap.get(jobRecId.Id).CSS_Hours__c && jobRecId.PSN_Not_Available__c!=true) {
                        string FailureDateString;
                        if(jobRecId.Failure_Date__c != null){
                            System.debug('in update before calling $$$$$$$$...');
                            FailureDateString = DateTime.newInstance(jobRecId.Failure_Date__c.year(),jobRecId.Failure_Date__c.month(),jobRecId.Failure_Date__c.day()).format('dd-MMM-YY');
                            System.debug('in update before calling $$$$$$$$...FailureDateString>>>:'+FailureDateString);
                            CG_BL_Campaigns.callGetCampaignsWebService(jobRecId.ESN__c, FailureDateString, jobRecId.Region__c, jobRecId.Territory_Class__c, 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', jobRecId.Name, jobRecId.Id);
                        }
                    }                    
      //start code as per Story $189313,-By RAJESH 18th July 2019
                   /* system.debug('**jobRecId.CSS_Hours__c**'+jobRecId.CSS_Hours__c);
                    system.debug('**jobRecId.ApplicationCode__c**'+jobRecId.ApplicationCode__c);
                    system.debug('**jobRecId.Mileage__c**'+jobRecId.Mileage__c);
                    system.debug('**jobRecId.Mileage_Measure__c**'+jobRecId.Mileage_Measure__c);
                    if((jobRecId.Mileage__c!=trigger.oldMap.get(jobRecId.Id).Mileage__c || jobRecId.ApplicationCode__c!=trigger.oldMap.get(jobRecId.Id).ApplicationCode__c || jobRecId.Mileage_Measure__c!=trigger.oldMap.get(jobRecId.Id).Mileage_Measure__c || jobRecId.CSS_Hours__c!=trigger.oldMap.get(jobRecId.Id).CSS_Hours__c) && jobRecId.PSN_Not_Available__c!=true){
                        if(jobRecId.Mileage__c != null && jobRecId.ApplicationCode__c != null && jobRecId.Mileage_Measure__c != null && jobRecId.CSS_Hours__c != null ){
                            system.debug('**enter inside calling the getWarrantyDetailsCoverage service**');
                            set<id> serviceJobId = new set<id>();
                            for(integer i=0;i<trigger.new.size();i++){
                                system.debug('**New Job Rec Ids**'+trigger.new[i].id); 
                                serviceJobId.add(trigger.new[i].id);
                            }
                            system.debug('**serviceJobId**'+serviceJobId);
                            CG_GetWarrantyDetailesHelper.getWarrantyDetailesForJob(serviceJobId);
                        }
                    }
                    */
      //End code as per Story $189313,-By RAJESH 18th July 2019  
                }
            }
        }

        if(Trigger.isAfter) 
        {
            //CSS_ServiceJob After Insert Helper 
            User u3 = css_utility.getUserAttributes(userinfo.getUserId()); 
            CSS_accountLanguage__c aLan = css_utility.getLanguage(u3.LanguageLocaleKey);
            if(Trigger.isInsert){
                //esn numbers
                //  CSS_ServiceJobTriggerHelper.changeOwnerInfo(trigger.New);
               /* List<css_job_order__c> changeOwnerInfoServiceJobs = new List<css_job_order__c>(); 
                for(css_job_order__c coInfoJob: trigger.new){
                    changeOwnerInfoServiceJobs.add(coInfoJob);
                }
                
                if(changeOwnerInfoServiceJobs != null && changeOwnerInfoServiceJobs.size()>0){
                    CSS_ServiceJobTriggerHelper.changeOwnerInfo(changeOwnerInfoServiceJobs);
                }*/

                set<string> esnNums = new set<string>();
                for(CSS_Job_Order__c cjb : trigger.New){
                    if(cjb.esn__c!=null){
                        esnNums.add(cjb.esn__c);
                    }

                    if (cjb.Mileage__c!=0 && cjb.ESN__c!=null)
                    {
                        //System.debug('RPV Trigger in Insert' + css_utility.getOrgType(userinfo.getUserId()));
                        if(!Test.isRunningTest()){
                            css_rpv.repeatVisit(css_utility.getOrgType(userinfo.getUserId()), cjb.ESN__c, cjb.Mileage__c, cjb.Mileage_Measure__c, cjb.Equipment_ID__c, cjb.name, cjb.DSID__c, cjb.DSID_Creation_Timestamp__c, cjb.RPVControlNumber__c, cjb.Id);
                        }
                    }
                }

                //Story 68615-Qsol Options Start
                System.debug('calling Options');
                Map<Id,String> mJobESN = new Map<Id,String>();
                for(CSS_Job_Order__c cjob : trigger.New){
                    if(cjob.esn__c!=null){
                        mJobESN.put(cjob.Id,cjob.esn__c);                    
                    }

                }
                if(system.isFuture()==false){
                    if(!Test.isRunningTest()){
                        System.debug('calling Options1');
                        System.debug('mJobESN is'+mJobESN);
                        CSS_QuickServe.getJobOptions(mJobESN, false);
                    }
                }

                //Story 68615-Qsol Options End

                //map of CampTsbTrps and esn Numbers
                map<string,list<CSS_JobEventTemporary__c>> esnCampTsbMap = new map<string,list<CSS_JobEventTemporary__c>>();

                //retrieve CampTsbTrps

                if(esnNums != null && !esnNums.isEmpty()){
                    system.debug('esnNums'+esnNums);
                  
                    //  list<CSS_CampTsbTrp__c> campTsbList = [Select Id,Name,Type__c,Job_Order__c,ESN__c,Doc_Num__c,Doc_Title__c,URL__c from CSS_CampTsbTrp__c where ESN__c IN : esnNums AND ESN__c != null];
                    list<CSS_JobEventTemporary__c>  campTsbList = [Select Id,Key__c,Name,Attribute1__c,JobOrder__c,Attribute2__c,Attribute3__c,Attribute7__c,Attribute8__c,Attribute9__c from CSS_JobEventTemporary__c where Key__c IN :esnNums and Name = 'QSOL' LIMIT 1000];
                    system.debug('@@@@@@@'+campTsbList);
                    if(campTsbList != null && !campTsbList.isEmpty()){                
                        for(CSS_JobEventTemporary__c campTsb : campTsbList){
                            if(esnCampTsbMap.get(campTsb.Key__c) != null){
                                list<CSS_JobEventTemporary__c > campList = new list<CSS_JobEventTemporary__c >();
                                campList = esnCampTsbMap.get(campTsb.Key__c);
                                campList.add(campTsb);
                                esnCampTsbMap.put(campTsb.Key__c,campList);
                            }else{
                                list<CSS_JobEventTemporary__c > campList = new list<CSS_JobEventTemporary__c >();
                                campList.add(campTsb);
                                esnCampTsbMap.put(campTsb.Key__c,campList);
                            }
                        }
                    }
                }

                List<css_job_order__c> changeOwnerInfoServiceJobs = new List<css_job_order__c>(); 
                for(css_job_order__c coInfoJob: trigger.new){
                    changeOwnerInfoServiceJobs.add(coInfoJob);
                }
                system.debug('** Service Job'+ '  ' + changeOwnerInfoServiceJobs);
              
                if(changeOwnerInfoServiceJobs != null && changeOwnerInfoServiceJobs.size()>0){
                    CSS_ServiceJobTriggerHelper.changeOwnerInfo(changeOwnerInfoServiceJobs);
                }
                
                //List to insert new CampTsbTrp records.
                list<CSS_CampTsbTrp__c> campListToInsert = new list<CSS_CampTsbTrp__c>();

                for(CSS_Job_Order__c cjb : trigger.New){
                    if(cjb.esn__c!=null){
                        if(!Test.isRunningTest()){
                            system.debug('inside the plate');
                            CSS_QuickServe.getDataPlateDocSave(cjb.id,cjb.esn__c,cjb.Make__c,cjb.Model__c,cjb.PSN_Not_Available__c);

                        }
                        if(esnCampTsbMap != null && esnCampTsbMap.get(cjb.esn__c) != null){
                            for(CSS_JobEventTemporary__c  campTsbTrpRec : esnCampTsbMap.get(cjb.ESN__c)){
                                CSS_CampTsbTrp__c campRec = new CSS_CampTsbTrp__c();
                                //  CSS_CampTsbTrp__c campRec = campTsbTrpRec.clone();
                                campRec.Name = campTsbTrpRec.Attribute1__c;
                                campRec.Type__c = campTsbTrpRec.Attribute2__c;
                                campRec.Cu_Language__c = campTsbTrpRec.Attribute3__c;
                                campRec.Doc_Num__c = campTsbTrpRec.Attribute7__c;
                                campRec.Doc_Title__c = campTsbTrpRec.Attribute8__c;
                                campRec.URL__c = campTsbTrpRec.Attribute9__c;
                                campRec.ESN__c = campTsbTrpRec.Key__c;
                                // campRec.Job_Order__c = trigger.new[0].Id;
                                campRec.Job_Order__c = cjb.Id;
                                campListToInsert.add(campRec);
                            }
                        }else{
                            if(!Test.isRunningTest()){
                                CSS_QuickServe.getQsolDocSave(cjb.id,cjb.esn__c, alan.CSS_QsolLanguage__c);
                            }
                        }
                        if(!Test.isRunningTest()){
                            //User u1 = css_utility.getUserAttributes(userinfo.getUserId()); 
                            //CSS_accountLanguage__c aLang = css_utility.getLanguage(u1.LanguageLocaleKey);
                            CSS_EDSAuthentication.getESNHistory(cjb.id,cjb.ESN__c,aLan.CSS_EDSLanguage__c);
                            system.debug('Trigger BMS Service Call 1'+cjb.ESN__c);

                            //if(css_utility.getBMSEnabled(userinfo.getUserId())){
                            //Modified as per story# 76192
                            if(css_utility.getBMSEnabled(cjb.Creator_Location__c)){
                                //if((Boolean)Cache.Session.get('local.CSSPartition.UserBMSEnabled')){
                                system.debug('Trigger BMS Service Call 2'+cjb.ESN__c);
                                CSS_WS_BMS.callServiceHistoryOutboundService(cjb.ESN__c,cjb.Creator_Location__c);}

                        }
                    }

                }

                //insert new CampTsbTrp records.
                if(campListToInsert != null && !campListToInsert.isEmpty()){
                    insert campListToInsert;
                }

                CSS_ServicejobNotesClass.createNotes(trigger.new);

                List<ID> userList1 = new List<ID>();
                //Get all User ID's based on Owner of the record
                for(CSS_Job_Order__c jobOrder : trigger.new) {
                    userList1.add(jobOrder.ownerID);
                    System.debug('The owner id is'+userList1);
                }
                List<User> recOwnerUsers = [Select id,contactID,AccountId, userName, profile.name,User_Location__c from user where id=:userList1 ];
                css_header_nav__c CS = css_header_nav__c.getInstance(UserInfo.getProfileId());
                System.debug('CS' + CS.EnablePeersSharing__c);
                // Sharing for Peers of Supervisors/ Writers - BEgins
                if(recOwnerUsers.size()>0){
                    Map<Id,String> usersLocs = new Map<Id,String>();
                    Map<Id,Id> usersAccounts = new Map<Id,Id>();
                    Map<Id,Id> mapAccountUserIds = new Map<Id,Id>();
                    Map<Id,Id> mapAcntusrForParIds = new Map<Id,Id>();
                    for(User u:recOwnerUsers){
                        //if(u.AccountId != null || u.AccountId != '')
                        mapAcntusrForParIds.put(u.Id,u.AccountId);
                        //if(u.profile.name.toupperCase().contains('SUPERVISOR') || u.profile.name.toupperCase().contains('WRITER') || u.profile.name.toupperCase().contains('ADVANCED')){  
                        if(CS.EnablePeersSharing__c){
                            system.debug('Enabale peers sharing');
                            if(u.User_Location__c != null && u.User_Location__c != '')
                                usersLocs.put(u.Id,u.User_Location__c);
                            if(u.AccountId != null)
                                system.debug('u.AccountId'+u.AccountId);
                            usersAccounts.put(u.Id,u.AccountId);

                        }
                        system.debug(' ***usersAccounts***' + usersAccounts);
                    }
                    system.debug(' ***usersLocs*** 1 ' + usersLocs);
                    system.debug(' ***recOwnerUsers*** 1 ' + recOwnerUsers);
                    //List<User> sameLocUsers = [select Id,userName,profile.name,User_Location__c,AccountId,UserRole.name from User where isActive=true and (user_location__c IN  :usersLocs.values() or AccountId IN :usersAccounts.values()))];
                    List<User> sameLocAccntUsers;
                    List<User> sameLocUsers;
                    try{
                        system.debug('usersLocs -->' + usersLocs);
                        //Query for distributors
                        if(!usersLocs.isEmpty()) {
                            sameLocUsers = [select Id,userName,profile.name,User_Location__c,UserRole.name from User where isActive=true and user_location__c IN :usersLocs.values()];
                            //Query for dealers
                            if(!usersAccounts.isEmpty()) {
                                System.debug('usersAccounts.isEmpty()'+usersAccounts.isEmpty());
                                sameLocAccntUsers = [select Id,userName,profile.name,User_Location__c,AccountId,UserRole.name from User where isActive=true and user_location__c IN  :usersLocs.values() and AccountId != null and AccountId IN :usersAccounts.values()];
                            }
                        }

                        CSS_ServiceJobTriggerHelper hlper = new CSS_ServiceJobTriggerHelper();
                        system.debug('***After Helper***');
                        //Defect# 62402 fix
                        if (sameLocAccntUsers!=null) {
                            if(sameLocAccntUsers.size() >0) 
                            {
                                //hlper.shareDealerJobs(sameLocAccntUsers, usersAccounts, trigger.new);
                                system.debug(' ***shareDealerJobs***');
                            }
                        }
                        if (sameLocUsers!=null) {
                            if(sameLocUsers.size() > 0) {
                                //hlper.shareDistributorJobs(sameLocUsers, usersLocs, trigger.new);
                                system.debug(' ***shareDistributorJobs***');
                            }
                        }
                        if(mapAcntusrForParIds.size() >0) hlper.shareParentAccountUsers(mapAcntusrForParIds,trigger.new);
                        system.debug(' ***shareParentAccountUsers***');                    
                    }catch(Exception e){
                        System.debug('Sharing Exception' + e.getMessage());
                    }
                }      
            }   
            //CSS_ServiceJob After Update Helper
            else if(Trigger.isUpdate){
                if(css_checkRecursive.runOnce()){
                    CSS_serviceJobRecentVisit rv = new CSS_serviceJobRecentVisit();
                    rv.assignToSharing(trigger.new,trigger.oldmap);
                }

                // Invoke the helperclass to track if the DSID owner changes
                for( CSS_Job_Order__c jobRecId : Trigger.new)
                {
                    if(jobRecId.DSID_Owner__c!=trigger.oldMap.get(jobRecId.Id).DSID_Owner__c)
                    {
                        CSS_ServiceJobTriggerHelper.trackDSIDOwner(trigger.new,trigger.oldMap);
                    }
                    // Invoke the helperclass to track the VIN Changes, only if it is done by user. CUBS# 88616    
                    if(jobRecId.VIN_Flag__c==true && (jobRecId.VIN__c!=trigger.oldMap.get(jobRecId.Id).VIN__c))
                    {
                        CSS_ServiceJobTriggerHelper.trackVIN(trigger.new,trigger.oldMap);
                    }
                }
                system.debug('Inside Update');



                // On change of ESN - Delete History, Recent Visit, TSB, TRP and Service Model, Engine Dataplate 

                //esn numbers
                set<string> esnNums = new set<string>();

                //old esn numbers
                set<string> oldEsnNums = new set<string>();

                set<Id> jobIds = new set<Id>();
                Map<Id,String> mJobESN = new Map<Id,String>();

                for(CSS_Job_Order__c cjb : trigger.New){
                    User u = css_utility.getUserAttributes(userInfo.getUserId());
                    string fedId = u.FederationIdentifier;
                    if(cjb.DSID__c!=null){
                        if(cjb.ESN__c!=trigger.oldMap.get(cjb.Id).ESN__c||cjb.Shop_Work_Order__c!=trigger.oldMap.get(cjb.Id).Shop_Work_Order__c||cjb.Customer_Name__c!=trigger.oldMap.get(cjb.Id).Customer_Name__c || cjb.Make__c!=trigger.oldMap.get(cjb.Id).Make__c || cjb.Model__c!=trigger.oldMap.get(cjb.Id).Model__c || cjb.AccessCode__c!=trigger.oldMap.get(cjb.Id).AccessCode__c ||cjb.Equipment_ID__c!=trigger.oldMap.get(cjb.Id).Equipment_ID__c || cjb.Mileage__c!=trigger.oldMap.get(cjb.Id).Mileage__c || cjb.Mileage_Measure__c!=trigger.oldMap.get(cjb.ID).Mileage_Measure__c || cjb.Unit_Number__c!=trigger.oldMap.get(cjb.Id).Unit_Number__c){
                            css_utility.updateDSID(cjb.DSID__c, fedID, cjb.Customer_Name__c, cjb.Make__c, cjb.Model__c, cjb.AccessCode__c, cjb.Equipment_ID__c, cjb.Mileage__c, cjb.Mileage_Measure__c, cjb.Unit_Number__c,cjb.ESN__c,cjb.Shop_Work_Order__c);
                        }
                    }
                    system.debug('Inside For');
                    system.debug('***cjb.esn__c--->'+cjb.esn__c);
                    if(cjb.esn__c!=null && cjb.esn__c != trigger.oldMap.get(cjb.Id).esn__c){
                        System.debug('The id is'+cjb.Id);
                        esnNums.add(cjb.esn__c);
                        if(trigger.oldMap.get(cjb.Id).esn__c != null){
                            oldEsnNums.add(trigger.oldMap.get(cjb.Id).esn__c);

                        }                
                        jobIds.add(cjb.Id);
                    }else if(cjb.esn__c==null){
                        jobIds.add(cjb.Id);

                    }            
                }

                System.debug('before updating esn$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
                //Story 68615-Qsol Options--Start
                list<CSS_Job_Order__c> basiccov = new list<CSS_Job_Order__c>();
                for(CSS_Job_Order__c updcjb : trigger.New){
                    CSS_Job_Order__c bsccov = new CSS_Job_Order__c ();
                    System.debug('before updcjb.BMSStatus__c>>>>>>>>:'+updcjb.BMSStatus__c);
                    if(updcjb.esn__c != trigger.oldMap.get(updcjb.Id).esn__c || updcjb.Warranty_Start_Date__c!=trigger.oldMap.get(updcjb.Id).Warranty_Start_Date__c || updcjb.Failure_Date__c!=trigger.oldMap.get(updcjb.Id).Failure_Date__c || updcjb.Mileage__c!=trigger.oldMap.get(updcjb.Id).Mileage__c || updcjb.ApplicationCode__c!=trigger.oldMap.get(updcjb.Id).ApplicationCode__c || updcjb.Mileage_Measure__c!=trigger.oldMap.get(updcjb.Id).Mileage_Measure__c || updcjb.CSS_Hours__c!=trigger.oldMap.get(updcjb.Id).CSS_Hours__c && updcjb.PSN_Not_Available__c!=true){//GSSC-307 changes
                        mJobESN.put(updcjb.Id, updcjb.ESN__c);
                        
                        bsccov.id = updcjb.id;
                        bsccov.CoverageResponse__c ='';
                        bsccov.EditCoverage__c ='';


                        //stem.debug('bsccov.BMSStatus__c>>>>>>>>:'+bsccov.BMSStatus__c);
                        //if(bsccov.BMSStatus__c !=null && bsccov.BMSStatus__c.trim() !='')
                        //  bsccov.BMSStatus__c = bsccov.BMSStatus__c.replace('UI0','');
                        basiccov.add(bsccov);
                    }
                }
                if(!basiccov.isEmpty()){
                    update basiccov;
                }
                if(system.isFuture()==false){
                    if(!Test.isRunningTest()){
                        System.debug('mJobESN is'+mJobESN);
                        CSS_QuickServe.getJobOptions(mJobESN, false);
                    }
                }
                //Story 68615-Qsol Options--End
                //delete old campTsbTrps
                if(jobIds != null && !jobIds.isEmpty() && oldEsnNums != null && !oldEsnNums.isEmpty()){

                    list<CSS_CampTsbTrp__c> campTsTrList = [Select Id from CSS_CampTsbTrp__c where Job_Order__c IN :jobIds and ESN__c IN :oldEsnNums];

                    if(campTsTrList != null && !campTsTrList.isEmpty()){

                        delete campTsTrList;
                    }
                    list<CSS_Parts_Options__c> partlistdel = [Select Id from CSS_Parts_Options__c where Service_Job__c IN :jobIds and Option_ESN__c  IN : oldEsnNums];
                    if(partlistdel != null && !partlistdel.isEmpty()){
                        delete partlistdel;
                    }
                    //Nullify Repeat Visit and Recent Visit

                    //  trigger.new[0].Repeat_Visit__c= false;
                    String currentBMSStat ;
                    list<CSS_Job_Order__c> repvis = new list<CSS_Job_Order__c>();
                    for(CSS_Job_Order__c cjb : trigger.New){

                        currentBMSStat = cjb.BMSStatus__c ==null?'':cjb.BMSStatus__c ;

                        CSS_Job_Order__c rep = new CSS_Job_Order__c ();
                        if(cjb.esn__c!=null && cjb.esn__c != trigger.oldMap.get(cjb.Id).esn__c){

                            System.debug('CheckforESNChanged>>>>>>>>:'+cjb.esn__c);
                            rep.Repeat_Visit__c = false;
                            //rep.BMSWSStatus__c ='UI';
                            currentBMSStat=currentBMSStat+',esnChanged';
                            System.debug('CheckforReplaceBefore>>>>>>>>:'+cjb.BMSStatus__c);
                            // On change of ESN, replacing BMS Unit Inbound status UI0 to Blank
                            if(cjb.BMSStatus__c !=null && cjb.BMSStatus__c.trim() !=''){                               
                                //rep.BMSStatus__c = cjb.BMSStatus__c.replace('UI0','');
                                rep.BMSStatus__c = currentBMSStat.replace('UI0','');
                            } else{

                                rep.BMSStatus__c=currentBMSStat;
                            }
                            rep.id = cjb.id;
                            repvis.add(rep);
                        }
                    }   
                    system.debug('repvis is '+repvis);
                    //update repvis;

                    //Delete Service History

                    //Delete CD Alert 
                    list<CSS_ConnectedDiagnostics__c> CDalert= [Select Id from CSS_ConnectedDiagnostics__c where CSSJobID__c IN :jobIds and ESN__c IN :oldEsnNums];
                    if(CDalert!= null && !CDalert.isEmpty()){
                        delete CDalert;
                    }
                }



                //Make and Model udpate changes
                if((trigger.new[0].Qsol_Engine_Family_Code__c!=Trigger.oldMap.get(trigger.new[0].Id).Qsol_Engine_Family_Code__c) || (trigger.new[0].Model__c!=Trigger.oldMap.get(trigger.new[0].Id).Model__c) || (trigger.new[0].Make__c!=Trigger.oldMap.get(trigger.new[0].Id).Make__c))
                    CSS_MakeAndModel.updateEquipmentId(trigger.new, trigger.oldMap);


                CSS_ServicejobNotesClass.updateNotes(trigger.new,trigger.oldMap);
               // CSS_addnlAuditTracking.css_jobHistoryAddnlAuditTracking(trigger.new,trigger.oldMap);- Commented by Anirudh as we are not using this. Please revert if any functionality is breaking



                if(jobIds != null && !jobIds.isEmpty()){
                    list<CSS_CampTsbTrp__c> campTsTrList = [Select Id from CSS_CampTsbTrp__c where Job_Order__c IN :jobIds];
                    if(campTsTrList != null && !campTsTrList.isEmpty()){
                        delete campTsTrList;
                    }
                }

                //list for Campaigns to insert.
                list<CSS_JobEventTemporary__c> campTsbTrpList = new list<CSS_JobEventTemporary__c>();
                list<CSS_JobEventTemporary__c> langqsol = new list<CSS_JobEventTemporary__c>();
                list<CSS_CampTsbTrp__c> langqsol1 = new list<CSS_CampTsbTrp__c>();

                //get Service jobs and thier corresponding Campaigns based on esn numbers and get the first Service job Campaigns to clone for new Service Job.
                if(esnNums != null && !esnNums.isEmpty()){

                    //list<CSS_Job_Order__c>  jobOrderList = [Select Id, (Select Id,Name,Type__c,Job_Order__c,ESN__c,Doc_Num__c,Doc_Title__c,URL__c,Cu_Language__c from CSS_CampTsbTrp__r) from CSS_Job_Order__c where esn__c IN :esnNums];
                    list<CSS_JobEventTemporary__c>  jobOrderList = [Select Id,Name,Key__c,Attribute1__c,JobOrder__c,Attribute2__c,Attribute3__c,Attribute7__c,Attribute8__c,Attribute9__c from CSS_JobEventTemporary__c where Key__c IN :esnNums and Name = 'QSOL' LIMIT 1000];

                    system.debug('$$$$$$$'+jobOrderList);
                    if(jobOrderList != null && !jobOrderList.isEmpty()){
                        // for(CSS_Job_Order__c jobOrd : jobOrderList){
                        //    if(jobOrd.CSS_CampTsbTrp__r != null && !jobOrd.CSS_CampTsbTrp__r.isEmpty() ){

                        // filtering the records based on user language - start

                        //  langqsol.add(jobOrd.CSS_CampTsbTrp__r);

                        for(CSS_JobEventTemporary__c frlang: jobOrderList ){
                            if(frlang.Attribute3__c == alan.CSS_QsolLanguage__c){
                                langqsol.add(frlang);
                            }
                        } 

                        if(campTsbTrpList.isEmpty()){
                            // system.debug('***jobOrd Id-->'+jobOrd.Id);
                            //  campTsbTrpList.addAll(jobOrd.CSS_CampTsbTrp__r);
                            campTsbTrpList.addAll(langqsol);
                        }
                        // filtering the records based on user language - end  
                        //  }
                        //  }
                    }
                }


                //List to insert new CampTsbTrp records.
                list<CSS_CampTsbTrp__c> campListToInsert = new list<CSS_CampTsbTrp__c>();

                //BEGIN - Process Connected Diagnostic Data for 1st Record only.
                CSS_Job_Order__c oldJob = Trigger.oldMap.get(trigger.new[0].Id);
                if (oldJob.ESN__c != trigger.new[0].ESN__c && trigger.new[0].ESN__c!=null){
                    System.debug('The esn inside update is'+trigger.new[0].ESN__c);
                    if(system.isFuture()==false){
                        if(!Test.isRunningTest()){
                            CSS_QuickServe.getDataPlateDocSave(trigger.new[0].Id,trigger.new[0].ESN__c,trigger.new[0].Make__c,trigger.new[0].Model__c,trigger.new[0].PSN_Not_Available__c);
                            //CSS_QuickServe.getJobOptions(jobIds, false);
                        }
                    }

                    if(campTsbTrpList != null && !campTsbTrpList.isEmpty()){
                        for(CSS_JobEventTemporary__c campTsbTrpRec : campTsbTrpList){
                            // CSS_CampTsbTrp__c campRec = campTsbTrpRec.clone();
                            //  for(integer i=0; i < campTsbTrpList.size(); i++ ){
                            CSS_CampTsbTrp__c campRec = new CSS_CampTsbTrp__c();
                            campRec.Name = campTsbTrpRec.Attribute1__c;
                            campRec.Type__c = campTsbTrpRec.Attribute2__c;
                            campRec.Cu_Language__c = campTsbTrpRec.Attribute3__c;
                            campRec.Doc_Num__c = campTsbTrpRec.Attribute7__c;
                            campRec.Doc_Title__c = campTsbTrpRec.Attribute8__c;
                            campRec.URL__c = campTsbTrpRec.Attribute9__c;
                            campRec.ESN__c = campTsbTrpRec.Key__c;
                            campRec.Job_Order__c = trigger.new[0].Id;
                            campListToInsert.add(campRec);
                            //  }  

                        }
                    }else{
                        // Added language parameter for quickserve integration - start
                        system.debug('Trigger TEST123');
                        CSS_QuickServe.getQsolDocSave(trigger.new[0].Id,trigger.new[0].ESN__c, aLan.CSS_QsolLanguage__c);
                        // Added language parameter for quickserve integration - end

                    }            
                    if(!Test.isRunningTest()){
                        string language = 'en';
                        CSS_receive30DayAlerts.requestAlerts(trigger.new[0].Id,trigger.new[0].ESN__c,trigger.new[0].Name,trigger.new[0].Mileage__c, trigger.new[0].Mileage_measure__c);
                        //User u2 = css_utility.getUserAttributes(userinfo.getUserId()); 
                        //CSS_accountLanguage__c aLangua = css_utility.getLanguage(u2.LanguageLocaleKey);
                        CSS_EDSAuthentication.getESNHistory(trigger.new[0].Id,trigger.new[0].ESN__c,aLan.CSS_EDSLanguage__c);

                        system.debug('Trigger BMS Service Call 11'+trigger.new[0].ESN__c);
                        system.debug('userinfo.getUserId********'+userinfo.getUserId());

                        //if(css_utility.getBMSEnabled(userinfo.getUserId())){
                        //Modified as per story# 76192
                        if(css_utility.getBMSEnabled(trigger.new[0].Creator_Location__c)){
                            system.debug('Trigger BMS Service Call 12'+trigger.new[0].ESN__c);
                            CSS_WS_BMS.callServiceHistoryOutboundService(trigger.new[0].ESN__c,trigger.new[0].Creator_Location__c);
                            system.debug('Trigger BMS Service Call 13'+trigger.new[0].ESN__c);
                        }

                    }
                }            

                //RPV call    
                //System.debug('RPV Trigger Call 1' + oldJob.ESN__c + ' ' + trigger.new[0].ESN__c + ' ' + oldJob.Mileage__c + ' ' + trigger.new[0].Mileage__c + oldJob.Mileage_Measure__c + ' ' + trigger.new[0].Mileage_Measure__c);

                if (trigger.new[0].Mileage__c!=0 || trigger.new[0].ESN__c!=null)
                {
                    if ( (oldJob.ESN__c != trigger.new[0].ESN__c) || (oldJob.Mileage__c !=trigger.new[0].Mileage__c) ){

                        System.debug('RPV Trigger Call 2' + css_utility.getOrgType(userinfo.getUserId()));
                        if(!Test.isRunningTest()){
                            css_rpv.repeatVisit(css_utility.getOrgType(userinfo.getUserId()), trigger.new[0].ESN__c, trigger.new[0].Mileage__c, trigger.new[0].Mileage_Measure__c, trigger.new[0].Equipment_ID__c, trigger.new[0].name, trigger.new[0].DSID__c, trigger.new[0].DSID_Creation_Timestamp__c, trigger.new[0].RPVControlNumber__c, trigger.new[0].Id);
                        }
                    } 
                }

                //insert new CampTsbTrp records.
                if(campListToInsert != null && !campListToInsert.isEmpty()){
                    system.debug('***campListToInsert-->'+campListToInsert);
                    insert campListToInsert;
                }

                CSS_Service_Job_AssignTo_Sharing helper1 = new CSS_Service_Job_AssignTo_Sharing();
                helper1.assignToSharing(trigger.new);

                //Calling the serviceJob trigger helper class to insert a job history record based on the 4cs update (yeti story)
                CSS_ServiceJobTriggerHelper.updateFourCs(trigger.new,trigger.oldMap);
                //Calling the serviceJob trigger helper class to insert a job history record based on the Sub status update 
                CSS_ServiceJobTriggerHelper.updateSubStatus(trigger.new,trigger.oldMap);
                //Calling the serviceJob trigger helper class to insert a job history record based on the Assigne(Gold story-90900)
                CSS_ServiceJobTriggerHelper.insertAssigne(trigger.new,trigger.oldMap);
                //Calling the serviceJob trigger helper class to insert a job history record based on the Location(Doc-76192)
                CSS_ServiceJobTriggerHelper.insertLocation(trigger.new,trigger.oldMap);
            }
            //CSS_ServiceJob After Delete Helper 
            else if(Trigger.isDelete){

            }         
        }
        else{
        }   

        if(Trigger.isUpdate && Trigger.isBefore)
        {
            System.debug('============================before update===================');   
        }
        else if(Trigger.isUpdate && Trigger.isAfter)
        {
            System.debug('============================after update==================='+Trigger.isUpdate); 
        }

        //The below function is to called to give limit related information.    
        CSS_CG_LimitInfo.limitsfunc();
        /*System.debug('====Number of Queries called===='+Limits.getQueries());
System.debug('====Number of Queries thet can be called===='+Limits.getLimitQueries());   

System.debug('====Number of futures called===='+Limits.getFutureCalls()); 
System.debug('====Number of futures which can be called from hereon===='+Limits.getLimitFutureCalls());*/

    }
}