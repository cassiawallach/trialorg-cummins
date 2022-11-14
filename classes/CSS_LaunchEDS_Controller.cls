/**********************************************************************
Name:CSS_LaunchEDS_Controller
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
Class to launch eds from TND Page.                                                            
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                  DETAIL                                 
1.0 -   Gyan Pany         1/17/2016              INITIAL DEVELOPMENT                    
2.0 -   Varun Sinha       2/11/2016              UDAC WIRE FRAME CHANGES               
3.0 -   Anirudh           2/11/2016              Coding Standards
***********************************************************************/

public class CSS_LaunchEDS_Controller {
    String dS_Status;
    List<CSS_Solutions__c> solutions;
    public Boolean displayPopup10 {get;set;}
    public CSS_LaunchEDS_Controller(css_tnd_job controller) {
        
    }
    public ID eds_JobOrd{
        get;
        set {
            eds_JobOrd = value;
            jobOrder = [select id,DSID__c,Name,Customer_Name__c,ESN__c,DSID_Status__c from CSS_Job_Order__c where ID= :eds_JobOrd];
        }
    }
    public void closePopup10() {
        displayPopup10 = false;
    } 
    public void showPopup10() {
        displayPopup10 = true;
        // List<Attachment> edtAttach = new List<Attachment>([Select Id,Description from attachment where id= :atthId]);
        //description = edtAttach[0].Description;
    }
    public static string session1=null;
    public ID Wid;
    Public CSS_Job_Order__c jobOrder;
    public CSS_LaunchEDS_Controller(ApexPages.StandardController std) {
        jobOrder = (CSS_Job_Order__c) std.getRecord();
        Wid=ApexPages.CurrentPage().getParameters().get('id');
    }
    public CSS_LaunchEDS_Controller() {
        
    }    
    public void check_dS_Status(){
        
        dS_Status = ApexPages.currentPage().getParameters().get('DSStatus');
        String dS_DSID = ApexPages.currentPage().getParameters().get('DSID');
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        string userId = UserInfo.getUserId();
        CSS_Job_Order__c ds = new CSS_Job_Order__c();
                
        try{
            if(Wid != null){
                 ds = [Select id,Name, (Select Id,Body from Notes) from CSS_Job_Order__c where id=:WId];
                 if(ds != null){
                     if(ds.Notes != null && !ds.Notes.isEmpty()){
                         if(ds.Notes[0].Body != null){
                             if(!ds.Notes[0].Body.contains(userId)){
                                 ds.Notes[0].Body += ','+userId;
                             }
                         }else{
                             ds.Notes[0].Body = userId;
                         }                      
                         update ds.Notes;
                     }
                 }
            }
            if(dS_Status != null && dS_DSID != null)
            {                
                if(ds != null){                    
                    ds.DSID_UpdateTimestamp__c  = System.now();
                    ds.DSID_Status__c = ds_Status;
                    System.debug('The status is+++++++++'+ds_Status);
                    System.debug('The status is>>>>>>>>>>>>>'+ds.DSID_Status__c);
                    if(ds_Status.equals('CLOSE')){
                        System.debug('The status is!!!!!!!!!!!!!!!'+ds_Status);
                        ds.Status__c='Repair';
                    }
                    try{
                        update(ds);
                        System.debug('Obj updated<><>');
                    } catch (DMLException e) {
                        System.debug('Exception Occured<><>');
                    }
                }
                else {
                    // createCSSDiagnosticSession(dS_Status,dS_DSID, jobOrder.id);   
                }
                Integer repAllCnt = getAllRepairCount();
                if (ds_Status == 'CLOSE' && repAllCnt > 0) {
                }
                else {
                    retrieveDSList(dS_DSID,ds_Status,WId);
                }

            }
        } catch(Exception e) {
        }
      
    }
    public integer getAllRepairCount(){
        AggregateResult[] repair;
        repair = [Select count(Case_Name__c) countRepair from CSS_Solutions__c where Service_Job__c=:WId ];
        integer repairCount = integer.valueOf(repair[0].get('countRepair'));
        return repairCount;
    } 
       
