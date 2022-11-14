public class FSL_SVNTriggerHandler {
    public static void avoidDuplicateUser(List<Shop_Vehicle_Number__c> newList, Map<Id,Shop_Vehicle_Number__c> oldMap, List<Shop_Vehicle_Number__c> oldList){
        
        Set<Id> lstServiceTerritory = new Set<Id>();
        Map<String,Shop_Vehicle_Number__c> mapUserVsST = new Map<String,Shop_Vehicle_Number__c>();
        Map<Id, String> mapUserIdVsName = new Map<Id, String>();
        List<Id> lstUser = new List<Id>();
        
        //getting the service terriroty IDs of the SVN records.
        for(Shop_Vehicle_Number__c svn : newList){
            lstServiceTerritory.add(svn.Service_Territory__c);
            lstUser.add(svn.User__c);
        }
        
        for(User u : [Select id, name from user where id in : lstUser]){
            mapUserIdVsName.put(u.Id,u.Name);
        }
        
        system.debug('lstServiceTerritory-->'+lstServiceTerritory);
        
        //getting all the SVN records associated with those Service Territory
        for(Shop_Vehicle_Number__c allSVN : [Select Id,User__c,Service_Territory__c from Shop_Vehicle_Number__c where Service_Territory__c in: lstServiceTerritory]){
            mapUserVsST.put(allSVN.User__c + '#'+ allSVN.Service_Territory__c, allSVN);
        }
        
        system.debug('mapUserVsST-->'+mapUserVsST.keyset());
        
        for(Shop_Vehicle_Number__c svn : newList){
            if(oldMap == null || (oldMap!=null && svn.User__c != oldMap.get(svn.Id).User__c)){
                if(svn.User__c!=null && mapUserVsST.get(svn.User__c +'#' + svn.Service_Territory__c)!=null){
                    //throw error
                    String s = System.Label.FSL_Duplicate_SVN_User;
                    s = s.replace('<user>',mapUserIdVsName.get(svn.User__c));
                    svn.adderror(s);
                }
            }
        }
    }
}