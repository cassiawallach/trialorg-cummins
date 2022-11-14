@istest
public class EVL_EmailPartsController_Test {
    @istest
    public static void testsendMailMethod(){
         Account acc = new Account();
            acc.Name = 'East Bronx1'; 
            acc.CMI_Account_Status__c = 'Active';
            acc.PaymentType__c = 'Cash';
            acc.FSL_ERP_Customer_Code__c = '48923';
            acc.FSL_Credit_Limit__c = 78888.5;
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
            ast.AccountId = acc.Id;        
            insert ast;
        
            Case  cs = new Case();
            cs.Status = 'Intake';
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
            wo1.sub_status__c = 'Troubleshooting Complete';
            wo1.AccountId = acc.Id;
            wo1.AssetId = ast.Id;
            wo1.CaseId = cs.Id;
            insert wo1;
        Boolean sendSuccess=EVL_EmailPartsController.sendMailMethod('test@gmail.com','test','test',wo1.id);
        system.assertEquals(true, sendSuccess);
    }

}