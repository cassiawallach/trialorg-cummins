/**********************************************************************
Name: FSL_MaintenancePlanHandlerTest
Copyright Â© 2021  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Harish       01/20/2019      INITIAL DEVELOPMENT- Add WorkType to the Maintenance Plan record Test Method
***********************************************************************/

@isTest
public class FSL_MaintenancePlanHandlerTest {
    static testMethod void workTypebeforeInsert() {
        Test.startTest();
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        //TimeZone
        
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '01234-01234';
        objServiceTerritory.FSL_Service_Territory_Code__c = '01234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.RecordTypeId = accRecId;
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        
        WorkType pmWorkType = new WorkType(name = 'PM',EstimatedDuration=1); 
        insert pmWorkType;
        
        MaintenancePlan objMaintenancePlan = new MaintenancePlan(StartDate= System.today() , EndDate=System.today()+20 ,Payment__c='Paid',Payer__c= objAccount.id,                                                                 Frequency=1, FrequencyType='Months', NextSuggestedMaintenanceDate= System.today(),GenerationTimeframe= 1);
        
        
        insert objMaintenancePlan;
        
        Test.stopTest();
        
        
    }
    
    
}