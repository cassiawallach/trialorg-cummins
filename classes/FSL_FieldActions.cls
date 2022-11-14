/**********************************************************************
Name:FSL_FieldActions
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class written to get FieldActions on changing the PSN on the work order
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         05/16/2019                         
***********************************************************************/
public class FSL_FieldActions
{
   /* public Id vMore_JobId {
        get;
        set {
            vMore_JobId = value;
        }
    }*/
   
   // public List<CSS_CampTsbTrp__c> lstALL {get;set;}
    public List<CSS_Solution_Component__c> solCompCTTP {get;set;}
 public CG_cancelServiceJobWrapper cancelSJWrapperObj1{get;set;}
    public String ComponentId{get;set;} 
    public String Type{get;set;}
    
    public Boolean isClaimEnabled {get;set;}
    public Boolean isJoblocClaimEnabled {get;set;}
    
    public List<CSS_UserLocation__c> checkclaims;
    
    Public void mainSOQL()
    {
        workOrder=[Select Id, WorkOrderNumber,Failure_Date__c,Asset.Unit_Type__c,DSID__c,DSID_WorkGroup__c,
                   Asset.Id,Asset.Name,Asset.Unit_Number__c,Asset.Service_Model__c,Asset.Application_Code__c,Asset.Model__c,Asset.Make__c,Asset.VIN__c,Asset.Warranty_Start_Date__c,ServiceTerritory.Name,ServiceTerritory.Region__c,ServiceTerritory.Territory__c,
                   (Select Id,Name,Case_Name__c,FSL_Service_Job__c,Repair_response__c,Solution_Title__c ,Solution__c,Diagnostic_Response__c FROM CSS_Solutions__r),
                   (Select id, name,Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrps__r where(FSL_ServiceJob__c=:Wid and (performed_review__c=True and performed__c=False))),
                   // (select Id, Name, OrderReference__c from CSS_Quotes__r),
                   (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC)
                   from WorkOrder where id=:WId];
    } 
    
    
    
