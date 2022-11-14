@isTest
public class dbu_validateproductwithstore_Test {
	
    
    @isTest static void testmethod1(){
        Test.startTest();
        ccrz__E_Product__c TestProduct3 = dbu_FactoryDataTest.createProduct('TestProduct3', true, false, false, true);
        TestProduct3.dbu_Crate_Engine__c = false; 
        TestProduct3.DBU_Product_Location__c = 'US';
        insert TestProduct3;
        
        Map<string,object> ty = dbu_validateproductwithstore.getdata('US',TestProduct3.id);
        Test.stopTest();
           
    }
}
//CumminsLogoFix