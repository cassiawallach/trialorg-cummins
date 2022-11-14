/**********************************************************************
Name: CG_CL_Invoice_Test
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:  
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                  DATE                DETAIL                                 
1.0      Rajesh Pasupuleti       07/03/2018          INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest
public class CG_CL_Invoice_Test {
    //Method for positive scenario     
   /* public static testMethod void CG_CL_Invoice_Method(){
        CSS_Job_Order__c JobRef = CSS_TestData.createJobOrder(true);
        System.AssertNotEquals(null,JobRef);
        ApexPages.currentPage().getParameters().put('id', JobRef.id);
        Test.startTest();
             CG_CL_Invoice Invoice = new CG_CL_Invoice();
                Invoice.loadInputData();
                Invoice.css_redirect();
        Test.stopTest();
    }
    //Method for Nagitive scenario 
    public static testMethod void CG_CL_Invoice_Method1(){
        Test.startTest();
             CG_CL_Invoice Invoice = new CG_CL_Invoice();
                Invoice.loadInputData();
                Invoice.css_redirect();
        Test.stopTest();
    }*/
    public static testMethod void CG_CL_Invoice_Method3(){
              CG_CL_Invoice Invoice = new CG_CL_Invoice();                           
    }
}