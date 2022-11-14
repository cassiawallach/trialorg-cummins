public class FSL_FileUploadController {
	
    @AuraEnabled
    public static void updateWorkOrder(List<Id> contentIds){
        system.debug('contentIds===='+contentIds);
        set<Id> setIds = new set<Id>();
        //map<Id, set<String>> mapParentIdFilenames = new map<Id, set<String>>();
        map<Id, list<String>> mapParentIdFilenames = new map<Id, list<String>>();
        map<Id, list<String>> mapParentIdFileId = new map<Id, list<String>>();
        //map<String, String> mapParentIdFilenames = new map<String, String>();
        //map<String, String> mapParentIdFileIds = new map<String, String>();
        if(contentIds != null && contentIds.size()>0) {
            for (ContentDocumentLink cdlIterator : [SELECT Id, ContentDocumentId, LinkedEntityId, ContentDocument.Title, ContentDocument.FileExtension 
                                                    FROM ContentDocumentLink 
                                                    WHERE ContentDocumentId IN :contentIds
                                                   ]) {
                String strObjPrefix = String.valueOf(cdlIterator.LinkedEntityId).substring(0, 3);
            	system.debug('strObjPrefix===='+strObjPrefix);
            	if(strObjPrefix == workorder.sObjectType.getDescribe().getKeyPrefix()) {
					setIds.add(cdlIterator.LinkedEntityId);
            	}
                system.debug('mapParentIdFilenames=###==='+cdlIterator.ContentDocument.Title);
                if (!mapParentIdFilenames.containsKey(cdlIterator.LinkedEntityId)) {
                    mapParentIdFilenames.put(cdlIterator.LinkedEntityId, new list<String>());
                }
                mapParentIdFilenames.get(cdlIterator.LinkedEntityId).add(cdlIterator.ContentDocument.Title+'~'+cdlIterator.ContentDocumentId);
                                                       
                
            }
            
            system.debug('mapParentIdFilenames===='+mapParentIdFilenames);
        }
        URL currentURL = URL.getCurrentRequestUrl();
        String host= URL.getSalesforceBaseUrl().toExternalForm();
        String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm();
        system.debug('fullRecordURL====='+fullRecordURL);
        // Get the URL for the current request.
        String currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
        System.debug('Current request URL:====== ' + currentRequestURL);  
        
        String Cssp_FileUploadUrl = Label.Cssp_FileUploadUrl;
        system.debug('Cssp_FileUploadUrl===='+Cssp_FileUploadUrl);
		system.debug('==host==='+host);
		
        
        if(!setIds.isEmpty()) {
            list<workorder> lstCases= new list<workorder>();
            for(workorder cObj: [SELECT Id, Cssp_File_Name_Link__c FROM workorder WHERE Id IN :setIds]){
                if(!mapParentIdFilenames.isEmpty() && mapParentIdFilenames.containsKey(cObj.Id))
                {
                    List<string> slist = mapParentIdFilenames.get(cObj.Id);
                    String strFName = '';
                    for(integer i =0; i < slist.size(); i++)
                    {
                        string allstring = sList[i];
                        String[] strArray = allstring.split('~');
                        //http://na2.salesforce.com/servlet/servlet.Download?file=00PR0000000MqVH 
                        //String strlink = '<a href="/servlet/servlet.FileDownload?file=\''+ strArray[1]+'\'">'+strArray[0]+'</a>';
                        system.debug('host===='+host);
                //  <a href="https://cumminscss--gdnzdev1.lightning.force.com/lightning/r/ContentDocument/0693C000000w41JQAQ/view">package</a>
             
                        String strlink = '<a href="'+Cssp_FileUploadUrl+strArray[1]+'/view">'+strArray[0]+'</a>'; 
                        //String strlink = '<a href="'+host+'/servlet/servlet.FileDownload?file=\''+ strArray[1]+'\'">'+strArray[0]+'</a>';
                 //       String strlink = '<a href="'+host+'/servlet/servlet.FileDownload?file=\''+ strArray[1]+'\'">'+strArray[0]+'</a>';
                        strFName += strlink+'\n';
                    }
                    cObj.Cssp_File_Name_Link__c = strFName;
                    lstCases.add(cObj);
                    
                    /*string allstring = mapParentIdFilenames.get(cObj.Id);
                    String strid = mapParentIdFileIds.get(cObj.Id);
                    //allstring+= 'HYPERLINK(\'/servlet/servlet.FileDownload?file=\'' + strid+', \'View\', \'_blank\')';
                    allstring = '<a href="/servlet/servlet.FileDownload?file=\''+ strid+'\'">'+allstring+'</a>';
                    cObj.FSL_File_Name__c = allstring;
                    lstCases.add(cObj);*/
                }
            }
            system.debug('lstCases==b=='+lstCases);
            FSL_workorderListTriggerHandle.avoidAfterupdate = true;
            update lstCases;
            system.debug('lstCases===='+lstCases);
        }
    }
    
    
    @AuraEnabled
    public static FileWrapper getFilesList(List<Id> linkedEntyIds){
        FileWrapper wrap = new FileWrapper();
        wrap.contentDocList = [SELECT ContentDocumentId, ContentDocument.Title, LinkedEntityId, ContentDocument.CreatedDate FROM ContentDocumentLink where LinkedEntityId IN: linkedEntyIds ORDER BY ContentDocument.CreatedDate DESC];
        return wrap;
    }
    
    @AuraEnabled
    public static void deleteSelectedFiles(List<Id> contentDocIds){
        List<Sobject> sobjLst = new List<SObject>();
        for(Id recId : contentDocIds){
            ContentDocument cd = new ContentDocument(Id = recId); 
            sobjLst.add(cd);
        }
        if(!sobjLst.isEmpty()){
            delete sobjLst;
        }
    }
    
    public class FileWrapper{
        @AuraEnabled
        public List<ContentDocumentLink> contentDocList {get;set;}
    }
}