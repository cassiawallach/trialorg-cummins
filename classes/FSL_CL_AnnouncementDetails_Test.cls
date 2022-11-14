//Comment added for deployment - Jan 22 Release
//Comment added for deployment - Mar 22 Release_2
@isTest
public class FSL_CL_AnnouncementDetails_Test {
    public static testmethod void getAnnouncementsTestMethod() { 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        System.debug([SELECT Id FROM Profile limit 100]);
        /*User u = new User(Alias = 'test', Email='standarduser@testorg.com.gdnz', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',ERP__c='BMS', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.gdnz',
                          State = 'Nevada', City = 'Naperville', Country = 'United States', 
                          street = '2526', PostalCode = '12345');
        
        Insert u;*/
        
        FSL_Announcements_Data__c annData = new FSL_Announcements_Data__c();
        annData.Description__c = 'Hello Guidanz';
        annData.Category__c = 'Scrolling Text';
        annData.Type__c = 'Dealer';
		insert annData;
        
        FSL_Switch__c switchMatrix = new FSL_Switch__c();
        switchMatrix.Name = 'Announcement';
        switchMatrix.IsActive__c = true;
        switchMatrix.User_Type__c = 'Dealer';
        insert switchMatrix;
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=annData.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers';
        insert contentlink;
        
        //System.runAs(u) {
        FSL_CL_AnnouncementDetails annDetails = new FSL_CL_AnnouncementDetails();
	    FSL_CL_AnnouncementDetails.getAnnouncements();
        FSL_CL_AnnouncementDetails.getSingleRecord();
        FSL_CL_AnnouncementDetails.getAllAnnouncements();
        FSL_CL_AnnouncementDetails.getRelatedFilesByRecordId(annData.Id);
        FSL_CL_AnnouncementDetails.fetchUserRole();
        FSL_CL_AnnouncementDetails.fetchAdminRole();
        FSL_CL_AnnouncementDetails.fetchPSNValue();
        
        //}
    } 
}