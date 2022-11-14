/*Name:CG_CL_AttachmentComp
======================================================
======================================================
Purpose:                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR                    DATE                DETAIL                                 
1.0    -    Rajesh Pasupuleti         29/12/2017          INITIAL DEVELOPMENT                  
1.1    -    Karthik gorantla          02/01/2018          Wild Kingdom story
2.0         karthik gorantla        02/19/2018            Added modification as per LOST story #114985
***********************************************************************/
public class CG_CL_AttachmentComp
{    

    public Id sobjId {get; set;}
    public String PageName {get;set;}
    public Blob fileBody {get;set;}
    public Blob fileBody2 {get;set;}
    public Blob fileBody3 {get;set;}
    public String fileName {get;set;}
    public String fileName2 {get;set;} 
    public String fileName3 {get;set;}

    public String fileSize1 {get;set;}
    public List<Attachment> jobAttach {get;set;} //<!----DEFECT 73249------>
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
   // public boolean isAttachmentLinkEnabled {get; set;}
    public string pgname;
    // public string showUpload{get;set;}
    // public Boolean showpop{get;set;}
    public id Wid;


    /* Constructor  */
    public CG_CL_AttachmentComp (){

        system.debug('Atthid111***'+atthid);
        system.debug('service job id***'+sobjId);
        system.debug('PageName***'+PageName);
           //isAttachmentLinkEnabled=false;
        pgname=ApexPages.currentPage().getUrl();
        pgname= pgname.substring(6).substringBefore('?');
        // pgname = pgname=='CSS_JobPlanParts'?'JobPlan':null;
        IF(pgname=='CSS_JobPlanParts')
            pgname='JobPlan';
        else if(pgname=='CG_ClaimsIntake'){
            pgname='ClaimsIntake';
           // isAttachmentLinkEnabled=true;
        }
        else if(pgname=='CG_ClaimsPartsandOtherClaimbles')
            pgname='ClaimsPartsandOtherClaimbles';
        else
            pgname = null;   

        system.debug('=====>PageName' +pgname);
        Wid=ApexPages.CurrentPage().getParameters().get('Id');
        List<Attachment> TempList=new List<Attachment>();
        jobAttach =new List<Attachment>();
        if((pgname=='JobPlan' || pgname=='ClaimsPartsandOtherClaimbles') && pagename!='ClaimsIntake'){
            TempList = new List<Attachment>([Select Id,Name,Description,parentid, LastModifiedDate from attachment 
                                             where parentid= :wid and (NOT Description like 'CG_%.eif') and Name like 'CGJBTLATT03%']);
            system.debug('====> Attachment List==>' +TempList); 
            for(Attachment att:TempList)
            {
                IF(att.Name.Contains('CGJBTLATT03-'))
                    att.Name =att.Name.substring(12);
                System.debug('========> att name' +att.Name);
                jobAttach.add(att);


            }
        }
        //added for story 137883
        else if(pgname=='ClaimsPartsandOtherClaimbles'){
            jobAttach = new List<Attachment>([Select Id,Name,Description,parentid, LastModifiedDate from attachment where parentid= :wid order by LastModifiedDate ASC] );
        }
        else{
            jobAttach = new List<Attachment>([Select Id,Name,Description,parentid, LastModifiedDate from attachment where parentid= :wid and (NOT Description like 'CG_%.eif') and (NOT Name like 'CGJBTLATT03%')order by LastModifiedDate ASC]);   
        }
        system.debug('Atthid111***'+atthid);
        system.debug('Atthid111***'+jobAttach.size());
    }    

