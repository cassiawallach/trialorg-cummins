/**********************************************************************
Name:CSS_FeedbackStatus1
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                    DETAIL                       
1.0 - Roopa Gadipudi   11/17/2015            INITIAL DEVELOPMENT           
2.0 - Gyan Pany        2/9/2016              UDAC WIRE FRAME CHANGES      
3.0 - Anirudh          2/11/2016             Coding Standards
4.0 - Satish7/18/2016added language methods
***********************************************************************/
public class CSS_FeedbackStatus1 {
    
     //Added transient keyword as part of defect 138444
    Transient public integer ReceivedInProcess{get;set;}
    Transient Public integer caseNotificationCount{get;set;}
    Transient public integer totalCaseNotification{get;set;}
    public transient CSS_Job_Order__c workJob {get; set;}
    Transient public Id Wid {get;set;}
     public Boolean FormsMenu {get;set;}
     public boolean enableflag{get;set;}
    public CSS_FeedbackStatus1() {
        //ReceivedInProcess = [SELECT count() FROM CSS_Feedback_Form__c where FeedbackStatus__c ='ReceivedInProcess'];
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        ReceivedInProcess=0;
        caseNotificationCount=0;
        totalCaseNotification=0;
        FormsMenu = false;
        String feedbackRecordTypeId = css_utility.getRecordTypeId(case.sObjectType, 'Feedback');
        String reportedProblemRecordTypeId = css_utility.getRecordTypeId(case.sObjectType, 'Reported Problem');
        
        List<Case> caseLst = [SELECT recordtypeId
                             FROM Case 
                             WHERE Case_Update_Flag__c = true AND 
                             createdById=: UserInfo.getUserId() AND 
                             (recordtypeId = : feedbackRecordTypeId OR recordtypeId = : reportedProblemRecordTypeId)];
        
        for(Case caseRec : caseLst) {
            if(caseRec.recordtypeId == feedbackRecordTypeId){
                ReceivedInProcess++;
            }
            if(caseRec.recordtypeId == reportedProblemRecordTypeId){
                caseNotificationCount++;
            }
        }
        
        /*ReceivedInProcess = [SELECT count() 
                             FROM Case 
                             WHERE Case_Update_Flag__c = true AND 
                             createdById=: UserInfo.getUserId() AND 
                             recordtypeId = : feedbackRecordTypeId];*/
        
        //String reportedProblemRecordTypeId = css_utility.getRecordTypeId(case.sObjectType, 'Reported Problem');
        //get count of all cases for the reported problem type for a particular owner .
        /*caseNotificationCount = [SELECT count() 
                                 FROM Case 
                                 WHERE Case_Update_Flag__c = true AND createdById=: UserInfo.getUserId() AND recordtypeId = : reportedProblemRecordTypeId];
        */
        if(ReceivedInProcess != null && caseNotificationCount != null){
            totalCaseNotification = caseNotificationCount + ReceivedInProcess;
        }
       displayForms();
    }
    
    public void displayForms(){
        try{
            Wid=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('Wid>>>>>>>'+Wid);
            if(Wid != null){
                workJob = new CSS_Job_Order__c();
                workJob = [Select id,Creator_Location__c,Account__r.Region__c,Account__r.Territory__c,Account__r.Type,Status__c from CSS_Job_Order__c where id =: Wid];
                system.debug('workJob-->'+workJob);
                //Account Regionterritory = css_utility.getRegionTerritory(workJob.Creator_Location__c);Commented by Anirudh s we can get the values directly from account instead of another query
                String Region = workJob.Account__r.Region__c;
                String accType = workJob.Account__r.Type;
                system.debug('accType>>>'+accType);
                system.debug('Region-->'+Region);
                system.debug('Creator_Location__c>>>'+workJob.Creator_Location__c);
                system.debug('Status__c>>>'+workJob.Status__c);
                Boolean showForms;
               // if(Region != null && (Region.toUpperCase() == 'NORTH AMERICA' || Region.toUpperCase() == 'AUSTRALIA/ NEW ZEALAND') && accType == 'Distributor Account'){
                // Modified below as per story 120795 
                /*Roopa Gaipudi added Code as part of IAM AccountType change*/

                boolean DistributorTypeFlag=False;
                string DistributorAcounttype = System.Label.CSS_InternalAccountType;
                 List<string> DistributorAcctypes = new List<String>();
                //= DistributorAcounttype.split(',');
                
                for(String delType: DistributorAcounttype.split(',')){
                  DistributorAcctypes.add(delType);
                }
                 
                if(DistributorAcctypes != null && DistributorAcctypes.size()>0){
                
                  for(string DistributorAcctype:  DistributorAcctypes) {
                    if(DistributorAcctype != null && DistributorAcctype != '') {
                    DistributorTypeFlag = accType.contains(DistributorAcctype.trim());
                       if(DistributorTypeFlag)
                        break;
                    }
                  } 
                } 
       /*Roopa Gaipudi added Code as part of IAM AccountType change*/
                
              //  if(accType == 'Distributor Account'){
                   if(DistributorTypeFlag){
                    showForms = true;
                }
                else{
                    showForms = false;
                }
                if(workJob.Status__c == null || workJob.Status__c == '' || workJob.Status__c == 'Closed' || workJob.Status__c == 'Canceled' || workJob.Status__c == 'Not Supported' || workJob.Creator_Location__c == null || workJob.Creator_Location__c == '' || workJob.Creator_Location__c == 'undefined' || Region == null || Region == '' || Region == 'undefined' || showForms == false){
                    FormsMenu = false;
                }else{
                    FormsMenu = true;
                }
            }
        }catch(exception e){
            system.debug('Entered into catch-method displayForms of CSS_FeedbackStatus1 Controller'+e.getLineNumber() + ' ' + e.getMessage());
        }
    }
     public pagereference changeEnglish(){
        
        css_utility.setUserLang(userInfo.getUserId(), 'en_US');
       
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    
    }
    
