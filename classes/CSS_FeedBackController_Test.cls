/**********************************************************************
Name:CSS_FeedBackController_Test
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:    test class for CSS_FeedBackController                                                        
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 -    rakesh            09-06-2017     INITIAL DEVELOPMENT                    

***********************************************************************/
@isTest
private class CSS_FeedBackController_Test {
       //Method to test the feedback form functionality with system Administrator   
       static testMethod void TestFeedback() { 
           test.startTest(); 
           Profile p = [select id from profile where name='System Administrator'];  
           User u = new User(alias = 'boba', email='standarduser@testorg.com',  
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',  
                          localesidkey='en_US', profileid = p.Id,  
                          timezonesidkey='America/Los_Angeles', username='boba@testorg.com'); 
           System.runAs(u) { 
               CSS_FeedBackController sf= new CSS_FeedBackController();
               String myString = 'StringToBlob';
               Blob myBlob = Blob.valueof(myString);
               //test data creation 
               case cs = css_Testdata.createCase(true,'Feedback');
               sf.stCaseId = cs.Id;
               sf.saveCase();
               sf.showFeedback();
               sf.showPopup1();
               sf.showFeedback();
               sf.caseCommentsDetails();
               sf.getSortvalues();
               sf.closePopup1();
               sf.SendProblem();
               sf.fileBody = myBlob;
               sf.processUpload();
               sf.processUpload(cs.Id);
               sf.replyToProblem();
               sf.getTypeOptions();
               test.stopTest(); 
          }
         
      } 
   
}