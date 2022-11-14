/************************************************************
Name:  IAM_PartnerJIT_Contact_QueueableUpdates
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class provides logic for inbound just-in-time provisioning of single sign-on users in your Salesforce organization.                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Karthik Raj Golakaram          1/16/2020        INITIAL DEVELOPMENT
1.1 -    Anupam Adhikari                03/23/2022       Changes for Ryder Fed 
1.2 -    Anupam Adhikari                04/21/2022       Changes for RyderCumpas Fed
******************************************************/
/********************************************************************************
***********************************************************************************/
public with sharing class IAM_PartnerJIT_Contact_QueueableUpdate implements Queueable {

    public string action;
    public user partnerUser;
    public Account partnerAccount;
    public contact partnerContact;
    public Map<string,string> attributes;
    public Map<String,IAM_Application__c> partnerAccountAccessMap;
    public Map<String,IAM_Contact_Provisioning__c> partnerContactAccessMap;
    public static string APP_NAME_QSOL=System.Label.IAM_AppName_QSOL;
    public static string APP_NAME_EDS=System.Label.IAM_AppName_EDS;
    public static string APP_NAME_CST=System.Label.IAM_AppName_Promotion;
    public static string QSOL_ROLE_CIHR='QSOL CIHR';
    public static string EDS_ROLE_TECHNICIAN='Technician';
    public static string CST_ROLE_TRAINING='Service Training User';
    public static string APP_NAME_CUMPAS=System.Label.IAM_AppName_Cumpas;//added for Ryder-Cumpas Integration changes
    public boolean bIsPartnercode;
    public boolean bUpdateWorkGrp;

    public IAM_PartnerJIT_Contact_QueueableUpdate(User partnerUser,Account partnerAccount,Contact partnerContact,Map<String,IAM_Application__c> partnerAccountAccessMap,Map<String,IAM_Contact_Provisioning__c> partnerContactAccessMap,Map<string,string> attributes, Boolean bIsPartnercode, Boolean bUpdateWorkGrp) {
        this.partnerUser=partnerUser;
        this.partnerAccount=partnerAccount;
        this.partnerContact=partnerContact;
        this.partnerAccountAccessMap=partnerAccountAccessMap;
        this.partnerContactAccessMap=partnerContactAccessMap;
        this.attributes=attributes;
        this.bIsPartnercode=bIsPartnercode;
        this.bUpdateWorkGrp=bUpdateWorkGrp;
    }

    public void execute(QueueableContext qc){

        if(!partnerContactAccessMap.isEmpty()){
            //Start - Ryder-Cumpas changes
            if(attributes.get('uid').containsIgnoreCase('ryd') && (!partnerContactAccessMap.ContainsKey(APP_NAME_QSOL)||!partnerContactAccessMap.ContainsKey(APP_NAME_CST)||!partnerContactAccessMap.ContainsKey(APP_NAME_EDS))){
                IAM_PartnerJITImplementation.createContactProvisionings(partnerUser,partnerContact,partnerAccountAccessMap,partnerContactAccessMap,attributes,bIsPartnercode);
            }else if(!partnerContactAccessMap.ContainsKey(APP_NAME_QSOL)||!partnerContactAccessMap.ContainsKey(APP_NAME_CST)||!partnerContactAccessMap.ContainsKey(APP_NAME_EDS)){
                IAM_PartnerJITImplementation.createContactProvisionings(partnerUser,partnerContact,partnerAccountAccessMap,partnerContactAccessMap,attributes,bIsPartnercode);
            }
            //End - Ryder-Cumpas changes
        }else{
            IAM_PartnerJITImplementation.createContactProvisionings(partnerUser,partnerContact,partnerAccountAccessMap,partnerContactAccessMap,attributes,bIsPartnercode);
        }

        contact partnerContactToSetAttributes;
        Boolean isCreateUser=false;
        Boolean partneContactisInactive=false;
        Map<String,Boolean>reclaimTracker= new Map<String,Boolean>();
        
        if(partnerContact.id!=null){
            System.debug('Printing not a new Contact');
            partnerContactToSetAttributes=new Contact(id=partnerContact.id);
            partnerContactToSetAttributes.IAM_Work_Group_Id__c = partnerContact.IAM_Work_Group_Id__c;
            if(bUpdateWorkGrp){
                partnerContactToSetAttributes.IAM_Work_Group_Id__c=partnerAccount.Location__c+System.Label.IAM_WorkGrpAddition_Symbol;
            }
            if(partnerContact.IAM_Contact_Status__c=='Inactive'){
                partneContactisInactive=True;
            }
        }else{
            System.debug('Printing a new Contact');
            partnerContactToSetAttributes = new Contact();
            isCreateUser=True;
            partnerContactToSetAttributes.IAM_Work_Group_Id__c=partnerAccount.Location__c+System.Label.IAM_WorkGrpAddition_Symbol;
        }
        
        partnerContactToSetAttributes.Accountid=partnerAccount.id;
        if(attributes.ContainsKey('givenname')){
            partnerContactToSetAttributes.FirstName=attributes.get('givenname');         
        }
        if(attributes.containsKey('sn')){
            partnerContactToSetAttributes.LastName=attributes.get('sn');
        }
        if(attributes.containsKey('email')){
            partnerContactToSetAttributes.email=attributes.get('email');
        }
        if(attributes.containsKey('uid')){
            partnerContactToSetAttributes.Username__c=attributes.get('uid');
            partnerContactToSetAttributes.IAM_Ext_Legacy_Uid__c=attributes.get('uid');
        }
        partnerContactToSetAttributes.IAM_Contact_Status__c='Active';
        partnerContactToSetAttributes.CMI_Contact_Type__c='Secondary';
        //partnerContactToSetAttributes.IAM_ABO_Code__c=partnerAccount.IAM_ABO_Code_Formula__c;
        //partnerContactToSetAttributes.IAM_Contact_source__c='Penske';//Since penske federation.
        if(attributes.get('email').contains('penske')){
            partnerContactToSetAttributes.IAM_Contact_source__c='Penske';//Since penske federation.
        }
            //Start For Ryder
        if(attributes.get('uid').containsIgnoreCase('ryd')){
            partnerContactToSetAttributes.IAM_Contact_source__c='Ryder';//Since Ryder federation.
        }
            //End for Ryder
        partnerContactToSetAttributes.Language_Preferences__c='English';
        partnerContactToSetAttributes.IAM_Product_Group_Access__c='PGA03';
        partnerContactToSetAttributes.RecordTypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        partnerContactToSetAttributes.IAM_Legacy_User__c=True;
        partnerContactToSetAttributes.IAM_From_JIT_Execution__c=True;
       /* if(partnerContact.id!=null){
            Map<String,String> contactAttributesToSet=IAM_PartnerJITImplementation.getcontactAttributes(partnerContact);
            if(contactAttributesToSet.ContainsKey('IAM_Applications__c')){
                partnerContactToSetAttributes.IAM_Applications__c=contactAttributesToSet.get('IAM_Applications__c');
            }
            if(contactAttributesToSet.ContainsKey('IAM_Application_Roles__c')){
                partnerContactToSetAttributes.IAM_Application_Roles__c=contactAttributesToSet.get('IAM_Application_Roles__c');
            }   
            if(contactAttributesToSet.ContainsKey('IAM_swregexpire__c')){
                partnerContactToSetAttributes.IAM_swregexpire__c=contactAttributesToSet.get('IAM_swregexpire__c');
            }
            if(contactAttributesToSet.ContainsKey('IAM_Qsolexpiration__c')){
                partnerContactToSetAttributes.IAM_Qsolexpiration__c=contactAttributesToSet.get('IAM_Qsolexpiration__c');
            }
            
        }else{*/
            //since we are creating a new contact there won't be any new contact provisionings. so we can hard code the vales.
            if(bIsPartnercode){
                partnerContactToSetAttributes.IAM_Applications__c='cn=quickserve_cihr,ou=app_quickserve,ou=application,dc=cummins,dc=com|cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com|cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com|cn=DBU_DN_DEALER_USERS,ou=App_DBU_commerce,ou=application,dc=cummins,dc=com';
                partnerContactToSetAttributes.IAM_Application_Roles__c='QSOL CIHR,Service Training User,Technician,Dealer User';
            }else{
                partnerContactToSetAttributes.IAM_Applications__c='cn=quickserve_cihr,ou=app_quickserve,ou=application,dc=cummins,dc=com|cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com|cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com';
                partnerContactToSetAttributes.IAM_Application_Roles__c='QSOL CIHR,Service Training User,Technician';
            }
            partnerContactToSetAttributes.IAM_is_Member_of__c='';
            partnerContactToSetAttributes.IAM_Qsolexpiration__c=partnerAccountAccessMap.get(APP_NAME_QSOL).IAM_Qsolexpiration__c;
    //}

    update partnerContactToSetAttributes;
    
   


    if(partneContactisInactive){
        id jobId= System.enqueueJob(new IAM_Reclaim_Queable_API_Class(partnerContactToSetAttributes));
    }else{
        system.debug('Updating the exsisting contact to LDAP');
        List<IAM_Contact_Provisioning__c> allConProv=[SELECT id,IAM_Application_Name__c,IAM_role__c,IAM_Status__c FROM IAM_Contact_Provisioning__c WHERE IAM_Contact__c=:partnerContactToSetAttributes.id AND IAM_Status__c=:'Active'];
        Set<id> allConProvIds= new Set<id>();
        Map<id,String> allApps= new Map<id,String>();
        if(!allConProv.isEmpty()){
            for(IAM_Contact_Provisioning__c conProv:allConProv){
                allConProvIds.add(conProv.id);
            }
            System.debug('Printing all the ids that are being pased to the LDAP Group Addition'+allConProvIds);    
            //calling LDAP Group Addition Class
            IAM_RC_UserGroupMapping.basicAuthCallout(allConProvIds,allApps,false);
        }
    }

    //Making a future call out to CST application for registring the user in their application.
    List<IAM_Contact_Provisioning__c> allConProv=[SELECT id,IAM_Application_Name__c FROM IAM_Contact_Provisioning__c WHERE IAM_Contact__c=:partnerContactToSetAttributes.id and IAM_Application_Name__c=:APP_NAME_CST AND IAM_Status__c=:'Active'];
    if(!allConProv.isEmpty()){
        System.debug('Entered CST Application Call');
        Set<id> cstAppid=new Set<id>{allConProv[0].id}; 
        IAM_CSTUserOutboundHelper.CstOutboundCall(cstAppid);
    }
    }

}