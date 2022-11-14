@isTest
public class CG_CL_ClaimHistoryPageController_Test {
    
    static testmethod void method1(){
        test.startTest();
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'SiebelClaimHistory';
        cid.ApplicationName__c = 'SiebelClaimHistory';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/claimhistory';
        cid.Method_Type__c  = 'POST';
        cid.AuthEnv__c  = 'OAGOAuth';
        cid.Timeout__c = 12000;
        insert cid;
        Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test3());
        
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79393939';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        insert jo;
        lstjo.add(jo);

        CSS_Claims__c cl = new CSS_Claims__c();
        // cl.CSS_Job__c = CSS_TestData.createJobOrder(true).id;
        cl.CSS_Job__c=jo.id;
        
        insert cl;
        
        //datetime datetimetest = System.now().addDays(31);
       
        list<CSS_JobEventTemporary__c> jobEventlstRef = new list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobEventRef = CSS_TestData.createJobEventTempObj(false);
        jobEventRef.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobEventRef.Attribute2__c='test2';
        jobEventRef.Attribute3__c='test3';
        jobEventRef.Attribute4__c='1.0';
        jobEventRef.Attribute5__c='test5';
        jobEventRef.Attribute6__c='test6';
        jobEventRef.Attribute7__c='test7';
        jobEventRef.Attribute8__c='test9';
        //jobEventRef.Attribute9__c='test10';
        jobEventRef.Attribute10__c='test11';
        jobEventRef.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobEventRef.Attribute12__c='test13';
        date d =  Date.today();
        jobEventRef.Attribute13__c=d;
        jobEventRef.Attribute14__c='test15';
        jobEventRef.Attribute15__c='test8';
        jobEventRef.Reason__c='tEst';
        jobEventRef.key__c='79393939'+':'+cl.id;
        jobEventRef.type__c='ClaimHistory';
        jobEventRef.Attribute9__c = 'Paid';
        insert jobEventRef;
        jobEventlstRef.add(jobEventRef);
        string sfailureDate =jobEventRef.Attribute1__c;
        String sfailDateLocale =' ';
        //test.startTest();
        CG_CL_ClaimHistoryPageController.ClaimID = cl.id ;
        //CG_CL_ClaimHistoryPageController.ClaimESN = '79464646' ;
        CG_CL_ClaimHistoryPageController.NotesWrapper chw1=new CG_CL_ClaimHistoryPageController.NotesWrapper();
        CG_CL_ClaimHistoryPageController.NoteWiseNotesWrapper chw2=new CG_CL_ClaimHistoryPageController.NoteWiseNotesWrapper();
        CG_CL_ClaimHistoryPageController.ClaimHistoryWrapper chw=new CG_CL_ClaimHistoryPageController.ClaimHistoryWrapper();
        CG_CL_ClaimHistoryPageController hist = new CG_CL_ClaimHistoryPageController();
       CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        //Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test2());
        CG_CL_ClaimHistoryPageController.SearchClaimHistory('79393939');
        //CG_CL_ClaimHistoryPageController.SPClaimDetails(cl.name);
       
      
        Test.stoptest();      
        
    }
@isTest
    static  void method2(){
        test.startTest();
                Test.setMock(HttpCalloutMock.class, new CG_CL_GetClaimDetails_Mock());
        /*CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetClaimDetails';
        cid.ApplicationName__c = 'CSS_SBL_GetClaimDetails';
        cid.End_Point__c = 'https://services-dev.cummins.com/csswarranty/getsiebelclaimdetails/';
        cid.Method_Type__c  = 'POST';
        cid.AuthEnv__c  = 'OAGOAuth';
        cid.Timeout__c = 12000;
        insert cid;*/


        
        /*List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79393939';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        insert jo;
        lstjo.add(jo);*/

        /*CSS_Claims__c cl = new CSS_Claims__c();
        // cl.CSS_Job__c = CSS_TestData.createJobOrder(true).id;
        cl.CSS_Job__c=jo.id;
        
        insert cl;*/
        ///CSS_Claims__c claims = css_TestData.createclaims(true,jo.id);
        //datetime datetimetest = System.now().addDays(31);
       
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_CL_ClaimHistoryPageController hist = new CG_CL_ClaimHistoryPageController();
        CG_CL_ClaimHistoryPageController.SPClaimDetails('C0000190119');
        Test.stoptest();      
        
    }
  
}