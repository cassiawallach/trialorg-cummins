@isTest(isParallel=true)
public class OSM_SW_cc_hk_UserInterface_Test {
     
     public static testMethod void createTestAccount()
     {
      OSM_SW_cc_hk_UserInterface uinterface=new  OSM_SW_cc_hk_UserInterface();
       uinterface.standardRespondJS();
     }   
}