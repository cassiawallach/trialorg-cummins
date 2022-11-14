@IsTest(SeeAllData=true)
// @IsTest corrected on 09/13/2016 as part of 09/10/2016 PROD Push
private class CSS_serviceJobRecentVisit_Test {
    static Testmethod void CSS_serviceJobRecentVisit_Method(){  
        
        Test.setMock(HttpCalloutMock.class, new CSS_RPVMockSecond_Test()); 
        Test.setMock(HttpCalloutMock.class, new CSS_ESNHistory_Test()); 
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
        //  Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator_Test());
        //May ** covering the insertDEParent method (on change of customer name method is covered on the update operation )
         test.startTest();
            User u = CSS_TestData.createTestUser(false);
            u.Username = 'cummins222@cummins.com';
            u.User_Location__c = '1111-2222';
            insert u;
            
            User u1 =  CSS_TestData.createTestUser(false);
            u1.Username = 'cumminsu1@cummins.com';
            insert u1;
        test.stopTest();
        CSS_Job_Order__c SerRec =  new CSS_Job_Order__c();
        system.runAs(u1){
             Account acc = CSS_TestData.createAccountObj(false);
            acc.Data_Exchange_Enabled__c = true;
            insert acc;
             Group Q = new Group();
            Q.Type = 'Queue';
            //Q.OwnerId=objUser1.id;
            Q.Name = 'JQ'+'-'+'03520-04892';
                insert Q;
            QueueSObject q1 = new QueueSObject(SobjectType='CSS_Job_Order__c', QueueId=Q.Id);
			insert q1;            
        
            Date d = Date.Today();
            SerRec.DSID__c='12345';
            SerRec.DSID_Status__c='open';
            //SerRec.ESN__c ='79464647';
            SerRec.Customer_Name__c='ABC';
            SerRec.Failure_Date__c =d;
            SerRec.Failure_Point__c=2.2;
            SerRec.Unit_Number__c='1234';
            SerRec.Service_Model__c='ESN';
            SerRec.Make__c='test';
            SerRec.Model__c='test1';
            SerRec.VIN__c='1XKAD49X6CJ305490';
            SerRec.Customer_Name__c='Sam Torq';
            SerRec.Warranty_Start_Date__c=d;
            SerRec.Failure_Point_Measure__c = 'MI'; 
            SerRec.Application__c='Automotive'; 
            SerRec.ESN__c = '7946464';
            SerRec.Mileage__c = 12345;
            SerRec.Mileage_measure__c = 'Miles'; 
            SerRec.OwnerId = u1.id;
            SerRec.CSS_Job_Location_Code__c = '03520-04892';
            Insert SerRec;
             Map<Id,CSS_Job_Order__c> jOrd = new Map<Id,CSS_Job_Order__c>();
            jOrd.put(SerRec.id,SerRec);
            CSS_Job_Order__c cjb = [select id from CSS_Job_Order__c where id =:SerRec.id];
            cjb.ESN__c ='79586617';
            //cjb.Make__c='test123';
            update cjb;
            List<CSS_Job_Order__c> jobOrder = new List<CSS_Job_Order__c>();
            jobOrder.add(cjb);
            
            system.debug(SerRec); 
              CSS_DataExchange_Parent__c  parent = new CSS_DataExchange_Parent__c ();
           parent.DataExchange_Status__c='UnProcessed';
           parent.CSS_Job_Number__c =SerRec.name;
           
           insert parent;
            
            CSS_serviceJobRecentVisit recV= new CSS_serviceJobRecentVisit();
            recV.assignToSharing(jobOrder,jOrd);
            //recV.insertDEParent(jobOrder, jOrd);
        }
       
            system.runAs(u){
                SerRec.Customer_Name__c='test';
                update SerRec;
            }    
         
    }
    static Testmethod void CSS_serviceJobRecentVisit_Method2(){
        
        CSS_Job_Order__c SerRec =  new CSS_Job_Order__c();
        
        Date d = Date.Today();
        SerRec.DSID__c='12345';
        SerRec.DSID_Status__c='open';
        //SerRec.ESN__c ='79464647';
        SerRec.Customer_Name__c='ABC';
        SerRec.Failure_Date__c =d;
        SerRec.Failure_Point__c=2.2;
        SerRec.Unit_Number__c='1234';
        SerRec.Service_Model__c='ESN';
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.VIN__c='1XKAD49X6CJ305490';
        SerRec.Customer_Name__c='Sam Torq';
        SerRec.Warranty_Start_Date__c=d;
        SerRec.Failure_Point_Measure__c = 'MI'; 
        SerRec.Application__c='Automotive'; 
        SerRec.ESN__c = '00000000';
        SerRec.Mileage__c = 12345;
        SerRec.Mileage_measure__c = 'Miles'; 
        
        Insert SerRec;        
        Map<Id,CSS_Job_Order__c> jOrd = new Map<Id,CSS_Job_Order__c>();
        jOrd.put(SerRec.id,SerRec);
        CSS_Job_Order__c cjb = [select id from CSS_Job_Order__c where id =:SerRec.id];
        cjb.ESN__c =null;
        //cjb.Make__c='test123';
        update cjb;
         List<CSS_Job_Order__c> jobOrder = new List<CSS_Job_Order__c>();
        jobOrder.add(cjb);
        
        system.debug(SerRec); 
        
        CSS_serviceJobRecentVisit recV= new CSS_serviceJobRecentVisit();
        recV.assignToSharing(jobOrder,jOrd);
    }
        static Testmethod void CSS_serviceJobRecentVisit_Method3(){
        
        CSS_Job_Order__c SerRec =  new CSS_Job_Order__c();
        
        Date d = Date.Today();
        SerRec.DSID__c='12345';
        SerRec.DSID_Status__c='open';
        //SerRec.ESN__c ='79464647';
        SerRec.Customer_Name__c='ABC';
        SerRec.Failure_Date__c =d;
        SerRec.Failure_Point__c=2.2;
        SerRec.Unit_Number__c='1234';
        SerRec.Service_Model__c='ESN';
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.VIN__c='1XKAD49X6CJ305490';
        SerRec.Customer_Name__c='Sam Torq';
        SerRec.Warranty_Start_Date__c=d;
        SerRec.Failure_Point_Measure__c = 'MI'; 
        SerRec.Application__c='Automotive'; 
        SerRec.ESN__c = '00000000';
        SerRec.Mileage__c = 12345;
        SerRec.Mileage_measure__c = 'Miles'; 
        
        Insert SerRec;        
        Map<Id,CSS_Job_Order__c> jOrd = new Map<Id,CSS_Job_Order__c>();
        jOrd.put(SerRec.id,SerRec);
        CSS_Job_Order__c cjb = [select id from CSS_Job_Order__c where id =:SerRec.id];
        cjb.ESN__c ='0000000001';
        //cjb.Make__c='test123';
        update cjb;
         List<CSS_Job_Order__c> jobOrder = new List<CSS_Job_Order__c>();
        jobOrder.add(cjb);
        
        system.debug(SerRec); 
        
        CSS_serviceJobRecentVisit recV= new CSS_serviceJobRecentVisit();
        recV.assignToSharing(jobOrder,jOrd);
    }
    
