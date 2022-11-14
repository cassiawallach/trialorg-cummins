/**************************************************************************************
Name:  IAM_LDAP_Util_Callout_Batch
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Batch class to call LDAP API to create or update user details in LDAP
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                      DATE               DETAIL                                
1            Lavanya Javvadi             12/17/2021       Intial development
**************************************************************************************
**************************************************************************************/


public class IAM_LDAP_Util_Callout_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    public string action;
    public list<Id> cons = new list<id>();
    public Set<Id> conIdss;

    public IAM_LDAP_Util_Callout_Batch(Set<Id> conIds, String action){
        system.debug(conIds);
        this.action = action;
        if(conIds == null){
            this.conIdss = new set<Id>();
        }
        else{
            this.conIdss = conIds;
        }
        if(conIdss.size()>0){
            for(Id conId:conIdss){
                this.cons.add(conId);
            }
        }       
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        //system.debug(cons)
        String query = 'select id from contact where id in :cons';
        system.debug(Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
        
    }

    public void execute(Database.BatchableContext bc, list<contact> cons){
        system.debug(cons);
        set<Id> Ids = new set<Id>();
        for(contact con:cons){
            Ids.add(con.id);
        }
        IAM_LDAP_Util_ApexCallout.callLDAPCreateOrUpdateUserAPI(Ids, action);
    }

    public void finish(Database.BatchableContext bc){
        
    }
}