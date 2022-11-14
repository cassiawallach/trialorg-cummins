@isTest
private class FSL_Comm_RegionToggles_Controller_Test {
    
    @isTest static void regionTogglesUnitTest1() {
        
        Map<String, String> fieldWithValuesMap = new Map<String, String>();
        fieldWithValuesMap.put('name' , 'Authorized_Work_Started__c');
        fieldWithValuesMap.put('value' , 'true');
        
        
        List<Map<String, String>> fieldWithValuesList = new List<Map<String, String>>();
        fieldWithValuesList.add(fieldWithValuesMap);
        test.StartTest();
        FSL_Comm_RegionToggles_Controller.getRegionTogglesMetaData();
        FSL_Comm_RegionToggles_Controller.getPickListValuesIntoList('Email_Frequency');
        FSL_Comm_RegionToggles_Controller.getallMetadata();
        FSL_Comm_RegionToggles_Controller.getRegion('BMS');
        FSL_Comm_RegionToggles_Controller.getallMetadatapicklist();
        FSL_Comm_RegionToggles_Controller.createUpdateMetadata('Test','BMS',fieldWithValuesList);
        test.StopTest();
    }
}