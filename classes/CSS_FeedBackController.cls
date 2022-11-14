public with sharing class CSS_FeedBackController {
    
    public Case caseObj {get;set;}
    public Boolean responseMsg{get;set;}
    public List<Case> lstCases{get; set;}
    public String feedbackRecordTypeId;
    public string userLoc {get; set;}
    public String selectedType{get; set;}
    public Boolean reqDecBoolen{get; set;}
    public Boolean SuppliedEmail{get; set;}
    public Boolean allFieldsValidate{get; set;}
    public Boolean casetype{get; set;}
    public String feedbackdesc {get;set;}
    public string successMsg{get;set;}
    public string wwIdOrUn{get;set;}
    public string userName{get;set;}
    public string userId{get;set;}
    public Boolean reqDecBoolen1{get; set;}
    public Boolean reqemail{get; set;}
    public Boolean allFieldsValidate1{get; set;}
    public Boolean reqtype{get; set;}
   //  public boolean btnReply {get; Set;}  
    public boolean replyNotes {get; Set;} 
    public Boolean isDealer{get; set;}
    //add attachment start
    public ID caseid {get;set;}
    public Boolean attchValueBool{get;set;}
    
    //Constructor
    public CSS_FeedBackController(){
        try{
        btnReply=true;
        replyNotes = false;
        reqDecBoolen1 = false;
        reqemail = false;
        allFieldsValidate1 = false;
        reqtype = false;
        successMsg='';
        System.debug('in controller....>>>>>>>>>>>>>>');
        userName = UserInfo.getUserName();
        userId = UserInfo.getUserId();    
        caseObj = new Case();
            //add attachment start
        caseid = ApexPages.CurrentPage().getParameters().get('id');
        //add attachment end
         //reqDecBoolen = false;
        SuppliedEmail = false;
        allFieldsValidate = false;
        casetype = false;
        
        //Checking Delaer or Distributor
        isDealer = true;
        String userType = css_utility.getOrgType(UserInfo.getUserId());
        if(userType !=null && userType !=''){
            if(userType == 'DLR'){
                isDealer = true;
            }else if(userType == 'DISTR'){
                isDealer = false;
            }
        }  
        System.debug('userType>>>:'+userType+' isDealer>>>:'+isDealer);
            
        lstCases = new list<Case>();
        feedbackRecordTypeId = css_utility.getRecordTypeId(case.sObjectType, 'Feedback');
        System.debug('feedbackRecordTypeId>>>>>>:'+feedbackRecordTypeId);
         //caseId = ApexPages.currentPage().getParameters().get('CaseId');
        //Get the Current user profile and set the flag for advance or tecnician user 
        Id profileId = userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        //userLoc =[SELECT Id, User_Location__c FROM User where Id= :UserInfo.getUserId()].User_Location__c;
        User userObj =[SELECT Id, User_Location__c, FederationIdentifier FROM User where Id= :UserInfo.getUserId()];
        userLoc = userObj.User_Location__c;
        if(userObj.FederationIdentifier !=null && userObj.FederationIdentifier.trim() !='')
            wwIdOrUn = userObj.FederationIdentifier;
        else
            wwIdOrUn = UserInfo.getName();
           /* lstCases = [SELECT id,Status,CaseNumber,Subject,CSS_Job__c,Service_Model__c,Solution_Title__c,Location__c,OwnerId,Owner.name,
                           Type, Description, CreatedDate, (Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp,
                                         LastModifiedDate, LastModifiedById, IsDeleted From CaseComments ORDER BY LastModifiedDate ASC limit 1 )
                       FROM  Case Order By LastModifiedDate DESC
                       WHERE  OwnerId =: userinfo.getUserId() AND recordtypeId = : reportedProblemRecordTypeId]; */
          lstCases = [SELECT id,Status,CaseNumber,Subject,Location__c,OwnerId,Owner.name,Case_Update_Flag__c, 
                           Type, Description, CreatedDate,Case_Viewed_User_Ids__c
                      FROM Case 
                      WHERE  createdById =: userinfo.getUserId() AND recordtypeId = : feedbackRecordTypeId Order By LastModifiedDate DESC];
              System.debug('in controller....lstCases size>>>>>>>>>>>>>>'+lstCases.size());
        //}
        //lstCases.sort();
        
        // method call to change the time format 
        createTimeZoneMap(lstCases);
        }catch(Exception ex){
            System.debug('in catch of constructor of CSS_FeedBackController>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
       }
    } 
    
    public void saveCase(){
        Database.DMLOptions dmo = new Database.DMLOptions();
dmo.assignmentRuleHeader.useDefaultRule= true;
        PageReference pg;
        try{
            system.debug('fileBody>>>'+fileBody);
            system.debug('fileName>>>'+fileName);
            system.debug('caseObj>>>'+caseObj);
            system.debug('caseObj.Subject'+caseObj.Subject);
            attchValueBool = false;
            if(caseObj.SuppliedEmail==null || caseObj.SuppliedEmail==''){
                reqemail=true;
                allFieldsValidate1=true;
                if(string.isNotblank(fileName)){
                attchValueBool = true;
                }
            }else{
                reqemail=false;
                allFieldsValidate1=false;
                attchValueBool = false;
            }
            if(selectedType==null || selectedType=='' || selectedType=='None' || selectedType=='Select One'){
                reqtype=true;
                allFieldsValidate1=true;
                if(string.isNotblank(fileName)){
                attchValueBool = true;
                }
            }else{
                reqtype=false;
                allFieldsValidate1=false;
                attchValueBool = false;
            }
            if(caseObj.Subject==null || caseObj.Subject==''){
                reqDecBoolen1=true;
                allFieldsValidate1=true;
                if(string.isNotblank(fileName)){
                attchValueBool = true;
                }
            }else{
                reqDecBoolen1=false;
                allFieldsValidate1=false;
                attchValueBool = false;
            }
            
            System.debug('allFieldsValidate1===:'+allFieldsValidate1+' reqDecBoolen1>>>>:'+reqDecBoolen1);
            if(allFieldsValidate1==false && reqDecBoolen1==false && reqemail==false && reqtype==false){
                System.debug('entered ...allFieldsValidate1===:'+allFieldsValidate1+' reqDecBoolen1>>>>:'+reqDecBoolen1);
                //insert the feedback case
                System.debug('caseObj===>'+caseObj);
                caseObj.recordtypeId = feedbackRecordTypeId;
                caseObj.Type = selectedType;
                caseObj.Location__c = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode');
                caseObj.Username_WWID__c = wwIdOrUn;
                 caseObj.Origin = 'Web';
                caseObj.Case_Viewed_User_Ids__c = userinfo.getUserId();
                caseObj.setOptions(dmo);
                insert caseObj;
                System.debug('caseObj.Id===>'+caseObj.Id);
                
                processUpload(caseObj.Id);
                responseMsg = true;
                successMsg = 'Thank You! Your Feedback has been sent. You should expect to receive a reply within 2 business days';
                lstCases = [SELECT id,Status,CaseNumber,Subject,Location__c,OwnerId,Owner.name,
                               Type, Description, CreatedDate,Case_Viewed_User_Ids__c,Case_Update_Flag__c
                            FROM Case 
                            WHERE  createdById =: userinfo.getUserId() AND recordtypeId = : feedbackRecordTypeId Order By LastModifiedDate DESC];
                caseObj = null;
                //caseObj = new Case(); //reset all the request values to NULL here after insert
                selectedType = 'Select One';
              }else{
               fileBody = null;
                //return null;   
              }
             //method call to get the case created date 
             if(lstCases !=null && lstCases.size() > 0){
                createTimeZoneMap(lstCases);
             }
             System.debug('responseMsg>>:'+responseMsg);
            //pg = new PageReference('/apex/CSS_GiveUsFeedback');
            //pg.getHeaders().put('attrValue','CSS');
            //pg.getParameters().put('Token','CSS');
            //pg.setRedirect(true);

        }catch(Exception ex){
            successMsg = 'Your feedback was not submitted successfully, please try again.';
            System.debug('in catch of saveCase of CSS_FeedBackController>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        //return pg;
    }
    
    public List<SelectOption> getTypeOptions(){
           List<SelectOption> options = new List<SelectOption>();
           options.add(new SelectOption('None','Select One'));
           Schema.DescribeFieldResult fieldResult = Case.Type.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
           for(Schema.PicklistEntry p : ple)
               options.add(new SelectOption(p.getValue(), p.getValue())); 
           return options;
     }
    
     public void showFeedback()
       {
           try{
          
           if(feedbackdesc=='1')    
           {
      lstCases= [SELECT id,Status,CaseNumber,Subject,Location__c,OwnerId,Owner.name,Type, Description, CreatedDate,Case_Viewed_User_Ids__c,Case_Update_Flag__c
                 FROM Case 
                 WHERE  createdById =: userinfo.getUserId() AND recordtypeId = : feedbackRecordTypeId Order By CreatedDate DESC];         
           }
          
          else if(feedbackdesc=='2'){
      lstCases= [SELECT id,Status,CaseNumber,Subject,Location__c,OwnerId,Owner.name,Type, Description, CreatedDate,Case_Viewed_User_Ids__c,Case_Update_Flag__c
                 FROM Case 
                 WHERE  createdById =: userinfo.getUserId() AND recordtypeId = : feedbackRecordTypeId Order By CreatedDate ASC];               
           }
       }
           catch(Exception ex){
               System.debug('Exception on Line '+ex.getLineNumber());
           }
       }
    
    public List<SelectOption> getSortvalues() {
        try{
            List<SelectOption> SortList = new List<SelectOption>(); 
            
            
            SortList.add(new SelectOption('1',system.Label.css_Newest_To_Oldest));
            SortList.add(new SelectOption('2',system.Label.css_Oldest_To_Newest));
            
            return SortList;
        }
        
        catch(exception e){
            return null;
        }
        
    }
    //Story 91304
    // Method display the popup and its case comments related to particular case id clicked
    public list<Case> lstComments {get; set;}
    public List<Attachment> caseAttach {get;set;}
    public string stCaseId {get; set;}

    public void caseCommentsDetails(){
        system.debug('CaseId >>>>>: ' + stCaseId );
        lstComments = [Select id, CaseNumber, Description, Status, Type,createdBy.name, 
                       CreatedDate,Case_Update_Flag__c,suppliedPhone,Subject ,Case_Viewed_User_Ids__c,
                       (Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp, createdBy.name,
                        LastModifiedDate, LastModifiedById, IsDeleted 
                        From CaseComments order by LastModifiedDate asc)
                       From Case where Id=:stCaseId LIMIT 1 ];
        if( stCaseId!=null)        
          caseAttach = new List<Attachment>([Select Id,Name,Description,parentid, LastModifiedDate from attachment where parentid= :stCaseId]);
          
        if(!lstComments.isEmpty()){
                    //Calling method to reset the counter for the notification 
                    resetCaseCounter();
                    //calling method to do bold and unbold
                    boldUnboldshowupdate();
                    //call method to build the map for current timezone format of logged in user
                    createTimeZoneMap(lstComments);
                }
    }
    public boolean btnReply {get; Set;}  
    public void replyToProblem()
    {
        btnReply=false;
        replyNotes = true;
        commMessage='';
    }
    public string commMessage {get; set;}
    public void SendProblem()
    {
        btnReply=true;
        replyNotes = false;
        CaseComment caseCommentObj = new CaseComment();
        if(commMessage == null || commMessage.trim()==''){
            caseCommentObj.CommentBody = ' ';
        } else
            caseCommentObj.CommentBody = commMessage;
        caseCommentObj.ParentId = stCaseId;
        caseCommentObj.IsPublished = true;
        //caseCommentObj.CreatedById = userId;
        //caseCommentObj.LastModifiedById = userId;
        insert caseCommentObj; 
        
        caseCommentsDetails();
        commMessage='';
    }
    
     //Method to reset the case count flag so the case counter decreases when user views the notifications.
    public void resetCaseCounter(){
        system.debug('inside resetCaseCounter');
        //running loop to check 
        for(case cs : lstComments){
            if(cs.Case_Update_Flag__c && cs.createdById == userId){
                cs.Case_Update_Flag__c = false;
            }
        }
        if(!lstComments.isEmpty()){
            try{
                update lstComments;
            }
            catch(Exception e){
                system.debug('exception messages -->'+e.getMessage());
            }
        }

    }
    
    //Method used to stamp the user id who reads the case and makes it unbold on the load 
     public void boldUnboldshowupdate(){
         for(case clickedCase : lstComments){
             if(clickedCase.Case_Viewed_User_Ids__c == null ||  clickedCase.Case_Viewed_User_Ids__c == ''){
                clickedCase.Case_Viewed_User_Ids__c = userID;
             }
             else{
             clickedCase.Case_Viewed_User_Ids__c +=  ',' +userID;
             }
         }
        
        if(!lstComments.isEmpty()){
            try{
                update lstComments;
            }
            catch(Exception e){
                system.debug('exception messages -->'+e.getMessage());
            }
        }           
    }
    
    public map<id,map<id,string>> mapCaseCommntTime{get;set;}
    public map<id,string> mapCommentIdDatetime {get;set;}
    public string descriptionDateTime{get;set;}
    public map<id,string> mapCaseDescriptionTime{get;set;}
    //method to build map for the case comment 
    public void createTimeZoneMap(list<Case> lstCaseCom){
        mapCaseDescriptionTime = new map<id,string>();
        mapCommentIdDatetime = new map<id,string>();
        mapCaseCommntTime = new map<id,map<id,string>>();
        string dt;
        for(Case c : lstCaseCom){
                mapCaseCommntTime.put(c.id,new map<id,string>());//for the front table 
             descriptionDateTime = c.CreatedDate.format('dd MMM yyyy - hh:mm:ss a z', UserInfo.getTimeZone().getID());
             mapCaseDescriptionTime.put(c.id,descriptionDateTime);
            if(c.CaseComments != null){
                for(caseComment cc : c.CaseComments){
                     dt = cc.LastModifiedDate.format('dd MMM yyyy - hh:mm:ss a z', UserInfo.getTimeZone().getID());
                         mapCaseCommntTime.get(c.id).put(cc.id,dt); //for the front table 
                         mapCommentIdDatetime.put(cc.id,dt); //for the popup
                 }
            }
             
        }
       
    }
    
    //add attachment start
    //public Boolean displayPopup1 {get;set;}
    //public Blob fileBody {get;set;}
    //public String fileName {get;set;}
    public String description1 {get;set;}
   /* public void showPopup1() {
        system.debug ('Before:: inside ShowPopup1:' + displayPopup1);
        displayPopup1 = true;
        system.debug ('After:: inside ShowPopup1:' + displayPopup1);
    } */
    public PageReference processUpload() {
        try 
        {
            boolean attachmentResult = saveStandardAttachment(caseid);
            if (attachmentResult == false || attachmentResult == null) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not save attachment.'));            
                return null;
            } 
            else
            {
                fileBody = null;              
            }    
        } 
        catch (Exception e) {
            ApexPages.AddMessages(e);
            return null;
        }
        PageReference ReturnPage = new PageReference('/apex/CSS_GiveUsFeedback?id='+caseid); 
        ReturnPage.setRedirect(true);
        return ReturnPage; 
    }

    public Boolean displayPopup1 {get;set;}
    public Blob fileBody {get;set;}
    public String fileName {get;set;}
    //public String description1 {get;set;}
    public void showPopup1() {
        system.debug ('Before:: inside ShowPopup1:' + displayPopup1);
        displayPopup1 = true;
        system.debug ('After:: inside ShowPopup1:' + displayPopup1);
    }
    public void processUpload(Id parentId) {
        try 
        {
                        boolean attachmentResult = saveStandardAttachment(parentId);
            if (attachmentResult == false || attachmentResult == null) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not save attachment.'));            
             //  return null;
            } 
            else
            {
                fileBody = null;              
            }    
        } 
        catch (Exception e) {
            ApexPages.AddMessages(e);
           // return null;
        }
        //return new PageReference('/apex/CSS_JobTnD?id='+Wid);
       //PageReference ReturnPage = new PageReference('/apex/CSS_GiveUsFeedback?id='+caseid); 
        
        //ReturnPage.setRedirect(true);
        //return ReturnPage; 
    }
    @testvisible
    private boolean saveStandardAttachment(Id parentId) 
    {
        boolean Success = false;
        Database.SaveResult result1;
       system.debug('-->fileBody<--'+fileBody);
         if(fileBody != null)
        { 
            Attachment attachment = new Attachment();
            attachment.body = this.fileBody;
            attachment.name = this.fileName;
            //attachment.description = description1;
            attachment.parentId = parentId;
            
            
            if (fileBody != null)
            {
                system.debug('-->inside-fileBody<--'+fileBody);
                result1 = Database.insert(attachment);
                            System.debug('result1--->'+result1);
                    }
            
             if(fileBody != null && result1.isSuccess() == false)
                 
                Success = false;
            else
                Success = true;
            
        } 
        return Success ;
    }
    public PageReference closePopup1() {
        
        //description1 ='';
      /*  System.debug('input file'+filebody);
        displayPopup1 = false;  */
        //fileBody = null;
     PageReference ReturnPage = new PageReference('/apex/CSS_GiveUsFeedback'); 
        ReturnPage.setRedirect(true);
        return ReturnPage;
        
    }
    //add attachment end

   }