    /*static Testmethod void insertDEParent(){
         Test.setMock(HttpCalloutMock.class, new CSS_UpdateDSID_Test());
         Test.setMock(HttpCalloutMock.class, new CSS_RPVMockSecond_Test()); 
         Test.setMock(HttpCalloutMock.class, new CSS_ESNHistory_Test()); 
         Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
         test.startTest();
            User u = CSS_TestData.createTestUser(false);
            u.Username = 'insertDEParent@cummins.com';
            u.User_Location__c = '1111-2222';
            insert u;
            
           User u1 =  CSS_TestData.createTestUser(false);
            u1.Username = 'insertDEParentu1111@cummins.com';
            insert u1;
            
        test.stopTest();
        CSS_Job_Order__c SerRec =  new CSS_Job_Order__c();
        system.runAs(u1){
            
            
             
        
            Date d = Date.Today();
            SerRec.DSID__c='12345';
            SerRec.DSID_Status__c='open';
            //SerRec.ESN__c ='79464647';
            SerRec.Customer_Name__c='ABC';
            SerRec.Failure_Date__c =d;
            SerRec.Failure_Point__c=2.2;
            SerRec.Unit_Number__c='1234';
            SerRec.Service_Model__c='ESN';
            SerRec.Make__c='test';
            SerRec.Model__c='test1';
            SerRec.VIN__c='1XKAD49X6CJ305490';
            SerRec.Customer_Name__c='Sam Torq';
            SerRec.Warranty_Start_Date__c=d;
            SerRec.Failure_Point_Measure__c = 'MI'; 
            SerRec.Application__c='Automotive'; 
            SerRec.ESN__c = '7946464';
            SerRec.Mileage__c = 12345;
            SerRec.Mileage_measure__c = 'Miles'; 
            
            Insert SerRec;
            
             Account acc = CSS_TestData.createAccountObj(false);
            acc.Data_Exchange_Enabled__c = true;
            insert acc;
        } 
        system.runAs(u){
                SerRec.Customer_Name__c='test';
                update SerRec;
            }    
    }*/
}