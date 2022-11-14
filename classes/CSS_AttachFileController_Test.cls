@IsTest
public class CSS_AttachFileController_Test {
    Blob fileBody = Blob.valueOf('Unit Test Attachment Body1');
    Blob fileBody2 = Blob.valueOf('Unit Test Attachment Body2');
    Blob fileBody3 = Blob.valueOf('Unit Test Attachment Body3');

    static testMethod void CSS_AttachFileController_Test()
    {       
        //Add test data for Service job order                
        Test.startTest();  
        Blob fileBody = Blob.valueOf('Unit Test Attachment Body1');
        Blob fileBody2 = Blob.valueOf('Unit Test Attachment Body2');
        Blob fileBody3 = Blob.valueOf('Unit Test Attachment Body3');
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Roopa';
        JO.Model__c = 'RoopaTest';
        JO.Make__c = 'CSSTest';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c ='Miles';
        JO.VIN__c='12345677890';
        JO.Failure_Date__c =date.today()-20;
        JO.Warranty_Start_Date__c =date.today()-365;
        JO.Location_Certification__c='abc';
        JO.jobLocation__c='abc';
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c='79464646';
        JO.jobLocation__c ='tyfsdytw';
        insert(JO);

        ApexPages.currentPage().getParameters().put('id',jo.Id);            

        PageReference p1=Page.CG_IntakeCustomer; 
        Test.setCurrentPage(p1);  
        ApexPages.currentPage().getParameters().put('id',jo.Id); 



        //  list<Attachment> attachmentList = new list<Attachment>();
        Attachment attach2 = new Attachment();  
        attach2.Name='Unit Test Attachment';
        attach2.Description = 'Sam';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach2.body=bodyBlob;
        attach2.parentId=jo.id;
        insert attach2;   

        /*        Attachment attachment = new Attachment();
            Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');// attachment.body = 'Sam'; ///this.fileBody;
             attachment.name = 'Sam'; //this.fileName;
            attachment.description = 'Sam'; // description1;
            attachment.parentId = jo.id;

            Attachment attachment2 = new Attachment();
            Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');  //   attachment2.body = 'Sam'; //this.fileBody2;
            attachment2.name = 'Sam'; //this.fileName2;
            attachment2.description = 'Sam'; //description2;
            attachment2.parentId = jo.id; //parentId;

            Attachment attachment3 = new Attachment();
           Blob bodyBlob3=Blob.valueOf('Unit Test Attachment Body');  //  attachment3.body = 'Sam';  //this.fileBody3;
            attachment3.name = 'Sam';  //this.fileName3;
            attachment3.description = 'Sam';  //description3;
            attachment3.parentId = jo.id;  //parentId;
            */

        // attachmentList.add(attach);

        Attachment attach1=new Attachment();  

        attach1 =  [Select Id, Name, Description from attachment where id= :attach2.id];


        //Add test data for intake page
        //     css_intake_job_R2 intakeJob= new css_intake_job_R2();
        CSS_AttachFileController intakeJob= new CSS_AttachFileController();
        intakeJob.fileBody = Blob.valueOf('Unit Test Attachment Body1');
        intakeJob.processUpload();

        //intakeJob.updateNotes();
        intakeJob.atthId=attach1.id;
        intakeJob.fileName = 'Roopa';
        intakeJob.fileName2 = 'Santosh';
        intakeJob.fileName3 = 'Anvesh';
        intakeJob.atthName = 'abc'; 
        intakeJob.description = 'abcd';
        intakeJob.sEncryptToken = 'sEncryptToken';
        intakeJob.sEndPoint = 'sEndPoint';
        intakeJob.statusCode = 200;
        intakeJob.statusMessage = 'statusMessage';
        intakeJob.sFileName = 'sFileName';
        intakeJob.attachId = 'attachId';
        intakeJob.showPopup5(); 
        intakeJob.editAttachment();
        intakeJob.delAttachment();           
        intakeJob.processUpload();
        intakeJob.showPopup1();
        intakeJob.displayPopup5 = true;
        intakeJob.closePopup();
        intakeJob.showPopup6();
        intakeJob.closePopup6();
        intakeJob.closePopup1();
        intakeJob.closePopup1 = true;
        intakeJob.redirectPopup();
        intakeJob.getAttach();
        intakeJob.getAttachment('attachObjId');
        intakeJob.createAttachment(fileBody);
        intakeJob.getFile();


        Test.stopTest();

    }
}