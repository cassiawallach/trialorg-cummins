public class FSLCreateServiceOrderFormCont {
    @auraEnabled
    public static string createForm(string soId,string tempId){
        disco__Form__c dis = new disco__Form__c(Service_Order__c=soId,disco__Form_Template__c=tempId);
        insert dis;
        return dis.id;
        
    }

}