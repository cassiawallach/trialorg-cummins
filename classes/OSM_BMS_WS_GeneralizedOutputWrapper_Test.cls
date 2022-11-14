/************************************************************
Name:  OSM_BMS_WS_GeneralizedOutputWrapper_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for OSM_BMS_WS_GeneralizedOutputWrapper class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Rupesh Ranjan     24/06/2020        INITIAL DEVELOPMENT  
2.0 -    Sangeeta Rani     01/03/2021        Updated
*****************************************************/
@isTest
    private class OSM_BMS_WS_GeneralizedOutputWrapper_Test{
    
    private static testMethod void test() {
    OSM_BMS_WS_GeneralizedOutputWrapper.DataArea wrapper= new OSM_BMS_WS_GeneralizedOutputWrapper.DataArea();
       wrapper.CustomerCode= '123';
       wrapper.LocationAddressline3= '200';
       wrapper.PhoneNumber= 'test';
       wrapper.Country= 'test1';
       wrapper.CustomerName= 'fasf';
       wrapper.City= 'dfh';
      wrapper.AreaCode= '456';
       wrapper.LocationAddressline2= 'test1';
       wrapper.LocationAddressline1= 'fasf';
       wrapper.PaymentType= '15 june';
       wrapper.State= 'test1';
       wrapper.Postalcode2= 'fasf';
       wrapper.Postalcode1= '15 june'; 
       wrapper.CreditLimit= 1.0;
       wrapper.QuoteCustomer= 'trhge';   
       wrapper.RequirePO= 'fasf';
       wrapper.AmountDue= 1.8;    
       wrapper.AvailableCredit= 2.0; 

        
       OSM_BMS_WS_GeneralizedOutputWrapper.Header wrapper1= new OSM_BMS_WS_GeneralizedOutputWrapper.Header();
       wrapper1.Status= '123';
      // wrapper1.Sender= 'test';
      // wrapper1.Target= 1234;
       //wrapper1.Location= 2;

       GOMS_IP_Wrapper.InvoiceHeaderNotes wrapper2= new GOMS_IP_Wrapper.InvoiceHeaderNotes();
       wrapper2.transactionID = '123';
       wrapper2.shipToAbbreviation = 'test';
       wrapper2.transactionLineNumber = 1234;
       wrapper2.noteNumber = 2;
       wrapper2.noteText = 'xyz';
       wrapper2.createdBu = 'test';
       wrapper2.updatedBy = 'test1';
       wrapper2.createDate = '15 june';
       wrapper2.recordDate = '15 june';
       
       OSM_BMS_WS_GeneralizedOutputWrapper.Location wrapper3= new OSM_BMS_WS_GeneralizedOutputWrapper.Location();
       wrapper3.LocationID= '123';
       
       OSM_BMS_WS_GeneralizedOutputWrapper.Sender wrapper4= new OSM_BMS_WS_GeneralizedOutputWrapper.Sender();
       wrapper4.ServiceName= '123';
       wrapper4.SenderID= '123';
       
       OSM_BMS_WS_GeneralizedOutputWrapper.Target  wrapper5= new OSM_BMS_WS_GeneralizedOutputWrapper.Target();
       wrapper5.TargetID= '123';
       CSS_Integration_Details__c objCID = new CSS_Integration_Details__c(AuthEnv__c = 'BMS',
                                                                           IsActive__c = true,
                                                                           Timeout__c = 120000,
                                                                           Method_Type__c = 'POST',
                                                                           ApplicationName__c = 'BMS',
                                                                           Name = 'BMSCustomerLookupService',
                                                                           End_Point__c = 'https://services-stg.cummins.com/cso/bmscustomer');
        
       Test.startTest();
       insert objCID;
    OSM_BMS_WS_GeneralizedOutputWrapper objWarp = new OSM_BMS_WS_GeneralizedOutputWrapper();
    Test.stopTest();
    System.assertEquals(null, objWarp.errorMsg);
    System.assertEquals(null, objWarp.DataArea);
    System.assertEquals(null, objWarp.Header);
    System.assertEquals(null, objWarp.errorFlag);
    System.assertEquals(null, objWarp.log);
       
    }
    
  	static testMethod void compareTo() {
        OSM_BMS_WS_GeneralizedOutputWrapper.DataArea wrapper= new OSM_BMS_WS_GeneralizedOutputWrapper.DataArea();
        wrapper.CustomerCode= '123';
        wrapper.LocationAddressline3= '200';
        wrapper.PhoneNumber= 'test';
        wrapper.Country= 'test1';
        wrapper.CustomerName= 'fasf';
        wrapper.City= 'dfh';
      	wrapper.AreaCode= '456';
       	wrapper.LocationAddressline2= 'test1';
        wrapper.LocationAddressline1= 'fasf';
        wrapper.PaymentType= '15 june';
        wrapper.State= 'test1';
        wrapper.Postalcode2= 'fasf';
        wrapper.Postalcode1= '15 june'; 
        wrapper.CreditLimit= 1.0;
        wrapper.QuoteCustomer= 'trhge';   
        wrapper.RequirePO= 'fasf';
        wrapper.AmountDue= 1.8;    
        wrapper.AvailableCredit= 2.0; 
        
        OSM_BMS_WS_GeneralizedOutputWrapper.DataArea wrapper1= new OSM_BMS_WS_GeneralizedOutputWrapper.DataArea();
        wrapper1.CustomerCode= '123';
        wrapper1.LocationAddressline3= '200';
        wrapper1.PhoneNumber= 'test';
        wrapper1.Country= 'test1';
        wrapper1.CustomerName= 'Yusuf';
        wrapper1.City= 'dfh';
      	wrapper1.AreaCode= '456';
       	wrapper1.LocationAddressline2= 'test1';
        wrapper1.LocationAddressline1= 'fasf';
        wrapper1.PaymentType= '15 june';
        wrapper1.State= 'test1';
        wrapper1.Postalcode2= 'fasf';
        wrapper1.Postalcode1= '15 june'; 
        wrapper1.CreditLimit= 1.0;
        wrapper1.QuoteCustomer= 'trhge';   
        wrapper1.RequirePO= 'fasf';
        wrapper1.AmountDue= 1.8;    
        wrapper1.AvailableCredit= 2.0; 
        wrapper1.IAMCustomerCode='123';
        
       	System.debug(wrapper.compareTo(wrapper1));
    }
  
  }