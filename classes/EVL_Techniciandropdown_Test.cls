//adding comment for deployment
@isTest
public class EVL_Techniciandropdown_Test {
    
    
    static testmethod  void savemethod(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        User newUser1 = new User(Alias = 'sta007',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser007@gmail.com');
        list<user> UserList = new list<user>();
        UserList.add(newUser);
        UserList.add(newUser1);
        insert UserList; 
        
        
        // This code runs as the system user
        
        //Id worOrder;
        
        System.runAs(newUser) {
            Account acc = new Account();
            acc.Name = 'East Bronx1'; 
            acc.CMI_Account_Status__c = 'Active';
            acc.PaymentType__c = 'Cash';
            acc.FSL_ERP_Customer_Code__c = '48923';
            acc.FSL_Credit_Limit__c = 78888.5;
            acc.BillingStreet = '400 BROWN ST';
            acc.BillingCity = 'Columbus';
            acc.BillingState = 'Indiana';
            acc.BillingCountry = 'United States';
            acc.BillingPostalCode = '47201';
            insert acc;
            
            Asset  ast = new Asset();
            ast.Service_Model__c = 'ISL9 CM2350 L101';
            ast.Unit_Number__c = '1234';
            ast.Make__c = 'KENWORTH';
            ast.Model__c = 'T800';
            ast.Name = '79963830';
            ast.Unit_Type__c = 'EQ8349';
            ast.VIN__c = '1NKDX4TX6JJ180253';
            ast.Type_PSN__c = 'Engines-79963830';
            ast.Application_Description__c = 'AUTOMOTIVE';
            ast.Application_Code__c = '130';
            ast.Engine_Family__c    ='56'; 
            ast.Type__c = 'Engines';
            ast.AccountId = acc.Id;        //Modified
            insert ast;
            
            Case  cs = new Case();
            cs.Status = 'Intake';
            //cs.Service_Territory__c = serTer.id;
            cs.Priority = 'Medium';
            cs.AccountId = acc.id;
            cs.AssetId = ast.id;
            insert cs; 
            
            workorder wo1 = new workorder();
            wo1.Process_Step__c = 'Intake';
            wo1.Repair_Location__c = 'Mobile';
            wo1.EditComplaint__c = 'Testing';
            wo1.EditCause__c = 'Testing';
            wo1.EditCorrection__c = 'Testing';
            wo1.EditCoverage__c = 'Testing';
            //wo1.ServiceTerritoryid = serTer.id;
            wo1.sub_status__c = 'Troubleshooting Complete';
            wo1.AccountId = acc.Id;
            wo1.AssetId = ast.Id;
            wo1.CaseId = cs.Id;
            insert wo1;
            //worOrder = wo1.Id;
            EVL_Techniciandropdown.save(newUser1.Id,wo1.Id);
			EVL_Techniciandropdown.save(newUser1.Id,wo1.Id);
            
        }
        
        //test.starttest();
        //EVL_Techniciandropdown.save(UserInfo.getUserId(),worOrder );
        //test.stopTest();
        
    }
    
    //Added by sai as part of CT1-61
    static testmethod void certUserLIstmethod(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;
        
        System.runAs(newUser) {
            Account acc0 = new Account();
            acc0.name='Rtest';
            acc0.CSS_DistributorCode__c='562701';
            acc0.IAM_Service_Provider_Code__c='562551';
            acc0.Type='Dealer Account';
            acc0.Region__c = 'US and Canada';
            acc0.CMI_Account_Status__c = 'Active';
            acc0.IAM_Service_Provider_Code__c = '562551';
            acc0.CSS_DistributorCode__c='50000';
            acc0.CSS_DBCode__c = '02466';
            acc0.IAM_Service_Provider_Code__c = '29550';
            acc0.BillingStreet = '400 BROWN ST';
            acc0.BillingCity = 'Columbus';
            acc0.BillingState = 'Indiana';
            acc0.BillingCountry = 'United States';
            acc0.BillingPostalCode = '47201';
            insert acc0;
            
            Contact con = new Contact();
            con.AccountId = acc0.Id;
            con.FirstName = 'Test Con';
            con.Username__c ='Test_con';
            con.Email = 'test@gmail.com';
            con.FSL_Contact_Id__c='Test778999';
            con.LastName ='Test';            
            insert con;
            
            Asset  asst = new Asset();
            asst.Service_Model__c = 'ISL9 CM2350 L101';
            asst.Unit_Number__c = '1234';
            asst.Make__c = 'KENWORTH';
            asst.Model__c = 'T800';
            asst.Name = '79963830';
            asst.Unit_Type__c = 'EQ8349';
            asst.VIN__c = '1NKDX4TX6JJ180253';
            asst.Type_PSN__c = 'Engines-79963830';
            asst.Application_Description__c = 'AUTOMOTIVE';
            asst.Application_Code__c = '130';
            asst.Engine_Family__c    ='56'; 
            asst.Type__c = 'Engines';
            asst.AccountId = acc0.Id;        
            insert asst;
            
            FSL_SMN_DTC__c fs = new FSL_SMN_DTC__c();
            fs.name='ISL9 CM2350 L101';
            fs.FaultTypeFC__c ='Yes';
            insert fs;
            
            Id DealerecTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();

            WorkOrder woo = new Workorder();
           // woo.Process_Step__c = 'Intake';
            woo.EVL_Stage__c ='Intake';
            woo.Status = 'Intake';
            woo.sub_status__c = 'Troubleshooting Complete';
            woo.FSL_SMN__c = fs.Id;
            woo.AccountId = acc0.Id;
            woo.AssetId = asst.Id;
            woo.Type__c = 'Dealer';
            woo.RecordTypeId = DealerecTypeId;
            insert woo;
            
            CSS_UserLocation__c obj = new CSS_UserLocation__c();
            obj.Location_code__c = '02466-29550';
            obj.IsActive__c = true;
            obj.UserId__c = newUser.id;
            obj.AccountId__c = acc0.id;
            insert obj;
            
            CSS_Accreditation__c accr = new CSS_Accreditation__c();
            accr.Name = 'UniqueTest';
            accr.Service_Level__c ='FULL SERVICE';
            accr.Service_Model_Name__c ='ISL9 CM2350 L101';
            accr.SpCode__c ='';
            accr.Account__c =acc0.Id;            
            insert accr;
            
            CSS_AccredUser__c aactus = new CSS_AccredUser__c();
            aactus.Name = 'UniqueTest110';
            aactus.CurrencyIsoCode ='USD';
            aactus.Accreditation__c = accr.Id;
            aactus.User__c = newUser.Id;    
            //aactus.Location__c = obj.Location_code__c;
            //aactus.Service_Model_Name__c = accr.Service_Model_Name__c;
            insert aactus;
            
            test.startTest();
            EVL_Techniciandropdown.certUserLIst(woo.Id);
            EVL_Techniciandropdown.getUsers(woo.Id);
            test.stopTest();
        }
    }
}