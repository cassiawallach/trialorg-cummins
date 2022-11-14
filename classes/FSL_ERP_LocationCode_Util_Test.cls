@isTest 
public class FSL_ERP_LocationCode_Util_Test {
    
     static testMethod void validateLocationCodeBMS() 
     {
      
        Test.startTest();
       	String sLoc = '23456-78655-I';
		FSL_ERP_LocationCode_Util.getLocationCode(sLoc);
        Test.stopTest();
    }
     static testMethod void validateLocationMoveX()
    
    {
        Test.startTest();
        String sLoc = '23456-78655-746';
		FSL_ERP_LocationCode_Util.getLocationCode(sLoc);
        Test.stopTest();
    }
    
     static testMethod void validateLocationCodeMoveXUK()
    {
        Test.startTest();
        String sLoc = '23456-78655-657-I';
		FSL_ERP_LocationCode_Util.getLocationCode(sLoc);
        Test.stopTest();
    }
}