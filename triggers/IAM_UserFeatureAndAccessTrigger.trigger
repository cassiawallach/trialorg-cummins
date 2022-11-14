/*************************************************************************************
Name:  IAM_UserFeatureAndAccessTrigger
Copyright © 2019  Cummins
**************************************************************************************
Purpose: It triggers functionality like updating fields on Contact Provisioning, call
LDAP grop API to add/remove user to/from LDAP, call CST API, call RSW API
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Karthik Raj Golakaram     01/16/2020     INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar          12/03/2020     Added FT-NPBU Dignostics app logic
1.2      Karthik Raj Golakaram     03/21/2021     Logic to skip trigger execution from JIT
1.3      Shubhangi Sardar          01/02/2021     Added before update trigger
1.4      Shubhangi Sardar          27/04/2021     LDAP Sync Issue Fix
1.5      Karthik Golakaram         03/21/2021     Added changes to skip trigger execution when contact 
                                                  is getting created or getting updated from JIT partner
**************************************************************************************
**************************************************************************************/

trigger IAM_UserFeatureAndAccessTrigger on IAM_Contact_Provisioning__c (after insert, after update,
before insert, before update){
    System.debug('Prinitng User Access trigger context is before'+Trigger.isBefore);
    System.debug('Prinitng User Access trigger context is After'+Trigger.isAfter);
    System.debug('Prinitng User Access trigger context is insert'+Trigger.isInsert);
    System.debug('Prinitng User Access trigger context is Update'+Trigger.isUpdate);    
    new IAM_UserAccessTriggerHandlerNew().run();
}