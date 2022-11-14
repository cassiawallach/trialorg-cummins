@IsTest
public class CSS_DataExchangeHelper_Test {
    static testMethod void testinsertDataExchange() {
     
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal21', Email='standarduser1111@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal1011@testorg.com', user_Location__c = '56280-56270');
        insert(u);
        System.runAs(u) {
              
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'Shanthitest';
            JO.Status__c = 'Intake';
            JO.Unit_Number__c = 'test1234';
            JO.Service_Model__c = 'ISBE CM800';
             JO.CustomerID__c= '123';
             JO.Contact_Name__c= 'shanthicontact';
             JO.Address__c= 'address';
             JO.City__c= 'bangalore';
             JO.ESN__c= '1234';  
             JO.Data_Exchange_Enabled__c=true;
                 
            insert jo;
            
            List<CSS_Fault_Code__c> lstfault = new List<CSS_Fault_Code__c>();
            CSS_Fault_Code__c fault = new CSS_Fault_Code__c();
            fault.Count__c=1;
            fault.Job_Order__c=jo.Id;
            fault.Primary_Fault_Code__c=2;
           fault.Related_Fault_Code__c='relates';
           lstfault.add(fault);
           insert lstfault;
           
           Test.startTest(); 
           CSS_DataExchangeHelper help = new CSS_DataExchangeHelper ();
           help.insertDataExchange(lstfault);
             Test.stopTest();
            }
    
    
    }
    
    
    
