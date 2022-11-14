/**********************************************************************
Name:CG_CL_ClaimsAuthorizations_Test
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
this is test class for CG_CL_ClaimsAuthorizations.
===============================================================
===============================================================
History      

-------                                                            
VERSION    AUTHOR                 DATE                  DETAIL                                 
1.0 -      Arpita Sarangee     02/14/2018           INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest
public class CG_CL_ClaimsAuthorizations_Test 
{
    public static Testmethod void CG_CL_ClaimsAuthorizations_Method()
   
    { 
         
        css_claims__c claim = new css_claims__c();
            claim.Rejection_Timestamp__c = Date.today();
            insert claim;
           PageReference pageRef = Page.CG_ClaimsVS;
             Test.setCurrentPage(pageRef);
           ApexPages.CurrentPage().getParameters().put('id', claim.ID);
        test.startTest();
       
        CG_CL_ClaimsAuthorizations claimsAuth = new CG_CL_ClaimsAuthorizations();
        claimsAuth.paccarokbtn = 'Reject';
        Id claimID;
          
        CG_CL_ClaimsIntake claimsIntake = new CG_CL_ClaimsIntake();
     
                
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            testpsnNewRec.psn__c = '79464646';
            testpsnNewRec.Primary__C = true;
            testpsnNewRec.css_claims__C = claim.id;
            insert testpsnNewRec;
    
       
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        User usr = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US',  ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = '56270-56270');
        insert usr;
        system.runAs(usr){
        
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        
        Claimsauth.claimsRec = claim;        
        claimsAuth.mainContr = claimsIntake;        
        CG_CL_ClaimsIntake mainContr = new CG_CL_ClaimsIntake();
        claimID = claim.id;
        claimsAuth.modifyDT = 'test';
        claimsAuth.mainContr = mainContr;
        claimsAuth.saveCatastrophicCheck();
            system.debug('***claimID**'+claimID);          
            ID claimsID1=apexpages.currentPage().getparameters().get('id');
            system.assert(claimsID1!=null);
        claimsAuth.Approvedrejectfrompopup();
        test.stoptest();
        }
    }
   
}