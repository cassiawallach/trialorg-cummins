@istest
public class FSL_serviceOrderContactTriggerHan_Test {
    public static testmethod void method1(){
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
        //socData.Language_Preferences__c = 'English';;
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
        Map<Id,ServiceOrderContact__c> oldSOCMap = new Map<Id,ServiceOrderContact__c>();
        oldSOCMap.put(socList[0].id,socList[0]);
        
        FSL_serviceOrderContactTriggerHandler SOTH = new FSL_serviceOrderContactTriggerHandler();
        FSL_serviceOrderContactTriggerHandler.insertServiceOrderContactList(socList);
		FSL_serviceOrderContactTriggerHandler.insertServiceOrderContactListUpdate(socList,oldSOCMap);
        FSL_serviceOrderContactTriggerHandler.ServiceOrderContactAfterInsert(socList);
		
       
                
    }
}