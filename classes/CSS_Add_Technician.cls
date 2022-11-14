/**********************************************************************
Name:CSS_Add_Technician
Copyright © 2011  Cummins
======================================================================
======================================================================
Purpose:                                                            
Service Jobs Additional Technicians  Controller                                                             
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                 
1.0 - Gyan Pany   1/20/2016 1:02 AM     INITIAL DEVELOPMENT                      
2.0 - Roopa       2/10/2016 4:27 PM     UDAC WIRE FRAME CHANGES                  
3.0 - Anirudh     2/11/2016             Coding Standards
4.0 - Satish      2/15/2016       Fixed to handle not only Service 
Technicians but other dealer technicians as well  
***********************************************************************/

public with sharing class CSS_Add_Technician{
    //Static Variables 
    public Id jobId{
        get;
        set {
            jobId = value;
        }
    }
    public id strUsers1 {get;set;}
    public id strUsers2 {get;set;}
    public id strUsers3 {get;set;}
    public id strUsers4 {get;set;}
    public id strUsers5 {get;set;}
    public id strUsers6 {get;set;}
    public id strUsers7 {get;set;}
    public id strUsers8 {get;set;}
    public id strUsers9 {get;set;}
    public id strUsers10 {get;set;}
    public CSS_Job_Order__c jo;
    public string userLocation;
    public boolean assignedUser {get;set;}
    public boolean assignedUserSec {get;set;}
    public boolean assignedUserThird {get;set;}
    public boolean assignedUserFourth {get;set;}
    public boolean assignedUserFifth {get;set;}
    public boolean assignedUserSixth {get;set;}
    public boolean assignedUserSeventh {get;set;}
    public boolean assignedUserEigth {get;set;}
    public boolean assignedUserNineth {get;set;}
    public boolean assignedUserTenth {get;set;}

    public string struAssId {get;set;}
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
    public String SubStatusPrevValue{get;set;}
    public String SelectedSubStatus{get;set;}
    public Boolean isDealer {get;set;}
    List<CSS_UserLocation__c> allUsersList= new List<CSS_UserLocation__c>();
    List<CSS_AccredUser__c> certifiedUserList = new List<CSS_AccredUser__c>(); 
    public CSS_Add_Technician() {
        try{
            assignedUser = false;
            assignedUserSec = false;
            assignedUserThird = false;
            assignedUserFourth = false;
            assignedUserFifth = false;
            assignedUserSixth = false;
            assignedUserSeventh = false;
            assignedUserEigth = false;
            assignedUserNineth = false;
            assignedUserTenth = false;
            SelectedSubStatus= '';
            JobID=ApexPages.CurrentPage().getParameters().get('id');
            jo=[select id,JobLocation__c,Creator_Location__c, Add_Tech1__c,Add_Tech2__c,Add_Tech3__c,Add_Tech4__c,Add_Tech5__c,Add_Tech6__c,Add_Tech7__c,Add_Tech8__c,Add_Tech9__c,Assigned__c,Assigned_To__r.id,Assigned_To__c,Additional_Tech2__r.id,Additional_Tech1__r.id,Additional_Tech1__c,Additional_Tech2__c,Additional_Tech3__r.id,Additional_Tech3__c,Additional_Tech4__r.id,Additional_Tech4__c,Additional_Tech5__r.id,Additional_Tech5__c,Additional_Tech6__r.id,Additional_Tech6__c,Additional_Tech7__r.id,Additional_Tech7__c,Additional_Tech8__r.id,Additional_Tech8__c,Additional_Tech9__r.id,Additional_Tech9__c,Status__c,Previous_Status__c,Service_Model__c,Sub_Status__c,LastUpdateSubStatus__c from CSS_Job_Order__c where id=:JobID LIMIT 1];

            //   user Recu = css_utility.getUserAttributes(userInfo.getUserId());
            //  userLocation=Recu.User_Location__c;  
            System.debug('The Job Location >> '+jo.Creator_Location__c);
            if(jo.Creator_Location__c!= ''){ 
                //added order by clause in query as per Honda ROD Sprint story 110910 by venkat           
                allUsersList = [Select id,UserId__r.Name,UserId__r.lastname,UserId__r.firstname,UserId__r.id,Name,Location_code__c,Location_Name__c from CSS_UserLocation__c Where Location_code__c =:jo.Creator_Location__c and isActive__c = True and Location_Source__c != 'ARF' order by UserId__r.lastname asc limit 50000];
            }
            System.debug('The user list is'+allUsersList);
            // System.debug('The values is'+jo.Service_Model__c+ ' '+userLocation);
            certifiedUserList = [select User_Login_ID__c,User__r.id,User__r.Name, User__r.FirstName, User__r.LastName from CSS_AccredUser__c where Service_Model_Name__c =:jo.Service_Model__c and Location__c= :jo.Creator_Location__c and User__r.IsActive= True];
            System.debug('The certified list is'+certifiedUserList);

            if(jo.Sub_Status__c != ''){
                SelectedSubStatus= jo.Sub_Status__c;
            }
            getDropDownValueCons();
            getDropDownValueSecCon();
            getDropDownValueThirdCon();
            getDropDownValueFourCon();
            getDropDownValueFifthCon();
            getDropDownValueSixthCon();
            getDropDownValueSeventhCon();
            getDropDownValueEigthCon();
            getDropDownValueNinethCon();
            getDropDownValueTenthCon();
        }catch(Exception e){
        }
        isDealer = true;
        string userType = css_Utility.getOrgType(userinfo.getUserId());
        if(userType!=null && userType!= '') {
            if(userType == 'DLR') {
                isDealer = true;
            }else if(userType == 'DISTR') {
                isDealer = false;
            }
        }
        
        integer qCount = limits.getQueries();
        integer qCount1 = limits.getLimitQueries();
        system.debug('Queries Count Add Technician--'+qCount+'Queries Limit--'+qCount1);
    }
    public PageReference getFirstPicklistValues() {
        getItems1();
        return null;
    }
    public PageReference getSecondPicklistValues() {
        getItems2();
        return null;
    }
    public PageReference getThirdPicklistValues() {
        getItems3();
        return null;
    }
    public PageReference getfourthPicklistValues() {
        getItems4();
        return null;
    }
    public PageReference getfifthPicklistValues() {
        getItems5();
        return null;
    }
    public PageReference getsixthPicklistValues() {
        getItems6();
        return null;
    }
    public PageReference getseventhPicklistValues() {
        getItems7();
        return null;
    }
    public PageReference geteigthPicklistValues() {
        getItems8();
        return null;
    }
    public PageReference getninenthPicklistValues() {
        getItems9();
        return null;
    }
    public PageReference getnitenthPicklistValues() {
        getItems10();
        return null;
    }
    //Code to add sub status 
      public List<SelectOption> getSubStatus(){
        system.debug('User ERP System'+Cache.Session.get('UserERPSystem'));
        boolean claimEnabled;
        claimEnabled = css_utility.getclaimsapprove(UserInfo.getUserId());
        List<SelectOption> options1 = new List<SelectOption>();
        List<Schema.PicklistEntry> ple = CSS_Job_Order__c.Sub_Status__c.getDescribe().getPicklistValues();
         system.debug(' claimEnabled 1'+claimEnabled);
         
         User usr = css_utility.getUserAttributes(userinfo.getUserId());
            string userRole = usr.UserRoleName__c;
          String profileName=usr.profile.name;
         
        for( Schema.PicklistEntry f : ple){
            if(isDealer)
            {
                 //if(f.getLabel() =='Parts Received from ERP' || f.getLabel() == 'Waiting for Parts from ERP' || ((f.getLabel() == 'Ready for Claim Creation' || f.getLabel() == 'Claim in Progress') && claimEnabled == false)){  //Sneha commented this condition and added below for getting 'ready for claim creation' #GSSC-242
                if((f.getLabel() =='Parts Received from ERP' || f.getLabel() == 'Waiting for Parts from ERP' || ((f.getLabel() == 'Claim in Progress') && claimEnabled == false)) || (f.getLabel() == 'Ready for Claim Creation' && !profileName.contains('Advanced') && !userRole.contains('Factory'))){   //Sneha added below condition for #GSSC-242
                system.debug('f.getLabel()'+f.getLabel() );
                }
                else{
                    options1.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            }else{
                // if(((f.getLabel() == 'Ready for Claim Creation' || f.getLabel() == 'Claim in Progress') && claimEnabled == false)  || (Cache.Session.get('UserERPSystem') != null && Cache.Session.get('UserERPSystem') != 'One BMS' && (f.getLabel() =='Parts Received from ERP' || f.getLabel() == 'Waiting for Parts from ERP'))){  //Sneha commented this condition and added below for getting 'ready for claim creation' #GSSC-242
               if((((f.getLabel() == 'Claim in Progress') && claimEnabled == false)  || (Cache.Session.get('UserERPSystem') != null && Cache.Session.get('UserERPSystem') != 'One BMS' && (f.getLabel() =='Parts Received from ERP' || f.getLabel() == 'Waiting for Parts from ERP'))) ||  (f.getLabel() == 'Ready for Claim Creation' && !profileName.contains('Advanced') && !userRole.contains('Factory'))){   //Sneha added below condition for #GSSC-242
               
                }
                else{
                    options1.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            }
        }
        return options1;
    }
    public List<SelectOption> getItems1() {
        List<SelectOption> options1 = new List<SelectOption>();
        if(certifiedSelected==true){
            if(jo.Assigned_To__c!=null ){
                //options1.add(new selectoption(jo.Assigned_To__c,jo.Assigned__c));
                options1.add(new selectoption('','--Select--'));
                if(certifiedUserList!=null && certifiedUserList.size()>0){
                    //options1.add(new selectoption(jo.Assigned_To__c,jo.Assigned__c));
                    for(CSS_AccredUser__c accredUser:certifiedUserList){
                        if(jo.Assigned__c==accredUser.User__r.name){
                            options1.add(new selectoption(jo.Assigned_To__c,jo.Assigned__c));}
                        if(jo.Assigned_To__r.id!=accredUser.User__r.id){
                            if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                            options1.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                        }
                    }
                }
            }
            else{
                options1.add(new selectoption('','--Select--'));
                if(certifiedUserList!=null && certifiedUserList.size()>0){
                    for(CSS_AccredUser__c accredUser:certifiedUserList){
                        if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                        options1.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
        }else{
            if(jo.Assigned_To__c!=null ){
                options1.add(new selectoption(jo.Assigned_To__c,jo.Assigned__c));
                options1.add(new selectoption('','--Select--'));
                system.debug('allUsersList>>>>>>'+allUsersList);
                system.debug('jo.Assigned_To__r>>>>'+jo.Assigned_To__r);
                if(allUsersList!=null && allUsersList.size()>0){
                    for(CSS_UserLocation__c u:allUsersList){
                        if(jo.Assigned_To__r.id!=u.id){ 
                            if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                            options1.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                        }
                    }
                }
            } else{
                options1.add(new selectoption('','--Select--'));
                if(allUsersList!=null && allUsersList.size()>0){
                    for(CSS_UserLocation__c u:allUsersList){
                        if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                            options1.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            }
        }
        return options1;
    }
    public List<SelectOption> getItems2() {
        List<SelectOption> options2 = new List<SelectOption>();
        if(certifiedSelected1==true){
            if(jo.Additional_Tech1__c!=null ){
                //options2.add(new selectoption(jo.Additional_Tech1__c,jo.Add_Tech1__c));
                options2.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(jo.Add_Tech1__c==accredUser.User__r.name){
                        options2.add(new selectoption(jo.Additional_Tech1__c,jo.Add_Tech1__c));}

                    if(jo.Additional_Tech1__r.id!=accredUser.User__r.id){
                     	if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                        options2.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
            else{
                options2.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                    options2.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
        }else{
            if(jo.Additional_Tech1__c!=null ){
                options2.add(new selectoption(jo.Additional_Tech1__c,jo.Add_Tech1__c));
                options2.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(jo.Additional_Tech1__r.id!=u.id){
                        if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options2.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            } else{
                options2.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options2.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                }
            }
        }
        return options2;
    }
    public List<SelectOption> getItems3() {
        List<SelectOption> options3 = new List<SelectOption>();
        if(certifiedSelected2==true){
            if(jo.Additional_Tech2__c!=null ){
                //options3.add(new selectoption(jo.Additional_Tech2__c,jo.Add_Tech2__c));
                options3.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(jo.Add_Tech2__c==accredUser.User__r.name){
                        options3.add(new selectoption(jo.Additional_Tech2__c,jo.Add_Tech2__c));}
                    if(jo.Additional_Tech2__r.id!=accredUser.User__r.id){
                        if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                        options3.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
            else{
                options3.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                    options3.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
        }else{
            if(jo.Additional_Tech2__c!=null ){
                options3.add(new selectoption(jo.Additional_Tech2__c,jo.Add_Tech2__c));
                options3.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(jo.Additional_Tech2__r.id!=u.id){
                        if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options3.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            } else{
                options3.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options3.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                }
            }
        }
        return options3; 
    }



    public List<SelectOption> getItems4() {
        List<SelectOption> options4 = new List<SelectOption>();
        if(certifiedSelected3==true){
            if(jo.Additional_Tech3__c!=null ){
                //options4.add(new selectoption(jo.Additional_Tech3__c,jo.Add_Tech3__c));
                options4.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(jo.Add_Tech3__c==accredUser.User__r.name){
                        options4.add(new selectoption(jo.Additional_Tech3__c,jo.Add_Tech3__c));}

                    if(jo.Additional_Tech3__r.id!=accredUser.User__r.id){
                        if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                        options4.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
            else{
                options4.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                    options4.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
        }else{
            if(jo.Additional_Tech3__c!=null ){
                options4.add(new selectoption(jo.Additional_Tech3__c,jo.Add_Tech3__c));
                options4.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(jo.Additional_Tech3__r.id!=u.id){
                        if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options4.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            } else{
                options4.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options4.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                }
            }
        }
        return options4; 
    }

    public List<SelectOption> getItems5() {
        List<SelectOption> options5 = new List<SelectOption>();
        if(certifiedSelected4==true){
            if(jo.Additional_Tech4__c!=null ){
                //options5.add(new selectoption(jo.Additional_Tech4__c,jo.Add_Tech4__c));
                options5.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(jo.Add_Tech4__c==accredUser.User__r.name){
                        options5.add(new selectoption(jo.Additional_Tech4__c,jo.Add_Tech4__c));}

                    if(jo.Additional_Tech4__r.id!=accredUser.User__r.id){
                        if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                        options5.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
            else{
                options5.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                    options5.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
        }else{
            if(jo.Additional_Tech4__c!=null ){
                options5.add(new selectoption(jo.Additional_Tech4__c,jo.Add_Tech4__c));
                options5.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(jo.Additional_Tech4__r.id!=u.id){
                        if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options5.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            } else{
                options5.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options5.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                }
            }
        }
        return options5; 
    }


    public List<SelectOption> getItems6() {
        List<SelectOption> options6 = new List<SelectOption>();
        if(certifiedSelected5==true){
            if(jo.Additional_Tech5__c!=null ){
                //options6.add(new selectoption(jo.Additional_Tech5__c,jo.Add_Tech5__c));
                options6.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(jo.Add_Tech5__c==accredUser.User__r.name){
                        options6.add(new selectoption(jo.Additional_Tech5__c,jo.Add_Tech5__c));}

                    if(jo.Additional_Tech5__r.id!=accredUser.User__r.id){
                        if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                        options6.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
            else{
                options6.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                    options6.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
        }else{
            if(jo.Additional_Tech5__c!=null ){
                options6.add(new selectoption(jo.Additional_Tech5__c,jo.Add_Tech5__c));
                options6.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(jo.Additional_Tech5__r.id!=u.id){
                        if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options6.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            } else{
                options6.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options6.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                }
            }
        }
        return options6; 
    }


    public List<SelectOption> getItems7() {
        List<SelectOption> options7 = new List<SelectOption>();
        if(certifiedSelected6==true){
            if(jo.Additional_Tech6__c!=null ){
                //options7.add(new selectoption(jo.Additional_Tech6__c,jo.Add_Tech6__c));
                options7.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(jo.Add_Tech6__c==accredUser.User__r.name){
                        options7.add(new selectoption(jo.Additional_Tech6__c,jo.Add_Tech6__c));}

                    if(jo.Additional_Tech6__r.id!=accredUser.User__r.id){
                        if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                        options7.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
            else{
                options7.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                    options7.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
        }else{
            if(jo.Additional_Tech6__c!=null ){
                options7.add(new selectoption(jo.Additional_Tech6__c,jo.Add_Tech6__c));
                options7.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(jo.Additional_Tech6__r.id!=u.id){
                        if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options7.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            } else{
                options7.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options7.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                }
            }
        }
        return options7; 
    }


    public List<SelectOption> getItems8() {
        List<SelectOption> options8 = new List<SelectOption>();
        if(certifiedSelected7==true){
            if(jo.Additional_Tech7__c!=null ){
                //options8.add(new selectoption(jo.Additional_Tech7__c,jo.Add_Tech7__c));
                options8.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(jo.Add_Tech7__c==accredUser.User__r.name){
                        options8.add(new selectoption(jo.Additional_Tech7__c,jo.Add_Tech7__c));}

                    if(jo.Additional_Tech7__r.id!=accredUser.User__r.id){
                        if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                        options8.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
            else{
                options8.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                    options8.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
        }else{
            if(jo.Additional_Tech7__c!=null ){
                options8.add(new selectoption(jo.Additional_Tech7__c,jo.Add_Tech7__c));
                options8.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(jo.Additional_Tech7__r.id!=u.id){
                        if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options8.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            } else{
                options8.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options8.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                }
            }
        }
        return options8; 
    }

    public List<SelectOption> getItems9() {
        List<SelectOption> options9 = new List<SelectOption>();
        if(certifiedSelected8==true){
            if(jo.Additional_Tech8__c!=null ){
                //options9.add(new selectoption(jo.Additional_Tech8__c,jo.Add_Tech8__c));
                options9.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(jo.Add_Tech8__c==accredUser.User__r.name){
                        options9.add(new selectoption(jo.Additional_Tech8__c,jo.Add_Tech8__c));}

                    if(jo.Additional_Tech8__r.id!=accredUser.User__r.id){
                        if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                        options9.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
            else{
                options9.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                    options9.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
        }else{
            if(jo.Additional_Tech8__c!=null ){
                options9.add(new selectoption(jo.Additional_Tech8__c,jo.Add_Tech8__c));
                options9.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(jo.Additional_Tech8__r.id!=u.id){
                        if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options9.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            } else{
                options9.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options9.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                }
            }
        }
        return options9; 
    }

    public List<SelectOption> getItems10() {
        List<SelectOption> options10 = new List<SelectOption>();
        if(certifiedSelected9==true){
            if(jo.Additional_Tech9__c!=null ){
                //options10.add(new selectoption(jo.Additional_Tech9__c,jo.Add_Tech9__c));
                options10.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(jo.Add_Tech9__c==accredUser.User__r.name){
                        options10.add(new selectoption(jo.Additional_Tech9__c,jo.Add_Tech9__c));}

                    if(jo.Additional_Tech9__r.id!=accredUser.User__r.id){
                        if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                        options10.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
            else{
                options10.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id != null && accredUser.User__r.name != null && accredUser.User__r.name != '')
                    options10.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
        }else{
            if(jo.Additional_Tech9__c!=null ){
                options10.add(new selectoption(jo.Additional_Tech9__c,jo.Add_Tech9__c));
                options10.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(jo.Additional_Tech9__r.id!=u.id){
                        if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options10.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            } else{
                options10.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id != null && u.UserId__r.Name != null && u.UserId__r.Name != '')
                        options10.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                }
            }
        }
        return options10; 
    }


    public void getDropDownValue(){
        System.debug('The value inside drop is'+strUsers1);
        if(strUsers1!=null){
            for(CSS_AccredUser__c accredUser:certifiedUserList){
                if(strUsers1==accredUser.User__r.id){
                    System.debug('The matches value is'+strUsers1 + ' '+accredUser.User__r.id +'  '+jo.Assigned_To__r.id + '  '+accredUser.User__r.id );
                    assignedUser = true;
                    break;
                }
                else{
                    assignedUser = false;
                }
            }
        }
        System.debug('The assigned CSS_UserLocation__c is'+assignedUser);
    }
    public void getDropDownValueCons(){
        for(CSS_AccredUser__c accredUser:certifiedUserList){
            if(jo.Assigned_To__r.id == accredUser.User__r.id){
                assignedUser = true;
                break;
            }
            else{
                assignedUser = false;
            }
        }
        System.debug('The assigned CSS_UserLocation__c is'+assignedUser);
    }
    public void getDropDownValueSec(){
        System.debug('The value is'+strUsers2);
        if(strUsers2!=null){
            for(CSS_AccredUser__c accredUser:certifiedUserList){
                if(strUsers2==accredUser.User__r.id){
                    assignedUserSec = true;
                    break;
                }
                else{
                    assignedUserSec = false;
                }
            }
        }
        System.debug('The assignedUserSec CSS_UserLocation__c is'+assignedUserSec);
    }
    public void getDropDownValueSecCon(){
        System.debug('The value is'+strUsers2);
        for(CSS_AccredUser__c accredUser:certifiedUserList){
            if(jo.Additional_Tech1__r.id == accredUser.User__r.id){
                assignedUserSec = true;
                break;
            }
            else{
                assignedUserSec = false;
            }
        }
        System.debug('The assignedUserSec CSS_UserLocation__c is'+assignedUserSec);
    }
    public void getDropDownValueThird(){
        System.debug('The value is'+strUsers2);
        if(strUsers3!=null){
            for(CSS_AccredUser__c accredUser:certifiedUserList){
                if(strUsers3==accredUser.User__r.id){
                    assignedUserThird = true;
                    break;
                }
                else{
                    assignedUserThird = false;
                }
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserThird);
    }

    public void getDropDownValueThirdCon(){
        System.debug('The value is'+strUsers2);
        for(CSS_AccredUser__c accredUser:certifiedUserList){
            if(accredUser.User__r.id == jo.Additional_Tech2__r.id){
                assignedUserThird = true;
                break;
            }
            else{
                assignedUserThird = false;
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserThird);
    }

    public void getDropDownValueFour(){
        System.debug('The value is'+strUsers3);
        if(strUsers4!=null){
            for(CSS_AccredUser__c accredUser:certifiedUserList){
                if(strUsers4==accredUser.User__r.id){
                    assignedUserFourth = true;
                    break;
                }
                else{
                    assignedUserFourth = false;
                }
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserFourth);
    }

    public void getDropDownValueFourCon(){
        System.debug('The value is'+strUsers3);
        for(CSS_AccredUser__c accredUser:certifiedUserList){
            if(accredUser.User__r.id == jo.Additional_Tech3__r.id){
                assignedUserFourth = true;
                break;
            }
            else{
                assignedUserFourth = false;
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserFourth);
    }

    public void getDropDownValueFifth(){
        System.debug('The value is'+strUsers4);
        if(strUsers5!=null){
            for(CSS_AccredUser__c accredUser:certifiedUserList){
                if(strUsers5==accredUser.User__r.id){
                    assignedUserFifth = true;
                    break;
                }
                else{
                    assignedUserFifth = false;
                }
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserFifth);
    }

    public void getDropDownValueFifthCon(){
        System.debug('The value is'+strUsers4);
        for(CSS_AccredUser__c accredUser:certifiedUserList){
            if(accredUser.User__r.id == jo.Additional_Tech4__r.id){
                assignedUserFifth = true;
                break;
            }
            else{
                assignedUserFifth = false;
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserFifth);
    }

    public void getDropDownValueSixth(){
        System.debug('The value is'+strUsers5);
        if(strUsers6!=null){
            for(CSS_AccredUser__c accredUser:certifiedUserList){
                if(strUsers6==accredUser.User__r.id){
                    assignedUserSixth = true;
                    break;
                }
                else{
                    assignedUserSixth = false;
                }
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserSixth);
    }

    public void getDropDownValueSixthCon(){
        System.debug('The value is'+strUsers5);
        for(CSS_AccredUser__c accredUser:certifiedUserList){
            if(accredUser.User__r.id == jo.Additional_Tech5__r.id){
                assignedUserSixth = true;
                break;
            }
            else{
                assignedUserSixth = false;
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserSixth);
    }

    public void getDropDownValueSeventh(){
        System.debug('The value is'+strUsers6);
        if(strUsers7!=null){
            for(CSS_AccredUser__c accredUser:certifiedUserList){
                if(strUsers7==accredUser.User__r.id){
                    assignedUserSeventh = true;
                    break;
                }
                else{
                    assignedUserSeventh = false;
                }
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserSeventh);
    }

    public void getDropDownValueSeventhCon(){
        System.debug('The value is'+strUsers6);
        for(CSS_AccredUser__c accredUser:certifiedUserList){
            if(accredUser.User__r.id == jo.Additional_Tech6__r.id){
                assignedUserSeventh = true;
                break;
            }
            else{
                assignedUserSeventh = false;
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserSeventh);
    }

    public void getDropDownValueEigth(){
        System.debug('The value is'+strUsers7);
        if(strUsers8!=null){
            for(CSS_AccredUser__c accredUser:certifiedUserList){
                if(strUsers8==accredUser.User__r.id){
                    assignedUserEigth = true;
                    break;
                }
                else{
                    assignedUserEigth = false;
                }
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserEigth);
    }

    public void getDropDownValueEigthCon(){
        System.debug('The value is'+strUsers7);
        for(CSS_AccredUser__c accredUser:certifiedUserList){
            if(accredUser.User__r.id == jo.Additional_Tech7__r.id){
                assignedUserEigth = true;
                break;
            }
            else{
                assignedUserEigth = false;
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserEigth);
    }

    public void getDropDownValueNineth(){
        System.debug('The value is'+strUsers8);
        if(strUsers9!=null){
            for(CSS_AccredUser__c accredUser:certifiedUserList){
                if(strUsers9==accredUser.User__r.id){
                    assignedUserNineth = true;
                    break;
                }
                else{
                    assignedUserNineth = false;
                }
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserNineth);
    }

    public void getDropDownValueNinethCon(){
        System.debug('The value is'+strUsers8);
        for(CSS_AccredUser__c accredUser:certifiedUserList){
            if(accredUser.User__r.id == jo.Additional_Tech8__r.id){
                assignedUserNineth = true;
                break;
            }
            else{
                assignedUserNineth = false;
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserNineth);
    }

    public void getDropDownValueTenth(){
        System.debug('The value is'+strUsers9);
        if(strUsers10!=null){
            for(CSS_AccredUser__c accredUser:certifiedUserList){
                if(strUsers10==accredUser.User__r.id){
                    assignedUserTenth = true;
                    break;
                }
                else{
                    assignedUserTenth = false;
                }
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserTenth);
    }

    public void getDropDownValueTenthCon(){
        System.debug('The value is'+strUsers9);
        for(CSS_AccredUser__c accredUser:certifiedUserList){
            if(accredUser.User__r.id == jo.Additional_Tech9__r.id){
                assignedUserTenth = true;
                break;
            }
            else{
                assignedUserTenth = false;
            }
        }
        System.debug('The assignedUserThird CSS_UserLocation__c is'+assignedUserTenth);
    }

    public id getstrUsers1() {
        return strUsers1;
    }
    public void setstrUsers1(String strUsers1) {
        this.strUsers1 = strUsers1;
    }
    public id getstrUsers2() {
        return strUsers2;
    }
    public void setstrUsers2(String strUsers2) {
        this.strUsers2 = strUsers2;
    }
    public id getstrUsers3() {
        return strUsers3;
    }
    public void setstrUsers3(String strUsers3) {
        this.strUsers3 = strUsers3;
    }
    public id getstrUsers4() {
        return strUsers4;
    }
    public void setstrUsers4(String strUsers4) {
        this.strUsers4 = strUsers4;
    }
    public id getstrUsers5() {
        return strUsers5;
    }
    public void setstrUsers5(String strUsers5) {
        this.strUsers5 = strUsers5;
    }
    public id getstrUsers6() {
        return strUsers6;
    }
    public void setstrUsers6(String strUsers6) {
        this.strUsers6 = strUsers6;
    }
    public id getstrUsers7() {
        return strUsers7;
    }
    public void setstrUsers7(String strUsers7) {
        this.strUsers7 = strUsers7;
    }
    public id getstrUsers8() {
        return strUsers8;
    }
    public void setstrUsers8(String strUsers8) {
        this.strUsers8 = strUsers8;
    }
    public id getstrUsers9() {
        return strUsers9;
    }
    public void setstrUsers9(String strUsers9) {
        this.strUsers9 = strUsers9;
    }
    public id getstrUsers10() {
        return strUsers10;
    }
    public void setstrUsers10(String strUsers10) {
        this.strUsers10 = strUsers10;
    }
    public void setSelectedSubStatus(String SelectedSubStatus) {
        this.SelectedSubStatus = SelectedSubStatus;
    }
    public String getLocCode() {
        String[] LocArray;
        String LocCode='';
        if(jo.Creator_Location__c !=null && jo.Creator_Location__c !='')
        { 
            if(jo.Creator_Location__c.contains('-')){
                LocArray = jo.Creator_Location__c.split('-');
                // system.debug('LocArray++++++++++++++++++'+LocArray[0]+ LocArray[1]); 
            }
        }
        if(LocArray != null && LocArray.size()>0)
            LocCode = LocArray[1];
        return LocCode; 
    }
    public PageReference redirectPopup(){  
        system.debug('SHAN TEST>>>>>>>');   
        try { 
            struAssId= jo.Assigned_to__c;
            if (jo.Status__c == 'Intake Complete' ) {
                jo.Status__c='Triage & Diagnosis';
                jo.Previous_Status__c='Intake Complete';
            }
            if (jo.Status__c == 'Review' ) {
                jo.Status__c=jo.Previous_Status__c;
                jo.Previous_Status__c='Review';
            }
            jo.Assigned_to__c=strusers1 ;
            jo.Additional_Tech1__c=strusers2 ;
            jo.Additional_Tech2__c =strusers3 ;
            jo.Additional_Tech3__c =strusers4;
            jo.Additional_Tech4__c =strusers5;
            jo.Additional_Tech5__c =strusers6;
            jo.Additional_Tech6__c =strusers7;
            jo.Additional_Tech7__c =strusers8;
            jo.Additional_Tech8__c =strusers9;
            jo.Additional_Tech9__c =strusers10;
            SubStatusPrevValue=jo.Sub_Status__c;
            system.debug('SubStatusPrevValue>>>>>>>'+SubStatusPrevValue);
            system.debug('SelectedSubStatus>>>>>>>>'+SelectedSubStatus);
            system.debug('SHANstrusers2>>>>>>>'+strusers2);
            system.debug('SHANstrusers1>>>>>>>'+strusers1);
            if(SubStatusPrevValue != SelectedSubStatus) {
                jo.Sub_Status__c =SelectedSubStatus;
                jo.LastUpdateSubStatus__c= system.now();
            }
                        
            update jo;
           
            // Call ANVL WebService in future call to send assigned technician information to ANVL system.
            CG_BL_ANVL.ANVL_RequestResponse(jo.id);
           
        } catch(Exception e) {
        }
        //String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        //PageReference pageRef = new PageReference(sDestURL+'id='+jobId); 
        //pageRef.setRedirect(true);
        //return pageRef;
        pageReference ReturnPage = ApexPages.currentPage(); 
        Id id = ReturnPage.getParameters().get('Id');
        Id symid= ReturnPage.getParameters().get('symid');
        Id fcid= ReturnPage.getParameters().get('fcid');
        String rank= ReturnPage.getParameters().get('rank');


        ReturnPage.getParameters().clear();
        ReturnPage.getParameters().put('Id', id);
        ReturnPage.getParameters().put('fcid', fcid);
        ReturnPage.getParameters().put('rank', rank);
        ReturnPage.getParameters().put('symid', symid);
        ReturnPage.setRedirect(true);
        return ReturnPage ;

    }   
}