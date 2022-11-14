/**************************************************************************************
Name:  IAM_LDAP_Util_Subcription_Callout
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Queueable class to call LDAP API to create or update user details in LDAP
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                      DATE               DETAIL                                
1.0      Karthik Raj Golakaram        11/16/2018        INITIAL DEVELOPMENT
1.1      Karthik Raj Golakaram        01/29/2021        Made changes for Mule API 
1.2      Shubhangi Sardar             20/05/2021        Code Optimization
**************************************************************************************
**************************************************************************************/
public class IAM_LDAP_Util_Subcription_Callout implements Queueable, Database.AllowsCallouts  {

    public Set<Id> conIds;
    public String action;
    public Integer batchsize = Integer.valueof(Label.IAM_LDAP_Util_Callout_Batch_Size);
    public IAM_LDAP_Util_Subcription_Callout(Set<Id> conIds, String action){
        this.conIds = conIds;
        this.action = action;
    }
    
    public Void execute(QueueableContext context) {
        if(conIds.size()<100){
            IAM_LDAP_Util_ApexCallout.callLDAPCreateOrUpdateUserAPI(conIds, action); 
        }else{
            system.debug(conIds);
            system.debug(action);
            IAM_LDAP_Util_Callout_Batch batch = new IAM_LDAP_Util_Callout_Batch(conIds,action);
            Database.executeBatch(batch,batchSize);
        }
    }     
}