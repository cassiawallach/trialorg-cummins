/************************************************************
Name:  IAM_WWSPS_Utility
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Utility Class for WWSPS API                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -     Shubhnagi Sardar              12/16/2020        INITIAL DEVELOPMENT 
1.1 -     Brant Logan                   2/3/2021       Made changes for capturing extra attributes.Changes
*****************************************************/
/********************************************************************************
***********************************************************************************/
public class IAM_WWSPS_Utility {
    
    public static List<Account> getWWSPSLocationAccountDetails(String spCode) {    
        return [ 
            SELECT Id
                 , IAM_Service_Provider_Code__c
                 , Name
                 , Type
                 , ShippingStreet
                 , ShippingCity
                 , ShippingState
                 , ShippingCountry
                 , ShippingPostalCode
                 , OwnerId
                 , RecordTypeId
                 , Ownership
                 , IAM_WWSPS_Regions__c
                 , Turbo_Channel_Of_Distribution__c
                 , IAM_Filtration_Channel_Of_Distribution__c
                 , EBU_Channel_of_Distribution__c
                 , PSBU_Channel_of_Distribution__c
                 , CMI_Account_Status__c
                 , CSS_DistributorCode__c
                 //Code changes: Logan Brandt 2/3/2021
            	 , DTNA__c
            	 , ServiceLevel__c
            	 , engineRangeDesc__c
            //End of Code Changes 2/12/2021
              FROM Account
             WHERE IAM_Service_Provider_code__c = :spCode
             LIMIT 1
        ];
    }
    
    Public Static List<IAM_Application__c> getAccountFeatureAndAccess(String accId,String subscriptionType){
    
        List<IAM_Application__c> appsToReturn= new List<IAM_Application__c>();
        
        System.debug('Printing Account Id is '+ accId+' Subcription Name is '+subscriptionType);
        //Condition for getting Specific Subscriptions.for PGBU we need just PGBU.
        if(subscriptionType.equalsIgnoreCase('QuickServe Online CPG')){
            appsToReturn=[SELECT id,IAM_Application_Name__c,IAM_Role__c,IAM_Status__c,IAM_Subscription_Name__c 
                          FROM IAM_Application__c 
                          WHERE IAM_Account_Name__c=:accId
                          AND IAM_Subscription_Name__c=:subscriptionType
                          AND IAM_Status__c=:System.Label.IAM_Status_Active];
        }else if(subscriptionType.equalsIgnoreCase('QuickServe Online EBU')){
           //We need to return subscriptions with name QuickServe Online EBU and Guidanz application Subscription.
            appsToReturn=[SELECT id,IAM_Application_Name__c,IAM_Role__c,IAM_Status__c,IAM_Subscription_Name__c 
                          FROM IAM_Application__c 
                          WHERE IAM_Account_Name__c=:accId
                          AND (IAM_Subscription_Name__c=:subscriptionType OR IAM_Application_Name__c='Guidanz')
                          AND IAM_Status__c=:System.Label.IAM_Status_Active];
        }else if(subscriptionType.equalsIgnoreCase('All')){
            //Condition to return all Subscriptions.
            appsToReturn=[SELECT id,IAM_Application_Name__c,IAM_Role__c,IAM_Status__c,IAM_Subscription_Name__c 
                          FROM IAM_Application__c 
                          WHERE IAM_Account_Name__c=:accId
                          AND IAM_Status__c=:System.Label.IAM_Status_Active];
        }
        
        return appsToReturn;
        
    }    
    
    /*Method to make records in sObject Inactive.*/
    Public static String changeStatusToInactive(List<IAM_Application__c> apps){
           
            //loops through apps to change status Field to Inactive.
        
            for(IAM_Application__c ap:apps){
                ap.IAM_Status__c=System.Label.IAM_Status_Inactive;
                //Need to add rejection reason.
            }
            Update apps;
            return 'Records Inactivated'; 
    }
    
    
    /*Method to check BU and make necessary updates to Account.*/
    Public Static String updateAccount(Account acnt,String businessUnit,String action){
       System.debug('Prinitng Account Update'+businessUnit+'#####'+action);
        
        if(businessUnit.equalsIgnoreCase('Power Generation')){
            //Simply blank out the PSBU channel of Distribution.
            acnt.PSBU_Channel_of_Distribution__c=''; 
        }
        else if(businessUnit.equalsIgnoreCase('Engines')){
            //we also need to change the account type from exsisitng to new value by 
            //checking COD Fields.
            //Need to check the field is emty or not before setting type.
            if(!String.isBlank(acnt.PSBU_Channel_of_Distribution__c)){
                acnt.type=getTypefromCOD(acnt.PSBU_Channel_of_Distribution__c);
            }else if(!String.isBlank(acnt.Turbo_Channel_Of_Distribution__c)){
                acnt.type=getTypefromCOD(acnt.Turbo_Channel_Of_Distribution__c);
            }else if(!String.isBlank(acnt.IAM_Filtration_Channel_Of_Distribution__c)){
                acnt.type=getTypefromCOD(acnt.IAM_Filtration_Channel_Of_Distribution__c);
            }
            acnt.EBU_Channel_of_Distribution__c='';    
        }else if(businessUnit.equalsIgnoreCase('Turbochargers')){
            acnt.Turbo_Channel_Of_Distribution__c='';
        }else if(businessUnit.equalsIgnoreCase('Filtration')){
            acnt.IAM_Filtration_Channel_Of_Distribution__c='';
        }else if(businessUnit.equalsIgnoreCase('All')){
            //make WWSPS related Fields blank
            acnt.CSS_DistributorCode__c='';
            acnt.CSS_DBCode__c='';
            acnt.CSS_DealerCode__c='';
            acnt.EBU_Channel_Of_Distribution__c='';
            acnt.PSBU_Channel_of_Distribution__c='';
            acnt.IAM_Filtration_Channel_Of_Distribution__c='';
            acnt.Turbo_Channel_Of_Distribution__c='';
            // End of WWSPS
            acnt.ownerId=System.Label.IAM_Default_Account_Owner;//IAM default user id
            acnt.ParentId=getRegionalParentAccount(acnt.IAM_WWSPS_Regions__c)[0].id;    
            acnt.type='Customer';
            acnt.RecordTypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        }
            
           Update acnt;
           return 'Records Inactivated';   
    }
    
