/**********************************************************************
Name:FSL_IntegrationIdUpdate
Copyright Â© 2019  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
This class is used for updating Account, Contact, Site and Unit Inbound services.
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0     SRIPRADA SESHAM             03/17/2020    Initial Development
1.1     Sunitha Mattaparthi         11/25/2020    Added Movex-190,200,250,270 for EU Rollouts
1.2     SUnitha M                   3/10/2020     Added Movex-175 for Argentina Rollouts
********************************************************************************************************************/
public class FSL_IntegrationIdUpdate {
    
    //to update customer code --- customer inbound integration
    @future(callout=true)
    public static void getAccountId(string recId, string accId) {
        String accountId;
        System.debug('::: Account Id:'+recId+''+accId);
        Account acc = [SELECT id, FSL_ERP_Customer_Code__c from Account WHERE Id =:recId];
        System.debug('::: Acc Id:'+acc);
        if(acc.FSL_ERP_Customer_Code__c != '' && acc.FSL_ERP_Customer_Code__c != null) {
            accountId = acc.FSL_ERP_Customer_Code__c;
        }
        accountId = accId;
        system.debug('::: UpdatedAccountId:'+accountId);
        updateacc(accountId,recId);
    }
    
    public static void updateacc(string updateaccId, string recId) {
        Account acc = [SELECT id, FSL_ERP_Customer_Code__c from Account WHERE id =:recId];
        if(string.isNotBlank(acc.Id)) {
            acc.FSL_ERP_Customer_Code__c = updateaccId;
            if(String.isNotBlank(updateaccId) && updateaccId.contains('-') && String.isNotBlank(updateaccId.split('-')[1]) )
            	acc.FSL_BMS_Instance__c = updateaccId.split('-')[1];
            update acc;
            system.debug('UpdatedAccountId:'+acc.FSL_ERP_Customer_Code__c);
        }
    }
    
    //to update contactId ---- Contact integration
    @future(callout = true)
    public static void getContactId(string recId, string cntId) {
        String contactId;
        System.debug('Con Id:'+recId+''+cntId);
        Contact con = [SELECT Id, FSL_Contact_Id__c FROM Contact WHERE Id =: recId];
        System.debug('Con Id:'+con);
        if(con.FSL_Contact_Id__c != '' && con.FSL_Contact_Id__c != null) {
            contactId = con.FSL_Contact_Id__c;
        }
        contactId = cntId;
        system.debug('UpdatedContactId:'+contactId);
        updateconId(contactId, recId);
    }
    
    public static void updateconId(string updateconId, string recId) {
        Contact con = [SELECT Id, FSL_Contact_Id__c FROM Contact WHERE Id =: recId];
        if(string.isNotBlank(con.Id)) {
            con.FSL_Contact_Id__c = updateconId;
            update con;
            system.debug('UpdatedContactId:'+con.FSL_Contact_Id__c);
        }
    }
    
    //TO UPDATE SITEID --- SITE INTEGRATION
    //to update contactId ---- Contact integration
    @future(callout = true)
    public static void getSiteId(string recId, string stId) {
        //CT2-416 : IAM_CDH_Cross_references__c is replaced by Address && FSL_MoveX_Site_Id__c replaced by FSL_Site_ID__c
        String siteId;
        System.debug('Site Id:'+recId+''+siteId);
        Schema.Address st = [SELECT Id, FSL_Site_ID__c FROM Address WHERE Id =: recId];
        System.debug('Site Id:'+st);
        if(st.FSL_Site_ID__c != '' && st.FSL_Site_ID__c != null) {
            siteId = string.valueOf(st.FSL_Site_ID__c);
        }
        siteId = stId;
        system.debug('UpdatedSiteId:'+siteId);
        updateSiteId(siteId, recId);
    }
    
    public static void updateSiteId(string updateStId, string recId) {
        //CT2-416 : IAM_CDH_Cross_references__c is replaced by Address && FSL_MoveX_Site_Id__c replaced by FSL_Site_ID__c
        Schema.Address st = [SELECT Id, FSL_Site_ID__c FROM Address WHERE Id =: recId];
        if(string.isNotBlank(st.Id)) {
            st.FSL_Site_ID__c = updateStId;
            update st;
            system.debug('UpdatedSiteId:'+st.FSL_Site_ID__c);
        }
    }
    
