@isTest
public class CG_ClaimsPSNWrapperTest {
    
    static TestMethod void psnNewRec() {
        
        Test.startTest();
        CSS_Claims__c claimRec= new CSS_Claims__c();
        insert claimRec;
        
        CSS_PSN__c psnRec = new CSS_PSN__c();
        
        psnRec.Unit_Number__c ='786';
        psnRec.Application__c = '888';
        psnRec.Before_In_Service__c = true;
        psnRec.Calibration_After__c ='after123';
        psnRec.Calibration_Before__c = 'before321';
     	psnRec.CSS_Claims__c = claimRec.id;
        
        psnRec.Failure_Date__c = date.today();
		//psnRec.Justification__c        
        //psnRec.License_Plate_State__c
        psnRec.Mission_Disabling__c = true;
        psnRec.Primary__c = true;
        psnRec.Model__c = 'abcd';
        psnRec.Product_Hours__c = 22;
        psnRec.Qsol_Engine_Family_Code__c = 'you90';
        psnRec.Qsol_Technical_Config__c =  'user56';
        psnRec.Qsol_Warranty_Start__c = 'user45';    
        psnRec.Service_Model__c = 'type5';
        psnRec.Unit_Type__c = 'type3';
        psnRec.VIN__c = 'type7';
        psnRec.Warranty_Start_Date__c = date.today()+10;
        insert(psnRec);
        
        CG_ClaimsPSNWrapper psnNewRec = new CG_ClaimsPSNWrapper(psnRec);        
        Test.stopTest();
        
    } 
}