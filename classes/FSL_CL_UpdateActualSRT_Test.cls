/*
* Test Class for Apex Controller - FSL_CL_UpdateActualSRT
* Author - Piyush Rani
*/ 
@isTest
public class FSL_CL_UpdateActualSRT_Test {
    
    @isTest public static void updateActualSRTTest() { 
        Try {
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Test.startTest();
            Account acc = new Account();
            acc.Name = 'East Bronx1';
            acc.CMI_Account_Status__c = 'Active';
            acc.PaymentType__c = 'Cash';
            acc.FSL_ERP_Customer_Code__c = '48923';
            acc.FSL_Credit_Limit__c = 78888.5;
            insert acc;
            
            OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            ServiceTerritory serTer = new ServiceTerritory();
            serTer.Name = 'ST001 Mobile';
            serTer.OperatingHoursId = oh.Id;
            serTer.IsActive = true;
            serTer.Location_Code__c = '03520-04892';
            serTer.FSL_Service_Territory_Code__c = '04892';
            serTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            serTer.Territory__c = 'AUSTRALIA';
            insert serTer;
            
            worktype  wType = new worktype();
            wType.EstimatedDuration = Decimal.valueOf('40.02');
            wType.Name = 'Internal';
            insert wType;
            
            List<workorder> woList = new List<workorder>();
            workorder wo1 = new workorder();
            wo1.Account = acc;
            wo1.Process_Step__c = 'Intake';
            wo1.Repair_Location__c = 'Mobile';
            wo1.EditComplaint__c = 'Testing';
            wo1.EditCause__c = 'Testing';
            wo1.EditCorrection__c = 'Testing';
            wo1.EditCoverage__c = 'Testing';
            wo1.ServiceTerritoryid = serTer.id;
            wo1.sub_status__c = 'Troubleshooting Complete';
            woList.add(wo1);
            
            insert woList;
            
            
            FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
            cfc.Cummins_Fault_Code__c = '123';
            insert cfc;
            
            CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
            fcode.Name=cfc.name;
            fcode.Type__c = 'Fault';
            fcode.Fault_Code_Type__c = '1';
            fcode.Service_Order__c = wo1.id;
            fcode.extfield__c = cfc.id+' '+wo1.id;
            fcode.Sequence__c = 0;
            fcode.Fault_Code_Type__c = 'Testing';
            fcode.Count__c = 1;
            fcode.Status__c = 'Active';
            insert fcode;
            
            List<FSL_SRT__c> ListSRT = new List<FSL_SRT__c>();
            FSL_SRT__c objSRT1 = new FSL_SRT__c();
            objSRT1.CSS_Fault_Code__c = fcode.Id;
            objSRT1.Service_Order__c = wo1.Id;
            objSRT1.SRT_Select__c = true;
            objSRT1.SRT_Time__c = 1.0;
            objSRT1.Type__c = 'Diagnosis';
        	objSRT1.SRT_Notes__c = 'SRT Notes Test';
            objSRT1.Name = '00-901-00';
        	
            ListSRT.add(objSRT1);
            insert ListSRT;
            
            List<FSL_Timesheet__c> TSList = new List<FSL_Timesheet__c>();
            FSL_Timesheet__c ts = new FSL_Timesheet__c();
            ts.Service_Order__c = wo1.Id;
            ts.StartTime__c = System.Datetime.now();
            ts.EndTime__c = System.Datetime.now().addHours(20);
            ts.Reason__c = 'Working';
            
            TSList.add(ts);
            
            insert TSList;
            
            Test.stopTest(); 
        } catch(Exception ex) {
            System.debug('::: Exception = '+ex.getMessage());
            System.debug('::: Exception Stacktrace = '+ex.getStackTraceString());
        }
       
    }
}