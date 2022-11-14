//Test Class for the class OSM_SW_ccServiceProduct
@IsTest
public class OSM_SW_ccServiceProduct_Test 
{
    static testMethod void testmethod1() 
    {
        Test.startTest();        
        Map<String, Object> inputMap = new Map<String, Object>();
        OSM_SW_ccServiceProduct obj1 = new OSM_SW_ccServiceProduct();
        obj1.getFieldsMap(inputMap);
        Test.stopTest();
    }
}