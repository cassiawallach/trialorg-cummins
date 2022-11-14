@IsTest(seealldata = true)
public class CSS_NotesCaptureClass_Test {
    static testMethod void CSS_NotesCaptureClass_Test_method(){

        Test.startTest();
        
        
                Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced' LIMIT 1];
        UserRole ur = [SELECT id 
                       from UserRole 
                       WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User( Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        
        insert newUser;
        system.runas(newUser){
         CSS_Job_Order__c job1 = new CSS_Job_Order__c(ownerId = newUser.id, Customer_Name__c='Satish Test');
            insert job1;
        
        note nn1 = new note(title='SUPERVISORNOTES', body='Test Test Test', ParentId=job1.id);
        insert nn1;
        note nn2 = new note(title='WRITERNOTES', body='Test Test Test', ParentId=job1.id);
        insert nn2;
        note nn3 = new note(title='TECHNICIANNOTES', body='Test Test Test', ParentId=job1.id);
        insert nn3;
        note nn4 = new note(title='JOURNALNOTES', body='Test Test Test', ParentId=job1.id);
        insert nn4;
         note nn5 = new note(title='PARTSPROFESSIONAL', body='Test Test Test', ParentId=job1.id);
        insert nn5;
        
        CSS_NotesCaptureClass nc= new CSS_NotesCaptureClass();
        
    nc.JobID=job1.id;
    nc.NotesType='';
    nc.NotesBody='';
    nc.nUserId=userInfo.getUserId();
 
    nc.SWLNBody='';
    nc.TCLNBody='';
    nc.SULNBody='';
    nc.EXLNBody='';
     nc.PPLNBody ='';

       //Note nt = new note();
            

        nc.getNotes();        
        
        nc.getSortvalues();
        nc.saveNotes();
        
        Test.stopTest();
        }
    }
    

}