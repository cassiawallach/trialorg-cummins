/*
 * Block comments with details of changes
 */
public class CG_CL_ClaimsServiceProvider{
    public CG_CL_ClaimsIntake mainContr{set; get;}
    public String CreatorLocation{get;set;}   
    public String ContactName{get;set;}
    public String CID{get;set;}
    public List<SelectOption> locOptions{get;set;}
    public List<SelectOption> techOptions{get;set;}
    //public List<SelectOption> certifiedUserList{get;set;}
    public string Firstname{get;set;}
    public string Lastname{get;set;}
    //public CSS_Claims__c ClaimsRecord{set;get;}
    public CSS_Claims__c ClaimsRecord1{set;get;}
    public CSS_PSN__c psnRecord{set;get;}
    public CSS_Claims__c claimsRec{get;set;}  
    public List<CSS_Claim_Submission__c> submissionRec{get;set;} 
    public List<Account> accountrec;
    public String warrantyAuthFlag{get;set;}
    public Boolean locCertification{get;set;}

    public List<CSS_UserLocation__c> UserLocation{get; set;}
    public List<SelectOption> options;
    public CG_BL_Claims CG_BL_ClaimsObj = new CG_BL_Claims();
    public String defaultLoc {get; set;}
    Public Integer TechCount{get;set;}
    public String selectedLocation {get;set;}

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
    List<CSS_UserLocation__c> allUsersList= new List<CSS_UserLocation__c>();
    List<CSS_AccredUser__c> certifiedUserList = new List<CSS_AccredUser__c>();


