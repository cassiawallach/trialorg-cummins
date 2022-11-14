/************************************************************
Name:  OSM_SW_TaxExemptionContactCtrl_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for OSM_SW_TaxExemptionContactCtrl class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Rupesh Ranjan     23/04/2020        INITIAL DEVELOPMENT          
*****************************************************/

    @isTest
    global class OSM_SW_TaxExemptionContactCtrl_Test{
       public static testmethod void testTaxExemptionContactCtrl() {
        //Create account
      
           
           Account testaccount = new Account();
                testAccount.Name='Test Account' ;
                testAccount.BOLT_Account_Number__c='1345' ;
                testAccount.IAM_Service_Provider_Code__c='Test Account' ;
                testAccount.BMS_Customer_ID__c='3456' ;
                testAccount.BMS_Customer_ID_Junction__c ='34567' ;      
                insert testAccount;
    
          
           test.startTest();
           PageReference myVfPage = Page.OSM_SW_TaxExemptionContactForm;
           Test.setCurrentPage(myVfPage);
              
           ApexPages.currentPage().getParameters().put('effacid',testAccount.Id);
           

           OSM_SW_TaxExemptionContactCtrl ctrl = new OSM_SW_TaxExemptionContactCtrl();
          //System.assertNotEquals(null,testAccount.id);
            //ctrl.Accountid = testAccount.id;
            ctrl.downloadcontactform();           
           List<SelectOption> options = ctrl.getstates();
           //String myGeneratedFileName = 'Tax Exemption ContactForm.pdf';
            //PageReference pageRef =  Page.Tax Exemption ContactForm;
            //Test.setCurrentPage(pageRef);
            //ApexPages.currentPage().getParameters().put('accountid', 'testAccount.id');

            String aString=ctrl.renderedContentType;
            ctrl.saveToPdf();
            test.stopTest();
       
       System.assertEquals(null, ctrl.renderedFileName);
     //  System.assertEquals(null, ctrl.CustomerNumber);
     //  System.assertEquals(null, ctrl.CustomerName);
       System.assertEquals(null, ctrl.primaryfirstname);
       System.assertEquals(null, ctrl.secondaryfirstname);
       System.assertEquals(null, ctrl.primarylastname);
       System.assertEquals(null, ctrl.secondarylastname);
       System.assertEquals(null, ctrl.primarycity);
       System.assertEquals(null, ctrl.secondarycity);
       System.assertEquals(null, ctrl.primarycountry);
       System.assertEquals(null, ctrl.secondarycountry);
       System.assertEquals(null, ctrl.primaryemail);
       System.assertEquals(null, ctrl.secondaryemail);
       System.assertEquals(null, ctrl.primaryaddress1);
       System.assertEquals(null, ctrl.secondaryaddress1);
       System.assertEquals(null, ctrl.primaryzip);
       System.assertEquals(null, ctrl.secondaryzip);
       System.assertEquals(null, ctrl.primaryphone);
       System.assertEquals(null, ctrl.primaryaddress2);
       System.assertEquals(null, ctrl.secondaryaddress2);
       System.assertEquals(null, ctrl.secondaryphone);
       System.assertEquals(null, ctrl.primarystate);
       System.assertEquals(null, ctrl.secondarystate);
       
   }
       
}