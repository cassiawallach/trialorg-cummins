/************************************************************
Name:  IAM_Contact_Trigger_Helper
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_Contact_Trigger_Helper class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram     04/12/2019        INITIAL DEVELOPMENT 
1.1 -    Chetan Gaikwad            12/04/2020      Made changes for market place deployment
1.2 -    Nishant Verma             12/09/2020      Made Changes for High Radisu Deployment  
1.3 -    Shubhangi Sardar          12/16/2020      Changes for CST User Status Update when Contact change to Inactive from WWIMMS       
1.4 -    Karthik Golakaram         01/25/2021      Changes for marketplace code changes for production fix - INC1022619 
1.5 -    Anupam Adhikari           03/22/2021      changes for global dealer portal 
1.6 -    Pragnya Sheelam           02/08/2022      Changes for Primary/Secondary Contact Validation and Guidanze Automation Ei-148   
1.7 -    Chetan Gaikwad            08/05/2022      CDO Phase2 outbound API calling on Contact update
*****************************************************/
/********************************************************************************
***********************************************************************************/
Public class IAM_Contact_Trigger_Helper{
    
    public static Boolean bIsFirstTime = true;
    
    //Method to invoke beforeInsert.
    Public Static void onBeforeInsertandAfterInsert(List<Contact> triggerNew,Boolean isBefore,Boolean isAfter){
        /* Fixed - D-2870. This method will get contact count for Individual Account and if user try to add more than one Contact then display error. */
        if(isBefore){
        getIndividualContactCount(triggerNew, isBefore);
        }
        //createUserFeature(triggerNew, isAfter);  //Cahnges added by Anupam - 03/22/2021
        if(UserInfo.getProfileId()!=System.Label.IAM_Cummins_web_Profile&&UserInfo.getProfileId()!=System.Label.IAM_Integration_User_Profile_ID){
            Set<String> allRoles=IAM_userAccessCheckToModify.getHQUserRoleIDs();
            if(!IAM_userAccessCheckToModify.contactCheck){
                if(allRoles.contains(UserInfo.getUserRoleId())){  
                    contactAccessValidationForDistributor(triggerNew, isBefore);
                    IAM_userAccessCheckToModify.contactCheck=true;
                }
            }
        } //fix for Defect 3223 this is on insert
        //Generic logic for insert.
        set<id> accntId=new Set<id>();
        set<id> activeConIds = new set<id>();
        List<Contact> activeConInsert=new List<Contact>();
        
        
        for(contact objCon:triggerNew){
            accntId.add(objCon.AccountId);
            System.debug('Printing Contact id in the loop'+objcon.id);
            //Addining Record type -5-22-2020 //since this trigger has to invoke only for IAM specific records 
            if(objCon.Email!=null && objCon.IAM_Contact_Status__c == System.Label.IAM_Status_Active&&objCon.IAM_from_Registration__c==false&&!objCon.IAM_From_API__c&&!objCon.IAM_Legacy_User__c&&(objCon.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()||objCon.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal').getRecordTypeId())){
                activeConIds.add(objCon.id);
                activeConInsert.add(objCon);
            }
            
        }
        System.Debug('Prinitng Active Con Insert'+activeConInsert);
        System.debug('Prinintng active Con IDS'+activeConIDs);
        
        //Code to get executed before insert of the contact 
        if(isBefore){
            //This part is to update the Wrokgroup id from the Account before contact creation 
            System.debug('Printing account values accntId'+accntId);
            Map <id,Account> accntMap=new Map<Id, Account>([select id,Name,Location__c,Type from Account where id=:accntId]);
            List<String> usernameList = new List<String>();
            System.debug('Printing Map values'+accntMap);
            for(Integer i=0; i<triggerNew.size(); i++){
                if(accntMap.ContainsKey(triggerNew[i].AccountId)){
                    triggerNew[i].IAM_Work_Group_ID__c=accntMap.get(triggerNew[i].AccountId).Location__c+System.Label.IAM_WorkGrpAddition_Symbol;
                    //updating PGA level on the contact record on Contact creation.
                    if(accntMap.get(triggerNew[i].AccountId).Type==System.Label.IAM_Account_Type_Distributor||accntMap.get(triggerNew[i].AccountId).Type==System.Label.IAM_Account_Type_DistBranch||accntMap.get(triggerNew[i].AccountId).Type==System.Label.IAM_Account_Type_Factory){
                        triggerNew[i].IAM_Product_Group_Access__c=System.Label.IAM_WrkGrp_Value_PGA01;
                        //Issue#406 - added PGA code for CIHR user
                    }else if(accntMap.get(triggerNew[i].AccountId).Type==System.Label.IAM_Account_Type_Dealer||accntMap.get(triggerNew[i].AccountId).Type==System.Label.IAM_Account_Type_DealerBranch||accntMap.get(triggerNew[i].AccountId).Type==System.Label.IAM_Account_Type_Fleet||accntMap.get(triggerNew[i].AccountId).Type==System.Label.IAM_Account_Type_Vocational||accntMap.get(triggerNew[i].AccountId).Type==System.Label.IAM_Account_Type_National_Account || accntMap.get(triggerNew[i].AccountId).Type==System.Label.IAM_Account_Type_CIHR){
                        triggerNew[i].IAM_Product_Group_Access__c=System.Label.IAM_WrkGrp_Value_PGA02;
                    }else if(accntMap.get(triggerNew[i].AccountId).Type==System.Label.IAM_Account_Type_Individual||accntMap.get(triggerNew[i].AccountId).Type==System.Label.IAM_Account_Type_Business){
                        triggerNew[i].IAM_Product_Group_Access__c=System.LAbel.IAM_WrkGrp_Value_PGA03;
                    }
                }
                /* Fix of D-2813 */
                if(triggerNew[i].IAM_from_Registration__c == true 
                   && String.isNotBlank(triggerNew[i].Username__c)
                   && triggerNew[i].IAM_Contact_Status__c != Label.IAM_Rejected_Label) {
                       usernameList.add(triggerNew[i].Username__c);
                }
               // triggerNew[i].IAM_DN_Value__c = IAM_Utility.getDNValue(triggerNew[i].Username__c,
               // triggerNew[i].IAM_Legacy_User__c, triggerNew[i].IAM_Internal__c);
		  triggerNew[i].IAM_DN_Value__c = IAM_Utility.getDNValue(triggerNew[i].Username__c,triggerNew[i].IAM_Person_Type__c);//added by vineet

            }
            /* Fix of D-2813 - If contact is inserted from registration and same Contact username is available in a system 
* in Rejected status, change the Username on this Rejected Contact to some random value. */
            if(!usernameList.isEmpty()) {
                changeUsernameOfRejectedContact(usernameList);
            }
        }
        
        //if Trigger got invoked because of the isAfter context variable.This logic is manly for the contacts which got created through Swreg API.
        if(isAfter){
            set<id> conIds = new Set<id>();
            List<Contact> objCon = new List<contact>();
            for(Contact con: triggerNew) {
                if(con.IAM_Contact_Status__c == 'Active' && (con.IAM_Contact_source__c == 'SwReg'|| con.IAM_Contact_source__c == 'QSOL')&&!con.IAM_From_API__c&&!con.IAM_Legacy_User__c&&(Con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()||Con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal').getRecordTypeId())) {
                    conIds.add(con.Id);
                }
            }
            system.debug('Prinitng is After active Contact IDs'+conIDs);
            if(!conIds.isEmpty() && conIds.size() >0) {
                objCon = IAM_contactHelperClass.getContactForUser(conIds);
                IAM_CreateUser.CreateUser(objCon); 
            }
            
            
            if(!activeConInsert.isEmpty()&&System.IsBatch() == false && System.isFuture() == false){
                System.debug('before making LDAP UTIL call activeConInsert.... '+ activeConInsert);
                IAM_LDAP_Util.invokeapexcallout(activeConInsert,'Insert');
                //this method bypass Acitve button on contact in business admin portal
                System.debug('before calling IAM_contactHelperClass .... '+ activeConIds);
                List<Contact> lstActiveCont = IAM_contactHelperClass.getContactForUser(activeConIds);
                System.debug('before calling updateContact_User .... '+ lstActiveCont);
                if(!Test.isRunningTest()){
                    IAM_contactHelperClass.updateContact_User(lstActiveCont);
                }
            }
        }         
    }   
    
    
    //Method to invoke onBefore Update from Trigger.
    Public Static void onAfterUpdate(List<Contact> triggerNew,List<Contact> triggerOld,Map<id,Contact> triggerNewMap,Map<id,Contact> triggerOldMap){
        if(!TriggerOldMap.isEmpty()){
            if(!System.isFuture()&&!System.isBatch()){
                IAM_AWSCognito_CallService.callService(triggerNew, triggerNewMap, triggerOldMap);
            }
            //CDO Outbound call
			set<id> setCDOConIds = new set<id>();
            set<id> setCDOConProIds = new set<id>();
            //CDO Outbound call
            set<id> setConIds = new set<id>();
            set<id> setUsrCont = new set<id>();
            set<id> setReclaimConID= new Set<id>();
            Set<id> updateConIds=new Set<id>();
            Set<id> CSTUpdate= new Set<id>();//set to store CSt ids.
            Set<id> accountChangedConIds=new Set<id>();//set to store ConIds.
            List<Contact> UpdateCon = new List<Contact>();
            List<Contact> setUsrCont_reclaim = new List<Contact>();
            List<Contact> createUserUpdate = new List<Contact>();
            Boolean isReclaim=false;//Depending upon this field we are using some logic in user update class.
            map<id,String> oldWWIDS=new map<id,String>();//
            map<id,String> oldUsername=new map<id,String>();
            map<id,String> newUsername= new map<id,String>();
            //GLobal Dealer Poratl changes - @Anupam
            List<Contact> UpdateConUserFeat = new List<Contact>();
            
            list <processInstanceStep> stepRejectsRecords = [SELECT ProcessInstance.TargetObject.Name, ActorId, Comments, Id, 
                                                             ProcessInstanceId, ProcessInstance.TargetObjectId,StepStatus FROM ProcessInstanceStep 
                                                             WHERE StepStatus =: System.Label.IAM_Rejected_Label AND ProcessInstance.TargetObjectId in: triggerNewMap.keyset()];
            
            for(contact con : triggerNew){  
                setConIds.add(con.id);
                if(triggerOldMap.containsKey(con.id)){
                //below conditino will take care of the Contacts who gets created on insertion.On update I think this will not be a criteria
                //Just for safe side 
                //CDO Outbound call
                if(triggerOldMap.get(con.id).Email != con.Email || triggerOldMap.get(con.id).Language_Preferences__c != con.Language_Preferences__c){
                    setCDOConIds.add(con.id);
                }
                //CDO Outbound call
                if(con.Email!=null&&con.Username__c!=null 
                   &&(con.IAM_Contact_Status__c=='Active'||con.IAM_Contact_Status__c=='Inactive' ||con.IAM_Contact_Status__c=='Reclaim')
                   &&triggerOldMap.get(con.id).IAM_Contact_Status__c!=null&&!Con.IAM_From_API__c&&(Con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()||Con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal').getRecordTypeId())){
                       UpdateCon.add(con);
                       updateConIds.add(con.id);
                       //Since we are comparing the value for null check directly adding the user id without making null check
                       if(triggerOldMap.get(con.id).Username__c!=null&&triggerOldMap.get(con.id).Username__c!=''){
                           oldUsername.put(con.id,triggerOldMap.get(con.id).Username__c);
                       }
                       
                       if(triggerNewMap.get(con.id).Username__c!=null&&triggerNewMap.get(con.id).Username__c!=''){
                           newUsername.put(con.id,triggerNewMap.get(con.id).Username__c);
                       }
                       
                       
                       
                   }
                
                //Condition for CSt status change only 
                if(con.Email!=null&&con.Username__c!=null 
                   &&(con.IAM_Contact_Status__c=='Active'||con.IAM_Contact_Status__c=='Inactive' ||con.IAM_Contact_Status__c=='Reclaim')
                   &&triggerOldMap.get(con.id).IAM_Contact_Status__c!=null&&!Con.IAM_From_API__c&&triggerOldMap.get(con.id).IAM_Contact_Status__c!=triggerNewMap.get(con.id).IAM_Contact_Status__c&&(Con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()||Con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal').getRecordTypeId())){
                       CSTupdate.add(con.id);
                   }
                
                //user creation logic for contact become active.     
                
                //Below condition is to make sure we capture all the contacts except those whose old status is Reclaim.because we have a seperate condition ofr that again.
                //Below contacts if they have users their users records need to be updated
                //This condition will not look for newly created contacts.
                system.debug('######'+con);
                if(con.Email!=null&&triggerNewMap.get(con.id).IAM_from_Registration__c==false&&con.IAM_Contact_Status__c == 'Active' && triggerOldMap.get(con.id).IAM_Contact_Status__c != 'Active'&&triggerOldMap.get(con.id).IAM_Contact_Status__c != 'Reclaim'&&triggerOldMap.get(con.id).IAM_Contact_Status__c !=null&&con.Username__c!=null&&!Con.IAM_From_API__c&&!Con.IAM_Legacy_User__c&&(Con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()||Con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal').getRecordTypeId())){
                    setUsrCont.add(con.id);
                    createUserUpdate.add(con);
                }
                
                //ldap for reclaim.This condition Should satisfy for both user creation and Guidan LDAP call issues.
                //Below condition  will capture records whose old status is reclaim and new status is Active.
                if(con.IAM_Contact_Status__c == 'Active' && triggerOldMap.get(con.id).IAM_Contact_Status__c =='Reclaim'&&(Con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()||Con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal').getRecordTypeId())){
                    setReclaimConID.add(con.id);
                    setUsrCont_reclaim.add(con);
                    oldWWIDS.put(con.id,triggerOldMap.get(con.id).Username__c);
                }

                //Global Dealer Portal changes to handle user feature create on after update - @Anupam
                if(con.IAM_Contact_Status__c == 'Active' && (triggerOldMap.get(con.id).IAM_Contact_Status__c =='Pending' || triggerOldMap.get(con.id).IAM_Contact_Status__c =='Reclaim') && Con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()){
                    UpdateConUserFeat.add(con);
                }
                
                //Amarnath Mishra added for the reject comment.
                if(stepRejectsRecords.size()>0){
                    if(con.id == stepRejectsRecords[0].ProcessInstance.TargetObjectId && String.isNotBlank(stepRejectsRecords[0].Comments) && IAM_contactHelperClass.isRejectcommentFirstTime == true){
                        IAM_contactHelperClass.isRejectcommentFirstTime = false;
                        IAM_contactHelperClass.updateRejectReason(con.id,con.IAM_Reject_Reason__c,stepRejectsRecords[0].Comments);
                    }
                } else if(con.Email != null && con.Username__c != null && con.IAM_Contact_Status__c == 'Inactive'
                    && IAM_contactHelperClass.isRejectcommentFirstTime == true
                    && UserInfo.getUiThemeDisplayed() != 'Theme4d'
                    && (con.Recordtypeid == Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()
                    || con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal').getRecordTypeId())) {
                    /* This else if condition is added to update reject reason for contact provisioning if
                    Contact is inactivated through WWIMS API*/
                    System.debug('#### in ELSE IF');
                    IAM_contactHelperClass.isRejectcommentFirstTime = false;
                    IAM_contactHelperClass.updateRejectReason(con.id,Label.IAM_RejectReason,Label.IAM_RejectComments);
                }
                
                //Amarnath Mishra added for the rejection reason IAM_Reject_Reason__c
                system.debug('=====UserInfo.UITheme() =========='+UserInfo.getUiTheme());
                system.debug('=====UserInfo.UIThemeDisplayed()===='+UserInfo.getUiThemeDisplayed());
                system.debug('=====con.IAM_Contact_Status__c==contact=='+con.IAM_Contact_Status__c);
                system.debug('=====con.IAM_Reject_Reason__c====contact===='+con.IAM_Reject_Reason__c);
                system.debug('=====triggerOldMap.get(con.id).IAM_Reject_Reason__c='+triggerOldMap.get(con.id).IAM_Reject_Reason__c);
                if(UserInfo.getUiThemeDisplayed() == 'Theme4d' && IAM_contactHelperClass.isRejectReasonFirstTime  == true && con.IAM_Contact_Status__c == System.Label.IAM_Inactive_Label ){
                    system.debug('======Inside if rejection==contact==');
                    IAM_contactHelperClass.isRejectReasonFirstTime = false;
                    IAM_contactHelperClass.updateRejectReason(con.id,con.IAM_Reject_Reason__c,con.IAM_Reason__c);
                }
                
                //Checking for Contact name change and if there are any guidanz applications making future call out.
                if(triggerNewMap.get(con.id).Accountid!= triggerOldMap.get(con.id).Accountid&&(Con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()||Con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal').getRecordTypeId())){
                    //if there is an account change the capture all contact ids and then call guidanz profile change class.
                    //con.CMI_Contact_Type__c='Secondary';
                    accountChangedConIds.add(con.id);
                }
            }  
            } 
            System.debug('setUsrCont.... '+ setUsrCont);// These are the contacts that got created . why should we update them again?               
            System.debug('createUserUpdate.... '+ createUserUpdate);//These are the contacts that are getting user
            System.debug('setUsrCont_reclaim.... '+ setUsrCont_reclaim);
            System.debug('Printing all old WWIDS'+oldWWIDS);
            System.debug('before making updateUserdetails.. IAM_contactHelperClass.isFirstTime .... '+ IAM_contactHelperClass.isFirstTime);
            //CDO Outbound call
            if(setCDOConIds.size() > 0){
                setCDOConProIds = IAM_CDO_OutboundHelper.getConnectedSoltuionProvisionings(setCDOConIds);
            }
            if(setCDOConProIds.size() > 0){
                for(ID cp:setCDOConProIds){
                    IAM_CDO_OutboundHelper.CDOOutboundCall(cp, 'Update');
                } 
            }
            //CDO Outbound call
            //Global Dealer Portal changes - @Anupam
            if(UpdateConUserFeat.size() > 0){
                Boolean bIsTrue = true;
                createUserFeature(UpdateConUserFeat, bIsTrue);
            }
            
            if(setConIds != NULL && !setConIds.isEmpty() && System.IsBatch() == false && System.isFuture() == false && IAM_contactHelperClass.isFirstTime){
                System.debug('Entered useer update condition');
                IAM_contactHelperClass.isFirstTime = false;
                IAM_contactHelperClass.updateUserdetails(setConIds,isReclaim,oldWWIDS);//class is called to Update the user record values on Contact update
            }
            //when reclaim contacts become active invoke LDAP insert API
            if(!setUsrCont_reclaim.isEmpty()&&System.IsBatch() == false && System.isFuture() == false){
                System.debug('before making LDAP UTIL call setUsrCont_reclaim.... '+ setUsrCont_reclaim);
                isReclaim=True;
                IAM_LDAP_Util.invokeapexcallout(setUsrCont_reclaim,'Insert');
                IAM_contactHelperClass.updateUserdetails(setReclaimConID,isReclaim,oldWWIDS);
            }
            
            System.debug('before making LDAP UTIL call IAM_LDAP_Util.isIAMLDAPUtil_Processed.... '+ IAM_LDAP_Util.isIAMLDAPUtil_Processed);
            //Below function will call the LDAP class to send out call out when user is directly created from UI screens or from front end registration where Contact status is made
            //Directly active on creation.
            if(!createUserUpdate.isEmpty()&&System.IsBatch() == false && System.isFuture() == false && !IAM_LDAP_Util.isIAMLDAPUtil_Processed){
                System.debug('before making LDAP UTIL call createUserUpdate.... '+ createUserUpdate);
                IAM_LDAP_Util.invokeapexcallout(createUserUpdate,'Insert');
                IAM_contactHelperClass.updateUserdetails(setUsrCont,isReclaim,oldWWIDS);
            }
            
            System.debug('before making LDAP UTIL call IAM_LDAP_Util.isIAMLDAPUtil_Processed.... '+ IAM_LDAP_Util.isIAMLDAPUtil_Processed);
            System.debug('Printing update function'+updateConIds);
            //Below function will call the LDAP class to send out call out.
            if(!UpdateCon.isEmpty()&&System.IsBatch() == false && System.isFuture() == false && !IAM_LDAP_Util.isIAMLDAPUtil_Processed){
                System.debug('before making LDAP UTIL call UpdateCon.... '+ UpdateCon);
                IAM_LDAP_Util.isIAMLDAPUtil_Processed = true;
                IAM_LDAP_Util.invokeapexcallout(UpdateCon,'Update');
                IAM_contactHelperClass.updateUserdetails(updateConIds,isReclaim,oldWWIDS);
            }
            
            if(!CSTUpdate.isEmpty()&&System.IsBatch() == false && System.isFuture() == false && !IAM_LDAP_Util.isIAMLDAPUtil_Processed){
                System.debug('CST call on status change of contact');
                IAM_CST_Contact_Updates.CheckUserStatus(CSTUpdate,oldUsername,newUsername);
            }
            // user creation logic if contact become active 
            List<id> lstUsrCont = new List<id>();
            lstUsrCont.addAll(setUsrCont);
            List<Contact> lstCont = [select id,firstname,IAM_Internal__c,lastname,email,phone, Account.CMI_Account_Num__c, Accountid,Account.Name,CMI_Contact_Type__c,Account.Type,
                                     Username__c,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Applications__c,Account.IAM_Service_Provider_Code__c,
                                     Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,IAM_is_Member_of__c,IAM_Work_Group_Id__c,IAM_Qsolexpiration__c,
                                     IAM_Qsolview__c,IAM_Product_Group_Access__c,Account.Location__c,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,
                                     Account.BillingPostalCode,Account.CSS_Locale__c,Account.CSS_Language__c,Account.Ownerid,Account.CSS_Timezone__c,Account.IAM_Movex_Customer_Code__c,
                                     Account.IAM_WWSPS_Regions__c,IAM_Contact_Status__c,IAM_swregexpire__c,IAM_Site_Admin_Role__c,IAM_Site_Admin__c,IAM_Legacy_User__c from Contact where id in: lstUsrCont];   
            
            if(null != lstCont && lstCont.size() > 0 ){
                IAM_contactHelperClass.updateAppContactProStatus(lstCont);        
                // IAM_CreateUser.CreateUser(lstCont); 
                IAM_Contact_Prov_Helper.CreationOfUser(lstCont);
            }  
            
            //check if accountChangedConIds is not empty and make call to below class.
            
            if(!accountChangedConIds.isEmpty()&&!System.isFuture() && System.IsBatch() == false){    
                //calling a future method to update user record if there is a guidanz Profile.
                IAM_contactHelperClass.ChangeUserProfile(AccountChangedConIds); 
            } 
        }
        //Added Changes for Primary/Secondary Contact Validation and Guidanz Automation
        Set<Id> oldAccIds = new Set<Id>();
        for(Integer i=0; i<triggerNew.size(); i++){
            if(i<TriggerOld.size()){
                if(TriggerOldMap.containsKey(triggerNew[i].Id)){
                    if(TriggerOldMap.get(triggerNew[i].Id).CMI_Contact_Type__c=='Primary'){
                        if(TriggerOldMap.get(triggerNew[i].Id).IAM_Contact_Status__c=='Active' && triggerNew[i].IAM_Contact_Status__c =='Inactive'){
                            system.debug('Inside primary Contact Inactive'+triggerOldMap.get(triggerNew[i].id).Accountid);
                           // triggerNew[i].CMI_Contact_Type__c='Secondary';
                            oldAccIds.add(triggerOldMap.get(triggerNew[i].id).Accountid);
                        }
                        //Added for Primary Contact Validation
                        if(TriggerOldMap.get(triggerNew[i].Id).CMI_Contact_Type__c=='Primary' && triggerNew[i].CMI_Contact_Type__c =='Secondary'){
                            oldAccIds.add(triggerOldMap.get(triggerNew[i].id).Accountid);
                            
                        }    
                        
                        
                    }
                } 
            }
        }
         if(!oldAccIds.isEmpty()){
      updateoldAccount(oldAccIds);   
      }
    } 
    
    public static boolean isAccountChanged = false;
    
    //Method to invoke after Update from Trigger.
    Public Static void onBeforeUpdate(List<Contact> triggerNew,List<Contact> triggerOld,Map<id,Contact> TriggerNewMap,Map<id,Contact> TriggerOldMap){
        if(!TriggerOldMap.isEmpty()&&!triggerOld.isEmpty()&&!triggerNew.isEmpty()){// Karthik Made Cahnges 01-21-2021
            set<id> accId=new Set<id>();
        
            set<id> setConIds2 = new set<id>();
            set<id> AccountChangeId= new set<id>();
            List<Contact> UpdateWrkGrp= new List<Contact>();
            
            if(UserInfo.getProfileId()!=System.Label.IAM_Cummins_web_Profile&&UserInfo.getProfileId()!=System.Label.IAM_Integration_User_Profile_ID){
                Set<String> allRoles=IAM_userAccessCheckToModify.getHQUserRoleIDs();
                if(!IAM_userAccessCheckToModify.contactCheck){
                    if(allRoles.Contains(UserInfo.getUserRoleId())){
                        contactAccessValidationForDistributor(triggerNew, Trigger.isBefore);
                        IAM_userAccessCheckToModify.contactCheck=True;
                    }
                }
            }//fix for Defect 3223 this is on Update
            for(Contact c: triggerNew){
                accId.add(c.AccountId);
                //fix of defect D-2810 - store old email on contact custom field if email got changed.
                if(triggerOldMap.ContainsKey(c.id)&&triggerOldMap.get(c.id).email!=null){
                    if(c.Email != triggerOldMap.get(c.id).Email){
                        c.IAM_Previous_User_Email__c = triggerOldMap.get(c.id).Email;
                    }   
                }
                if(c.IAM_Person_Type__c != triggerOldMap.get(c.Id).IAM_Person_Type__c){
                    c.IAM_DN_Value__c = IAM_Utility.getDNValue(c.Username__c, c.IAM_Person_Type__c);
                }
            }
            System.debug('Printing all account ids accId'+ accId);
            Map <id,Account> accMap=new Map<Id, Account>([select id,Name,Location__c,Type from Account where id=:accId]);  //D-3224 added Type in query
            System.debug('Printing Map values'+accMap);
            for(Integer i=0; i<triggerNew.size(); i++){
                if(i<TriggerOld.size()){//KArthik Added this line 01-21-2021
                System.debug('Printing account Name for trigger'+triggerNew[i].Accountid+'  '+triggerOld[i].Accountid);
                System.debug('Printing account Name for trigger'+triggerNew[i].Account.Name+'  '+triggerOld[i].Account.Name);
    
                if(TriggerOldMap.containsKey(triggerNew[i].Id)){
                //Amarnath Mishra added for the issue fix D-2815
                if(triggerNew[i].Accountid != triggerOldMap.get(triggerNew[i].id).Accountid){
                    system.debug('====Inside account change ======');
                
                    setConIds2.add(triggerNew[i].id);
                    triggerNew[i].IAM_Work_Group_ID__c=accMap.get(triggerNew[i].AccountId).Location__c+'-P';
                    if(accMap.get(triggerNew[i].AccountId).Type=='Internal') // Added this If for D-3224
                    {triggerNew[i].IAM_Work_Group_ID__c='';}
                    UpdateWrkGrp.add(triggerNew[i]);
                    AccountChangeId.add(triggerNew[i].id);
                    triggerNew[i].IAM_Applications__c = '';
                    triggerNew[i].Location_Change__c = true;
                    triggerNew[i].IAM_Application_Roles__c = '';
                    triggerNew[i].IAM_swregexpire__c = '';
                    triggerNew[i].IAM_Qsolexpiration__c = '';
                    triggerNew[i].IAM_is_Member_of__c= '';
                    triggerNew[i].IAM_Qsolview__c = '';
                    triggerNew[i].CMI_Contact_Type__c='Secondary';
                    triggerNew[i].OwnerId=UserInfo.getUserId();//Karthik Golakaram 2-22-2020 : Made changes to move a contact across different distributor locations.     
                } 
            }
            }   
            }
          
    
            System.debug('Printing all the contact'+UpdateWrkGrp);
            //Code to make api call for user group deletion when location is changed D-2982
            Set<id> ContDel=new Set<id>();// ids to store the old map record ids to RC delete.
            Map<id,String> contMapDel=new Map<id,String>();
            if(!AccountChangeId.isEmpty()){
                List<IAM_Contact_Provisioning__c> conProv=[select id,IAM_Status__c,IAM_Role__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:AccountChangeId AND IAM_Status__c ='Active'];
                for(IAM_Contact_Provisioning__c cc: conProv){
                    contMapDel.put(cc.id,cc.IAM_Role__c);
                    ContDel.add(cc.id);
                }
                system.debug('List going to update'+ContDel);
                IAM_RC_DeleteUserFromGroup.basicAuthCallout(ContDel,contMapDel,true);
            }
            if(!AccountChangeId.isEmpty() && isAccountChanged ==false){
                
                IAM_contactHelperClass.Accountchange(AccountChangeId);
                
                isAccountChanged =true;
            }
            if(setConIds2.size()>0 || !setConIds2.isEmpty()){
                if(!System.isFuture() && !System.isBatch()){
                    IAM_CSTUserLocationOutboundHelper.CstUserLocationUpdate(setConIds2);
                }
            }
        }
    }
    
    /* Fixed - D-2870. This method will get contact count for Individual Account and if user try to add more than one Contact then display error. */
    private static void getIndividualContactCount(List<Contact> triggerNew, Boolean isBefore){
        Set<id> accId = new Set<id>();
        if(isBefore){
            for(contact cont : triggerNew){
                if(cont.AccountId != null)
                    accId.add(cont.AccountId);    
            }
            List<contact> ccList = new List<contact> ();
   List<Account> accLst = [select id,Type,(select id from contacts limit 2) from account where id IN : accId];
            for(account accObj : accLst){
                //SonarQube fix
                if('Individual'.equals(accObj.Type)){
                    for(contact conObj : accObj.contacts)     
                        ccList.add(conObj);
                }
            }
            
            for(contact oCon : triggerNew){  
                if(ccList.size() > 0 )
                    oCon.addError(System.Label.IAM_more_than_one_contact_error); 
            }
        }
    }
    
    /* Change username of rejected Contact - Fix of D-2813*/
    public static void changeUsernameOfRejectedContact(List<String> usernameList) {       
        List<contact> rejectedContactslist = [
            SELECT Id
            , Username__c
            , IAM_Contact_Status__c
            FROM Contact
            WHERE Username__c IN :usernameList
            AND IAM_Contact_Status__c = :Label.IAM_Rejected_Label
        ];
        if(!rejectedContactslist.isEmpty()) {
            List<Contact> changedUsernameList = new List<Contact>();
            for(Contact c : rejectedContactslist) {
                String updatedUsername = String.valueOfGmt(System.now()).replaceAll('[-:\\s+]', '')
                    + '.' + c.Username__c ;
                System.debug('#### Now updatedUsername '+ updatedUsername);
                c.Username__c = updatedUsername;
                changedUsernameList.add(c);
            }
            update changedUsernameList;
        }
    }
    
    Public Static void contactAccessValidationForDistributor(List<Contact> cons,Boolean isBefore){
        
        
        
        for(Contact ObjCon:cons){
            
            
            String accessLevel=IAM_userAccessCheckToModify.userAccessCheck(objCon.Accountid,'Contact'); 
            if(accessLevel=='Insufficient access'){
                //adding error here.
                objCon.adderror('Insufficient Privileges');
            }
            //end of that validation to check Modify access.
            
        }
    }
    
    // Account Change Issue:- Nishant  
    public static Map<Id,Boolean> checkAccChangeFlag(Set<Id> accountIds){  
        Map<Id,Boolean> Returnmap = new Map<Id,Boolean>();
        for(Account accountObj :[Select Id,IAM_Account_Change__c from account where id =:accountIds]){
            if(accountObj.IAM_Account_Change__c){
                system.debug('accountObj.IAM_Account_Change__c@@@'+accountObj.IAM_Account_Change__c);
                //boolean flag = (accountObj.IAM_Account_Change__c== null ? false :accountObj.IAM_Account_Change__c);
                Returnmap.put(accountObj.Id,accountObj.IAM_Account_Change__c);
            }
            else{
                Returnmap.put(accountObj.Id,accountObj.IAM_Account_Change__c);
            }
        }
        System.debug('Returnmap@@@@'+Returnmap);
        return Returnmap;
    }
    // Account Change Issue:- Nishant  
    public static void unCheckAccChangeFlag(Set<Id> accountIds){  
        Map<Id,Boolean> Returnmap = new Map<Id,Boolean>();
        List<Account> UpdateAccChangeFlag = new List<Account>();
        
        for(Account accountObj :[Select Id,IAM_Account_Change__c from account where id =:accountIds]){
            if(accountObj.IAM_Account_Change__c){
                accountObj.IAM_Account_Change__c = false;
                UpdateAccChangeFlag.add(accountObj);
            }
        }
        Update UpdateAccChangeFlag;
        System.debug('UpdateAccChangeFlag@@@@'+UpdateAccChangeFlag);
    }
    
    //Code start - update old account for Primary contact locaion change or inactivation - Chetan G 04/12/20
    @future
    public static void updateoldAccount(Set<Id> oldAccIds){
        system.debug('@Ids of Account to be updated:'+oldAccIds);
        List<Account> acclist = [Select id, CMI_Primary_Contact__c from Account where id=:oldAccIds];
        system.debug('@List of Account to be updated:'+acclist);
        List<Account> updateAccList = new List<Account>();
        for(Account acc:acclist){
            system.debug('Inside account update');
            acc.CMI_Primary_Contact__c = null;
            updateAccList.add(acc);
        }
        update updateAccList;
    }
    //Code End - update old account for Primary contact locaion change or inactivation - Chetan G 04/12/20

      //After Insert Method- Create User Feature and Access Record with Ststus as Active for Dealer User - @Anupam
      Public Static void createUserFeature(List<Contact> triggerNewInsert, Boolean isAfter){
        system.debug('Inside create user feature method--->');
        system.debug('triggerNewInsert---->'+triggerNewInsert);
        set<id> contactIds = new Set<id>();
        set<id> accountIds = new Set<id>();
        List<Contact> objContactRec = new List<contact>();
        List<IAM_Application__c> objAcctFeatureList = new List<IAM_Application__c>();
        List<IAM_Application__c> acctFeatInsertList = new List<IAM_Application__c>();
        Map<String, Contact> mapContactRecords = new Map<String, Contact>();
        Map<String, IAM_Application__c> mapAppFeatureRecords = new Map<String, IAM_Application__c>();
        //if(isAfter){
        //if(triggerNewInsert.size() > 0){
        for(Contact con: triggerNewInsert) {
            if(con.IAM_Contact_Status__c == 'Active' && (Con.Recordtypeid== Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId())){
                //&& con.AccountId != null && (con.Account.Type == 'Dealer Account' || con.Account.Type == 'Dealer Branch Account')) {
                contactIds.add(con.Id);
                //accountIds.add(con.AccountId);
            }
        }
        system.debug('Prinitng is After active account IDs'+contactIds);
        if(contactIds.size() >0) {
            //objContactRec = IAM_contactHelperClass.getContactForUser(contactIds);
            //IAM_CreateUser.CreateUser(objCon);
            objContactRec = [select Id,AccountId,Account.Name,CMI_Contact_Type__c,
                             Account.Type, IAM_Contact_Owner__c from Contact where id in :contactIds];
            
            for(Contact cRec : objContactRec){
                if(cRec.AccountId != null && (cRec.Account.Type == 'Dealer Account' || cRec.Account.Type == 'Dealer Branch Account')){
                    accountIds.add(cRec.AccountId);
                }
            } 
            
            if(accountIds.size() > 0){
                objAcctFeatureList = [Select Id, OwnerId, IAM_Account_Name__r.Id,
                                      IAM_Cumpas_Modularity__c, IAM_Subscription_End_Date__c,
                                      IAM_Application_Name__c, IAM_Role__c
                                      from IAM_Application__c 
                                      WHERE IAM_Account_Name__r.Id IN : accountIds AND IAM_Application_Name__c = 'Global Dealer Portal' AND IAM_Status__c = 'Active']; 
                //}
                system.debug('objAcctFeatureList--->'+objAcctFeatureList);
                system.debug('objContactRec--->'+objContactRec);
                if(objAcctFeatureList.isEmpty()){
                    system.debug('inside if--->');
                    Id RecIdpro1 = [Select Id, Name, sobjecttype from RecordType where name = 'Global Dealer Portal' and sobjecttype = 'IAM_Application__c'].Id;
                    for(Id idAcct : accountIds){
                        IAM_Application__c  createAppRec = new IAM_Application__c();
                        createAppRec.IAM_Account_Name__c = idAcct;
                        createAppRec.IAM_Application_Name__c = 'Global Dealer Portal';
                        createAppRec.IAM_Role__c = 'Dealer User';
                        createAppRec.IAM_Status__c = 'Active';
                        createAppRec.IAM_Subscription_Start_Date__c = system.today();
                        createAppRec.IAM_Subscription_End_Date__c = system.today() + 36500;
                        createAppRec.recordtypeid = RecIdpro1;
                        acctFeatInsertList.add(createAppRec);
                    }               
                    if(acctFeatInsertList.size() > 0){
                        insert acctFeatInsertList;
                    }
                }
                system.debug('acctFeatInsertList--->'+acctFeatInsertList);
                if(objAcctFeatureList.size() > 0 && objContactRec.size() > 0){
                    system.debug('inside if block objAcctFeatureList not empty');
                    for(Contact conRec : objContactRec){
                        for(IAM_Application__c acctFeatureRec : objAcctFeatureList){
                            if(conRec.AccountId == acctFeatureRec.IAM_Account_Name__r.Id){
                                if(!mapAppFeatureRecords.containsKey(conRec.Id)){
                                    mapAppFeatureRecords.put(conRec.Id, acctFeatureRec);
                                    mapContactRecords.put(conRec.Id, conRec);
                                } 
                            }
                        }                        
                    }
                }else{
                    system.debug('inside else block acctFeatInsertList not empty');
                    for(Contact conRec : objContactRec){
                        for(IAM_Application__c acctFeatureRec : acctFeatInsertList){
                            system.debug('acctFeatureRec.IAM_Account_Name__r.Id--->'+acctFeatureRec.IAM_Account_Name__r.Id);
                            if(conRec.AccountId == acctFeatureRec.IAM_Account_Name__c){
                                if(!mapAppFeatureRecords.containsKey(conRec.Id)){
                                    mapAppFeatureRecords.put(conRec.Id, acctFeatureRec);
                                    mapContactRecords.put(conRec.Id, conRec);
                                } 
                            }
                        }                        
                    }
                }
                if(mapAppFeatureRecords.size() > 0){
                    createUserFeatureAccessRecord(mapAppFeatureRecords, mapContactRecords); 
                }
            }
        }
        //}
    }
    
     //Create User Feature and Access Record with Status as Active for Dealer User - @Anupam
     Public Static void createUserFeatureAccessRecord(Map<String, IAM_Application__c> mapAppFeatureRecords, Map<String, Contact> mapContactRecords){
        system.debug('Inside createUserFeatureAccessRecord method--->');
        List<IAM_Contact_Provisioning__c> UserFeatureAccessList = new List<IAM_Contact_Provisioning__c>();
        //User currentLoginUser = [Select Id,Name,Contactid,username from user where id=:userinfo.getuserid()];
        Id RecIdpro = [Select Id, Name, sobjecttype from RecordType where name = 'Global Dealer Portal' and sobjecttype = 'IAM_Contact_Provisioning__c'].Id;
        //List<IAM_Contact_Provisioning__c> UserFeatExitList = [Select Id from IAM_Contact_Provisioning__c where IAM_Contact__c IN: mapContactRecords.keyset()
                                                             //AND IAM_Application_Name__c = 'Global Dealer Portal' AND IAM_Status__c = 'Active'];
         //system.debug('UserFeatExitList--->'+UserFeatExitList);
        //string sRecordtypeid = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Global Dealer Portal').getRecordTypeId();
        if(mapAppFeatureRecords.size() > 0){
            for(String AccFeatureKey : mapAppFeatureRecords.keyset()){
                //if(conRec.Account.Type == 'Dealer Account' || conRec.Account.Type == 'Dealer Branch Account'){
                  IAM_Contact_Provisioning__c userFeatureAccess = new IAM_Contact_Provisioning__c(); 
                    userFeatureAccess.RecordTypeId = RecIdpro;
                    userFeatureAccess.IAM_Application_Name__c = mapAppFeatureRecords.get(AccFeatureKey).IAM_Application_Name__c;
                    userFeatureAccess.IAM_Role__c = mapAppFeatureRecords.get(AccFeatureKey).IAM_Role__c;
                    //userFeatureAccess.IAM_Cumpas_Modularity__c = mapAppFeatureRecords.get(AccFeatureKey).IAM_Cumpas_Modularity__c;
                    userFeatureAccess.IAM_Contact__c = AccFeatureKey;//conRec.Id;
                    userFeatureAccess.IAM_Status__c = 'Active';
                    userFeatureAccess.IAM_Account_Application__c = mapAppFeatureRecords.get(AccFeatureKey).Id;
                  //userFeatureAccess.IAM_User__c = mapAppFeatureRecords.get(AccFeatureKey).OwnerId;
                    //userFeatureAccess.IAM_User__c = currentLoginUser.Id;
                    userFeatureAccess.IAM_User__c = mapContactRecords.get(AccFeatureKey).IAM_Contact_Owner__c;
                	userFeatureAccess.IAM_Start_Date__c = system.today();
                    userFeatureAccess.IAM_End_Date__c = mapAppFeatureRecords.get(AccFeatureKey).IAM_Subscription_End_Date__c;
                    UserFeatureAccessList.add(userFeatureAccess);
                //}
            }
        }
        system.debug('UserFeatureAccessList--->'+UserFeatureAccessList);
        if(UserFeatureAccessList.size() > 0){
            if(bIsFirstTime == true){
            insert UserFeatureAccessList;
            }
            bIsFirstTime = false;
        }
    }
}