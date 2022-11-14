/******************************************************************************************

* Name        :    FSL_AddressUpdateTrigger_Test
* Purpose     :    update address in service Appointment
* History     :
* apex Trigger:    FSL_AddressUpdateTrigger
------------------------------------------------------------------------------------------- 
* VERSION         AUTHOR             DATE             DETAIL 
* 1.0             Ravi Teja      15/01/2020       Initial Development(test class for FSL_AddressUpdateTrigger)
*******************************************************************************************/
@isTest
public class FSL_AddressUpdateTrigger_Test {
    static testMethod void UpdateAddress() {
 
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        insert acc; 
        
        Account acc1 = new Account();
        acc1.RecordTypeId=accRecId;
        acc1.Name='Timothy';
        insert acc1; 
        
        IAM_CDH_Cross_references__c cross = new IAM_CDH_Cross_references__c();
        cross.Name = 'test';
        cross.FSL_Address_Line_1__c = '1595 N National Rd';
        cross.IAM_Account__c = acc1.Id;
        cross.FSL_Tax_District__c = 'NON';
        cross.FSL_Country__c = 'Canada';	
        insert cross;
        
        WorkType wt=new WorkType();
        wt.Name='Test work type';
        wt.EstimatedDuration=60.00;
        insert wt;

        //added newly 04-14 by Ravi
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT = new ServiceTerritory();
        sT.Name = 'ST001';
        sT.OperatingHoursId = oh.Id;
        sT.IsActive = true;
        sT.Location_Code__c = '01234-12345';
        sT.FSL_Service_Territory_Code__c = '12345';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        Insert sT;
        //ended  04-14 by Ravi
        
        
        WorkOrder wOrder = new WorkOrder();
        wOrder.ServiceTerritoryId = sT.Id;
        wOrder.WorkTypeId = wt.ID;
        wOrder.AccountId = acc1.Id;
        wOrder.Repair_Site_Name__c =  cross.Id;
        wOrder.Repair_Location__c = 'Mobile';
        worder.Status = 'Scheduled';
        worder.Type__c = 'External';
        insert wOrder;
        
        serviceappointment sa= new serviceappointment();
        sa.parentrecordId = wOrder.Id;
       // sa.WorkTypeId = wOrder.Id;
        sa.Status = 'None';
        sa.EarliestStartTime = datetime.newInstance(2019, 7, 22, 12, 30, 0);
        sa.DueDate = datetime.newInstance(2019, 7, 29, 12, 30, 0);
        insert sa;
        
        test.startTest();
        
        cross.FSL_Address_Line_1__c='1595 N National Rd';
        cross.FSL_Address_Line_2__c = 'Court Rd';
        cross.FSL_City__c = 'Picton';
        cross.FSL_State__c='Queensland';
        cross.FSL_Country__c='Australia';
        cross.FSL_Postal_Code__c='47202';
        
        update cross;
        
        
        serviceappointment sap = [SELECT Id, Street FROM serviceappointment LIMIT 1];
        System.debug('sap' + sap);
        System.assertEquals('1595 N National Rd Court Rd', sap.street);
        
        Test.stopTest(); 
        
    }
}