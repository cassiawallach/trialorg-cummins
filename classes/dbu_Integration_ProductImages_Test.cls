@isTest
public class dbu_Integration_ProductImages_Test {
    static testmethod void method1(){
        //added prod deployement
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='dbu_ProductImage';
        conDetails.End_Point__c= 'https://api-ue-stgnf4-aw-ex.cummins.com/pcc/v1/catalogs/graphics?type=part&name=200517_iso.png';
        conDetails.Method_Type__c= 'GET';
        conDetails.grant_type__c= 'application/json';
        insert conDetails;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name='dbu_ProductImageAccessToen';
        conDetails1.End_Point__c= 'https://api-ue-stgnf4-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
        conDetails1.Method_Type__c= 'POST';
        conDetails1.grant_type__c= 'application/json';
        conDetails1.Key__c ='122c334d-a6a9-4d7f-bfae-78b78902b04d';
        conDetails1.Passcode__c='69veMf-iaMv-CiDIpkM-X_9-84te5X.-l_';
        insert conDetails1;
        
        Document  documentObj = new Document();
        documentObj.Body = Blob.valueOf('test');
        documentObj.IsPublic = true;
        documentObj.Name = 'https://api-ue-stgnf4-aw-ex.cummins.com/pcc/v1/catalogs/graphics?type=part&name=200517_iso.png';
        documentObj.FolderId = [select id from folder where name =: 'Public'].id;
        insert documentObj;
        
        test.startTest();
        dbu_Integration_ProductImages.getAccessToken();
        dbu_Integration_ProductImages.getProductImages('https:/partsmedia.cummins.com/graphics/parts/310/3103596/3103596_iso.png');
        dbu_Integration_ProductImages.insertImageData('https:/partsmedia.cummins.com/graphics/parts/310/3103596/3103596_iso.png','tests');
        // dbu_Integration_ProductImages.insertImageData('','tests');
        test.stopTest();
    }
    
     static testmethod void method2(){
        
        test.startTest();
        //dbu_Integration_ProductImages.getAccessToken();
        dbu_Integration_ProductImages.getProductImages('https://partsmedia.cummins.com/graphics/parts');
         
         
       // dbu_Integration_ProductImages.insertImageData('https://api-ue-stgnf4-aw-ex.cummins.com/pcc/v1/catalogs/graphics?type=part&name=200517_iso.png','tests');
         dbu_Integration_ProductImages.insertImageData('','tests');
         
        test.stopTest();
    }
    
}