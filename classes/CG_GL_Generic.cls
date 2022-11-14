/**********************************************************************
Name: CSS_GL_Generic
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is a Generic global class of CSS application to 
reuse the methods, variables
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        12/05/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
public virtual class CG_GL_Generic {
    public css_job_order__c workJob {get;set;}
    public string mil_measure;
    public string fail_measure;
    public ID Wid;
    public Boolean showJobPlanBoolean{get;set;}
    public boolean bmsEnabled {get;set;}
    
      public void CG_GL_Generic(){
        System.debug('in CSS_GL_Generic constructor...');
        Wid=ApexPages.CurrentPage().getParameters().get('id');
             
        if (Wid == null) {
            
            mil_measure = 'Miles';
            fail_measure = 'Miles';
            css_redirect();
        }
        else  {
            try {
                workJob=[Select Id,Name,BMSStatus__c,BMSWSStatus__c,Customer_Name__c,Contact_ID__c,Contact_Name__c,Address__c,Cstmr_Contacts_Phone__c,City__c,ZipCode__c,Country__c,CSS_State__c,CSS_Charge_Account_Status__c,Customer_Code__c,Shop_Work_Order__c,Sub_Type__c,Application__c, Application_Desc__c, Unit_Number__c,Unit_Type__c, date_in__c,CSS_resolution__c,CSS_Feedback_Comments__c,INSITE_UpdateTimeStamp__c,DSID_WorkGroup__c, 
                         Failure_Date__c,AccessCode__c,Equipment_Id__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c,VIN_Flag__c,Warranty_Start_Date__c,Make__c,Model__c, Qsol_Engine_Family_Code__c,
                         DSID__c, DSID_Creation_Timestamp__c, TSR_EscalateNumber__c, Before_In_Service__c,DSID_Status__c,First_Name__c,BMS_Last_Name__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Status__c,Previous_Status__c, Category__c, Complaint_Type__c,Category2__c,Complaint_Type2__c,Category3__c,Complaint_Type3__c,Category4__c,Complaint_Type4__c,Category5__c,Complaint_Type5__c, Category_Desc__c, Category2_Desc__c, Category3_Desc__c, Category4_Desc__c, Category5_Desc__c, Complaint_Type_Desc__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c, Preventive_Maintenance__c,Expedited_Service__c,
                         Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,Additional_Tech3__r.Name,Additional_Tech4__r.Name,Additional_Tech5__r.Name,Additional_Tech6__r.Name,Additional_Tech7__r.Name,Additional_Tech8__r.Name,Additional_Tech9__r.Name,OwnerId,Control_Number__c,date_in_shop__c,Creator_Location__c,Warranty_Authorization_Flag__c,Location_Certification__c,
                         ESN__c, ESN_IA__c, Mileage__c,CSS_Hours__c,Primary_Segment__c,Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate,JobLocation__c, CSS_Job_Location_Code__c, ESN_Locked__c,Phone_Number__c, Sub_Status__c,LastUpdateSubStatus__c,
                         Repair_Location__c,Repeat_Visit__c, RPVControlNumber__c, After_Image__c,Before_Image__c,RPV_Notification_Message__c, RPV_SecondWebserviceCall__c, RPV_Email_Address__c, RPV_Email_Send_To__c, RPV_Email_Has_Sent__c, RPV_Notification_Flag__c,Actual_Technician_Time__c,
                         (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC),
                         (Select id, type__c,diagnosis_time__c,srt_time__c,SRT_Decimal_Time__c, job_order__c,isPerformed__c, Component_Id__r.Selected_Component__c from css_srts__r where job_order__c =:Wid and Solution_Number__c = null)
                         /*,(select Id,Name,Action__c,Component_Id__c, Solutions__c,Quantity__c,Selected_Component__c,Charlength__c, Service_Job__c from CSS_Solution_Components__r),
                            (Select Id, Name,Solution_Title__c, Service_Job__c, Rank__c,DSID__c, Diagnostic_notes__c, Diagnostic_Response__c, FaultCode__c from CSS_Solutions__r)*/
                         from CSS_Job_Order__c where id= :Wid];
                     tndverification();
            }
            catch(Exception e)  {
                system.debug('in catch block exception -->'+e.getMessage()+' Exception LineNo:'+e.getLineNumber());
            }
                        //End
        }   
      }
      
    public void tndverification(){
        boolean solVer; 
        solVer=false; 
        try{
         	//userlang = css_utility.getUserAttributes(userinfo.getUserId());
            //accountlang = css_utility.getLanguage(userlang.LanguageLocaleKey); 
            String UserLocation = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode');
            if(UserLocation != workJob.Creator_Location__c){
                css_utility.setSessionVariables(workJob.Creator_Location__c);
                bmsEnabled = (Boolean)Cache.Session.get('local.CSSPartition.UserBMSEnabled');
            }else{
                bmsEnabled = (Boolean)Cache.Session.get('local.CSSPartition.UserBMSEnabled');
                system.debug('BMS Enabled>>>>'+bmsEnabled);
                if(bmsEnabled == null){
                    css_utility.setSessionVariables(workJob.Creator_Location__c);
                    bmsEnabled = (Boolean)Cache.Session.get('local.CSSPartition.UserBMSEnabled');
                }
            }   
            
        //bmsEnabled = (Boolean)Cache.Session.get('local.CSSPartition.UserBMSEnabled');
        System.debug('bmsEnabled>>>:'+bmsEnabled);
        if(bmsEnabled == null || bmsEnabled==false){
            List<CSS_Solutions__c> solutionList= [Select Id,Diagnostic_Response__c,CSS_Nested_Solutions__c, CSS_Nested_Solutions__r.Name, CSS_Nested_Solutions__r.Case_Name__c from CSS_Solutions__c where Service_Job__c= :workJob.Id];        
            for(CSS_Solutions__c sol: solutionList){       
                System.debug('in bmsEnabled false loop11...');
                if(sol.Diagnostic_Response__c == 'Most likely the solution'){   
                    System.debug('in bmsEnabled false loop22...');
                    solVer= true;       
                }  
            } 
        }
        else{
            if(workJob.BMSStatus__c!=null && workJob.BMSStatus__c.contains('WC1'))
                solVer= true;
        }
            
        }catch(Exception ex){
            System.debug('in catch of tndverification of CSS_repair_job >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
         system.debug('tndverification>>>:'+solVer);
        showJobPlanBoolean=solVer; 
            
    }
    
    public PageReference css_redirect()
    {
        PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    
}