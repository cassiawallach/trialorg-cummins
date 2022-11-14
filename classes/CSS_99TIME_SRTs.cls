/**********************************************************************
Name:CSS_99TIME_SRTs
======================================================
======================================================
Purpose:                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR              DATE                DETAIL                                 
1.0    -    Rajesh Pasupuleti   22/08/2017      INITIAL DEVELOPMENT
1.1    -    Vignesh S           11/06/2018      Included Save/Reset method functionality from page
1.2    -    Rajesh Pasupuleti   05/06/2019      Added code as per story #185705
***********************************************************************/
public class CSS_99TIME_SRTs {
    
    public List<CSS_SRT__C> existingNonSRTList {get; set;}
    public List<NonSRTWrapper> NonSRTWrapperList {get;set;}
    public List<NonSRTWrapper> NonSRTWrapperList1 {get;set;}
    public CSS_JobPlanSRTController mainContr{get;set;}
    public string PName { get; set;}
    public Integer selectedRemoveRow {get; set;}
    public Decimal TotalSRTTime{get; set;}
    public CSS_Solution_Component__c[] solutionComponentList;
    public set<string> failAcocuntCode;
    public boolean chkReqField{get;set;}
    public boolean ErrorMessage1 {get; set;}
    public list<CSS_JobEventTemporary__c> JETFA{get;set;}
    // public String coverageType;
    public transient Map<String,CSS_JobEventTemporary__c> accCodeMapJET = new Map<String,CSS_JobEventTemporary__c>(); // This is transient added by Vamshi and Rajesh to reduce the view state.
    public Id Wid;
    public string srtTime;// Venkat 171494
    public string perRequested;
    public String notes;
    public boolean checkNonSRTRow {get; set;}
    //public Id Cid{get; set;}
    public Boolean dealerLocation{get; set;}
    //public Boolean isFactory{get; set;}
    public ID JobID {
        get;
        set {
            JobID=value;
        }
    }
    public Boolean inShopLaborRate {get; set;}
    public Map<String,String> fCaCpercentCovered = new Map<String,String>();
    public Boolean perReqError {get; set;}
    public Map<String, Id> failCodeAccCodeMap {get; set;}
    string orgType;
    UserRole urRole = new UserRole();
    @testVisible
    map<string,string> coveredlabours = new map<string,string>();
    public void testing(){
        
    }
    public boolean isJobClosedOrCanceled { get; set; }	//Defect: #191515
    //Constructor.
    public CSS_99TIME_SRTs() {
        checkNonSRTRow = true;//Venkat 171494
        ErrorMessage1=false;
        //requestederr = false;
        TotalSRTTime=0.0;
        isJobClosedOrCanceled = false; //Defect: #191515
        JETFA = new list<CSS_JobEventTemporary__c>();
        JETFA = [select id,Attribute1__c,Attribute2__c,Attribute3__c,key__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes'];
        for(CSS_JobEventTemporary__c jet : JETFA){
            string temp = jet.Attribute2__c+jet.Attribute3__c; 
            if(!accCodeMapJET.containskey(temp))
                accCodeMapJET.put(temp,jet);
        }
        
        existingNonSRTList = new List<CSS_SRT__C>();
        
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        system.debug('--**Wid**--'+Wid);
        orgType = css_Utility.getOrgType(UserInfo.getUserId());
        if(orgType == 'DLR'){
            dealerLocation = true;
        }
        else{
            dealerLocation = false;
        }
        //isFactory=false;
        //system.debug('mainContr>>>>'+mainContr);
        /*if(mainContr != null && mainContr.usr != null && mainContr.usr.UserRoleName__c != null && mainContr.usr.UserRoleName__c != '') {
            //urRole = [Select name from UserRole where id=:UserInfo.getUserRoleId()];
            if(mainContr.Usr.UserRoleName__c == 'Factory'){
                isFactory=true;
            }
            else
            {
                isFactory=false;
            }
        }*/
        if(Wid != null) {
            CSS_Job_Order__c  claimrecord = [SELECT Id, CSS_In_Shop_Labor_Rate__c, Status__c, Creator_Location__C FROM CSS_Job_Order__c where id=:Wid];
            if(claimrecord.CSS_In_Shop_Labor_Rate__c != null && claimrecord.CSS_In_Shop_Labor_Rate__c != '' && Decimal.valueof(claimrecord.CSS_In_Shop_Labor_Rate__c) > 0){
                inShopLaborRate = true;
            }
            else
                inShopLaborRate = false;
            
            //Defect: #191515
            if(claimrecord != null && claimrecord.Status__c != null && claimrecord.Status__c != '') {
                if(claimrecord.Status__c == 'Closed' || claimrecord.Status__c == 'Canceled')
                    isJobClosedOrCanceled = true;	
            }
            //Defect: #191515
            
            //Fetch data from Existing Non SRT.
            existingNonSRTList = [select Id, Account_Code__c,Account_Code_Description__c, FailCode__c, Fail_Code_Description__c, SRT_Time__c, SRT_Warrantable__c, SRT_Notes__c,SRT_Estimate__c,                  
                                  Component_Id__c,isPerformed__c,CSS_nonSRTRow__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,Extended_Hours__c from CSS_SRT__c 
                                  where Job_order__c=:Wid AND Type__c='99Time' AND (Fail_Code_Description__c != null OR CSS_nonSRTRow__c != null)];////AND Fail_Code_Description__c != null Venkat 171494
            system.debug('--**existingNonSRTList**--'+existingNonSRTList);
            if(existingNonSRTList !=null && existingNonSRTList.size() > 0){
                for(CSS_SRT__c existing : existingNonSRTList) {
                   // if((existing.SRT_Time__c) != null && (existing.SRT_Time__c) != 0.0) {
                    if((existing.Extended_Hours__c) != null && (existing.Extended_Hours__c) != 0.0 && existing.isPerformed__c==true) {
                        TotalSRTTime += existing.Extended_Hours__c;
                        system.debug('Check value for SRTTime0 >> '+TotalSRTTime);
                    }
                }
            }
            
            //Fetching data from CSS Solution Components.
            //Added Root_Cause__c field and "Root_Cause__c = true" WHERE clause in below query as part of the story GSSC-456
            solutionComponentList = [select Id, Root_Cause__c, CSS_Account_Formula__c, FailCode_Formula__c, Fail_Code__c, Selected_Component__c,CoveredLaborHrs__c, Type__c,CampaignLaborPercentage__c
                                     From CSS_Solution_Component__c
                                    // where Service_Job__c=:Wid AND (Selected_Component__c = true OR (Type__c IN ('CAMPAIGN','TRP','ATC') AND Performed_Review__c = true))]; //Commented and added below line as per defect 191432
                                    where Service_Job__c=:Wid AND ((Selected_Component__c = true AND Type__c NOT IN('CAMPAIGN','TRP','ATC') AND Root_Cause__c = true) OR (Type__c IN ('CAMPAIGN','TRP','ATC') AND Performed_Review__c = true))];
            failCodeAccCodeMap = new Map<String, Id>();
            //system.debug('***solutionComponentList*** '+solutionComponentList);
            for(CSS_Solution_Component__c solComp : solutionComponentList){
                String coverageType;
                string tempT;
                string temp1;
                if(solComp.CSS_Account_Formula__c != null){
                    tempT = solComp.CSS_Account_Formula__c.substring(0,solComp.CSS_Account_Formula__c.length()-3);
                    temp1 = solComp.CSS_Account_Formula__c.substring(solComp.CSS_Account_Formula__c.length()-3,solComp.CSS_Account_Formula__c.length()); 
                    //system.debug('tempT--->>>>'+tempT);
                    //system.debug('temp1--->>>>'+temp1);
                    temp1 = temp1.trim();
                    tempT = tempT.trim();
                }
                    string temp2 = tempT + temp1;
                    CSS_JobEventTemporary__c jetSingle = new CSS_JobEventTemporary__c();
                    jetSingle = accCodeMapJET.get(temp2);
                    if(jetSingle!= null){
                        coverageType = jetSingle.Attribute1__c;
                    }
                    String temp;
                    if(solComp.Type__c != 'Campaign' && solComp.Type__c != 'TRP' && solComp.Type__c != 'ATC' && solComp.FailCode_Formula__c!=null){
                        temp = solComp.FailCode_Formula__c +':'+ solComp.CSS_Account_Formula__c;
                        //system.debug('temp-->'+temp);
                        if(!fCaCpercentCovered.containskey(temp)) {
                            if((solComp.CoveredLaborHrs__c != null && solComp.CoveredLaborHrs__c != '' && double.valueof(solComp.CoveredLaborHrs__c) != 0) || (coverageType == 'OTH' || coverageType == 'POL'))
                                fCaCpercentCovered.put(temp,'100');
                            else
                                fCaCpercentCovered.put(temp,'0');
                        }
                        if(solComp.CoveredLaborHrs__c != null && solComp.CoveredLaborHrs__c != ''){
                            if((coverageType == 'OTH' || coverageType == 'POL')){
                                coveredlabours.put(temp,'100');
                            }
                            else{
                                coveredlabours.put(temp,solComp.CoveredLaborHrs__c);
                            }
                        }
                        if(!failCodeAccCodeMap.containskey(temp)){
                            failCodeAccCodeMap.put(temp,solComp.Id);
                        }
                    }
                    else if( solComp.Fail_Code__c!=null){
                        temp = solComp.Fail_Code__c +':'+ solComp.CSS_Account_Formula__c;
                        //system.debug('temp-->'+temp);
                        if(!fCaCpercentCovered.containskey(temp)){
                            fCaCpercentCovered.put(temp,'Field Action');
                        }
                        if(solComp.CampaignLaborPercentage__c != null && solComp.CampaignLaborPercentage__c != '')
                            coveredlabours.put(temp,solComp.CampaignLaborPercentage__c);
                        if(!failCodeAccCodeMap.containskey(temp)){
                            failCodeAccCodeMap.put(temp, solComp.Id);
                        }
                    }
               // }
                
            }
            system.debug('failCodeAccCodeMap-->'+failCodeAccCodeMap);
            getEditNonSRTValues();
        }
    }
    
    //Popup Functionality.
    public List<NonSRTWrapper> getEditNonSRTValues() {
        NonSRTWrapperList = new List<NonSRTWrapper>();
        Integer srtCount = 0;
        //system.debug('Covered Labour HRS'+coveredlabours);
        //system.debug('***inside method existingNonSRTList***'+existingNonSRTList);
        try {
            if(Wid != null) {
                failAcocuntCode = new set<string>();
                set<string> failureIdset = new set<string>();
                if(existingNonSRTList != null && existingNonSRTList.size() > 0) {
                    for(CSS_SRT__C existingNonSRT : existingNonSRTList) {
                        string uniquekey;
                        if(existingNonSRT.FailCode__c != null && existingNonSRT.FailCode__c != '' && existingNonSRT.FailCode__c.length() == 6){
                            uniquekey = existingNonSRT.FailCode__c +':' + existingNonSRT.Account_Code_Description__c;
                        }
                        else if(existingNonSRT.FailCode__c != null && existingNonSRT.FailCode__c != '' && existingNonSRT.FailCode__c.length() != 6){
                            uniquekey = existingNonSRT.Fail_Code_Description__c +':' + existingNonSRT.Account_Code_Description__c;
                        }
                        else{
                            uniquekey = existingNonSRT.Fail_Code_Description__c +':' + existingNonSRT.Account_Code_Description__c;
                        }
                        //system.debug('****uniquekey***'+uniquekey);
                        failAcocuntCode.add(uniquekey);
                        system.debug('****failAcocuntCode***'+failAcocuntCode);
                        //system.debug('****coveredlabours.containsKey(uniquekey)***'+coveredlabours.containsKey(uniquekey));
                        //system.debug('****coveredlabours.get(uniquekey)***'+coveredlabours.get(uniquekey));
//if(coveredlabours.containsKey(uniquekey) && double.valueof(coveredlabours.get(uniquekey)) > 0){ //commented the only if condition line as per story #185705,-By RAJESH June 5th 2019
                        if(coveredlabours.containsKey(uniquekey) ){
                            //system.debug('****inside coveredlabours if***');
                            //system.debug('****fCaCpercentCovered.get(uniquekey)***'+fCaCpercentCovered.get(uniquekey));
                            String percCovered = fCaCpercentCovered.get(uniquekey);
                            String perCovWrapper;
                            String fcTypeWrapper;
                            
                            if(percCovered != 'Field Action'){
                                //system.debug('****inside with out Field Action***');
                                fcTypeWrapper = 'Failures';
                                if(Integer.valueOf(existingNonSRT.SRT_Warrantable__c) > 0 && Integer.valueOf(existingNonSRT.SRT_Warrantable__c) <= 100)
                                    perCovWrapper = existingNonSRT.SRT_Warrantable__c;
                                else if(Integer.valueOf(existingNonSRT.SRT_Warrantable__c) > 100)
                                    perCovWrapper = '100';
                                else
                                    perCovWrapper = (percCovered != null && percCovered != '' && double.valueof(percCovered) > 0) ? '100' : '0';
                            }
                            else if(percCovered == 'Field Action'){
                                //system.debug('****inside with Field Action***');
                                fcTypeWrapper = 'Field Action';
                                if(Integer.valueOf(existingNonSRT.SRT_Warrantable__c) > 0 && Integer.valueOf(existingNonSRT.SRT_Warrantable__c) <= 100)
                                    perCovWrapper = existingNonSRT.SRT_Warrantable__c;
                                else if(Integer.valueOf(existingNonSRT.SRT_Warrantable__c) > 100)
                                    perCovWrapper = '100';
                            }
                            
                            NonSRTWrapperList.add(new NonSRTWrapper(srtCount, existingNonSRT.Id, '99-999', string.ValueOf(existingNonSRT.SRT_Time__c), perCovWrapper,string.ValueOf(existingNonSRT.Extended_Hours__c),existingNonSRT.Fail_Code_Description__c, existingNonSRT.Account_Code_Description__c, existingNonSRT.SRT_Notes__c,fcTypeWrapper,null,existingNonSRT.isPerformed__c,existingNonSRT.Component_Id__c));//Venkat 171494
                            failureIdset.add(existingNonSRT.Component_Id__c);
                            srtCount +=1; 
                        } else {
                            if(!failureIdset.contains(existingNonSRT.Component_Id__c) && (existingNonSRT.CSS_nonSRTRow__c == null || existingNonSRT.CSS_nonSRTRow__c == '')) {
                                NonSRTWrapperList.add(new NonSRTWrapper(srtCount, existingNonSRT.Id, '99-999', string.ValueOf(existingNonSRT.SRT_Time__c), existingNonSRT.SRT_Warrantable__c,string.ValueOf(existingNonSRT.Extended_Hours__c),existingNonSRT.Fail_Code_Description__c, existingNonSRT.Account_Code_Description__c, existingNonSRT.SRT_Notes__c,'Failures',null,existingNonSRT.isPerformed__c,existingNonSRT.Component_Id__c));//Venkat 171494
                                failureIdset.add(existingNonSRT.Component_Id__c);
                                srtCount +=1; 
                            }
                        }     
                        
                    }
                }
                
                
                
                //Insert the wrapper Records.
                
                
                if((dealerLocation == true) || (dealerLocation == false && inShopLaborRate == true)){
                    system.debug('*****Inside Main****');
                    system.debug('*****Inside solutionComponentList****'+solutionComponentList);
                    for(CSS_Solution_Component__c solComp : solutionComponentList) {
                       // if(solComp.CSS_Account_Formula__c != null){//commented the if condition line only and covered below as per story #185705,-By RAJESH June 4th 2019
                            String reqPercent;
                            String fcTypeWrapper;
                            String coverageType;
                            string tempT;
                            string temp1;
                            if(solComp.CSS_Account_Formula__c != null){
                             tempT = solComp.CSS_Account_Formula__c.substring(0,solComp.CSS_Account_Formula__c.length()-3);
                             temp1 = solComp.CSS_Account_Formula__c.substring(solComp.CSS_Account_Formula__c.length()-3,solComp.CSS_Account_Formula__c.length()); 
                            temp1 = temp1.trim();
                            tempT = tempT.trim(); 
                            }
                             
                            string temp2 = tempT + temp1;
                            
                            //system.debug('*****temp2****'+temp2);
                            CSS_JobEventTemporary__c jetSingle = new CSS_JobEventTemporary__c();
                            jetSingle = accCodeMapJET.get(temp2);
                        //system.debug('*****jetSingle****'+jetSingle);
                            if(jetSingle!= null){
                                coverageType = jetSingle.Attribute1__c;
                            }
                        system.debug('*****coverageType****'+coverageType);
                        system.debug('*****solComp.Type__c****'+solComp.Type__c);
                            if(solComp.Type__c != 'CAMPAIGN' && solComp.Type__c != 'TRP' && solComp.Type__c != 'ATC'){
                                system.debug('*****inside if for type****');
                                fcTypeWrapper = 'Failures';
                                 if(solComp.FailCode_Formula__c != null){
                                    string s = solComp.FailCode_Formula__c + ':' + solComp.CSS_Account_Formula__c;
                                    
                                    if(s!=null && s!='' && !failAcocuntCode.contains(s)) {
                                        if((solComp.Selected_Component__c == true && solComp.CoveredLaborHrs__c != null && solComp.CoveredLaborHrs__c != '' && double.ValueOf(solComp.CoveredLaborHrs__c) >0) || (solComp.Selected_Component__c == true && (coverageType == 'OTH' || coverageType == 'POL'))){
                                            reqPercent = '100';
                                        }
                                        else{
                                            reqPercent = '0';
                                        }
                                        if((double.valueOf(solComp.CoveredLaborHrs__c)>0 || (coverageType == 'OTH' || coverageType == 'POL')) && !failureIdset.contains(solComp.id)){
                                           NonSRTWrapperList.add(new NonSRTWrapper(srtCount, null, '99-999', '', reqPercent,'', solComp.FailCode_Formula__c, solComp.CSS_Account_Formula__c, '',fcTypeWrapper,null,false,solComp.id)); // Venkat 171494
                                           failureIdset.add(solComp.id);
                                            srtCount +=1; 
                                       }
                        //   START   Added below if condition for getting Failures and Field Actions into Nonsrt popup as per story #185705,-By RAJESH June 4th 2019               
                                       if((double.valueOf(solComp.CoveredLaborHrs__c)==0 || (coverageType == 'OTH' || coverageType == 'POL')) && !failureIdset.contains(solComp.id)){
                                           NonSRTWrapperList.add(new NonSRTWrapper(srtCount, null, '99-999', '', reqPercent,'', solComp.FailCode_Formula__c,'', '',fcTypeWrapper,null,false,solComp.id)); // Venkat 171494
                                           failureIdset.add(solComp.id);
                                           srtCount +=1;    
                                       }
                    //     END    Added below if condition for getting Failures and Field Actions into Nonsrt popup as per story #185705,-By RAJESH June 4th 2019                                  
                                    }
                                      else{
                                         system.debug('*****inside else for solComp.CoveredLaborHrs__c)==0****');
                                         if((solComp.Selected_Component__c == true && solComp.CoveredLaborHrs__c != null && solComp.CoveredLaborHrs__c != '' && double.ValueOf(solComp.CoveredLaborHrs__c) >0) || (solComp.Selected_Component__c == true && (coverageType == 'OTH' || coverageType == 'POL'))){
                                             reqPercent = '100';
                                         }
                                         else{
                                             reqPercent = '0';
                                         }
                                         if((double.valueOf(solComp.CoveredLaborHrs__c)==0 || (coverageType == 'OTH' || coverageType == 'POL')) && !failureIdset.contains(solComp.id)){
                                             system.debug('*****inside 312 else  for solComp.CoveredLaborHrs__c)==0****');
                                             NonSRTWrapperList.add(new NonSRTWrapper(srtCount, null, '99-999', '', reqPercent,'', solComp.FailCode_Formula__c,'', '',fcTypeWrapper,null,false,solComp.Id)); // Venkat 171494
                                             failureIdset.add(solComp.id);
                                             srtCount +=1;    
                                         }
                                     }
                                    failAcocuntCode.add(s);
                                }
                            }
                            else if(solComp.Type__c == 'CAMPAIGN' || solComp.Type__c == 'TRP' || solComp.Type__c == 'ATC' ){
                                system.debug('*****inside main else if****');
                                fcTypeWrapper = 'Field Action';
                                if(solComp.Fail_Code__c != null){
                                    string s = solComp.Fail_Code__c + ':' + solComp.CSS_Account_Formula__c;
                                    system.debug('*****inside main else if for s****'+s);
                                    system.debug('*****inside main else if for s failAcocuntCode****'+failAcocuntCode);
                                    system.debug('*****inside main else if for s solComp.CampaignLaborPercentage__c****'+solComp.CampaignLaborPercentage__c);
                                    system.debug('*****inside main else if for solComp.id****'+solComp.id);
                                    system.debug('*****inside main else if for s failureIdset****'+failureIdset);
                                   //  if(!failAcocuntCode.contains(s) &&  double.valueOf(solComp.CampaignLaborPercentage__c)>0 && !failureIdset.contains(solComp.id)) { commented and added null pointer check for arguments.
                                  if(s!=null && s!='' && solComp.CampaignLaborPercentage__c!=null && failureIdset.size()>0 && !failAcocuntCode.contains(s) &&  double.valueOf(solComp.CampaignLaborPercentage__c)>0 && !failureIdset.contains(solComp.id)) {
                                       system.debug('*****inside main else if inside if part****');
                                        NonSRTWrapperList.add(new NonSRTWrapper(srtCount, null, '99-999', '', '100','', solComp.FailCode_Formula__c, solComp.CSS_Account_Formula__c, '',fcTypeWrapper,null,false,solComp.id));//Venkat 171494
                                        failureIdset.add(solComp.id);
                                        srtCount +=1;
                                    }
                    //Start code for defect #189311                 
                                  if(s!=null && s!='' && solComp.CampaignLaborPercentage__c!=null && failureIdset.size()==0 && double.valueOf(solComp.CampaignLaborPercentage__c)>0) {
                                       system.debug('*****inside main else if inside if part****');
                                        NonSRTWrapperList.add(new NonSRTWrapper(srtCount, null, '99-999', '', '100','', solComp.FailCode_Formula__c, solComp.CSS_Account_Formula__c, '',fcTypeWrapper,null,false,solComp.id));
                                        failureIdset.add(solComp.id);
                                        srtCount +=1;
                                    }
                   //end code for defect #189311                      
                                    failAcocuntCode.add(s);
                                }
                            }
                       // }
                    }
                }
                //added by venkat for the ROD 171494
                
                if(existingNonSRTList !=null && existingNonSRTList.size() > 0){
                    for(CSS_SRT__c existingNew : existingNonSRTList) {
                        if((existingNew.CSS_nonSRTRow__c) != null && (existingNew.CSS_nonSRTRow__c) != '') { 
                            checkNonSRTRow = true;
                            NonSRTWrapperList.add(new NonSRTWrapper(srtCount, existingNew.Id, '99-999', string.ValueOf(existingNew.SRT_Time__c), '100',string.ValueOf(existingNew.Extended_Hours__c), '', '', existingNew.SRT_Notes__c,null,null,existingNew.isPerformed__c,null));
                            break;
                        }
                        else{
                            checkNonSRTRow = false;
                            System.debug('inside existingNewcheckNonSRTRow##'+checkNonSRTRow);
                        }
                        
                    }
                }
                else {
                    checkNonSRTRow = false;
                }
                //system.debug('--**NonSRTWrapperList**--Final >>> '+NonSRTWrapperList);
                //Fetching data from CSS Solution Components.
            }
            //added by venkat for the ROD 171494
            if(checkNonSRTRow == false){
                NonSRTWrapperList.add(new NonSRTWrapper(srtCount, null, '99-999', srtTime,'100','', null, null, notes,'Field Action','nonSRTFieldActionRow',false,null));
            }
        } catch(Exception ex) {
            system.debug('in the exception of JobPlan Controller Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }
        return NonSRTWrapperList;
    }
    
    //Removing rows in Popup
    public void removingNonSRTRow(){
        try{
            NonSRTWrapperList1=NonSRTWrapperList.clone();
            NonSRTWrapperList.clear();
            for(Integer i=0; i<NonSRTWrapperList1.size(); i++){
                if(NonSRTWrapperList1[i].count == selectedRemoveRow) {
                    NonSRTWrapperList1[i].SRTTime = '';
                    NonSRTWrapperList1[i].Notes = '';
                }
            }
            
            NonSRTWrapperList=NonSRTWrapperList1.clone();
            NonSRTWrapperList1.clear();
        }catch(Exception ex) {
            System.debug('in catch of removingRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        
    }
    
    //Method to close the pop up 
    public void closePopup(){
        system.debug('START closePopup '); 
        getEditNonSRTValues();
        ErrorMessage1 = false;
        perReqError = false;
        system.debug('END closePopup '); 
    }
    
    //map<string,list<NonSRTWrapper>> sameaccerrormap = new map<string,list<NonSRTWrapper>>();
    //public boolean requestederr{get;set;}
    
    //Method for Save Function.
    public pagereference saveNonSRTPopup() {
        system.debug('--**NonSRTWrapperList**--'+NonSRTWrapperList);
        //requestederr = false;
        chkReqField = false;
        perReqError = false;
        system.debug('--**chkReqField**--'+chkReqField);
        ErrorMessage1 = false;
        PageReference pageRef;
        set<Id> deleteSRTIds = new set<Id>();
        list<CSS_SRT__c> SRTList = new list<CSS_SRT__c>();
        Map<String,Set<String>> accCodePerCov = new Map<String,Set<String>>();
        try {
            
            system.debug('mainContr.Usr.UserRoleName__>>>>>'+mainContr.Usr.UserRoleName__c);
            system.debug('***NonSRTWrapperList***'+NonSRTWrapperList);
            for(NonSRTWrapper NonSRT : NonSRTWrapperList) {
                system.debug('***NonSRT***'+NonSRT);
                system.debug('***NonSRT extendedhrs***'+NonSRT.extendedhrs);
                if((NonSRT.SRTTime != null && NonSRT.SRTTime != '') ||  (NonSRT.Notes != null && NonSRT.Notes != '')) { // Removed percentRequested mandatory check as per the story #169609
                    if(mainContr != null && mainContr.Usr.UserRoleName__c == 'Factory' && NonSRT.accountCode != null){
                        if(!accCodePerCov.containskey(NonSRT.accountCode)){
                            Set<String> tempLst = new Set<String>();
                            tempLst.add(NonSRT.percentRequested);
                            accCodePerCov.put(NonSRT.accountCode,tempLst);
                        }
                        else{
                            Set<String> tempLst = new Set<String>();
                            tempLst = accCodePerCov.get(NonSRT.accountCode);
                            if(!tempLst.contains(NonSRT.percentRequested)){
                                tempLst.add(NonSRT.percentRequested);
                            }
                            accCodePerCov.put(NonSRT.accountCode,tempLst);
                        }
                    }
                    CSS_SRT__c srt = new CSS_SRT__c();
                    srt.Type__c = '99Time';
                    srt.Id = NonSRT.srtId;
                    srt.Account_Code_Description__c = NonSRT.accountCode;
                    srt.Fail_Code_Description__c = NonSRT.failCode;
                    if((NonSRT.accountCode == null || NonSRT.accountCode == '') && (NonSRT.failCode == null || NonSRT.failCode == '')){
                        srt.CSS_nonSRTRow__c = 'nonSRTFieldActionRow'; //added by venkat for the ROD 171494
                    }
                    else{
                        srt.CSS_nonSRTRow__c = '';
                    }
                    String selectedFailCodeMod;
                    List<String> failCodeSplit = new List<String>();
                    if(NonSRT.failCode != null && NonSRT.failCode != ''){////added by venkat for the ROD 171494
                        failCodeSplit = NonSRT.failCode.split('-');
                    }
                    if(failCodeSplit.size() >= 1 && failCodeSplit[failCodeSplit.size()-1] != null && failCodeSplit[failCodeSplit.size()-1] != ''){
                        selectedFailCodeMod = failCodeSplit[failCodeSplit.size()-1];
                    }                   
                    
                    srt.FailCode__c = selectedFailCodeMod;
                    srt.SRT_ID__c = '99-999';
                    srt.Job_order__c= Wid;
                    srt.SRT_Time__c = (NonSRT.SRTTime!=null && NonSRT.SRTTime!='')?Double.valueOf(NonSRT.SRTTime):0;
                    srt.SRT_Warrantable__c = (NonSRT.percentRequested!=null && NonSRT.percentRequested != '') ? NonSRT.percentRequested:'0';
                    srt.SRT_Notes__c = NonSRT.Notes;
                    srt.SRT_Quantity__c = 1;
                    srt.isPerformed__c = true;
                    srt.Component_Id__c = NonSRT.failureId;
                    String temp;
                    if(NonSRT.failCode != null && NonSRT.failCode != '' && !NonSRT.failCode.contains('Campaign') && !NonSRT.failCode.contains('ATC') && !NonSRT.failCode.contains('TRP')){
                        temp = NonSRT.failCode +':'+ NonSRT.accountCode;
                    }
                    else{
                        if(NonSRT.failCode != null && NonSRT.failCode != '')
                            temp = NonSRT.failCode.RIGHT(6) +':'+ NonSRT.accountCode;
                    }
                    system.debug('temp-->'+temp);
                    //srt.Component_Id__c = failCodeAccCodeMap.get(temp);
                    system.debug('srt.Component_Id__c-->'+srt.Component_Id__c);
                    
                    /* Commented below lines and covered another if condition as per story #185705,-By RAJESH June 5th 2019
                    Decimal cHours;
                    if(NonSRT.SRTTime!=null && NonSRT.SRTTime!=''&& NonSRT.percentRequested!=null && NonSRT.percentRequested != ''){
                        cHours = ((Decimal.valueOf(NonSRT.SRTTime)*Decimal.valueOf(NonSRT.percentRequested))/100).setScale(1,RoundingMode.HALF_UP);
                    }
                     END  */
      // START added code for calculating the extendedhrs field value based on Account code as per story #185705,-By RAJESH June 5th 2018              
                    Decimal cHours;
                    if(NonSRT.SRTTime!=null && NonSRT.SRTTime!=''&& NonSRT.percentRequested!=null && NonSRT.percentRequested != ''){
                        if(NonSRT.accountCode!=null && NonSRT.accountCode!=''){
                            system.debug('****enter inside if with Account code ***');
                            cHours = ((Decimal.valueOf(NonSRT.SRTTime)*Decimal.valueOf(NonSRT.percentRequested))/100).setScale(1,RoundingMode.HALF_UP);
                        }
                        else{
                            system.debug('****enter inside if with out Account code ***');
                            cHours = ( Decimal.valueOf(NonSRT.SRTTime) * srt.SRT_Quantity__c);
                        }
                    }
     // END added code for calculating the extendedhrs field value based on Account code as per story #185705,-By RAJESH June 5th 2018               
                    
                    system.debug('--**cHours**--'+cHours);
                    srt.Extended_Hours__c = cHours;
                    system.debug('srt.Extended_Hours__c'+srt.Extended_Hours__c);
                    SRTList.add(srt);
                    
                } 
                else {
                    
                    if(NonSRT.srtId != null)
                        deleteSRTIds.add(NonSRT.srtId);
                }
                
                if((NonSRT.SRTTime != null && NonSRT.SRTTime != '' && (NonSRT.Notes == null || NonSRT.Notes == '')) || 
                   (NonSRT.Notes != null && NonSRT.Notes != '' && (NonSRT.SRTTime == null || NonSRT.SRTTime == '')) || 
                   (NonSRT.Notes != null && NonSRT.Notes != '' && NonSRT.SRTTime != null && NonSRT.SRTTime != '' && (NonSRT.percentRequested == null || NonSRT.percentRequested == ''))){
                       chkReqField = true;
                       ErrorMessage1 = true;
                       return null;
                   }
                
            }
            if(accCodePerCov != null){ 
                for(String perCov : accCodePerCov.keyset()){
                    Set<String> tempLst = new Set<String>();
                    tempLst = accCodePerCov.get(perCov);
                    if(tempLst != null && tempLst.size() > 1){
                        perReqError = true;
                        return null;
                    }
                    
                }
            }
            CSS_SRT__c[] deleteSRT = [select Id from CSS_SRT__c where Id IN :deleteSRTIds];
            
            if(SRTList != null && SRTList.size() > 0) 
                upsert SRTList;
            system.debug('savedSRTList' + SRTList);
            
            if(deleteSRT != null && deleteSRT.size() > 0)     
                delete deleteSRT; 
            
            if(wid!=null){
                String allSrtNotes='';
                CSS_job_Order__c jobOrderTemp = new CSS_Job_Order__c();
                
                for(CSS_SRT__c srt : [SELECT id,SRT_Notes__c 
                                      FROM CSS_SRT__c 
                                      WHERE type__c = '99Time'
                                      AND Job_order__c=:wid]){
                                          
                                          if(srt.SRT_Notes__c!= null && srt.SRT_Notes__c!= '' ){
                                              allSrtNotes += srt.SRT_Notes__c + '\n';
                                          }
                                          
                                          // allSrtNotes += srt.SRT_Notes__c + '\n';
                                          
                                      }
                
                System.debug('** Non SRT Detail '+allSrtNotes);
                //Rajesh Narra has added the allSrtNotes=='' to update the Non SRT details that has changed in SRT chevron optional Non SRT accordian 
                if(allSrtNotes!='' || allSrtNotes==''){
                    jobOrderTemp.id=wid;
                    jobOrderTemp.Non_SRT_Details__c = allSrtNotes;
                    
                    update jobOrderTemp;
                }
                
            }
            
            if(orgType == 'DLR' || (mainContr != null && mainContr.Usr.UserRoleName__c == 'Factory')){
                CG_CL_CoverageLimitExceedValidation callingSRTClaimedHour= new CG_CL_CoverageLimitExceedValidation();
                //callingSRTClaimedHour.covLimitValidationSRTsJob(jobId,null);
                callingSRTClaimedHour.covLimitValidationSRT(jobId,null);
            }
            
        } catch(Exception e) {
            system.debug('Error in Cust SRT Save Component ## ' + e.getmessage() + e.getLineNumber());
        }
        perReqError = false;
        ErrorMessage1 = false;
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        pageRef = new PageReference(sDestURL+'id='+Wid); 
        system.debug('sDestURL' + sDestURL);
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    //This method is called on TND and Repair Review job pages.
    public PageReference gotoJobPlanSrt(){       
        JobID=ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanSRT?id='+JobID); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    
    //Wrapper.
    public class NonSRTWrapper {
        public Integer Count { get; set; }
        public string srtId { get; set; }
        public string SRTCode { get; set; }
        public string SRTTime { get; set; }
        public string percentRequested { get; set; }
        public string extendedhrs{get;set;}
        public string failCode { get; set; }
        public string accountCode { get; set; }
        public string Notes { get; set; }
        public boolean isRemove { get; set; }//No need as of now.
        public string fctype {get; set;}
        public string nonSRTRow {get; set;}
        public boolean isperformed { get; set; }
        public string failureId { get; set; }
        
        public NonSRTWrapper(Integer Count, string srtId, string SRTCode, string SRTTime, string percentRequested, string extendedhrs, string failCode, string accountCode, string Notes, string fctype, string nonSRTRow,boolean isperformed, String failureId) {
            this.Count = Count;
            this.srtId = srtId;
            this.SRTCode = SRTCode;
            this.SRTTime = SRTTime;
            this.percentRequested = percentRequested;
            this.failCode = failCode;
            this.accountCode = accountCode;
            this.Notes = Notes;
            this.fctype = fctype;
            this.nonSRTRow = nonSRTRow;
            this.extendedhrs = extendedhrs;
            this.isperformed = isperformed;
            this.failureId = failureId;
        }
    }
    
    public PageReference saveSRTMethod(){
        system.debug('inside saveSRTMethod');
        TotalSRTTime=0.0;
        if(existingNonSRTList.size() > 0){
            update existingNonSRTList;
            existingNonSRTList = [select Id, Account_Code_Description__c, FailCode__c, Fail_Code_Description__c, SRT_Time__c, SRT_Warrantable__c, SRT_Notes__c,SRT_Estimate__c,                  
                                  isPerformed__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,Extended_Hours__c from CSS_SRT__c 
                                  where Job_order__c=:Wid AND Type__c='99Time' AND Fail_Code_Description__c != null];
        }
        for(CSS_SRT__c existing : existingNonSRTList){
             if((existing.Extended_Hours__c) != null && (existing.Extended_Hours__c) != 0.0 && existing.isPerformed__c==true) {
                TotalSRTTime += existing.Extended_Hours__c;
            }
       
        }
        if(orgType == 'DLR' || (mainContr != null && mainContr.Usr.UserRoleName__c == 'Factory')){
            CG_CL_CoverageLimitExceedValidation callingSRTClaimedHour= new CG_CL_CoverageLimitExceedValidation();
            //callingSRTClaimedHour.covLimitValidationSRTsJob(jobId,null);
            callingSRTClaimedHour.covLimitValidationSRT(jobId,null);
        }
        //return null;
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        PageReference pageRef = new PageReference(sDestURL+'id='+Wid); 
        system.debug('sDestURL' + sDestURL);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public pageReference resetNonSRTMethod(){
        system.debug('inside resetNonSRTMethod');
        existingNonSRTList = [select Id, Account_Code_Description__c, FailCode__c, Fail_Code_Description__c, SRT_Time__c, SRT_Warrantable__c, SRT_Notes__c,SRT_Estimate__c,                  
                              isPerformed__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c from CSS_SRT__c 
                              where Job_order__c=:Wid AND Type__c='99Time' AND Fail_Code_Description__c != null];
        return null;
    }
}