@isTest
public class dbu_CustomsettingCntrl_Test {
    
	static testMethod void testupdateLocationCustomSetting() {  
        Test.startTest();   
         dbu_CustomsettingCntrl.getStatesData();
         dbu_CustomsettingCntrl.getHomePageBannersData();//CHG0078302
        Test.stopTest();  
    }
}