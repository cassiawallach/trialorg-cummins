@isTest
public class CG_CL_ClaimsPartsFromBMS_Test {
    
    public static testMethod void CG_CL_ClaimsPartsFromBMS_TestMethod1(){
         css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='56749876';
        insert jo;
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Customer_Name__c='Gopal';
        claims.Customer_Code__c='123';
        claims.ESN__c='56749876';
        claims.CSS_Job__c=jo.id;
        insert claims;
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        sol.Name='Testing';
        insert sol;
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.Service_Job__c=jo.Id;
        solcomp.Solutions__c=sol.Id;
        solcomp.AccountCodeEdit__c='Testing';
        solcomp.Fail_Code_Editable__c='Testing Failcode';
        solcomp.Type__c='ATC';
        solcomp.Pay_Code__c='A';
        insert solcomp;
        id partsrecodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();    
        css_parts_options__c patop = new css_parts_options__c();
        patop.Parts_Type__c = 'Custom';
        patop.RecordTypeId=partsrecodid;
        patop.Service_Job__c=jo.id;
        patop.Solutions__c=sol.id;
        patop.CSS_Claims__c=claims.Id;
        patop.Quantity__c=3;
        patop.Sell_Price__c=4;
        patop.Covered__c=4;
        insert patop;
        css_parts_options__c patop1 = new css_parts_options__c();
            patop1.Parts_Type__c = 'Custom';
            patop1.RecordTypeId=partsrecodid;
            patop1.Service_Job__c=jo.id;
            patop1.Solutions__c=sol.id;
            patop1.CSS_Claims__c=claims.Id;
            patop1.FailurepartId__c=solcomp.id;
            patop1.Fail_Code__c='';
        patop1.ReturnToFactory__c='';
         patop1.Quantity__c=3;
        patop1.Sell_Price__c=4;
        patop1.Covered__c=4;
        insert patop1;
         PageReference pref;
        pref = new PageReference('/'+claims.id);
        pref.getParameters().put('id',claims.id);
        Test.setCurrentPage(pref);
        test.startTest();
        CG_CL_ClaimsPartsFromBMS cla = new CG_CL_ClaimsPartsFromBMS();
        
        test.stopTest();
        
    }
    }