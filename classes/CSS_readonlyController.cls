public without Sharing class CSS_readonlyController {
    public css_job_order__c workJob {get;set;}//<!----DEFECT 73249------>
    public list<Note> workjob2{get; set;} //<!----DEFECT 65797------>
    //public Id Wid; 
    public Id jobId{get;set;}
    public string mil_measure;
    public Boolean displayPopup {get;set;}
    public Boolean displayPopup4 {get;set;}
    public Boolean displayPopup8 {get;set;}
    public Boolean showViewEdit{get;set;}
    public Boolean editTriage{get;set;}
    public List<Attachment> jobAttach {get;set;}
    public List<CSS_Solution_Component__c> lstSolComp {get;set;}
    public List<CSS_Parts_Options__c> lstPartsComp {get;set;}
    public List<CSS_Solutions__c> solList{get;set;}
    public List<CSS_Solutions__c> solRepairList{get;set;}
    list<Note> notesList = new list<Note>();
    public Boolean isDealer {get; set;}
    public string pgName;
    public string dsidIndi{get;set;}
    public datetime insitetimestamp;
    
    public Id vMore_JobId {
        get;
        set {
            vMore_JobId = value;
            
        }
    }
    
    public css_readonlyController(){
        //String url = ApexPages.CurrentPage().getUrl();
        //system.debug('url>>>>>>>>'+url);
        
        if(ApexPages.CurrentPage().getParameters().size() > 0){
            jobId = ApexPages.CurrentPage().getParameters().get('id');  
        }
        pgName=ApexPages.CurrentPage().getParameters().get('pgflag');  
        String orgType = css_utility.getOrgType(UserInfo.getUserId());
        if(orgType == 'DLR'){
            isDealer = true;
        }
        else{
            isDealer = false;
        }
        
        // system.debug('Wid>>>>>>>>>>'+Wid);
        Id userId = UserInfo.getUserId();
        system.debug('userId>>>>>>'+userId);
        if (jobId == null) {
            css_redirect();
        }
        else  {
            try{
                
                
                
                
                workJob = [Select   Id,Name,Account__r.isCampTrp__c,Customer_Name__c,createdDate,Shop_Work_Order__c,CSS_Hours__c,Equipment_ID__c,INSITE_UpdateTimeStamp__c,CSS_Job_Location_Code__c,Sub_Status__c,License_Plate__c,Warranty_Authorization_Flag__c,Location_Certification__c,Repair_Location__c,Sub_Type__c,CSS_Mission_Disabling__c,Before_In_Service__c,Preventive_Maintenance__c,Expedited_Service__c,DiagTimeExtendedHrsCalculation__c,
                           Application__c,Application_Desc__c,Unit_Number__c,DSID__c,Date_in__c, CoverageResponse__c,
                           DSID_Creation_Timestamp__c, DSID_Status__c,Model__c,Make__c,VIN__c,
                           Repeat_Or_Recent_Calc__c,JobLocation__c,Service_Model__c ,Before_Image__c, After_Image__c,
                           DSID_UpdateTimestamp__c,OwnerId,Assigned_to__r.Name,Failure_date__c,
                           Additional_Tech1__r.Name,Additional_Tech2__r.Name, Additional_Tech3__r.Name,Additional_Tech4__r.Name,Additional_Tech5__r.Name,Additional_Tech6__r.Name,Additional_Tech7__r.Name,Additional_Tech8__r.Name,Additional_Tech9__r.Name,Status__c,
                           ESN__c, Mileage__c, Mileage_Measure__c, chevron_page__c, Creator_Location__c,Close_Job_Date_Time__c,
                           General_Symptoms__c, Assigned_To__c, LastModifiedDate, Engine_Run_Time_Hours_Mileage_km_miles__c, EditComplaint__c,
                           Customer_Code__c, EditCause__c, EditCoverage__c, EditCorrection__c, Qsol_Fuel_Pump_Part_Number__c, Latest_Event_Time_Stamp__c,     
                           Warranty_Start_Date__c,Failure_Point__c,Category__c,Category_Desc__c,Category2_Desc__c,Category3_Desc__c,Category4_Desc__c,Category5_Desc__c,
                           Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type5__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,
                           Complaint_Type__c,Actual_Technician_Time__c,TotalSRTExtendedHours__c,(Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname  from  Notes ),
                           (select id,Type__c,URL__c,  Doc_Num__c, Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__r where job_order__C=:jobId LIMIT 1000)   
                           from   CSS_Job_Order__c  
                           where   id= :jobId]; //:jobId];// <!----DEFECT 65797------>
                
                system.debug('**->workJob<-**'+workJob);
                //lstSol = [select Case_Name__c,Solution_Title__c,Name,Diagnostic_notes__c,Repair_Notes__c from CSS_Solutions__c where service_job__c = :Wid
                lstSolComp = [Select Id, Name,Solutions__r.Solution_Title__c,Solutions__r.Diagnostic_notes__c,Solutions__r.Repair_Notes__c from CSS_Solution_Component__c where service_job__c = :jobId and Solutions__r.Diagnostic_Response__c='Most likely the solution' and Selected_Component__c= true ];
                
                lstPartsComp =[select Id, Name,FailurepartId__r.Name,Part_Description__c, Quantity__c,Service_partnumber__c,Part_Name__c from CSS_Parts_Options__c where Service_Job__c =:jobId and FailurepartId__c != null and selected_part__c = true];
                system.debug('lstPartsComp--'+lstPartsComp);
                
                solList = [Select id,name,Solution_Title__c,Diagnostic_notes__c,Repair_Notes__c, (Select id, name, Selected_Component__c  from CSS_Solution_Components__r where service_job__c = :jobId) from CSS_Solutions__c where Service_Job__c = :jobId and Diagnostic_Response__c='Most likely the solution'];
                system.debug('solList--'+solList);
                //system.debug('solListcmp--'+solList.CSS_Solution_Components__r);

                solRepairList = [Select id,name,Solution_Title__c,Diagnostic_notes__c,Repair_Notes__c, (Select id, name, Selected_Component__c from CSS_Solution_Components__r where service_job__c = :jobId and Selected_Component__c= true) from CSS_Solutions__c where Service_Job__c = :jobId and (Repair_Response__c='Repair Successful.' or Repair_Response__c='Repair Successful with additional parts/procedures.')];
                //system.debug('solListcmp--'+solRepairList.CSS_Solution_Components__r);
                loadBasicData();
                
                if(workJob != null ){   
                    jobAttach = new List<Attachment>([Select Id,Name,Description,parentid, LastModifiedDate from attachment where parentid= :jobId and (NOT Description like 'CG_%.eif')]);
                    
                    
                    
                    if(workJob.Notes != null && !workJob.Notes.isEmpty()){
                        for(Note noteRec:workJob.Notes){
                            if(noteRec.title.equalsIgnoreCase('Bold')){
                                if(noteRec.Body != null){
                                    if(!noteRec.Body.contains(userId)){
                                        noteRec.Body += ','+userId;
                                    }
                                }else{
                                    noteRec.Body = userId;
                                }
                                notesList.add(noteRec);
                            }
                            system.debug('noteRec****'+noteRec);
                        }
                        
                    }
                    css_header_nav__c CS = css_header_nav__c.getInstance(UserInfo.getProfileId());
                    
                }
                
                if(workJob.Actual_Technician_Time__c == null){
                    workJob.Actual_Technician_Time__c = 000.0;
                }
            }
            catch (Exception e){
                
            }
        }
        
        /*        if(workJob.Actual_Technician_Time__c == null){
workJob.Actual_Technician_Time__c = 000.0;
}
*/
        
    }
    
    public void updateNotes(){
        update notesList; 
    }
    
    /* <!----DEFECT 65797------> */
    
    public list<Note> getNotex(){
        try{
            if(Workjob.Notes != null && !workjob.Notes.isEmpty()){
                workjob2 = new List<Note>();
                for(Note b : workjob.Notes){
                    string xyx = b.body; 
                    if(b.title.equalsIgnoreCase('CAMPCOMMENTS') && xyx != ''){
                        
                        workjob2.add(b);
                    }
                    
                }
            } 
            return workjob2;  
        }
        catch(exception e){
            return null;
        }
    } 
    
    
    
    public integer getTsbs(){
        try{
            list<CSS_CampTsbTrp__c> qsol3 = new list<CSS_CampTsbTrp__c>();
            if(workjob.CSS_CampTsbTrp__r != null){
                for(CSS_CampTsbTrp__c qsoltsbs : workjob.CSS_CampTsbTrp__r){
                    if(qsoltsbs.type__c.equalsIgnoreCase('TSB')){
                        qsol3.add(qsoltsbs);
                        
                    }
                }
                system.debug('count of tsbs'+qsol3.size());
            }
            
            return qsol3.size();
        }
        
        catch(exception e){
            return null;
        }
        
    }
    
    
    /*-------------code end for defect 65797 -------------*/     
    public PageReference css_redirect()
    {
        PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    public void showPopup() {
        displayPopup = true;
    }
    public void closePopup() {
        displayPopup = false;
    }
    public void showPopup4() {
        displayPopup4 = true;
    }
    public void closePopup4() {
        displayPopup4 = false;
    }
    public void showpopup8() {
        displaypopup8 =true;
    }
    public void closepopup8() {
        displaypopup8 =false;
    }
    public String getmil_measure() 
    {
        return mil_measure;
    }
    public void setmil_measure(String mmeasure) 
    {
        this.mil_measure = mmeasure; 
    }
    
    
    
    
    public string sEncryptToken {get; set;}
    public string sEndPoint {get; set;}
    public Integer statusCode {get;set;}
    public String statusMessage{get;set;}
    public String sFileName{get;set;}
    public String attachId{get;set;}
    
    public void getFile(){
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
    }
    
    
    /*
* This method is used for creating a new Attachment
*/ 
    public Boolean createAttachment(Blob bImage){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into createAttachment method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        try{
            Attachment attachObj = new Attachment();
            attachObj.Name = sFileName;
            attachObj.Description = 'CG_'+sFileName;
            attachObj.ParentId = jobId; //Label.CSS_SampleRecordId;
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
    //Method for Date Formmat of LastModifiedDate
    public String getDtModify() {
        try{
            if(workJob.LastModifiedDate != null){
                //css_utility cUtil = new css_utility();
                String lastModifiedDate = css_utility.getFormattedDate(workJob.LastModifiedDate); //Get formatted String from Utility Class
                return lastModifiedDate; //return the string
            }else{
                return null;
            }
        }catch(exception e){
            system.debug('Entered into catch block of getDtModify method in css_readonly controller>>>>>>>>>'+e.getMessage() + ' ' + e.getLineNumber());
            return null;
        }
    }
    //Method for Date Formmat of Start Job Date/Time
    public String getDtStart() {
        //css_utility cUtil = new css_utility();
        try{
            if(workJob.CreatedDate != null){
                String createdDate = css_utility.getFormattedDate(workJob.CreatedDate); //Get formatted String from Utility Class
                return createdDate; //return the string
            }else{
                return null;
            }
        }catch(exception e){
            system.debug('Entered into catch block of getDtStart method in css_readonly controller>>>>>>>>>'+e.getMessage() + ' ' + e.getLineNumber());
            return null;
        }
    }
    //Method for Date Formmat of Failure Date
    public String getDtFailure() {
        //css_utility cUtil = new css_utility();
        /*String locale_formatted_date_time_value = css_utility.getFormattedDate(workJob.Failure_Date__c); //Get formatted String from Utility Class
return locale_formatted_date_time_value; //return the string*/
        try{
            if(workJob.Failure_Date__c != null){       
                Date d = workJob.Failure_Date__c;
                //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
                String failureDdate = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd MMM yyyy');
                
                return failureDdate;
            }else{
                return null;
            }
        }catch(exception e){
            system.debug('Entered into catch block of getDtFailure method in css_readonly controller>>>>>>>>>'+e.getMessage() + ' ' + e.getLineNumber());
            return null;
        }
    }
    //Method for Date Formmat of Created Date
    public String getDtCreated() {
        try{
            if(workJob.Date_In__c != null){
                //css_utility cUtil = new css_utility();
                 //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
                String dateIn = System.now().format('dd MMM yyyy hh:mm a z');
                //String dateIn = css_utility.getFormattedDate(workJob.Date_In__c); //Get formatted String from Utility Class
                return dateIn; //return the string
            }else{
                return null;
            }
        }catch(exception e){
            system.debug('Entered into catch block of getDtCreated method in css_readonly controller>>>>>>>>>'+e.getMessage() + ' ' + e.getLineNumber());
            return null;
        }
    }
    
    public CSS_getBasicCoverageResponseJ2A basicCoverageDetails{get;set;}
    public map<string,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefType{get;set;}
    public map<string,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefTypeNewENG{get;set;}
    public map<string,map<String,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>> coverageByDefTypeMap{get;set;}
    public map<string,string> coverageURLProceMap{get;set;}
    public boolean reqWrcoverBoolean{get;set;}
    public list<CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails> listcertificatedetails{get;set;}
    public boolean reqWrcertBoolean{get;set;}
    public boolean reqWrTerBoolean{get;set;}
    public string prevmil_measure;
    public boolean showExtCoverage {
        get;
        set;
    }
    public void loadBasicData() {
        //              if(pagName != null && pagName != ''){
        
        //            if(pagName.equalsIgnoreCase('TND') || pagName.equalsIgnoreCase('REPAIR')){
        try {
            if (workJob != null) {
                prevmil_measure = mil_measure;
                if (workJob.CoverageResponse__c != null && workJob.CoverageResponse__c != '') {
                    basicCoverageDetails = new CSS_getBasicCoverageResponseJ2A();
                    basicCoverageDetails = (CSS_getBasicCoverageResponseJ2A) JSON.deserialize(workJob.CoverageResponse__c, CSS_getBasicCoverageResponseJ2A.class);
                    system.debug('basicCoverageDetails coverage resp' + basicCoverageDetails.Header);
                    system.debug('basicCoverageDetails>>>>>>' + basicCoverageDetails);
                    //Building map mapGroupCoverageByDefType
                    mapGroupCoverageByDefType = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
                    mapGroupCoverageByDefTypeNewENG = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
                    coverageByDefTypeMap = new map < string, map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >>> ();
                    coverageURLProceMap = new map < string, string > ();
                    reqWrcoverBoolean = true;
                    system.debug('Coverage Details--'+basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails);
                    for (CSS_getBasicCoverageResponseJ2A.coverageDetails c: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails) {
                        system.debug('c.CoverageType>>>>>>' + c.CoverageType);
                        //if the coverage type is of EMS-Emissions Warranty - NEW-New Engine Warranty
                        if (c.CoverageType == 'EMS-Emissions Warranty') {
                            reqWrcoverBoolean = false;
                            //URl and Procedure Map Values
                            coverageURLProceMap.put('EMS-Emissions Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                            //iterating the CoverageComponentList
                            for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                //calculating miles
                                if (mil_measure != null && mil_measure != '') {
                                    if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                        ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                    }
                                }
                                //#85179    START
                                ccl.status = c.status;
                                ccl.WarrantyEndDate = c.WarrantyEndDate;
                                if(ccl.WarrantyEndDate != null && ccl.WarrantyEndDate!= '') {
                                    date cd = date.parse(ccl.WarrantyEndDate);
                                    DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                    ccl.WarrantyEndDate = getWarrantyDate(DateTime.valueof(mydateGMT));
                                }
                                //#85179    END
                                //populating the map 
                                if (!mapGroupCoverageByDefType.containskey(ccl.CoverageComponentTypeCode)) {
                                    
                                    mapGroupCoverageByDefType.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                                }
                                mapGroupCoverageByDefType.get(ccl.CoverageComponentTypeCode).add(ccl);
                            } //end of inner 1 loop
                        } //end of If cond
                        system.debug('mapGroupCoverageByDefType>>>>*******' + mapGroupCoverageByDefType);
                        //if the coverage type is of NEW-New Engine Warranty
                        if (c.CoverageType == 'NEW-New Engine Warranty') {
                            reqWrcoverBoolean = false;
                            //URl and Procedure Map Values
                            coverageURLProceMap.put('NEW-New Engine Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                            //iterating the CoverageComponentList
                            system.debug('new engine typecheck' + c.CoverageType);
                            for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                //calculating miles
                                if (mil_measure != null && mil_measure != '') {
                                    if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                        ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                    }
                                }
                                //#85179    START
                                ccl.status = c.status;
                                ccl.WarrantyEndDate = c.WarrantyEndDate;
                                if(ccl.WarrantyEndDate != null && ccl.WarrantyEndDate!= '') {
                                    date cd = date.parse(ccl.WarrantyEndDate);
                                    DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                    ccl.WarrantyEndDate = getWarrantyDate(DateTime.valueof(mydateGMT));
                                }
                                //#85179    END
                                //populating the map 
                                if (!mapGroupCoverageByDefTypeNewENG.containskey(ccl.CoverageComponentTypeCode)) {
                                    
                                    mapGroupCoverageByDefTypeNewENG.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                                }
                                mapGroupCoverageByDefTypeNewENG.get(ccl.CoverageComponentTypeCode).add(ccl);
                                system.debug('mapGroupCoverageByDefTypeNewENG>>>>*******' + mapGroupCoverageByDefTypeNewENG);
                            } //end of inner 2 loop
                        } //end of if cond
                        
                    } //end of outer for loop
                    
                    if (mapGroupCoverageByDefTypeNewENG != null && !mapGroupCoverageByDefTypeNewENG.isEmpty()) {
                        coverageByDefTypeMap.put('A-New Engine Warranty', mapGroupCoverageByDefTypeNewENG);
                    }
                    
                    if (mapGroupCoverageByDefType != null && !mapGroupCoverageByDefType.isEmpty()) {
                        coverageByDefTypeMap.put('B-Emissions Warranty', mapGroupCoverageByDefType);
                    }
                    
                    system.debug('checking certification details' + basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails);
                    // Certificate details -- start
                    listcertificatedetails = new list < CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails > ();
                    reqWrcertBoolean = false;
                    for (CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails crtdt: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails) {
                        
                        if (mil_measure != null && mil_measure != '') {
                            if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                crtdt.EndMiles = String.ValueOf((Decimal.valueOf(crtdt.EndMiles) / 0.621371).setScale(0));
                            }
                        }
                        //#85179    START
                        if(crtdt.StartDate != null && crtdt.StartDate != '') {
                            date cd = date.parse(crtdt.StartDate);
                            DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                            crtdt.StartDate = getWarrantyDate(DateTime.valueof(mydateGMT));
                        }
                        if(crtdt.EndDate != null && crtdt.EndDate != '') {
                            date cd = date.parse(crtdt.EndDate);
                            DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                            crtdt.EndDate = getWarrantyDate(DateTime.valueof(mydateGMT));
                        }
                        //#85179    END
                        listcertificatedetails.add(crtdt);
                        
                        
                    }
                    if (listcertificatedetails.isEmpty()){
                        reqWrcertBoolean = true;
                        showExtCoverage = false;
                    }
                    else
                        showExtCoverage = true;
                    system.debug('certificate details' + listcertificatedetails);
                    // Certificate details -- end
                    
                }
                reqWrTerBoolean = false;
            }
            //              }
            //          }     
        } catch (exception e) {}
    }  
    
    public String getWarrantyDate(DateTime dInputDate) {
        
        String locale_formatted_date_time_value = css_utility.getFormattedDate(dInputDate); //Get formatted String from Utility Class
        if (locale_formatted_date_time_value != null)
            return locale_formatted_date_time_value.substring(0, 11); //return the string
        else
            return null;
    }
    
    public string getInsiteTimeStamp(){
        string insitestamp;
        insitetimestamp = workJob.INSITE_UpdateTimeStamp__c;
        if (insitetimestamp !=null) {
            insitestamp=string.valueof(insitetimestamp.format('dd MMM yyyy - hh:mm a z'));
        }
        return insitestamp;
    }
    
    public integer getRepair(){
        AggregateResult[] repair;
        //Added Repair Response condition for defect 63663
        repair = [Select count(Case_Name__c) countRepair from CSS_Solutions__c where Service_Job__c=:jobId and Case_Name__c!=Null and (Not Name like 'a0%')
                  and Repair_Response__c in ('Repair Successful.','Repair Successful with additional parts/procedures.')];
        integer repairCount = integer.valueOf(repair[0].get('countRepair'));
        System.debug('The solutions is>>>>>>>>!!!!!!'+repairCount);
        return repairCount;
    }
    
    public boolean certifiedSelected {get; set;}
    public boolean certifiedSelected1 {get; set;}
    public boolean certifiedSelected2 {get; set;}
    public boolean certifiedSelected3 {get; set;}
    public boolean certifiedSelected4 {get; set;}
    public boolean certifiedSelected5 {get; set;}
    public boolean certifiedSelected6 {get; set;}
    public boolean certifiedSelected7 {get; set;}
    public boolean certifiedSelected8 {get; set;}
    public boolean certifiedSelected9 {get; set;}
    
     public String getLocCode() {
        String[] LocArray;
        String LocCode='';
        if(workjob.Creator_Location__c !=null && workjob.Creator_Location__c !='')
        { 
            if(workjob.Creator_Location__c.contains('-')){
                LocArray = workjob.Creator_Location__c.split('-');
                // system.debug('LocArray++++++++++++++++++'+LocArray[0]+ LocArray[1]); 
            }
        }
        if(LocArray != null && LocArray.size()>0)
            LocCode = LocArray[1];
        return LocCode; 
    }
    List<CSS_Solution_Component__c> solCompCTTP;
    public List<CSS_Solution_Component__c> getALLRecords(){
        
        try{
            //new code start
            solCompCTTP = new List<CSS_Solution_Component__c>([select Id, Type__c,URL__c,  Component_Id__c, Campaign_Description__c, Performed__c,Performed_Review__c,Reviewed__c,Fail_Code__c,css_account_formula__c from CSS_Solution_Component__c where Service_Job__c= :jobId AND Type__c in('Campaign','TRP','ATC') and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))  order by Type__c LIMIT 1000]);
            //Get QSOL Docs for existing ESN
            List<CSS_CampTsbTrp__c> lstQSOLDocs = new List<CSS_CampTsbTrp__c>([Select Id, Type__c, Job_Order__c,ESN__c, Doc_Num__c, 
                                                                               Doc_Title__c, URL__c, Reviewed__c,Performed__c,
                                                                               Performed_Review__c,Cu_Language__c from CSS_CampTsbTrp__c
                                                                               where Job_Order__c = :jobId and ESN__c = :workJob.ESN__c and Type__c !='TSB' 
                                                                               order by Performed_Review__c desc]);
            //add qsol links
            solCompCTTP = CG_BL_Intake.addQSOLLinksToSiebelQueryList(solCompCTTP, lstQSOLDocs);
            //new code end
        }catch(exception ex){
            System.debug('in catch of getALLRecords of css_repair_job >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return solCompCTTP;
    }
    
}