@IsTest
public class CSS_AttachFileControllerTest {

static testMethod void AttachFileController_method() {

CSS_AttachFileController method = New CSS_AttachFileController();

method.fileName = 'TestName';
method.fileName2 = 'TestName1';
method.fileName3 = 'TestName3';
method.closePopup1 = true;
CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
JO.Customer_Name__c = 'CumminsTnD';
JO.Status__c = 'Repair Complete';
JO.Make__c = 'test1234';
JO.Model__c = 'test1234';
JO.DSID__c = 'test1234';
JO.Equipment_ID__c = 'test1234';
JO.Service_Model__c = 'test1234';
JO.Shop_Work_Order__c = 'test1234';
        JO.INSITE_UpdateTimeStamp__c = system.now();
JO.Repair_Location__c ='Mobile';
//JO.Application__c='Automotive';
JO.Application_Desc__c='Automotive';
JO.Preventive_Maintenance__c = 'Yes';
Jo.Assigned_To__c = UserInfo.getUserId();        
insert(JO);

        List<Attachment>att=new List<Attachment>();    
        Attachment attach = new Attachment();
attach.Name='Unit Test Attachment';
attach.Description='Unit Test Attachment Body';
        //attach.LastModifiedDate=system.now();
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
attach.body=bodyBlob1;
attach.parentId=JO.Id;
insert attach;
att.Add(attach);
method.jobAttach = att;
method.atthid = attach.id;
         //method.filebody = 'gjgfgkfjgklsjgkls';

//PageReferencepageRef = new PageReference('/apex/CSS_JobReadOnly?id=');
//test.setCurrentPage(pageRef);        
       // pageRef.getParameters().put('atthId',attach.id);
        //apexpages.currentPage().getparameters().put(method.atthid,attach.id);

method.editAttachment();
method.processUpload();
method.showPopup1();
method.showPopup5();
method.closePopup();
method.showPopup6();
method.closePopup6();
method.closePopup1();
method.redirectPopup();
method.delAttachment();     
method.getAttach();

}

static testMethod void saveAttachmentTest() {

CSS_AttachFileController method = New CSS_AttachFileController();

method.fileName = 'TestName2';
method.fileName2 = 'TestName4';
method.fileName3 = 'TestName6';
method.closePopup1 = true;
CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
JO.Customer_Name__c = 'CumminsTnD';
JO.Status__c = 'Repair Complete';
JO.Make__c = 'test1234';
JO.Model__c = 'test1234';
JO.DSID__c = 'test1234';
JO.Equipment_ID__c = 'test1234';
JO.Service_Model__c = 'test1234';
JO.Shop_Work_Order__c = 'test1234';
 JO.INSITE_UpdateTimeStamp__c = system.now();
JO.Repair_Location__c ='Mobile';
//JO.Application__c='Automotive';
JO.Application_Desc__c='Automotive';
JO.Preventive_Maintenance__c = 'Yes';
Jo.Assigned_To__c = UserInfo.getUserId();        
insert(JO);

 Test.StartTest();
 Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body1');
 Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body2');
 Blob bodyBlob3=Blob.valueOf('Unit Test Attachment Body3');
  
  CSS_AttachFileController obj = New CSS_AttachFileController();
  obj.fileBody = bodyBlob1;
  obj.fileBody2 = bodyBlob2;
  obj.fileBody3 = bodyBlob3;
  obj.description =  'Test Description';
  obj.description1 = 'Test Description1';
  obj.description2 = 'Test Description2';
  obj.description3 = 'Test Description3';
 obj.sobjid= Jo.Id;
  obj.processUpload();
    //boolean attachmentResult=obj.saveStandardAttachment(JO.Id);
Test.StopTest();

}
}