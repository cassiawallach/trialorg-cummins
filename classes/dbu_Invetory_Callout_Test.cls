@isTest
public class dbu_Invetory_Callout_Test {
    @isTest public static void invCalloutTest(){
        dbu_Invetory_Callout calloutTest = new dbu_Invetory_Callout();
        
    }
    
    @isTest static void unitTest() {
        Test.setMock(HttpCalloutMock.class, new dbu_Invetory_CalloutMock());
        dbu_Invetory_Callout.getInventory('123456', 'US');
        Test.setMock(HttpCalloutMock.class, new dbu_Invetory_CalloutMock1());
        dbu_Invetory_Callout.getInventory('123456', 'US');
    }
    
    static void unitTest1() {
        Test.setMock(HttpCalloutMock.class, new dbu_Invetory_CalloutMock1());
        dbu_Invetory_Callout.getInventory('123456', 'US');
    }
}