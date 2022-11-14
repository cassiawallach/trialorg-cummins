@isTest
public with sharing class OSM_ContactListAuraController_Test {
    static OSM_TestUtil util = new OSM_TestUtil();
    @TestSetup
    static void testSetup(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser){
            Map<String, Object> m = util.initData();
        } 
    }
 
    static testmethod void testOSM_ContactListAuraController(){
        Account curraccount = util.getAccount();
        List<Contact> result = OSM_ContactListAuraController.getPermContacts(curraccount.Id);
        System.debug('OSM_ContactListAuraController result: '+result);
    }
}