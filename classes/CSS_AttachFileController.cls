public class CSS_AttachFileController {

    
    public Id sobjId {get; set{sobjId = value;}
                     
                     }
    
    public Blob fileBody {get;set;}
    public string sEncryptToken {get; set;}
    public string sEndPoint {get; set;}
    public Integer statusCode {get;set;}
    public String statusMessage{get;set;}
    public String sFileName{get;set;}
    public String attachId{get;set;}
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
    public CSS_AttachFileController(){
    system.debug('Atthid111***'+atthid);
        
   jobAttach = new List<Attachment>([Select Id,Name,Description,parentid, LastModifiedDate from attachment where parentid= :sobjId  and (NOT Description like 'CG_%.eif') and (NOT Name like 'CGJBTLATT03%')]);

    }    
    
        public PageReference delAttachment()
    {
        if (atthId != null)
        {
            Attachment AttachmenttoDel=new Attachment(id=atthId);
            delete AttachmenttoDel;
            PageReference pageRef = new pageReference('/apex/CSS_JobReadOnly?id='+sobjid); 
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
            PageReference pageRef = new pageReference('/apex/CSS_JobReadOnly?id='+sobjid); 
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
       
        PageReference ReturnPage = new PageReference('/apex/CSS_JobReadOnly?id='+sobjId); 
        ReturnPage.setRedirect(true);
        return ReturnPage;        
        
    }
    public List<Attachment> getAttach(){
        // jobAttach=[SELECT Body,name,Description FROM Attachment WHERE ParentID = :sobjId]; Sai:Feb202017: Commented it for Prod Defect and included the below line(113)
        jobAttach =[SELECT Id,Name,Description,parentid, LastModifiedDate FROM Attachment WHERE ParentID = :sobjId and (NOT Description like 'CG_%.eif') and (NOT Name like 'CGJBTLATT03%')];
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
            
            // inser the attahcment
            //result = Database.insert(attachment);
            // reset the file for the view state
            
            if (fileBody != null)
            {
                result1 = Database.insert(attachment);
            }
            //result2 = Database.insert(attachment2);
            if (fileBody2 != null)
            {
                result2 = Database.insert(attachment2);
            }
            //result3 = Database.insert(attachment3);
            if (fileBody3 != null)
            {
                result3 = Database.insert(attachment3);
            }
            if((fileBody != null && result1.isSuccess() == false) || (fileBody2 != null && result2.isSuccess() == false)
               || (fileBody3 != null && result3.isSuccess() == false ))
                Success = false;
            else
                Success = true;
            
        } 
        return Success ;
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
    
     /*public void getFile(){
        System.debug('in getFile method...');
        sEncryptToken = '';
        //sEndPoint = '';
        attachId = '';
        sFileName = '';
        sFileName = Apexpages.currentPage().getParameters().get('fileName');
        System.debug('sFileName>>>>>>>>>>>>>:'+sFileName);
        //sFileName = 'I-20170330-083317843.eif'; //file in STG Server
        DateTime dDtTime;
        String sDtTime;
        try {
            dDtTime = System.now();
            sDtTime = dDtTime.format('yyyy-MM-dd\'T\'HH:mm:ss.sss\'Z\'', 'GMT');
            //string sEndPoint = 'https://connectedsolutions-dev.cummins.com/INSITEImage/v1/imagefile';
            //sEndPoint = 'https://connectedsolutions-stg.cummins.com/INSITEImage/v1/imagefile';
            sEndPoint = (CSS_getConnnectionDetails.getConnection('InsiteImage')).End_Point__c;
            System.debug('sEndPoint>>>>>>>>>>>>>:'+sEndPoint);
            string sPsPhrase = 'wEC38PruRaSw.bEm';
            Blob bIVKey = Blob.valueOf(sPsPhrase);
            string sUnEncrypt = sFileName + '|' + sDtTime;
            Blob bTokenString = Blob.valueOf(sUnEncrypt);
            Blob bStrEncrypt = Crypto.encrypt('AES128',bIVKey,bIVKey,bTokenString);
            sEncryptToken = EncodingUtil.base64Encode(bStrEncrypt);
            System.debug('sEncryptToken>>>>>>:'+sEncryptToken);
            
            //Download code
            http h = new http();
            HttpResponse res = new HttpResponse();
            httpRequest req = new httpRequest();
            req.setHeader('Token', sEncryptToken);
            req.setMethod('GET');
            req.setEndpoint(sEndPoint);
            System.debug('Request req>>>>:'+req);
            res =  h.send(req);
            statusCode = res.getStatusCode();
            statusMessage = res.getStatus();
            System.debug('statusCode>>>:'+statusCode+' statusMessage>>>:'+statusMessage);
            //Here's where the magic happens. First get the response as a blob:
            Blob bImage = res.getBodyAsBlob();
            System.debug('blob Image>>>:'+bImage);
            
            //String sBlob = res.getBody();
            //sBlob = EncodingUtil.base64Encode(res.getBodyAsBlob());
            //System.debug('sBlob>>>:'+sBlob);
            
            Boolean flag = createAttachment(bImage);
            System.debug('flag>>>:'+flag);
            
        }catch(exception ex) {
            System.debug('in catch of getFile of css_tnd_job>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }*/
    
      //########### New Azure Insite Images Code Start ################
    public void getFile(){
        System.debug('in getFile method...');
        css_utility utilityObj;
        try{
            //I-20190609-111230668-EB2C1D72.eif 
//I-20190601-121230702-EB2C1D84.eif 
//SI-20190501-101230703-EB2C1D90.eif 
//I-20190121-211426769-EB2C1D71.eif 
            String sFileName = Apexpages.currentPage().getParameters().get('fileName');
            utilityObj = new css_utility();
            //attachId = utilityObj.getInsiteImageAzureFile(sFileName, Wid);
            List<String> outputs = utilityObj.getInsiteImageAzureFile(sFileName, sobjId);
            attachId = outputs.get(0);
            statusCode = Integer.valueOf(outputs.get(1));
            
        }catch(exception ex) {
            System.debug('in catch of getFile of css_tnd_job>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        utilityObj = null; //nullifying after completion of operation to clear memory for performance
    }
    //########### New Azure Insite Images Code End
    
    
    
    
    
     public Boolean createAttachment(Blob bImage){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into createAttachment method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        try{
            Attachment attachObj = new Attachment();
            attachObj.Name = sFileName;
            attachObj.Description = 'CG_'+sFileName;
            attachObj.ParentId = sobjId; //Label.CSS_SampleRecordId;
            attachObj.ContentType = 'application/octet-stream';
            //String encodedString = sBlob;
            //Blob fileBlobData = EncodingUtil.base64Decode(encodedString);
            attachObj.Body = bImage;
            insert attachObj;      
            System.debug('created successfully New AttachmentId>>>>>>>>>>>>>>>>>>>>>>>>>>:'+attachObj.Id);
            
            attachId = getAttachment(attachObj.Id);
            
            return true;
        }catch(Exception ex){
            System.debug('in catch of createAttachment of CSS_tnd_job>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return false;
    }
    
     public String getAttachment(String attachObjId){
        try{
            List<Attachment> attachList = new List<Attachment>([Select Id, Name, ParentId, Body, BodyLength, LastModifiedDate from Attachment where Id=:attachObjId order By LastModifiedDate DESC limit 1]);
            System.debug('attachList size>>>>>>>>>>>>>>>:'+attachList.size());
            if(attachList.size()<=0)
                return null;
            Attachment attachObj = attachList.get(0);
            attachId = attachObj.Id;
            System.debug('retrieved Attachment Id:'+attachId);
            System.debug('sFileName>>>>>>>>>>>>>:'+sFileName);
        }catch(Exception ex){
            System.debug('in catch of getAttachment of CSS_tnd_job>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return attachId;
    }


    }