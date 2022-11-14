@isTest
public class CSS_InsiteActReqWrapper_Test {
    static testMethod void InsiteActReqWrapperTest(){ 
        Test.startTest();
        CSS_InsiteActReqWrapper obj = new CSS_InsiteActReqWrapper();
        obj.actionType = 'Act';
        CSS_InsiteActReqWrapper.Properties csProp = new CSS_InsiteActReqWrapper.Properties();
        csProp.propertyName = 'propertyName';
        csProp.propertyValue = 'propertyValue';
        CSS_InsiteActReqWrapper.ActionProperties props = new CSS_InsiteActReqWrapper.ActionProperties();
        List<CSS_InsiteActReqWrapper.Properties> propList = new List<CSS_InsiteActReqWrapper.Properties>();
        propList.add(csProp);
        props.properties = propList;
        obj.dsProperties = props;
        String json = CSS_InsiteActReqWrapper.parse(obj);        
        Test.stopTest();
    }
}