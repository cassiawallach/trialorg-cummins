@isTest(seealldata = false)
 
public class CG_CL_IntakeVHComp_Test {

   
    static testMethod void test(){
        CG_CL_IntakeVHcomp obj = new CG_CL_IntakeVHcomp();
        
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        Test.setMock(HttpCalloutMock.class, new CSS_RPVMockSecond_Test()); 
        Test.setMock(HttpCalloutMock.class, new CSS_ESNHistory_Test()); 
        
        string sCustomerName;
        string sCSSJobNum;
        string sShopsWorkOrder;
        string sServiceModel;    
        string sLocation;
        string sWorkSummary;
        string sFaultcodeSymp;
        Decimal sMileage;
        string sRecent_Visit;
        string sCreated_Time_Zone;
        string sCreated_Time_sort;
        string sMeter;
        Boolean sRepeat_Visit;
        Id sjobId;
        
        obj.ServiceHistList = 'Sample';
        CG_CL_IntakeVHcomp.strESN='79704393';
        CG_CL_IntakeVHcomp.dtCreated=System.now();
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced' LIMIT 1];
        Profile p2 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        User newUserA = new User(Alias = 'standtA', Email='test1A@gmail.com', UserRoleId = ur.Id ,
                                 EmailEncodingKey='UTF-8', LastName='TestingA', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p1.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test11AQnewUser@gmail.com');
        
        User newUser2A = new User(Alias = 'standt2A', Email='test2A@gmail.com', UserRoleId = ur.Id ,
                                  EmailEncodingKey='UTF-8', LastName='Testing2A', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p2.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='test12AQnewUser@gmail.com');
        insert newUser;                       
        insert newUser2A;
        
        CSS_Job_Order__c cjo = new CSS_Job_Order__c();
        CSS_Job_Order__c cjo2 = new CSS_Job_Order__c();
        CSS_Job_Order__c cj = new CSS_Job_Order__c();
        CSS_Job_Order__c cj2 = new CSS_Job_Order__c();
        
        CSS_JobEventTemporary__c je=new CSS_JobEventTemporary__c();
        CSS_JobEventTemporary__c je2=new CSS_JobEventTemporary__c();
        CSS_JobEventTemporary__c je3=new CSS_JobEventTemporary__c();
        List<CG_CL_IntakeVHcomp.ServiceHistWrap> sw = new List<CG_CL_IntakeVHcomp.ServiceHistWrap>();
        List<CG_CL_IntakeVHcomp.ServiceHistWrap2> sw2 = new List<CG_CL_IntakeVHcomp.ServiceHistWrap2>();
        
        
        System.runAs(newUser){
            cjo.Customer_Name__c = 'Wonder Trucks';
            CJO.Assigned_To__c=newUser.id;
            CJO.Additional_Tech1__c=newUser.id;
            CJO.Additional_Tech2__c=newUser.id;    
            cjo.Status__c='Closed';
            cjo.DSID__c='DSBDT2274';
            cjo.unit_number__c='12345';
            //    cjo.Service_Model_N__c=12345;
            cjo.Shop_Work_Order__c='abcd';
            // cjo.dField='Visible';
            cjo.ESN__c='79704393';
            cjo.DSID_UpdateTimestamp__c=System.now();
            cjo.INSITE_UpdateTimeStamp__c=System.now();
            cjo.Mileage__c=9.9;
            cjo.Service_Model__c='werwe';
            insert cjo;  
            
            cjo2.Customer_Name__c = 'Wonder Trucks 2';
            CJO2.Assigned_To__c=newUser.id;
            CJO2.Additional_Tech1__c=newUser.id;
            CJO2.Additional_Tech2__c=newUser.id;    
            cjo2.Status__c='Closed';
            cjo2.DSID__c='DSBDT2274';
            cjo2.unit_number__c='12345';
            //    cjo.Service_Model_N__c=12345;
            cjo2.Shop_Work_Order__c='abcd';
            // cjo.dField='Visible';
            cjo2.ESN__c='79704393';
            cjo2.DSID_UpdateTimestamp__c=System.now();
            cjo2.INSITE_UpdateTimeStamp__c=System.now();
            cjo2.createdDate=system.now().addDays(-29);
            cjo2.Mileage__c=9.9;
            cjo2.Service_Model__c='werwe2';
            
            insert cjo2;  
            
            je.key__c='79704393';
            je.Attribute1__c = 'Att1'; 
            je.Attribute2__c = 'Att2';
            je.Attribute3__c = 'Att3';
            je.Attribute4__c = 'Att4';
            je.Attribute5__c = 'Att5';
            je.Attribute6__c = 'Att6';
            je.Attribute7__c = 'Att7';
            je.Attribute8__c = 'Att8';
            je.Attribute9__c = 'MIHRKM';
            je.Attribute14__c = '9';
            je.Attribute13__c = system.now().addDays(-29);     
            
            insert je;
            
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym.Job_Order__c=cjo2.id;
            sym.caption__c ='white smoke';
            sym.Option1__c  ='12213';
            sym.Option_type__c  ='qwewqe';
            sym.Guide_Question__c  ='1asdsad2213';
            sym.Type__c  ='SearchString';
            sym.createdDate=system.now().addDays(-29);
            insert sym;
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol.Case_Name__c='test';
            sol.Diagnostic_Response__c='test';
            sol.Repair_Response__c='Repair Successful.';
            sol.Symptom__c=sym.id;
            sol.Service_Job__c=cjo2.id;
            sol.createdDate=system.now().addDays(-29);
            insert sol;
            CG_CL_IntakeVHcomp joe = new CG_CL_IntakeVHcomp();
            string csj = CG_CL_IntakeVHcomp.getRecentHistJobs();
            string getlst = CG_CL_IntakeVHcomp.getHistJobs();
            
            
        }
        
        System.runAs(newUser2A){
            cj.Customer_Name__c = 'Wonder Trucks2';
            CJ.Assigned_To__c=newUser2A.id;
            CJ.Additional_Tech1__c=newUser.id;
            CJ.Additional_Tech2__c=newUser.id;
            cj.DSID_UpdateTimestamp__c=System.now();
            cj.INSITE_UpdateTimeStamp__c=System.now();
            cj.ESN__c='79704393';
            cj.createdDate=system.now().addDays(-50);
            cj.Status__c='Closed';
            insert cj; 
            
            cj2.Customer_Name__c = 'Wonder Trucks2';
            CJ2.Assigned_To__c=newUser2A.id;
            CJ2.Additional_Tech1__c=newUser.id;
            CJ2.Additional_Tech2__c=newUser.id;
            cj2.DSID_UpdateTimestamp__c=System.now();
            cj2.INSITE_UpdateTimeStamp__c=System.now();
            cj2.ESN__c='79704393';
            cj2.createdDate=system.now().addDays(-60);
            cj2.Status__c='Closed';
            insert cj2; 
            
            je2.key__c='79704393';
            je2.Attribute1__c = 'Att1'; 
            je2.Attribute2__c = 'Att2';
            je2.Attribute3__c = 'Att3';
            je2.Attribute4__c = 'Att4';
            je2.Attribute5__c = 'Att5';
            je2.Attribute6__c = 'Att6';
            je2.Attribute7__c = 'Att6';
            je2.Attribute8__c = 'Att6';
            je2.Attribute13__c=system.now().addDays(-60);
            je2.Attribute9__c = 'HR';
            je2.Attribute14__c = '9';
            insert je2;
            
            je3.key__c='79704393';
            je3.Attribute1__c = 'Att1'; 
            je3.Attribute2__c = 'Att2';
            je3.Attribute3__c = 'Att3';
            je3.Attribute4__c = 'Att4';
            je3.Attribute5__c = 'Att5';
            je3.Attribute6__c = 'Att6';
            je3.Attribute7__c = 'Att7';
            je3.Attribute8__c = 'Att8';
            je3.Attribute13__c=system.now().addDays(-50);
            je3.Attribute9__c = 'KM';
            je3.Attribute14__c = '9';
            insert je3;
            
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym.Job_Order__c=cj.id;
            sym.caption__c ='white smoke';
            sym.Option1__c  ='12213';
            sym.Option_type__c  ='qwewqe';
            sym.Guide_Question__c  ='1asdsad2213';
            sym.Type__c  ='SearchString';
            sym.createdDate=system.now().addDays(-50);
            insert sym;
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol.Case_Name__c='test';
            sol.Diagnostic_Response__c='test';
            sol.Repair_Response__c='Repair Successful.';
            sol.Symptom__c=sym.id;
            sol.Service_Job__c=cj.id;
            sol.createdDate=system.now().addDays(-50);
            insert sol;            
            CG_CL_IntakeVHcomp joe1 = new CG_CL_IntakeVHcomp();           
            string csj1 = CG_CL_IntakeVHcomp.getRecentHistJobs();
            string getlst1 = CG_CL_IntakeVHcomp.getHistJobs();       
        }     
    }


}