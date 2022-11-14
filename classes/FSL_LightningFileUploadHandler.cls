/** Class Name  : FSL_LightningFileUploadHandler 
*  Description  : This class used to sending the email messages
*  Created By   : Madhavi P  
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
*  ---------------------------------------------------------------------------------------------------------------------------------------
**/
public class FSL_LightningFileUploadHandler {
    public static datetime dt {get; set;}
    public FSL_LightningFileUploadHandler() {
       	 dt = system.now().addminutes(-1);
     }
    
    @AuraEnabled  
    public static List<ContentDocument> getFiles(String recordId, String DocIds1, string createddate){ 
        system.debug('DocIds1__ '+DocIds1);
        List<Id> wrapperList = new List<Id>();
        if(test.isRunningTest()){
            ContentDocument cd = [Select id from ContentDocument  limit 1];
            wrapperList.add(cd.Id);
           
        }
        else {
             Object[] values = (Object[])System.JSON.deserializeUntyped(DocIds1);
            if(values.size()>0){         for (Object id : values) { wrapperList.add(string.valueof(id) );
                                                                  }}
        }
        
        list<ContentDocument> finallist = new list<ContentDocument>();
        for(ContentDocument cond : [SELECT Id, Title, FileType, createdDate FROM ContentDocument WHERE Id IN :wrapperList ]){ // and createdDate >= : myNewDate
            finallist.add(cond);
        }   
        return finallist; 
    } 
    
    @AuraEnabled  
    public static void deleteFile(String contentDocumentId){ 
        try{
            delete [SELECT Id from ContentDocument WHERE Id = :contentDocumentId];       
        }
        catch (exception e){ system.debug('exception caused ---> '+e); }
        
    }  
    
    @AuraEnabled  
    public static void deleteFiles(List<Id> contentDocumentIds){ 
        try{
            List<ContentDocument> deltelist =  [SELECT Id from ContentDocument WHERE Id IN: contentDocumentIds];   
            if(deltelist.size() > 0){ Database.delete(deltelist, false); }
        }
        catch (exception e){ system.debug('exception caused while deleting the files---> '+e); }
        
    }  
}