    @Future(Callout=true)
    public static void retrieveDSList(string ds_DSID,string ds_Status,ID id)
    {   
        CSS_SOAPEDS.retrieveDSListByLoggedInUser(getSession(),ds_DSID,ds_Status,id);
    }
    
    
    public PageReference  getID(){
        System.debug('jobOrder<><>' + jobOrder.id);
        string codes;
        try{
            jobOrder=[select id,DSID__c,Name,Customer_Name__c,ESN__c from CSS_Job_Order__c where ID= :jobOrder.id];
            string session =  getSession();
            if(jobOrder.DSID__c==null || jobOrder.DSID__c=='Invalid ESN'){
                integer i;
                integer j;
                string[] a;
                List<string>Faultcode1 = new List<string>();
                AggregateResult[]  fc = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:jobOrder.id];
                System.debug('The job order is'+jobOrder.Id);
                if(fc.size()>0){
                    integer maxSeq = integer.valueOf(fc[0].get('maxSeq'));
                    System.debug('The max sequence is'+maxSeq);
                    List<CSS_Fault_Code__c> faultCode = [select Primary_Fault_Code__c,Related_Fault_Code__c,FaultCode__c,RelatedFaultCode__c from CSS_Fault_Code__c where Sequence__c=:maxSeq and Job_Order__c=:jobOrder.id  and (Fault_Code_Type__c='APD-P' OR Fault_Code_Type__c='APD-R' OR Fault_Code_Type__c='BPD') limit 5];
                    codes = faultyCodeString(faultCode);
                }
                String model = null; //"ISC CM2150"; //"ISB CM850";
                string title = jobOrder.Customer_Name__c;
                string workorder = jobOrder.Name;
                string serialNumber = jobOrder.ESN__c;
                System.debug('The esn is--->>>>'+serialNumber);
                String propertyName='CSS';
                string propertyValue='True'; 
                jobOrder.DSID__c = CSS_SOAPEDS.createDS(session,title,serialNumber,model,workorder); 
                jobOrder.DSID_Creation_Timestamp__c=system.now();
                CSS_SOAPEDS.setDiagnosticSessionProperty(session,jobOrder.DSID__c,'CSS', 'TRUE');
                CSS_SOAPEDS.setDiagnosticSessionProperty(session,jobOrder.DSID__c,'INSITE_FAULTCODES',codes);
                System.debug('The DSID IS---->>>>>'+jobOrder.DSID__c);
                if(jobOrder.DSID__c==null){
                    jobOrder.DSID__c='Invalid ESN';
                }
                try{
                    update(jobOrder);
                    System.debug('Obj Updated<><>');
                } catch (DMLException e) {
                    string excep;
                    System.debug('Exception Occured<><>');
                }        
            }
        } catch(Exception e) {
        }
        User u = [select profile.name from user where id=:Userinfo.getUserId()];
        //CSS_TnDDealer
        String edsUrl=System.label.CSS_edsUrl;
        String redirectURL;
        System.debug('The pROFILE is'+u.profile.name.toupperCase());
        if(u.profile.name.toupperCase().contains('DEALER')){
            String callURL = System.label.CSS_TnDDealer;
            redirectURL=edsUrl+jobOrder.DSID__c+'&DS=continue&crm_source=CSS&'+callUrl+jobOrder.Id+'&pgnm=tshoot&forcenewsession=false&state=dialog-start';
           // redirectURL = 'https://edstest.ptcmanaged.com/advisor-css/bookmark?DSID=DSBDT4584&DS=continue&crm_source=CSS&'+callUrl+'a093B000000YhqPQAS&pgnm=tshoot&forcenewsession=false&state=dialog-start';
        }
        else{
        //String edsUrl=System.label.CSS_edsUrl;
        String callbackUrl=System.labeL.css_Callback;
        redirectURL=edsUrl+jobOrder.DSID__c+'&DS=continue&crm_source=CSS&'+callbackUrl+jobOrder.Id+'&pgnm=tshoot&forcenewsession=false&state=dialog-start';
        } //String redirectURL=edsUrl+jobOrder.DSID__c+'&DS=continue&crm_source=CSS&'+callbackUrl+jobOrder.Id+'%26pgnm%3Dtshoot%26forcenewsession%3Dfalse%26state%3Ddialog-start';
        //string redirectURL = 'https://edstest.ptcmanaged.com/advisor-css/bookmark?DSID='+jobOrder.DSID__c+'&DS=continue&crm_source=CSS&crm_callback_url=https://cummins--cssdev.cs50.my.salesforce.com/apex/css_JobTnD?id='+jobOrder.Id+'&pgnm=tshoot&forcenewsession=false&state=dialog-start';
        //string redirectURL = 'https://edstest.ptcmanaged.com/advisor-css/bookmark?DSID='+jobOrder.DSID__c+'&DS=continue&crm_source=CSS&crm_callback_url=https://cummins--csstest--c.cs51.visual.force.com/apex/CSS_JobTnD?id='+jobOrder.Id+'&pgnm=tshoot&forcenewsession=false&state=dialog-start';
        System.debug('The url is'+redirectURL);
        PageReference pageRef = new PageReference(redirectURL);
        pageRef.setRedirect(true);
        return pageRef;
    }
    public integer getRepairCount(){
        AggregateResult[] repair;
        repair = [Select count(Case_Name__c) countRepair from CSS_Solutions__c where Service_Job__c=:jobOrder.id and Case_Name__c!=Null and (Not Name like 'a0%')];
        integer repairCount = integer.valueOf(repair[0].get('countRepair'));
        return repairCount;
    }

    public PageReference  getRepairs(){
        AggregateResult[] repair;
        PageReference pageRef;
        repair = [Select count(Case_Name__c) countRepair from CSS_Solutions__c where Service_Job__c=:jobOrder.id and Case_Name__c!=Null and (Not Name like 'a0%')];
        integer repairCount = integer.valueOf(repair[0].get('countRepair'));
        if(repairCount>0){
            string redirect='/apex/CSS_JobRepair?id='+jobOrder.id+'&EDSCodes=true';
            pageRef = new PageReference(redirect);
            pageRef.setRedirect(true);
            return pageRef;
        }
        
        else{
            displayPopup10=true;
            //showError('No repairs have been made');
            //return null;
        }
        return null;
    }
    
    public static string faultyCodeString(List<CSS_Fault_Code__c> faultCode) {
        List<String> faultycode = new List<String>{'','','','',''};
            List<String> relfaultycode = new List<String>{'','','','',''};
                for(Integer i=0;i<faultCode.size();i++) {
                    faultycode[i] =String.valueOf(faultCode[i].FaultCode__c);
                    relfaultycode[i]=String.valueOf(faultCode[i].RelatedFaultCode__c);
                }
        return '{"fcCode1":"'+faultycode[0]+'","relFcCode1":"'+relfaultycode[0]+'","fcCode2":"'+faultycode[1]+'","relFcCode2":"'+relfaultycode[1]+'","fcCode3":"'
            +faultycode[2]+'","relFcCode3":"'+relfaultycode[2]+'","fcCode4":"'+faultycode[3]+'","relFcCode4":"'
            +relfaultycode[3]+'","fcCode5":"'+faultycode[4]+'","relFcCode5":"'+relfaultycode[4]+'"}';
    }    
    
    Public static String getSession(){
        System.debug('The session1 is getting called');
        //static string session='';
        String locale = 'en';
        User u = [select FederationIdentifier,UserGroup__c from user where id=:Userinfo.getUserId()];
        string userName=u.FederationIdentifier;
        string userGroup = u.UserGroup__c;
        string encryptedKey = CSS_SOAPEDS.getgenerateToken(userName,userGroup);
        if(session1==null){
            session1 = CSS_SOAPEDS.login(encryptedKey,locale);
        }
        return session1;
    }
    public List<CSS_Solutions__c> getsolutions() {
        solutions = [select Case_Name__c,Solution_Title__c,Name from CSS_Solutions__c where Service_Job__c=:jobOrder.id and Case_Name__c!=Null and (Not Name like 'a0%') limit 5];
        System.debug('The solution is>>>>>>>>>'+solutions);
        return solutions;      
    }
    datetime dsidtimestamp;
    public string getDSIDStamp(){
        string dsidstamp;
        dsidtimestamp = [select DSID_UpdateTimestamp__c from  CSS_Job_Order__c where id=:jobOrder.id].DSID_UpdateTimestamp__c;
        if(dsidtimestamp!=null){
            dsidstamp=string.valueof(dsidtimestamp.format('dd MMM yyyy - hh:mm a z'));
        }
        return dsidstamp;
    }
}