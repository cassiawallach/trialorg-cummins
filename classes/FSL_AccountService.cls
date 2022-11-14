public inherited sharing class FSL_AccountService {
    public static List<account> acctList;
    public static string query;//added As a part of FBI 393
    //builds linked list of the hiearchy 
    public static Set<Id> getChildAccountsInHierarchy(Id accId) {
        
        Boolean endTraversing = false;
        Integer accountLevel = 0;
        //acctList = new List<account>();
        List<id> parentIdList = new List<id>();
        Set<id> allAccIdSet = new Set<id>();
        
        allAccIdSet.add(accId);
        parentIdList.add(accId);
        while(!endTraversing) {  //added As a part of FBI 393
            acctList = acclist(accountLevel,parentIdList); //added As a part of FBI 393
            
            if(acctList.size() == 0 ) {
                endTraversing = true;
            } else {
                parentIdList.clear();
                acctList.sort();
                Account a;
                for(Integer i = 0; i < acctList.size(); i++ ) {
                    a = acctList.get(i);
                    parentIdList.add(a.Id);
                    allAccIdSet.add(a.Id);
                }
                accountLevel++;
            }
        }
        
        return allAccIdSet;
    }
    //added As a part of FBI 393
    public static list<account> acclist(Integer accountLevel,List<id> parentIdList){
        //added As a part of FBI 393
        if(accountLevel == 0) {
            query = 'SELECT Id, Name FROM Account WHERE Id IN: parentIdList';
        } else {
            query = 'SELECT Id, Name FROM Account WHERE ParentId IN: parentIdList';
        }
        acctList = Database.query(String.escapeSingleQuotes(query));//added As a part of FBI 393
        system.debug('acctList>>>'+acctList);
        //added As a part of FBI 393
        return acctList;
        
    }
    //added As a part of FBI 393
    
}