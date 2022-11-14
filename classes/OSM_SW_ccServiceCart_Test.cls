//Test Class for the class OSM_SW_ccServiceCartItem
//updated for MP_430 by swetha
@IsTest
public class OSM_SW_ccServiceCart_Test 
{
    static testMethod void testmethod1() 
    {
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put(ccrz.ccService.OBJECTFIELDS,'Name');
        Test.startTest();
        OSM_SW_ccServiceCart ss=new OSM_SW_ccServiceCart();
        OSM_SW_ccServiceCartItem sc=new OSM_SW_ccServiceCartItem();
        ss.getDirectQueryMap(inputMap);
        ss.getFieldsMap(inputMap);
        sc.getFieldsMap(inputMap);
        Test.stopTest(); 
    }
}