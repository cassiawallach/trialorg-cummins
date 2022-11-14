public class FSL_FindEmailImage{
    @TestVisible private List<Document> img;
    public string langPrefDocName {get;set;}
    public string envURL{get;set;}
    public string OrgIdLabel{get;set;}
    private string headerFileName; //change from global to private as part of NIN_491 -Trupti
    
    public FSL_FindEmailImage() {
       //img = [SELECT Id,Body FROM Document WHERE name=:langPrefDocName];//'EN'
        envURL=URL.getSalesforceBaseUrl().toExternalForm();
        //OrgIdLabel = system.Label.OrganizationID; 
        OrgIdLabel = userInfo.getOrganizationId();
       
    }

/*    public List<Document> getImg() {
        //envURL=URL.getSalesforceBaseUrl().toExternalForm();
        headerFileName = (langPrefDocName == 'FR') ? 'CommunicationHeader_FR_CA' : 'CommunicationHeader_EN';
        img = [SELECT Id,Body FROM Document WHERE Name=:headerFileName];//need to change with an langPrefDocName varable
        return img;
    }*/
    
    public List<Document> getImg() {
        //envURL=URL.getSalesforceBaseUrl().toExternalForm();
        
        switch on langPrefDocName {
            when 'fr','FR' { headerFileName = 'CommunicationHeader_FR_CA'; }
            when 'es', 'ES' { headerFileName = 'CommunicationHeader_es'; }
            when 'tr', 'TR' { headerFileName = 'CommunicationHeader_tr'; }
			when 'de', 'DE' { headerFileName = 'CommunicationHeader_DE'; }
            when else { headerFileName = 'CommunicationHeader_EN'; }
        }

        img = [SELECT Id,Body FROM Document WHERE Name=:headerFileName];//need to change with an langPrefDocName varable
        return img;
    }     
}