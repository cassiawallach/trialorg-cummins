/**********************************************************************
Name:CG_CL_ClaimsCustOneBMS_Test
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
this is test class for CG_CL_ClaimsCustOneBMS Controller.
===============================================================
===============================================================
History      

-------                                                            
VERSION    AUTHOR                 DATE                DETAIL                                 
1.0 -      Rajasekhar Hindupur/Kalpana Vemula     02/13/2018           INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest
public class CG_CL_ClaimsCustOneBMS_Test 
{
    public static Testmethod void CG_CL_ClaimsCustOneBMS_Method()
    { 
        
        test.startTest();
        String json = '{'+
'                \"DataArea\": ['+
'                {'+
'                                \"CustomerNumber\": \"5723046\",'+
'                                \"FirstName\": \"CA\",'+
'                                \"MI\": \"5723046\",'+
'                                \"LastName\": \"CA\",'+
'                                \"Salutation\": \"BRITESTONECOLONY\",'+
'                                \"Position\": \"CARBON\",'+
'                                \"LocationAddressline1\": \"BOX\",'+
'                                \"LocationAddressline2\": \"CARBONCOLONY\",'+
'                                \"LocationAddressline3\": \"CARBONCOLONY\",'+
'                                \"City\": \"403\",'+
'                                \"State\": \"CASH\",'+
'                                \"PostalCode\": \"AB\",'+
'                                \"PostalCodeSuffix\": \"\",'+
'                                \"Country\": \"US\",'+
'                                \"PhoneAreaCode\": \"667\",'+
'                                \"PhoneNumber\": \"278-6789\",'+
'                                \"Ext\": \"11\",'+
'                                \"FaxAreacode\": \"813\",'+
'                                \"FaxNumber\": \"2130897\",'+
'                                \"Email\": \"example@gmail.com\",'+
'                                \"Comments\": \"Testing\",'+
'                                \"ContactID\": \"213897\"'+
'                }],'+
''+
'                \"Header\": {'+
'                                \"ReturnCodeDescription\":\"Contact not Found\",'+
'                                \"Status\": \"ERROR\",'+
'                                \"Sender\": {'+
'                                                \"ServiceName\": \"GetCustomer\",'+
'                                                \"MessageID\":\"1234\", '+
'                                                \"SenderID\": \"BMS\"'+
'                                },'+
'                                \"Target\": {'+
'                                                \"TargetID\": \"CSS\"'+
'                                },'+
'                                \"Location\": {'+
'                                                \"LocationID\": \"56270-56255\"'+
'                                }'+
'                }'+
'}';
CSS_BMSContactLookupResponseJ2A obj = CSS_BMSContactLookupResponseJ2A.parse(json);
        system.debug('obj--->'+obj);

         
        CG_CL_ClaimsCustOneBMS claimsCustOneBMS = new CG_CL_ClaimsCustOneBMS();
        claimsCustOneBMS.dt_shopIn = system.now(); 
        claimsCustOneBMS.lastupdateSubStatus = system.now();
        //claimsCustOneBMS.customerCodeField = true;
        claimsCustOneBMS.selectedContactID = '213897';
      
        claimsCustOneBMS.selectedCustCode = '123';


        claimsCustOneBMS.strCntry = '';
        claimsCustOneBMS.strCntryState ='';
        claimsCustOneBMS.filterlocation='';
        claimsCustOneBMS.filterCountry='';
        claimsCustOneBMS.filterState='';
        claimsCustOneBMS.BMSCustSearchPopup=true;
        claimsCustOneBMS.BMSContactSearchPopup=true;
        claimsCustOneBMS.strBMSAccountMsg='';
        claimsCustOneBMS.bmsContacterrorMessage='';
        claimsCustOneBMS.selectedLocation='';
        claimsCustOneBMS.errorMessage='';
        claimsCustOneBMS.CustomerContactDetails = obj;
        claimsCustOneBMS.selectedContactDetails();
        
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Gopal';
        claims.Customer_Code__c='5723046';
        claims.ESN__c='58763453';
        claims.Customer_Phone__c='(123)-455678912';
        claims.Contact_First_Name__c='Raj';
        claims.Contact_Last_Name__c='';
        claims.Customer_Contact_Phone__c='(123)-455678912';
        claims.Address__c='Testing';
        claims.Claims_city__c='Testing';
        claims.State__c='Testing';
        claims.ZipCode__c='Testing';
        claims.Country__c='Testing';
        claims.Shop_Work_Order__c='Testing';
        insert claims;
            
        CG_CL_ClaimsIntake intake = new CG_CL_ClaimsIntake();
        intake.EmailAddress='';
        intake.EmailAddress1='';
        intake.claimsRec=claims;
        intake.filterApplication='Data Center Continuous';
      
       
        claimsCustOneBMS.mainContr = intake;
        
        String st1=claimsCustOneBMS.getDtShopIn();
        String st2=claimsCustOneBMS.getRepCom();
        /*string usrLoc ='';
        Test.isRunningTest();
        usrLoc =selectedLocation;*/
        CSS_customerOutboundJSON2Apex.DataArea d1=new CSS_customerOutboundJSON2Apex.DataArea();
        CSS_customerOutboundJSON2Apex.DataArea d2=new CSS_customerOutboundJSON2Apex.DataArea();
        
        List<CSS_customerOutboundJSON2Apex.DataArea> paginatedCustDetails=new List<CSS_customerOutboundJSON2Apex.DataArea>();
        
        paginatedCustDetails.add(d1);
        paginatedCustDetails.add(d2);
        
        CSS_CustomerInboundJSON2APEX cij1=new CSS_CustomerInboundJSON2APEX();
        claimsCustOneBMS.CustomerInboundRes=cij1;
        CSS_customerOutboundJSON2Apex co=new CSS_customerOutboundJSON2Apex();
        //claimsCustOneBMS.customerDetail=co;
        
        claimsCustOneBMS.contactshowOutageError=true;
        claimsCustOneBMS.showOutageError=true;
         CG_OP_OAGWrapper outputWrapper = CG_BL_Intake.fetchBMSCustomerDetails('mainContr.claimsRec.Customer_Name__c', 'mainContr.claimsRec.Customer_Code__c','03520-56255');
         
        
        claimsCustOneBMS.getCountry();
        claimsCustOneBMS.getStates();
        String s1= claimsCustOneBMS.getfilterState();
        claimsCustOneBMS.setfilterState('abc');
        claimsCustOneBMS.getfilterCountry();
        claimsCustOneBMS.setfilterCountry('Europe');
        List<SelectOption> so1= claimsCustOneBMS.getLocationsName();
        claimsCustOneBMS.selectedContactDetails();
        claimsCustOneBMS.ContactLookup();
        claimsCustOneBMS.resetBMSFields();
        String s2=claimsCustOneBMS.getLocationLabel(' ');
        claimsCustOneBMS.selectedCustDetails();
        claimsCustOneBMS.getBMSCustDetails();
        boolean b= claimsCustOneBMS.bmsCustInbound();
        claimsCustOneBMS.closeBMSContDetails();
        claimsCustOneBMS.closeBMSCustDetails();
        claimsCustOneBMS.selectedBMSCustCode();
        pagereference ref=claimsCustOneBMS.changeLocation();
        
        test.stoptest();
        
    }
    static testmethod void testmethod12()
    {
       user u = CSS_TestData.createTestUser(false);
        u.User_Location__c='56748-56478';
        u.Username='gopal.ra@cummins.com';
        insert u;
        system.runAs(u)
        {
        
        
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Gopal';
        claims.Contact_First_Name__c = 'test';
        claims.Contact_Last_Name__c = 'test'; 
        claims.Customer_Contact_Phone__c = '8524598875';
        claims.Contact_Id__c = '12';
        claims.Customer_Code__c='123';
        claims.ESN__c='58763453';
        insert claims;   
       
       CG_CL_ClaimsIntake intake = new CG_CL_ClaimsIntake();
         intake.EmailAddress='';
            intake.EmailAddress1='';
            intake.claimsRec=claims;
            intake.filterApplication='Data Center Continuous';   
        
            test.setMock(httpcalloutmock.class,new CSS_FN_BMS_Mock());
            test.startTest();
           
            CG_CL_ClaimsCustOneBMS bms = new CG_CL_ClaimsCustOneBMS();
            bms.mainContr = intake;
            bms.selectedContactID = null;
            
            bms.ContactLookup();
            
            CSS_customerOutboundJSON2Apex.DataArea custDt = new CSS_customerOutboundJSON2Apex.DataArea();
            
            CSS_customerOutboundJSON2Apex.DataArea custDt1 = new CSS_customerOutboundJSON2Apex.DataArea();
            
            List<CSS_customerOutboundJSON2Apex.DataArea> lstDt = new List<CSS_customerOutboundJSON2Apex.DataArea>();
            lstDt.add(custDt);
            lstDt.add(custDt1);
            bms.selectedCustCode='123';
            bms.paginatedCustDetails = lstDt;
            bms.selectedCustDetails();
            test.stopTest();
        }
    }
  static testmethod void testmethod13()
    {
        String json = '{'+
'                \"DataArea\": ['+
'                {'+
'                                \"CustomerNumber\": \"5723046\",'+
'                                \"FirstName\": \"\",'+
'                                \"MI\": \"5723046\",'+
'                                \"LastName\": \"CA\",'+
'                                \"Salutation\": \"BRITESTONECOLONY\",'+
'                                \"Position\": \"CARBON\",'+
'                                \"LocationAddressline1\": \"BOX\",'+
'                                \"LocationAddressline2\": \"CARBONCOLONY\",'+
'                                \"LocationAddressline3\": \"CARBONCOLONY\",'+
'                                \"City\": \"403\",'+
'                                \"State\": \"CASH\",'+
'                                \"PostalCode\": \"AB\",'+
'                                \"PostalCodeSuffix\": \"\",'+
'                                \"Country\": \"US\",'+
'                                \"PhoneAreaCode\": \"667\",'+
'                                \"PhoneNumber\": \"278-6789\",'+
'                                \"Ext\": \"11\",'+
'                                \"FaxAreacode\": \"813\",'+
'                                \"FaxNumber\": \"2130897\",'+
'                                \"Comments\": \"Testing\",'+
'                                \"ContactID\": \"213897\"'+
'                }],'+
''+
'                \"Header\": {'+
'                                \"ReturnCodeDescription\":\"Contact not Found\",'+
'                                \"Status\": \"ERROR\",'+
'                                \"Sender\": {'+
'                                                \"ServiceName\": \"GetCustomer\",'+
'                                                \"MessageID\":\"1234\", '+
'                                                \"SenderID\": \"BMS\"'+
'                                },'+
'                                \"Target\": {'+
'                                                \"TargetID\": \"CSS\"'+
'                                },'+
'                                \"Location\": {'+
'                                                \"LocationID\": \"56270-56255\"'+
'                                }'+
'                }'+
'}';
CSS_BMSContactLookupResponseJ2A obj = CSS_BMSContactLookupResponseJ2A.parse(json);
        system.debug('obj--->'+obj);
        
       user u = CSS_TestData.createTestUser(false);
        u.User_Location__c='56748-56478';
        u.Username='gopal.ra@cummins.com';
        insert u;
        system.runAs(u)
        {
        css_claims__c claims = new css_claims__c();
        claims.bmsCreateAccount__c  = true;
        claims.Customer_Name__c='Gopal';
        claims.Customer_Code__c='5723046';
        claims.ESN__c='58763453';
        claims.Customer_Phone__c='(123)-455678912';
        claims.Contact_First_Name__c='Raj';
        claims.Contact_Last_Name__c='';
        claims.Customer_Contact_Phone__c='(123)-455678912';
        claims.Address__c='Testing';
        claims.Claims_city__c='Testing';
        claims.State__c='Testing';
        claims.ZipCode__c='Testing';
        claims.Country__c='Testing';
        claims.Shop_Work_Order__c='Testing';
        insert claims;
            
            CG_CL_ClaimsIntake intake = new CG_CL_ClaimsIntake();
            intake.EmailAddress='';
            intake.EmailAddress1='';
           intake.claimsRec=claims;
            intake.filterApplication='Data Center Continuous';
            
            
            CSS_List_Of_Values__c lov = new CSS_List_Of_Values__c();
            lov.Code__c='DCC';
            lov.Type__c='Primary Segment';
            lov.Picklist_Values_1__c='Data Center Continuous';
           lov.name='Testing';
            insert lov;
        
            test.setMock(httpcalloutmock.class,new CSS_FN_BMS_Mock());
        test.startTest();
        CSS_customerOutboundJSON2Apex.DataArea d1=new CSS_customerOutboundJSON2Apex.DataArea();
         
        CSS_customerOutboundJSON2Apex.DataArea d2=new CSS_customerOutboundJSON2Apex.DataArea();
        
        List<CSS_customerOutboundJSON2Apex.DataArea> paginatedCustDetails=new List<CSS_customerOutboundJSON2Apex.DataArea>();
        
        paginatedCustDetails.add(d1);
        paginatedCustDetails.add(d2);
        
        CG_CL_ClaimsCustOneBMS bms = new CG_CL_ClaimsCustOneBMS();
           
            bms.ContactLookup();
            bms.mainContr=intake;
            bms.getBMSCustDetails();
            test.setMock(httpcalloutmock.class,new CSS_WS_OAGMOCK_createbms());
            BMS.bmsCustInbound();
            bms.resetBMSFields();
            bms.CustomerContactDetails = obj;
        bms.selectedContactDetails();
            bms.selectedCustDetails() ;
            
            
            test.stopTest();
        }
    }
     static testmethod void testmethod14()
    {
       user u = CSS_TestData.createTestUser(false);
        u.User_Location__c='56748-56478';
        u.Username='gopal.ra@cummins.com';
        insert u;
        system.runAs(u)
        {
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Gopal';
        claims.Customer_Code__c='123';
        claims.ESN__c='58763453';
        claims.Customer_Phone__c='(123)-455678912';
        claims.Contact_First_Name__c='Raj';
        claims.Contact_Last_Name__c='';
        claims.Customer_Contact_Phone__c='(123)-455678912';
        claims.Address__c='Testing';
        claims.Claims_city__c='Testing';
        claims.State__c='Testing';
        claims.ZipCode__c='Testing';
        claims.Country__c='Testing';
        claims.Shop_Work_Order__c='Testing';
        insert claims;
        
        CG_CL_ClaimsIntake intake = new CG_CL_ClaimsIntake();
        intake.EmailAddress='';
        intake.EmailAddress1='';
        intake.claimsRec=claims;
        intake.filterApplication='Data Center Continuous';
            
        CSS_List_Of_Values__c lov = new CSS_List_Of_Values__c();
        lov.Code__c='DCC';
        lov.Type__c='Primary Segment';
        lov.Picklist_Values_1__c='Data Center Continuous';
        lov.name='Testing';
        insert lov;
            
        test.setMock(httpcalloutmock.class,new CSS_WS_OAGMOCK_createbms());
        test.startTest();
        CG_CL_ClaimsCustOneBMS bms = new CG_CL_ClaimsCustOneBMS();
        bms.mainContr=intake;
        bms.getRepairLocation();
          bms.autoAdminSrt();
           
        BMS.bmsCustInbound();
           
           
            test.stopTest();
        }
    }
}