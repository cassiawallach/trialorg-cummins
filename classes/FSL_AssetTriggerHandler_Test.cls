@isTest
public class FSL_AssetTriggerHandler_Test{


   public static testMethod void updateVinTest() {
        Test.startTest();
        
        FSL_SMN_DTC__c fst=new FSL_SMN_DTC__c (name='testmodel',BusinessUnit__c='test',FaultTypeFC__c='Yes',FaultTypePCode__c='Yes',FaultTypeSPNFMI__c='Yes');
        insert fst;
        
        
        Asset objasa = new Asset();
        objasa.Name = 'Test347';
        objasa.Type_PSN__c = 'Engines-Test347';
        objasa.Type__c = 'Engines';
        objasa.VIN__c = 'BN193956';
        objasa.Service_Model__c = 'testmodel';//added for Prod Migration

        insert objasa;
        
        objasa.VIN__c = 'BN193557';
        update objasa; 
        
        test.stoptest();
    }   
    public static testMethod void updateVinTest2() {
        Test.startTest();
        
            FSL_SMN_DTC__c fst=new FSL_SMN_DTC__c (name='testmodel',BusinessUnit__c='test',FaultTypeFC__c='Yes',FaultTypePCode__c='Yes',FaultTypeSPNFMI__c='Yes');
            insert fst;
            
            
            Asset objasa = new Asset();
            objasa.Name = 'Test347';
            objasa.Type_PSN__c = 'Products';
            objasa.Type__c = 'Products';
            objasa.VIN__c = 'BN193956';
            objasa.Service_Model__c = 'testmodel';
            insert objasa;
            
             objasa.VIN__c = 'BN1935567';
            update objasa;
            
            test.stoptest();
         }   
            
            
}