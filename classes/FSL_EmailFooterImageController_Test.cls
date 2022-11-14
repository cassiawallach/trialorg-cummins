@isTest
public class FSL_EmailFooterImageController_Test {
    
    static testMethod void myTestData(){
        
        Document docData = new Document();
        List<Document> docList = new List<Document>();
        Folder foldId = new Folder();
        docData.Name = 'fsl_wave_en';
        docData.Body = Blob.valueOf('Testing');
        docData.ContentType = 'application/pdf';
        docData.DeveloperName = 'my_document';
        docData.IsPublic = true;
        docData.FolderId = [select id from folder where name = 'Communication Related Images'].id;        
        docList.add(docData);
        insert docList;
        FSL_EmailFooterImageController emailcomm = new FSL_EmailFooterImageController();
        emailcomm.getImg();
        
    }
    
}