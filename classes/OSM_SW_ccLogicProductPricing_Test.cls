@isTest
public class OSM_SW_ccLogicProductPricing_Test {
    static testmethod void testOSM_SW_ccLogicProductPricing(){
        // Start Test
        Test.startTest();        
        Map<String, Object> inputMap = new Map<String, Object>();
        OSM_SW_ccLogicProductPricing objOSM_SW_ccLogicProductPricing = new OSM_SW_ccLogicProductPricing();
        objOSM_SW_ccLogicProductPricing.processSelectedPLIs(inputMap);
            
        // Stop Test
        Test.stopTest();
    }
}