    public PageReference delAttachment()
    {
        system.debug('inside Delete method');
        //string a = ApexPages.CurrentPage().getParameters().get('atthIdParam');
        //system.debug('=====>'+a);
        system.debug('atthId--'+atthId);
        try
        {
            PageReference pageRef;
            if (atthId != null)
            {
                Attachment AttachmenttoDel=new Attachment(id=atthId);

                Attachment Attalist =[select name,id,body,parentid from Attachment where id=:atthId];            
                CSS_JobHistory__c DeleteHiscRec = new CSS_JobHistory__c();
                DeleteHiscRec.CSS_Object_Name__c = 'Attachment';
                DeleteHiscRec.CSS_Job_Id__c = Wid;
                system.debug('CSS_Job_Id__c--->'+DeleteHiscRec.CSS_Job_Id__c);
                DeleteHiscRec.CSS_Field_Name__c ='Attachment';
                DeleteHiscRec.CSS_Old_Value__c = 'Deleted';
                DeleteHiscRec.CSS_New_Value__c = Attalist.name;
                system.debug('CSS_New_Value__c--->'+DeleteHiscRec.CSS_New_Value__c);

                system.debug('DeleteHiscRec-->'+DeleteHiscRec);
                system.debug('AttachmenttoDel-->'+AttachmenttoDel);
                if(DeleteHiscRec!=null){
                    insert DeleteHiscRec;
                }
                system.debug('DeleteHiscRec--->'+DeleteHiscRec);
                // if(AttachmenttoDel.body!=null){
                delete AttachmenttoDel;
                // }

                if(PageName=='IntakeVH'){
                    pageRef = new pageReference('/apex/CG_IntakeVH?id='+wid);
                }
                else if(PageName=='IntakeUE')
                {
                    pageRef = new pageReference('/apex/CG_IntakeUE?id='+wid);
                }
                else if(PageName=='IntakeCC')
                {
                    pageRef = new pageReference('/apex/CG_IntakeCC?id='+wid);
                }
                else if(PageName=='IntakeWR')
                {
                    pageRef = new pageReference('/apex/CG_IntakeWarranty?id='+wid);
                }
                else if(PageName=='IntakeRJ')
                {
                    pageRef = new pageReference('/apex/CG_IntakeRJ?id='+wid);
                }
                else if(PageName=='Jobplan')
                {
                    pageRef = new pageReference('/apex/CSS_JobPlanParts?id='+wid);
                }
                else if(PageName=='ClaimsIntake')
                {
                    pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+wid);
                }
                else if(PageName=='ClaimsPartsandOtherClaimbles')
                {
                    pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+wid);
                }
                else if(PageName=='CG_Claimsjobnotes')
                {
                    pageRef = new pageReference('/apex/CG_Claimsjobnotes?id='+wid);
                }
                pageRef.setRedirect(true);
                return pageRef;
            }
            else
            {
                if(PageName=='ClaimsPartsandOtherClaimbles')
                {
                    pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+wid);
                }
                pageRef.setRedirect(true);
                return pageRef;
                //return null;

            }
        }
        catch(exception e){
            system.debug('Exception in attachment '+ e.getMessage() + ' in the line '+e.getLineNumber());
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
            //PageReference pageRef = new pageReference('/apex/CG_IntakeVh?id='+wid);
            PageReference pageRef;
            if(PageName=='IntakeVH'){
                pageRef = new pageReference('/apex/CG_IntakeVH?id='+wid);
            }
            else if(PageName=='IntakeUE')
            {
                pageRef = new pageReference('/apex/CG_IntakeUE?id='+wid);
            }
            else if(PageName=='IntakeCC')
            {
                pageRef = new pageReference('/apex/CG_IntakeCC?id='+wid);
            }
            else if(PageName=='IntakeWR')
            {
                pageRef = new pageReference('/apex/CG_IntakeWarranty?id='+wid);
            }
            else if(PageName=='IntakeRJ')
            {
                pageRef = new pageReference('/apex/CG_IntakeRJ?id='+wid);
            }
            else if(PageName=='Jobplan')
            {
                pageRef = new pageReference('/apex/CSS_JobPlanParts?id='+wid);
            }
            else if(PageName=='ClaimsIntake')
            {
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+wid);
            }
            else if(PageName=='ClaimsPartsandOtherClaimbles')
            {
                pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+wid);
            }
            else if(PageName=='CG_Claimsjobnotes')
            {
                pageRef = new pageReference('/apex/CG_Claimsjobnotes?id='+wid);
            }
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

            system.debug('UploadAtthid***'+atthid);
            boolean attachmentResult = saveStandardAttachment(wid);
            system.debug('attachmentResult***'+attachmentResult);
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
        PageReference ReturnPage;
        if(PageName=='IntakeVH'){
            ReturnPage = new pageReference('/apex/CG_IntakeVH?id='+wid);
        }
        else if(PageName=='IntakeUE')
        {
            ReturnPage = new pageReference('/apex/CG_IntakeUE?id='+wid);
        }
        else if(PageName=='IntakeCC')
        {
            ReturnPage = new pageReference('/apex/CG_IntakeCC?id='+wid);
        }
        else if(PageName=='IntakeWR')
        {
            ReturnPage = new pageReference('/apex/CG_IntakeWarranty?id='+wid);
        }
        else if(PageName=='IntakeRJ')
        {
            ReturnPage = new pageReference('/apex/CG_IntakeRJ?id='+wid);
        }
        else if(PageName=='Jobplan')
        {
            ReturnPage = new pageReference('/apex/CSS_JobPlanParts?id='+wid);
        }
        else if(PageName=='ClaimsIntake'){
            ReturnPage = new pageReference('/apex/CG_ClaimsIntake?id='+wid);
        }
        else if(PageName=='ClaimsPartsandOtherClaimbles'){
            ReturnPage = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+wid);
        }
        else if(PageName=='CG_Claimsjobnotes'){
            ReturnPage = new pageReference('/apex/CG_Claimsjobnotes?id='+wid);
        }
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

        try{
            if(fileBody != null || fileBody2 != null || fileBody3 != null )
            { 
                system.debug('=======> +parentId==' +parentId +'====wid'+wid );
                system.debug('=======> +fileSize1==' +filesize1 );
                Attachment attachment = new Attachment();
                attachment.body = this.fileBody;
                if(PageName=='Jobplan' || PageName=='ClaimsPartsandOtherClaimbles' ){
                    system.debug('=======> +PageName==' +PageName);
                    if(fileName!=null){
                        // if(fileName.contains('CGJBPLATT03'))
                        attachment.name = 'CGJBTLATT03-'+this.fileName;
                    }
                } 
                else{
                    attachment.name = this.fileName;
                }
                attachment.description = description1;
                attachment.parentId = parentId;

                Attachment attachment2 = new Attachment();
                attachment2.body = this.fileBody2;
                if(PageName=='Jobplan' || PageName=='ClaimsPartsandOtherClaimbles'){
                    if(fileName2!=null){
                        //if(fileName2.contains('CGJBPLATT03'))
                        attachment2.name = 'CGJBTLATT03-'+this.fileName2;
                    }
                }
                else{
                    attachment2.name = this.fileName2;
                }
                attachment2.description = description2;
                attachment2.parentId = parentId;

                Attachment attachment3 = new Attachment();
                attachment3.body = this.fileBody3;
                if(PageName=='Jobplan' || PageName=='ClaimsPartsandOtherClaimbles'){
                    If(fileName3!=null){
                        // if(fileName3.contains('CGJBPLATT03'))
                        attachment3.name = 'CGJBTLATT03-'+this.fileName3;
                    }
                }
                else{
                    attachment3.name = this.fileName3;
                }
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
                // }
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
        }catch(exception e){
            system.debug('Exception in attachment '+ e.getMessage());
            return false;
        }
    }

    /* delete files for parent account*/
    public PageReference DeleteFile() 
    {
        system.debug('atthId--'+atthId);
        try
        {
            Attachment attachment = new Attachment(parentid=wid );
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
        atthName='';
        description='';
        system.debug('AtthId***'+atthid);
        List<Attachment> edtAttach = new List<Attachment>([Select Id, Name, Description from attachment where id= :atthId]);
        // description = edtAttach[0].Description;
        if((pagename=='JobPlan'|| pagename=='ClaimsPartsandOtherClaimbles') && edtAttach[0].Name.Contains('CGJBTLATT03-'))
            atthName = edtAttach[0].Name.subString(12);
        else
            atthName = edtAttach[0].Name;
        system.debug('atthName***'+atthName);
        System.debug('The description is'+description);

    }
    public void closePopup() {
        displayPopup = false;
    }
    public void showPopup6() {
        system.debug('inside shoPopup6 ' +DeleteFlg);
        if(DeleteFlg == False){displayPopup6 = False;}
        else
            displayPopup6 = true;
        system.debug('======> '+atthId);
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
        //description='';
        //atthName='';
    }
    public PageReference redirectPopup()
    {    
        displayPopup = false;
        PageReference p=new Pagereference('/apex/CSS_Job_Detail?nto=HOME');
        p.setRedirect(true);
        return p;
    } 
}