public class IAM_SiteAdmin_uploadFile_ctrl {

    //variable to hold the filebody
    public transient Blob fileForimport {get;set;}
    Public Integer SuccessUpload{get; set;}
    Public Integer failedUpload{get; set;}
    @TestVisible private map <string, String> appRole;
    @TestVisible private map <string, String> email_approw;
    @TestVisible private map <string, String> email_approwNew;
    @TestVisible private map <string, String> mapApplications;
    @TestVisible private List<Account> acc;
    @TestVisible private List<IAM_Application__c> lstApplications;
    @TestVisible private String output;
    public boolean isPendingApproval{get;set;}
    public string AppsHeader{get;set;}
    public boolean DataDownload{get;set;}
    public String data{get;set;}
    static final String accountId = 'AccountIdis';
    Map<String,String> mapAppId = new Map<String,String>();
    
    public IAM_SiteAdmin_uploadFile_ctrl(){
        AppsHeader = '';
        isPendingApproval = false;
        appRole = new map <string, String> ();
        mapApplications  = new map <string, String> ();
        email_approw = new map < string, String > ();
        email_approwNew = new map < string, String > ();
        SuccessUpload = 0;
        failedUpload = 0;
        DataDownload = false;
        acc = [select id, IAM_Service_Provider_Code__c,RecordType.Name,Location__c, CMI_Account_Num__c, CMI_Region__c,OwnerId,Parent.OwnerId,CMI_Account_Status__c from account where id =: ApexPages.CurrentPage().getParameters().get(accountId)];               
        lstApplications = [Select id,IAM_Account_Name__c,IAM_Application_Name__c,IAM_Status__c,IAM_Free_Subscription__c, 
                                      IAM_Role__c,IAM_Qsolexpiration__c,IAM_swregExpire__c from IAM_Application__c where IAM_Account_Name__c = :acc[0].id and IAM_Status__c =: System.Label.IAM_Status_Active];
                                      
        List<String> lstAppName = new List<String>();
            
        //fetch the account for which data needs to be uploaded for
        for(IAM_Application__c application :lstApplications ){
            lstAppName.add(application.IAM_Application_Name__c);
            AppsHeader += application.IAM_Application_Name__c;
            if (application.IAM_Role__c != null){
                AppsHeader += '(' + application.IAM_Role__c + ')' + ',';
            }else{
                AppsHeader += ',';
            }
            appRole.put(application.IAM_Application_Name__c, application.IAM_Role__c);
            //fixed - D-3142 - set Qsol_Expiration & IAM_swregExpire__c values if application is QSOL and Guidanz Mobile.
            if(application.IAM_Application_Name__c == 'QuickServe Online')
                mapApplications.put(application.IAM_Application_Name__c, application.IAM_Qsolexpiration__c);
            if(application.IAM_Application_Name__c == 'Guidanz Mobile')
                mapApplications.put(application.IAM_Application_Name__c, application.IAM_swregExpire__c);
        }
        
        System.debug('printing value of lstAppName...  '+lstAppName);
        List<RecordType> lstRecType = [Select Id,NAME from RecordType where name =: lstAppName and sobjecttype ='IAM_Contact_Provisioning__c'];
        System.debug('printing value of lstRecType...  '+lstRecType);
        
        for(RecordType recType : lstRecType){
            mapAppId.put(recType.name, recType.id);
        }
        System.debug('printing value of mapAppId...  '+mapAppId);
    }
    
