public without sharing class IAM_SiteAdmin_Controller{
    //pagination attributes
    public ApexPages.StandardSetController pageCont{get; set;}
    public List<Integer> numOfPage {get;set;}
    Public Integer pageSize{get;set;} 
    public List<SelectOption> PaginationSizeOptions{get;set;}
    public boolean isDeniedRequestTableEmpty {get;set;}
    public boolean isPendingApprovalTableEmpty {get;set;}
    public String userSearchText{get;set;}
    public String pageMessage{get;set;}
    public boolean isFilterAppRole{get;set;}
    public boolean isUserSearchAppRole{get;set;}
    public string selectedContactId{get;set;}
    @TestVisible private List<Account> lstAccStatus = null;
    @TestVisible private boolean isDefaultAccType = false;
    @TestVisible private boolean isDefaultCompany = false;
    public Boolean isActiveInaciveUsers{get;set;}
    public integer isActiveUsersCount{get;set;}
    public integer isInactiveUsersCount{get;set;}
    public integer pendingApprovalsCount{get;set;}
    public integer deniedRequestCount{get;set;}
    public Boolean contactEmptyMessage{get;set;}
    public Boolean userContactTable{get;set;}
    static final string selectedUsers = 'get_selectedUsers';
    public list <Contact> lstConFiltApps{set;get;}
    public String selectedSortField{get;set;} 
    public String selectedSortOrder{get;set;}
    //public String sortByFirstName{get;set;}
    //public String sortByLastName{get;set;}
    //public String sortByUserName{get;set;}
    //public String sortByEmail{get;set;}
    public boolean approvalHisMessage {get;set;}
    public List <SelectOption> SiteadminRoles {set;get;}
    public List < SelectOption > CompaniesAcc {set;get;}
    //the associated page canbe viewed from inside SFDC so to distinguish the view this boolean is used
    public boolean openedInsfdc {get;set;}
    //This is to hold the selected account type
    public string accountType {get;set;}
    //new contact holding variable
    public Contact newCon{get;set;}
    public string strAccountId{get;set;}
    public string strContactId{get;set;}
    public string editRoleItemId{get;set;}
    //To hold the Accounts owned by the logged in user
    public List <Account> lstAccounts{get;set;}
    //To hold the logged in user 
    public List <user> objUser{get;set;}
    public Account objAccount{get;set;}
    public list <Contact> lstContact{set;get;}
    //Map to hold the Contact id and user active status
    public map <string, boolean> mapActiveImagesContactid{set;get;}
    public map <string, boolean> mapuserlockedContactid{set;get;}
    public List < SelectOption > Companies{set;get;}
    public List < SelectOption > Region{set;get;}
    public List < SelectOption > SortingRecords{set;get;}
    public List < SelectOption > AccType{set;get;}
    public Map < string, User > mapContactIdToUser{set;get;}
    public boolean isAccountActive{get;set;}
    public IAM_Application__c application{get;set;}
    Public App_Mapping__c app{get;set;}
    public List <ProcessInstanceStep > reg_lstuser {set;get;} //to store users who are regular users.
    public boolean showUploadPopup {get;set;}
    public Integer ActiveAccounts {get;set;}
    public Integer PendingAccounts {get;set;}
    public Integer InactiveAccounts {get;set;}
    public String selectedApp {get; set;}
    public String selectedRole {get; set;}
    public List <SelectOption> Applications{set;get;}
    public List <SelectOption> Roles{set;get;}
    //issue-448 fix
    public String prevSelectedApp {get; set;}
    public String prevSelectedRole {get; set;}
    //Section to display approval process history from image in the section.
    public boolean approvalHis {get;set;}
    //Properties Declaration
    transient public ApprovalList aSW {get;set;}
    @TestVisible private Id recordId;
    @TestVisible private Id retURLRecordId;
    @TestVisible private String ORG_LNK;
    public String rejectApproveReason {get;set;}
    public class ApprovalStepWrapper{
        public String workItemApproveOrRejectLink{get;set;}
        public String workItemReassignLink {get;set;}
        public List < ProcessInstanceHistory > listOfSteps {get;set;}
        public ApprovalStepWrapper() {
            listOfSteps = new List < ProcessInstanceHistory > ();
        }
    }
    public class ApprovalList{
        public List < ApprovalStepWrapper > approvals {get;set;}
        public String recallApprovalProcessLink {get;set;}
        public Boolean isSubmitForApproval {get;set;}
        public Id recId {get;set;}
        public ApprovalList() {
            approvals = new List < ApprovalStepWrapper > ();
            isSubmitForApproval = true;
        }
    }
    //end of approval history 
    
    /*Approvals for in pending approval tab Site admin Contact begins need to work this function 
     *should invoke on when approve on pending approval screen is clicked.
    */
    public contact cn{get;set;}
    
    public boolean isUserNameExist{get;set;}
    public List <ProcessInstanceWorkItem> lstuser {set;get;}
    public List <ProcessInstanceWorkItem> lstPendingApproval {set;get;}
    public map <id,ApprovalData> mapApprovalData {get;set;}
    public map <id, ProcessInstanceWorkItem> conprocess {get;set;}
    public Account seleAccountForUpdate{get;set;}
    list < String > ContactIdsToUpdate = new list < String > ();
    public string strconAppid {get;set;}       
    @TestVisible private  list <Contact> activeContactsList;
    @TestVisible private list <Contact> inActiveContactsList;
    public List < SelectOption > accountApplications {set; get;}
    public String accountSelectedApp {get; set;}
    @TestVisible private List<IAM_Application__c> lstApplicationNames;
    @TestVisible private Map<String, List<String>> controllingFieldValues;
    @TestVisible private List<String> setAppRoles;
    @TestVisible private string selectedRec;
    
    
    //Radio options so switch between active and inacive users list
    public List < SelectOption > getItems() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption(System.Label.IAM_Status_Active, System.Label.IAM_Status_Active));
        options.add(new SelectOption(System.Label.IAM_Status_Inactive, System.Label.IAM_Status_Inactive));
        return options;
    }
    public void getSortingRecords() {
        System.debug('getSortingRecords ....');
        SortingRecords = new list < SelectOption > ();
        SortingRecords.add(new SelectOption('Sort By', 'Sort By'));
        SortingRecords.add(new SelectOption('Ascending', 'Ascending'));
        SortingRecords.add(new SelectOption('Descending', 'Descending'));
    }
    
    //This method populate account type based on type of account
    public void getAccType(){
        
        AccType = new list < SelectOption > ();
        accountType = null;
        Map<String,String> mapAccountType = new  Map<String,String>();
        System.debug('mapAccountType....111. '+mapAccountType);
        System.debug('lstAccounts....111. '+lstAccounts);
        for (Account acc: lstAccounts){
            String accId = acc.id;
            if(!objUser.isEmpty() && accId != null){
                String iamAccount = (null == objUser[0].IAM_Account__c) ? '' : objUser[0].IAM_Account__c;
                System.debug('getAccType++++User account id ' + objUser[0].IAM_Account__c);
                System.debug('lstAccounts...regionIs'+regionIs);
                System.debug('getAccType++++ accId ' + accId);
                if(!isDefaultAccType && accId.contains(iamAccount)){
                    accountType = acc.type;
                    isDefaultAccType = true;
                }
            }   
            if(null != acc.type && (null != acc.IAM_WWSPS_Regions__c && acc.IAM_WWSPS_Regions__c.equalsIgnoreCase(regionIs)) && !mapAccountType.containsKey(acc.type)){
                mapAccountType.put(acc.type, acc.type);
            }
        }
        System.debug('getAccType+ before ...  ALL+++accountType ' + accountType);
        System.debug('getAccType+ before ...  isAccountType  ' + isDefaultAccType);
        System.debug('getAccType+ before ...  mapAccountType.size()  ' + mapAccountType.size());
        
        for(String key : mapAccountType.keySet()){
            if(accountType == null)
                accountType = mapAccountType.get(key);
            AccType.add(new SelectOption(key, mapAccountType.get(key)));
        }  
        
        System.debug('mapAccountType...222.. '+mapAccountType);
        System.debug('getAccType++++accountType ' + accountType);
        getCompanies();
       
    }   

   
  //Items for Account Type readio button
    public List<SelectOption> getaccTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Company','Company'));
        options.add(new SelectOption('Individual','Individual')); 
        return options;
    }
    //Constructor for the class has started 
    public IAM_SiteAdmin_Controller(){
        lstContact = new List<Contact>();
        isActiveInaciveUsers = true;
        isDeniedRequestTableEmpty = true;
        numOfPage = new List<Integer>();
        isUserSearchAppRole = false;
        isDefaultAccType = false;
        isDefaultCompany = false;
        isFilterAppRole = false;
        isActiveUsersCount = 0;
        isInactiveUsersCount = 0;
        pendingApprovalsCount = 0;
        deniedRequestCount = 0;
        contactEmptyMessage = false;
        userContactTable = false;
        isPendingApprovalTableEmpty = true;
        openedInsfdc = (Network.getNetworkId() == null) ? true : false;
        isUserNameExist = false;
        showUploadPopup = false;
        //initialize counts to Zero
        ActiveAccounts = 0;
        PendingAccounts = 0;
        InactiveAccounts = 0;
        //issue-448 fix
        prevSelectedApp = null;
        prevSelectedRole = null;
        //get the appid from Url parameters of page
        String currentRecordId = ApexPages.CurrentPage().getparameters().get('appid');
        //Get the aplication based on th appid passed in page url
        if(currentRecordId == null || currentRecordId == ''){
           
               //if appid is null load DEFAULT application
    
            app = [select AppId__c, Name, Internal_Employee_link__c, Registration__c, internal_Employee_Redirection__c, Registration_Link__c, Back_page__c, contact_email__c, Footer_text__c from App_Mapping__c where name = 'Online Login' limit 1]; // id ='a164C000000L1VE'];
        }else if(currentRecordId != null && currentRecordId!=''){
        //if appid is not null load respective application
            app = [select AppId__c, Name,
                 Back_page__c, contact_email__c, Footer_text__c from App_Mapping__c where id =: currentRecordId

            ];
        }
 
        isAccountActive = true;
        //Fetch All the Accounts and Accociated contats
         fetchData();
        //populate Account Region 
        getRegion();
        //populate Account types
        getAccType();
        //Populate all companies 
        getUserRoles();
        getSortingRecords();
        getPaginationSizeOptions();
        getEditAccount();
        setPendingApprovalCount();
        setDeniedRequestCount();
    }
    //Constructor has ended

    public List<SelectOption> getUserRoles(){
        SiteadminRoles = new list < SelectOption > ();           
        Schema.DescribeFieldResult fieldResult = contact.IAM_Site_Admin_Role__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple)  {           
            SiteadminRoles.add(new SelectOption(pickListVal.getLabel(), pickListVal.getValue()));
        }     
        return SiteadminRoles;
               
    }
    
    //This method is used to get the approval list data 
    public ApprovalList generateData(){
        ApprovalList approvalResultForObject = new ApprovalList();
        List < ApprovalStepWrapper > lstASW = new List < ApprovalStepWrapper > ();
        String recallApprovalProcessLink;
        Boolean isSubmitForApproval = true;
        for (ProcessInstance pI: getProcessHistory(recordId).values()) {
            Set <Id> processNodeId = new Set <Id> ();

            for (ProcessInstanceHistory sWI: pI.StepsAndWorkitems) {
                if (processNodeId.isEmpty()){
                    processNodeId.add(sWI.ProcessNodeId);
                } else if (!processNodeId.isEmpty() && processNodeId.contains(sWI.ProcessNodeId) != NULL)
                    processNodeId.add(sWI.ProcessNodeId);
            }

            for (Id pNId: processNodeId) {
                ApprovalStepWrapper aSWr = new ApprovalStepWrapper();
                for (ProcessInstanceHistory sWI: pI.StepsAndWorkitems) {
                    if (sWI.processNodeId == pNID) {
                        aSWr.listOfSteps.add(sWI);
                    }
                    if (sWI.StepStatus == System.Label.IAM_Status_Pending) {
                        aSWr.workItemApproveOrRejectLink = ORG_LNK + '/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + sWI.Id;
                        aSWr.workItemReassignLink = ORG_LNK + '/' + sWI.Id + '/e?et=REASSIGN&retURL=/' + retURLRecordId;
                        recallApprovalProcessLink = ORG_LNK + '/' + sWI.Id + '/e?et=REMOVE&retURL=/' + retURLRecordId;
                        isSubmitForApproval = false;
                    }

                }
                lstASW.add(aSWr);
            }
        }
        approvalResultForObject.approvals = lstASW;
        approvalResultForObject.recId = recordId;
        approvalResultForObject.isSubmitForApproval = isSubmitForApproval;
        approvalResultForObject.recallApprovalProcessLink = recallApprovalProcessLink;
        System.debug('Printing return object' + approvalResultForObject);
        return approvalResultForObject;
    }
    
    //This method is used to get approval hostory data based on object id
    @TestVisible private Map < Id, ProcessInstance > getProcessHistory(Id objectId) {
        return new Map < Id, ProcessInstance > ([SELECT Id, (SELECT ID, ProcessNodeId,
                StepStatus, Comments, TargetObjectId, ActorId, CreatedById, IsDeleted, IsPending, OriginalActorId, ProcessInstanceId, RemindersSent, CreatedDate, Actor.Name,
                OriginalActor.Name, ProcessNode.Name FROM StepsAndWorkitems order by CreatedDate DESC)
            FROM ProcessInstance where TargetObjectId =: objectId order by CreatedDate DESC
        ]);
    }
    

    
    //this method is used to display the upload user popup
    public void show_upload_popup() {
        showUploadPopup = true;
    }

    public void hide_upload_popup() {
        showUploadPopup = false;
    }
    
    //This is to hold the selected region
    public string regionIs {get;set;}
    
    public void getRegion() {
        System.debug('getRegion++++lstAccounts++' +lstAccounts);
        System.debug('getRegion++++objUser++' +objUser);
        System.debug('getRegion++++UserInfo ' + UserInfo.getUserId());
        Region = new list < SelectOption > ();
        String defaultReg = '';
        
        

        set<String> RegionsAre = new set<String>();
        //add region from each account to above set (to stop duplicactes)
        for (Account acc: lstAccounts){
             String accId = acc.id;
             if(!objUser.isEmpty() && accId != null){
                String iamAccount = (null != objUser[0].IAM_Account__c) ? objUser[0].IAM_Account__c : '';
                System.debug('getRegion++++User account id ' + objUser[0].IAM_Account__c);
                System.debug('getRegion++++ accId ' + accId);
                if(accId.contains(iamAccount)){
                    defaultReg = acc.IAM_WWSPS_Regions__c;
                    System.debug('defaultReg-defaultReg' +defaultReg );
                    regionIs = defaultReg;
                }   
            }
            if(null != acc.IAM_WWSPS_Regions__c)
                RegionsAre.add(acc.IAM_WWSPS_Regions__c);
           
        }
        
        list<String> RegionsList = new list<String>();
        RegionsList.addAll(RegionsAre);
        
        if(!RegionsList.isEmpty() && regionIs == null)
            regionIs = RegionsList[0];
            
        System.debug('regionIs regionIs' +regionIs );
        System.debug('RegionsList++++RegionsList++' +RegionsList);  
        //for each region create a select option
        for(String eachRegion :RegionsList ){
            Region.add(new SelectOption(eachRegion , eachRegion ));
        }
        
        //return options;
    }
  
    //This is used to populate the accounts basesd on regions and account types
    public void getCompanies(){
        strAccountId = null;
        System.debug('getRegionBasedAccounts...lstAccounts. ' + lstAccounts);
        lstAccStatus = new List<Account>();
        
        Companies = new list < SelectOption > ();
        System.debug('getCompanies...regionIs. ' + regionIs);
        System.debug('getCompanies...accountType. ' + accountType);
        System.debug('getCompanies...isDefaultCompany. ' + isDefaultCompany);
        
        
        for (Account acc: lstAccounts){
            if ((null != acc.IAM_WWSPS_Regions__c && acc.IAM_WWSPS_Regions__c.equalsIgnoreCase(regionIs)) && (null != acc.Type && acc.Type.equalsIgnoreCase(accountType)))
               lstAccStatus.add(acc);
        }
        //lstAccStatus.sort();
        System.debug('getCompanies ..lstAccStatus..' + lstAccStatus);
        
        for(Account acc : lstAccStatus){
            String accId = acc.id;
            if(!objUser.isEmpty() && accId != null){
                String iamAccount = (null != objUser[0].IAM_Account__c) ? objUser[0].IAM_Account__c : '';
                if(!isDefaultCompany && accId.contains(iamAccount)){
                    strAccountId = accId;
                    isDefaultCompany = true;
                }
            }   
            //Companies.add(new SelectOption(acc.Id, acc.Name));
            //Added location code for the defect D-3128
            Companies.add(new SelectOption(acc.Id, acc.Name+' ('+acc.Location__c+')'));    
        }
        
        Companies = sortSelectOptions(Companies);
        
        if(!lstAccStatus.isEmpty() && strAccountId == null)
            strAccountId = lstAccStatus[0].id;
            
        getStatisticsTableValue(lstAccStatus);
        System.debug('lstAccounts.size()>>> ' + lstAccounts.size());
        System.debug('getCompanies...strAccountId. ' + strAccountId);
        
    }
    
    //This is used to populate the accounts basesd on regions and account types
    public void getStatisticsTableValue(List<Account> lstAccounts){
        System.debug('getStatisticsTableValue...lstAccounts. ' + lstAccounts);
        ActiveAccounts = 0;
        PendingAccounts = 0;
        InactiveAccounts = 0;
        
        for(Account acc: lstAccounts){
            if(null != acc.CMI_Account_Status__c){
                if(acc.CMI_Account_Status__c.equalsIgnoreCase(System.Label.IAM_Status_Active)) 
                    ActiveAccounts++;
                else if(acc.CMI_Account_Status__c.equalsIgnoreCase(System.Label.IAM_Status_Pending)) 
                    PendingAccounts++;
                else if(acc.CMI_Account_Status__c.equalsIgnoreCase(System.Label.IAM_Status_Inactive))
                    InactiveAccounts++;
            }
        } 
    }
    
    //empty method just used to rerender the page
    public void donothing() {}
    
    //This method get the application based on the contact provisioning record
    public void getApplications(){
        //isFilterAppRole = false;
        selectedApp = null;
        System.debug('getApplications...lstContact...'+lstContact);
        System.debug('getApplications...lstContact.size..'+lstContact.size());
        //System.debug('getApplications...Contact_Provisionings__r...'+lstContact[0].Contact_Provisionings__r);
        Applications = new list <SelectOption> ();
        Set<String> setApp = new Set<String>();
        List<String> sortApp = new List<String>();
        Applications.add(new SelectOption('', 'Filter By'));
        for(Contact con : lstContact){
            for(IAM_Contact_Provisioning__c icp : con.Contact_Provisionings__r){
                setApp.add(icp.IAM_Application_Name__c);
            }
            
        }
        
        //sorting Applications
        sortApp.addAll(setApp);
        sortApp.sort();
        for(String strApp : sortApp){
            Applications.add(new SelectOption(strApp, strApp));  
        }
        
    }
    
    //This method will get the role based on the selected application
    public void getRoles(){
        System.debug('getRoles...lstContact...'+lstContact);
        //System.debug('getRoles...Contact_Provisionings__r...'+lstContact[0].Contact_Provisionings__r);
        selectedRole = null;
        Roles = new list <SelectOption> ();
        Set<String> setRole = new Set<String>();
        Roles.add(new SelectOption('', 'Filter By'));
        if(selectedApp != null){
            for(Contact con : lstContact){
                for(IAM_Contact_Provisioning__c icp : con.Contact_Provisionings__r){
                    if(icp.IAM_Application_Name__c == selectedApp){
                        List<String> lstDelmitedStr = icp.IAM_Role__c.split(';');
                        setRole.addAll(lstDelmitedStr);
                    }
                }
            }
        }
        for(String strRole : setRole){
            Roles.add(new SelectOption(strRole, strRole));  
        }
    }
    
    //This method get the search application when user pick the application from application picklist from user table.
    public void getFilterApps(){
        isFilterAppRole = false;
        isUserSearchAppRole = false;
        //issue-448 fix
        prevSelectedApp = selectedApp;
        System.debug('getFilterApps...selectedApp...'+selectedApp);
        lstConFiltApps = new List<Contact>();
        if(selectedApp == null){
            System.debug('getFilterApps...else selectedApp...'+selectedApp);
            lstConFiltApps.addAll(lstContact);  
        }else if(selectedApp != null){
            isFilterAppRole = true;
            lstConFiltApps = getfilterAppsCont(lstContact,selectedApp);   
        }
        initPagination(lstConFiltApps);
        getRoles();
        System.debug('getFilterApps...lstConFiltApps...'+lstConFiltApps);
        
    }
    
    //This method get the search role when user click pick the role in role picklist from user table
    public void getFilterRole(){
        //isFilterAppRole = false;
        System.debug('getFilterRole...selectedApp...'+selectedApp);
        //issue-448 fix
        prevSelectedRole = selectedRole;
        lstConFiltApps = new List<Contact>();
        if(selectedApp != null && selectedRole != null){
            //isFilterAppRole = true;
            for(Contact con : lstContact){
                String strRoles = '';
                for(IAM_Contact_Provisioning__c icp : con.Contact_Provisionings__r){
                    if(icp.IAM_Application_Name__c == selectedApp){
                        strRoles = strRoles + ';' + icp.IAM_Role__c;
                    }   
                }
                System.debug('getFilterRole...strRoles...'+strRoles);
                if(strRoles.contains(selectedRole)){
                    lstConFiltApps.add(con);
                }
            }
            
        }else if(selectedApp != null && selectedRole == null){
            lstConFiltApps = getfilterAppsCont(lstContact,selectedApp);
        }
        //issue-448 fix
        if(lstConFiltApps.isEmpty())
            lstConFiltApps = getfilterAppsCont(lstContact,selectedApp);
        System.debug('getFilterApps...lstConFiltApps...'+lstConFiltApps);
        initPagination(lstConFiltApps);
    }
    
    //This method get the active or inactive user based on radio button on the page. by default active users display when page get loaded.
    public void getActiveInactiveUsers(){
        isFilterAppRole = false;
        lstContact = new List<Contact>();
        list <Contact> ltChildContacts = new List<contact>();
        system.debug('strAccountId***strAccountId***'+strAccountId);
        system.debug('lstAccounts***lstAccounts***'+lstAccounts.size());
        system.debug('getActiveInactiveUsers....lstAccStatus*******'+lstAccStatus.size());
        ltChildContacts = getContactList(null,strAccountId);
        system.debug('strAccountId***strAccountId***'+strAccountId);
        System.debug('getActiveInactiveUsers...ltChildContacts >> ' + ltChildContacts);   
        System.debug('getActiveInactiveUsers...ltChildContacts size >> ' + ltChildContacts.size());                 
        setContactInfo(ltChildContacts);
        System.debug('getActiveInactiveUsers inActiveContactsList****>>>>' + inActiveContactsList);
        System.debug('getActiveInactiveUsers inActiveContactsList size****>>>>' + inActiveContactsList.size());
        System.debug('getActiveInactiveUsers activeContactsList***>>>>' + activeContactsList);
        System.debug('getActiveInactiveUsers activeContactsList size***>>>>' + activeContactsList.size());
        isActiveUsersCount = activeContactsList.size();
        isInactiveUsersCount = inActiveContactsList.size();
        System.debug('isActiveUsersCount ****>>>>' + isActiveUsersCount);
        System.debug('isInactiveUsersCount ***>>>>' + isInactiveUsersCount);
        System.debug('isActiveInaciveUsers ***>>>>' + isActiveInaciveUsers);

        if(isActiveInaciveUsers){
            contactEmptyMessage = false;
            userContactTable = false;
            lstContact.addAll(activeContactsList);
            if(isActiveUsersCount == 0){
                contactEmptyMessage = true;
            }else{
                userContactTable = true;
            }         
        }else{
            contactEmptyMessage = false;
            userContactTable = false;
            lstContact.addAll(inActiveContactsList);
            
            if(isInactiveUsersCount == 0){
                contactEmptyMessage = true;
            }else{
                userContactTable = true;
            }   
        }
        System.debug('getActiveInactiveUsers....lstContact>>****>>>>' + lstContact); 
        System.debug('getActiveInactiveUsers....lstContact size>>****>>>>' + lstContact.size());
        initPagination(lstContact);
        getApplications();
        getRoles();
    } 
    
    //This function will do the search for user
    public void getUserSearch(){
        try{
            isUserSearchAppRole = false;
            isFilterAppRole = false;
            userSearchText = userSearchText.trim();
            System.debug('getUserSearch....userSearchText..' + userSearchText);
            System.debug('getUserSearch....lstAccStatus..' + lstAccStatus);
            System.debug('getUserSearch....strAccountId..' + strAccountId);
            lstContact = getContactList(null,strAccountId);
            setContactInfo(lstContact);
            lstContact = new List<Contact>();
            if(isActiveInaciveUsers){
                lstContact.addAll(activeContactsList);
                System.debug('getUserSearch..11..activeContactsList..' + activeContactsList);
            }else{
                lstContact.addAll(inActiveContactsList);
                System.debug('getUserSearch..11..inActiveContactsList..' + inActiveContactsList);
            }
            System.debug('getUserSearch..11..lstContact..' + lstContact);
            if(userSearchText != null){
                isFilterAppRole = true;
                isUserSearchAppRole = true;
                lstConFiltApps = new List<Contact>();
                for(Contact con : lstContact){
                    // fix - D-2967 - replace first name and last name to Name field 
                    if((null != con.Name && con.Name.containsIgnoreCase(userSearchText)) || (null != con.Email && con.Email.containsIgnoreCase(userSearchText)) || (null != con.Phone && con.Phone.containsIgnoreCase(userSearchText)) || (null != con.Username__c && con.Username__c.containsIgnoreCase(userSearchText))){
                        System.debug('getUserSearch..11..con..' + con);
                        lstConFiltApps.add(con);
                    }
                }
                initPagination(lstConFiltApps);
            }   
            
            System.debug('getUserSearch....lstConFiltApps..' + lstConFiltApps);
            System.debug('getUserSearch....isActiveInaciveUsers..' + isActiveInaciveUsers);
            System.debug('....lstConFiltApps Size'+lstConFiltApps.size());
            //Amarnath Mishra added code 18-02-2019
            
            if(lstConFiltApps.isEmpty()){
                contactEmptyMessage = true;
                userContactTable = false;
                System.debug('....no any users found');
                }
            else{
                 contactEmptyMessage = false;
                 userContactTable = true;
             }   
             // Amarnath Mishra code changes ends   
            getApplications();
            getRoles();
        }catch(Exception ex){
            handelException('getUserSearch', ex);
        } 
        
    }
    
    public List<Contact> getContactList(List<Account> lstAcc, String accId){
        system.debug('strAccountId***lstAcc***'+lstAcc);
        system.debug('strAccountId***accId***'+accId);
        if(null == lstAcc)
            return  [Select IAM_Internal__c, id, IAM_Contact_Status__c,
                 IAM_Approved__c, Name, Email, AccountId, Account.Name, Phone, LastName, FirstName, IAM_Site_Admin__c,Username__c,
                 (select id,IAM_Application_Name__c,IAM_Role__c from Contact_Provisionings__r where IAM_Status__c =: System.Label.IAM_Status_Active) from Contact  
                 where AccountId =: accId AND (IAM_Contact_Status__c =: System.Label.IAM_Status_Active OR IAM_Contact_Status__c =: System.Label.IAM_Status_Inactive) ORDER BY LastModifiedDate DESC];   
        else 
            return  [Select IAM_Internal__c, id, IAM_Contact_Status__c,
                 IAM_Approved__c, Name, Email, AccountId, Account.Name, Phone, LastName, FirstName, IAM_Site_Admin__c,Username__c, 
                 (select id,IAM_Application_Name__c,IAM_Role__c from Contact_Provisionings__r where IAM_Status__c =: System.Label.IAM_Status_Active) from Contact 
                 where AccountId In: lstAcc AND (IAM_Contact_Status__c =: System.Label.IAM_Status_Active OR IAM_Contact_Status__c =: System.Label.IAM_Status_Inactive) ORDER BY LastModifiedDate DESC];          
               
    }
    
    // This method will sort contact based on accending/decending filter.
    public List<Contact> getOrderedContactList(list <Contact> lstCont, String fieldName, String ordBY){
        //SonarQube fix
        String strOrderBy = '';
        if(ordBY == 'Ascending')
            strOrderBy = 'ASC';
        else if(ordBY == 'Descending')
            strOrderBy = 'DESC';
        else 
            strOrderBy = 'ASC';
        String activeApp = System.Label.IAM_Status_Active;   
        String query = 'Select IAM_Internal__c, id, IAM_Applications__c, IAM_Approved__c, Name, Email, AccountId, Account.Name,Account.IAM_Primary_Market_Segment__c, Phone, LastName, FirstName, CMI_TableauId__c, IAM_Site_Admin__c,(select id,IAM_Application_Name__c,IAM_Role__c from Contact_Provisionings__r where IAM_Status__c =\'' +String.escapeSingleQuotes(activeApp)+'\' ), Username__c, Account.IAM_WWSPS_Regions__c from Contact where IAM_Send_for_Approval__c != true and Id IN: lstCont order by ' +fieldName + ' ' + strOrderBy;
        System.debug('Dynamic query ... ' + query);          
        return Database.query(query);
               
    }
    
    public void getRecordsbySelectedOrder(){
        System.debug('selectedSortField .....  ' +selectedSortField);
        System.debug('selectedSortOrder .....  ' +selectedSortOrder);
        if(isActiveInaciveUsers){
            lstcontact =  getOrderedContactList(activeContactsList, selectedSortField, selectedSortOrder);
            initPagination(lstcontact);         
        }else{
            lstcontact =  getOrderedContactList(inActiveContactsList, selectedSortField, selectedSortOrder);
            initPagination(lstcontact); 
        }   
    }
   
    //intialize pagination
    public void initPagination(List<Contact> lstConts){
        system.debug('initPagination..lstConts.' + lstConts.size());
        pageCont = null;
        pageCont = new ApexPages.StandardSetController(lstConts);
        if(pageCont != null){
            getNumberOfPages();    
        }
        system.debug('initPagination..pageCont... ' + pageCont.getResultSize());
    }
    
   
    public void previous(){
        system.debug('previous...' + pageCont);
        pageCont.previous(); 
        
    }  
    public void next(){
        system.debug('next...' + pageCont.getRecords());
        pageCont.next();  
        system.debug('next..11.' + pageCont.getRecords());
        
        
    }  
    
    public List<Contact> getPageRecords(){
        return (List<Contact>)pageCont.getRecords();
    }
    
    public void getPageNumberRecord(){
        String selectedPageNumber = Apexpages.currentpage().getParameters().get('get_pageNumber');
        system.debug('getPageNumberRecord...selectedPageNumber..  ' + selectedPageNumber);
        pageCont.setpageNumber(Integer.valueof(selectedPageNumber.trim()));
        
    }
    
     //Changes the size of pagination
    public void refreshPageSize(){
         pageCont.setPageSize(pageSize);
         getNumberOfPages();
         
    }
    
    public void getPaginationSizeOptions(){
        //fix of issue#48 - increase default page size from 5 to 20 and also increased option page size from 5 to 20
        pageSize = 20;
        PaginationSizeOptions = new List<SelectOption>();
        PaginationSizeOptions.add(new SelectOption('20','20'));
        PaginationSizeOptions.add(new SelectOption('25','25'));
        PaginationSizeOptions.add(new SelectOption('50','50'));
        PaginationSizeOptions.add(new SelectOption('100','100'));
        
    }
    
    public void getNumberOfPages(){
        numOfPage = new List<Integer>();
        System.debug('pageSize.... '+pageSize);
        pageCont.setPageSize(pageSize);
        System.debug('pageCont.getResultSize().... '+pageCont.getResultSize());
        Decimal totalCount = pageCont.getResultSize();
        Decimal count = (totalCount/pageSize).round(System.RoundingMode.UP);
        System.debug('count.... '+count);
        for(integer i = 1; i <= count; i++)
            numOfPage.add(i);
    }  
    
    public List<Contact> getfilterAppsCont(List<Contact> lstContact, String selectedApp){
        List<Contact> lstConFilterApps = new List<Contact>();
        for(Contact con : lstContact){
            String application = '';
            for(IAM_Contact_Provisioning__c icp : con.Contact_Provisionings__r){
                application = application + ',' + icp.IAM_Application_Name__c;
            }
            System.debug('getFilterApps...application...'+application);
            if(application.contains(selectedApp)){
                lstConFilterApps.add(con);
            }
        
        }
        return lstConFilterApps;
    }  
    
    /* this function is to display the Accounts information like region,type and account name in the drop down of the site admin page. Account information is 
    fetched based on logged in user`s Account number, service provider id, owner id and contact`s Account.
    Lgged in user have account number,sp code and contact, default selected Account information is fetched based on logged in user contact`s Account.
    This method also traverse up to seven level of child records when fetch Account information. also fetch contacts information associated to the Accounts.
    */
    public void fetchData(){
        try{
            newCon = new Contact();
            lstAccounts = new List<Account>();
            //Get Current User Info.Set Username 
            objUser = [select id, ContactId, IAM_Account__c, IAM_SP_Code__c, IAM_Account_Number__c, contact.AccountId, contact.IAM_Site_Admin_Role__c, IAM_Final_Approver__c, IAM_Identity_Approver__c from user where id =: Userinfo.getUserid()];
            System.debug('OBJUSER========>>' + objUser[0]);
            //this is to get the user owner accounts whose tableu id is null means he will be the owner of those accounts.
            //this is to get the Parent account id
            
            if (objUser[0].IAM_Account_Number__c != null){
                List <Account> Accnt = [Select id from Account where IAM_Service_Provider_Code__c =: objUser[0].IAM_Account_Number__c];
                System.debug('Size of the parent accout list is ' + Accnt.size());
                system.debug('entering display query');
                if(!Accnt.isEmpty()){
                    //Query to display list of accounts added by karthik
                    lstAccounts = [Select IAM_Service_Provider_Code__c,IAM_Primary_Market_Segment__c,id, IAM_WWSPS_Regions__c, Name, Type, CMI_Account_Status__c, Location__c, CSS_DistributorCode__c, ParentId, IAM_ECN__c from Account where ParentId =: Accnt[0].Id OR ownerid =: objUser[0].id OR IAM_Service_Provider_Code__c =: objUser[0].IAM_SP_Code__c];
                    system.debug('Value to be compared is ' + objUser[0].IAM_Account_Number__c == null || objUser[0].IAM_Account_Number__c == '');
                }
            }else{
                lstAccounts = [Select IAM_Service_Provider_Code__c,IAM_Primary_Market_Segment__c,IAM_WWSPS_Regions__c,
                              id, Name, CMI_Account_Status__c, Location__c, CSS_DistributorCode__c,Type, ParentId,IAM_ECN__c from Account where ownerid =: objUser[0].id ];
                
            }
            
            
            if(!objUser.isEmpty() && null != objUser[0].contact){
                Account parentAcc = [Select IAM_Service_Provider_Code__c, id, Name, CSS_DistributorCode__c, IAM_Primary_Market_Segment__c, CMI_Account_Status__c, Location__c, ParentId, IAM_WWSPS_Regions__c,type
                                     from Account where id=:objUser[0].contact.AccountId];
                lstAccounts.add(parentAcc);                      
            }
            System.debug('List of account before adding childs' + lstaccounts);
            //get the childs account upto 7 level
            getChildsAccounts();
            System.debug('List of account after adding childs' + lstaccounts);
            Set <Account> uniqueAcc = new Set <Account> ();
            uniqueAcc.addAll(lstAccounts);
            lstAccounts = new list <Account> ();
            lstAccounts.addAll(uniqueAcc);
            //Amar added to sort the companies name 10/01/2019
            lstAccounts.sort();
            System.debug('lstAccounts============after removing dupicates======>>' + lstAccounts);
            System.debug('lstAccounts===========after removing dupicates=======>>Size' + lstAccounts.size());
            list <Contact> ltChildContacts = getContactList(lstAccounts,null);
            System.debug('ltChildContacts>>' + ltChildContacts);
            setContactInfo(ltChildContacts);
        }catch(Exception ex){
            pageMessage = System.Label.IAM_Something_Went_Wrong_Error;  
            handelException('fetchData', ex);
        }
    }

    @TestVisible private void getChildsAccounts(){
    
        Map <id, Account> Acclist_2 = null;
        Map <id, Account> Acclist_3 = null;
        Map <id, Account> Acclist_4 = null;
        Map <id, Account> Acclist_5 = null;
        Map <id, Account> Acclist_6 = null;
        Map <id, Account> Acclist_7 = null;
        Map <id, Account> Acclist_8 = null;

        Set<String> accIds = new Set <String> ();
        for (Account acc: lstAccounts){
            accIds.add(acc.id);
        }

        map <id, Account> Acclist_1 = new map <id, Account> ([Select IAM_Service_Provider_Code__c,CSS_DistributorCode__c,IAM_Primary_Market_Segment__c, IAM_WWSPS_Regions__c,
        id, Name, CMI_Account_Status__c, Location__c, ParentId,type from Account where ParentId in: accIds
        ]);

        if (!Acclist_1.keyset().isEmpty()){
            lstAccounts.addAll(Acclist_1.values());
            Acclist_2 = new map <id, Account> ([Select IAM_Service_Provider_Code__c,IAM_Primary_Market_Segment__c, id, Name, CMI_Account_Status__c, Location__c, ParentId, IAM_WWSPS_Regions__c,CSS_DistributorCode__c,type from Account where ParentId in: Acclist_1.keyset()]);
            
            if (!Acclist_2.keyset().isEmpty()){
                lstAccounts.addAll(Acclist_2.values());
                Acclist_3 = new map <id, Account> ([Select IAM_Service_Provider_Code__c,CSS_DistributorCode__c,IAM_Primary_Market_Segment__c, id, Name, CMI_Account_Status__c, Location__c, ParentId, IAM_WWSPS_Regions__c,type from Account where ParentId in: Acclist_2.keyset()]);

                if (!Acclist_3.keyset().isEmpty()){
                    lstAccounts.addAll(Acclist_3.values());
                    Acclist_4 = new map <id, Account> ([Select IAM_Service_Provider_Code__c,CSS_DistributorCode__c,IAM_Primary_Market_Segment__c, id, Name, CMI_Account_Status__c, Location__c, ParentId, IAM_WWSPS_Regions__c,type
                    from Account where ParentId in: Acclist_3.keyset()
                    ]);

                    if (!Acclist_4.keyset().isEmpty()){
                        lstAccounts.addAll(Acclist_4.values());
                        Acclist_5 = new map <id, Account> ([Select IAM_Service_Provider_Code__c,CSS_DistributorCode__c,IAM_Primary_Market_Segment__c, id, Name, CMI_Account_Status__c, Location__c, ParentId, IAM_WWSPS_Regions__c,type
                        from Account where ParentId in: Acclist_4.keyset()
                        ]);
                        
                        if (!Acclist_5.keyset().isEmpty()){
                            lstAccounts.addAll(Acclist_5.values());
                            Acclist_6 = new map <id, Account> ([Select IAM_Service_Provider_Code__c,CSS_DistributorCode__c,IAM_Primary_Market_Segment__c, id, Name, CMI_Account_Status__c, Location__c, ParentId, IAM_WWSPS_Regions__c,type
                            from Account where ParentId in: Acclist_5.keyset()
                            ]);
                            
                            /*if (!Acclist_6.keyset().isEmpty()){
                                lstAccounts.addAll(Acclist_6.values());
                                Acclist_7 = new map < id, Account > ([Select IAM_Service_Provider_Code__c,CSS_DistributorCode__c,IAM_Primary_Market_Segment__c, id, Name, CMI_Account_Status__c, Location__c, ParentId, IAM_WWSPS_Regions__c,type
                                from Account where ParentId in: Acclist_6.keyset() ]);
                                
                                if (!Acclist_7.keyset().isEmpty()){
                                    lstAccounts.addAll(Acclist_7.values());
                                    Acclist_8 = new map <id, Account> ([Select IAM_Service_Provider_Code__c,CSS_DistributorCode__c,IAM_Primary_Market_Segment__c, id, Name, CMI_Account_Status__c, Location__c, ParentId, IAM_WWSPS_Regions__c,type
                                    from Account where ParentId in: Acclist_7.keyset() ]);
                                    
                                    if (!Acclist_8.keyset().isEmpty()) {
                                        lstAccounts.addAll(Acclist_8.values());
                                    }
                                }
                            }*/
                        }
                    }
                }
            }
        }
    }
    
    /*This method will create a new contact with status active or pending, if logged in user is final approver
    or account is IAM account then contact is created with active status and user also created from contact trigger,
    if account is WWSPS account then contact is created with pending status and approval send to parent account`s primary contact
    if newly created user has site admin role as manage subscription or manage both then contact provisioning record will be created 
    for MarketPlace and status active, if contact is pending for approval then status set as Pending Contact Approval 
    */  
    public void addNewUser(){
        try{
            pageMessage = null;
            newCon.id = null;
            System.debug('addNewUser starts... '+newCon);
            String userName = newCon.Username__c.trim() + System.Label.css_org;
            integer user_count = 0;
            user_count = [select count() from contact where Username__c =: userName];
            
            if (user_count > 0){
                isUserNameExist = true;
                system.debug('addNewUser *********isUserNameExist  ' +isUserNameExist);
            }else{
                isUserNameExist = false;
                system.debug('addNewUser *********isUserNameExist  ' +isUserNameExist);
                newCon.RecordtypeId = IAM_contactHelperClass.getRecordtypeId(System.Label.IAM_Record, System.Label.IAM_Contact_Singular_Label);
                System.debug('Account.id .....  ' + objAccount.Id);
                
                if(objAccount.Id != NULL){
                    newCon.AccountId = objAccount.Id;
                    newCon.Username__c = userName;
                }
                List<Account> acc = [select id, IAM_Service_Provider_Code__c,RecordType.Name,Location__c, CMI_Account_Num__c, IAM_WWSPS_Regions__c,OwnerId,Parent.OwnerId,CMI_Account_Status__c from account where id =: objAccount.Id];               
                boolean isPrimaryContactExist = false;
                for (Contact eachCOn: [select id, firstname, lastname,
                          CMI_TableauId__c, CMI_Contact_Type__c, IAM_Site_Admin__c, Username__c, Account.IAM_WWSPS_Regions__c from Contact where AccountId =: objAccount.Id]){
                    if (eachCOn.CMI_Contact_Type__c == System.Label.IAM_Primary){
                        isPrimaryContactExist = true;
                    }
                }
                
                if(isPrimaryContactExist) {
                    newCon.CMI_Contact_Type__c = System.Label.IAM_Secondary;
                }else{
                    newCon.CMI_Contact_Type__c = System.Label.IAM_Primary;
                }
                
                if(newCon.IAM_Site_Admin__c && isPrimaryContactExist) {
                    newCon.CMI_Contact_Type__c = System.Label.IAM_Secondary;  //site admin
                }
                
                if(!acc.isEmpty()){
                    system.debug('_____>>_____>> acc[0].RecordType.Name ' + acc[0].RecordType.Name);
                    system.debug('_____>>_____>> objUser[0].IAM_Final_Approver__c ' + objUser[0].IAM_Final_Approver__c);
                    
                    if(acc[0].IAM_Service_Provider_Code__c != NULL && acc[0].Location__c != NULL){
                        newCon.IAM_Work_Group_Id__c = acc[0].Location__c +  System.Label.IAM_WorkGrpAddition_Symbol;
                    }
                    if(objUser[0].IAM_Final_Approver__c == System.Label.IAM_Label_Y){
                        newCon.IAM_Contact_Status__c = System.Label.IAM_Status_Active;
                    }else if(acc[0].RecordType.Name == System.Label.IAM_WWSPS){
                        newCon.IAM_Contact_Status__c = System.Label.IAM_Status_Pending;
                    }else{
                        newCon.IAM_Contact_Status__c = System.Label.IAM_Status_Active;
                    }
                }
                
                if(!newCon.IAM_Site_Admin__c )
                    newcon.IAM_Site_Admin_Role__c = null;
                    
                newcon.IAM_Approved__c = System.Label.IAM_Label_N;
                system.debug('IAM_Site_Admin_Role__c >> newcon ' + newcon.IAM_Site_Admin_Role__c);
                system.debug('IAM_Site_Admin__c >> newcon ' + newcon.IAM_Site_Admin__c);
                Id approverId = getApproverId(objAccount.Id);
                if(null == approverId)
                    approverId = System.Label.IAM_Default_IAM_Record_Owner;
                newCon.ownerId = approverId;
                system.debug('_____>>_____>> approverId ' + approverId);
                system.debug('_____>>_____>> before insert newcon ' + newcon);
                insert newCon;
                system.debug('_____>>_____>> after insert newcon ' + newcon);
                if(newCon.id != null){
                    createApplication(newCon);
                    if(newCon.IAM_Contact_Status__c == System.Label.IAM_Status_Pending){
                        IAM_Approval_Submission.submitAndProcessApprovalRequest(newCon, approverId);
                        pageMessage = System.Label.IAM_Pending_Aproval_Message;
                    }else if(newCon.IAM_Contact_Status__c == System.Label.IAM_Status_Active){
                        getActiveInactiveUsers();
                        pageMessage = System.Label.IAM_User_Created_Successfilly_Label;
                    }
                }
            }
        }catch(Exception ex){
            handelException('addNewUser', ex);
        }
    }
    
    // logic for assigning contact owner. traverse to the parent account contact and see if any primary contact exist if yes then assign contact owner otherwise traverse one level up until get the primary contact in parent account.
    public static Id getApproverId(Id accId){
        Id approverId = null;
        List<Account> lstParentId1 = [select id,ParentId from account where id =:accId];
        if(!lstParentId1.isEmpty()){
            List<Contact> lstContOwner1 = [select id, accountid, Username__c from contact where AccountId =: lstParentId1[0].ParentId and CMI_Contact_Type__c =: System.Label.IAM_Primary and IAM_Contact_Status__c =: System.Label.IAM_Status_Active];
            if(!lstContOwner1.isEmpty()){
                List<User> lstUser1 = [select id from user where IAM_UID__c =: lstContOwner1[0].Username__c];
                If(!lstUser1.isEmpty()){
                    approverId = lstUser1[0].id;
                }   
            }else{
                List<Account> lstParentId2 = [select id,ParentId from account where id =: lstParentId1[0].ParentId];
                if(!lstParentId2.isEmpty()){
                    List<Contact> lstContOwner2 = [select id, accountid, Username__c from contact where AccountId =: lstParentId2[0].ParentId and CMI_Contact_Type__c =: System.Label.IAM_Primary and IAM_Contact_Status__c =: System.Label.IAM_Status_Active];
                    if(!lstContOwner2.isEmpty()){
                        List<User> lstUser2 = [select id from user where IAM_UID__c =: lstContOwner2[0].Username__c];
                        If(!lstUser2.isEmpty()){
                            approverId = lstUser2[0].id;
                        }   
                    }else{
                        List<Account> lstParentId3 = [select id,ParentId from account where id =: lstParentId2[0].ParentId];
                        if(!lstParentId3.isEmpty()){
                            List<Contact> lstContOwner3 = [select id, accountid, Username__c from contact where AccountId =: lstParentId3[0].ParentId and CMI_Contact_Type__c =: System.Label.IAM_Primary and IAM_Contact_Status__c =: System.Label.IAM_Status_Active];
                            if(!lstContOwner3.isEmpty()){
                                List<User> lstUser3 = [select id from user where IAM_UID__c =: lstContOwner3[0].Username__c];
                                If(!lstUser3.isEmpty()){
                                    approverId = lstUser3[0].id;
                                }   
                            }else{
                                List<Account> lstParentId4 = [select id,ParentId from account where id =: lstParentId3[0].ParentId];
                                if(!lstParentId4.isEmpty()){
                                    List<Contact> lstContOwner4 = [select id, accountid, Username__c from contact where AccountId =: lstParentId4[0].ParentId and CMI_Contact_Type__c =: System.Label.IAM_Primary and IAM_Contact_Status__c =: System.Label.IAM_Status_Active];
                                    if(!lstContOwner4.isEmpty()){
                                        List<User> lstUser4 = [select id from user where IAM_UID__c =: lstContOwner4[0].Username__c];
                                        If(!lstUser4.isEmpty()){
                                            approverId = lstUser4[0].id;
                                        }
                                    }else{
                                        List<Account> lstParentId5 = [select id,ParentId from account where id =: lstParentId4[0].ParentId];
                                       /* if(!lstParentId5.isEmpty()){
                                            List<Contact> lstContOwner5 = [select id, accountid, Username__c from contact where AccountId =: lstParentId5[0].ParentId and CMI_Contact_Type__c =: System.Label.IAM_Primary and IAM_Contact_Status__c =: System.Label.IAM_Status_Active];
                                            if(!lstContOwner5.isEmpty()){
                                                List<User> lstUser5 = [select id from user where IAM_UID__c =: lstContOwner5[0].Username__c];
                                                If(!lstUser5.isEmpty()){
                                                    approverId = lstUser5[0].id;
                                                }   
                                            }else{
                                                List<Account> lstParentId6 = [select id,ParentId from account where id =: lstParentId5[0].ParentId];
                                                if(!lstParentId6.isEmpty()){
                                                    List<Contact> lstContOwner6 = [select id, accountid, Username__c from contact where AccountId =: lstParentId6[0].ParentId and CMI_Contact_Type__c =: System.Label.IAM_Primary and IAM_Contact_Status__c =: System.Label.IAM_Status_Active];
                                                    if(!lstContOwner6.isEmpty()){
                                                        List<User> lstUser6 = [select id from user where IAM_UID__c =: lstContOwner6[0].Username__c];
                                                        If(!lstUser6.isEmpty()){
                                                            approverId = lstUser6[0].id;
                                                        }
                                                    }else{
                                                        List<Account> lstParentId7 = [select id,ParentId from account where id =: lstParentId6[0].ParentId];
                                                            if(!lstParentId7.isEmpty()){
                                                            List<Contact> lstContOwner7 = [select id, accountid, Username__c from contact where AccountId =: lstParentId7[0].ParentId and CMI_Contact_Type__c =: System.Label.IAM_Primary and IAM_Contact_Status__c =: System.Label.IAM_Status_Active];
                                                            if(!lstContOwner7.isEmpty()){
                                                                List<User> lstUser7 = [select id from user where IAM_UID__c =: lstContOwner7[0].Username__c];
                                                                If(!lstUser7.isEmpty()){
                                                                    approverId = lstUser7[0].id;
                                                                }   
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }*/
                                    }
                                }
                            }
                        }
                    }
                }       
            }
        }
        return approverId;
    }
    
    //This method set the contact information when page get loaded or Active/Inacive radio button click on the page.
    public void setContactInfo(List<Contact> lstContact){
        mapActiveImagesContactid = new map <string, boolean> ();
        mapuserlockedContactid = new map <string, boolean> ();
        mapContactIdToUser = new Map < String, User > ();
        map <string, boolean> useridpasswordstatus = new map < string, boolean > ();
        activeContactsList = new List<contact>();
        inActiveContactsList = new List<contact>();
        // fix - D-2967 - added name field in SOQL
        List <User> lstUsers = [Select id, name,firstname, lastname, isActive, contactId from User where contactId In: lstContact];
        
        for (UserLogin eachLogin: [SELECT IsPasswordLocked,UserId FROM UserLogin WHERE UserId in: lstUsers]){
            useridpasswordstatus.put(eachLogin.UserId, eachLogin.IsPasswordLocked);
        }
       
        for (User uObj: lstUsers){
            mapContactIdToUser.put(uObj.contactId, uObj);
        }
        
        for (Contact conobj : lstContact){
            if(mapContactIdToUser.containsKey(conobj.id)){
                User objUser1 = mapContactIdToUser.get(conobj.id);
                if(null != objUser1 && conobj.IAM_Contact_Status__c == System.Label.IAM_Status_Active){
                    activeContactsList.add(conobj);
                    mapActiveImagesContactid.put(string.valueOf(conobj.id), true);
                    mapuserlockedContactid.put(string.valueOf(conobj.id), useridpasswordstatus.get(objUser1.id));
                }else if(null != objUser1 && conobj.IAM_Contact_Status__c == System.Label.IAM_Status_Inactive){
                    inActiveContactsList.add(conobj);
                    mapActiveImagesContactid.put(string.valueOf(conobj.id), false);
                    mapuserlockedContactid.put(string.valueOf(conobj.id), useridpasswordstatus.get(objUser1.id));
                }
            }
        }
     
    }
    
    //this functional is called to get the pending approvals depending upon the account selected in the drop down and logged in user.
    public void getPendingApprovals(){
        try{
            //Process instance items that are needed to be displayed
            List <ProcessInstanceWorkItem> lstApprovals = getApprovalItems();
            lstPendingApproval = new List <ProcessInstanceWorkItem>();
            Map <id, ProcessInstanceWorkItem> mapPIWI = new Map <id, ProcessInstanceWorkItem>();
            pendingApprovalsCount = 0;
            mapApprovalData = new map<id,ApprovalData>();
            Set <id> setTargetObjIds = new Set <id> ();
            System.debug('Printing lstApprovals.... ' + lstApprovals);
            for(processinstanceworkitem piwi: lstApprovals){
                mapPIWI.put(piwi.processinstance.targetobject.id, piwi);
                setTargetObjIds.add(piwi.processinstance.targetobject.id);
            }
            
            System.debug('Printing mapPIWI   ' + mapPIWI);
            System.debug('Printing setTargetObjIds    '+ setTargetObjIds);
            System.debug('Printing strAccountId    '+ strAccountId);
            //issue - 452 - populate application name in pending approval tab in site admin portal.
            for(Contact cont: [select firstname, lastname, (select IAM_Application_Name__c from Contact_Provisionings__r),Username__c,
                            account.name, Email from Contact where id =: setTargetObjIds and accountid =:strAccountId]){
                mapApprovalData.put(cont.id, new ApprovalData(cont.firstName,cont.LastName,cont.Email,cont.account.name,(cont.Contact_Provisionings__r.size() == 1) ? cont.Contact_Provisionings__r[0].IAM_Application_Name__c : null, cont.Username__c,null));
                lstPendingApproval.add(mapPIWI.get(cont.id));
            }
            
            System.debug('Printing mapApprovalData    '+ mapApprovalData);
            
            System.debug('Printing lstPendingApproval    '+ lstPendingApproval);
            // added email field issue#427
            for (IAM_Contact_Provisioning__c conApp: [select id,IAM_Contact__r.Account.name,IAM_Contact__r.firstname, IAM_Contact__r.lastname,IAM_Contact__r.Username__c, IAM_Contact__r.email,
                            IAM_Application_Name__c from IAM_Contact_Provisioning__c where id =: setTargetObjIds and IAM_Contact__r.AccountId =:strAccountId]){
                mapApprovalData.put(conApp.id, new ApprovalData(conApp.IAM_Contact__r.firstName,conApp.IAM_Contact__r.lastName,conApp.IAM_Contact__r.Email,conApp.IAM_Contact__r.Account.name,conApp.IAM_Application_Name__c,conApp.IAM_Contact__r.Username__c,null));
                //Adding Process instance ids to respective lists
                lstPendingApproval.add(mapPIWI.get(conApp.id));
            } 
            System.debug('Printing lstPendingApproval' + lstPendingApproval);
            pendingApprovalsCount = lstPendingApproval.size();
            System.debug('Printing pendingApprovalsCount ' + pendingApprovalsCount );
            if(lstPendingApproval.isEmpty())
                isPendingApprovalTableEmpty = true;
            else 
                isPendingApprovalTableEmpty = false;

        }catch(exception ex){
            handelException('getPendingApprovals', ex);
        }
    }
    
    //This function get the information about rejected approvals based on logged in user and selected account from the list of companies drop down.
    public void getDeniedRequests(){
        try{
            reg_lstuser = new List <ProcessInstanceStep> ();
            mapApprovalData = new map<id,ApprovalData>();
            Set <id> setTargetObjIds = new Set <id>();
            deniedRequestCount = 0;
            Map <id, processInstanceStep> mapRejectedProcess = new Map <id, processInstanceStep> ();
            List <processInstanceStep> lstRejectedProcess = getDeniedItems();

            for(processInstanceStep rejStep: lstRejectedProcess){
                setTargetObjIds.add(rejStep.processinstance.targetobject.id);
                mapRejectedProcess.put(rejStep.processinstance.targetobject.id, rejStep);
            }

            for(Contact cont: [select firstname, lastname,Username__c, account.name, Email from Contact where id =: setTargetObjIds and accountid =: strAccountId]){
                mapApprovalData.put(cont.id, new ApprovalData(cont.firstName,cont.LastName,cont.Email,cont.account.name, null, cont.Username__c,mapRejectedProcess.get(cont.id).Comments));
                reg_lstuser.add(mapRejectedProcess.get(cont.id));
            }

            for (IAM_Contact_Provisioning__c conApp: [select id,IAM_Contact__r.Account.name,IAM_Contact__r.firstname, IAM_Contact__r.lastname,IAM_Contact__r.Username__c, IAM_Contact__r.email
                             from IAM_Contact_Provisioning__c where id =: setTargetObjIds and IAM_Contact__r.AccountId =: strAccountId]){
                mapApprovalData.put(conApp.id, new ApprovalData(conApp.IAM_Contact__r.firstName,conApp.IAM_Contact__r.lastName,conApp.IAM_Contact__r.Email,conApp.IAM_Contact__r.Account.name,null,conApp.IAM_Contact__r.Username__c,mapRejectedProcess.get(conApp.id).Comments));
                reg_lstuser.add(mapRejectedProcess.get(conApp.id));
            } 
            deniedRequestCount = reg_lstuser.size();
            if(reg_lstuser.isEmpty())
                isDeniedRequestTableEmpty = true;
            else
                isDeniedRequestTableEmpty = false;
        }catch(exception ex){
            handelException('getDeniedRequests', ex);
        }
    }
    
    /*
    *This method is used to update the selected account in page
    */
    public void EditAccount(){
        System.debug('EditAccount...seleAccountForUpdate.. ' + seleAccountForUpdate);
        try{
            update seleAccountForUpdate;
            pageMessage = System.Label.IAM_Company_Update;  
            fetchData();
        }catch(exception ex){
            handelException('EditAccount', ex);
        }
    }
    
    //This function get information about account on click on edit account icon
    public void getEditAccount(){
        try{
            List<Account> lstAccountForUpdate = [Select BillingStatecode, BillingCountryCode,RecordType.Name,
                    BillingStreet, CMI_Address3__c, BillingCity, BillingState, BillingPostalCode, BillingCountry,IAM_Primary_Market_Segment__c, id, Name  from Account where id =: strAccountId];
            
            if (!lstAccountForUpdate.isEmpty()){
                seleAccountForUpdate = lstAccountForUpdate[0];
                if(seleAccountForUpdate.RecordType.Name == System.Label.IAM_WWSPS){
                    pageMessage = System.Label.IAM_WWSPS_Account_Edit_Message;  
                    return;
                }
                
            }   
       
        }catch(exception ex){
            handelException('getEditAccount', ex);
        }
    }
    
    /*this function is mainly used to get data or contacts or processinstancework items 
    and fetch the account information which display as company information
    */
    public void getComapanyAndContactInfo(){
        System.debug('>>> getComapanyAndContactInfo start here ');
        try{
            newCon = new contact();
            System.debug('>>>>>>>>>>>>>>>>>>>> strAccountId  ' + strAccountId);
            objAccount = [Select IAM_Primary_Market_Segment__c,id, Name, CMI_Account_Status__c,BillingStreet,BillingCity,CSS_Timezone__c,CSS_Locale__c,
                    BillingState,BillingPostalCode,Phone, IAM_Service_Provider_Code__c,CSS_Language__c,IAM_ECN__c,Type from Account where id =: strAccountId];
            System.debug('objAccount=======' + objAccount);
            setPendingApprovalCount();
            setDeniedRequestCount();
            getActiveInactiveUsers();
        }catch(exception ex){
            handelException('getComapanyAndContactInfo', ex);
        }
        
    }
    
    //this method is update contact
    public void updateUser(){
        try{
            pageMessage = null;
            system.debug('updateUser_____>>_____>> newcon.id ' + newcon.id);
            List<Contact> lstupdateCont = [select ownerid,IAM_Contact_Status__c,email from contact where id =: newcon.Id];
            List<IAM_Contact_Provisioning__c> lstContProv = [select id,IAM_Status__c from IAM_Contact_Provisioning__c where IAM_Contact__c =: newcon.Id and IAM_Application_Name__c =: System.Label.IAM_OSM_App_Name limit 1];
            system.debug('updateUser_____>>_____>> before update lstupdateCont ' + lstupdateCont);
            system.debug('updateUser_____>>_____>> before update newcon ' + newcon);
            if(!lstupdateCont.isEmpty()){
                if(!newCon.IAM_Site_Admin__c){
                    newcon.IAM_Site_Admin_Role__c = null;
                    if(!lstContProv.isEmpty() && lstupdateCont[0].IAM_Contact_Status__c == System.Label.IAM_Status_Active)
                        lstContProv[0].IAM_Status__c = System.Label.IAM_Status_Inactive;
                }else if(newCon.IAM_Site_Admin__c){
                    if(lstupdateCont[0].IAM_Contact_Status__c == System.Label.IAM_Status_Active){
                        if(lstContProv.isEmpty())
                            createApplication(newCon);
                        else if(!lstContProv.isEmpty() && (newcon.IAM_Site_Admin_Role__c == System.Label.IAM_Manage_Subscription || newcon.IAM_Site_Admin_Role__c == System.Label.IAM_Manage_Both))
                            lstContProv[0].IAM_Status__c = System.Label.IAM_Status_Active;
                        else if(!lstContProv.isEmpty() && newcon.IAM_Site_Admin_Role__c == System.Label.IAM_Manage_User)
                            lstContProv[0].IAM_Status__c = System.Label.IAM_Status_Inactive;
                    }   
                }
                newcon.ownerid = lstupdateCont[0].ownerid;
                newcon.IAM_Contact_Status__c = lstupdateCont[0].IAM_Contact_Status__c;
               
            }
            system.debug('updateUser_____>>_____>> before update lstContProv ' + lstContProv);
            system.debug('updateUser_____>>_____>> before update newcon ' + newcon);
            update lstContProv;
            
            update newCon;
            pageMessage = System.Label.IAM_User_Updated_Message;
            getActiveInactiveUsers();
        }catch(exception ex){
            handelException('updateUser', ex);
        }
    }
    
    // This is wrapper class to display pending/denied request in the page
    public class ApprovalData{
        public string firstName{get;set;}
        public string lastName{get;set;}
        public string email{get;set;}
        public string companyName{get;set;}
        public string applicationName{get;set;}
        public string userName{ get;set;}   
        public string rejectComments{ get;set;}  
        public ApprovalData(String firstName,String lastName,String email,String companyName, String applicationName, String userName,String rejectComments) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.email = email;  
            this.companyName = companyName;
            this.applicationName = applicationName;
            this.userName = userName;
            this.rejectComments = rejectComments;
        }
    }
    
    //This method get approval request items based on these item pending approal request fetch
    public List <ProcessInstanceWorkItem> getApprovalItems(){
        return [select id, processinstance.targetobject.id from processinstanceworkitem where actorid =: userinfo.getuserid()];
    }
    
    //This method get denied request items based on these item denied request fetch
    public List <processInstanceStep> getDeniedItems(){
        return [SELECT id, Comments, processinstance.targetobject.firstname FROM ProcessInstanceStep where StepStatus =: System.Label.IAM_Rejected_Label and ActorId =: userinfo.getUserid()];
    }
    
    //This method get the pending approval request count and this method called on page load
    public void setPendingApprovalCount(){
        try{
            List <ProcessInstanceWorkItem> lstApprovals = getApprovalItems();
            Set<Id> setTargetObjIds = new Set<Id>();
            for(processinstanceworkitem piwi: lstApprovals){
                setTargetObjIds.add(piwi.processinstance.targetobject.id);
            }
            pendingApprovalsCount = getApproveDeniedCount(setTargetObjIds);
            System.debug('Printing from setPendingApprovalCount ...pendingApprovalsCount.... ' + pendingApprovalsCount);
        }catch(exception ex){
            handelException('setPendingApprovalCount', ex);
        }
    }
    
    //This method get the denied request count and this method called on page load
    public void setDeniedRequestCount(){
        try{
            List <processInstanceStep> lstDeniedReq = getDeniedItems();
            Set<Id> setTargetObjIds = new Set<Id>();
            for(processInstanceStep rejStep: lstDeniedReq){
                setTargetObjIds.add(rejStep.processinstance.targetobject.id);
            }
            deniedRequestCount = getApproveDeniedCount(setTargetObjIds);
            System.debug('Printing from setDeniedRequestCount ...deniedRequestCount.... ' + deniedRequestCount);
        }catch(exception ex){
            handelException('setDeniedRequestCount', ex);
        }
    }
    
    //This function get the penidng approval/denied request counts based on target object id.
    public Integer getApproveDeniedCount(Set<Id> setTargetObjIds){
        Integer approveDeniedCount = 0;
        approveDeniedCount = [select count() from Contact where id =: setTargetObjIds and accountid = :strAccountId];
        approveDeniedCount += [select count() from IAM_Contact_Provisioning__c where id =: setTargetObjIds and IAM_Contact__r.AccountId =:strAccountId];
        return approveDeniedCount;
    }
    
    //This method is used to fetched existing contact information for edit contact
    public void getEditUserInfo(){
        System.debug('showUpdatePanel start .... strContactId========' + strContactId);
        try{
            if(strContactId != null){
                newCon = new contact();
                List < Contact > lstCon = [select id, IAM_Location__c,IAM_Site_Admin_Role__c,Username__c,IAM_Approved__c, IAM_Internal__c,Name, Accountid,FirstName, LastName, Email, phone, IAM_Site_Admin__c from Contact where id =: strContactId];
                System.debug('lstCon========>>' + lstCon);
                if (!lstCon.isempty()){
                    newCon = lstCon[0];
                    if(!newCon.IAM_Internal__c){
                        CompaniesAcc = new list < SelectOption > ();
                        for(Account acc: lstAccounts){
                            CompaniesAcc.add(new SelectOption(acc.id , acc.name));
                        }
                    }
                    
                }
                System.debug('newCon==' + newCon);
            }
        }catch(Exception ex){
            handelException('getEditUserInfo', ex);
        }
    }
    
    //This method called from catch block of action method
    public void handelException(String methodName, Exception ex){
        pageMessage = System.Label.IAM_Something_Went_Wrong_Error;  
        System.debug('Exception during ' + methodName+'()' +' method ========    ' + ex.getMessage());
        System.debug('Exception line number '+ex.getLineNumber());
        try{
            IAM_ErrorHandling.IAMerrorCapture(null, 'IAM_SiteAdmin_Controller.'+methodName, ex.getMessage());
        }catch(Exception exp){
            System.debug('Exception during inserting record on IAM_ErrorHandling ========    ' + exp.getMessage());
        }
    }
    
    //This method is used to reset the selected user password
    public void resetUserPassword(){
        try{
            String selectedUser = Apexpages.currentpage().getParameters().get(selectedUsers);
            List <String> lstContactIds = selectedUser.split(',');
            
            System.debug('lstContactIds...... ' + lstContactIds);
            List<user> lstUsers = [select id from User where contactId in : lstContactIds];
            System.debug('resetUserPassword...... ' +lstUsers.size());
            for(user usr : lstUsers) {
                system.resetPasswordWithEmailTemplate(usr.id, true,'IAM_Reset_Password');
            }
            pageMessage = System.Label.IAM_Reset_Password_Message;
            getActiveInactiveUsers();
        }catch(Exception ex) {
            handelException('resetUserPassword', ex);
        }
    }
    
    //This method is used to deactivate multiple users
    public void deactivateMultipleUser(){
        try{
            list <String> listOfUsers = new list <String> ();
            list < String > listOfUserIds = new list <String> ();
            String selected_users = Apexpages.currentpage().getParameters().get(selectedUsers);
            String reasonForDeactivation = Apexpages.currentpage().getParameters().get('deactivate_reason');
            String commentsForDeactivation = Apexpages.currentpage().getParameters().get('deactivate_comments');
            System.debug('deactivateMultipleUser.... selected_users   ' + selected_users);
            System.debug('deactivateMultipleUser.... reasonForDeactivation   ' + reasonForDeactivation);
            System.debug('deactivateMultipleUser.... commentsForDeactivation   ' + commentsForDeactivation);
            User currentObjUser = [select ContactId from user where id =: Userinfo.getUserid() Limit 1];
            System.debug('currentObjUser in deactivate======>>' + currentObjUser);
            for(String each: selected_users.split(',')){
                if(mapContactIdToUser.containsKey(each)){
                    User objUsr = mapContactIdToUser.get(each);
                    System.debug('each in deactivate========>>' + each);
                    System.debug('objUsr in deactivate========>>' + objUsr);
                    if(null != objUsr){
                        if(currentObjUser.contactId == each){
                            pageMessage = System.Label.IAM_Logged_In_user_deactivate_message;
                            return;
                        }else{
                            listOfUsers.add(objUsr.id);
                            listOfUserIds.add(each);
                        }
                    }
                }
            }

            if (!listOfUsers.isEmpty()){
                activateDeactivateUser(listOfUsers, System.Label.IAM_User_Deactivated_Lable);
                updateContact(listOfUserIds, System.Label.IAM_User_Deactivated_Lable, reasonForDeactivation.escapeHtml3(), commentsForDeactivation);
            }
            pageMessage = System.Label.IAM_User_deactivated;
            getActiveInactiveUsers();
        }catch(Exception ex){
            handelException('deactivateMultipleUser', ex);
        }
    }
    
    
    //This method is used to activate users
    public void activeteSelectedUsers(){
        try{
            String selected_users = Apexpages.currentpage().getParameters().get(selectedUsers);
            List <String> lstContactIds = selected_users.split(',');
            System.debug('lstContactIds...... ' + lstContactIds);
            list <String> listOfUsers = new list <String> ();
            list <String> listOfUserIds = new list <String> ();
            System.debug('deactivate_multipleUser.... mapContactIdToUser   ' + mapContactIdToUser);
            for(String each : lstContactIds){
                if(mapContactIdToUser.containsKey(each)){
                    User objUser = mapContactIdToUser.get(each);
                    if(null != objUser){
                        listOfUsers.add(objUser.id);
                        listOfUserIds.add(each);
                    }
                }
            }
            if(!listOfUsers.isEmpty()){
                activateDeactivateUser(listOfUsers, System.Label.IAM_User_Activated_Label);
                updateContact(listOfUserIds, System.Label.IAM_User_Activated_Label, null, null);            
            }
            pageMessage = System.Label.IAM_User_activated;
            getActiveInactiveUsers();
        }catch(Exception ex){
            handelException('activeteSelectedUsers', ex);
        }
    }
    
    //This method is used to update contact status
    public void updateContact(list <String> contactid, String Status, String rejectReason, String rejectComments){
        try{
            List <Contact> lstCont = [Select id,IAM_Applications__c,IAM_Application_Roles__c,IAM_Qsolexpiration__c,IAM_Qsolview__c,FirstName,email,IAM_Contact_Status__c,Account.CMI_Account_Status__c,Account.id,(select id,IAM_Status__c from Contact_Provisionings__r) from Contact where id =: contactid];
            List<Contact> lstUpdateCont = new List<Contact>();
            List<Account> lstUpdateAcc = new List<Account>();
            List<IAM_Contact_Provisioning__c> lstupdateConProv = new List<IAM_Contact_Provisioning__c>();
            List<User> lstUsr = [select id, contactid from User where contactid =: contactid];
            Map<String,User> mapContactUser = new Map<String,User>();
            for(User usr : lstUsr){
                if(!mapContactUser.containsKey(usr.contactid))
                    mapContactUser.put(usr.contactid, usr);
            }
            System.debug('updateContact....lstCont ' + lstCont);
            System.debug('updateContact....mapContactUser ' + mapContactUser);
            
            if(Status == System.Label.IAM_User_Deactivated_Lable){
                for(Contact con: lstCont){
                    con.IAM_Inactivated_on__c = System.today();
                    con.IAM_Contact_Status__c = System.Label.IAM_Status_Inactive;
                    con.IAM_Applications__c = '';
                    con.IAM_Application_Roles__c ='';
                    con.IAM_Qsolexpiration__c = '';
                    con.IAM_Qsolview__c = '';
                    con.IAM_Reject_Reason__c = rejectReason;
                    con.IAM_Reason__c = rejectComments;
                    con.IAM_Deactivation_Mail_Sent__c = true;
                    for(IAM_Contact_Provisioning__c conProv : con.Contact_Provisionings__r){
                        if(conprov.IAM_Status__c == System.Label.IAM_Status_Active){
                            conprov.IAM_Status__c = System.Label.IAM_Status_Inactive;
                            conprov.IAM_Reject_Reason__c = rejectReason;
                            conprov.IAM_Reason__c = rejectComments;
                            conprov.Location_Change__c = true; 
                            lstupdateConProv.add(conProv);
                        }
                    }  
                    lstUpdateCont.add(con);
                }
            }else if (Status == System.Label.IAM_User_Activated_Label){
                for(Contact con: lstCont){
                    con.IAM_Activated_On__c = System.today();
                    con.IAM_Contact_Status__c = System.Label.IAM_Status_Active;
                    if(con.Account.CMI_Account_Status__c != System.Label.IAM_Status_Active)
                        con.Account.CMI_Account_Status__c = System.Label.IAM_Status_Active;
                    if(con.Account.CMI_Account_Status__c == System.Label.IAM_Status_Inactive)
                        lstUpdateAcc.add(con.Account);  
                    for(IAM_Contact_Provisioning__c conProv : con.Contact_Provisionings__r){
                        if(conProv.IAM_Status__c != System.Label.IAM_Status_Inactive && mapContactUser.containsKey(con.id)){
                            User objUsr = mapContactUser.get(con.id);
                            conProv.IAM_User__c = objUsr.id;
                        }   
                        //issue# 38 making this check box unchecked to triggering application access approval email contact status set to Active
                        conProv.IAM_Is_Reclaim_Access_Email_Send__c = false;
                        System.debug('Printing..contactpro ..IAM_Is_Reclaim_Access_Email_Send__c... ' + conProv.IAM_Is_Reclaim_Access_Email_Send__c);
                        lstupdateConProv.add(conProv);
                    }
    
                    lstUpdateCont.add(con);
                }
            }
            System.debug('updateContact....lstUpdateCont ' + lstUpdateCont);
            System.debug('updateContact....lstupdateConProv ' + lstupdateConProv);
            System.debug('updateContact....lstUpdateAcc ' + lstUpdateAcc);
            if(!lstUpdateCont.isEmpty())
                update lstUpdateCont;
            if(!lstupdateConProv.isEmpty())
                update lstupdateConProv;
            if(!lstUpdateAcc.isEmpty())
                update lstUpdateAcc;
        }catch(Exception ex){
            handelException('updateContact', ex);
        }
    }
    
    //This method is used to remove application
    public void deleteApplication(){
        try{
            String removeAppComments = Apexpages.currentpage().getParameters().get('removeApp_comments');
            String removeAppReason = Apexpages.currentpage().getParameters().get('removeApp_Reason');
            system.debug('deleteApplication.....removeAppComments ' + removeAppComments);
            system.debug('deleteApplication.....removeAppReason ' + removeAppReason);
            system.debug('App name of contact ' + strconAppid);
            List<IAM_Contact_Provisioning__c> lstupdateContPro = new List<IAM_Contact_Provisioning__c> ();
            List<IAM_Contact_Provisioning__c> lstContPro = [select id,IAM_Status__c from IAM_Contact_Provisioning__c where id=:strconAppid];
            for(IAM_Contact_Provisioning__c conPro : lstContPro){
                conPro.IAM_Status__c = System.Label.IAM_Status_Inactive;
                conPro.IAM_Reason__c = removeAppComments.escapeHtml3();
                conPro.IAM_Reject_Reason__c = removeAppReason.escapeHtml3();
                lstupdateContPro.add(conPro);
            }
            system.debug('deleteApplication.....lstupdateContPro ' + lstupdateContPro);
            update lstupdateContPro;
            pageMessage = System.Label.IAM_Application_Remove_Message;
            getActiveInactiveUsers();
        }catch(Exception ex){
            handelException('activeteSelectedUsers', ex);
        }   
    }
    
    //This method id used to reject approval request
    Public void rejectApprovalRequest(){
        try{
            List <ProcessInstanceWorkItem> lstApprovalItem = [select id, processinstance.targetobject.id from processinstanceworkitem where id =: Apexpages.currentPage().getParameters().get('myParamRej')];
            System.debug('rejectApprovalRequest .. lstApprovalItem[0].processinstance.targetobject.id..  ' + lstApprovalItem[0].processinstance.targetobject.id);
            Approval.ProcessWorkitemRequest request = new Approval.ProcessWorkitemRequest();
            request.setComments(rejectApproveReason);
            request.setAction(System.Label.IAM_Reject);
            request.setWorkitemId(Id.valueOf(Apexpages.currentPage().getParameters().get('myParamRej')));
            Approval.ProcessResult result = Approval.process(request);
            IAM_contactHelperClass.updateRejectReason(lstApprovalItem[0].processinstance.targetobject.id, 'Subscription Request Rejected', rejectApproveReason);
            if(result.isSuccess()){
                pageMessage = System.Label.IAM_Reject_request_Message;
                getPendingApprovals();
                setDeniedRequestCount();
            }else{
                pageMessage = System.Label.IAM_Something_Went_Wrong_Error;
            }   
        }catch(Exception ex){
            handelException('rejectApprovalRequest', ex);
        }  
    }
    
     //This method is used to approve request from pending approval tab
    Public void approveRequest(){
        try{
            editRoleItemId = null;
            List<IAM_Contact_Provisioning__c> lstconProvisioning = null;
            List <ProcessInstanceWorkItem> lstApprovalItem = [select id, processinstance.targetobject.id from processinstanceworkitem where id =: Apexpages.currentPage().getParameters().get('myParamApprove')];
            System.debug('approveRequest .. lstApprovalItem[0].processinstance.targetobject.id..  ' + lstApprovalItem[0].processinstance.targetobject.id);
            String objName = IAM_AccountsController.getName(lstApprovalItem[0].processinstance.targetobject.id);
            if(!lstApprovalItem.isEmpty()){
                if(objName == 'Contact'){
                    lstconProvisioning = [select id from IAM_Contact_Provisioning__c where IAM_Contact__c =: lstApprovalItem[0].processinstance.targetobject.id];
                    System.debug('approveRequest .. lstconProvisioning..  ' + lstconProvisioning);
                    if(!lstconProvisioning.isEmpty())
                        editRoleItemId = lstconProvisioning[0].id;
                }   
            }
            System.debug('approveRequest .. editRoleItemId..  ' + editRoleItemId);
            Approval.ProcessWorkitemRequest request = new Approval.ProcessWorkitemRequest();
            request.setAction(System.Label.IAM_approve);
            request.setWorkitemId(Id.valueOf(Apexpages.currentPage().getParameters().get('myParamApprove')));
            Approval.ProcessResult result = Approval.process(request);
            if(result.isSuccess()){
                pageMessage = System.Label.IAM_Approve_Request_message;
                getPendingApprovals();
                setDeniedRequestCount();
            }else{
                pageMessage = System.Label.IAM_Something_Went_Wrong_Error;
            }   
        }catch(Exception ex){
            handelException('approveRequest', ex);
        }  
    }
    
    //this method is used to unlock user 
    public void unlockUser(){
        try{
            List<UserLogin> lstusr = [SELECT IsPasswordLocked FROM UserLogin WHERE UserId =: [select id from user where contactId =: Apexpages.currentpage().getParameters().get('unlockParam') limit 1].id];
            if(!lstusr.isEmpty()){
                lstusr[0].IsPasswordLocked = false;
                update lstusr;
                pageMessage = System.Label.IAM_User_Unlock_Message;
                getActiveInactiveUsers();
            }
        }catch(Exception ex){
            handelException('unlockUser', ex);
        } 
    }
    
    //This method is used to display approval history on the page
    public void approvalHistory(){
        try{
            approvalHis = false;
            approvalHisMessage = false;
            retURLRecordId = recordId = ApexPages.currentPage().getParameters().get(selectedUsers);
            System.debug('Printing the value of the record id' + recordId);
            ORG_LNK = 'https://' + URL.getSalesforceBaseUrl().getHost();
            if(String.isBlank(recordID)){
                approvalHis = false;
            }else{
                aSW = new ApprovalList();
                aSW = generateData();
                system.debug('ASW***' +asW.approvals.size());
                if(asW.approvals.size() != NULL && asW.approvals.size() >= 1){            
                    approvalHis = true;
                }else{
                    approvalHisMessage = true;
                }
            }
        }catch(Exception ex){
            handelException('approvalHistory', ex);
        } 
        
    }
    
    //This method is used to create OSM application if its have access on related account 
    public void createApplication(Contact newcon){  
        if(newcon.IAM_Site_Admin_Role__c == System.Label.IAM_Manage_Subscription || newcon.IAM_Site_Admin_Role__c == System.Label.IAM_Manage_Both){
            system.debug('createApplication _____>>_____>> newcon ' + newcon);
            IAM_Contact_Provisioning__c idmContPro = null;
            for(IAM_Application__c cmiApp : [select id, recordtype.name,IAM_Application_Name__c, IAM_Role__c,IAM_Subscription_Start_Date__c, IAM_Subscription_End_Date__c from IAM_Application__c where IAM_Account_Name__c =: newCon.AccountId and IAM_Application_Name__c =: System.Label.IAM_OSM_App_Name and IAM_Status__c =: System.Label.IAM_Status_Active limit 1]){
                idmContPro = new IAM_Contact_Provisioning__c();
                idmContPro.recordtypeid = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(cmiApp.recordtype.name).getRecordTypeId();
                idmContPro.IAM_Account_Application__c = cmiApp.id;
                idmContPro.IAM_Contact__c = newCon.id;
                idmContPro.IAM_Application_Name__c = cmiApp.IAM_Application_Name__c;
                idmContPro.IAM_Role__c = cmiApp.IAM_Role__c;
                idmContPro.IAM_Status__c = (newCon.IAM_Contact_Status__c == System.Label.IAM_Status_Pending) ? System.Label.IAM_Pending_Contact_Approval : newCon.IAM_Contact_Status__c;
                idmContPro.IAM_Start_Date__c = cmiApp.IAM_Subscription_Start_Date__c;
                idmContPro.IAM_End_Date__c = cmiApp.IAM_Subscription_End_Date__c;
                idmContPro.IAM_End_Date__c = cmiApp.IAM_Subscription_End_Date__c;
            } 
            
            if(null != idmContPro)
                insert idmContPro;
            system.debug('createApplication _____>>_____>> idmContPro ' + idmContPro);
        }
    }
    
    //This method is used to update user status
    @future
    public static void activateDeactivateUser(list <String> userid, String Status){
        try{
            List<User> lstUserr = [select id,isActive from user where id =: userid];
            List<User> lstUpdateUser = new List<User>();
            for(User usr : lstUserr){
                if(status == System.Label.IAM_User_Deactivated_Lable){
                    usr.isActive = false;
                    
                }else if(status == System.Label.IAM_User_Activated_Label){
                    usr.isActive = true;
                }    
                lstUpdateUser.add(usr); 
            }
            System.debug('lstUpdateUser.size()......  '+ lstUpdateUser.size());
            if(!lstUpdateUser.isEmpty()){
                System.debug('lstUpdateUser......  '+ lstUpdateUser);
                update lstUpdateUser;
                //reset password for active user
                for(User resetUser : lstUpdateUser){
                    if(resetUser.isActive)
                        System.resetpassword(resetUser.id,true);
                }
            }
            
        }catch (Exception ex){
            System.debug('Exception during activateDeactivateUser()  method ========    ' + ex.getMessage());
            System.debug('Exception line number '+ex.getLineNumber());
            try{
                IAM_ErrorHandling.IAMerrorCapture(null, 'IAM_SiteAdmin_Controller.activateDeactivateUser', ex.getMessage());
            }catch(Exception exp){
                System.debug('Exception during inserting record on IAM_ErrorHandling ========    ' + exp.getMessage());
            }
        }
    }
    
    //Amarnath Mishra added for the sorting of company list D-3128
    public List<SelectOption> sortSelectOptions(List<SelectOption> sortingList) {
        for (Integer i =0; i < sortingList.size(); i++) {
            for (Integer j = i; j > 0; j--) {
                if (sortingList[j-1].getLabel() > sortingList[j].getLabel()){
                    SelectOption temp = sortingList[j];
                    sortingList[j] = sortingList[j-1];
                    sortingList[j-1] = temp;
                }
            }
        }
        return sortingList;
    }
}