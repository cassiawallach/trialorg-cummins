@isTest
public class FSL_ServiceOrderCommunicationUtil_Test {
    public static testMethod void insertCommunicationRecords_New_test() {        
        
    
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.RecordTypeId = accRecId;
        //acc.Authorize_Work_Started__c = false;
        insert acc;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        serviceterritory st = new serviceterritory();
        st.name='BrisbaneNew';
        st.state='Queensland';
        st.city='Carole Park';
        st.Street='39-53 Ron Boyle Crescent';
        st.country='Australia';
        st.postalcode='4300';
        st.Phone__c ='+61 7 3710 4700'; 
        st.OperatingHoursId = oh.Id;
        st.IsActive = true;
        st.Location_Code__c = '03522-04893';
        st.FSL_Service_Territory_Code__c = '04893';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        Asset ast = new Asset();
        ast.name='79371784';
        ast.Unit_Number__c='595769';
        ast.VIN__c='BJ361430';
        insert ast;
        
        Contact con= new Contact();
        con.FirstName='test1';
        con.LastName='test';
        con.AccountId=acc.id;
        con.Email = 'test@cummins.com';
        //con.Authorize_work_started__c= true;
        //con.Troubleshooting_started__c= true;
        //con.Service_Work_Completed__c= true;
        //con.Equipment_available__c=true;
        //con.Invoice_ready__c=true;
        con.FSL_Comm_Triggers__c = 'Troubleshooting Started;Authorized Work Started;Service Work Completed;Equipment Available;Invoice Ready';
        con.Language_Preferences__c = 'French';
        //con.Mobile_Phone__c='9999999999'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con.MobilePhone ='9999999999';
        con.Email_Notification_Frequency__c='Real-Time';
        con.Text_SMS_Notification_Frequency__c='Real-Time';
        con.IAM_Contact_Status__c = 'Active'; 
        con.Language_Preferences__c = 'English';
        con.CMI_IsActive__c = true;
        con.FSL_Contact_Id__c='66211006';
         insert con;
        
        WorkOrder wo = new WorkOrder();
        wo.Payer__c = acc.id;
        wo.AccountId = acc.id;
        wo.ESN__c='79371784';
        wo.Unit_Type__c='595769';
        wo.Make__c='INTERNATIONAL';
        wo.Model__c='PROSTAR';
        wo.AssetId=ast.Id;
        wo.Shop_Work_Order__c='175793';
        wo.ServiceTerritoryId=st.Id;
        wo.FSL_Additional_Email_Notifications__c='test@cummins.com';
        wo.Payer_ContactID__c=con.Id;
        wo.contactId = con.Id;
        wo.Service_Team_Contact__c=UserInfo.getUserId();
        insert wo;
        
        List<ServiceOrderContact__c> socList = new List<ServiceOrderContact__c>();
        ServiceOrderContact__c socData = new ServiceOrderContact__c();
        //socData.Language_Preferences__c = 'English';
        //socData.Email__c = 'noreply@test.com';
        //socData.Email_Notifications__c = true;
        //socData.Mobile_Phone__c = '8901234560';
        //socData.Nightly_Communication__c = true;
        socData.Payer_Contact_Flag__c = true;
        //socData.Text_Notifications__c = true;
        socData.Payer_Account__c = wo.Payer__c;
        socData.Payer_Contact__c = wo.Payer_ContactID__c;
        socData.Service_Order__c = wo.Id;
        socData.Opt_In__c =true;
        socList.add(socData);
        
        insert socList;
        
        Service_Order_Communication__c socObj = new Service_Order_Communication__c();
                        socObj.Action__c = 'email';
                        socObj.Contact__c= con.id;
                        socObj.Service_Order__c = wo.id;
                        socObj.Communication_Trigger_Name__c = 'Authorized Work Started';//Need to check on the mapping
                        //String City = soc.Service_Order__r.ServiceTerritory.city;
                        //String Street = soc.Service_Order__r.ServiceTerritory.street;
                        //String State = soc.Service_Order__r.ServiceTerritory.state;
                        //String Country = soc.Service_Order__r.ServiceTerritory.country;
                        //String postCode = soc.Service_Order__r.ServiceTerritory.postalcode;                    
                        //String address = ((City != null && City != '')?City:'')+((Street != null && Street != '')?street:'')+((State != null && State != '')?State:'')+((Country != null && Country != '')?Country:'')+((postCode != null && postCode != '')?postCode:'');
                        //socObj.Address__c = City + ' '+State;
                        socObj.ERP__c = '123';
                        socObj.Event_Type__c = 'Service_Status_Change';//Need to check on the mapping
                        socObj.From_Address__c = 'DONOTREPLY@cummins.com';
                        insert socObj;
                        
                        
        Map<String,List<ServiceOrderContact__c>> socMap = new Map<String,List<ServiceOrderContact__c>>();
        socMap.put('English',socList);
        List<Id> woIds= new List<Id>();
        woIds.add(wo.Id);
        List<String> woIdCommName = new List<String>();
        woIdCommName.add(wo.Id+';'+'Authorized_Work_Started');
        woIdCommName.add(wo.Id+';'+'Troubleshooting_Started');
        woIdCommName.add(wo.Id+';'+'Service_Work_Completed');
        woIdCommName.add(wo.Id+';'+'Equipment_available');
        
        Test.startTest();
        
        FSL_ServiceOrderCommunicationUtil.insertCommunicationRecords_New(woIdCommName);
        Set<String> conIds=new Set<String>();       
        conIds.add(con.id);
        String refNumber= wo.Shop_Work_Order__c;
        FSL_ServiceOrderCommunicationUtil.insertCommunicationRecordsFromBMS(conIds,refNumber);
        FSL_ServiceOrderCommunicationUtil.insertCommunicationRecordsFromBMS_Adhoc(refNumber,'test@test.com');
       
        Test.stopTest();
    }
    public static testMethod void insertCommunicationRecords_New_test1() {        
        
      
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.RecordTypeId = accRecId;
        //acc.Authorize_Work_Started__c = false;
        //acc.Invoice_Ready__c=false;
        insert acc;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        serviceterritory st = new serviceterritory();
        st.name='BrisbaneNew';
        st.state='Queensland';
        st.city='Carole Park';
        st.Street='39-53 Ron Boyle Crescent';
        st.country='Australia';
        st.postalcode='4300';
        st.Phone__c ='+61 7 3710 4700'; 
        st.OperatingHoursId = oh.Id;
        st.IsActive = true;
        st.Location_Code__c = '03522-04893';
        st.FSL_Service_Territory_Code__c = '04893';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        Asset ast = new Asset();
        ast.name='79371784';
        ast.Unit_Number__c='595769';
        ast.VIN__c='BJ361430';
        
        insert ast;
        
        Contact con= new Contact();
        con.FirstName='test1';
        con.LastName='test';
        con.AccountId=acc.id;
        con.Email = 'test@cummins.com';
        //con.Email_Notifications__c = true;
        //con.Text_Notifications__c = true;
        
        con.Language_Preferences__c = 'French';
        //con.Mobile_Phone__c='9999999999'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con.MobilePhone ='9999999999';
        con.Email_Notification_Frequency__c='Nightly';
        con.FSL_Comm_Triggers__c = 'Troubleshooting Started;Authorized Work Started;Service Work Completed;Equipment Available;Invoice Ready';

        con.IAM_Contact_Status__c = 'Active'; 
        con.Language_Preferences__c = 'English';
        con.CMI_IsActive__c = true;
        con.FSL_Contact_Id__c='66211006';
        //con.Authorize_work_started__c= true;
        //con.Troubleshooting_started__c= true;
        //con.Service_Work_Completed__c= true;
        //con.Equipment_available__c=true;
        //con.Invoice_ready__c=true;
         insert con;
        
        WorkOrder wo = new WorkOrder();
        wo.Payer__c = acc.id;
        wo.AccountId = acc.id;
        wo.ESN__c='79371784';
        wo.Unit_Type__c='595769';
        wo.Make__c='INTERNATIONAL';
        wo.Model__c='PROSTAR';
        wo.AssetId=ast.Id;
        wo.Shop_Work_Order__c='175793';
        wo.ServiceTerritoryId=st.Id;
        wo.FSL_Additional_Email_Notifications__c='test@cummins.com';
        wo.Payer_ContactID__c=con.Id;
        wo.contactId = con.Id;
        wo.Service_Team_Contact__c=UserInfo.getUserId();
        insert wo;
        
        List<ServiceOrderContact__c> socList = new List<ServiceOrderContact__c>();
        ServiceOrderContact__c socData = new ServiceOrderContact__c();
        //socData.Language_Preferences__c = 'English';
        //socData.Email__c = 'noreply@test.com';
        //socData.Email_Notifications__c = true;
        //socData.Mobile_Phone__c = '8901234560';
        //socData.Nightly_Communication__c = true;
        socData.Payer_Contact_Flag__c = true;
        //socData.Text_Notifications__c = true;
        socData.Payer_Account__c = wo.Payer__c;
        socData.Payer_Contact__c = wo.Payer_ContactID__c;
        socData.Service_Order__c = wo.Id;
        socData.Opt_In__c =true;
        socList.add(socData);
        
        insert socList;
        Service_Order_Communication__c socObj = new Service_Order_Communication__c();
                        socObj.Action__c = 'email';
                        socObj.Contact__c= con.id;
                        socObj.Service_Order__c = wo.id;
                        socObj.Communication_Trigger_Name__c = 'Authorized Work Started';//Need to check on the mapping
                        //String City = soc.Service_Order__r.ServiceTerritory.city;
                        //String Street = soc.Service_Order__r.ServiceTerritory.street;
                        //String State = soc.Service_Order__r.ServiceTerritory.state;
                        //String Country = soc.Service_Order__r.ServiceTerritory.country;
                        //String postCode = soc.Service_Order__r.ServiceTerritory.postalcode;                    
                        //String address = ((City != null && City != '')?City:'')+((Street != null && Street != '')?street:'')+((State != null && State != '')?State:'')+((Country != null && Country != '')?Country:'')+((postCode != null && postCode != '')?postCode:'');
                        //socObj.Address__c = City + ' '+State;
                        socObj.ERP__c = '123';
                        socObj.Event_Type__c = 'Service_Status_Change';//Need to check on the mapping
                        socObj.From_Address__c = 'DONOTREPLY@cummins.com';
                        insert socObj;
                        
        Map<String,List<ServiceOrderContact__c>> socMap = new Map<String,List<ServiceOrderContact__c>>();
        socMap.put('English',socList);
        List<Id> woIds= new List<Id>();
        woIds.add(wo.Id);
        List<String> woIdCommName = new List<String>();
        woIdCommName.add(wo.Id+';'+'Authorized_Work_Started');
          
          Test.startTest();
       
        FSL_ServiceOrderCommunicationUtil.insertCommunicationRecords_New(woIdCommName);
        Set<String> conIds=new Set<String>();       
        conIds.add(con.FSL_Contact_Id__c);
        String refNumber= wo.Shop_Work_Order__c;
        FSL_ServiceOrderCommunicationUtil.insertCommunicationRecordsFromBMS(conIds,refNumber);
        FSL_ServiceOrderCommunicationUtil.insertCommunicationRecordsFromBMS_Adhoc(refNumber,'test@test.com');
       
        Test.stopTest();
    }
    
    
    public static testMethod void insertCommunicationRecords_New_test2() {        
        
      
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.RecordTypeId = accRecId;
        //acc.Authorize_Work_Started__c = false;
        //acc.Equipment_Available__c= false;
        //acc.Service_Work_Completed__c= false;
        //acc.Troubleshooting_Started__c= false;
        acc.Communication_Triggers__c = 'Troubleshooting Started;Authorized Work Started;Service Work Completed;Equipment Available;Invoice Ready';
        //acc.Invoice_Ready__c=true;
        insert acc;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        serviceterritory st = new serviceterritory();
        st.name='BrisbaneNew';
        st.state='Queensland';
        st.city='Carole Park';
        st.Street='39-53 Ron Boyle Crescent';
        st.country='Australia';
        st.postalcode='4300';
        st.Phone__c ='+61 7 3710 4700'; 
        st.OperatingHoursId = oh.Id;
        st.IsActive = true;
        st.Location_Code__c = '03522-04893';
        st.FSL_Service_Territory_Code__c = '04893';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        Asset ast = new Asset();
        ast.name='79371784';
        ast.Unit_Number__c='595769';
        ast.VIN__c='BJ361430';
        
        insert ast;
        
        Contact con= new Contact();
        con.FirstName='test1';
        con.LastName='test';
        con.AccountId=acc.id;
        con.Email = 'test@cummins.com';
        //con.Email_Notifications__c = true;
        //con.Text_Notifications__c = true;
        
        con.Language_Preferences__c = 'French';
        //con.Mobile_Phone__c='9999999999'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con.MobilePhone ='9999999999';
        con.Email_Notification_Frequency__c='Nightly';
        //con.Email_Notification_Frequency__c='Real-Time';
        con.IAM_Contact_Status__c = 'Active'; 
        con.Language_Preferences__c = 'English';
        con.CMI_IsActive__c = true;
        con.FSL_Contact_Id__c='66211006';

         insert con;
        
        WorkOrder wo = new WorkOrder();
        wo.Payer__c = acc.id;
        wo.AccountId = acc.id;
        wo.ESN__c='79371784';
        wo.Unit_Type__c='595769';
        wo.Make__c='INTERNATIONAL';
        wo.Model__c='PROSTAR';
        wo.AssetId=ast.Id;
        wo.Shop_Work_Order__c='175793';
        wo.ServiceTerritoryId=st.Id;
        wo.FSL_Additional_Email_Notifications__c='test@cummins.com';
        wo.Payer_ContactID__c=con.Id;
        wo.contactId = con.Id;
        wo.Service_Team_Contact__c=UserInfo.getUserId();
        insert wo;
        
        List<ServiceOrderContact__c> socList = new List<ServiceOrderContact__c>();
        ServiceOrderContact__c socData = new ServiceOrderContact__c();
        //socData.Language_Preferences__c = 'English';
        //socData.Email__c = 'noreply@test.com';
        //socData.Email_Notifications__c = true;
        //socData.Mobile_Phone__c = '8901234560';
        //socData.Nightly_Communication__c = true;
        socData.Payer_Contact_Flag__c = true;
        //socData.Text_Notifications__c = true;
        socData.Payer_Account__c = wo.Payer__c;
        socData.Payer_Contact__c = wo.Payer_ContactID__c;
        socData.Service_Order__c = wo.Id;
        socData.Opt_In__c =true;
        socList.add(socData);
        
        insert socList;
        Service_Order_Communication__c socObj = new Service_Order_Communication__c();
                        socObj.Action__c = 'email';
                        socObj.Contact__c= con.id;
                        socObj.Service_Order__c = wo.id;
                        socObj.Communication_Trigger_Name__c = 'Authorized Work Started';//Need to check on the mapping
                        //String City = soc.Service_Order__r.ServiceTerritory.city;
                        //String Street = soc.Service_Order__r.ServiceTerritory.street;
                        //String State = soc.Service_Order__r.ServiceTerritory.state;
                        //String Country = soc.Service_Order__r.ServiceTerritory.country;
                        //String postCode = soc.Service_Order__r.ServiceTerritory.postalcode;                    
                        //String address = ((City != null && City != '')?City:'')+((Street != null && Street != '')?street:'')+((State != null && State != '')?State:'')+((Country != null && Country != '')?Country:'')+((postCode != null && postCode != '')?postCode:'');
                        //socObj.Address__c = City + ' '+State;
                        socObj.ERP__c = '123';
                        socObj.Event_Type__c = 'Service_Status_Change';//Need to check on the mapping
                        socObj.From_Address__c = 'DONOTREPLY@cummins.com';
                        insert socObj;
                        
        Map<String,List<ServiceOrderContact__c>> socMap = new Map<String,List<ServiceOrderContact__c>>();
        socMap.put('English',socList);
        List<Id> woIds= new List<Id>();
        woIds.add(wo.Id);
        List<String> woIdCommName = new List<String>();
        woIdCommName.add(wo.Id+';'+'Authorized_Work_Started');
          
          Test.startTest();
       
        FSL_ServiceOrderCommunicationUtil.insertCommunicationRecords_New(woIdCommName);
        Set<String> conIds=new Set<String>();       
        conIds.add(con.FSL_Contact_Id__c);
        String refNumber= wo.Shop_Work_Order__c;
        FSL_ServiceOrderCommunicationUtil.insertCommunicationRecordsFromBMS(conIds,refNumber);
        FSL_ServiceOrderCommunicationUtil.insertCommunicationRecordsFromBMS_Adhoc(refNumber,'test@test.com');
       
        Test.stopTest();
    }
  
}