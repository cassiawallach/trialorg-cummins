@isTest
public class CSS_UserAddedPartsController_Test {

static testMethod void Method1(){
Test.startTest();
List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
CSS_Job_Order__c JO = new CSS_Job_Order__c();
JO.Customer_Name__c = 'case';
JO.Application__c = 'Recreational Vehicle';
JO.Model__c = 'testcase';
JO.Make__c = 'CSSTest';
JO.Notes__c = 'CAMPCOMMENTS';
JO.Failure_Point__c = 122;
JO.Failure_Point_Measure__c = 'Miles';
JO.VIN__c = '12345677890';
JO.Failure_Date__c = date.today() - 20;
JO.Warranty_Start_Date__c = date.today() - 365;
JO.Location_Certification__c = 'abc';
JO.jobLocation__c = 'abc';
JO.Before_In_Service__c = True;
JO.Status__c = 'Repair Complete';
JO.Unit_Number__c = 'test123';
Jo.Assigned_To__c = UserInfo.getUserId();
Jo.esn__c = '33186363';
JO.Unit_Type__c = 'type';
Jo.Country__c = 'United States';
Jo.CSS_State__c = 'Indiana';
Jo.City__c = 'Columbus';
Jo.Customer_Code__c = '23456';
Jo.EditComplaint__c = 'complaint';
Jo.EditCoverage__c = 'coverage';
Jo.EditCause__c = 'cause';
Jo.EditCorrection__c = 'correction';
JO.chevron_page__c = 'prt';
JO.CSS_Resolution__c = 'Test';
JO.DSID__c = 'VFD23';
    insert JO;
  lstjo.add(JO);

PageReference pref;
pref = new PageReference('/'+JO.id);
pref.getParameters().put('id',JO.id);
Test.setCurrentPage(pref);

CSS_Solution_Component__c solObj = new CSS_Solution_Component__c();
solObj.Root_Cause__c = true;
  insert solObj;
  
CSS_Solution_Component__c solObj1 = new CSS_Solution_Component__c();
solObj1.Root_Cause__c = true;
  insert solObj1;

List<CSS_Parts_Options__c> prtsLst = new List<CSS_Parts_Options__c>();
CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
parts.FailurepartId__c = solObj1.id;
parts.Service_Job__c = JO.id;
parts.Parts_Type__c = 'Custom';
parts.ReturnToFactory__c = '';
parts.Fail_Code__c = 'FailCode';
parts.Account_Code__c = 'AccountCode';
parts.Service_partnumber__c = 'ServicePartNumber';
parts.Covered__c = 23;
parts.Selected_part__c = true;
parts.Part_size__c = 'Data';
parts.Option_Number__c = 'DataTesting';
parts.Part_Description__c = 'DataTesting';
parts.Assignment__c = 'Test';
parts.Part_Name__c = 'PartName';
parts.Replacement_Reason__c = 'Test';
parts.Quantity__c = 10;
parts.OEM__c = 'Data';
parts.Notes__c = 'Data';
parts.Name = 'Testng';
   insert parts;
CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
parts1.FailurepartId__c = solObj1.id;
parts1.Service_Job__c = JO.id;
parts1.Parts_Type__c = 'Custom';
parts1.ReturnToFactory__c = '';
parts1.Fail_Code__c = 'FailCode';
parts1.Account_Code__c = 'AccountCode';
parts1.Service_partnumber__c = 'ServicePartNumber';
parts1.Covered__c = 23;
parts1.Selected_part__c = true;
parts1.Part_size__c = 'Data';
parts1.Option_Number__c = 'DataTesting';
parts1.Part_Description__c = 'DataTesting';
parts1.Assignment__c = 'Test';
parts1.Part_Name__c = 'PartName';
parts1.Replacement_Reason__c = 'Test';
parts1.Quantity__c = 10;
parts1.OEM__c = 'Data';
parts1.Notes__c = 'Data';
parts1.Name = 'Testng';
   insert parts1;
   
   prtsLst.add(parts);
   prtsLst.add(parts1);
   system.debug('prtsLst'+prtsLst);

CSS_UserAddedPartsController obj = new CSS_UserAddedPartsController();
obj.eprPartList = prtsLst;
obj.serviceJobNumber = 'serviceJobNumber';
obj.DealerTypeFlag = true;
obj.pgId = JO.id;
Test.stopTest();
}
static testMethod void getUserAddedPartsMethod(){

CSS_Job_Order__c JO = new CSS_Job_Order__c();
JO.Customer_Name__c = 'case';
JO.Application__c = 'Recreational Vehicle';
JO.Model__c = 'testcase';
JO.Make__c = 'CSSTest';
JO.Notes__c = 'CAMPCOMMENTS';
JO.Failure_Point__c = 122;
JO.Failure_Point_Measure__c = 'Miles';
JO.VIN__c = '12345677890';
JO.Failure_Date__c = date.today() - 20;
JO.Warranty_Start_Date__c = date.today() - 365;
JO.Location_Certification__c = 'abc';
JO.jobLocation__c = 'abc';
JO.Before_In_Service__c = True;
JO.Status__c = 'Repair Complete';
JO.Unit_Number__c = 'test123';
Jo.Assigned_To__c = UserInfo.getUserId();
Jo.esn__c = '33186363';
JO.Unit_Type__c = 'type';
Jo.Country__c = 'United States';
Jo.CSS_State__c = 'Indiana';
Jo.City__c = 'Columbus';
Jo.Customer_Code__c = '23456';
Jo.EditComplaint__c = 'complaint';
Jo.EditCoverage__c = 'coverage';
Jo.EditCause__c = 'cause';
Jo.EditCorrection__c = 'correction';
JO.chevron_page__c = 'prt';
JO.CSS_Resolution__c = 'Test';
JO.DSID__c = 'VFD23';
    insert JO;

Id pgId = ApexPages.CurrentPage().getParameters().put('id',JO.id);

PageReference pref;
pref = new PageReference('/'+JO.id);
pref.getParameters().put('id',JO.id);
Test.setCurrentPage(pref);

CSS_Solution_Component__c solObj = new CSS_Solution_Component__c();
solObj.Root_Cause__c = true;
  insert solObj;
  
CSS_Solution_Component__c solObj1 = new CSS_Solution_Component__c();
solObj1.Root_Cause__c = true;
  insert solObj1;

List<CSS_Parts_Options__c> prtsLst = new List<CSS_Parts_Options__c>();
CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
parts.FailurepartId__c = solObj1.id;
parts.Service_Job__c = pgId;
parts.Parts_Type__c = 'Custom';
parts.ReturnToFactory__c ='';
parts.Fail_Code__c = 'FailCode';
parts.Account_Code__c = 'AccountCode';
parts.Service_partnumber__c = 'ServicePartNumber';
parts.Covered__c = 23;
parts.Selected_part__c = true;
parts.Part_size__c = 'Data';
parts.Option_Number__c = 'DataTesting';
parts.Part_Description__c = 'DataTesting';
parts.Assignment__c = 'Test';
parts.Part_Name__c = 'PartName';
parts.Replacement_Reason__c = 'Test';
parts.Quantity__c = 10;
parts.OEM__c = 'Data';
parts.Notes__c = 'Data';
parts.Name = 'Testng';
   insert parts;
CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
parts1.FailurepartId__c = solObj1.id;
parts1.Service_Job__c = pgId;
parts1.Parts_Type__c = 'Custom';
parts1.ReturnToFactory__c = '';
parts1.Fail_Code__c = 'FailCode';
parts1.Account_Code__c = 'AccountCode';
parts1.Service_partnumber__c = 'ServicePartNumber';
parts1.Covered__c = 23;
parts1.Selected_part__c = true;
parts1.Part_size__c = 'Data';
parts1.Option_Number__c = 'DataTesting';
parts1.Part_Description__c = 'DataTesting';
parts1.Assignment__c = 'Test';
parts1.Part_Name__c = 'PartName';
parts1.Replacement_Reason__c = 'Test';
parts1.Quantity__c = 10;
parts1.OEM__c = 'Data';
parts1.Notes__c = 'Data';
parts1.Name = 'Testng';
   insert parts1;
   prtsLst.add(parts);
   prtsLst.add(parts1);
   system.debug('prtsLst'+prtsLst);

Test.startTest();
CSS_UserAddedPartsController obj = new CSS_UserAddedPartsController();
obj.getUserAddedParts();
Test.stopTest();
}
static testMethod void saveUserAddedPartsMethod(){
Test.startTest();
CSS_UserAddedPartsController obj = new CSS_UserAddedPartsController();
obj.saveUserAddedParts();
Test.stopTest();
}

}