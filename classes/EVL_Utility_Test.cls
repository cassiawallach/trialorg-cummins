@isTest
public class EVL_Utility_Test {
static testmethod  void testsetEligibilityForApplicationLogging(){
        test.starttest();
        boolean booltest = EVL_Utility.setEligibilityForApplicationLogging();
        test.stoptest();
    }
    
    
    static testmethod  void testsetEligibilityForApplicationLogging1(){
        test.starttest();
        String strUtil =  EVL_Utility.SetNow();
        test.stoptest();
    }
    
    static testmethod  void LogOutIntError(){
        test.starttest();
        EVL_Utility.LogOutIntError('test1','test2','test3','test4');
        test.stoptest();
    }
    
     static testmethod  void LogOutInbtError(){
        test.starttest();
        EVL_Utility.LogInbIntError('test1','test2','test3','test4');
        test.stoptest();
    }
    
     static testmethod  void userinfo(){
        test.starttest();
        EVL_Utility.UserInfo();
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
       // EVL_Utility.getCountryCode(cs.CountryName__c);
        //EVL_Utility.getStateCode(cs.CountryName__c, cs.StateName__c);
       // EVL_Utility.getCountryDesc(cs.CountryCode__c);
        //EVL_Utility.getStateDesc(cs.CountryCode__c, cs.StateCode__c);
        test.stoptest();
    }
    
    static testmethod void stateinfo(){
        EVL_PathSetting__mdt pf = new EVL_PathSetting__mdt();
         test.starttest();
        EVL_Utility.getStageValues(pf.isActive_For__c);
        test.stoptest();
    }
    
}