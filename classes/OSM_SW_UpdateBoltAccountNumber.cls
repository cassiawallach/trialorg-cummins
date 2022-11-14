global class OSM_SW_UpdateBoltAccountNumber implements Database.Batchable<sObject>,Schedulable {
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        list<string> Branchaccounts = new list<string>{'Distributor Branch Account','CIHR','Distributor Branch','Fleet','National Account','Special Account'};
            list<string> Parentaccounts = new list<string>{'Distributor Account','SPECIAL ACCOUNT-HQ','NATIONAL ACCT_CIHR - HQ'};
                return Database.getQueryLocator([Select Id,parent.Bolt_Site_Number__c,parent.BOLT_reference_number__c,parent.Bolt_Receivable_Account__c,parent.Bolt_Party_Number__c,parent.Bolt_Party_Name__c,parent.Bolt_Customer_Type__c,parent.Bolt_Payment_Terms__c,parent.Bolt_Acc_Site_Reference__c,Bolt_Site_Number__c,Bolt_Party_Name__c,Bolt_Receivable_Account__c,BOLT_reference_number__c,Bolt_Payment_Terms__c,Bolt_Acc_Site_Reference__c,Bolt_Customer_Type__c,ParentID, parent.BOLT_Account_Number__c, parent.Bolt_Credit_Hold__c ,parent.Bolt_Customer_Account_Status__c, parent.Bolt_BC_Code__c,CSS_DistributorCode__c,EBU_Channel_of_Distribution__c,PSBU_Channel_of_Distribution__c,Type, Bolt_BC_Code__c,BOLT_Account_Number__c, Bolt_Credit_Hold__c, Bolt_Customer_Account_Status__c from Account where (EBU_Channel_of_Distribution__c IN:Branchaccounts OR PSBU_Channel_of_Distribution__c IN:Branchaccounts OR Type IN:Branchaccounts ) AND (parent.EBU_Channel_of_Distribution__c IN:Parentaccounts OR parent.PSBU_Channel_of_Distribution__c IN:Parentaccounts OR parent.Type IN:Parentaccounts ) AND BOLT_Account_Number__c=Null AND ParentID!=Null AND parent.BOLT_Account_Number__c !=null ]);
    }
    
    public void execute(Database.BatchableContext BC, List<account> scope){
        list<account>  updateAccountList = new list<account>();
        for(Account objAcc : scope){
            objAcc.BOLT_Account_Number__c = objAcc.parent.BOLT_Account_Number__c;
            objAcc.Bolt_Credit_Hold__c = objAcc.parent.Bolt_Credit_Hold__c;
            objAcc.Bolt_Customer_Account_Status__c = objAcc.parent.Bolt_Customer_Account_Status__c;
            objAcc.Bolt_BC_Code__c = objAcc.parent.Bolt_BC_Code__c;
            objAcc.Bolt_Site_Number__c= objAcc.parent.Bolt_Site_Number__c;
            objAcc.Bolt_Site_Number__c= objAcc.parent.Bolt_Site_Number__c;
            objAcc.BOLT_reference_number__c= objAcc.parent.BOLT_reference_number__c;
            objAcc.Bolt_Receivable_Account__c= objAcc.parent.Bolt_Receivable_Account__c;
            objAcc.Bolt_Party_Number__c= objAcc.parent.Bolt_Party_Number__c;
            objAcc.Bolt_Party_Name__c= objAcc.parent.Bolt_Party_Name__c;
            objAcc.Bolt_Customer_Type__c= objAcc.parent.Bolt_Customer_Type__c;
            objAcc.Bolt_Acc_Site_Reference__c= objAcc.parent.Bolt_Acc_Site_Reference__c;
            updateAccountList.add(objAcc);
        }
        system.debug('records'+updateAccountList.size());
        if(updateAccountList.size() > 0){
            database.Update (updateAccountList, false);
        }
    }
    
    public void finish(Database.BatchableContext BC){
    }
    public void execute(SchedulableContext SC) {
        Database.executeBatch(new OSM_SW_PopulateOrderManagementCode(),2000);
    }
    
    
}