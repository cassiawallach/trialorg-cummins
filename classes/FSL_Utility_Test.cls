//Adding Comment for code coverage -- Sriprada S

@isTest
public class FSL_Utility_Test{ 
    
    static testmethod  void testsetEligibilityForApplicationLogging(){
        test.starttest();
        boolean booltest = FSL_Utility.setEligibilityForApplicationLogging();
        test.stoptest();
    }
    
    
    static testmethod  void testsetEligibilityForApplicationLogging1(){
        test.starttest();
        String strUtil =  FSL_Utility.SetNow();
        test.stoptest();
    }
    
    static testmethod  void LogOutIntError(){
        test.starttest();
        FSL_Utility.LogOutIntError('test1','test2','test3','test4');
        test.stoptest();
    }
    
     static testmethod  void LogOutInbtError(){
        test.starttest();
        FSL_Utility.LogInbIntError('test1','test2','test3','test4');
        test.stoptest();
    }
    
     static testmethod  void userinfo(){
        test.starttest();
        FSL_Utility.UserInfo();
        test.stoptest();
    }
    
    static testmethod  void countryinfo(){
        //Creating Country State Values object
        CSS_CountryStateValues__c cs = new CSS_CountryStateValues__c();
        cs.Name = 'countrystate';
        cs.StateName__c = 'Indiana';
        cs.CountryName__c = 'United States';
        cs.CountryCode__c = 'US';
        cs.StateCode__c = 'IN';
        insert cs;
        test.starttest();
        FSL_Utility.getCountryCode(cs.CountryName__c);
        FSL_Utility.getStateCode(cs.CountryName__c, cs.StateName__c);
        FSL_Utility.getCountryDesc(cs.CountryCode__c);
        FSL_Utility.getStateDesc(cs.CountryCode__c, cs.StateCode__c);
        test.stoptest();
    }
    
}