//Adding comment for deployment -- Akansha MV_688 8/25/2022

//Adding Comment for Deploment --- Sriprada
//test class modified by Naveen -----Naveen  26/08/2022
@isTest
public class FSL_IntakeViewHistoryCtrl_Test {
    
    @testSetup
    public static void setupMethod(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com',User_Location__c='05306-40582-036-I');
        insert newUser;  
        
    }    
    public static testMethod void test1() {
        /*Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;*/
        User userObj = [SELECT Id FROM User WHERE Alias = 'standt'];
        System.runAs(userObj){ 
            BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
            
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc = TestUtility.createTestAccount('Test Account', accRecId);
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con = TestUtility.createNewCon(acc.id, conRecId);
            
            OperatingHours  oh = new OperatingHours ();
            oh = TestUtility.createOperatingHours('new');
            
            ServiceTerritory sT= new ServiceTerritory();
            st = TestUtility.createServiceTerritory('TEST ST Mobile', true, oh.id);
            
            Test.startTest();
            FSL_Labor_Multiplier__c lm = new FSL_Labor_Multiplier__c();
            lm.Name = 'TIER B';
            insert lm;
            
            Asset asst = new Asset();
            asst = TestUtility.createTestAsset(acc, 'Engines-79644334');
             
            case cs=new case();
            cs = TestUtility.createTestCasewithContact(acc.id, asst.id, con.id);
            
            List<WorkOrder> WorkOrderList = new List<WorkOrder>();
            WorkOrder wo = new WorkOrder();
            wo = TestUtility.createNewWorkOrder(sT.id, acc.id, con.id, asst.id);
            wo.Type__c = 'Dealer';
            WorkOrderList.add(wo);
            
            WorkOrder wo1 = new WorkOrder();
            wo1 = TestUtility.createNewWorkOrder(sT.id, acc.id, con.id, asst.id);
            WorkOrderList.add(wo1);
            insert WorkOrderList;
            
            ApexPages.currentPage().getParameters().put('Id', wo.Id);
            FSL_IntakeViewHistoryCtrl vh = new FSL_IntakeViewHistoryCtrl();
            vh.workOrderId = wo.Id; 
            Test.stopTest();
            
        }
    }
    public static testMethod void test2() {
        /*Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com',User_Location__c='05306-40582-036-I');
        insert newUser;*/
        User userObj = [SELECT Id FROM User WHERE Alias = 'standt'];
        System.runAs(userObj){ 
            BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
            
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc = TestUtility.createTestAccount('Test Account', accRecId);
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con = TestUtility.createNewCon(acc.id, conRecId);
            
            OperatingHours  oh = new OperatingHours ();
            oh = TestUtility.createOperatingHours('new');
            
            ServiceTerritory sT= new ServiceTerritory();
            st = TestUtility.createServiceTerritory('TEST ST Mobile', true, oh.id);
            
            Test.startTest();
            FSL_Labor_Multiplier__c lm = new FSL_Labor_Multiplier__c();
            lm.Name = 'TIER B';
            insert lm;
            
            Asset asst = new Asset();
            asst = TestUtility.createTestAsset(acc, 'Engines-79644334');
            
            case cs=new case();
            cs = TestUtility.createTestCasewithContact(acc.id, asst.id, con.id);
            
            List<WorkOrder> WorkOrderList = new List<WorkOrder>();
            WorkOrder wo = new WorkOrder();
            wo = TestUtility.createNewWorkOrder(sT.id, acc.id, con.id, asst.id);
            WorkOrderList.add(wo);
            
            WorkOrder wo1 = new WorkOrder();
            wo1 = TestUtility.createNewWorkOrder(sT.id, acc.id, con.id, asst.id);
            WorkOrderList.add(wo1);
            insert WorkOrderList;
            
            ServiceTerritory testServiceTerritory = new ServiceTerritory(Name = 'Europe test',
                                                                         IsActive = true,
                                                                         OperatingHoursId = oh.id, 
                                                                         Type__c = 'Group',
                                                                         Location_Code__c	='00000-I00004',Region__c = 'EUROPE', Territory__c = 'UK',
                                                                         FSL_Service_Territory_Code__c='I00004');
            
            insert testServiceTerritory;     
            
            
            List<FSL__User_Territory__c> lstUT = new List<FSL__User_Territory__c>();
            FSL__User_Territory__c Ut = new FSL__User_Territory__c();
            Ut.FSL__ServiceTerritory__c = testServiceTerritory.id;
            Ut.FSL__User__c = userObj.id;
            lstUT.add(Ut);
            
            insert lstUT;
            
            ApexPages.currentPage().getParameters().put('Id', wo.Id);
            FSL_IntakeViewHistoryCtrl vh = new FSL_IntakeViewHistoryCtrl();
            vh.workOrderId = wo.Id; 
            Test.stopTest();
            
        }
    }
    
}