    /*****
    *This method is used to strat the import action once the file is uploaded
    *********/
    public pagereference start_import(){
        if(fileForimport == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please upload your file'));
            return ApexPages.CurrentPage();
        }else{
            try{
                output = fileForimport.toString();
                System.debug('start_import-------output '+output);
            }catch (exception ex) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please upload a valid CSV document');
                ApexPages.addMessage(myMsg); 
                return null; 
            }
            try{
                Id approverId = IAM_SiteAdmin_Controller.getApproverId(acc[0].id);
                if(null == approverId)
                    approverId = System.Label.IAM_Default_IAM_Record_Owner;
                DataDownload = false;
                System.debug('start_import-------lstApplications '+lstApplications);
                System.debug('start_import-------appRole '+appRole);
                List<User> objUser = [select id, IAM_Final_Approver__c from user where id =: Userinfo.getUserid()];
                List <String> lstContactRows = output.split('\n');
                String headerIs = lstContactRows[0];
                System.debug('start_import-------headerIs '+headerIs);
                List <String> headers = lstContactRows[0].split(',');
                List <Contact> lstAllContacts = new List <Contact> ();
                List <IAM_Contact_Provisioning__c> lstContProvision = new List <IAM_Contact_Provisioning__c> ();
                map <String, Set <IAM_Contact_Provisioning__c>> mapContProvision = new map <String, Set < IAM_Contact_Provisioning__c>> ();
                List <contact> invalidContact = new List <contact> ();
                boolean isvalidApplication = true;
                for(Integer i = 1; i <  lstContactRows.size(); i++){
                    List <String> rowCells = lstContactRows[i].split(',');
                    Contact con = new Contact();
                    con.AccountId = acc[0].id;
                    con.Firstname = rowCells[0]; //First Name;
                    con.Lastname = rowCells[1]; //Last Name;           
                    con.Username__c = rowCells[2]; //UserName;
                    con.email = rowCells[3]; //email;
                    con.Phone = rowCells[4]; //Phone;            
                    con.IAM_Site_Admin__c = '' + rowCells[5].toLowercase().trim() == 'true' ? true : false; //Site Admin;
                    con.RecordtypeId = IAM_contactHelperClass.getRecordtypeId(System.Label.IAM_Record, System.Label.IAM_Contact_Singular_Label);
                    boolean isPrimaryContactExist = false;
                    for (Contact eachCOn: [select id, firstname, lastname,
                               CMI_Contact_Type__c, IAM_Site_Admin__c, Username__c, Account.CMI_Region__c from Contact where AccountId =: ApexPages.CurrentPage().getParameters().get(accountId)]){
                        if (eachCOn.CMI_Contact_Type__c == System.Label.IAM_Primary){
                            isPrimaryContactExist = true;
                        }
                    }
                    
                    if(!isPrimaryContactExist) {
                        con.CMI_Contact_Type__c = System.Label.IAM_Primary;
                    }else{
                        con.CMI_Contact_Type__c = System.Label.IAM_Secondary;
                    }
                    
                    if(con.IAM_Site_Admin__c && isPrimaryContactExist) {
                        con.CMI_Contact_Type__c = System.Label.IAM_Secondary;  //site admin
                    }
                    
                    if(!acc.isEmpty()){
                        if(acc[0].IAM_Service_Provider_Code__c != NULL && acc[0].Location__c != NULL){
                            con.IAM_Work_Group_Id__c = acc[0].Location__c + System.Label.IAM_WorkGrpAddition_Symbol;
                        }
                        if(objUser[0].IAM_Final_Approver__c == System.Label.IAM_Label_Y){
                            con.IAM_Contact_Status__c = System.Label.IAM_Status_Active;
                        }else if(acc[0].RecordType.Name == System.Label.IAM_WWSPS){
                            con.IAM_Contact_Status__c = System.Label.IAM_Status_Pending;
                        }else{
                            con.IAM_Contact_Status__c = System.Label.IAM_Status_Active;
                        }
                    }
                    if(!con.IAM_Site_Admin__c)
                        con.IAM_Site_Admin_Role__c = null;
                    else if(con.IAM_Site_Admin__c)
                        con.IAM_Site_Admin_Role__c = rowCells[6]; //site admin role
                        
                    con.ownerId = approverId;
                    con.IAM_Approved__c = System.Label.IAM_Label_N;
                    system.debug('start_import-------con '+con);    
                    if(rowCells.size() > 6){
                        //applications exist in template
                        Set <IAM_Contact_Provisioning__c> userAppsList = new Set <IAM_Contact_Provisioning__c> ();
                        isvalidApplication = true;
                        string apppp_string = '';
                        string apppp_stringNew = '';
                        for(integer j = 7; j < rowCells.size(); j++){
                            if (!headers[j].contains('(')){
                                if(rowCells[j] != null && rowCells[j] != '')
                                    apppp_string += isValidRole(headers[j], rowCells[j]) + ',';
                                apppp_stringNew += isValidAppRole(headers[j], rowCells[j]) ;
                                //is valid app 
                                if(!appRole.get(headers[j].trim()).contains(rowCells[j].trim())){
                                    isvalidApplication = false;
                                }
                            }else{
                                List <string> hdrs = headers[j].replace('(', '__').split('__');
                                System.debug('start_import-------hdrs[0] '+hdrs[0]);
                                if(!appRole.get(hdrs[0].trim()).contains(rowCells[j].trim())){
                                    isvalidApplication = false;
                                }
                                apppp_string += isValidRole(hdrs[0], rowCells[j]) + ',';
                                apppp_stringNew += isValidAppRole(hdrs[0], rowCells[j]) ;
                            }
                            
                            if(rowCells[j] != null && rowCells[j] != ''){
                                System.debug('rowCells[j]...begin.  '+ rowCells[j]); 
                                for(IAM_Application__c userApp :lstApplications ){
                                    String applicationName = ''; 
                                    IAM_Contact_Provisioning__c contactApp = new IAM_Contact_Provisioning__c();
                                    if (!headers[j].contains('(')){
                                        applicationName = headers[j];             
                                    }else{
                                        List < string > hdrs = headers[j].replace('(', '__').split('__'); 
                                        applicationName = hdrs[0];             
                                    }
                                    System.debug('applicationName....  '+ applicationName); 
                                    // fix - D-2824 - was getting to many SOQL error so replaced with mapAppId
                                    contactApp.recordtypeid = mapAppId.get(applicationName);
                                    if(userApp.IAM_Application_Name__c == applicationName){
                                        contactApp.IAM_Application_Name__c =  applicationName;
                                        //fixed - D-3142 - set Qsol_Expiration & IAM_swregExpire__c values if application is QSOL and Guidanz Mobile.                                       
                                        if(applicationName == 'QuickServe Online')
                                            contactApp.IAM_Qsolexpiration__c = mapApplications.get(applicationName);
                                        if(applicationName == 'Guidanz Mobile')
                                            contactApp.IAM_swregExpire__c = mapApplications.get(applicationName);   
                                        System.debug('mapApplications.get(applicationName)....  '+ mapApplications.get(applicationName));   
                                        contactApp.IAM_Role__c = rowCells[j];
                                        System.debug('contactApp.IAM_Role__c...begin.  '+ contactApp.IAM_Role__c);
                                        contactApp.IAM_Status__c = (con.IAM_Contact_Status__c == System.Label.IAM_Status_Pending) ? System.Label.IAM_Pending_Contact_Approval : con.IAM_Contact_Status__c;
                                        contactApp.IAM_Start_Date__c = Date.today();                        
                                        contactApp.IAM_Account_Application__c = userApp.id; //'a134C0000010Z7a';
                                        if(null != contactApp.IAM_Role__c && contactApp.IAM_Role__c.trim() != '')
                                            userAppsList.add(contactApp);
                                    }
                                }    
                            }
                            email_approw.put(con.Username__c, apppp_string);
                            email_approwNew.put(con.Username__c, apppp_stringNew);

                        }
                        
                        if(!userAppsList.isEmpty()){                           
                            mapContProvision.put(con.Username__c, userAppsList); 
                        }
                        system.debug('mapContProvision..........111-------'+mapContProvision);
                    }
                    
                    if(isvalidApplication){
                        lstAllContacts.add(con);
                    }else{
                        invalidContact.add(con);
                        isvalidApplication = true;
                    }
                    system.debug('mapContProvision..........222-------'+mapContProvision);
                }
                data = headerIs.replaceAll('\\n','').replaceAll('\\r','')+ ',Status,Reason';
                system.debug('start_import..........data-------'+data);
                system.debug('mapContProvision..........data-------'+mapContProvision);
                Database.SaveResult[] srList = Database.insert(lstAllContacts, false);       
                List<string> errorMessages = new List<string>();
                SuccessUpload = 0;
                failedUpload = 0;
                for (Database.SaveResult sr : srList ){
                    if (sr.isSuccess()){
                        SuccessUpload++;
                    }else{
                        failedUpload++;          
                    }
                }
                if(!invalidContact.isEmpty())
                    failedUpload += invalidContact.size();
                
                system.debug('Success-------'+SuccessUpload);
                system.debug('failed--------'+failedUpload);
                system.debug('lstAllContacts-------'+lstAllContacts.size());
                system.debug('AllErrorMessages-------'+errorMessages);
                system.debug('start_import..........srList-------'+srList);
                if(!srList.isEmpty()){
                    for (Integer i = 1; i < lstAllContacts.size() + 1; i++){
                        contact c = lstAllContacts[i - 1];
                        string msg = '';
                        system.debug('srList[i-1]. ' + srList[i - 1]);
                        if(!srList[i - 1].isSuccess()){
                            msg = srList[i - 1].getErrors()[0].getMessage();
                        }else{
                            if(!mapContProvision.isEmpty()){
                                //Fix - D-3153 - EDS and CST application can only be assigned along with QSOL.
                                Set<IAM_Contact_Provisioning__c> setContPro = mapContProvision.get(lstAllContacts[i - 1].Username__c);
                                Set<String> setApps = new Set<String>();
                                if(null != setContPro && !setContPro.isEmpty()){
                                    for(IAM_Contact_Provisioning__c conPro : setContPro){
                                        setApps.add(conPro.IAM_Application_Name__c);
                                    }
                                }
                                System.debug('setApps...... ' + setApps);
                                if(null != mapContProvision.get(lstAllContacts[i - 1].Username__c) && !mapContProvision.get(lstAllContacts[i - 1].Username__c).isEmpty()){
                                    for(IAM_Contact_Provisioning__c app: mapContProvision.get(lstAllContacts[i - 1].Username__c)){
                                        app.IAM_Contact__c = lstAllContacts[i - 1].id;
                                        System.debug('setApps...... ' + setApps);
                                        system.debug('app.IAM_Application_Name__c '+app.IAM_Application_Name__c);
                                        if (app.IAM_Role__c.trim() != null && app.IAM_Role__c.trim() != '' && !string.isBlank(app.IAM_Role__c) ){
                                            if(!setApps.isEmpty() && !setApps.contains('QuickServe Online') && setApps.contains('EDS') &&  setApps.contains('Cummins Service Training')) 
                                                msg = System.label.IAM_EDS_and_CST_no_QSOL_error;
                                            else if(!setApps.isEmpty() && !setApps.contains('QuickServe Online') && app.IAM_Application_Name__c == 'EDS')
                                                msg = System.label.IAM_EDS_no_QSOL_error;
                                            else if(!setApps.isEmpty() && !setApps.contains('QuickServe Online') && app.IAM_Application_Name__c == 'Cummins Service Training') 
                                                msg = System.label.IAM_CST_no_QSOL_error;
                                            else
                                                lstContProvision.add(app);
                                            System.debug('lstContProvision after processing...... ' + lstContProvision);    
                                        }
                                    }
                                }
                            }
                            // Fix - D-3148 - if newly created user is pending for approval display pending approval message in the csv file
                            if(c.IAM_Contact_Status__c == System.Label.IAM_Status_Pending && acc[0].RecordType.Name == System.Label.IAM_WWSPS &&  objUser[0].IAM_Final_Approver__c != System.Label.IAM_Label_Y)
                                msg = System.Label.IAM_Pending_Aproval_Message;
                        }
                        data += c.Firstname + ',' + c.LastName + ',' + c.Username__c + ',' + c.Email + ',' + c.Phone + ',' + c.IAM_Site_Admin__c + ',' + c.IAM_Site_Admin_Role__c + ',';
                        System.debug('data...... ' + data);
                        System.debug('email_approw email_approw ' + email_approw.get(c.Username__c));
                        System.debug('email_approwNew email_approwNew ' + email_approwNew.get(c.Username__c));
                        if(email_approw.keyset().size() > 0){                  
                            data += email_approw.get(c.Username__c).replaceAll('\\n','').replaceAll('\\r','');            
                        }
                        if(email_approwNew.keyset().size() > 0)
                            data += srList[i - 1].isSuccess() + ',' + msg.replace('&quot;','') +  email_approwNew.get(c.Username__c).replaceAll('\\n','').replaceAll('\\r','').replaceAll(',',';').replaceAll(';;',';').replaceAll(';;;',';').replaceAll(';;;;',';').replaceAll(';;;;;',';').replaceAll(';;;;;;',';').replaceAll(';;',';').removeEnd(';') + '\\n';
                        else
                            data += srList[i - 1].isSuccess() + ',' + msg.replace('&quot;','') + '\\n';
                        System.debug('email_approw................ data ' + data);
                    }
                }

                //invalid contacts
                if(!invalidContact.isEmpty()){
                    for(Integer i = 1; i < invalidContact.size() + 1; i++){
                        contact c = invalidContact[i - 1];              
                        string msg = 'invalid data : ';
                        data += c.Firstname + ',' + c.LastName + ',' + c.Username__c + ',' + c.Email + ',' + c.Phone + ',' + c.IAM_Site_Admin__c + ',' + c.IAM_Site_Admin_Role__c + ',';
                        System.debug('email_approw email_approw ' + email_approw);

                        if(email_approw.keyset().size() > 0){                  
                            data += email_approw.get(c.Username__c).replaceAll('\\n','').replaceAll('\\r','');
                        }
                        if(email_approwNew.keyset().size() > 0)
                            data += 'Failed ' + ',' + msg + email_approwNew.get(c.Username__c).replaceAll('\\n','').replaceAll('\\r','').replaceAll(',',';').replaceAll(';;',';').replaceAll(';;;',';').replaceAll(';;;;',';').replaceAll(';;;;;',';').replaceAll(';;;;;;',';').replaceAll(';;',';').removeEnd(';') + '\\n';
                        else
                            data += 'Failed ' + ',' + msg + '\\n';
                    }   
                }

                if(!lstContProvision.isEmpty()){
                    System.debug('lstContProvision...... ' + lstContProvision);
                    insert lstContProvision;
                }

                
                if(acc[0].RecordType.Name == System.Label.IAM_WWSPS && objUser[0].IAM_Final_Approver__c != System.Label.IAM_Label_Y) {
                    //send for approval process
                    //Fixed D-3148 if contact is pending for approval display message in orange color else display in green color
                    isPendingApproval = true;
                    for(Contact cont : lstAllContacts){
                        IAM_Approval_Submission.submitAndProcessApprovalRequest(cont, approverId);
                    }
                    System.debug('isPendingApproval 1111> ' + isPendingApproval);
                }

            }catch(exception ex){  
                System.debug('Exception line number '+ex.getLineNumber());
                System.debug('Exception is>>>>>>>> ' + ex.getMessage()); 
            }
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Total Number of Users Uploaded Successfully:' + SuccessUpload));       
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Total Number of Users Uploaded Failure: '+failedUpload));               
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Please refer the downloaded Status file'));
            DataDownload = true;
            System.debug('data >>>>>>>>>>>>> ' + data);  
            System.debug('isPendingApproval >>>>>>>>>>>>> ' + isPendingApproval);
            return null;
        }
    }


    //this is used to check wether the roles enterd in the CSV file are valid or not
    public string isValidRole(String appName, String role){    
        String app;
        if (appName.contains('(')) {
            app = appName.replace('(', '__').split('__')[0];

        } else {
            app = appName;
        }
        
        if (!appRole.get(app).contains(role.trim())) {
            if(app!=null && app!=''){
            return role + ' ( Invalid role )';
            }
            else{
            
                return '';
            }
        }

        return role;
        
    }
    
    //this is used to validate weather the entered role is belongs to same app or not (app name are column names in the csv import file
    public string isValidAppRole(String appName, String role){  
        String app;
        if (appName.contains('(')) {
            app = appName.replace('(', '__').split('__')[0];

        } else {
            app = appName;
        }
        
        if (!appRole.get(app).contains(role.trim())){
            if(app != null && app != ''){
                return role + ' ( Invalid role for Application: '+appName+' )';
            }
        }
        return '';
    }
    
    
}