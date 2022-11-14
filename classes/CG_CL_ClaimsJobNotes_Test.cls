/* This test class has 3 test methods:
TestForNullValues       - Method that assign null value;
TestForValues           - Method that assign values;
TestForValuesStatusPSN  - Method smilar to TestForValues- has changed status and multipsn Values */


@isTest
public class CG_CL_ClaimsJobNotes_Test {
    
     public static Testmethod void TestForNullValues(){
                  
        string cId = ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = Page.CG_ClaimsJobNotes;
        Test.setCurrentPage(pageRef);
               
        test.startTest();
            CG_CL_ClaimsJobNotes claims = new CG_CL_ClaimsJobNotes();
               claims.nvClaimsIntake();
               claims.nvClaimsWC();
               claims.nvClaimsVH();
               claims.nvClaimsCC();
               claims.nvClaimsFC();
               claims.nvClaimsPSN();
               claims.nvClaimsPOC();
               claims.nvClaimsSRTs();
               claims.nvClaimsJobNotes();
               claims.nvClaimsVS();
               //claims.pgSave();
       test.stopTest();
    }
    
     public static Testmethod void TestForValues(){
          
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
                
        list<css_claims__c> Cl = new list<css_claims__c>();
        css_claims__c claim = new css_claims__c();
                claim.CSS_Job__c=JO.id;
                claim.AccessCode__c='C';
                claim.Multi_PSN_Claim__c = true;
                claim.Status__c = 'Submitted';
                insert claim;
                Cl.add(claim);
                  
         CSS_PSN__c PsnR = new CSS_PSN__c();
                PsnR.Name='Test';
                PsnR.Primary__c = true;
                PsnR.PSN__c = '00800028';
                PsnR.CSS_Claims__c = claim.id;
                insert PsnR;
                
         list<CSS_Solution_Component__c> solcomp = new list<CSS_Solution_Component__c>();
         CSS_Solution_Component__c SC = new CSS_Solution_Component__c();
                SC.Component_Id__c ='F0051000';
                SC.Service_Job__c = JO.id;
                SC.CSS_Claims__c = claim.id;
                SC.Selected_Component__c = true;
                SC.AccountCode__c = 'CZ';
                SC.AccountCodeType__c = 'BJT-ZEUS Commisioning';
                SC.AccountCodeEdit__c = 'BJT-ZEUS Comsioning CZ';
                insert SC;
                solcomp.add(SC);
                  
        PageReference pageRef = Page.CG_ClaimsJobNotes;
        Test.setCurrentPage(pageRef); 
        apexpages.currentPage().getparameters().put('id',claim.id);      

                  
        test.startTest();
            CG_CL_ClaimsJobNotes claims = new CG_CL_ClaimsJobNotes();
               claims.nvClaimsIntake();
               claims.nvClaimsWC();
               claims.nvClaimsVH();
               claims.nvClaimsCC();
               claims.nvClaimsFC();
               claims.nvClaimsPSN();
               claims.nvClaimsPOC();
               claims.nvClaimsSRTs();
               claims.nvClaimsJobNotes();
               claims.nvClaimsVS();
               //claims.clmJobNotesAction();
               claims.claimsRec.FieldActionWebServiceResult__c ='Error';
               claims.CampaignsWSCall();
        test.stopTest();
               
    }
    
    public static Testmethod void TestForValuesStatusPSN(){
          
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
                
        list<css_claims__c> Cl = new list<css_claims__c>();
        css_claims__c claim = new css_claims__c();
                claim.CSS_Job__c=JO.id;
                claim.AccessCode__c='C';
                claim.Multi_PSN_Claim__c = false;
                claim.Status__c = 'Draft';
                insert claim;
                Cl.add(claim);
                  
         CSS_PSN__c PsnR = new CSS_PSN__c();
                PsnR.Name='Test';
                PsnR.Primary__c = true;
                PsnR.PSN__c = '00800028';
                PsnR.CSS_Claims__c = claim.id;
                insert PsnR;
                
         list<CSS_Solution_Component__c> solcomp = new list<CSS_Solution_Component__c>();
         CSS_Solution_Component__c SC = new CSS_Solution_Component__c();
                SC.Component_Id__c ='F0051000';
                SC.Service_Job__c = JO.id;
                SC.CSS_Claims__c = claim.id;
                SC.Selected_Component__c = true;
                SC.AccountCode__c = 'CZ';
                SC.AccountCodeType__c = 'BJT-ZEUS Comsioning';
                SC.AccountCodeEdit__c = 'BJT-ZEUS Comsioning CZ';
                insert SC;
                solcomp.add(SC);
                  
        PageReference pageRef = Page.CG_ClaimsJobNotes;
        Test.setCurrentPage(pageRef); 
        apexpages.currentPage().getparameters().put('id',claim.id);      

                  
        test.startTest();
            CG_CL_ClaimsJobNotes claims = new CG_CL_ClaimsJobNotes();
               claims.nvClaimsCC();
               claims.nvClaimsFC();
               claims.nvClaimsPSN();
               claims.nvClaimsPOC();
               claims.nvClaimsSRTs();
               claims.nvClaimsJobNotes();
               claims.nvClaimsVS();
              // claims.pgSave();
        test.stopTest();
               
    }
     
}