    /* Return Account Type against COD value from Metadata */
    public static String getTypeFromCOD(String COD){
        System.debug('Prinintg COD value'+COD);
        List<IAM_Channel_Of_Distribution_Mapping__mdt> types = [
            SELECT Id
                 , MasterLabel
                 , IAM_Account_Type__c
                 , IAM_Channel_Name_with_Number__c 
              FROM IAM_Channel_Of_Distribution_Mapping__mdt
             WHERE MasterLabel = :COD
        ];
        System.debug('#### Printing type value '+types[0].IAM_Account_Type__c);
       /* Map<String,IAM_Channel_Of_Distribution_Mapping__mdt> typesMap=new Map<String,IAM_Channel_Of_Distribution_Mapping__mdt>();
        for(IAM_Channel_Of_Distribution_Mapping__mdt app:types){
            typesMap.put(app.MasterLabel,app);
        }*/
        if(!types.isEmpty()) {
            return types[0].IAM_Account_Type__c;
        } else {
            return '';
        }
    }
    
    /*Method to process cancellation of entire location.*/
    Public Static String cancelEntireLocation(Account acnt){
        
        //Since cacellation of subscriptions happened.Now move Contacts to new IAM default location.
        List<Contact> contactsToMove=allContactFromLocation(acnt);
        if(!ContactsToMove.isEmpty()){
            for(Contact c:contactsToMove){
               //Updating account id
               System.debug('Printing account id');
                c.Accountid=System.Label.IAM_Default_Account_No_Codes_Associated;
            }
            Update ContactsToMove;
        }
        
        //making changes to account
        acnt.ownerid=System.Label.IAM_Default_IAM_Record_Owner;
        acnt.recordTypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS_Cancelled').getRecordTypeId();
        acnt.CMI_Account_Status__c='Cancelled';
        acnt.IAM_Service_Provider_Code__c='D-'+acnt.IAM_Service_Provider_Code__c;
        acnt.CSS_DBCode__c='';
        acnt.CSS_DealerCode__c='';
        acnt.CSS_DistributorCode__c='';
        update acnt;
        return 'Location Cancelled for All';
    }
    
    /*Method to get Contacts Associated to a specific account*/
    Public Static List<Contact> allContactFromLocation(Account acnt){
        return[SELECT id
                     ,FirstName
                     ,LastName
                     ,Email
                     ,Username__c
                     ,Accountid
              FROM Contact 
              WHERE Accountid=:acnt.id
              ];
    }
    
    /* Return WWSPS Admin User */
    public static User getWWSPSAdminUser() {
        List<UserRole> userRole = [SELECT Id FROM UserRole WHERE Name = 'WWSPS'];
        List<User> adminWWSPS;
        if(!userRole.isEmpty()) {
            adminWWSPS = [
                SELECT Id
                     , Name 
                  FROM User 
                 WHERE UserRoleId = :userRole[0].Id
                   AND IsActive = true
              ORDER BY Name 
                   ASC
            ];
        }
        if(adminWWSPS != null && !adminWWSPS.isEmpty()) {
            return adminWWSPS[0];
        } else {
            return null;
        }
    }
    
    /* Return regional parent account */
    public static List<Account> getRegionalParentAccount(String regionName) {
        return [ 
            SELECT Id
              FROM Account
             WHERE Name = :regionName
               AND Type = 'Internal'
             LIMIT 1
        ];
    }
    
    /* Return valid picklist value of given field of given object */
    public static Set<String> getPicklistValues(string fieldName,String objectName) {
        Set<String> setPickvals = new Set<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values) { 
            setPickvals.add(a.getLabel());
        }
        return setPickvals;
    }
}