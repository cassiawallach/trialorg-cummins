/**********************************************************************
Name:CSS_ReportedProblemViewController
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 -  Rakesh kumar     27/04/2017      INITIAL DEVELOPMENT  
2.0 -  Rajesh P         27/04/2017      Added code for document no:92925
***********************************************************************/
public class CSS_ReportedProblemViewController
{
    public string profileName;
    public boolean advanceUserFlag{get; set;}
    public list<case> lstCases {get; set;}
    public boolean CheckboxVal{get; set;}
    public string userLoc {get; set;}
    public string reportedProblemRecordTypeId;
    public Boolean boldFlag {get; set;}
    public ID userID {get; set;}
    public Boolean isDealer{get; set;}

    public CSS_ReportedProblemViewController()
    {
        btnReply=true;
        replyNotes = false;
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
        
        lstCases = new list<case>();
        reportedProblemRecordTypeId = css_utility.getRecordTypeId(case.sObjectType, 'Reported Problem');
        //caseId = ApexPages.currentPage().getParameters().get('CaseId');
        //Get the Current user profile and set the flag for advance or tecnician user 
        Id profileId=userinfo.getProfileId();
        userID= userinfo.getUserId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        userLoc =[SELECT Id, User_Location__c FROM User where Id= :UserInfo.getUserId()].User_Location__c;
        //Use it for system  admin testing during development
        //Put comment Ed start
        advanceUserFlag = false;
        profileName = 'TECHNICIAN';
        boldFlag = true;  
        
       /* end comment*/
        if(string.isNotBlank(profileName)){
            if(profileName.toUpperCase().contains('ADVANCE'))
            {
             advanceUserFlag = true;
                btnReply=false;
        }
        }

        if (string.isNotBlank(profileName) && (profileName.toUpperCase().contains('TECHNICIAN')  || profileName.toUpperCase().contains('ADVANCE')))
        {
            lstCases = [SELECT id,Status,CaseNumber,Subject,CSS_Job__c,Service_Model__c,Solution_Title__c,Location__c,OwnerId,Owner.name,
                        Description,Case_Viewed_User_Ids__c,Case_Update_Flag__c,Solution_Id__c,CreatedDate,createdBy.name,
                        (Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp,
                         LastModifiedDate, LastModifiedById, IsDeleted 
                         From CaseComments 
                         ORDER BY LastModifiedDate DESC limit 1 )
                        FROM  Case
                        WHERE  createdById =: userinfo.getUserId() AND recordtypeId = : reportedProblemRecordTypeId
                        ORDER BY LastModifiedDate DESC];
            //function to show date time in current user time zone .
            createTimeZoneMap(lstCases);
        }
        // str=lstCases.Case_Viewed_User_Ids__c;
        /*   for(case lstC : lstCases){
        if(lstC.Case_Viewed_User_Ids__c != null  || lstC.Case_Viewed_User_Ids__c != '' ){
         for(String strFinal: lstC.Case_Viewed_User_Ids__c.split(',')){
           if(userID==strFinal){
            boldFlag= false; 
           }
         }
       }else
        { boldFlag = true; }
      }  */
    }



    
    public void showCasesForAdvUser(){
        if(CheckboxVal == true ){
        System.debug('inside if ****');
            lstCases = [SELECT id,Status,CaseNumber,Subject,CSS_Job__c,Service_Model__c,Solution_Title__c,Location__c,OwnerId,Owner.name,
                        Description,Case_Viewed_User_Ids__c,Case_Update_Flag__c,Solution_Id__c,CreatedDate,createdBy.name,
                        (Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp,
                         LastModifiedDate, LastModifiedById, IsDeleted 
                         From CaseComments 
                         ORDER BY LastModifiedDate DESC limit 1 )
                        FROM  Case
                        WHERE  createdById =: userinfo.getUserId() AND recordtypeId = : reportedProblemRecordTypeId
                        ORDER BY LastModifiedDate DESC];
        }else
        {
         System.debug('inside else ****');
            lstCases = [SELECT id,Status,CaseNumber,Subject,CSS_Job__c,Service_Model__c,Solution_Title__c,Location__c,OwnerId,Owner.name,
                        Description,Case_Viewed_User_Ids__c,Case_Update_Flag__c,Solution_Id__c,CreatedDate,createdBy.name,
                        (Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp,
                         LastModifiedDate, LastModifiedById, IsDeleted 
                         From CaseComments 
                         ORDER BY LastModifiedDate DESC limit 1 )
                        FROM  Case
                        WHERE  Location__c =: userLoc AND recordtypeId = : reportedProblemRecordTypeId
                        ORDER BY LastModifiedDate DESC];

        }
        //Defect Fix - 96659 
        createTimeZoneMap(lstCases);
    }    




