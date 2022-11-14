//Adding comment for deployment -- Akansha MV_688 8/25/2022

@isTest
public class FSL_FindEmailImage_Test {
    
    public static testMethod void getEmailCommMethod(){
        
        Document doc = new Document();
        doc.Body = Blob.valueOf('CommImage');
        doc.ContentType = 'application/pdf';
        doc.DeveloperName = 'my_document';
        doc.IsPublic = true;
        doc.Name = 'My Document';
        doc.FolderId = [select id from folder where name = 'Communication Related Images'].id;
        insert doc;
        List<Document>doclist = new List<Document>();
        doclist.add(doc);
        Test.startTest();
        FSL_FindEmailImage controller = new FSL_FindEmailImage();
        controller.img = doclist;
        controller.langPrefDocName = 'EN';
        doclist = controller.getImg();
        Test.stopTest();
    } 

}