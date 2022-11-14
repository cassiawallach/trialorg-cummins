/**********************************************************************
Name: FSLAddCustPartsCls_Test
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose: These is used for the Unit Test classes                                                      
-------  
======================================================
=========================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      03/20/2019      INITIAL DEVELOPMENT                    
***********************************************************************/
//deploying for cvrg with no changes
//Test Class execution comment added by mallika as part of cps-102:10/29
 //deploying for cvrg with no changes
 //Comment added for deployment - Jan 22 Release
 ////Comment added for deployment - Sep 22 Release
@isTest
    public class FSLAddCustPartsCls_Test {
    static testMethod void testlogic1()
    {
        Test.startTest();
        FSLAddCustPartsCls.getRepairReasonLOVs();
        Account a = FSLTestDataSetupCls.createAccountData();
        Asset ast=FSLTestDataSetupCls.createAssetRecord();
        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a, st);	
        list<FSL_Custom_Part__c> csp = new List<FSL_Custom_Part__c>();
        csp.add(new FSL_Custom_Part__c(Quantity__c=1,Name='testpart1',Part_Number__c='testsn1')); 
        csp.add(new FSL_Custom_Part__c(Quantity__c=1,Name='testpart12',Part_Number__c='testsn12')); 
        
        FSLAddCustPartsCls.saveParts(csp,wo.id);
        FSLAddCustPartsCls.getCSSParts(wo.id);
        FSLAddCustPartsCls.fetchcustompart('Name',true,wo.id);
        FSLAddCustPartsCls.deleteCSSParts(csp);
        
        Test.stopTest();
        //Test
    }
    //Adding a comment for deployment --- Sriprada    
    static testMethod void getPartName() {
        FSLAddCustPartsCls.getPartName('krishna');
    }
        
        static testMethod void getProfileInfo() {
        FSLAddCustPartsCls.getProfileInfo();
    }
}