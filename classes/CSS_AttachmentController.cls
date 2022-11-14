public class CSS_AttachmentController {

    
    public Id sobjId {get; set;}
    public Blob fileBody {get;set;}
    public Blob fileBody2 {get;set;}
    public Blob fileBody3 {get;set;}
    public String fileName {get;set;}
    public String fileName2 {get;set;} 
    public String fileName3 {get;set;}    
    Transient public List<Attachment> jobAttach {get;set;} //<!----DEFECT 73249------>
    public String description {get;set;}
    public String description1 {get;set;}
    public String description2 {get;set;}
    public String description3 {get;set;}
    public Boolean displayPopup {get;set;}
    public Boolean displayPopup1 {get;set;}
    public Boolean displayPopup5 {get;set;}
    public Boolean displayPopup6 {get;set;}
    public Boolean closePopup1{get;set;}
    public string atthId{get; set;}
    public String atthName{get; set;}
    public Boolean DeleteFlg {get;set;}
   
    /* Constructor  */
    public CSS_AttachmentController (){
    system.debug('Atthid111***'+atthid);
   jobAttach = new List<Attachment>([Select Id,Body,Name,Description,parentid, LastModifiedDate from attachment where parentid= :sobjId]);
        system.debug('Atthid111***'+atthid);
    }    
    
        public PageReference delAttachment()
    {
        if (atthId != null)
        {
            Attachment AttachmenttoDel=new Attachment(id=atthId);
            
            Attachment Attalist =[select name,id,body,parentid from Attachment where id=:atthId];            
            CSS_JobHistory__c DeleteHiscRec = new CSS_JobHistory__c();
                DeleteHiscRec.CSS_Object_Name__c = 'Attachment';
                DeleteHiscRec.CSS_Job_Id__c = sobjId;
                    system.debug('CSS_Job_Id__c--->'+DeleteHiscRec.CSS_Job_Id__c);
                DeleteHiscRec.CSS_Field_Name__c ='Attachment';
                DeleteHiscRec.CSS_Old_Value__c = 'Deleted';
                DeleteHiscRec.CSS_New_Value__c = Attalist.name;
                    system.debug('CSS_New_Value__c--->'+DeleteHiscRec.CSS_New_Value__c);
                  if(DeleteHiscRec!=null){
                    insert DeleteHiscRec;
                  }
                    system.debug('DeleteHiscRec--->'+DeleteHiscRec);
            delete AttachmenttoDel;
            PageReference pageRef = new pageReference('/apex/CSS_JobIntake_Attachment?id='+sobjid); 
            pageRef.setRedirect(true);
            return pageRef;
        }
        else
        {
            return null;
            
        }
    }
    /* Redirect to JobIntake page with Id if atthId is not null else return null */    
    public PageReference editAttachment()
        {
        system.debug('EditAtthid***'+atthid);
        
system.debug('description***'+description);
system.debug('description1***'+description1);
system.debug('description2***'+description2);
system.debug('description3***'+description3);
        if (atthId != null)
                {
           
    system.debug('Atthid***'+atthid);
system.debug('description***'+description);
system.debug('description1***'+description1);
system.debug('description2***'+description2);
system.debug('description3***'+description3);
        
            Attachment AttachmenttoUpd=new Attachment(id=atthId,description=description);
            update AttachmenttoUpd;
            PageReference pageRef = new pageReference('/apex/CSS_JobIntake_Attachment?id='+sobjid); 
            pageRef.setRedirect(true);
            return pageRef;
        }
        else
        {
            return null;
        }
    }
    
    /* process upload*/
    public PageReference processUpload() {
        try 
        {
            //system.debug('R*********'+sobjId);
            system.debug('UploadAtthid***'+atthid);
            boolean attachmentResult = saveStandardAttachment(sobjId);
            
            if (attachmentResult == false || attachmentResult == null) {
                
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                           'Could not save attachment.'));            
                return null;
            } 
            else
            {
                fileBody = null;
                fileBody2 = null;
                fileBody3 = null;
                //closePopup1();
            }   
            
        } 
        
        catch (Exception e) {
            ApexPages.AddMessages(e);
            return null;
        }
       
       PageReference ReturnPage = new PageReference('/apex/CSS_JobIntake_Attachment?id='+sobjId); 
       //PageReference ReturnPage = new PageReference(ApexPages.currentPage().getUrl());

        ReturnPage.setRedirect(true);
        return ReturnPage;        
        
    }
    public List<Attachment> getAttach(){
        //jobAttach=[SELECT Body,name,Description FROM Attachment WHERE ParentID = :sobjId];
        return jobAttach;
    }
    /* Saving the standard attachment since modify SDk change from DNP*/    
    private boolean saveStandardAttachment(Id parentId) 
    {
        boolean Success = false;
        //Database.SaveResult result;
        Database.SaveResult result1;
        Database.SaveResult result2;
        Database.SaveResult result3;
        Database.SaveResult resultHist1;
        Database.SaveResult resultHist2;
        Database.SaveResult resultHist3;
        
        if(fileBody != null || fileBody2 != null || fileBody3 != null )
        { 
            Attachment attachment = new Attachment();
            attachment.body = this.fileBody;
            attachment.name = this.fileName;
            attachment.description = description1;
            attachment.parentId = parentId;
            
            Attachment attachment2 = new Attachment();
            attachment2.body = this.fileBody2;
            attachment2.name = this.fileName2;
            attachment2.description = description2;
            attachment2.parentId = parentId;
            
            Attachment attachment3 = new Attachment();
            attachment3.body = this.fileBody3;
            attachment3.name = this.fileName3;
            attachment3.description = description3;
            attachment3.parentId = parentId;
            
            CSS_JobHistory__c InsertHistRec = new CSS_JobHistory__c();
            InsertHistRec.CSS_Object_Name__c = 'Attachment';
            InsertHistRec.CSS_Field_Name__c = this.fileName;
            InsertHistRec.CSS_Old_Value__c = 'Added';
            InsertHistRec.CSS_New_Value__c = this.fileName;
            InsertHistRec.CSS_Job_Id__c =parentId;
            
            CSS_JobHistory__c InsertHistRec2 = new CSS_JobHistory__c();
            InsertHistRec2.CSS_Object_Name__c = 'Attachment';
            InsertHistRec2.CSS_Field_Name__c = this.fileName;
            InsertHistRec2.CSS_Old_Value__c = 'Added';
            InsertHistRec2.CSS_New_Value__c = this.fileName2;
            InsertHistRec2.CSS_Job_Id__c =parentId;
            
            CSS_JobHistory__c InsertHistRec3 = new CSS_JobHistory__c();
            InsertHistRec3.CSS_Object_Name__c = 'Attachment';
            InsertHistRec3.CSS_Field_Name__c = this.fileName;
            InsertHistRec3.CSS_Old_Value__c = 'Added';
            InsertHistRec3.CSS_New_Value__c = this.fileName3;
            InsertHistRec3.CSS_Job_Id__c =parentId;
            
            // inser the attahcment
            //result = Database.insert(attachment);
            // reset the file for the view state
            
            if (fileBody != null)
            {
                result1 = Database.insert(attachment);
                resultHist1 = Database.insert(InsertHistRec);
            }
            //result2 = Database.insert(attachment2);
            if (fileBody2 != null)
            {
                result2 = Database.insert(attachment2);
                resultHist2 = Database.insert(InsertHistRec2);
            }
            //result3 = Database.insert(attachment3);
            if (fileBody3 != null)
            {
                result3 = Database.insert(attachment3);
                resultHist3 = Database.insert(InsertHistRec3);
            }
            if((fileBody != null && result1.isSuccess() == false) || (fileBody2 != null && result2.isSuccess() == false)
               || (fileBody3 != null && result3.isSuccess() == false ))
                Success = false;
            else
                Success = true;
            
        } 
        return Success ;
    }
   
   /* delete files for parent account*/
    public PageReference DeleteFile() 
    {
        try
        {
            Attachment attachment = new Attachment(parentid=sobjId );
            delete jobAttach;
        }
        catch(Exception e){
            //handle error
        }
        return null;
    }
    
   public void showPopup1() {
        system.debug ('Before:: inside ShowPopup1:' + displayPopup1);
        displayPopup1 = true;
        system.debug ('After:: inside ShowPopup1:' + displayPopup1);
    }
    public void showPopup5() {
        displayPopup5 = true;

            system.debug('AtthId***'+atthid);
           List<Attachment> edtAttach = new List<Attachment>([Select Id, Name, Description from attachment where id= :atthId]);
            description = edtAttach[0].Description;
            atthName = edtAttach[0].Name;
        system.debug('atthName***'+atthName);
             System.debug('The description is'+description);

    }
     public void closePopup() {
        displayPopup = false;
    }
    


    public void showPopup6() {
        if(DeleteFlg == False){displayPopup6 = False;}
        else
        displayPopup6 = true;
        
    }
     public void showPopup7() {
       
        displayPopup6 = true;
        
    }
    public void closePopup6() {
        displayPopup6 = false;
    }
      public void closePopup1() {
        
        description1 ='';
        description2 ='';
        description3 ='';
        displayPopup1 = false;
        fileBody = null;
        fileBody2 = null;
        fileBody3 = null; 
        
    }
    public PageReference redirectPopup()
    {    
        displayPopup = false;
        PageReference p=new Pagereference('/apex/CSS_Job_Detail?nto=HOME');
        p.setRedirect(true);
        return p;
    } 


    }