     static testMethod void testinsertDataExchangeSolution() {
     
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal21123', Email='standarduser11111234@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12234', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal1011234345@testorg.com', user_Location__c = '56280-56270');
        insert(u);
        System.runAs(u) {
            Map<Id,CSS_Solutions__c> oldMap = new Map<Id,CSS_Solutions__c> ();
            List<CSS_Job_Order__c> lstJO = new List<CSS_Job_Order__c>();
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'Shanthitest';
            JO.Status__c = 'Intake';
            JO.Unit_Number__c = 'test1234';
            JO.Service_Model__c = 'ISBE CM800';
             JO.CustomerID__c= '123';
             JO.Contact_Name__c= 'shanthicontact';
             JO.Address__c= 'address';
             JO.City__c= 'bangalore';
             JO.ESN__c= '1234';  
             JO.Data_Exchange_Enabled__c=true;
                 
            insert jo;
            lstJO.add(JO);
            System.debug('shanu jo'+jo);
            CSS_Job_Order__c cssjob = [select name from CSS_Job_Order__c where id=:JO.id];
          CSS_DataExchange_Parent__c  parent = new CSS_DataExchange_Parent__c ();
           parent.DataExchange_Status__c='UnProcessed';
           parent.CSS_Job_Number__c =cssjob.name;
           
           insert parent;
           System.debug('shanu parent'+parent);
           
           
            List<CSS_Solutions__c> lstsolexisting = new List<CSS_Solutions__c>();
            List<CSS_Solutions__c> lstsol = new List<CSS_Solutions__c>();
            CSS_Solutions__c sol = new CSS_Solutions__c();
            sol.Service_Job__c=jo.id;
            sol.Diagnostic_notes__c='test';
            sol.Repair_Notes__c='test';
           insert sol;
           
           CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c ();
           solcomp.Solutions__c =sol.id;
           solcomp.Action__c='Repair';
           solcomp.Component_Id__c='ids';
           solcomp.name='name';
           insert solcomp;
           System.debug('shanu solutioncomp'+solcomp);
           
            System.debug('shanu sol'+sol);
           CSS_DataExchange_Child__c child = new CSS_DataExchange_Child__c();
           child.Solution_ID__c=sol.id;
           child.DataExchangeChild_Status__c='UnProcessed';
           child.CSS_DataExchange_Parent__c=parent.id;
           insert child;
           
           lstsolexisting.add(sol);
           sol.Diagnostic_notes__c='daig';
           sol.Repair_Notes__c='repair';
           sol.Id=sol.Id;
           update sol;
           
           
           lstsol.add(sol);
           
           for(CSS_Solutions__c css: lstsol ){
           
           oldMap.put(css.id,css);
           }
           System.debug('shanu oldMap'+oldMap);

           
          
           
           Test.startTest(); 
           CSS_DataExchangeHelper help1 = new CSS_DataExchangeHelper ();
           help1.insertDataExchangeSolution(lstsolexisting,oldMap);
           system.debug('shanu'+lstsolexisting);
            system.debug('shanu solcomp'+solcomp);
             Test.stopTest();
            }
    
    
    }
    
     static testMethod void testinsertDEParent() {
     
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal21', Email='standarduser1111@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal1011@testorg.com', user_Location__c = '56280-56270');
        insert(u);
        System.runAs(u) {
             Map<Id,CSS_Job_Order__c> oldMap =new Map<Id,CSS_Job_Order__c>();
           List<CSS_Job_Order__c> lstJO = new List<CSS_Job_Order__c>();
           CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'Shanthitest';
            JO.Status__c = 'Intake';
            JO.Unit_Number__c = 'test1234';
            JO.Service_Model__c = 'ISBE CM800';
             JO.CustomerID__c= '123';
             JO.Contact_Name__c= 'shanthicontact';
             JO.Address__c= 'address';
             JO.City__c= 'bangalore';
             JO.ESN__c= '1234';  
             JO.Data_Exchange_Enabled__c=true;
                 
            insert JO;
            lstJO.add(JO);
            JO.City__c= 'bangalore';
            update JO;
            oldMap.put(JO.ID,JO); 
           Test.startTest();
           CSS_DataExchangeHelper help = new CSS_DataExchangeHelper ();
           help.insertDEParent(lstJO,oldMap);
             Test.stopTest();
            }
    
    
    }
    
     static testMethod void testinsertDataExchangeSolution2() {
     
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal21123', Email='standarduser11111234@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12234', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal1011234345@testorg.com', user_Location__c = '56280-56270');
        insert(u);
        System.runAs(u) {
            Map<Id,CSS_Solutions__c> oldMap = new Map<Id,CSS_Solutions__c> ();
            List<CSS_Job_Order__c> lstJO = new List<CSS_Job_Order__c>();
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'Shanthitest';
            JO.Status__c = 'Intake';
            JO.Unit_Number__c = 'test1234';
            JO.Service_Model__c = 'ISBE CM800';
             JO.CustomerID__c= '123';
             JO.Contact_Name__c= 'shanthicontact';
             JO.Address__c= 'address';
             JO.City__c= 'bangalore';
             JO.ESN__c= '1234';  
             JO.Data_Exchange_Enabled__c=true;
                 
            insert jo;
            lstJO.add(JO);
            System.debug('shanu jo'+jo);
          
           
           
            List<CSS_Solutions__c> lstsolexisting = new List<CSS_Solutions__c>();
            List<CSS_Solutions__c> lstsol = new List<CSS_Solutions__c>();
            CSS_Solutions__c sol = new CSS_Solutions__c();
            sol.Service_Job__c=jo.id;
            sol.Diagnostic_notes__c='test';
            sol.Repair_Notes__c='test';
           insert sol;
           
           CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c ();
           solcomp.Solutions__c =sol.id;
           solcomp.Action__c='Repair';
           solcomp.Component_Id__c='ids';
           solcomp.name='name';
           insert solcomp;
           System.debug('shanu solutioncomp'+solcomp);
           
           lstsolexisting.add(sol);
           sol.Diagnostic_notes__c='daig';
           sol.Repair_Notes__c='repair';
           sol.Id=sol.Id;
           update sol;
           
           
           lstsol.add(sol);
           
           for(CSS_Solutions__c css: lstsol ){
           
           oldMap.put(css.id,css);
           }
           System.debug('shanu oldMap'+oldMap);

           
          
           
           Test.startTest(); 
           CSS_DataExchangeHelper help1 = new CSS_DataExchangeHelper ();
           help1.insertDataExchangeSolution(lstsolexisting,oldMap);
           system.debug('shanu'+lstsolexisting);
            system.debug('shanu solcomp'+solcomp);
             Test.stopTest();
            }
    
    
    }
    
    }