    //TO UPDATE IndividualItemNumber & Type-PSN --- UnitInbound INTEGRATION
    @future(callout = true)
    public static void getAssetId(string recId, string indvId, string custCode) {
        String individualItemNumber;
        String customerCode;
        system.debug('UpdatedAssetCC:' +custCode);
        
        System.debug('Asset Id:'+recId+''+indvId);
        Asset astObj = [SELECT Id, Individual__c, Account.FSL_ERP_Customer_Code__c FROM Asset WHERE Id =: recId];
        System.debug('Asset Id:'+astObj);
        if(astObj.Individual__c != '' && astObj.Individual__c != null) {
            individualItemNumber = astObj.Individual__c;
        }
        if(astObj.Account.FSL_ERP_Customer_Code__c != '' && astObj.Account.FSL_ERP_Customer_Code__c != null) {
            customerCode = astObj.Account.FSL_ERP_Customer_Code__c;
        }
        individualItemNumber = indvId;
        customerCode = custCode;
        system.debug('UpdatedAssetId:'+individualItemNumber);
        updateAssetId(individualItemNumber, recId, customerCode);
    }
    
    public static void updateAssetId(string updateAstId, string recId, string accCode) {
        User usr = new User();
        usr = [SELECT Id, ERP__c,UserRole.Name, Name, FederationIdentifier 
               FROM User 
               WHERE Id =: UserInfo.getUserId() LIMIT 1];
        String UserERP;
        UserERP = (String)usr.ERP__c;
        
        Asset asst1 = [SELECT Id, Type__c, Individual__c, Service_Model__c, Unit_Number__c, Engine_Family_Code__c 
                       FROM Asset WHERE Id =: recId];
        system.debug('UpdatedAssetCC:' +accCode);
        
        if(string.isNotBlank(asst1.Id)) {
            asst1.Individual__c = updateAstId;
            //EUrollouts 
            if((UserERP == 'MOVEX-UK'||UserERP == 'MOVEX-CDK'||UserERP == 'MOVEX-CSP'||UserERP =='MOVEX-190'||UserERP =='MOVEX-200'||UserERP =='MOVEX-250'||UserERP =='MOVEX-270'||UserERP =='MOVEX-175') && (asst1.Engine_Family_Code__c == 'BB' || asst1.Service_Model__c == 'NON CUMMINS')) {
                asst1.Type_PSN__c = 'Engines-' + updateAstId;
                // asst1.Type_PSN__c = asst1.Type__c + '-' + updateAstId;
                /* if(asst1.Type__c == 'Engines' || asst1.Type__c == 'Products') {
                    asst1.Type_PSN__c = asst1.Type__c + '-' + updateAstId;
                }
                else if(asst1.Type__c == 'ENGINE' || asst1.Type__c == 'GENSET') {
                    asst1.Type_PSN__c = 'Engines-' + updateAstId;
                }
                else if(asst1.Type__c == 'FIREPUMP' || asst1.Type__c == 'ENGINE CORE' || asst1.Type__c == 'SWITCH GEAR' || 
                        asst1.Type__c == 'TRANSFER SWITCH' || asst1.Type__c == 'TRANSMISSIONS' || 
                        asst1.Type__c == 'BATTERY' || asst1.Type__c == 'PARSYS' || asst1.Type__c == 'MARINE GEAR') 
                {
                    asst1.Type_PSN__c = 'Products-' + updateAstId; // Need to update this when MOVEX has Engines or Products classification
                } */
            }
            else if(UserERP == 'BMS' && (asst1.Engine_Family_Code__c == '99' || asst1.Service_Model__c == 'NON CUMMINS')) {
                // asst1.Type_PSN__c = asst1.Type__c + '-' + accCode + '-' + asst1.Unit_Number__c;
                if(asst1.Type__c == 'Engines' || asst1.Type__c == 'Products') {
                    asst1.Type_PSN__c = asst1.Type__c + '-' + accCode + '-' + asst1.Unit_Number__c;
                }
                else if(asst1.Type__c == 'ENGINE' || asst1.Type__c == 'GENSET') {
                    asst1.Type_PSN__c = 'Engines-' + accCode + '-' + asst1.Unit_Number__c;
                }
                else if(asst1.Type__c == 'FIREPUMP' || asst1.Type__c == 'ENGINE CORE' || asst1.Type__c == 'SWITCH GEAR' || 
                        asst1.Type__c == 'TRANSFER SWITCH' || asst1.Type__c == 'TRANSMISSIONS' || 
                        asst1.Type__c == 'BATTERY' || asst1.Type__c == 'PARSYS' || asst1.Type__c == 'MARINE GEAR') 
                {
                    asst1.Type_PSN__c = 'Products-' + accCode + '-' + asst1.Unit_Number__c;
                }
            }
            update asst1;
            system.debug('UpdatedAssetId:' + asst1.Individual__c);
        }
    }
}