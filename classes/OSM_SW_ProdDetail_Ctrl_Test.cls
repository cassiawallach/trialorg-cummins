@isTest
public class OSM_SW_ProdDetail_Ctrl_Test {

	static testMethod void testOSM_SW_ProdDetail_Ctrl(){
    	//Create  Product
        List<ccrz__E_Product__c> lstEProduct = TestingUtils.createEProduct(1,'TestProduct', 'Released',2,'SK100-2', 'DA', true);
        
        // Start Test
        Test.startTest();
        
        PageReference pageRef = Page.ccrz__ProductDetails;
        pageRef.getParameters().put('sku',String.valueOf(lstEProduct[0].ccrz__SKU__c));
        Test.setCurrentPage(pageRef);
        OSM_SW_ProdDetail_Ctrl objOSM_SW_ProdDetail_Ctrl = new OSM_SW_ProdDetail_Ctrl();
        // Stop Test
        Test.stopTest();
    }
}