/****************************************************************************************************
Name: CSS_JobOrderExtension_Edit_h
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
Service Jobs Table Controller                                                            
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                 FEATURES/CSR/TTP
1.0 -    Satish       1/4/2016 5:40 PM      INITIAL DEVELOPMENT                      CSR: 
2.0 -    Satish       2/9/2016 12:33 PM     UDAC WIRE FRAME CHANGES                  TTP:
3.0 -    Anirudh        02/11/2016          Coding Standards
4.0 -    Satish         04/18/2016          Sort on recent and repeat flags
****************************************************************************************************/

public with sharing class CSS_JobOrderExtension_Edit_h{ 

    public String ServiceJobList { get; set; }
    public String SelectedSubStatus{get;set;}
	public boolean isclaimenable{get;set;}
	public Boolean Profilecheck { get; set; }
    /*Wrapper class to store the Service Job Info */
    public class ServiceJobWrap {
        //Static Variables 

        //varibale for showing Bold
        public boolean showBold;
        public string id;
        public string name;
        public string Customer_Name;
        // location story start 
        public string Job_Location;
        // location story end
        // MultiLocation Story code start ED
        public string Job_LocationCode;
        // MultiLocation Story code End ED
        public string Assigned_To;
        public string Assigned;

        public string Assigned_To1;
        public string AssignedTech1;

        public string Assigned_To2;
        public string AssignedTech2;
        //Added by shanthi- Assignee
        public string Assigned_To3;
        public string AssignedTech3;

        public string Assigned_To4;
        public string AssignedTech4;
        public string Assigned_To5;
        public string AssignedTech5;
        public string Assigned_To6;
        public string AssignedTech6;
        public string Assigned_To7;
        public string AssignedTech7;
        public string Assigned_To8;
        public string AssignedTech8;
        public string Assigned_To9;
        public string AssignedTech9;
        //end
        public string DSID;    
        public string Date_In;
        public string Date_In_sort;
        public string Created_Time_Zone;
        public string Created_Time_sort;
        public string Status;
        public string Sub_Status;
        public string LastUpdateSubStatus;
        public boolean RecentVisit;
        public boolean Repeat_Visit;
        public string LastSaved;
        public string LastSaved_sort;
        public string Service_Model;
        public string Unit_Number;
        public string Shop_s_Work_Order; 
        public string dField;
        public string jobStatus;
        public string jobLocation;
        
        public String Claims;

        /*Wrapper class Constructor to initialize the value to members */
        ServiceJobWrap () {
            Customer_Name='';
            // location story start 
            Job_Location='';
            //// location story end
            Assigned_To='';
            Assigned='';
            Assigned_To1='';
            AssignedTech1='';
            Assigned_To2='';
            AssignedTech2='';
            Assigned_To3='';
            AssignedTech3='';
            Assigned_To4='';
            AssignedTech4='';
            Assigned_To5='';
            AssignedTech5='';
            Assigned_To6='';
            AssignedTech6='';
            Assigned_To7='';
            AssignedTech7='';
            Assigned_To8='';
            AssignedTech8='';
            Assigned_To9='';
            AssignedTech9='';
            DSID='';
            Date_In='';
            Date_In_sort='';
            Status='';
            Sub_Status ='';
            LastUpdateSubStatus = '';
            Service_Model='';
            Unit_Number='';
            Shop_s_Work_Order=null;
            dField='';
            Created_Time_sort='';
            jobLocation='';
            Job_LocationCode ='';
            claims = '';
        }

    }
    /*Wrapper class to store the User Info */
    public class UserbyRoleWrap{

        public string UserId;
        public string UserName;    
        public string UserLoc;
        public string UserRole;
        public string UserCertSMN;

    }       

    //Method to bring the list of Account and Serialize Wrapper Object as JSON
    public  static String getlstServiceJob() {
        
        try{
            system.debug('IN lstServiceJob ***');
            /*Get The Profile Based for Logged in User*/
            String profileName;
             if(!Test.isRunningTest()){
            Id profileId=userinfo.getProfileId();
            profileName=[Select Id,Name from Profile where Id=:profileId].Name;
             }else{
            profileName=[SELECT Id,Name FROM Profile WHERE Name='CSS_Service_TECHNICIAN' LIMIT 1].Name;
             }
            system.debug('profileName'+profileName);

            List < CSS_Job_Order__c > lstjob;
            List < CSS_Job_Order__c > prevAssignedjobs;
            List < CSS_Job_Order__c > jobIds;
            List < CSS_Job_Order__share > sharedIds;
            Set <ID> sharedIds1 = new Set<ID>();

        
            List < ServiceJobWrap > lstwrap = new List < ServiceJobWrap > ();

            if (profileName.toUpperCase().contains('TECHNICIAN'))
            {
                lstjob = [select id,JobStatus__c, Name, Customer_Name__c,LastSaved__c, Assigned_To__c, Assigned__c,Assigned_To__r.Name, Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,Repeat_Visit__c, RecentVisit__c, DSID__C, Date_In__c, Created_Time_Zone__c, Status__c,Sub_Status__c,LastUpdateSubStatus__c, Service_Model__C, Unit_Number__c, Shop_Work_Order__c, 
                          JobLocation__c,Claim_ID__c,Creator_Location__c, (Select Body from Notes  where Title = 'Bold')
                          from CSS_Job_Order__c 
                          where Status__c !='Intake' and status__c Not in ('Canceled' , 'Closed') and 
                          (Assigned_To__c=:userInfo.getUserId() or Additional_Tech1__c=:userInfo.getUserId() or Additional_Tech2__c=:userInfo.getUserId() or Additional_Tech3__c=:userInfo.getUserId() or
                           Additional_Tech4__c=:userInfo.getUserId() or Additional_Tech5__c=:userInfo.getUserId() or Additional_Tech6__c=:userInfo.getUserId() or Additional_Tech7__c=:userInfo.getUserId() or
                           Additional_Tech8__c=:userInfo.getUserId() or Additional_Tech9__c=:userInfo.getUserId()) 
                          order by LastModifiedDate desc LIMIT 25];        
                jobIds = [select id from CSS_Job_Order__c where Status__c !='Intake' and (Assigned_To__c=:userInfo.getUserId() or Additional_Tech1__c=:userInfo.getUserId() or Additional_Tech2__c=:userInfo.getUserId()or Additional_Tech3__c=:userInfo.getUserId() or Additional_Tech4__c=:userInfo.getUserId() or Additional_Tech5__c=:userInfo.getUserId() or Additional_Tech6__c=:userInfo.getUserId() or Additional_Tech7__c=:userInfo.getUserId() or Additional_Tech8__c=:userInfo.getUserId() or Additional_Tech9__c=:userInfo.getUserId() )];
                //sharedIds = [select parentid from CSS_Job_Order__share where RowCause='CSS_Apex_AssignedTo_Sharing__c' and userOrGroupId=:userInfo.getUserId() and parentid not in :jobIds]; 
                system.debug('jobIds>>>>>>'+jobIds);
                sharedIds = CSS_ShareRecs.css_relatedrec(jobIds);
                //sharedIds1.add(sharedIds.parentid);
                system.debug('sharedIds>>>>>>'+sharedIds);

                for (CSS_Job_Order__share shid2 : sharedIds)
                {sharedIds1.add(shid2.parentid);}

                prevAssignedjobs=[select id,JobStatus__c, Name, Customer_Name__c,LastSaved__c, Assigned_To__c, Assigned_To__r.Name,Additional_Tech1__c,Add_Tech1__c,Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,
                                  Created_Time_Zone__c,Claim_ID__c, Repeat_Visit__c, RecentVisit__c, Assigned__c, DSID__C, Date_In__c, Service_Model__C, Status__c,Sub_Status__c,LastUpdateSubStatus__c, Unit_Number__c, Shop_Work_Order__c, 
                                  JobLocation__c,Creator_Location__c,(Select Body from Notes  where Title = 'Bold')
                                  FROM CSS_Job_Order__c 
                                  where 
                                  Status__c !='Intake' and 
                                  id IN :sharedIds1 
                                  order by LastModifiedDate desc LIMIT 25];
            }
            else
            {
                lstjob = [select id,JobStatus__c, Name, Customer_Name__c,Claim_ID__c, Assigned_To__c,LastSaved__c, Assigned_To__r.Name, Assigned__c,Additional_Tech1__c,Add_Tech1__c,
                          Additional_Tech2__c,Add_Tech2__c,Additional_Tech3__c,Add_Tech3__c,Additional_Tech4__c,Add_Tech4__c,Additional_Tech5__c,Add_Tech5__c,Additional_Tech6__c,Add_Tech6__c,Additional_Tech7__c,Add_Tech7__c,Additional_Tech8__c,Add_Tech8__c,Additional_Tech9__c,Add_Tech9__c,RecentVisit__c,Repeat_Visit__c, Created_Time_Zone__c, DSID__C, Date_In__c, Service_Model__C, Status__c,Sub_Status__c,LastUpdateSubStatus__c, Unit_Number__c, Shop_Work_Order__c, JobLocation__c,Creator_Location__c, (Select Id, Body from Notes) FROM CSS_Job_Order__c where status__c Not in ('Canceled' , 'Closed') order by LastModifiedDate desc LIMIT 25];    
            }
            
            
          
            //  List < CSS_Job_Order__c > lstjob = [select id, Name, Customer_Name__c, Assigned_To__c, Assigned_To__r.Name, Assigned__c, DSID__C, Date_In__c, Status__c, Unit_Number__c, Shop_Work_Order__c FROM CSS_Job_Order__c order by LastModifiedDate desc];    
            string userId = UserInfo.getUserId();
            for (CSS_Job_Order__c a: lstjob) {
                ServiceJobWrap awrap = new ServiceJobWrap();
                awrap.showBold = true;


                if(a.Notes!=null){

                    for (Note b: a.Notes) {   


                        if (b.body!=null){
                            if(b.body.contains(userId)){  

                                awrap.showBold = false; 

                            }
                        }
                    }
                }
                awrap.id = a.id;
                awrap.name = a.name;

                if (a.Customer_Name__c != null) {
                    awrap.Customer_Name = a.Customer_Name__c;
                }
                // Location story  start
                if (a.JobLocation__c != null) {
                    awrap.Job_Location = a.JobLocation__c;
                }
                // Location story end  

                // Multi Location story code start Ed
                if (a.Creator_Location__c != null) {
                    awrap.Job_LocationCode = a.Creator_Location__c;
                }
                // Multi Location story code start Ed 
                if (a.Assigned_To__c != null) {
                    awrap.Assigned_To = a.Assigned_To__c;
                }
                if (a.Assigned__c != null) {
                    awrap.Assigned = a.Assigned__c;
                }
                if (a.Additional_Tech1__c != null) {
                    awrap.Assigned_To1 = a.Additional_Tech1__c;
                }
                if (a.Add_Tech1__c != null) {
                    awrap.AssignedTech1 = a.Add_Tech1__c;
                }
                if (a.Additional_Tech2__c != null) {
                    awrap.Assigned_To2 = a.Additional_Tech2__c;
                }
                if (a.Add_Tech2__c != null) {
                    awrap.AssignedTech2 = a.Add_Tech2__c;
                }
                if (a.Additional_Tech3__c != null) {
                    awrap.Assigned_To3 = a.Additional_Tech3__c;
                }
                if (a.Add_Tech3__c != null) {
                    awrap.AssignedTech3 = a.Add_Tech3__c;
                }

                if (a.Additional_Tech4__c != null) {
                    awrap.Assigned_To4 = a.Additional_Tech4__c;
                }
                if (a.Add_Tech4__c != null) {
                    awrap.AssignedTech4 = a.Add_Tech4__c;
                }

                if (a.Additional_Tech5__c != null) {
                    awrap.Assigned_To5 = a.Additional_Tech5__c;
                }
                if (a.Add_Tech5__c != null) {
                    awrap.AssignedTech5 = a.Add_Tech5__c;
                }
                if (a.Additional_Tech6__c != null) {
                    awrap.Assigned_To6 = a.Additional_Tech6__c;
                }
                if (a.Add_Tech6__c != null) {
                    awrap.AssignedTech6 = a.Add_Tech6__c;
                }
                if (a.Additional_Tech7__c != null) {
                    awrap.Assigned_To7 = a.Additional_Tech7__c;
                }
                if (a.Add_Tech7__c != null) {
                    awrap.AssignedTech7 = a.Add_Tech7__c;
                }
                if (a.Additional_Tech8__c != null) {
                    awrap.Assigned_To8 = a.Additional_Tech8__c;
                }
                if (a.Add_Tech8__c != null) {
                    awrap.AssignedTech8 = a.Add_Tech8__c;
                }
                if (a.Additional_Tech9__c != null) {
                    awrap.Assigned_To9 = a.Additional_Tech9__c;
                }
                if (a.Add_Tech9__c != null) {
                    awrap.AssignedTech9 = a.Add_Tech9__c;
                }
                if (a.LastSaved__c != null) {
                    awrap.LastSaved = a.LastSaved__c.format('dd MMM yyyy hh:mm a z');
                    awrap.LastSaved_sort = a.LastSaved__c.format('yyyy MM dd HH:mm a z');
                }
                if (a.DSID__C != null) {
                    awrap.DSID = a.DSID__C;
                }
                if (a.Date_In__c != null) {
                    awrap.Date_In = a.Date_In__c.format('dd MMM yyyy hh:mm a z');
                    awrap.Date_In_sort = a.Date_In__c.format('yyyy MM dd HH:mm a z');
                }
                if (a.Service_Model__c != null) {
                    awrap.Service_Model = a.Service_Model__c;
                }
                if (a.Status__c != null) {
                    awrap.Status = a.Status__c;
                }  
                if (a.Sub_Status__c != null && a.Sub_Status__c!='-Select One-') {
                    awrap.Sub_Status = a.Sub_Status__c;
                }
                if (a.LastUpdateSubStatus__c != null  && a.Sub_Status__c!='-Select One-') {
                    awrap.LastUpdateSubStatus = a.LastUpdateSubStatus__c.format('dd MMM yyyy hh:mm a z');
                }
                if (a.Unit_Number__c != null) {
                    awrap.Unit_Number = a.Unit_Number__c;
                }            
                if(a.Created_Time_Zone__c!=null){
                    awrap.Created_Time_Zone = a.Created_Time_Zone__c.format('MMM dd yyyy hh:mm a z');
                    awrap.Created_Time_sort = a.Created_Time_Zone__c.format('yyyy MM dd HH:mm a z');
                }
                if (a.Shop_Work_Order__c != null) {
                    awrap.Shop_s_Work_Order = a.Shop_Work_Order__c;
                } 
                if (a.RecentVisit__c != false) {
                    awrap.RecentVisit = a.RecentVisit__c;
                }
                if (a.Repeat_Visit__c != false) {
                    awrap.Repeat_Visit = a.Repeat_Visit__c;
                }

                if (a.JobStatus__c != null) {
                    awrap.jobStatus = a.JobStatus__c;
                } 
                
                if(a.Claim_ID__c!=null){
                    awrap.claims=a.Claim_ID__c;
                }
                else
                   awrap.claims=''; 
                
                awrap.dField='Visible';
                awrap.jobLocation=a.JobLocation__c ;

                lstwrap.add(awrap);
            }

            if (profileName.toUpperCase().contains('TECHNICIAN')) {
                for (CSS_Job_Order__c b: prevAssignedjobs) {

                    ServiceJobWrap awrap2 = new ServiceJobWrap();
                    awrap2.showBold = true;

                    if(b.Notes!=null){

                        for (Note a: b.Notes) {   


                            if (a.body!=null){
                                if(a.body.contains(userId)){  

                                    awrap2.showBold = false; 

                                }
                            }
                        } 
                    }
                    awrap2.id = b.id;
                    awrap2.name = b.name;
                    if (b.Customer_Name__c != null) {
                        awrap2.Customer_Name = b.Customer_Name__c;
                    }
                    // Location story  start
                    if (b.JobLocation__c != null) {
                        awrap2.Job_Location = b.JobLocation__c;
                    }
                    // Location story  end

                    // Multi Location story code start Ed
                    if (b.Creator_Location__c != null) {
                        awrap2.Job_LocationCode = b.Creator_Location__c;
                    }
                    // Multi Location story code start Ed 


                    if (b.Assigned_To__c != null) {
                        awrap2.Assigned_To = b.Assigned_To__c;
                    }
                    if (b.LastSaved__c != null) {
                        awrap2.LastSaved = b.LastSaved__c.format('dd MMM yyyy hh:mm a z');
                        awrap2.LastSaved_sort = b.LastSaved__c.format('yyyy MM dd HH:mm a z');
                    }
                    if (b.Assigned__c != null) {
                        awrap2.Assigned = b.Assigned__c;
                    }

                    if (b.Additional_Tech1__c != null) {
                        awrap2.Assigned_To1 = b.Additional_Tech1__c;
                    }
                    if (b.Add_Tech1__c != null) {
                        awrap2.AssignedTech1 = b.Add_Tech1__c;
                    }

                    if (b.Additional_Tech2__c != null) {
                        awrap2.Assigned_To2 = b.Additional_Tech2__c;
                    }
                    if (b.Add_Tech2__c != null) {
                        awrap2.AssignedTech2 = b.Add_Tech2__c;
                    }
                    if (b.Additional_Tech3__c != null) {
                        awrap2.Assigned_To3 = b.Additional_Tech3__c;
                    }
                    if (b.Add_Tech3__c != null) {
                        awrap2.AssignedTech3 = b.Add_Tech3__c;
                    }
                    if (b.Additional_Tech4__c != null) {
                        awrap2.Assigned_To4 = b.Additional_Tech4__c;
                    }
                    if (b.Add_Tech4__c != null) {
                        awrap2.AssignedTech4 = b.Add_Tech4__c;
                    }
                    if (b.Additional_Tech5__c != null) {
                        awrap2.Assigned_To5 = b.Additional_Tech5__c;
                    }
                    if (b.Add_Tech5__c != null) {
                        awrap2.AssignedTech5 = b.Add_Tech5__c;
                    }
                    if (b.Additional_Tech6__c != null) {
                        awrap2.Assigned_To6 = b.Additional_Tech6__c;
                    }
                    if (b.Add_Tech6__c != null) {
                        awrap2.AssignedTech6 = b.Add_Tech6__c;
                    }
                    if (b.Additional_Tech7__c != null) {
                        awrap2.Assigned_To7 = b.Additional_Tech7__c;
                    }
                    if (b.Add_Tech7__c != null) {
                        awrap2.AssignedTech7 = b.Add_Tech7__c;
                    }
                    if (b.Additional_Tech8__c != null) {
                        awrap2.Assigned_To8 = b.Additional_Tech8__c;
                    }
                    if (b.Add_Tech8__c != null) {
                        awrap2.AssignedTech8 = b.Add_Tech8__c;
                    }
                    if (b.Additional_Tech9__c != null) {
                        awrap2.Assigned_To9 = b.Additional_Tech9__c;
                    }
                    if (b.Add_Tech9__c != null) {
                        awrap2.AssignedTech9 = b.Add_Tech9__c;
                    }
                    if (b.DSID__C != null) {
                        awrap2.DSID = b.DSID__C;
                    }
                    if (b.Date_In__c != null) {
                        awrap2.Date_In = b.Date_In__c.format('dd MMM yyyy hh:mm a z');
                        awrap2.Date_In_sort = b.Date_In__c.format('yyyy MM dd HH:mm a z');
                    }
                    if (b.Service_Model__c != null) {
                        awrap2.Service_Model = b.Service_Model__c;
                    }            
                    if (b.Status__c != null) {
                        awrap2.Status = b.Status__c;
                    } 
                    if (b.Sub_Status__c != null && b.Sub_Status__c!='-Select One-') {
                        awrap2.Sub_Status = b.Sub_Status__c;
                    }
                    if (b.LastUpdateSubStatus__c != null && b.Sub_Status__c!='-Select One-') {
                        awrap2.LastUpdateSubStatus = b.LastUpdateSubStatus__c.format('dd MMM yyyy hh:mm a z');
                    }
                    if (b.Unit_Number__c != null) {
                        awrap2.Unit_Number = b.Unit_Number__c;
                    }            

                    if (b.Shop_Work_Order__c != null) {
                        awrap2.Shop_s_Work_Order = b.Shop_Work_Order__c;
                    }     
                    if(b.Created_Time_Zone__c!=null){
                        awrap2.Created_Time_Zone = b.Created_Time_Zone__c.format('MMM dd yyyy hh:mm a z');
                        awrap2.Created_Time_sort = b.Created_Time_Zone__c.format('yyyy MM dd HH:mm a z');     
                    }
                    if (b.RecentVisit__c != false) {
                        awrap2.RecentVisit = b.RecentVisit__c;
                    }  
                    if (b.Repeat_Visit__c != false) {
                        awrap2.Repeat_Visit = b.Repeat_Visit__c;
                    }

                    if (b.JobStatus__c != null) {
                        awrap2.jobStatus = b.JobStatus__c;
                    }
                    
                    if(b.Claim_ID__c!=null){
                    awrap2.claims=b.Claim_ID__c;
                    }
                    else
                       awrap2.claims='';
                    
                    awrap2.dField='Previous';
                    awrap2.jobLocation=b.JobLocation__c;

                    lstwrap.add(awrap2);
                }
            }

            //return JSON.serialize(lstwrap);
            return JSON.serialize(lstwrap);
        }catch(Exception e){ return null;}  

    }

    public static string certSMN;

    @RemoteAction
    public static List<UserbyRoleWrap> certUserLIst(string jobSMN,string jobLoc){
        system.debug('I am Inside CertUserList');
        certSMN=jobSMN;
        system.debug('certSMN1'+certSMN);
        List<CSS_AccredUser__c> certifiedUserList = new List<CSS_AccredUser__c>(); 
        List < UserbyRoleWrap > ulstwrap = new List < UserbyRoleWrap > ();
        system.debug('jobLoc user>>> :  '+jobLoc);
        //MultiLocation story ED
        //String usrLocation = [SELECT User_Location__c FROM User WHERE id=:userInfo.getUserId()].User_Location__c;

        //List <profile> profId = [Select Id from profile where name LIKE '%Technician%'];
        //List < User> lstUser = [SELECT Id, name, User_Location__c, User_Role__c FROM User WHERE User_Location__c=:usrLocation and profileId IN:profId and isactive =true and User_Location__c!=null];
        //added order by clause in query as per Honda ROD Sprint story 110910 by venkat           
        List < CSS_UserLocation__c> lstUser = [Select id,Name,UserId__r.Name,UserId__r.lastname,UserId__r.firstname,Location_code__c,Location_Name__c FROM CSS_UserLocation__c WHERE Location_code__c=:jobLoc and Location_Source__c != 'ARF' and IsActive__c =true and Location_Name__c!=null order by UserId__r.lastname asc];
        system.debug('lstUser user>>> :  '+lstUser);
        certifiedUserList = [select User_Login_ID__c,User__r.id,User__r.Name,Service_Model_Name__c from CSS_AccredUser__c where Location__c= :jobLoc and User__r.IsActive=: True and Service_Model_Name__c=:certSMN];
        system.debug('certifiedUserList: '+certifiedUserList);
        string tempSMN;
        for (CSS_UserLocation__c b: lstUser) { 

            UserbyRoleWrap uwrap = new UserbyRoleWrap();
            uwrap.UserId = b.UserId__c;
            // uwrap.UserName = b.name;
            uwrap.UserName = b.UserId__r.FirstName+' '+b.UserId__r.LastName;
            uwrap.UserLoc = b.Location_Name__c;
            //ED comment start
            //   uwrap.UserRole = b.User_Role__c;
            //ED comment end
            // uwrap.UserCertSMN = b.Certified_SMN__c;
            tempSMN='';
            for(CSS_AccredUser__c accredUser :  certifiedUserList )
            { 
                if(accredUser.User__r.id == b.Id){
                    //system.debug('Accred User Cert '+ accredUser.User__r.id +' '+ b.Id + ' '+ accredUser.Service_Model_Name__c);
                    tempSMN=accredUser.Service_Model_Name__c;
                }                
                system.debug('uwrap.UserCertSMN: '+ tempSMN);
            }
            uwrap.UserCertSMN=tempSMN;

            system.debug('uwrap: '+ uwrap);
            ulstwrap.add(uwrap);
            system.debug('ulstwrap '+ ulstwrap);
        } 

        return ulstwrap;
    }    

    /* method to get the list of user with same location  and profile is Service Technician */
    public  static String getlstUserbyRole() {        
        system.debug('certSMN2'+certSMN);
        List<CSS_AccredUser__c> certifiedUserList = new List<CSS_AccredUser__c>(); 
        List < UserbyRoleWrap > ulstwrap = new List < UserbyRoleWrap > ();
        String usrLocation = [SELECT User_Location__c FROM User WHERE id=:userInfo.getUserId()].User_Location__c;
        List < User> lstUser = [SELECT Id, name,FirstName, LastName, User_Location__c, User_Role__c FROM User WHERE User_Location__c=:usrLocation and isactive =true and User_Location__c!=null];
        for (User b: lstUser) { 
            UserbyRoleWrap uwrap = new UserbyRoleWrap();
            uwrap.UserId = b.Id;
            uwrap.UserName = b.FirstName+' '+b.LastName;
            uwrap.UserLoc = b.User_Location__c;
            uwrap.UserRole = b.User_Role__c;
            ulstwrap.add(uwrap);
        } 
        return JSON.serialize(ulstwrap);
    }

    /* remote action to update the status and assidned tp of given Job Order Id*/    
    @RemoteAction
    public static void updateAccount(string id,string name,string Customer_Name, string Assigned_To2, string AddTech_To1, string AddTech_To2,string AddTech_To3,string AddTech_To4,string AddTech_To5,string AddTech_To6,string AddTech_To7,string AddTech_To8,string AddTech_To9){
        //list<User> userId = [SELECT Id FROM User WHERE Id = :Assigned_To2 LIMIT 1]; 
        CSS_Job_Order__c queriedJobOrder = [SELECT Id,Assigned_to__c,Additional_Tech1__c,Additional_Tech2__c,Additional_Tech3__c,Additional_Tech4__c,Additional_Tech5__c,Additional_Tech6__c,Additional_Tech7__c,Additional_Tech8__c,Additional_Tech9__c, Status__c,Sub_Status__c,LastUpdateSubStatus__c, Previous_Status__c, (Select Body from Notes where Title = 'Bold') FROM CSS_Job_Order__c WHERE Id = :id LIMIT 1];

        if (Assigned_To2 != '' || Assigned_To2 != null ){
            queriedJobOrder.Assigned_to__c= Assigned_To2;}
        if (AddTech_To1 != '' || AddTech_To1 != null ){
            queriedJobOrder.Additional_Tech1__c= AddTech_To1;}
        if ( AddTech_To2 != '' || AddTech_To2 != null ){
            queriedJobOrder.Additional_Tech2__c= AddTech_To2;}
        if ( AddTech_To3 != '' || AddTech_To3 != null ){
            queriedJobOrder.Additional_Tech3__c= AddTech_To3;}
        if ( AddTech_To4 != '' || AddTech_To4 != null ){
            queriedJobOrder.Additional_Tech4__c= AddTech_To4;}
        if ( AddTech_To5 != '' || AddTech_To5 != null ){
            queriedJobOrder.Additional_Tech5__c= AddTech_To5;}
        if ( AddTech_To6 != '' || AddTech_To6 != null ){
            queriedJobOrder.Additional_Tech6__c= AddTech_To6;}
        if ( AddTech_To7 != '' || AddTech_To7 != null ){
            queriedJobOrder.Additional_Tech7__c= AddTech_To7;}
        if ( AddTech_To8 != '' || AddTech_To8 != null ){
            queriedJobOrder.Additional_Tech8__c= AddTech_To8;}
        if ( AddTech_To9 != '' || AddTech_To9 != null ){
            queriedJobOrder.Additional_Tech9__c= AddTech_To9;}
        /*for(User temp : userId)
{
queriedJobOrder.Assigned_to__c= temp.Id; 
}*/

        if (queriedJobOrder.Status__c=='Intake Complete') {
            queriedJobOrder.Status__c='Triage & Diagnosis';
            queriedJobOrder.Previous_Status__c='Intake Complete';
        }
        if (queriedJobOrder.Status__c == 'Review' ) {
            queriedJobOrder.Status__c=queriedJobOrder.Previous_Status__c;
            queriedJobOrder.Previous_Status__c='Review';
        } 
        update queriedJobOrder;

        if(queriedJobOrder != null){
            string UserIdToUpdate = UserInfo.getUserId();
            if(queriedJobOrder.Notes != null && !queriedJobOrder.Notes.isEmpty()){
                if(queriedJobOrder.Notes[0].Body != null){
                    if(!queriedJobOrder.Notes[0].Body.contains(UserIdToUpdate)){
                        queriedJobOrder.Notes[0].Body += ','+UserIdToUpdate;
                    }
                }else{
                    queriedJobOrder.Notes[0].Body = UserIdToUpdate;
                } 
                update queriedJobOrder.Notes;               
            }//end of If Notes Null Check. 
        }//end of If serviceJob null check.
         // Call ANVL WebService in future call to send assigned technician information to ANVL system.
            CG_BL_ANVL.ANVL_RequestResponse(queriedJobOrder.id);
    }
    /* remote action to update the sub-status of given Job Order Id*/    
    @RemoteAction
    public static string updateAccountSS(string id,string subStatus){
        system.debug('subStatus--'+subStatus);
        CSS_Job_Order__c serviceJob = new CSS_Job_Order__c();
        serviceJob.id = id;
        serviceJob.Sub_Status__c = subStatus;
        serviceJob.LastUpdateSubStatus__c = system.now();
        update serviceJob;
        string dt = serviceJob.LastUpdateSubStatus__c.format('dd MMM yyyy hh:mm a z');
        return dt;
    }
    //Code to add sub status 
    public List<SelectOption> getSubStatus(){
        List<SelectOption> options1 = new List<SelectOption>();
        /*List<Schema.PicklistEntry> ple = CSS_Job_Order__c.Sub_Status__c.getDescribe().getPicklistValues();
        for( Schema.PicklistEntry f : ple)
            options1.add(new SelectOption(f.getLabel(), f.getValue()));*/
        options1.add(new SelectOption('none','None'));
        options1.add(new SelectOption('escalated','Escalated'));
        options1.add(new SelectOption('estimateNeedsUpdate','Estimate Needs Update'));
        options1.add(new SelectOption('repairComplete','Repair Complete'));
        options1.add(new SelectOption('tsComplete','Troubleshooting Complete'));
        options1.add(new SelectOption('ueOnLot','Unit/Vehicle on Lot'));
        options1.add(new SelectOption('waitingOnCust','Waiting on Customer'));
        options1.add(new SelectOption('waitingOnFact','Waiting on Factory'));
        options1.add(new SelectOption('waitingOnEstApp','Waiting on Estimate/Approval'));
        options1.add(new SelectOption('waitingOnParts','Waiting on Parts'));
        options1.add(new SelectOption('waitingOnTech','Waiting on Tech Availability'));
        options1.add(new SelectOption('waitingOnUE','Waiting on Unit/Vehicle'));
        options1.add(new SelectOption('wIP','Work In Progress'));
        options1.add(new SelectOption('CIP','Claim in Progress'));
        return options1;
    }
    public void setSelectedSubStatus(String SelectedSubStatus) {
        this.SelectedSubStatus = SelectedSubStatus;
    }
    
    public CSS_JobOrderExtension_Edit_h(){		
        system.debug('insidecon');		
        String profileId = UserInfo.getProfileId();
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id =:profileId];
        system.debug('profile>>>>>>>>>>'+profile.Name);
        if(profile.Name == 'EVL_Dealer_Advanced' || profile.Name == 'EVL_Dealer_Technician' || profile.Name == 'EVL_Dealer_Readonly'){
            Profilecheck = true;
        }
        else{
            Profilecheck = false;
        }
        isclaimenable = css_utility.getclaimsapprove(UserInfo.getUserId());		
        system.debug('isclaimenable'+isclaimenable);		
        
    } 

}