    public fsl_fieldactions() {
       // controllerRef = this;
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        pgName=ApexPages.CurrentPage().getParameters().get('pgflag');
        rpid=ApexPages.CurrentPage().getParameters().get('rpHistory');
        String QId = ApexPages.CurrentPage().getParameters().get('DSID');
        strEDSCodes=ApexPages.CurrentPage().getParameters().get('EDSCodes');
        String NTO = ApexPages.CurrentPage().getParameters().get('nto');
        
        string userId = UserInfo.getUserId();
       
        
        if (Wid == null) {
            mil_measure = 'Miles';
            fail_measure = 'Miles';
         //   css_redirect();
        }
        else  {
            try {
                
                mainSOQL();
                isJoblocClaimEnabled = false;
                if(Userinfo.getUserId()!=null)
                {
                    
                    
                    system.debug('isClaimEnabled'+isClaimEnabled);
                }
                system.debug('dhanvi**'+workOrder);
                
                //End Story      
                //Added Code for Service Job Logs - Start
                if(workOrder != null) {
                    
                    try{
                        if(workOrder != null && workOrder.Asset.Name != null && workOrder.Asset.Name != ''){
                            // added for ROD Defect 111715 & 111716 by Venkat
                            if(workOrder.Asset.Name.isNumeric())
                            {
                                //recconFlag = css_utility.getReconEngine(decimal.valueof(workOrder.Asset.Name));
                            }
                            
                            
                        }
                        if(workOrder.Notes != null && !workOrder.Notes.isEmpty()){
                            workOrder1 = new List<Note>();
                            for(Note b : workOrder.Notes){
                                if(b.title.equalsIgnoreCase('CAMPCOMMENTS')){
                                    workOrder1.add(b);
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    Catch(exception e){
                        System.debug('catching exception>>>>'+e);
                    }
                    //Get QSOL Docs for existing ESN
                    
                }
                
                
                /*  Defect 63819 Code Begins - Displaying Diagnosis and Repair Time in Job Over View*/
                
                /*  Defect 63819 Code Ends - Displaying Diagnosis and Repair Time in Job Over View*/
                
                //Added Code for Service Job Logs - End
                system.debug('pgName'+pgName);
                
                
            }
            catch(Exception e)  {
                system.debug('Repair Constructor '+ e.getLineNumber() + ' : '+e.getMessage());
            }
            //Modified by Manjari
            
            //End
        }
    }
    
   
    public void updateNotes(){  
        try{
            userlang = css_utility.getUserAttributes(userinfo.getUserId());
            accountlang = css_utility.getLanguage(userlang.LanguageLocaleKey); 
            String UserLocation = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode');
            
            
            accountlang = css_utility.getLanguage((String)Cache.Session.get('local.CSSPartition.UserLanguageLocaleKey'));
            system.debug('accountlang>>>>>>'+accountlang);
          //  isReadUser = false;
            
            system.debug('accountlang>>>>:'+accountlang);
            getQSOLDocs();  //getSiebelQSOLCampaigns();
         //   jobPlanAction();
            
            update notesList; 
        }catch(exception e){
            system.debug('Entered in Catch Update notes of repair controller'+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }
    
    public void getQSOLDocs(){
        try{
            lstCAM = new List<CSS_CampTsbTrp__c>();
            lstTRP = new List<CSS_CampTsbTrp__c>();
            lstTSB = new List<CSS_CampTsbTrp__c>();
            lstATC = new List<CSS_CampTsbTrp__c>();
            system.debug('in pageload getQSOLDocs before calling CG_BL_Intake.getSiebelQSOLCampaigns>>>'+workOrder.Asset.Name);
            List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getSiebelQSOLCampaigns(workOrder.Id, workOrder.Asset.Name, accountlang.CSS_QsolLanguage__c, workOrder.Asset.Service_Model__c, workOrder.Failure_Date__c);
            system.debug('in pageload getQSOLDocs after calling CG_BL_Intake.getSiebelQSOLCampaigns campaignsList>>>:'+campaignsList);
            if(campaignsList !=null && campaignsList.size()>=0)
                lstCAM = campaignsList.get(0);
            if(campaignsList !=null && campaignsList.size()>=1)
                lstTSB = campaignsList.get(1);
            if(campaignsList !=null && campaignsList.size()>=2)
                lstTRP = campaignsList.get(2);
            if(campaignsList !=null && campaignsList.size()>=3)
                lstATC = campaignsList.get(3);
            
        } catch(exception e) {
            system.debug('EXCEPTION of fsl_fieldactions getQSOLDocs method >>> '+e.getMessage() + e.getLineNumber());
        }
    }
    
    //public String region{get;set;}
    Transient List<CSS_CampTsbTrp__c> lstQSOLDocs;
    public Integer timeinMinutes{get;set;}
    public Integer timeinhours {get;set;}
    public string sServiceModel {get; set;}
    public String dispDTime{get;set;}
    public String dispRepTime{get;set;}
    public Decimal digTime{get;set;}
    public Decimal repTime{get;set;}
    public Decimal NewrepTime{get;set;}
    public Decimal NewdigTime{get;set;}
    public Integer NewdigMin{get;set;}
    public Integer NewrepMin{get;set;}
    public boolean bmsEnabled {get;set;}  
    public String selectedSubStatusVal {get;set;}
    public string dsidIndi{get;set;}//67550
    list<Note> notesList = new list<Note>();
   // public Boolean isPrioritized {get; set;}
    public WorkOrder workOrder {get; set;}
   // public css_job_order__c workJob {get;set;}
   // Transient List<CSS_CampTsbTrp__c> qsolCTTP {get;set;}
    public List<Note> workOrder1 {get;set;}
    Transient public List<CSS_CampTsbTrp__c> lstCAM {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTRP {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTSB {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstATC {get; set;}
    public string comm {get;set;}
    
    public ID Wid;
    
    public string rpid;
    public string strEDSCodes;
    public String filterMake;
    /* Added as per Story# 64030 start*/
   
    
    public String filterModel;
   // public Boolean displaycertPopup {get;set;}
   // public Boolean displaySrvModPopup {get;set;}
   // public Boolean displaySrvModPopup1 {get;set;}
    
    
    public string mil_measure;
    public string fail_measure;
    public List<AggregateResult> lmake = new List<AggregateResult>();
    public List<CSS_Make_Model_Access__c> lmodel = new List<CSS_Make_Model_Access__c>();
    
    
    
    list<Profile> profileList;
    public string pgName;
   // string DSID{get;set;}
    //public string getDSID(){
      //  DSID = workJob.DSID__c;
       // return DSID;
    //}
    
   
    public List<CSS_Solution_Component__c> getALLRecords(){
        system.debug('in getALLRecords...accountlang>>>:'+accountlang);
        
        try{
            //new code start
            //Ravikanth Modified Query filters 
            solCompCTTP = new List<CSS_Solution_Component__c>([SELECT Id, Type__c, URL__c, Component_Id__c, Campaign_Description__c, Complete_Indicator__c, Performed__c, Performed_Review__c, Reviewed__c, FSL_Service_Job__c FROM CSS_Solution_Component__c WHERE FSL_Service_Job__c =: workOrder.Id AND Type__c IN('Campaign','TRP','ATC') AND (Status__c = 'Approved' AND (Complete_Indicator__c = false OR Multiple_Times__c = true OR (Complete_Indicator__c = true AND Multiple_Times__c = true))) ORDER BY Type__c LIMIT 1000]);
           // solCompCTTP = new List<CSS_Solution_Component__c>([SELECT Id, Type__c, URL__c, Component_Id__c, Campaign_Description__c, Complete_Indicator__c, Performed__c, Performed_Review__c, Reviewed__c, FSL_Service_Job__c FROM CSS_Solution_Component__c ]);
            //Get QSOL Docs for existing ESN
            system.debug('solCompCTTP>>>>>'+solCompCTTP);
            List<CSS_CampTsbTrp__c> lstQSOLDocs = new List<CSS_CampTsbTrp__c>([Select Id, Type__c, FSL_ServiceJob__c,ESN__c, Doc_Num__c, 
                                                                               Doc_Title__c, URL__c, Reviewed__c,Performed__c,
                                                                               Performed_Review__c,Cu_Language__c from CSS_CampTsbTrp__c
                                                                               where FSL_ServiceJob__c = :workOrder.Id and ESN__c = :workOrder.Asset.Name  order by Performed_Review__c desc]);
            
            system.debug('lstQSOLDocs>>>>>'+lstQSOLDocs);
            //add qsol links
            solCompCTTP = CG_BL_Intake.addQSOLLinksToSiebelQueryList(solCompCTTP, lstQSOLDocs);
            //new code end
        }catch(exception ex){
            System.debug('in catch of getALLRecords of fsl_fieldactions >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return solCompCTTP;
    }
    
    
    public integer getCamps(){
        
        
        if(lstCAM != null){
            return lstCAM.size();
        }else
            return 0;
    }
    public integer getTrps(){
        
        
        if(lstTRP != null){
            return lstTRP.size();
        }else
            return 0;
    }
    
    public integer getAtcs(){
        
        
        if(lstATC != null){
            return lstATC.size();
        }else
            return 0;
    } 
    
    public integer getTsbs(){
        
        
        if(lstTSB != null){
            return lstTSB.size();
        }else
            return 0;
    }     
    public void saveCampNotesCheckBox(){
        mainSOQL();
        //  CampNotes();
         system.debug('Today comm>>' + comm);
        saveCheckBox();      
    }
    
    public pagereference saveCheckBox(){
        List<ID> solCmprecsLst = new List<ID>();
        try{
            if(comm !='' && comm !=null ){
                system.debug('JobID' +Wid);
                Note x = new Note();
                x.Title = 'CAMPCOMMENTS';
                x.ParentId = Wid;  
                x.Body = comm;
                insert x;
            }
            
           
            //new code start
            System.debug('before updating solCompCTTP>>>:'+solCompCTTP);
            if(solCompCTTP != null && !solCompCTTP.isEmpty() && solCompCTTP.size()>0)
            {
                update solCompCTTP;
                integer count = 0;
                for(CSS_Solution_Component__c obj : solCompCTTP)
                {
                    if(obj.Performed__c == true && count<90)
                    {
                        solCmprecsLst.add(obj.Id);
                        FSL_getDetailCoverage.getSolutionCoverage(obj.Id);
                        FSLFieldActionsServices.fieldactionsrtwebservices(obj.Id); // Added Ravi kanth
                        string strDescription = 'Performed' +''+ obj.Type__c +''+ obj.Campaign_Description__c ;
                        FSL_CumminsUtilities.auditTrailInsert('Event-12',obj.FSL_Service_Job__c,strDescription,'','','');
                        system.debug('SolutionID:'+obj.Id);
                        count++;
                    }
                    //Ravikanth added below code for Field actions audit trail
                    if(obj.Reviewed__c == true && count < 90)
                    {
                        string strDescription = 'Reviewed' +''+ obj.Type__c +''+ obj.Campaign_Description__c ;
                        FSL_CumminsUtilities.auditTrailInsert('Event-13',obj.FSL_Service_Job__c,strDescription,'','','');
                        system.debug('SolutionID:'+obj.Id);
                        count++;
                    }
                    if(obj.Performed_Review__c == true && count < 90)
                    {
                        string strDescription = 'Required to perform'+'' +''+ obj.Type__c +''+ obj.Campaign_Description__c ;
                        FSL_CumminsUtilities.auditTrailInsert('Event-14',obj.FSL_Service_Job__c,strDescription,'','','');
                        system.debug('SolutionID:'+obj.Id);
                        count++;
                    }
                    if(comm != null){
                        string strDescription = 'User entered comments'+'' + comm +''+ obj.Type__c +''+ obj.Campaign_Description__c ;
                        FSL_CumminsUtilities.auditTrailInsert('Event-15',obj.FSL_Service_Job__c,strDescription,'','','');
                        system.debug('SolutionID:'+obj.Id);
                        count++;
                    }
                    
                }
                System.debug('after updating solCompCTTP>>>:'+solCompCTTP);
                //  FSLFieldActionsServices.fieldactionsrtwebservices(solCmprecsLst);
                
            }
            
            PageReference pageRef = new pageReference('/apex/FSL_FieldActions?id='+workOrder.id); 
            pageRef.setRedirect(true);
            return PageRef;
            //new code end
        }catch(exception ex){
            System.debug('in catch of saveCheckBox of fsl_fieldactions >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return null;
    }
    
    public user userlang{get; set;}
    public CSS_accountLanguage__c accountlang{get; set;}
    Transient public list<CSS_CampTsbTrp__c> campList{get;set;}
    Transient map<string,CSS_CampTsbTrp__c> qsolCampMap = new map<string,CSS_CampTsbTrp__c>();
   // list<CSS_CampTsbTrp__c> qsolCTTP9 = new list<CSS_CampTsbTrp__c>();
    // Method to call quick serve on page load - start
    public void qsollanguage(){
        list<CSS_CampTsbTrp__c> qsolla1 = new list<CSS_CampTsbTrp__c>();
        list<CSS_CampTsbTrp__c> qsolla2 = new list<CSS_CampTsbTrp__c>();       
        
        system.debug('**above user Lang');
        system.debug('**after user Lang');
        
      //  system.debug('checking qsolcttp9'+qsolCTTP9);   
        if(lstQSOLDocs != null && !lstQSOLDocs.isEmpty()){  
            //for(CSS_CampTsbTrp__c camp : qsolCTTP9){
            if(lstQSOLDocs[0].Cu_Language__c != null && lstQSOLDocs[0].Cu_Language__c != accountlang.CSS_QsolLanguage__c ){                    
                qsolla1.add(lstQSOLDocs[0]);                       
            }
            if(lstQSOLDocs[0].Cu_Language__c != null && lstQSOLDocs[0].Cu_Language__c == accountlang.CSS_QsolLanguage__c ){                    
                qsolla2.add(lstQSOLDocs[0]);                       
            }
            // hardcoding the  accountlang.CSS_QsolLanguage__c=en }
            if(Wid != null && workOrder.Asset.Name != null && (!qsolla1.isEmpty()|| !qsolla2.isEmpty())){
                campList = CSS_QuickServe.getQsolDocSaveLang(workOrder.Id, workOrder.Asset.Name, accountlang.CSS_QsolLanguage__c );
                if(campList != null && !campList.isEmpty()){
                    for(CSS_CampTsbTrp__c campRec : campList){
                        qsolCampMap.put(campRec.Doc_Num__c,campRec);
                    }
                }
            }
        }      
        
    } 
    
    
    // Start Added Ravikanth ,To getAccess Token in this method 
    public static string getTokenQSOL(){
        string strgetacess = FSL_CL_QSOLIntegrations.getToken('FSL_GetApiToken_QSOL');
        return strgetacess ;
    }
    
    public  PageReference CSSSolutionsFromQSOL(){
        
        
        string strSerialNumber ;
        string endPoint ;
        string docType ;
        string language ;
        string businessUnit ;
        CSS_Solution_Component__c objCSS =[select id ,FSL_Service_Job__c,FSL_Service_Job__r.Asset.Name,Component_Id__c from CSS_Solution_Component__c where id=:componentid];
        
        if(objCSS.FSL_Service_Job__r.Asset.Name!=null){
            strSerialNumber = objCSS.FSL_Service_Job__r.Asset.Name ;
        }
        HttpRequest req;
        HttpResponse res;
        String tokenStr2;
        
        CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('FSL_QSOL_Getwarrantydocs');                
        endPoint = conDetails.End_Point__c;
        docType = conDetails.DocumentType__c;
        language = conDetails.Language__c ;
        businessUnit = conDetails.BusinessUnit__c ;
        
        Http h = new Http();
        List<FSL_QSOLResponsewrapper> fslQSOLResps = new list<FSL_QSOLResponsewrapper>();
        
        
        req = new HttpRequest();
        req.setMethod('GET');
        req.setTimeout(100000);
        //  req.setBody(reqBody);   
        req.setEndpoint(endPoint+'serialNumber='+strSerialNumber+'&'+'documentType='+ docType +'&'+'language='+language +'&'+'businessUnit='+businessUnit );
        
        // req.setEndpoint('https://qs-stg.cummins.com/integrationservices/api/getWarrantyDocs?serialNumber=79643468&documentType=TRP&language=en&businessUnit=EBU');
        tokenStr2 = getTokenQSOL();
        system.debug('type check'+type);
        system.debug('component id'+componentid);
        String authorizationHeader = 'Bearer '+ getTokenQSOL();
        req.setHeader('Authorization', authorizationHeader);      
        system.debug('reqreqreq:::'+req);
        res = h.send(req);
        
        String responseBody = res.getBody();
        // responseBody = ' [ ' + responseBody + ' ] '; 
        fslQSOLResps = (List<FSL_QSOLResponsewrapper>)JSON.deserialize(responseBody, List<FSL_QSOLResponsewrapper>.Class);
        system.debug('response for syptoms\n::'+responseBody);
        list<CSS_Solution_Component__c> lstSol = new list<CSS_Solution_Component__c>();
        string strURL ;
        string docNumber;
        if(objCSS.Component_Id__c!=null && objCSS.Component_Id__c!=''){
            docNumber =objCSS.Component_Id__c ; // To Identy document type based on document number
        }    
        for(FSL_QSOLResponsewrapper owrapper : fslQSOLResps ){
            system.debug('checkdoc-->'+owrapper.documentNum);
            system.debug('checkdocdocNumber-->'+docNumber);
            if(owrapper.documentNum == docNumber){
                
                strURL = owrapper.documentLink ;
            }
            
        }
        viewcampaigns(objCSS.FSL_Service_Job__r.id);
        if(strURL !=null){
            PageReference QSOLPage = new PageReference(strURL);
            //QSOLPage.setRedirect(true);
            return QSOLPage;
        }
        else{
        PageReference QSOLPageError = new PageReference('/apex/FSL_FieldActionsError');
            return QSOLPageError ;
         
        }
        
    }
    
    @future 
    public static void viewcampaigns(string serviceorderId){
        FSL_CumminsUtilities.auditTrailInsert('Event-08',serviceorderId,'','','','');
    }
    
    
    // Ravikanth end
}