    public pagereference changeSpanish(){
        
css_utility.setUserLang(userInfo.getUserId(), 'es');
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }

    public pagereference changeFrench(){
        
css_utility.setUserLang(userInfo.getUserId(), 'fr');
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    } 
    public pagereference changeBrasil(){
        
css_utility.setUserLang(userInfo.getUserId(), 'pt_BR');
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    } 
      public pagereference changeChinese(){
        
    css_utility.setUserLang(userInfo.getUserId(), 'zh_CN');
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
        public pagereference changeAfrikaans(){
        
css_utility.setUserLang(userInfo.getUserId(), 'en_ZA');
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    } 
     public pagereference changeGerman(){
        
        css_utility.setUserLang(userInfo.getUserId(), 'de');
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
    public pagereference changeCanadianFrench(){
        
        css_utility.setUserLang(userInfo.getUserId(), 'fr_CA');
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
    
        public pagereference changeDutch(){
        
        css_utility.setUserLang(userInfo.getUserId(), 'nl_NL');
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
    public pagereference changeTurkish(){
        
        css_utility.setUserLang(userInfo.getUserId(), 'Tr');
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
    
     public pagereference changeRussian(){
        
        css_utility.setUserLang(userInfo.getUserId(), 'ru');
        
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public  pagereference redirectHomePage(){
    PageReference pageRef = new PageReference('/apex/CSS_SS_HOME');
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
    
    public  boolean getReports(){
        boolean isReports = false;
        PermissionSet[] ps = [SELECT Id, name FROM PermissionSet 
                              WHERE name =: Label.CSS_PermissionSet]; 
        
        if(ps != null && ps.size() > 0) {
            PermissionSetAssignment[] psa = [SELECT Id, AssigneeId, PermissionSetId
                                             FROM PermissionSetAssignment 
                                             WHERE AssigneeId = : UserInfo.getuserId() 
                                             AND PermissionSetId = : ps[0].id];
            if(psa != null && psa.size() > 0) 
                isReports = true;
        }
        system.debug(' Reports Tab '+ isReports);
        return isReports;
    }
    
      // Code added for story 118801 start
    Transient List<PermissionSetAssignment> passign = new List<PermissionSetAssignment>([select PermissionSet.Name from PermissionSetAssignment where Assignee.Id = :UserInfo.getUserId()]);
    public  boolean getWrtySysPermission(){
    boolean isSysPermission = false;
        enableflag = false;
    if(passign != null && passign.size() >0) {
    For(PermissionSetAssignment p: passign ){
    system.debug(' Reports Tab PermissionSet.Name'+ p);
     system.debug(' Reports Tab PermissionSet.Name'+ p.PermissionSet.Name);
       // if( p!=null && p.PermissionSet.Name.Contains('CSS_WS')){
       if( p!=null && (p.PermissionSet.Name.Contains('CSS_WS_CSM') || p.PermissionSet.Name.Contains('CSS_WS_TSM') || p.PermissionSet.Name.Contains('CSS_WS_Paccar')|| p.PermissionSet.Name.Contains('CSS_WS_Factory_Warranty_Manager'))){
           system.debug(' Reports Tab PermissionSet.Name inside'+ p.PermissionSet.Name);
           isSysPermission = true;
           system.debug(' Reports Tab PermissionSet.Name inside  isSysPermission '+  isSysPermission);
           break;
           }
           }
           
           }
        system.debug(' Reports Tab '+ isSysPermission);
        return isSysPermission;

    } 
   public  boolean getWrtyExtSysPermission(){
    boolean isSysExtPermission = false;
       
  // List<PermissionSetAssignment> passign = new List<PermissionSetAssignment>([select PermissionSet.Name from PermissionSetAssignment where Assignee.Id = :UserInfo.getUserId()]);
   if(passign != null && passign.size() >0) {
    For(PermissionSetAssignment p: passign ){
          if( p!=null && (p.PermissionSet.Name.Contains('CSS_WS_Dealer') || p.PermissionSet.Name.Contains('CSS_WS_Distributor') || p.PermissionSet.Name.Contains('CSS_WS_DR')|| p.PermissionSet.Name.Contains('CSS_WS_Reports')|| p.PermissionSet.Name.Contains('CSS_WS_Branch_Warranty'))){
              enableflag = true;
              if(p.PermissionSet.name.contains('CSS_WS_Dealer_Rescue_Coordinator')||p.PermissionSet.name.contains('CSS_WS_Distributor_Rescue_Coordinator'))
              {
                  isSysExtPermission = false;
                    break;
              }
              else
              {
           isSysExtPermission = true;
                    break;
              }
              
           }
           }         
           }
         return isSysExtPermission;
    } 
    public  boolean getLightningAppPermission(){
    boolean isLightningPermission = false;
       
 
   if(passign != null && passign.size() >0) {
    For(PermissionSetAssignment p: passign ){
          if( p!=null && (p.PermissionSet.Name.Contains('FSL_Advanced') || p.PermissionSet.Name.Contains('FSL_Technician'))){
              enableflag = true;
              
           isLightningPermission = true;
                    break;
              }
              
           }
           }
         return isLightningPermission;
    } 
}