    public CG_CL_ClaimsServiceProvider(){        
        TechCount = -1;
        //ClaimsRecord = new CSS_Claims__c();
        ClaimsRecord1 = new CSS_Claims__c();
        accountrec = new List<Account>();
        submissionRec = new List<CSS_Claim_Submission__c>();
        psnRecord = new CSS_PSN__c();
        locOptions = new List<SelectOption>();
        techOptions = new List<SelectOption>();
        //certifiedUserList = new List<SelectOption>();
        UserLocation = CG_BL_Claims.fetchMultiLocation();
        //UserLocation= '03520-04892';

        getLocationsName();
        system.debug('UserLocation'+ ' ' +UserLocation); 
        selectedLocation = ApexPages.currentPage().getParameters().get('selectLoc');
        system.debug('selectedLocation'+ ' ' + selectedLocation); 
        CID=ApexPages.CurrentPage().getParameters().get('id');
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
            if(CID !=null){
                /*ClaimsRecord = [Select id,Location__c,Location_Code__c,Service_Model__c,Account__c ,css_job__c,CSS_Job__r.Assigned_To__r.name,CSS_Job__r.Additional_Tech1__r.name,CSS_Job__r.Additional_Tech2__r.name,CSS_Job__r.Additional_Tech3__r.name,
                       CSS_Job__r.Additional_Tech4__r.name,CSS_Job__r.Additional_Tech5__r.name,CSS_Job__r.Additional_Tech6__r.name,CSS_Job__r.Additional_Tech7__r.name,
                       CSS_Job__r.Additional_Tech8__r.name,CSS_Job__r.Additional_Tech9__r.name,
                       (Select Id,Name,Location_Certification__c,Warranty_Authorization_Flag__c from CSS_PSNs__r where Primary__c=true)
                       from CSS_Claims__c where id= :CID];*/
                ClaimsRecord1 = [Select id,Location__c,Location_Code__c,Service_Model__c,Account__c ,css_job__c,Assigned_To__c,Assigned_To__r.id,Assigned_To__r.name,Assigned_To__r.FirstName,Assigned_To__r.LastName,Additional_Tech1__c,Additional_Tech1__r.id,Additional_Tech1__r.name,Additional_Tech1__r.FirstName,Additional_Tech1__r.LastName,Additional_Tech2__c,Additional_Tech2__r.id,Additional_Tech2__r.name,Additional_Tech2__r.FirstName,Additional_Tech2__r.LastName,Additional_Tech3__c,
                                 Additional_Tech3__r.id,Additional_Tech3__r.name,Additional_Tech3__r.FirstName,Additional_Tech3__r.LastName,Additional_Tech4__c,Additional_Tech4__r.id,Additional_Tech4__r.name,Additional_Tech4__r.FirstName,Additional_Tech4__r.LastName,Additional_Tech5__c,Additional_Tech5__r.id,Additional_Tech5__r.name,Additional_Tech5__r.FirstName,Additional_Tech5__r.LastName,Additional_Tech6__c,Additional_Tech6__r.id,Additional_Tech6__r.name,Additional_Tech6__r.FirstName,Additional_Tech6__r.LastName,Additional_Tech7__c,Additional_Tech7__r.id,Additional_Tech7__r.name,Additional_Tech7__r.FirstName,Additional_Tech7__r.LastName,
                                 Additional_Tech8__c,Additional_Tech8__r.id,Additional_Tech8__r.name,Additional_Tech8__r.FirstName,Additional_Tech8__r.LastName,Additional_Tech9__c,Additional_Tech9__r.id,Additional_Tech9__r.name,Additional_Tech9__r.FirstName,Additional_Tech9__r.LastName,Status__c,
                                 (Select Id,Name,Location_Certification__c,Warranty_Authorization_Flag__c from CSS_PSNs__r where Primary__c=true)
                                 from CSS_Claims__c where id= :CID];
                submissionRec = [select Id,Name,CreatedBy.firstname,CreatedBy.lastname,CSS_Claims__c from CSS_Claim_Submission__c where CSS_Claims__c =: CID LIMIT 1];
				system.debug('ClaimsRecord1 '+ClaimsRecord1);
                if(ClaimsRecord1!=null && ClaimsRecord1.CSS_PSNs__r.size()>0){
                    psnRecord =  ClaimsRecord1.CSS_PSNs__r[0];      
                }               

                /*if(claimsRecord1.css_job__c==null)
            certUserLIst(ClaimsRecord1.Service_Model__c,ClaimsRecord1.Location_Code__c);*/


            }
            else{
                certUserLIst(null,defaultLoc);

            }


            if(submissionRec.size()>0){
                system.debug('inside***submissionrec***');
                if(submissionRec[0].CreatedBy.firstname != null){
                    ContactName = submissionRec[0].CreatedBy.firstname + ' ' + submissionRec[0].CreatedBy.lastname;
                }
            }else{
                system.debug('inside*else***submissionrec***');
                Firstname   = UserInfo.getFirstname() ;
                Lastname    =  UserInfo.getLastname() ;
                ContactName = Firstname+' '+ Lastname;
            }
            system.debug('Claim Record2:'+ClaimsRecord1); 
            if(ClaimsRecord1 != null){

                if(ClaimsRecord1.Location__c!=null)
                {
                    CreatorLocation = ClaimsRecord1.Location__c+' - '+ClaimsRecord1.Location_code__c.RIGHT(5); 
                    system.debug('CreatorLocation' + ' ' + CreatorLocation);
                }
                else
                {
                    User user = css_utility.getUserAttributes(userInfo.getUserId());
                    CreatorLocation = user.User_Location__c;                               
                }                            
            } 
            else{
                User user = css_utility.getUserAttributes(userInfo.getUserId());
                CreatorLocation = user.User_Location__c;                         
            } 
            locOptions.add(new SelectOption(CreatorLocation,CreatorLocation));

            system.debug('CreatorLocation***'+ClaimsRecord1.Location__c);
            if(ClaimsRecord1 != null && ClaimsRecord1.Location_Code__c != null && ClaimsRecord1.Location_Code__c != ''){
            accountrec = [Select id, Location__c, Warranty_Training_Status__c, Product_Certification__c from Account where Location__c=: ClaimsRecord1.Location_Code__c];
            }
            system.debug('accountrec***'+accountrec);

            if(accountrec.size() > 0){
                system.debug('accountrec.Warranty_Training_Status__c***'+accountrec[0].Warranty_Training_Status__c);
                system.debug('accountrec.Product_Certification__c***'+accountrec[0].Product_Certification__c);
                warrantyAuthFlag = accountrec[0].Warranty_Training_Status__c;
                locCertification =  accountrec[0].Product_Certification__c;

            }

            String LocationManualClaims = (String)Cache.Session.get('ManualClaimsSelectedLocation');
            String manualLocationCode;

            String lstLocName;
            //    system.debug(' LocationManualClaims.length' + '      ' +  LocationManualClaims.length());
            if(LocationManualClaims !=null && LocationManualClaims!=''){
                lstLocName = LocationManualClaims.substring(0,LocationManualClaims.length()-7);

                system.debug(' lstLocName' + '      ' +  lstLocName);
                lstLocName = lstLocName.trim();
            }
            // string userName = UserInfo.getName();
            list<CSS_UserLocation__c> userLocationList = new list<CSS_UserLocation__c>();           
            userLocationList = [select id, Location_Name__c,Location_code__c from  CSS_UserLocation__c where Location_Name__c =:lstLocName and UserId__c=:UserInfo.getUserId()];            
            System.debug('locsize' + ' ' +userLocationList.size() );
            string newManualLoc;
            if(userLocationList!=null && userLocationList.size()>0){
                manualLocationCode = userLocationList[0].Location_code__c;
                System.debug(' inside if cond claimNewRec.Location_Code__c' + ' ' + newManualLoc );
            }


            system.debug('outside if manualLocationCode>>>>'+manualLocationCode);
            if(ClaimsRecord1.Location_Code__c != null && ClaimsRecord1.Location_Code__c!= ''){ 
                allUsersList = [Select id,UserId__r.Name,UserId__r.lastname,UserId__r.firstname,UserId__r.id,Name,Location_code__c,Location_Name__c from CSS_UserLocation__c Where Location_code__c =:ClaimsRecord1.Location_Code__c and isActive__c = True and Location_Source__c != 'ARF' order by UserId__r.lastname asc];
            }else if(manualLocationCode != null && manualLocationCode != ''){
                system.debug('manualLocationCode>>>>'+manualLocationCode);
                allUsersList = [Select id,UserId__r.Name,UserId__r.lastname,UserId__r.firstname,UserId__r.id,Name,Location_code__c,Location_Name__c from CSS_UserLocation__c Where Location_code__c =:manualLocationCode and isActive__c = True and Location_Source__c != 'ARF' order by UserId__r.lastname asc];
                system.debug('allUsersList>>>>'+allUsersList);
            }


            System.debug('The user list is'+allUsersList);

            certifiedUserList = [select User_Login_ID__c,User__r.id,User__r.Name, User__r.FirstName, User__r.LastName from CSS_AccredUser__c where Service_Model_Name__c =:ClaimsRecord1.Service_Model__c and Location__c= :ClaimsRecord1.Location_Code__c and User__r.IsActive= True];
            System.debug('The certified list is'+certifiedUserList);

            /*if(ClaimsRecord1 != null){
            system.debug('test---->'+ClaimsRecord1.Assigned_To__r.name);
            if(ClaimsRecord1.Assigned_To__c !=null){
                techCount= 0;
                techOptions.add(new SelectOption(ClaimsRecord1.Assigned_To__r.name,ClaimsRecord1.Assigned_To__r.name));
                techOptions.add(new selectoption('','--Select--'));
            }
            if(ClaimsRecord1.Additional_Tech1__r.name !=null ){
                techCount = 1;
                techOptions.add(new SelectOption(ClaimsRecord1.Additional_Tech1__r.name,ClaimsRecord1.Additional_Tech1__r.name));
                techOptions.add(new selectoption('','--Select--'));
            }
            if(ClaimsRecord1.Additional_Tech2__r.name !=null ){
                techCount = 2;
                techOptions.add(new SelectOption(ClaimsRecord1.Additional_Tech2__r.name,ClaimsRecord1.Additional_Tech2__r.name));
                techOptions.add(new selectoption('','--Select--'));
            }
            if(ClaimsRecord1.Additional_Tech3__r.name !=null ){
                techCount = 3;
                techOptions.add(new SelectOption(ClaimsRecord1.Additional_Tech3__r.name,ClaimsRecord.CSS_Job__r.Additional_Tech3__r.name));
                techOptions.add(new selectoption('','--Select--'));
            }
            if(ClaimsRecord1.Additional_Tech4__r.name !=null){
                techCount = 4;
                techOptions.add(new SelectOption(ClaimsRecord1.Additional_Tech4__r.name,ClaimsRecord1.Additional_Tech4__r.name));
                techOptions.add(new selectoption('','--Select--'));
            }
            if(ClaimsRecord1.Additional_Tech5__r.name !=null ){
                techCount = 5;
                techOptions.add(new SelectOption(ClaimsRecord1.Additional_Tech5__r.name,ClaimsRecord1.Additional_Tech5__r.name));
                techOptions.add(new selectoption('','--Select--'));
            }
            if(ClaimsRecord1.Additional_Tech6__r.name !=null){
                techCount = 6;
                techOptions.add(new SelectOption(ClaimsRecord1.Additional_Tech6__r.name,ClaimsRecord1.Additional_Tech6__r.name));
                techOptions.add(new selectoption('','--Select--'));
            }
            if(ClaimsRecord1.Additional_Tech7__r.name !=null ){
                techCount = 7;
                techOptions.add(new SelectOption(ClaimsRecord1.Additional_Tech7__r.name,ClaimsRecord1.Additional_Tech7__r.name));
                techOptions.add(new selectoption('','--Select--'));
            }
            if(ClaimsRecord1.Additional_Tech8__r.name !=null ){
                techCount = 8;
                techOptions.add(new SelectOption(ClaimsRecord1.Additional_Tech8__r.name,ClaimsRecord1.Additional_Tech8__r.name));
                techOptions.add(new selectoption('','--Select--'));
            }
            if(ClaimsRecord1.Additional_Tech9__r.name !=null ){
                techCount = 9;
                techOptions.add(new SelectOption(ClaimsRecord1.Additional_Tech9__r.name,ClaimsRecord1.Additional_Tech9__r.name));
                techOptions.add(new selectoption('','--Select--'));
            }
        }*/
            system.debug('techOptions****'+techOptions); 
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
        }
        catch(Exception ex){
            system.debug('excption***'+ex.getMessage()+ex.getLineNumber());

        }

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
    public List<SelectOption> getItems1() {
        List<SelectOption> options1 = new List<SelectOption>();
        if(certifiedSelected==true){
            if(ClaimsRecord1.Assigned_To__c!=null ){
                options1.add(new selectoption('','--Select--'));
                if(certifiedUserList!=null && certifiedUserList.size()>0){
                    for(CSS_AccredUser__c accredUser:certifiedUserList){
                        if(ClaimsRecord1.Assigned_To__r.Name == accredUser.User__r.name){
                            options1.add(new selectoption(ClaimsRecord1.Assigned_To__c,ClaimsRecord1.Assigned_To__r.FirstName+' '+ClaimsRecord1.Assigned_To__r.LastName));}
                        if(ClaimsRecord1.Assigned_To__r.id!=accredUser.User__r.id)
                            options1.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
            else{
                options1.add(new selectoption('','--Select--'));
                if(certifiedUserList!=null && certifiedUserList.size()>0){
                    for(CSS_AccredUser__c accredUser:certifiedUserList){
                        if(accredUser.User__r.id!=null && accredUser.User__r.Name!=null && accredUser.User__r.Name!= ''){
                            options1.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                        }
                    }
                }
            }
        }else{
            if(ClaimsRecord1.Assigned_To__c!=null ){
                options1.add(new selectoption(ClaimsRecord1.Assigned_To__c,ClaimsRecord1.Assigned_To__r.FirstName+' '+ClaimsRecord1.Assigned_To__r.LastName));
                options1.add(new selectoption('','--Select--'));
                if(allUsersList!=null && allUsersList.size()>0){
                    for(CSS_UserLocation__c u:allUsersList){
                        if(ClaimsRecord1.Assigned_To__r.id!=u.id){ 
                            if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                                options1.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                            }
                        }
                    }
                }
            } else{
                options1.add(new selectoption('','--Select--'));
                if(allUsersList!=null && allUsersList.size()>0){
                    for(CSS_UserLocation__c u:allUsersList){
                        if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                            options1.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                        }
                    }
                }
            }
        }
        return options1;
    }
    public List<SelectOption> getItems2() {
        List<SelectOption> options2 = new List<SelectOption>();
        if(certifiedSelected1==true){
            if(ClaimsRecord1.Additional_Tech1__c!=null ){
                options2.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(ClaimsRecord1.Additional_Tech1__r.name==accredUser.User__r.name){
                        options2.add(new selectoption(ClaimsRecord1.Additional_Tech1__c,ClaimsRecord1.Additional_Tech1__r.FirstName+' '+ClaimsRecord1.Additional_Tech1__r.LastName));}

                    if(ClaimsRecord1.Additional_Tech1__r.id!=accredUser.User__r.id)
                        options2.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
            else{
                options2.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id!=null && accredUser.User__r.Name!=null && accredUser.User__r.Name!= ''){
                        options2.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
        }else{
            if(ClaimsRecord1.Additional_Tech1__c!=null ){
                options2.add(new selectoption(ClaimsRecord1.Additional_Tech1__c,ClaimsRecord1.Additional_Tech1__r.FirstName+' '+ClaimsRecord1.Additional_Tech1__r.LastName));
                options2.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(ClaimsRecord1.Additional_Tech1__r.id!=u.id){
                        if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                            options2.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                        }
                    }
                }
            } else{
                options2.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                        options2.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            }
        }
        return options2;
    }
    public List<SelectOption> getItems3() {
        List<SelectOption> options3 = new List<SelectOption>();
        if(certifiedSelected2==true){
            if(ClaimsRecord1.Additional_Tech2__c!=null ){
                options3.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(ClaimsRecord1.Additional_Tech2__r.Name==accredUser.User__r.name){
                        options3.add(new selectoption(ClaimsRecord1.Additional_Tech2__c,ClaimsRecord1.Additional_Tech2__r.FirstName+' '+ClaimsRecord1.Additional_Tech2__r.LastName));}
                    if(ClaimsRecord1.Additional_Tech2__r.id!=accredUser.User__r.id)
                        options3.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
            else{
                options3.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id!=null && accredUser.User__r.Name!=null && accredUser.User__r.Name!= ''){
                        options3.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
        }else{
            if(ClaimsRecord1.Additional_Tech2__r.Name!=null ){
                options3.add(new selectoption(ClaimsRecord1.Additional_Tech2__c,ClaimsRecord1.Additional_Tech2__r.FirstName+' '+ClaimsRecord1.Additional_Tech2__r.LastName));
                options3.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(ClaimsRecord1.Additional_Tech2__r.id!=u.id){
                        if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                            options3.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                        }
                    }
                }
            } else{
                options3.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                        options3.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            }
        }
        return options3; 
    }



    public List<SelectOption> getItems4() {
        List<SelectOption> options4 = new List<SelectOption>();
        if(certifiedSelected3==true){
            if(ClaimsRecord1.Additional_Tech3__c!=null ){
                options4.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(ClaimsRecord1.Additional_Tech3__r.Name==accredUser.User__r.name){
                        options4.add(new selectoption(ClaimsRecord1.Additional_Tech3__c,ClaimsRecord1.Additional_Tech3__r.FirstName+' '+ClaimsRecord1.Additional_Tech3__r.LastName));}

                    if(ClaimsRecord1.Additional_Tech3__r.id!=accredUser.User__r.id)
                        options4.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
            else{
                options4.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id!=null && accredUser.User__r.Name!=null && accredUser.User__r.Name!= ''){
                        options4.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
        }else{
            if(ClaimsRecord1.Additional_Tech3__c!=null ){
                options4.add(new selectoption(ClaimsRecord1.Additional_Tech3__c,ClaimsRecord1.Additional_Tech3__r.FirstName+' '+ClaimsRecord1.Additional_Tech3__r.LastName));
                options4.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(ClaimsRecord1.Additional_Tech3__r.id!=u.id){
                        if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                            options4.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                        }
                    }
                }
            } else{
                options4.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){

                        options4.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            }
        }
        return options4; 
    }

    public List<SelectOption> getItems5() {
        List<SelectOption> options5 = new List<SelectOption>();
        if(certifiedSelected4==true){
            if(ClaimsRecord1.Additional_Tech4__c!=null ){
                options5.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(ClaimsRecord1.Additional_Tech4__r.Name==accredUser.User__r.name){
                        options5.add(new selectoption(ClaimsRecord1.Additional_Tech4__c,ClaimsRecord1.Additional_Tech4__r.FirstName+' '+ClaimsRecord1.Additional_Tech4__r.LastName));}

                    if(ClaimsRecord1.Additional_Tech4__r.id!=accredUser.User__r.id)
                        options5.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
            else{
                options5.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id!=null && accredUser.User__r.Name!=null && accredUser.User__r.Name!= ''){
                        options5.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
        }else{
            if(ClaimsRecord1.Additional_Tech4__c!=null ){
                options5.add(new selectoption(ClaimsRecord1.Additional_Tech4__c,ClaimsRecord1.Additional_Tech4__r.FirstName+' '+ClaimsRecord1.Additional_Tech4__r.LastName));
                options5.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(ClaimsRecord1.Additional_Tech4__r.id!=u.id){
                        if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                            options5.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                        }
                    }
                }
            } else{
                options5.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                        options5.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            }
        }
        return options5; 
    }


    public List<SelectOption> getItems6() {
        List<SelectOption> options6 = new List<SelectOption>();
        if(certifiedSelected5==true){
            if(ClaimsRecord1.Additional_Tech5__c!=null ){
                options6.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(ClaimsRecord1.Additional_Tech5__r.Name==accredUser.User__r.name){
                        options6.add(new selectoption(ClaimsRecord1.Additional_Tech5__c,ClaimsRecord1.Additional_Tech5__r.FirstName+' '+ClaimsRecord1.Additional_Tech5__r.LastName));}

                    if(ClaimsRecord1.Additional_Tech5__r.id!=accredUser.User__r.id)
                        options6.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
            else{
                options6.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id!=null && accredUser.User__r.Name!=null && accredUser.User__r.Name!= ''){
                        options6.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
        }else{
            if(ClaimsRecord1.Additional_Tech5__c!=null ){
                options6.add(new selectoption(ClaimsRecord1.Additional_Tech5__c,ClaimsRecord1.Additional_Tech5__r.FirstName+' '+ClaimsRecord1.Additional_Tech5__r.LastName));
                options6.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(ClaimsRecord1.Additional_Tech5__r.id!=u.id){
                        if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                            options6.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                        }
                    }
                }
            } else{
                options6.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                        options6.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }   
                }
            }
        }
        return options6; 
    }


    public List<SelectOption> getItems7() {
        List<SelectOption> options7 = new List<SelectOption>();
        if(certifiedSelected6==true){
            if(ClaimsRecord1.Additional_Tech6__c!=null ){
                options7.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(ClaimsRecord1.Additional_Tech6__r.Name==accredUser.User__r.name){
                        options7.add(new selectoption(ClaimsRecord1.Additional_Tech6__c,ClaimsRecord1.Additional_Tech6__r.FirstName+' '+ClaimsRecord1.Additional_Tech6__r.LastName));}

                    if(ClaimsRecord1.Additional_Tech6__r.id!=accredUser.User__r.id)
                        options7.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
            else{
                options7.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id!=null && accredUser.User__r.Name!=null && accredUser.User__r.Name!= ''){
                        options7.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
        }else{
            if(ClaimsRecord1.Additional_Tech6__c!=null ){
                options7.add(new selectoption(ClaimsRecord1.Additional_Tech6__c,ClaimsRecord1.Additional_Tech6__r.FirstName+' '+ClaimsRecord1.Additional_Tech6__r.LastName));
                options7.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(ClaimsRecord1.Additional_Tech6__r.id!=u.id){
                        if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                            options7.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                        }
                    }
                }
            } else{
                options7.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                        options7.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }  
                }
            }
        }
        return options7; 
    }


    public List<SelectOption> getItems8() {
        List<SelectOption> options8 = new List<SelectOption>();
        if(certifiedSelected7==true){
            if(ClaimsRecord1.Additional_Tech7__c!=null ){
                options8.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(ClaimsRecord1.Additional_Tech7__r.Name==accredUser.User__r.name){
                        options8.add(new selectoption(ClaimsRecord1.Additional_Tech7__c,ClaimsRecord1.Additional_Tech7__r.FirstName+' '+ClaimsRecord1.Additional_Tech7__r.LastName));}

                    if(ClaimsRecord1.Additional_Tech7__r.id!=accredUser.User__r.id)
                        options8.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
            else{
                options8.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id!=null && accredUser.User__r.Name!=null && accredUser.User__r.Name!= ''){
                        options8.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
        }else{
            if(ClaimsRecord1.Additional_Tech7__c!=null ){
                options8.add(new selectoption(ClaimsRecord1.Additional_Tech7__c,ClaimsRecord1.Additional_Tech7__r.FirstName+' '+ClaimsRecord1.Additional_Tech7__r.LastName));
                options8.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(ClaimsRecord1.Additional_Tech7__r.id!=u.id){
                        if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                            options8.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                        }
                    }
                }
            } else{
                options8.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                        options8.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            }
        }
        return options8; 
    }

    public List<SelectOption> getItems9() {
        List<SelectOption> options9 = new List<SelectOption>();
        if(certifiedSelected8==true){
            if(ClaimsRecord1.Additional_Tech8__c!=null ){
                options9.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(ClaimsRecord1.Additional_Tech8__r.Name==accredUser.User__r.name){
                        options9.add(new selectoption(ClaimsRecord1.Additional_Tech8__c,ClaimsRecord1.Additional_Tech8__r.FirstName+' '+ClaimsRecord1.Additional_Tech8__r.LastName));}

                    if(ClaimsRecord1.Additional_Tech8__r.id!=accredUser.User__r.id)
                        options9.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
            else{
                options9.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id!=null && accredUser.User__r.Name!=null && accredUser.User__r.Name!= ''){
                        options9.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
        }else{
            if(ClaimsRecord1.Additional_Tech8__c!=null ){
                options9.add(new selectoption(ClaimsRecord1.Additional_Tech8__c,ClaimsRecord1.Additional_Tech8__r.FirstName+' '+ClaimsRecord1.Additional_Tech8__r.LastName));
                options9.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(ClaimsRecord1.Additional_Tech8__r.id!=u.id){
                        if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                            options9.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                        }
                    }
                }
            } else{
                options9.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                        options9.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
                }
            }
        }
        return options9; 
    }

    public List<SelectOption> getItems10() {
        List<SelectOption> options10 = new List<SelectOption>();
        if(certifiedSelected9==true){
            if(ClaimsRecord1.Additional_Tech9__c!=null ){
                options10.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(ClaimsRecord1.Additional_Tech9__r.Name==accredUser.User__r.name){
                        options10.add(new selectoption(ClaimsRecord1.Additional_Tech9__c,ClaimsRecord1.Additional_Tech9__r.FirstName+' '+ClaimsRecord1.Additional_Tech9__r.LastName));}

                    if(ClaimsRecord1.Additional_Tech9__r.id!=accredUser.User__r.id)
                        options10.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                }
            }
            else{
                options10.add(new selectoption('','--Select--'));
                for(CSS_AccredUser__c accredUser:certifiedUserList){
                    if(accredUser.User__r.id!=null && accredUser.User__r.Name!=null && accredUser.User__r.Name!= ''){
                        options10.add(new selectoption(accredUser.User__r.id,accredUser.User__r.FirstName+' '+accredUser.User__r.LastName));
                    }
                }
            }
        }else{
            if(ClaimsRecord1.Additional_Tech9__c!=null ){
                options10.add(new selectoption(ClaimsRecord1.Additional_Tech9__c,ClaimsRecord1.Additional_Tech9__r.FirstName+' '+ClaimsRecord1.Additional_Tech9__r.LastName));
                options10.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(ClaimsRecord1.Additional_Tech9__r.id!=u.id){
                        if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                            options10.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                        }
                    }
                }
            } else{
                options10.add(new selectoption('','--Select--'));
                for(CSS_UserLocation__c u:allUsersList){
                    if(u.UserId__r.Id!=null && u.UserId__r.Name!=null && u.UserId__r.Name!= ''){
                        options10.add(new selectoption(u.UserId__r.Id,u.UserId__r.FirstName+' '+u.UserId__r.LastName));
                    }
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
                    System.debug('The matches value is'+strUsers1 + ' '+accredUser.User__r.id +'  '+ClaimsRecord1.Assigned_To__r.id + '  '+accredUser.User__r.id );
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
            if(ClaimsRecord1.Assigned_To__r.id == accredUser.User__r.id){
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
            if(ClaimsRecord1.Additional_Tech1__r.id == accredUser.User__r.id){
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
            if(accredUser.User__r.id == ClaimsRecord1.Additional_Tech2__r.id){
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
            if(accredUser.User__r.id == ClaimsRecord1.Additional_Tech3__r.id){
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
            if(accredUser.User__r.id == ClaimsRecord1.Additional_Tech4__r.id){
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
            if(accredUser.User__r.id == ClaimsRecord1.Additional_Tech5__r.id){
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
            if(accredUser.User__r.id == ClaimsRecord1.Additional_Tech6__r.id){
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
            if(accredUser.User__r.id == ClaimsRecord1.Additional_Tech7__r.id){
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
            if(accredUser.User__r.id == ClaimsRecord1.Additional_Tech8__r.id){
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
            if(accredUser.User__r.id == ClaimsRecord1.Additional_Tech9__r.id){
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


    //method to fecth all the locations based on the logged in user 


    public List<SelectOption> getLocationsName() {
        options = new List<SelectOption>();
        try {
            options = CG_BL_ClaimsObj.fetchLocationName(UserLocation);
            defaultLoc = CG_BL_ClaimsObj.defaultUserLocCode;
            system.debug('defaultLoc--'+defaultLoc);
            system.debug('options--'+options);
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsServiceProvider - getLocationsName Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('OUT CG_CL_ClaimsServiceProvider - getLocationsName Method ...');
        return options;
    }

    public class UserbyRoleWrap{

        public string UserId;
        public string UserName;    
        public string UserLoc;
        public string UserRole;
        public string UserCertSMN;

    }     

    public  string certSMN;

    public  void certUserLIst(string jobSMN,string jobLoc){
        certSMN=jobSMN;
        system.debug('certSMN1'+certSMN);

        List<CSS_AccredUser__c> certUserList = new List<CSS_AccredUser__c>();
        List < UserbyRoleWrap > ulstwrap = new List < UserbyRoleWrap > ();
        if(jobLoc==null){
            jobLoc = defaultLoc;
        }
        system.debug('jobLoc user>>> :  '+jobLoc);


        //MultiLocation story ED
        //String usrLocation = [SELECT User_Location__c FROM User WHERE id=:userInfo.getUserId()].User_Location__c;

        //List <profile> profId = [Select Id from profile where name LIKE '%Technician%'];
        //List < User> lstUser = [SELECT Id, name, User_Location__c, User_Role__c FROM User WHERE User_Location__c=:usrLocation and profileId IN:profId and isactive =true and User_Location__c!=null];
        //added order by clause in query as per Honda ROD Sprint story 110910 by venkat           
        List < CSS_UserLocation__c> lstUser = [Select id,Name,UserId__r.Name,UserId__r.lastname,UserId__r.firstname,Location_code__c,Location_Name__c FROM CSS_UserLocation__c WHERE Location_code__c=:jobLoc and Location_Source__c != 'ARF' and IsActive__c =true and Location_Name__c!=null order by UserId__r.lastname asc];
        system.debug('lstUser user>>> :  '+lstUser);
        certUserList = [select User_Login_ID__c,User__r.id,User__r.Name,Service_Model_Name__c from CSS_AccredUser__c where Location__c= :jobLoc and User__r.IsActive=: True and Service_Model_Name__c=:certSMN];
        system.debug('certifiedUserList: '+certUserList);
        string tempSMN;
        for (CSS_UserLocation__c b: lstUser) { 
            //certifiedUserList.add(new SelectOption(b.UserId__r.Name,b.UserId__r.Name));

            /*UserbyRoleWrap uwrap = new UserbyRoleWrap();
            uwrap.UserId = b.UserId__c;
            // uwrap.UserName = b.name;
            uwrap.UserName = b.UserId__r.Name;
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
            system.debug('ulstwrap '+ ulstwrap);*/
        } 

        //return ulstwrap;
    }
}