    public list<Case> lstComments {get; set;}
    public string stCaseId {get; set;}

    public void caseCommentsDetails(){
        system.debug('CaseId >>>>>: ' + stCaseId );
        lstComments = [Select id, CaseNumber, Description, Status, CSS_Job__c, Service_Model__c,Solution_Title__c, Solution_Id__c, createdBy.name, 
                       CreatedDate,Case_Update_Flag__c,createdBy.ID,Case_Viewed_User_Ids__c,
                       (Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp, createdBy.name,
                        LastModifiedDate, LastModifiedById, IsDeleted 
                        From CaseComments order by LastModifiedDate asc)
                       From Case where Id=:stCaseId LIMIT 1 ];
        if(!lstComments.isEmpty()){
            //calling method to check the department and buld map 
             checkDepartment();
            //Calling method to reset the counter for the notification 
            resetCaseCounter();
            //calling method to do bold and unbold
            boldUnboldshowupdate();
            //call method to build the map for current timezone format of logged in user
            createTimeZoneMap(lstComments);
        }
        //Advance user should not be able to edit other users record
        if(lstComments[0].createdBy.ID==userID){
         btnReply= true;
        } 
        else
          btnReply= false; 
    
        
    }

    public boolean btnReply {get; Set;}  
    public boolean replyNotes {get; Set;}  
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
    public PageReference close(){
       PageReference pageRef = new pageReference('/apex/CSS_ReportedProblemView'); 
            pageRef.setRedirect(true);
            return pageRef;
    }     
    //Method to reset the case count flag so the case counter decreases when user views the notifications.
    public void resetCaseCounter(){
        system.debug('inside resetCaseCounter');
        //running loop to check 
        for(case cs : lstComments){
            if(cs.Case_Update_Flag__c && cs.createdById == userID){
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
    set<id> setCreatedById = new set<id>();
    public map<id,string> mapUserDepartment{get;set;}
    list<user> lstUserRecords = new list<user>();
    //method to determine the department of the user 
    public void checkDepartment(){
        mapUserDepartment = new map<id,string>();
                for(Case c : lstComments){
                    for(CaseComment comm : c.CaseComments)
                    {
                        setCreatedById.add(comm.CreatedById);
                        System.debug(comm.CommentBody);
                    }
                }
        //get all users for the createbyid for case comments
        if(!setCreatedById.isEmpty()){
            lstUserRecords = [SELECT id,department
                              FROM User
                              WHERE id in : setCreatedById];
        }
        
        //preparing map for createdById and respective department 
        for(User u : lstUserRecords){
            if(u.department != null){
            mapUserDepartment.put(u.id,u.department);
            }
            else{
                mapUserDepartment.put(u.id,'Empty');
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
             for(caseComment cc : c.CaseComments){
                 dt = cc.LastModifiedDate.format('dd MMM yyyy - hh:mm:ss a z', UserInfo.getTimeZone().getID());
                     mapCaseCommntTime.get(c.id).put(cc.id,dt); //for the front table 
                     mapCommentIdDatetime.put(cc.id,dt); //for the popup
            }
        }
       
    }
    
    public PageReference closePopup1() {
        
        PageReference ReturnPage = new PageReference('/apex/CSS_ReportedProblemView'); 
        ReturnPage.setRedirect(true);
        return ReturnPage;
        
    }

}