@isTest
public class CSS_GetJobInfo_Test {
    

    Static String recordType_Id = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();  
    
    static testmethod void AccountMethod(){
        
         Id p = [select id from profile where name='CSS_Dealer_Data_ExChange_Admin'].id;
         
         Account A = new Account();
         A.Name = 'OEM-DTNA HQ';
         A.BillingCity = 'City';
         A.BillingStreet = 'Street';
         A.BillingCountry = 'Canada';
         A.Data_Exchange_Enabled__c = true;
         insert A;
          
        Contact con = new Contact(LastName ='testCon',firstname = 'testing', IAM_Cummins_login_ID__c = 'test@cummins.com', AccountId = A.Id);
        insert con;
        
                  
        User user = new User(alias = 'test123', email='test123@noemail.com',
                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                    ContactId = con.Id, timezonesidkey='America/Los_Angeles', username='iiiioooo@noemail.com');
        insert user;
        
        User U = [ SELECT id, accountid, ContactId, profileid, IsActive from user where username='iiiioooo@noemail.com'];
        system.debug('user'+U);
        
        system.runAs(User){
            
           Test.startTest(); 
            
            Account acc1 = new Account();
            Acc1.Name = 'test';
            acc1.css_de_parent__c = A.id;
            Acc1.BillingCity = 'City';
            Acc1.BillingStreet = 'Street';
            Acc1.BillingCountry = 'Canada';
            Acc1.BillingPostalCode = '90001';
            acc1.RecordTypeId=recordType_Id;
            acc1.IAM_Service_Provider_Code__c = '56255';
            acc1.CSS_DistributorCode__c = '56270';
            acc1.CSS_DBCode__c = '56255';
            acc1.Data_Exchange_Enabled__c = true;
            acc1.Customer_Data_Send_to_CSS__c = true;
            acc1.Vehicle_Unit_Data_Send_to_CSS__c = true;
            acc1.Vehicle_Unit_Data_Receive_from_CSS__c = true;
            acc1.ESN_Service_History_Send_to_CSS__c = true;
            acc1.Customer_Data_Receive_from_CSS__c = true;
            acc1.Solution_Data_Receive_from_CSS__c = true;
            acc1.Repair_Data_Receive_from_CSS__c = true;
            acc1.Fault_Code_Data_Receive_from_CSS__c = true;
            insert acc1;
            System.debug('acc1------->'+acc1); 
             
            list<account> acctlist1=[select id,name,css_de_parent__c,Location__c from account];
            system.debug('acctlist1>>'+acctlist1);
            
            Contact con1 = new Contact(LastName ='testCon',AccountId = acc1.Id);
            insert con1;
            
            CSS_Job_Order__c SerRec = new CSS_Job_Order__c();
            SerRec.Shop_Work_Order__c = 'WO12345';
            Date d = Date.Today();
            SerRec.DSID__c='12345';
            SerRec.DSID_Status__c='open';
            SerRec.ESN__c ='79464646';
            SerRec.Customer_Name__c='Oliver';
            SerRec.Failure_Date__c =d;
            SerRec.Warranty_Start_Date__c=d;
            SerREc.CSS_Job_Location_Code__c = '56270-56255';
            insert SerRec;
    
            list<CSS_Job_Order__c> SerRec1 = [select id, name,Creator_Location__c from CSS_Job_Order__c 
                                              where Customer_Name__c = 'Oliver'];
            system.debug('SerRec1'+SerRec1);
            
            CSS_DataExchange_Parent__c  DataParent = new CSS_DataExchange_Parent__c();
            DataParent.CSS_Job_Number__c = SerRec1[0].Name;
            DataParent.Failure_Point__c =5.9;
            DataParent.Customer_Name__c='testAs';
            DataParent.CustomerID__c='123';
            DataParent.Hours__c=2;
            DataParent.ESN__c='testTs'; 
            DataParent.Unit_Number__c='testRa';
            DataParent.MAKE__c='testRe';
            DataParent.VIN__c='testWr';
            DataParent.Mileage_Measure__c='<Miles/KM>';
            DataParent.MODEL__c='testQr';
            DataParent.Application__c='Automotive';
            DataParent.Address__c='testSh';
            DataParent.SERVICEMODELNAME__c='testRa';
            DataParent.Contact_Name__c='testJe';
            DataParent.City__c='COLUMBUS';
            DataParent.State__c='IN';
            DataParent.Country__c='AP';
            DataParent.DataExchange_Status__c='UnProcessed';
            insert DataParent;
            
            list<CSS_DataExchange_Parent__c> DP1 = [select id, CSS_Job_Number__c,DataExchange_Status__c from CSS_DataExchange_Parent__c 
                                              where Customer_Name__c = 'testAs'];
            system.debug('DP1'+DP1); 
        
            list<CSS_DataExchange_Child__c> DEChildList = new list<CSS_DataExchange_Child__c>();
            CSS_DataExchange_Child__c chilRec1= new CSS_DataExchange_Child__c();
            chilRec1.DataExchangeChild_Status__c='UnProcessed';
            chilRec1.CSS_DataExchange_Parent__c = DataParent.id;
            chilRec1.DataExchangeChildType__c='RepairData';        
            chilRec1.Selected_Component__c='{"ComponentID":"F20000","ComponentName":"PressureSensor","Action":"Repaired"}';
            chilRec1.Repair_Symptom__c='123';
            chilRec1.Repair_Fault_Code__c='123';
            chilRec1.Repair_Related_Fault_Code__c='123456';
            DEChildList.add(chilRec1);
            
            CSS_DataExchange_Child__c chilRec2= new CSS_DataExchange_Child__c();
            chilRec2.DataExchangeChild_Status__c='UnProcessed';
            chilRec2.CSS_DataExchange_Parent__c = DataParent.id;
            chilRec2.DataExchangeChildType__c='FaultCode';        
            chilRec2.Selected_Component__c='{"ComponentID":"F20000","ComponentName":"PressureSensor","Action":"Repaired"}';
            chilRec2.Repair_Symptom__c='123';
            chilRec2.Repair_Fault_Code__c='123';
            chilRec2.Repair_Related_Fault_Code__c='123456';
            DEChildList.add(chilRec2);
            
            CSS_DataExchange_Child__c chilRec3= new CSS_DataExchange_Child__c();
            chilRec3.DataExchangeChild_Status__c='UnProcessed';
            chilRec3.CSS_DataExchange_Parent__c = DataParent.id;
            chilRec3.DataExchangeChildType__c='SolutionData';        
            chilRec3.Selected_Component__c='{"ComponentID":"F20000","ComponentName":"PressureSensor","Action":"Repaired"}';
            chilRec3.Repair_Symptom__c='123';
            chilRec3.Repair_Fault_Code__c='123';
            chilRec3.Repair_Related_Fault_Code__c='123456';
            DEChildList.add(chilRec3);
            insert DEChildList;
                                    
            
            
        CSS_GetJobInfo.WrapperInput wrap=new CSS_GetJobInfo.WrapperInput();
        CSS_GetJobInfo.ComponentWrapper comp=new CSS_GetJobInfo.ComponentWrapper();
            
        
            RestRequest request = new RestRequest();
            request.addHeader('Content-Type', 'application/json');
            request.requestUri ='https://cumminscss--cssbrkfx.cs54.my.salesforce.com/services/apexrest/GetJobInfo/';
            request.httpMethod = 'POST'; 
            
            string requestRes1 =  '{'+
                ' "Header": {'+       
                ' "ServiceName":"GetJobInfo",'+
                ' "ServiceVersion":"1.0", '+
                ' "ToolID":"<Name of Dealer System>" ,'+
                ' "SPCode":"56255" ,'+
                ' "SenderID":"<User Id / System User>",'+
                ' "TargetID":"CSS" '+        
                '  },'+                  
                ' "DataArea":{'+         
                ' "CSSJobID":"'+SerRec1[0].Name+'",'+
                ' "ShopWO":"WO12345" '+
                '}'+
                ' }';   
                
            request.requestBody = Blob.valueOf(requestRes1);
            RestContext.request = request;
            CSS_GetJobInfoResWrapper getJobW=CSS_GetJobInfo.GetJobInfomration(); 
          
            string requestRes2 =  '{'+
                ' "Header": {'+       
                '  "ServiceName_Test":"GetJobInfo",'+
                '  "ServiceVersion":"1.0", '+
                '  "ToolID":"<Name of Dealer System>" ,'+
                '  "SPCode":"56255" ,'+
                '  "SenderID":"<User Id / System User>",'+
                '  "TargetID":"CSS" '+        
                '  },'+                  
                '  "DataArea":{'+         
                '  "CSSJobID":"'+SerRec1[0].Name+'",'+
                '  "ShopWO":"1234" '+
                '}'+
                ' }';      
            request.requestBody = Blob.valueOf(requestRes2);
            RestContext.request = request;                
            CSS_GetJobInfoResWrapper getJobW1=CSS_GetJobInfo.GetJobInfomration();
            
            
            string requestRes3 =  '{'+
                ' "Header": {'+       
                '  "ServiceName":"GetJobInfo_Test",'+
                '  "ServiceVersion":"1.0", '+
                '  "ToolID":"<Name of Dealer System>" ,'+
                '  "SPCode":"56255" ,'+
                '  "SenderID":"<User Id / System User>",'+
                '  "TargetID":"CSS" '+        
                '  },'+                  
                '  "DataArea":{'+         
                '  "CSSJobID":"'+SerRec1[0].Name+'",'+
                '  "ShopWO":"1234" '+
                '}'+
                ' }';      
            request.requestBody = Blob.valueOf(requestRes3);
            RestContext.request = request;
            CSS_GetJobInfoResWrapper getJobW2=CSS_GetJobInfo.GetJobInfomration();
           
            
            string requestRes4 =  '{'+
                ' "Header": {'+       
                '  "ServiceName":"GetJobInfo",'+
                '  "ServiceVersion":"1.0", '+
                '  "ToolID":"" ,'+
                '  "SPCode":"56255" ,'+
                '  "SenderID":"<User Id / System User>",'+
                '  "TargetID":"CSS" '+        
                '  },'+                  
                '  "DataArea":{'+         
                '  "CSSJobID":"'+SerRec1[0].Name+'",'+
                '  "ShopWO":"123" '+
                '}'+
                ' }';      
            request.requestBody = Blob.valueOf(requestRes4);
            RestContext.request = request;
            CSS_GetJobInfoResWrapper getJobW3=CSS_GetJobInfo.GetJobInfomration();
           
            
            string requestRes5 =  '{'+
                ' "Header": {'+       
                '  "ServiceName":"GetJobInfo",'+
                '  "ServiceVersion":"1.0", '+
                '  "ToolID":"<Name of Dealer System>" ,'+
                '  "SPCode":"56255" ,'+
                '  "SenderID":"<User Id / System User>",'+
                '  "TargetID":"CSS" '+        
                '  },'+                  
                '  "DataArea":{'+         
                '  "CSSJobID":"'+SerRec1[0].Name+'",'+
                '  "ShopWO":"123" '+
                '}'+
                ' }';      
            request.requestBody = Blob.valueOf(requestRes5);
            RestContext.request = request;
            CSS_GetJobInfoResWrapper getJobW4=CSS_GetJobInfo.GetJobInfomration();
          
        
            string requestRes6 =  '{'+
                ' "Header": {'+       
                '  "ServiceName":"GetJobInfo",'+
                '  "ServiceVersion":"1.0", '+
                '  "ToolID":"<Name of Dealer System>" ,'+
                '  "SPCode":"56255" ,'+
                '  "SenderID":"<User Id / System User>",'+
                '  "TargetID":"CSS" '+        
                '  },'+                  
                '  "DataArea":{'+         
                '  "CSSJobID":"'+SerRec1[0].Name+'",'+
                '  "ShopWO":"'+SerRec.Shop_Work_Order__c+'" '+
                '}'+
                ' }';      
            request.requestBody = Blob.valueOf(requestRes6);
            RestContext.request = request;
            CSS_GetJobInfoResWrapper getJobW5=CSS_GetJobInfo.GetJobInfomration();
          
            Test.stopTest(); 
            
        }
      }
}