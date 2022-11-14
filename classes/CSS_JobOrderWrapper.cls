/*
  *****************************************************************************
  HISTORY
  *****************************************************************************
  ******************************************************************************
    Version        Author        Date        Details
    1.0          Anirudh Pesari  8/31/2016   Intial Developement
    1.1          Rajesh Narra    10/24/2017  Added bmsEnabled to the CSS_JobOrderWrapper constructor
    ****************************************************************************
*/
public class CSS_JobOrderWrapper {
    public css_job_order__c worecord{set;get;}
    //Modified as per story# 64030
    public CSS_JobOrderWrapper(css_job_order__c workJob,String filterMake,String filterModel,String mil_measure,String fail_measure,String filterCountry,String filterState,Boolean bmsEnabled,String EmailAddress,String EmailAddress1,boolean emailCheckbox){
    //public CSS_JobOrderWrapper(css_job_order__c workJob,String filterMake,String filterModel,String mil_measure,String fail_measure,String filterCountry,String filterState,String filterApplication,String filterCategory,String filterCategory2,String filterCategory3,String filterCategory4,String filterCategory5,String filterComplaintType,String filterComplaintType2,String filterComplaintType3,String filterComplaintType4,String filterComplaintType5){
       
        worecord = new css_job_order__c();
		system.debug('workJob ???????? ' + workJob);  
        system.debug('workJob.Unit_Number__c >>>>>> ' + workJob.Unit_Number__c);
        worecord.Customer_Name__c=workJob.Customer_Name__c;
        worecord.bmsCreateAccount__c=workJob.bmsCreateAccount__c;
        worecord.Customer_Code__c=workJob.Customer_Code__c;
        /*bmsEnabled filter is added by Rajesh Narra on 10-23-2017*/
        if(bmsEnabled==null)
            bmsEnabled=false;
        if((workJob.Customer_Code__c == '' || workJob.Customer_Code__c == null) && (bmsEnabled==true))
               workJob.Unit_number__c = '';
        worecord.Phone_Number__c=workJob.Phone_Number__c;
        //worecord.Contact_Name__c=workJob.Contact_Name__c;
        worecord.First_Name__c=workJob.First_Name__c;
        worecord.BMS_Last_Name__c=workJob.BMS_Last_Name__c;
        worecord.Cstmr_Contacts_Phone__c=workJob.Cstmr_Contacts_Phone__c;
        //  worecord.Email_check_box__c=workJob.Email_check_box__c;
        system.debug('EmailAddress--'+EmailAddress+EmailAddress1);
        system.debug('EmailAddress--1'+EmailAddress+EmailAddress1);
        system.debug('Email_Address__c'+worecord.Email_Address__c);
        system.debug('workJob.Email_check_box__c'+workJob.Email_check_box__c);
        worecord.Email_check_box__c = workJob.Email_check_box__c;
        if(workJob.Email_check_box__c==true){
            worecord.Email_Address__c='declined@cummins.com';
        }   
        else{
            if(EmailAddress == null)
                EmailAddress = '';
            if(EmailAddress1 == null)
                EmailAddress1 = '';
            
            if((EmailAddress == null || EmailAddress == '') && (EmailAddress1 == null || EmailAddress1 == ''))
            	worecord.Email_Address__c='';
            else
            	worecord.Email_Address__c=EmailAddress+'@'+EmailAddress1;
        }
        worecord.Address__c=workJob.Address__c;
        worecord.City__c=workJob.City__c;
        worecord.ZipCode__c=workJob.ZipCode__c;
        worecord.Country__c= filterCountry;  //workJob.Country__c; 
        worecord.CSS_State__c = filterState;//workJob.CSS_State__c;
        // worecord.CSS_State__c = SelectedStateCode;
        // worecord.Country__c = SelectedCountryCode;
        worecord.CSS_Charge_Account_Status__c=workJob.CSS_Charge_Account_Status__c; 
        worecord.Primary_Segment__c = workJob.Primary_Segment__c;
        worecord.Shop_Work_Order__c=workJob.Shop_Work_Order__c;
        if(workJob.Date_in_Shop__c!=null)
            worecord.Date_In__c = datetime.newInstance(workJob.Date_in_Shop__c.year(), workJob.Date_in_Shop__c.month(),workJob.Date_in_Shop__c.day(),12,0,0);
        worecord.Date_in_Shop__c = workJob.Date_in_Shop__c;
        //Moddified as per story# 64030
        //worecord.Application__c = workJob.Application__c;
        worecord.Unit_number__c = workJob.Unit_number__c;
        worecord.Service_Model__c = workJob.Service_Model__c;
        worecord.VIN__c = workJob.VIN__c;
        worecord.VIN_Flag__c = workJob.VIN_Flag__c;
        worecord.ESN__c = workJob.ESN__c;
        worecord.Make__c = filterMake;
        worecord.Model__c = filterModel;
        //worecord.Category__c = workJob.Category__c;
        /* Added Code for the customer complaint section for Story - 63828 */
        /*worecord.Category2__c = workJob.Category2__c;
        worecord.Category3__c = workJob.Category3__c;
        worecord.Category4__c = workJob.Category4__c;
        worecord.Category5__c = workJob.Category5__c;
        worecord.Complaint_Type__c = workJob.Complaint_Type__c;
        worecord.Complaint_Type2__c = workJob.Complaint_Type2__c;
        worecord.Complaint_Type3__c = workJob.Complaint_Type3__c;
        worecord.Complaint_Type4__c = workJob.Complaint_Type4__c;
        worecord.Complaint_Type5__c = workJob.Complaint_Type5__c;*/
        /* Added as per story# 64030 */
        /*worecord.Category_Desc__c = filterCategory;
        worecord.Category2_Desc__c = filterCategory2;
        worecord.Category3_Desc__c = filterCategory3;
        worecord.Category4_Desc__c = filterCategory4;
        worecord.Category5_Desc__c = filterCategory5;
        worecord.Complaint_Type_Desc__c = filterComplaintType;
        worecord.Complaint_Type2_Desc__c = filterComplaintType2;
        worecord.Complaint_Type3_Desc__c = filterComplaintType3;
        worecord.Complaint_Type4_Desc__c = filterComplaintType4;
        worecord.Complaint_Type5_Desc__c = filterComplaintType5;*/
        
      /*  worecord.Complaint__c = workJob.Complaint__c;
        worecord.Correction__c = workJob.Correction__c;
        worecord.Coverage__c = workJob.Coverage__c;
        worecord.Cause__c = workJob.Cause__c;      */  
        worecord.previousESN_MultiLoc__c = workJob.previousESN_MultiLoc__c;
        worecord.Mileage__c = workJob.Mileage__c;
        worecord.CSS_Hours__c = workJob.CSS_Hours__c;
        worecord.Mileage_Measure__c = mil_measure;
        worecord.Failure_Date__c=workJob.Failure_Date__c;
        worecord.Failure_Point__c = workJob.Failure_Point__c;
        worecord.Failure_Point_Measure__c = fail_measure;
        worecord.General_Symptoms__c=workJob.General_Symptoms__c;
        worecord.Warranty_Start_Date__c=workJob.Warranty_Start_Date__c;
        worecord.Location_Certification__c=workjob.Location_Certification__c;
        worecord.Preventive_Maintenance__c=workjob.Preventive_Maintenance__c;
        worecord.Expedited_Service__c=workjob.Expedited_Service__c;
        worecord.Qsol_Engine_Family_Code__c=workjob.Qsol_Engine_Family_Code__c;
        system.debug('Inside JOWrap1'+worecord.Make__c + ' ' +worecord.Model__c + 'previousesn>>>' +worecord.previousESN_MultiLoc__c );
        //worecord.Unit_Type__c=workjob.Unit_Type__c;
        worecord.Repair_Location__c=workjob.Repair_Location__c;
        // worecord.Sub_Type__c=workjob.Sub_Type__c;
        worecord.Warranty_Authorization_Flag__c=workjob.Warranty_Authorization_Flag__c;
        worecord.PSN_Not_Available__c=workjob.PSN_Not_Available__c;
        
        /* Added Code to store Region and Category values for Story - 70323 */
        worecord.Region__c = workJob.Region__c;
        worecord.Territory__c = workJob.Territory__c;
        worecord.Before_In_Service__c = workJob.Before_In_Service__c;
        worecord.Contact_ID__c = workJob.Contact_ID__c;
        worecord.CSS_Bms_ContactBoolean__c = workJob.CSS_Bms_ContactBoolean__c;
        
        system.debug('Inside JOWrap2');
    }
}