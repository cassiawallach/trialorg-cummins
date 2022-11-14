//Modified by Krishna to Without Sharing to fix the Location issue
public without sharing class FSL_NotesController {
    public static list<notesWrapper> SWriterNotes {get;set;}
    public static list<Note> JobNotesList{get;set;}
    
    @AuraEnabled
    public static List<notesWrapper> fetchNoteRecords(string recordId, String sortOrder) {
        String direction = sortOrder == null  ? 'asc' : sortOrder;
        //Added below line as part of FBI - 383
        String queryString = 'Select Id,Body,title,CreatedBy.firstname, CreatedDate, CreatedBy.lastname, LastModifiedDate, CreatedById from Note where parentid= :recordId order by CreatedDate '+ String.escapeSingleQuotes(direction) + ' LIMIT 1000' ; 
        JobNotesList = Database.query(queryString);
        List<notesWrapper> notes = new List<notesWrapper>();
        
        for(Note n: JobNotesList){
            notes.add(new notesWrapper(n));
        }
        return notes;
    }
    
    @AuraEnabled
    public static String fetchUser(){
        // query current user information  
        User oUser = [select id,Name,Username,IsActive,Profile.Name
                      FROM User Where id =: userInfo.getUserId()];
        String userProfile = oUser.Profile.Name;
        return userProfile;
    }
    //TW-87 Karthik Pedditi Error Logging Changes
    @AuraEnabled
    public static String saveNotesDetails(String configData) {
        System.debug(':::Data - '+configData);
        String getMessage;
        
        DataWrapper config = (DataWrapper)JSON.deserialize(configData, DataWrapper.class);
        
        try{
            Note newNote = new Note();
            newNote.Title = config.noteType;
            newNote.ParentId = config.recId;
            newNote.Body = config.noteValue;
            
            //Calling Job Notes/4Cs integration service to send Job Notes to BMS as part of FBI-9
            //TW-84 Job Notes Integration updates - Karthik Pedditi
            system.debug('before call out config.recId:'+config.recId+' noteType:'+config.noteType+' noteValue:'+config.noteValue);
            
            User usr = new User();
            usr = [SELECT Id, ERP__c,UserRole.Name, Name, FederationIdentifier FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
            fsl_Switch__c switchRecord = [SELECT name,Id,IsActive__C,User_Type__c,ERP__c FROM fsl_Switch__c where name = 'Job_Notes' AND IsActive__C=true limit 1];
            WorkOrder wo  = [Select id, CreatedDate,CreatedById,LastModifiedById,LastModifiedDate, ServiceTerritory.Location_Code__c,WorkOrderNumber, Shop_Work_Order__c,EditComplaint__c, EditCoverage__c, Type__c from WorkOrder where id =: config.recId ];
            
            //Added Code for Dealer Functionality. Please do not place any distributor functionality above this.
            if(wo.Type__c == 'Dealer'){
                insert newNote;
                getMessage='RECORD_INSERTED';
                return getMessage;
            }
            
            String notesCreatedUserFedId;
            notesCreatedUserFedId=usr.FederationIdentifier;
            String sLoc = wo.ServiceTerritory.Location_Code__c;
            String UserERP='';
            if(usr.ERP__c!=null){
            UserERP=(String)usr.ERP__c;
            }
           
            if (UserERP==''){
                getMessage=System.Label.FSL_Job_Notes_Error_Msg_if_ERP_Null;
            }
            else if((UserERP!=null && switchRecord.ERP__c.contains(UserERP) && wo.Shop_Work_Order__c==null)){
                getMessage=System.Label.FSL_Job_Notes_Error_Msg_if_ERP_WO_Null;
            }
            else if((UserERP!=null && switchRecord.ERP__c.contains(UserERP) && wo.Shop_Work_Order__c!=null)){
                getMessage =callOutJobNotesIntegration(config.recId, config.noteType, config.noteValue, system.now(),notesCreatedUserFedId,UserERP,sLoc,wo);
               
                if(getMessage==''){
                    system.debug('CCCCCCCCCCC1'+getMessage);
                    insert newNote;
                    getMessage='RECORD_INSERTED';
                }
            }
            else if(UserERP!=null && !switchRecord.ERP__c.contains(UserERP)){
                insert newNote;
                getMessage='RECORD_INSERTED';
            }
            
        }catch(exception e){
            system.debug('Exception in Save'+e.getMessage()+' '+e.getLineNumber());
            //getMessage=e.getMessage(); backend errror
            // getMessage='Insert Error';
             system.debug('CCCCCCCCCCC'+getMessage);
        }
        return getMessage;
    }
    
    //Calling Job Notes/4Cs integration service to send Job Notes to BMS as part of FBI-9
   // @future(callout = true)
    public static String callOutJobNotesIntegration(String woId, String noteType, String noteValue,Datetime NotecreatedDate,String notesCreatedUserFedId,String UserERP,String sLoc, Workorder wo ){
        
        String calloutMessage='';
        String notesCreatedDate = NotecreatedDate.format('YYYY-MM-dd','GMT')+ 'T' + NotecreatedDate.format('HH:mm:ss','GMT');
        String notesChangeDate =null;
        String notesChangeUser=null;

        //String subString = sLoc.substringBefore('-'); //Trupthi 7/18/22 - NIN-409. Added new class FSL_ERP_LocationCode_Util.apxc to derive the location
        //String subString2 = sLoc.substringAfter('-').substring(0,5); //Trupthi 7/18/22 - NIN-409. Added new class FSL_ERP_LocationCode_Util.apxc to derive the location
        
        //TW-88 Job Notes Toggle Switch - Karthik Pedditi
        fsl_Switch__c switchRecord = [SELECT name,Id,IsActive__C,User_Type__c,ERP__c FROM fsl_Switch__c where name = 'Job_Notes' limit 1];
        if(switchRecord!=null && UserERP!=null){
            //Start, Trupthi 7/18/22 - NIN-409. Added new class FSL_ERP_LocationCode_Util.apxc to derive the location
           // if(UserERP.contains(switchRecord.ERP__c))
            if (switchRecord.ERP__c.contains(UserERP)){
           // sLoc = subString + '-' + subString2; 
             sLoc = FSL_ERP_LocationCode_Util.getLocationCode(sLoc); 
            }
        //Trupthi 7/18/22 - NIN-409. Added new class FSL_ERP_LocationCode_Util.apxc to derive the location
            system.debug('Location is:' + sLoc);
            system.debug('UserERP'+UserERP);
            system.debug('switchRecordERP'+switchRecord.ERP__c);
            system.debug('switchRecord contains'+switchRecord.ERP__c.contains(UserERP));
            //Start Phoen-287
            String noteValueJSON = '';            
            if (String.isNotBlank(noteValue)) {
            	noteValueJSON= addEscapeChar(noteValue);
        	}
           
            system.debug('noteValueJSON==>'+noteValueJSON);
             //End Phoen-287
            //String varnoteValue=noteValue.replaceAll('"','');
            //FSL_WOCommentInboundJson2Apex commentInboundDetails=FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, wo.WorkOrderNumber, 'WO', wo.Shop_Work_Order__c, noteType, varnoteValue, notesCreatedUserFedId, notesChangeUser,notesCreatedDate,notesChangeDate);
            FSL_WOCommentInboundJson2Apex commentInboundDetails=FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, wo.WorkOrderNumber, 'WO', wo.Shop_Work_Order__c, noteType, noteValue, notesCreatedUserFedId, notesChangeUser,notesCreatedDate,notesChangeDate);
            system.debug('commentInboundDetails'+commentInboundDetails);
            If(commentInboundDetails == null){
                calloutMessage=System.Label.FSL_JobNotesDown;
            }
            else if(commentInboundDetails != null && commentInboundDetails.Header!= null && commentInboundDetails.Header.Status=='ERROR'){
                calloutMessage=commentInboundDetails.Header.ReturnCodeDescription;
            }else if(commentInboundDetails != null && commentInboundDetails.ReturnCodeDescription != null){
                 Boolean isSpecialChar = commentInboundDetails.ReturnCodeDescription.contains('Unexpected character');
                /*if(isSpecialChar){
                    calloutMessage=System.Label.FSL_IncorrectParametersinJobNotes;
                }else{
                    calloutMessage= System.Label.FSL_JobNotesDown;
                } */  
            }
        }
        return calloutMessage;
        //End : added code for JobNotes
        //return null;
        //End TW-84 Job Notes Integration updates - Karthik Pedditi
        //End TW-87
    }
    @AuraEnabled
    public static user fetchUserInfo(){
        User currUser = [select id,Name,ERP__c,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled,LanguageLocaleKey
                         FROM User Where id =: userInfo.getUserId()];
        return currUser;
    }
    
    @AuraEnabled
    public static string getCustomMetaDataTypesForErrors(string errorCode){
        User user1 = FSL_NotesController.fetchUserInfo();
        
        errorCode = '%'+errorCode+'%';
        List<FSL_ErrorCodes__mdt> errorMessageList =
        [SELECT id, Error_Code__c, Language__c, Error_Description__c FROM 
        FSL_ErrorCodes__mdt WHERE Error_Code__c LIKE :errorCode AND Language__c=:user1.LanguageLocaleKey  LIMIT 1];
        if(errorMessageList.size()>0){
         return errorMessageList[0].Error_Description__c;
        }else{
            return null;
        }
    }
    public class DataWrapper {
        @AuraEnabled public string recId;
        @AuraEnabled public string noteType;
        @AuraEnabled public string noteValue;
        
        public DataWrapper(){}
    }
    
    public class notesWrapper{
        @AuraEnabled public Id nId;
        @AuraEnabled public string nBody;
        @AuraEnabled public string nTitle;
        @AuraEnabled public string nfrstName;
        @AuraEnabled public string nlastName;
        @AuraEnabled public string nLastModified;
        @AuraEnabled public string nCreatedId;
        
        public notesWrapper(Note n){
            this.nId=n.id;
            this.nBody=string.valueof(n.body);
            this.nTitle=n.Title;
            this.nfrstName=n.CreatedBy.firstname;
            this.nlastName=n.CreatedBy.lastname;
            this.nLastModified= n.CreatedDate.format('dd MMM yyyy hh:mm a z'); 
            this.nCreatedId=n.CreatedById;
        } 
    }
     /** Charan : Start for Phoen-287**/
    public static string addEscapeChar(string inputString) {
        if(inputString.contains('\\') ){
            string addbackslash = '\\\\';
            inputString = inputString.replace('\\',addbackslash);
            system.debug('inputString  :::' +inputString);
        }
        if(inputString.contains('"') ){
            string adddoublecodes = '\\"';
            inputString = inputString.replace('"',adddoublecodes);
            system.debug('inputString  :::' +inputString);
        }
        system.debug('Actual inputString  :::' +inputString);
        return inputString;
    } 
    /**Phoen-287 Code ends **/
}