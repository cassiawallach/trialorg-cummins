public class lookUpController {
    @AuraEnabled
	public static List < disco__Form_Template__c > fetchLookUpValues(String searchKeyWord,string ObjectName) {
        String searchKey = searchKeyWord + '%';
        List < disco__Form_Template__c > returnList = new List < disco__Form_Template__c > ();
        returnList = [select id, Name from disco__Form_Template__c where Name LIKE: searchKey and FSL_Approval_Status__c='Approved' and disco__Status__c='In Use'];
        return returnList;
    }
}