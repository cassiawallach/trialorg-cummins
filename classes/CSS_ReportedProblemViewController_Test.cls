/**********************************************************************
Name:CSS_ReportedProblemViewController_Test
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:   Test class for CSS_ReportedProblemViewController_Test                                                         
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 -  Shanthi     06/07/2017      INITIAL DEVELOPMENT  
***********************************************************************/
@isTest
public class CSS_ReportedProblemViewController_Test
{
    static testMethod void reportedProblemCntrltest(){
    
     test.startTest(); 
       
       PageReference pageRef = Page.Css_ReportedProblemView;
       Test.setCurrentPage(pageRef);
       Profile p = [select id from profile where name='System Administrator'];  
       User u = new User(alias = 'boba', email='standarduser@testorg.com',  
                      emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',  
                      localesidkey='en_US', profileid = p.Id,  
                      timezonesidkey='America/Los_Angeles', username='boba@testorg.com'); 
       System.runAs(u) { 
         //  CSS_Reported_Solutions_Problem__c report= new CSS_Reported_Solutions_Problem__c (name='test',User_ID__c=u.id); 
         //  insert report;
                      CSS_ReportedProblemViewController sf= new CSS_ReportedProblemViewController();
                    
           Case cs = new case();
           cs.SuppliedEmail = 'test@gmail.com';
           cs.SuppliedPhone = '1234567898';
           cs.Type = 'Problem';
           cs.status = 'New';
           cs.Subject = 'wewew';
           cs.Description = 'gsdsgdsd';
          // cs.Recordtype.name='Reported_Problem';
           insert cs;
             sf.stCaseId =cs.id;
             sf.advanceUserFlag=true;
             sf.boldFlag=true;
           sf.showCasesForAdvUser();
          //sf.caseCommentsDetails();
           sf.SendProblem();
           sf.close();
           sf.boldUnboldshowupdate();
           sf.closePopup1();
          sf.replyToProblem();
     
           test.stopTest(); 
      }
        
    }
}