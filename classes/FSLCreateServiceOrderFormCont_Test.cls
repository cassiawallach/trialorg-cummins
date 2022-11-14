@isTest
public class FSLCreateServiceOrderFormCont_Test {
	@isTest
    Public static void UnitTest(){
        disco__Form_Template__c testTemp = new disco__Form_Template__c(name='Test',FSL_Approval_Status__c='Approved' , disco__Status__c='In Use');
        insert testTemp;
        Account a=new Account();
        a.name='name';
        a.CSS_DistributorCode__c='02850';
        a.IAM_Service_Provider_Code__c='99945';
        a.Type='Dealer Account';
        a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        insert(a);
        Workorder wo = new workorder(accountId = a.id);
        insert wo;
        
        test.startTest();
        lookUpController.fetchLookUpValues('Test','');
        FSLCreateServiceOrderFormCont.createForm(wo.id,testTemp.id);
        test.stoptest();
        List<disco__Form__c> dis = new List<disco__Form__c>();
        dis = [Select id from disco__Form__c];
        system.assertEquals(1, dis.size());
        
    }
}