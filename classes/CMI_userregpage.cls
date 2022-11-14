public without sharing class CMI_userregpage{
    public String currentRecordId {get;set;}
    public String parameterValue {get;set;}
    Public Account acc{get;set;}
    Public Contact contact{get;set;}
    public IAM_Contact_Provisioning__c conprov{get;set;}
    public string selectedRole{set;get;}
    public String errorUserName{set;get;}
    
    public string errorContactFirstName{set;get;}
    public string errorContactLastName{set;get;}
    public string errorContactEmail{set;get;}
    public string errorContactPhone{set;get;}
    public string errorConRole{set;get;}
    
    public CMI_userregpage(ApexPages.StandardController controller) {
        acc=new Account();
        contact=new Contact(); 
        conprov=new IAM_Contact_Provisioning__c();
        conprov.IAM_Application_Name__c=System.label.IAM_AppName_ConnectedSolutions;
        Id devRecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(System.label.IAM_AppName_ConnectedSolutions).getRecordTypeId();
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('aid');
        acc = [select id,name,CMI_CId__c from Account where id =: currentRecordId];
        parameterValue = ApexPages.CurrentPage().getparameters().get('aid');
        //parameterValue = ApexPages.CurrentPage().getparameters().get(acc.Id);
        System.debug('parameterValue>>>>>>'+parameterValue);        
    }
    
    public PageReference reset() {
        acc=new Account();
        contact=new Contact(); 
        conprov=new IAM_Contact_Provisioning__c();
        PageReference pageRef = new PageReference(System.currentPageReference().getURL());
        pageRef.getParameters().put('aid',currentRecordId  );
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    //defining custom picklist value to dispaly role options
    public List<SelectOption> getRoleOptions() {
        List<SelectOption> roleOptions= new List<SelectOption>();
        roleOptions.add(new SelectOption('','None'));
        roleOptions.add(new SelectOption('AccountManager','AccountManager'));
        roleOptions.add(new SelectOption('ServiceTechnician','ServiceTechnician'));
        roleOptions.add(new SelectOption('Operator','Operator'));
        roleOptions.add(new SelectOption('Subscriber','Subscriber'));
        return roleOptions;
    }
    
    // save button is clicked
    public PageReference send() {
        Boolean errofound = false;
        errorContactFirstName='';
        errorContactLastName='';
        errorContactEmail='';
        errorContactPhone='';
        errorUserName='';//code change - duplicate username - Chetan Gaikwad
        errorConRole='';
        if(contact.FirstName == '' ||contact.FirstName == Null ){
            errorContactFirstName='Please fill out Contact First Name';  
            errofound = true;
        }
        if(contact.LastName == '' ||contact.LastName == Null ){
            errorContactLastName='Please fill out Contact Last Name';  
            errofound = true;
        }
        //code start - Validate if username already exist - Chetan Gaikwad
        if(contact.Email == '' ||contact.Email == Null ){
            errorContactEmail='Please fill out Contact Email';  
            errofound = true;
        }else{
            if(contact.Email!=null && !contact.Email.contains('@') ){
                list<string> lstMail=contact.Email.split('@');
                
                if(lstMail==null || lstMail.size()!=2 || !lstMail[1].contains('.')){    
                    
                    errorContactEmail='Please fill out Valid Contact Email';  
                    errofound = true;
                }
            }
        }
        if(contact.Username__c== '' || contact.Username__c== Null ){
            errorUserName='Please fill out Username';  
            errofound = true;
        }else{
            if(contact.Username__c!=null && !contact.Username__c.contains('@') ){
                list<string> lstMail=contact.Username__c.split('@');
                if(lstMail==null || lstMail.size()!=2 || !lstMail[1].contains('.')){    
                    
                    errorUserName='Please fill out Valid Username in Email format';  
                    errofound = true;
                }
            }else{
                String dupUsrName = contact.Username__c;
                String lowUsrName = dupUsrName.toLowerCase();
                if(lowUsrName.contains('@cummins.')){
                    errorUserName='Username must not contain cummins';  
                    errofound = true;
                }
                List<Contact> dupCont = [Select id,FirstName, LastName, Email,CMI_Contact_Type__c,Username__c,Account.CMI_CId__c From Contact where Username__c =: dupUsrName];
                if(dupCont.size()>0){
                    errorUserName='Username already exist';  
                    errofound = true;
                }
            } 
        }
        //code end - Validate if username already exist - Chetan Gaikwad
        
        if(selectedRole==''||selectedRole==null){
            errorConRole='Please fill out Role';  
            errofound = true;
        }
        if(errofound == true){
            System.debug('Printing error'+errofound);
            return null;
        }
        else{
            try{
                
                Savepoint sp = Database.setSavepoint(); 
                try{   
                    
                    system.debug('contact entering'+acc );
                    System.debug('Printing selected role'+selectedRole);      
                    // contact.AccountId=parameterValue ; 
                    contact.AccountId=acc.Id ;
                    contact.CMI_Contact_Type__c='Secondary';
                    Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                    System.debug('Contact recordtype======='+devRecordTypeId);
                    contact.RecordTypeId=devRecordTypeId; 
                    contact.IAM_Contact_Status__c='Active';
                    contact.ownerid='00561000000rPnZ';
                    insert contact; // inserts the new record into the database
                    system.debug('contact has been created'+contact +contact.id);     
                    insertNewUser(contact.id);
                    
                    Id RecIdpro = [Select Id, Name,sobjecttype from RecordType where name = 'Connected Solutions' and sobjecttype = 'IAM_Contact_Provisioning__c'].Id;   
                    //IAM_Application__c app=[select id,IAM_Role__c from IAM_Application__c where IAM_Account_Name__c=:parameterValue and IAM_Application_Name__c=:System.label.IAM_AppName_ConnectedSolutions];
                    IAM_Application__c app=[select id,IAM_Role__c, IAM_Subscription_End_Date__c from IAM_Application__c where IAM_Account_Name__c=:acc.Id and IAM_Application_Name__c=:System.label.IAM_AppName_ConnectedSolutions];
                    system.debug('contact conprov'+app.id);          
                    conprov.IAM_Account_Application__c=app.id;
                    conprov.IAM_Status__c='Active';
                    conprov.IAM_Start_Date__c=system.today();
                    if(app.IAM_Subscription_End_Date__c!=null){
                        conprov.IAM_End_Date__c=app.IAM_Subscription_End_Date__c;
                    }
                    conprov.IAM_Application_Name__c=System.label.IAM_AppName_ConnectedSolutions;
                    //conprov.DA_Connected_Solutions_Role__c=conprov.IAM_Role__c;
                    conprov.recordtypeid = RecIdpro;
                    conprov.IAM_Contact__c = contact.id;
                    conprov.IAM_Role__c = selectedRole;
                    conprov.IAM_DA_Customer_List__c=acc.CMI_CId__c;
                    //conprov.ownerid='00561000000rPnZ';
                    system.debug('DA provisioning record'+conprov);
                    insert conprov;
                    
                    
                    //Below code is to insert record OSM to give access to OSM applications for Role Account Manager
                    if(selectedRole=='AccountManager'){
                        List<IAM_Application__c> appMP=[select id,IAM_Role__c, IAM_Subscription_End_Date__c from IAM_Application__c where IAM_Account_Name__c=:parameterValue and IAM_Application_Name__c=:System.label.IAM_OSM_App_Name LIMIT 1];
                        System.debug('Printing applicationa name'+appMP);
                        if(!appMP.isEmpty()){
                            IAM_Contact_Provisioning__c appOSM= new IAM_Contact_Provisioning__c();
                            appOSM.IAM_Account_Application__c=appMP[0].id;
                            appOSM.IAM_Status__c='Active';
                            appOSM.IAM_Start_Date__c=system.today();
                            if(appMP[0].IAM_Subscription_End_Date__c!=null){
                                appOSM.IAM_End_Date__c = appMP[0].IAM_Subscription_End_Date__c; 
                            }
                            appOSM.IAM_Application_Name__c=System.label.IAM_OSM_App_Name;
                            // appOSM.DA_Connected_Solutions_Role__c='OSM Fleet Admin';
                            appOSM.recordtypeid = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(system.label.IAM_OSM_App_Name).getRecordTypeId();
                            appOSM.IAM_Contact__c = contact.id;
                            appOSM.IAM_Role__c = System.label.IAM_OSM_StoreFront_Admin_Role;
                            //appOSM.ownerid='00561000000rPnZ';
                            system.debug('OSM provisioning record'+appOSM);
                            insert appOSM;
                        }
                    }
                    
                    system.debug('contact conprov'+conprov);
                    return Page.CMI_userregconfirm;
                }     
                catch(exception e){
                    System.debug('Printing exception'+e);
                    System.debug('Printing Stack Trace'+e.getStackTraceString());
                    Database.rollback(sp); 
                    acc= acc.clone(false);
                    return null;  
                    
                }
                return null;
            }
            catch(DMLException ex){
                ApexPages.addMessages(ex);
                System.debug('Printing exception'+ex);
                System.debug('Printing Stack Trace'+ex.getStackTraceString());
            }
            // if successfully inserted new contact, then displays the thank you page.
            return Page.CMI_userregconfirm;
        }
        return null;
    }        
    
    @future
    public static void insertNewUser(String contactId){
        System.debug('insertNewUser..contactId.' + contactId);
        Profile pSiteAdmin=[select id from Profile where name='IAM_Site_Admin_Community' Limit 1];
        Profile pSiteUser= [select id from Profile where name='IAM User' Limit 1]; 
        Permissionset DA=[select id,Name,Label from Permissionset where Name= 'Connected_Solutions'];
        Permissionset OSM=[select id,Name,Label from Permissionset where Name='OSM_Fleet_Admin'];
        System.debug('Printing all the Profile values'+pSiteAdmin+'Please see the IAM USer'+pSiteUser);
        System.debug('Printing all the permission set ids from the above queries'+DA+'OSM permission set id'+OSM); 
        
        try{
            Contact cont = [Select id,FirstName, LastName, Email,CMI_Contact_Type__c,Username__c,Account.CMI_CId__c From Contact where id=:contactId limit 1];
            List<IAM_Contact_Provisioning__c> conProv=[Select id,IAM_Application_Name__c,IAM_Role__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:cont.id and IAM_Application_Name__c='Connected Solutions' and IAM_Status__c='Active'];
            system.debug('contact id for user creation'+cont.id);
            System.debug('Printing con Prov detaisl'+conProv);
            if(cont!=null){              
                User usr = new User();                
                usr.LastName = cont.LastName;
                usr.FirstName = cont.FirstName;               
                usr.CommunityNickname = cont.FirstName.substring(0,2) + cont.LastName.substring(0,2);
                usr.Email = cont.Email;
                usr.Username = cont.Username__c;
                usr.ContactId = cont.id;
                usr.CMI_Calibration_Role__c=ConProv[0].IAM_Role__c;
                usr.CMI_Customer_List__c=cont.Account.CMI_CId__c;                 
                if(ConProv[0].IAM_Role__c=='AccountManager'){
                    System.debug('Printing Profile for Account Manager');
                    //usr.Profileid='00eQ0000000QhPCIA0';
                    usr.Profileid=pSiteAdmin.id;
                }else{
                    //usr.Profileid='00eQ0000000QhP9IAK';
                    usr.Profileid=pSiteUser.id;
                }               
                usr.TimeZoneSidKey = 'America/New_York';
                usr.LanguageLocaleKey = 'en_US';
                usr.EmailEncodingKey = 'UTF-8';
                usr.LocaleSidKey = 'en_US';
                
                if (system.label.css_org != '.cso') {
                    usr.Username = cont.Username__c+ system.label.css_org;
                    //usr.IAM_UID__c = cont[0].email + system.label.css_org;
                } else {
                    usr.Username = cont.Username__c;
                    //usr.IAM_UID__c = cont[0].email;
                }
                if (cont.LastName.length() >= 4) {
                    usr.alias = cont.FirstName.substring(0, 1) + '' + cont.LastName.substring(0, 4);
                } else if (cont.LastName.length() <= 2 && cont.FirstName.length() <= 2) {
                    usr.alias = cont.FirstName + '' + cont.LastName;
                } else {
                    usr.alias = cont.FirstName.substring(0, 4 - cont.LastName.length()) + '' + cont.LastName;
                }
                
                System.debug('Printing user details'+usr);
                insert usr;
                system.resetpassword(usr.id,true);
                //Inserting Permission set 
                List<PermissionSetAssignment> pSet= new List<PermissionSetAssignment>();    
                if(conProv[0].IAM_Role__c=='AccountManager') {
                    //Now Need to assaign product connectivity and OSM application Access.
                    
                    PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = OSM.id, AssigneeId = usr.id);//OSM Permission set
                    pSet.add(psa);
                    PermissionSetAssignment psa1 = new PermissionSetAssignment(PermissionSetId = DA.id, AssigneeId = usr.id);//cs Permission set
                    pSet.add(psa1);
                }
                else if(conProv[0].IAM_Role__c!='AccountManager') {
                    PermissionSetAssignment psa2= new PermissionSetAssignment(PermissionSetId = DA.id, AssigneeId = usr.id);//cs Permission set
                    pSet.add(psa2);
                    
                }
                insert pSet;
                //  }           
            }   
        }catch(Exception ex){
            //Database.RollBack(sp);
            system.debug('Error throws during user creation....' + ex.getMessage());
            //show_error_msg(ex.getMessage());
        }  
    }   
}