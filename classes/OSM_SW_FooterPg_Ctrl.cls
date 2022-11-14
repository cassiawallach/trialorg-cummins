//For Testing Purpose
public class OSM_SW_FooterPg_Ctrl {
    
    public String pdfURL {get;set;}
    public Integer Year {get;set;}
    public OSM_SW_FooterPg_Ctrl (){
    footerPDF();
        Year = Date.Today().Year();
    }
    
    public void footerPDF(){
    List<Document> documentsLst = new List<Document>();
    Document documents;
    
     documentsLst = [SELECT Id, FolderId, Folder.Name FROM Document WHERE name= 'DocumentsTnC' LIMIT 1];
        
        if(documentsLst!=null && documentsLst.size()>0){
            documents = documentsLst.get(0);
            pdfURL = label.OSM_DEV_URL+documents.id;
         }
    
    
    system.debug('>>>>>'+pdfURL);
  
    }
}