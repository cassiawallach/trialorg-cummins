public class FSL_EmailFooterImageController {
    private List<Document> img;
    public string envURL{get;set;}
    public string OrgIdLabel{get;set;}
    public FSL_EmailFooterImageController() {
       //img = [SELECT Id,Body FROM Document WHERE name=:langPrefDocName];//'EN'
       envURL=URL.getSalesforceBaseUrl().toExternalForm();
       OrgIdLabel = userInfo.getOrganizationId();
    }
    public List<Document> getImg() {
        //envURL=URL.getSalesforceBaseUrl().toExternalForm();
        //img = [SELECT Id,Name,Body FROM Document];//need to change with an langPrefDocName varable
        img = [SELECT Id,Name,Body FROM Document where Name in('FSLEmailInstagramImage','FSLEmailPinterestmage','FSLEmailTwitterImage','FSLFacebookImage')];//need to change with an langPrefDocName varable
        return img;
    }

}