@isTest
public class CG_CL_ClaimHistory_Test {
    
    static testmethod void method1(){
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79464646';
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
        jobEventRef.key__c='79464646'+':'+cl.id;
        jobEventRef.type__c='ClaimHistory';
     	jobEventRef.Attribute9__c = 'Paid';
        insert jobEventRef;
        jobEventlstRef.add(jobEventRef);
        string sfailureDate =jobEventRef.Attribute1__c;
        String sfailDateLocale =' ';
        CG_CL_ClaimHistory.ClaimID = cl.id ;
        CG_CL_ClaimHistory.ClaimESN = '79464646' ;
        
        CG_CL_ClaimHistory hist = new CG_CL_ClaimHistory();
       CG_CL_ClaimHistory.ClaimHistoryWrapper chw=new CG_CL_ClaimHistory.ClaimHistoryWrapper();
        CG_CL_ClaimHistory.getRecentClaimHistory();
       
      
              
        
    }
  
}