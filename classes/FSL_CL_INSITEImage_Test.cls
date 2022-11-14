/*
* Test Class for Apex Controller - FSL_CL_INSITEImage
* Author - Piyush Rani
*/ 
@isTest
public class FSL_CL_INSITEImage_Test {
    
    @isTest
    static void fetechWorkOrder_Test() {
        Test.startTest();
        
        WorkOrder wo = new WorkOrder(
            Before_Image__c = 'SI-20191001-164805455-279FD267',
            INSITE_Work_Order_Image_Name__c = 'SI-20191001-164805455-279FD267',
            FaultCode_Max_Sequence__c = 1,
            ServiceTerritoryId = FSL_TestDataUtility.createServiceTerritory().Id
            //X18_Char_Id_Text__c = 'TestX18'
        );
        insert wo;
        
        CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c(
            Name = 'InsiteImage',
            ApplicationName__c = 'InsiteImage',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = true,
            Key__c = '7r7F6tyJlMmmC6JHSUMqK6dEUPvhL172LYrK6URZB3zKLO45503MD61NA8STQCRvGn7Qroo3CkG7RRlFe9Bw==',
            Passcode__c = '7r7F6tyJlMmmC6JHSUMqK6dEUPvhL172LYrK6URZB3zKLO45503MD61NA8LSTQCRvGn7Qroo3CkG7RRlFe9Bw==/RGXlTOu8ik=',
            Username__c = 'wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO5QlGuxTVNg/ly+0Sy1nWe57U01ngfRWq9ogg3q6LfncwdAZmBg==='
        ); 
        insert inteDetails;
        
        WorkOrder testWO = FSL_CL_INSITEImage.fetechWorkOrder(wo.Id);
        
        //Coverage for updateBeforeImage()
        String newImage = 'SI-20191001-164805455-279FD268';
        
        FSL_CL_INSITEImage.updateBeforeImage(newImage, wo.Id);
        FSL_CL_INSITEImage.updateAfterImage(newImage, wo.Id);
        Id eifRecId = FSL_CL_INSITEImage.getAfterImageFile(wo.Id, 'eif');
        Id csvRecId = FSL_CL_INSITEImage.getAfterImageFile(wo.Id, 'csv');
        Test.stopTest();
    }
    
    @isTest
    static void getFile_Test() {
        Test.startTest();
        
        WorkOrder wo = new WorkOrder(
            Before_Image__c = 'SI-20191001-164805455-279FD267',
            INSITE_Work_Order_Image_Name__c = 'SI-20191001-164805455-279FD267',
            FaultCode_Max_Sequence__c = 1,
           // X18_Char_Id_Text__c = 'TestX18',
            ServiceTerritoryId = FSL_TestDataUtility.createServiceTerritory().Id
        );
        insert wo;
        
        //
        CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c(
            Name = 'InsiteImage',
            ApplicationName__c = 'InsiteImage',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = true,
            Key__c = '7r7F6tyJlMmmC6JHSUMqK6dEUPvhL172LYrK6URZB3zKLO45503MD61NA8STQCRvGn7Qroo3CkG7RRlFe9Bw==',
            Passcode__c = '7r7F6tyJlMmmC6JHSUMqK6dEUPvhL172LYrK6URZB3zKLO45503MD61NA8LSTQCRvGn7Qroo3CkG7RRlFe9Bw==/RGXlTOu8ik=',
            Username__c = 'wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO5QlGuxTVNg/ly+0Sy1nWe57U01ngfRWq9ogg3q6LfncwdAZmBg==='
        ); 
        insert inteDetails;
        
        Id eifFileID = FSL_CL_INSITEImage.getFile(wo.Id, 'eif');
        Id csvFileID = FSL_CL_INSITEImage.getFile(wo.Id, 'csv');
        
        Attachment attachObj = new Attachment();
        attachObj.Name = 'Unit Test Attachment';
        attachObj.Description = 'Unit Test Attachment Description';
        attachObj.ParentId = wo.Id;
        attachObj.ContentType = 'application/octet-stream';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attachObj.Body = bodyBlob;
        insert attachObj;
        
        String  attachStr =  FSL_CL_INSITEImage.getAttachment(attachObj.Id);
        
        Test.stopTest();
    }
}