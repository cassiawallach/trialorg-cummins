@isTest
public class CG_CL_AttachmentComp_Test {
    
    Public static testMethod void CG_CL_AttachmentComp_Test1(){
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Test-KG';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        //JO.lo = 10;
        //JO.Shop_s_Work_Order__c = 120;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        insert(JO);
        list < Attachment > attachmentList = new list < Attachment > ();
        Attachment attach = new Attachment();
        attach.Name = 'Unit Test Attachment1';
        Blob bodyBlob1 = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob1;
        attach.parentId = jo.id;
        attachmentList.add(attach);
        
        Attachment attach1 = new Attachment();
        attach1.Name = 'Unit Test Attachment2';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach1.body = bodyBlob;
        attach1.parentId = jo.id;
        attachmentList.add(attach1);
        
        insert attachmentList;
        //ApexPages.Standardcontroller sc1 = New ApexPages.StandardController(jo);
        PageReference pg = Page.CG_IntakeRJ;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('id',jo.id);
        
        CG_CL_AttachmentComp cg=new CG_CL_AttachmentComp();
        cg.atthId = attach1.id;
        cg.atthName ='Test123.txt';
        cg.DeleteFlg = false;
        cg.description='test1';
        cg.description1='test1';
        cg.description2='test1';
        cg.description3='test1';
        cg.displayPopup=true;
        cg.displayPopup5=true;
        cg.displayPopup6=true;
        cg.fileBody=Blob.valueOf('Unit Test Attachment Body5');
        cg.fileBody2=Blob.valueOf('Unit Test Attachment Body6');
        cg.fileBody3=Blob.valueOf('Unit Test Attachment Body7');
        cg.fileName='Test Attch5';
        cg.fileName2='Test Attch6';
        cg.fileName3='Test Attch7';
        cg.PageName = 'IntakeRJ';
        cg.processUpload();
        cg.getAttach();
        cg.editAttachment();
        cg.delAttachment();
        cg.DeleteFile();
        cg.redirectPopup();
        cg.closePopup();
        cg.closePopup1();
        cg.closePopup6();
        
        try{
            cg.showPopup1();
            cg.showPopup5();
           
            cg.showPopup7();
            cg.showPopup6();
        }
        Catch(exception e){
            
        }
        
    }
    Public static testMethod void CG_CL_AttachmentComp_Test2(){
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Test-KG';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RoopaTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        //JO.lo = 10;
        //JO.Shop_s_Work_Order__c = 120;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        insert(JO);
        list < Attachment > attachmentList = new list < Attachment > ();
        Attachment attach = new Attachment();
        attach.Name = 'Unit Test Attachment1';
        Blob bodyBlob1 = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob1;
        attach.parentId = jo.id;
        attachmentList.add(attach);
        
        Attachment attach1 = new Attachment();
        attach1.Name = 'CGJBTLATT03-Attachment2';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach1.body = bodyBlob;
        attach1.parentId = jo.id;
        attachmentList.add(attach1);
        
        insert attachmentList;
        //ApexPages.Standardcontroller sc1 = New ApexPages.StandardController(jo);
        PageReference pg = Page.CSS_JobPlanParts;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('id',jo.id);
        
        CG_CL_AttachmentComp cg=new CG_CL_AttachmentComp();
        cg.atthId = attach1.id;
        cg.atthName ='Test123.txt';
        cg.DeleteFlg = false;
        cg.description='test1';
        cg.description1='test1';
        cg.description2='test1';
        cg.description3='test1';
        cg.displayPopup=true;
        cg.displayPopup5=true;
        cg.displayPopup6=true;
        cg.closePopup1 = true;
        //cg.
        cg.fileBody=Blob.valueOf('Unit Test Attachment Body5');
        cg.fileBody2=Blob.valueOf('Unit Test Attachment Body6');
        cg.fileBody3=Blob.valueOf('Unit Test Attachment Body7');
        cg.fileName='Test Attch5';
        cg.fileName2='Test Attch6';
        cg.fileName3='Test Attch7';
        cg.PageName ='Jobplan';
        
        cg.processUpload();
        cg.editAttachment();
        cg.delAttachment();
        cg.DeleteFile();
         cg.showPopup6();
        
        
    }
    Public static testMethod void CG_CL_AttachmentComp_Test3(){
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Test-KG';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RaTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        //JO.lo = 10;
        //JO.Shop_s_Work_Order__c = 120;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        insert(JO);
        list < Attachment > attachmentList = new list < Attachment > ();
        Attachment attach = new Attachment();
        attach.Name = 'Unit Test Attachment1';
        Blob bodyBlob1 = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob1;
        attach.parentId = jo.id;
        attachmentList.add(attach);
        
        Attachment attach1 = new Attachment();
        attach1.Name = 'CGJBTLATT03-Attachment2';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach1.body = bodyBlob;
        attach1.parentId = jo.id;
        attachmentList.add(attach1);
        
        insert attachmentList;
        //ApexPages.Standardcontroller sc1 = New ApexPages.StandardController(jo);
        PageReference pg = Page.CG_IntakeWarranty;
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('id',jo.id);
        
        CG_CL_AttachmentComp cg=new CG_CL_AttachmentComp();
        cg.atthId = attach1.id;
        cg.atthName ='Test123.txt';
        cg.DeleteFlg = false;
        cg.description='test1';
        cg.description1='test1';
        cg.description2='test1';
        cg.description3='test1';
        cg.displayPopup=true;
        cg.displayPopup5=true;
        cg.displayPopup6=true;
        cg.closePopup1 = true;
        //cg.
        cg.fileBody=Blob.valueOf('Unit Test Attachment Body5');
        cg.fileBody2=Blob.valueOf('Unit Test Attachment Body6');
        cg.fileBody3=Blob.valueOf('Unit Test Attachment Body7');
        cg.fileName='Test Attch5';
        cg.fileName2='Test Attch6';
        cg.fileName3='Test Attch7';
        cg.PageName ='IntakeWR';
        cg.processUpload();
        cg.editAttachment();
        cg.delAttachment();
        cg.DeleteFile();
        cg.showPopup7();
        
        
    }
    
}