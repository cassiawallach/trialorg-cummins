/************************************************************
Name:  CMI_APIAccountCreation
Copyright © 2019  Cummins
=============================================================
Purpose:                                                            
Requires the cummins customer id of Account and reutrn results as Response Type                           
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -    Harshini Basina        20/04/2017        INITIAL DEVELOPMENT  
1.1 -    Anupam Adhikari        01/05/2021       Made changes for creating account access feature.
1.2 -    Karthik Raj Golakaram  05/21/2021       Made changes for query to include Limits
1.3 -    Shubhangi Sardar       05/26/2021       Added DN Value Changes
*****************************************************/
/********************************************************************************
***********************************************************************************/ 

@RestResource(urlMapping='/Customer/*')
global class CMI_APIAccountCreation extends TriggerHandler{
    
    public static Boolean isFirstTime = true;
    //==============================================================================================
    // *** REST Post *** :  Requires the cummins customer id of Account and reutrn results as Response Type
    //===============================================================================================
    @HttpPost
    global static CMI_ResponseHandler Post(CustomerPayloadInfo CustomerPayloadInfo)
    {
        system.debug('request====' + CustomerPayloadInfo);
        string duplicate='';
        string appFeatureId = '';
        RestRequest req = RestContext.request;
        CMI_ResponseHandler response = new CMI_ResponseHandler();
        List<CMI_TSP__c> tsp;
        String Cid = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);           
        system.debug('CID value is==='+Cid);
        
        //String Cid = sInitialCid.replace('%0A','');
        //system.debug('CID value without %0A is-->'+Cid);
        
        System.debug('Value of the above url is'+(Cid!=null||Cid!=''));
        System.debug('Value with string comparision'+string.isEmpty(Cid));
        //List<Account> accUpdate=[Select id,name,CMI_Account_Status__c,CMI_CDA_Status__c from Account where CMI_CId__c=:Cid and Recordtypeid=:Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId() LIMIT 1];
        List<Account> accUpdate=[Select id,name,CMI_Account_Status__c,CMI_CDA_Status__c from Account 
                                 where CMI_CId__c=:Cid and 
                                 (Recordtypeid=:Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId() or Recordtypeid=:Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId()) LIMIT 1];
        System.debug('Accounts with the given sk is '+accUpdate);
        //Getting TSP deatils for Update
        if(!accUpdate.isEmpty()){
            tsp=[SELECT id,CMI_Account_Name__c,CMI_Telematics_ID__c,CMI_TSP_Id__c,CMI_TSP_Name__c FROM CMI_TSP__c WHERE CMI_Account_Name__c =:accUpdate[0].id];
            System.debug('Printing the datails of TSP to be Updated'+tsp);
            //check for email is registered as any other Primary contact while create only.
        }    
        Contact[] con=[select FirstName,LastName,Email,CMI_Contact_Type__c from Contact where Email=:CustomerPayloadInfo.Contactemail limit 1];
        if(con.size() > 0 && con[0].CMI_Contact_Type__c=='Primary'&& string.isEmpty(Cid)){
            //  duplicate='Contact already Registered';
        }
        //Changes for DA Portal start - @Anupam
        IAM_DA_Portal_TSP_Name__mdt tspData = [Select DeveloperName, IAM_CDA_Status__c, IAM_Contact_Status__c, IAM_App_Status__c,
                                               IAM_Indemnified__c, IAM_Moratorium__c, IAM_User_Feature_Access_Status__c
                                               FROM IAM_DA_Portal_TSP_Name__mdt WHERE masterLabel =: CustomerPayloadInfo.Tspname];
        string Fieldname = ValidateRequest(CustomerPayloadInfo,duplicate,accUpdate,Cid,tsp,tspData,con);
        system.debug('Fieldname====' + Fieldname);
        map<String,String> maphours=new map<String,String>();
        maphours.put('1 hour','1 hour');
        maphours.put('4 hours','4 hours');
        maphours.put('8 hours','8 hours');
        maphours.put('12 hours','12 hours');
        maphours.put('24 hours','1 day');
        maphours.put('48 hours','2 days');
        maphours.put('72 hours','3 days');
        maphours.put('No delay','No delay');
        if(Fieldname == '')
        {
            try
            {
                Savepoint sp = Database.setSavepoint(); 
                Account accObj = new Account();
                Contact conObj = new Contact();     
                try{
                    //Changes for DA Portal start - @Anupam
                    /*IAM_DA_Portal_TSP_Name__mdt tspData = [Select DeveloperName, IAM_CDA_Status__c, IAM_Contact_Status__c, IAM_App_Status__c,
                                                      IAM_Indemnified__c, IAM_Moratorium__c, IAM_User_Feature_Access_Status__c
                                                      FROM IAM_DA_Portal_TSP_Name__mdt WHERE masterLabel =: CustomerPayloadInfo.Tspname];*/
                    system.debug('tspData--->'+tspData);
                    TriggerHandler.bypass('IAM_AccountTriggerHandlerNew');
                    TriggerHandler.bypass('IAM_ContactTriggerHandlerNew');
                    TriggerHandler.bypass('IAM_AccountAccessTriggerHndlrNew');
                    TriggerHandler.bypass('IAM_UserAccessTriggerHandlerNew');
                    //Changes for DA Portal end -- @Anupam 
                    user u= [select username from user where id='00561000000rPnZ'];
                    accObj.Owner=u;
                    accObj.CMI_Cummins_Customer_Id__c = CustomerPayloadInfo.CumminsCustomerId;
                    accObj.Name = CustomerPayloadInfo.AccountName;
                    accObj.BillingCountry = CustomerPayloadInfo.CountryName;
                    
                    accObj.CMI_Care_Service_Level__c = CustomerPayloadInfo.CareServiceLevel;
                    accObj.CSS_Language__c = CustomerPayloadInfo.language;
                    // accObj.CMI_Region__c = CustomerPayloadInfo.region;
                    accObj.CMI_Region__c = CustomerPayloadInfo.region;
                    //accObj.CMI_CDA_Status__c = CustomerPayloadInfo.CDAStatus;
                    accObj.BillingStreet = CustomerPayloadInfo.AddressLine1;
                    accObj.CMI_Address2__c = CustomerPayloadInfo.AddressLine2;
                    accObj.CMI_Address3__c = CustomerPayloadInfo.AddressLine3;
                    accObj.BillingCity = CustomerPayloadInfo.City;
                    accObj.BillingState = CustomerPayloadInfo.StateName;
                    accObj.BillingPostalCode = CustomerPayloadInfo.Zipcode;                 
                    accObj.CMI_Cummins_Support_First_Name__c = CustomerPayloadInfo.CumminsSupportFirstName;
                    accObj.CMI_Cummins_Support_Last_Name__c = CustomerPayloadInfo.CumminsSupportLastName;
                    String strCumminsSupportEmail = '';
                    for(String strEmail : CustomerPayloadInfo.CumminsSupportEmail)
                    {
                        if(strCumminsSupportEmail != '')
                            strCumminsSupportEmail = strCumminsSupportEmail + ',' + strEmail;
                        else
                            strCumminsSupportEmail = strEmail;
                    }
                    accObj.CMI_Cummins_Support_Email__c = strCumminsSupportEmail;
                    accObj.CMI_Other_TSP__c = CustomerPayloadInfo.OtherTSP;
                    String strUrgentFaultNotificationEmail = '';
                    
                    for(String strEmail : CustomerPayloadInfo.UrgentFaultNotificationEmail)
                    {
                        if(strUrgentFaultNotificationEmail != '')
                            strUrgentFaultNotificationEmail = strUrgentFaultNotificationEmail + ',' + strEmail;
                        else
                            strUrgentFaultNotificationEmail = strEmail;
                    }
                    accObj.CMI_Urgent_Fault_Notification_Email__c = strUrgentFaultNotificationEmail;
                    
                    
                    //default value to no system if the fault notifications is empty
                    /*if(CustomerPayloadInfo.UrgentFaultNotification == null || CustomerPayloadInfo.UrgentFaultNotification == '')
                    {
                        
                        accObj.CMI_Urgent_Fault_Notification__c = 'No System';
                    }
                    else
                    {
                        accObj.CMI_Urgent_Fault_Notification__c = CustomerPayloadInfo.UrgentFaultNotification;
                    }
                    if(CustomerPayloadInfo.OtherFaultNotification == null || CustomerPayloadInfo.OtherFaultNotification == '' )
                    {
                        
                        accObj.CMI_Other_Fault_Notifications__c  = 'No System';
                    }
                    else
                    {
                        accObj.CMI_Other_Fault_Notifications__c = CustomerPayloadInfo.OtherFaultNotification;
                    }*/
                    
                    if(CustomerPayloadInfo.EmailFlag != null && CustomerPayloadInfo.EmailFlag == true)
                    {
                        accObj.CMI_Email_Flag__c = CustomerPayloadInfo.EmailFlag;
                        //accObj.CMI_Stop_Now__c =maphours.get(CustomerPayloadInfo.StopNow); //  maphours.get('0');
                        //accObj.CMI_Service_Now__c = maphours.get(CustomerPayloadInfo.ServiceNow);//maphours.get('0');
                        //accObj.CMI_Service_Soon__c = maphours.get(CustomerPayloadInfo.ServiceSoon); //maphours.get('0');
                    }
                    accObj.CMI_Urgent_Fault_Notification__c = 'No System';
                    accObj.CMI_Other_Fault_Notifications__c  = 'No System';
                    accObj.RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                    //added AccountSource as 'PC_API' as part of DA enhancement Infant care 
                    accObj.AccountSource = 'PC_API';
                    accObj.CMI_Indemnified__c =true;
                    
                    accObj.CMI_Customer_Equipment_Group__c = '';//CustomerPayloadInfo.CustomerEquipmentGroup;
                    accObj.CMI_Request_withdrawn__c = false;
                    //DA Portal changes(INC1523029) - @Anupam
                    if(string.isEmpty(Cid)){
                    accObj.Type='Customer';  
                        
                    System.debug('Account insert');
                    insert accObj;
                    
                    /*if(string.isEmpty(Cid))
                    {
                        if(CustomerPayloadInfo.Tspname =='PACCAR Solutions' )
                        { 
                            accObj.CMI_Moratorium__c = 'Yes';
                            accObj.CMI_Account_Status__c= 'Active-Indemnified';
                        }
                        else
                        {
                            
                            accObj.CMI_Moratorium__c = 'No';
                            accObj.CMI_Account_Status__c= 'Active';
                            
                        }
                        //  accObj.Description=CustomerPayloadInfo.comments;
                        //generate CDA only when the customer is not existing
                        
                        accObj.CMI_CDA_Status__c =' New Customer Request';
                        accObj.Type='Customer';  
                        
                        System.debug('Account insert');
                        insert accObj;*/
                    }else if((!string.isEmpty(Cid))&&(!accUpdate.isEmpty()))
                    {
                        
                        System.debug('Update of the Account is Happening and id is '+accUpdate[0].id);
                        accObj.id=accUpdate[0].id;
                        Account accUpdate1=[Select id,name,CMI_Account_Status__c from Account where CMI_CId__c=:Cid LIMIT 1];
                        System.debug('Accounts with the given sk with account status '+accUpdate1.CMI_Account_Status__c );
                        accObj.CMI_Account_Status__c=accUpdate1.CMI_Account_Status__c;
                        update accObj;      
                        system.debug('Updated Account Details'+  accObj);
                    }
                    
                    CMI_TSP__c tspObj = new CMI_TSP__c();                
                    tspObj.CMI_TSP_ID__c = CustomerPayloadInfo.tspCustRef;
                    tspObj.CMI_Telematics_ID__c =CustomerPayloadInfo.tspid;
                    tspObj.CMI_TSP_Name__c = CustomerPayloadInfo.Tspname;
                    tspObj.CMI_Account_Name__c = accObj.id;
                    
                    
                    if(string.isEmpty(Cid)){
                        System.debug('TSP insert');
                        insert tspObj;  
                    }else if((!string.isEmpty(Cid))&&(!accUpdate.isEmpty())){
                        tspObj.id=tsp[0].id;
                        update tspObj;
                    }                      
                    
                    
                    
                    conObj.firstName=CustomerPayloadInfo.ContactfirstName;
                    conObj.lastName=CustomerPayloadInfo.ContactlastName;
                    conObj.phone=CustomerPayloadInfo.ContactphoneNo;
                    conObj.CMI_User_Id__c=CustomerPayloadInfo.userId;
                    conObj.email=CustomerPayloadInfo.Contactemail;
                    conObj.Username__c=conObj.email;
                    conObj.RecordtypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                    conObj.Accountid = accObj.id;
                    conObj.IAM_DN_Value__c=IAM_Utility.getDNValue(conObj.Username__c,conObj.IAM_Person_Type__c);
                    //DA portal changes - @Anupam
                    conObj.IAM_Contact_Status__c = tspData.IAM_Contact_Status__c != ''? tspData.IAM_Contact_Status__c : System.Label.IAM_Status_Pending;
                    conObj.CMI_Contact_Type__c = 'Primary';
                    conObj.IAM_From_JIT_Execution__c = true;
                    //Condition to check if email sent is Dummy or not
                    /*Contact[] con1=[select Id,FirstName,LastName,Email,CMI_Contact_Type__c from Contact where Email=:CustomerPayloadInfo.Contactemail limit 1];
                    System.Debug('Printing dummy contact'+con1);
                    if(con1.size() > 0 && string.isEmpty(Cid)) {
                        String tspemail=tspObj.CMI_TSP_ID__c +'.'+tspObj.CMI_TSP_Name__c;
                        
                        String regex=('[^a-z/gA-Z0-9.]');
                        string m=tspemail.replaceAll(regex,'');
                        conObj.email=m+'@noemail.com';
                        system.debug('Dummy emaid id has been created'+conObj.email);
                        conObj.CMI_Flagged_E_mail_Address__c=CustomerPayloadInfo.Contactemail;
                        conObj.CMI_Dummy_Email__c=True;
                        system.debug('Dummy emaid id has been created'+conObj);
                    }*/
                    //added changes for email already exist DA Enhancement - @Anupam
                    /*if(tspData != null && tspData.IAM_Moratorium__c == 'Yes'){
                        String tspemail=tspObj.CMI_TSP_ID__c +'.'+tspObj.CMI_TSP_Name__c;
                        
                        String regex=('[^a-z/gA-Z0-9.]');
                        string m=tspemail.replaceAll(regex,'');
                        conObj.email=m+'@noemail.com';
                        system.debug('Dummy emaid id has been created'+conObj.email);
                        conObj.CMI_Flagged_E_mail_Address__c=CustomerPayloadInfo.Contactemail;
                        conObj.CMI_Dummy_Email__c=True;
                        system.debug('Dummy emaid id has been created'+conObj);                       
                    }*/
                    if(system.label.IAM_org_label!='.cso')
                    {
                        conObj.Username__c = conObj.Username__c + system.label.IAM_org_label; //Karthik changes this method for 77 UAT issue
                    }
                    if(CustomerPayloadInfo.Contactemail==CustomerPayloadInfo.CumminsCustomerId+CustomerPayloadInfo.Tspname+'@noemail.com')
                    {
                        //setting dummy value falg to true
                        conObj.CMI_Dummy_Email__c=True;
                    }
                    
                    //DA Portal changes after SIT demo - @Anupam
                    Contact[] con2=[select Id,FirstName,LastName,Email,CMI_Contact_Type__c, Username__c from Contact where Username__c=:conObj.Username__c OR Email=:CustomerPayloadInfo.Contactemail limit 1];
                    if(con2.size() > 0 && string.isEmpty(Cid)) {
                        if(tspData != null && tspData.IAM_Moratorium__c == 'Yes'){
                            String tspemail=tspObj.CMI_TSP_ID__c +'.'+tspObj.CMI_TSP_Name__c;                       
                            String regex=('[^a-z/gA-Z0-9.]');
                            string m=tspemail.replaceAll(regex,'');
                            conObj.email=m+'@noemail.com';
                            system.debug('Dummy emaid id has been created'+conObj.email);
                            conObj.CMI_Flagged_E_mail_Address__c=CustomerPayloadInfo.Contactemail;
                            conObj.CMI_Dummy_Email__c=True;
                            system.debug('Dummy emaid id has been created'+conObj);
                            conObj.Username__c=conObj.email;
                            if(system.label.IAM_org_label!='.cso')
                            {
                                conObj.Username__c = conObj.Username__c + system.label.IAM_org_label; //Karthik changes this method for 77 UAT issue
                            }
                        }                        
                    }
                    
                    
                    if(string.isEmpty(Cid)){ 
                        System.debug('Contact insert '+conObj);  
                        
                        insert conObj;
                        
                    }
                    
                    List<IAM_Contact_Provisioning__c> conFeatureAccess = new List<IAM_Contact_Provisioning__c>();
                    //Changes for DA Portal start- @Anupam
                    if(tspData != null && string.isEmpty(Cid)){
                        appFeatureId = createAccountFeature(accObj, tspData, CustomerPayloadInfo);
                        createUserFeature(conObj, appFeatureId, tspData, accObj.id);
                        
                    }else if(tspData != null && !string.isEmpty(Cid) && !accUpdate.isEmpty()){
                        List<IAM_Application__c> appFeature = [Select Id, IAM_Status__c, CMI_Moratorium__c, CMI_Indemnified__c, CMI_CDA_Status__c
                                                               from IAM_Application__c 
                                                               where IAM_Account_Name__c =: accObj.id and IAM_Application_Name__c =: 'Connected Solutions' limit 1];
                        system.debug('appFeature data--->'+appFeature);
                        if(appFeature.size() > 0){
                            conFeatureAccess = [Select Id from IAM_Contact_Provisioning__c
                                                where IAM_Account_Application__c =: appFeature[0].Id and IAM_Application_Name__c =: 'Connected Solutions' limit 1];
                            system.debug('conFeatureAccess data--->'+conFeatureAccess);
                            IAM_Application__c app = new IAM_Application__c();
                            app.Id = appFeature[0].Id;
                            app.IAM_Status__c = tspData.IAM_App_Status__c;
                            app.CMI_Moratorium__c = tspData.IAM_Moratorium__c;
                            app.CMI_Indemnified__c= tspData.IAM_Indemnified__c;
                            app.CMI_CDA_Status__c=tspData.IAM_CDA_Status__c;
                            system.debug('app feature data update--->'+app);
                            update app;
                        }else{
                            appFeatureId = createAccountFeature(accObj, tspData, CustomerPayloadInfo);
                        }
                        
                        if(conFeatureAccess.size() > 0){
                            IAM_Contact_Provisioning__c conProv = new IAM_Contact_Provisioning__c();
                            conProv.Id = conFeatureAccess[0].Id;
                            conProv.IAM_Status__c = tspData.IAM_User_Feature_Access_Status__c;
                            system.debug('user feature data update--->'+conProv);
                            update conProv;
                        }else{
                            Contact ConRec = [Select Id from Contact where Accountid =: accObj.id];
                            createUserFeature(ConRec, appFeatureId, tspData, accObj.id);
                        }
                    }
                    
                    //Changes for DA Portal end - @Anupam
                    
                    /*IAM_Contact_Provisioning__c Userapp = null;
                    Userapp = new IAM_Contact_Provisioning__c();
                    Userapp.IAM_Account_Application__c = osmAppID.id;
                    Userapp.IAM_Contact__c = conObj.id;
                    Userapp.IAM_Start_Date__c = System.today();
                    Userapp.IAM_End_Date__c = System.today()+365;
                    Userapp.IAM_Application_Name__c = osmAppID.IAM_Application_Name__c;
                    Userapp.IAM_Subscription_Name__c = osmAppID.IAM_Subscription_Name__c;
                    Userapp.IAM_Status__c = System.Label.IAM_Status_Active;
                    Userapp.recordtypeid =  Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(System.Label.IAM_OSM_App_Name).getRecordTypeId(); 
                    Userapp.IAM_Role__c = System.Label.IAM_OSM_ContPro_Default_Roles;
                    System.debug('conSolUserapp... ' + Userapp);
                    insert Userapp;*/
                    
                    if(conObj.id != null && accObj.CMI_Moratorium__c == 'Yes')
                    {
                        // sendContactemail(accObj,conObj);
                    }           
                    
                    if(string.isEmpty(Cid)){
                        
                        response.Message = 'Inserted Successfully';
                    }
                    
                    else if(!string.isempty(Cid)&&(!accUpdate.isEmpty())){
                        response.Message = 'Company Information Updated Successfully based on Customer Sk '+Cid;
                    }
                    
                    response.StatusCode = '200';
                    response.Status = 'Success';
                    response.Data = null;
                    system.debug('appFeatureId--->'+appFeatureId);
                    system.debug('accObj.id--->'+accObj.id);
                    system.debug('conObj.id--->'+conObj.id);
                    system.debug('accObj.CMI_Account_Status__c--->'+accObj.CMI_Account_Status__c);
                    system.debug('Cid--->'+Cid);
                    DoCallout(appFeatureId,accObj.id,conObj.id,accObj.CMI_Account_Status__c,Cid,tspData.IAM_Moratorium__c,tspData.IAM_Indemnified__c);
                }
                catch (System.DmlException e) {
                    cmiError(e.getMessage());
                    System.debug('Printing exception'+e);
                    System.debug('Printing Stackc Trace String'+e.getStackTraceString());
                    
                    //return response;
                        
                response=setResponse(e);    
                /* response.StatusCode = '404'; 
                 response.Status = 'error'; 
                 response.Data = null;  
                 for (Integer i = 0; i < e.getNumDml(); i++) {  
                     // Process exception here  
                     response.Message =  e.getDmlMessage(i);    
                 }*/
                    Database.rollback(sp);
                    
                    new IAM_ErrorHandling().createLog(new IAM_ErrorHandling.Error('CMI_APIAccountCreation',String.valueOf(response),String.valueOf(CustomerPayloadInfo),'CMI_ResponseHandler',e));
                    return response;
                    // return null;
                }  
                
                
            }
            catch (System.DmlException e) {
                cmiError(e.getMessage());
                
                
                    
                response=setResponse(e);    
               /* response.StatusCode = '404';  
                response.Status = 'error';  
                response.Data = null;   
                for (Integer i = 0; i < e.getNumDml(); i++) {   
                    // Process exception here   
                    response.Message =  e.getDmlMessage(i);     
                }*/
                new IAM_ErrorHandling().createLog(new IAM_ErrorHandling.Error('CMI_APIAccountCreation',String.valueOf(response),String.valueOf(CustomerPayloadInfo),'CMI_ResponseHandler',e));
                //sendmailToAdmin(CustomerPayloadInfo.AccountName,CustomerPayloadInfo.ContactfirstName,CustomerPayloadInfo.ContactLastName,CustomerPayloadInfo.Contactemail,response.Message);
            }            
        }
        else
        {
            response.StatusCode = '404';
            response.Status = 'error';
            response.Data = null;
            string tspexist = '';            
            response.Message = 'Fail : ' + Fieldname;
            NoRecordMatchException customException= new NoRecordMatchException('failed because of Custom validation '+response.Message);
            //sendmailToAdmin(CustomerPayloadInfo.AccountName,CustomerPayloadInfo.ContactfirstName,CustomerPayloadInfo.ContactLastName,CustomerPayloadInfo.Contactemail,response.Message);
            new IAM_ErrorHandling().createLog(new IAM_ErrorHandling.Error('CMI_APIAccountCreation',String.valueOf(response),String.valueOf(CustomerPayloadInfo),'CMI_ResponseHandler',customException));
        }
        return response;
    }
    
    public static CMI_ResponseHandler setResponse(exception e){ 
        CMI_ResponseHandler response=new CMI_ResponseHandler(); 
                response.StatusCode = '404';    
                response.Status = 'error';  
                response.Data = null;   
                if(!Test.isRunningTest()){  
                    for (Integer i = 0; i < e.getNumDml(); i++) {   
                    // Process exception here   
                    response.Message =  e.getDmlMessage(i);     
                }   
                }else{  
                    response.Message = 'error'; 
                }   
       return response;             
    }

    private static string ValidateRequest(CustomerPayloadInfo customerPayloadObj,string conemail,List<Account> accnt,string cid,List<CMI_TSP__c> TSP, IAM_DA_Portal_TSP_Name__mdt tspData, Contact[] con)
    {
        map<String,String> maphours=new map<String,String>();
        maphours.put('1 hour','1 hour');
        maphours.put('4 hours','4 hours');
        maphours.put('8 hours','8 hours');
        maphours.put('12 hours','12 hours');
        maphours.put('24 hours','1 day');
        maphours.put('48 hours','2 days');
        maphours.put('72 hours','3 days');
        maphours.put('No delay','No delay');
        
        string Fieldname = '';
        //To check if account can be updated or not
        System.debug('Value of the condition is '+((accnt.isEmpty())&&(cid!=null || cid!='')));
        System.debug('value of Cid conditoin is '+ (cid!=null || cid!=''));
        System.debug('value of is empty conditoin is '+ (accnt.isEmpty()));
        
        if((accnt.isEmpty())&&(!string.isEmpty(Cid))){
            Fieldname=Fieldname+'Account with provided Customer SK is not present,';
        }
        
        //Contact information Check while create only.
        if(string.isEmpty(Cid))
        {
            if(customerPayloadObj.ContactfirstName == null || customerPayloadObj.ContactfirstName.trim() == '')  
                
            {
                Fieldname = Fieldname + 'ContactfirstName is required, ';
            }
            
            if(customerPayloadObj.ContactfirstName != null && customerPayloadObj.ContactfirstName.length()> 40) 
            {
                Fieldname = Fieldname + 'ContactfirstName maximum length is 40 characters, ';
            }
            
            
            if(customerPayloadObj.ContactlastName == null || customerPayloadObj.ContactlastName.trim() == '')
            {
                Fieldname = Fieldname + 'ContactlastName is required, ';
            }
            
            if(customerPayloadObj.ContactlastName != null && customerPayloadObj.ContactlastName.length()> 80)
            {
                Fieldname = Fieldname + 'ContactlastName maximum length is 80 characters, ';
            }
            
            if(customerPayloadObj.ContactphoneNo == null || customerPayloadObj.ContactphoneNo.trim() == '')
            {
                Fieldname = Fieldname + 'ContactphoneNo is required, ';
            }
            
            if(customerPayloadObj.ContactphoneNo != null && customerPayloadObj.ContactphoneNo.length()> 50)
            {
                Fieldname = Fieldname + 'ContactphoneNo maximum length is 50 characters, ';
            }
            
            if(customerPayloadObj.Contactemail == null || customerPayloadObj.Contactemail == '')
            {
                Fieldname = Fieldname + 'Contact email is required, ';
            }
            if(customerPayloadObj.Contactemail != null && customerPayloadObj.Contactemail != '')
            {
                if(conemail!=null&&conemail=='Contact already Registered'){
                    Fieldname=Fieldname+conemail + ', ';
                }
                
                if(!validateEmail(customerPayloadObj.Contactemail.split(',')))
                    Fieldname = Fieldname + 'Provide a valid Contactemail, ';
                if(customerPayloadObj.Contactemail != null && customerPayloadObj.Contactemail.length() > 100)
                {
                    Fieldname = Fieldname + 'Contact email maximum length is 100 characters, ';
                }    
                
            }
            //DA portal enhancement changes - @Anupam
            if(con.size() > 0){
                if(tspData != null && tspData.IAM_Moratorium__c == 'No'){
                    Fieldname = Fieldname + 'User already exists, ';
                }
                
            }
        }
        //Contact information Check Complete.
        
        
        if(customerPayloadObj.CumminsCustomerId == null || customerPayloadObj.CumminsCustomerId.trim() == '')
        {
            Fieldname = Fieldname + 'CumminsCustomerId is required, ';            
        }
        if(customerPayloadObj.CumminsCustomerId != null && customerPayloadObj.CumminsCustomerId.length() > 25)
        {
            Fieldname = Fieldname + 'CumminsCustomerId maximum length is 25 characters., ';
        }
        
        if(customerPayloadObj.AccountName == null || customerPayloadObj.AccountName.trim() == '')
        {
            Fieldname = Fieldname + 'AccountName is required, ';
        }
        
        if(customerPayloadObj.AccountName != null && customerPayloadObj.AccountName.length() > 50)
        {
            Fieldname = Fieldname + 'AccountName maximum length is 50 characters., ';
        }
        
        
        if(customerPayloadObj.CustomerEquipmentGroup == null)
        {
            Fieldname = Fieldname + 'CustomerEquipmentGroup is required, ';
        }
        
        if(customerPayloadObj.CumminsSupportFirstName != null && customerPayloadObj.CumminsSupportFirstName.length() > 25)
        {
            Fieldname = Fieldname + 'CumminsSupportFirstName maximum length is 25 characters., ';
        }
        if(customerPayloadObj.CumminsSupportLastName != null && customerPayloadObj.CumminsSupportLastName.length() > 25)
        {
            Fieldname = Fieldname + 'CumminsSupportLastName maximum length is 25 characters, ';
        }
        
        if(customerPayloadObj.CareServiceLevel == null || customerPayloadObj.CareServiceLevel == '')
        {
            Fieldname = Fieldname + 'CareServiceLevel is required, ';
        }
        if(customerPayloadObj.CareServiceLevel != null && customerPayloadObj.CareServiceLevel != '')
        {
            Set<string> tmplist = getPicklistValues('CMI_Care_Service_Level__c','Account');
            System.debug('***************'+tmplist );
            if(!tmplist.contains(customerPayloadObj.CareServiceLevel))
            {
                Fieldname = Fieldname + 'Provide a valid CareServiceLevel, ' ;
            }
        }
        if(customerPayloadObj.CountryName == null || customerPayloadObj.CountryName.trim() == '')
        {
            Fieldname = Fieldname + 'CountryName is required, ';
        }
        if(customerPayloadObj.CountryName != null && customerPayloadObj.CountryName.trim() != '')
        {
            Set<string> tmplist = getPicklistValues('BillingCountryCode','Account');
            System.debug('***************'+tmplist );
            String s=(customerPayloadObj.CountryName).tolowercase();
            String s1=s.subString(0 ,1).ToUpperCase()+s.subString(1);
            Boolean result = tmplist.equals(customerPayloadObj.CountryName);
            system.debug('Country name'+result);
            if(!tmplist.contains(customerPayloadObj.CountryName.tolowercase()))
            {
                Fieldname = Fieldname + 'Provide a valid CountryName, ' ;
            }
            
        }
        
        
        if(customerPayloadObj.AddressLine1 == null || customerPayloadObj.AddressLine1.trim() == '')
        {
            Fieldname = Fieldname + ' AddressLine1 is required, ';
        }
        
        if(customerPayloadObj.AddressLine1 != null && customerPayloadObj.AddressLine1.length() > 100)
        {
            Fieldname = Fieldname + 'AddressLine1 maximum length is 100 characters., ';
        }
        
        
        if(customerPayloadObj.City == null || customerPayloadObj.City.trim() == '')
        {
            Fieldname = Fieldname + 'City is required, ';
        }
        
        if(customerPayloadObj.City != null && customerPayloadObj.City.length() > 100)
        {
            Fieldname = Fieldname + 'City maximum length is 100 characters., ';
        }
        
        if(customerPayloadObj.StateName == null || customerPayloadObj.StateName.trim() == '')
        {
            Fieldname = Fieldname + 'StateName is required';
        }
        {
            if(customerPayloadObj.StateName != null && customerPayloadObj.StateName.trim() != '')
            {
                Set<string> tmplist = getPicklistValues('BillingStateCode','Account');
                System.debug('***************'+tmplist );
                String s=(customerPayloadObj.StateName).tolowercase();
                String s1=s.subString(0 ,1).ToUpperCase()+s.subString(1);
                
                system.debug('state'+s1);
                
                if(!tmplist.contains(s1.tolowercase()))
                {
                    Fieldname = Fieldname + 'Provide a valid StateName,' ;
                }
            }
            
        }
        if(customerPayloadObj.Zipcode == null || customerPayloadObj.Zipcode.trim() == '')
        {
            Fieldname = Fieldname + 'Zipcode is required, ';
        }
        
        if(customerPayloadObj.Zipcode != null &&  customerPayloadObj.Zipcode.length()> 40)
        {
            Fieldname = Fieldname + 'Zipcode maximum length is 40 characters, ';
        }
        
       /* if(customerPayloadObj.EmailFlag != null || customerPayloadObj.EmailFlag == true)
        {
            if(customerPayloadObj.StopNow == null)
            {
                Fieldname = Fieldname + 'StopNow is required, ';
            }
            if(customerPayloadObj.StopNow != null && customerPayloadObj.StopNow != '')
            {
                string StrStopNow = maphours.get(customerPayloadObj.StopNow);
                Set<string> tmplist = getPicklistValues('CMI_Stop_Now__c','Account');
                if(!tmplist.contains(StrStopNow))
                {
                    Fieldname = Fieldname + 'Provide a valid StopNow, ' ;
                }
            }
            if(customerPayloadObj.ServiceNow == null)
            {
                Fieldname = Fieldname + 'ServiceNow is required, ';
            }
            if(customerPayloadObj.ServiceNow != null && customerPayloadObj.ServiceNow != '')
            {
                string StrServiceNow = maphours.get(customerPayloadObj.ServiceNow);
                Set<string> tmplist = getPicklistValues('CMI_Service_Now__c','Account');
                if(!tmplist.contains(StrServiceNow))
                {
                    Fieldname = Fieldname + 'Provide a valid ServiceNow, ' ;
                }
            }
            if(customerPayloadObj.ServiceSoon== null)
            {
                Fieldname = Fieldname + 'ServiceSoon is required, ';
            }
            if(customerPayloadObj.ServiceSoon != null && customerPayloadObj.ServiceSoon != '')
            {
                string StrserviceSoon = maphours.get(customerPayloadObj.ServiceSoon);
                Set<string> tmplist = getPicklistValues('CMI_Service_Soon__c','Account');
                if(!tmplist.contains(StrserviceSoon))
                {
                    Fieldname = Fieldname + 'Provide a valid ServiceSoon,' ;
                }
            }
        }*/
        
        if(customerPayloadObj.tspid == null || customerPayloadObj.tspid.trim() == '')
        {
            
            Fieldname = Fieldname + 'Tspid is required, ';
        }
        
        if(customerPayloadObj.tspid != null && customerPayloadObj.tspid.length()> 12)
        {
            Fieldname = Fieldname + 'Tspid  maximum length is 12 characters, ';
            
        }
        
        if(customerPayloadObj.tspCustRef == null || customerPayloadObj.tspCustRef.trim() == '')
        {
            Fieldname = Fieldname + 'tspCustRef is required, ';
        }
        if(customerPayloadObj.tspCustRef != null && customerPayloadObj.tspCustRef.length()> 50)
        {
            Fieldname = Fieldname + 'tspCustRef  maximum length is 50 characters, ';
        }
        
        if(customerPayloadObj.Tspname == null || customerPayloadObj.Tspname.trim() == '')
        {
            Fieldname = Fieldname + 'Tspname';
            
        }
        if(customerPayloadObj.Tspname != null && customerPayloadObj.Tspname.trim() != '')
        {
            Set<string> tmplist = getPicklistValues('CMI_TSP_Name__c','CMI_TSP__c');
            System.debug('tmplist***************'+tmplist );
            if(!tmplist.contains(customerPayloadObj.Tspname))
            {
                Fieldname = Fieldname + 'Provide a valid Tspname ,' ;
            }
            
        }
        //Checking for TSP details while update.because, only TSP name,TSP Id, Custreference of TSP will be the unique values.
        if(!string.isEmpty(Cid)){
            
            
            if(customerPayloadObj.tspid != null && customerPayloadObj.tspid!=TSP[0].CMI_Telematics_ID__c)
            {
                Fieldname = Fieldname + 'Tspid  has changed from '+TSP[0].CMI_Telematics_ID__c+' to '+customerPayloadObj.tspid+', ';
                
            }
            
            
            if(customerPayloadObj.tspCustRef != null && customerPayloadObj.tspCustRef!=TSP[0].CMI_TSP_Id__c)
            {
                Fieldname = Fieldname + 'tspCustRef has changed from '+TSP[0].CMI_TSP_Id__c+' to '+customerPayloadObj.tspCustRef+',';
            }
            
            
            if(customerPayloadObj.Tspname != null && customerPayloadObj.Tspname!=TSP[0].CMI_TSP_Name__c)
            {
                Fieldname=Fieldname+'TSP name has changed from '+TSP[0].CMI_TSP_Name__c+' to '+customerPayloadObj.Tspname+', '; 
                
            }
            
        }  
        //End TSP update validation
        
        if(customerPayloadObj.region == null || customerPayloadObj.region.trim() == '')
        {
            Fieldname = Fieldname + 'region is required, ';
        }
        if(customerPayloadObj.region != null && customerPayloadObj.region.trim() != '')
        {
            Set<string> tmplist = getPicklistValues('CMI_Region__c','Account');
            System.debug('***************'+tmplist );
            if(!tmplist.contains(customerPayloadObj.region))
            {
                Fieldname = Fieldname + 'Provide a valid Region,' ;
            }
        }
        
        if(customerPayloadObj.language == null || customerPayloadObj.language.trim() == '')
        {
            Fieldname = Fieldname + 'language is required, ';
        }
        if(customerPayloadObj.language != null && customerPayloadObj.language.trim() != '')
        {
            Set<string> tmplist = getPicklistValues('CSS_Language__c','Account');
            System.debug('***************'+tmplist );
            if(!tmplist.contains(customerPayloadObj.language))
            {
                Fieldname = Fieldname + 'Provide a valid language,' ;
            }
        }
        if(customerPayloadObj.CumminsSupportEmail != null && customerPayloadObj.CumminsSupportEmail.size()>0)
        {
            if(!validateEmail(customerPayloadObj.CumminsSupportEmail))
                Fieldname = Fieldname + 'Provide a valid  CumminsSupportEmail, ';
            
            for(String strEmail : customerPayloadObj.CumminsSupportEmail)
            {
                if( strEmail.length() > 100)
                    Fieldname = Fieldname + 'CumminsSupportEmail maximum length is 100 characters, ';
            }
        }
        if(customerPayloadObj.UrgentFaultNotificationEmail != null && customerPayloadObj.UrgentFaultNotificationEmail.size()>0 )
        {
            if(!validateEmail(customerPayloadObj.UrgentFaultNotificationEmail))
                Fieldname = Fieldname + 'Provide a valid UrgentFaultNotificationEmail, ';
            
            for(String strEmail : customerPayloadObj.UrgentFaultNotificationEmail)
            {
                if(strEmail.length() > 100)
                    Fieldname = Fieldname + 'UrgentFaultNotificationEmail maximum length is 100 characters, ';
            }
            
        }
        
        if(customerPayloadObj.UrgentFaultNotification != null && customerPayloadObj.UrgentFaultNotification.trim() != '')
        {
            Set<string> tmplist = getPicklistValues('CMI_Urgent_Fault_Notification__c','Account');
            System.debug('***************'+tmplist );
            if(!tmplist.contains(customerPayloadObj.UrgentFaultNotification))
            {
                Fieldname = Fieldname + 'Invalid UrgentFaultNotification Picklist Name :  ' +customerPayloadObj.UrgentFaultNotification + ',' ;
            }
        }
        
        if(customerPayloadObj.OtherFaultNotification != null && customerPayloadObj.OtherFaultNotification.trim() != '')
        {
            Set<string> tmplist = getPicklistValues('CMI_Other_Fault_Notifications__c','Account');
            System.debug('***************'+tmplist );
            if(!tmplist.contains(customerPayloadObj.OtherFaultNotification))
            {
                Fieldname = Fieldname + 'Provide a valid OtherFaultNotification,' ;
            }
        }
        if(customerPayloadObj.userId!=null)
        {
            if(customerPayloadObj.userId.length()> 150)
            {
                Fieldname = Fieldname + 'Tspid  maximum length is 150 characters, ';
                
            }
        }
        String tspnameErrorMessage = '';
        if(customerPayloadObj.Tspname != null && customerPayloadObj.Tspname.trim() != '' && customerPayloadObj.tspid != null && customerPayloadObj.tspid.trim() != '' && customerPayloadObj.AccountName != null && customerPayloadObj.AccountName.trim() != '')
        {
            List<Account> lstaccounts = [select id from Account where Name=:customerPayloadObj.AccountName];
            System.debug('lstaccounts***************'+lstaccounts );
            if(lstaccounts.size() > 0)
            {
                Set<id> setaccids = new Set<id>();
                for(Account acc:lstaccounts)
                {
                    setaccids.add(acc.id);
                }
                
                List<CMI_TSP__c> lstTsp = [select id from CMI_TSP__c where CMI_TSP_Name__c=:customerPayloadObj.Tspname and CMI_TSP_ID__c =: customerPayloadObj.tspid and CMI_Account_Name__c In:setaccids];
                System.debug('lstTsp***************'+lstTsp );
                if(lstTsp.size() > 0 && string.isEmpty(cid))
                {
                    
                    tspnameErrorMessage = 'TSP ' +customerPayloadObj.Tspname + ' already exists for this Account: ' + customerPayloadObj.AccountName;
                }
            }
        }
        if(Fieldname != '')
        {
            //Fieldname = ' Required Fields are missing ' + Fieldname;
            if(tspnameErrorMessage != '')
            {
                Fieldname = Fieldname + tspnameErrorMessage; 
            }
            system.debug('Inside Fieldname====' + Fieldname);        
            Fieldname = Fieldname.removeEnd(', ');
        }
        if(Fieldname == '' && tspnameErrorMessage != '')
        {
            Fieldname = tspnameErrorMessage;
        }
        
        return Fieldname ;
    }
    public static Boolean validateEmail(List<String> lstemails) {      
        Boolean res = true;
        
        
        
        system.debug('lstemails==' + lstemails);        
        for(string email: lstemails)        
        {
            system.debug('email==' + email); 
            String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
            Pattern MyPattern = Pattern.compile(emailRegex);        
            Matcher MyMatcher = MyPattern.matcher(email);       
            if (!MyMatcher.matches())       
                res = false;        
            
            system.debug('res==' + res);            
        }       
        system.debug('res==' + res);        
        return res;         
        
        
    }    
    
    
    //Adding custom Exception sub-class 
    public class NoRecordMatchException extends Exception {}    
    
    public static void cmiError(String msg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Source__c='CS';
        errObj.Error_Description__c = msg;
        
        errObj.Source__c='IDENTITY';
        //errObj.Error_Type__c='There are no customers associated with the  Id:CId';
        errObj.Error_Description__c = msg;
        errObj.Processed_Data__c=msg;
        
        insert errObj;
    }
    global class CMI_ResponseHandler {
        
        //List of custom attributes that we want to check the status of the org
        public String Status {get; set;}
        public List<sObject> Data {get;set;}
        public String Message {get;set;}
        public String StatusCode {get; set;}
        
        
    }
    Public static Set<String> getPicklistValues(string fieldName,String objectName)
    {
        Set<String> setPickvals=new Set<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values) { 
            if(fieldName == 'BillingCountryCode' || fieldName=='BillingStateCode'){
                setPickvals.add(a.getLabel().tolowercase());
            }else{  
                setPickvals.add(a.getLabel());
            }
        }
        return setPickvals;
    }
    global class CustomerPayloadInfo{
        
        public string CumminsCustomerId{set;get;}
        public string AccountName{set;get;}
        public string CountryName{set;get;}
        public string AddressLine1{set;get;}
        public string AddressLine2{set;get;}
        public string AddressLine3{set;get;}
        public string City{set;get;}
        public string StateName{set;get;}
        public string Zipcode{set;get;}
        public string ContactfirstName{set;get;}
        public string ContactlastName{set;get;}
        public string ContactphoneNo{set;get;}
        public string Contactemail{set;get;}
        public string PrimaryContactemailaddress{set;get;}
        public string PrimaryContactPhone{set;get;}
        public string CumminsSupportFirstName{set;get;}
        public string CumminsSupportLastName{set;get;}
        public List<String> CumminsSupportEmail{set;get;}
        // public string TelematicsServiceProvider{set;get;}
        public string OtherTsp{set;get;}
        public string UrgentFaultNotification{get;set;}
        public List<String> UrgentFaultNotificationEmail{get;set;}
        public string OtherFaultNotification{get;set;}
        public boolean EmailFlag {set;get;}
        public string StopNow{get;set;}
        public string ServiceNow{get;set;}
        public string ServiceSoon{get;set;}
        public String tspid{set;get;}
        public String Tspname{set;get;}
        public string language{set;get;}
        public string CareServiceLevel{set;get;}
        public string region{set;get;}
        public string AccountStatus{set;get;}
        public string CDAStatus{set;get;}
        public string CustomerEquipmentGroup{get;set;}
        public string CId{get;set;}
        public boolean UserNotCreated{set;get;}
        public boolean dummyEmail{set;get;}
        public string comments{set;get;}
        public String tspCustRef{set;get;}
        public String userId{set;get;}
        
    }  
    public static void sendmailToAdmin(string accName,string ContactFirstName,String ConLastName,String ContactEmail,string errormessage){
        
        try{
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        String[] toAddresses = new String[] {'harshini922@gmail.com'}; 
            String[] ccAddresses = new String[] {'harshini922@gmail.com'};
                //String[] ccAddresses = new String[] {'ml237@cummins.com'};
                mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        
        mail.setSenderDisplayName('Salesforce Support');
        mail.setSubject('Account not created');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setHtmlBody('Account Details:<br/><b> AccountName:</b>' + accName +' <br/><b> FirstName:</b>' + ContactFirstName +' <br/><b>LastName:</b>'+ConLastName+' </b><br/><b>MailId:</b>'+ContactEmail+'<br/><br/>' + errormessage+'<br/><br/><br/> Thanks,<br/> Salesforce');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        }catch(exception ex){
            cmiError(ex.getMessage());
            system.debug(ex.getLineNumber()+ ': >' + ex.getMessage()+ ': >' + ex.getStackTraceString());
        }
        
    }  
    @future(callout=true)
    private static void DoCallout(String appFeatureId,String accid,String conid,string Status,string CId, String sMoratorium, Boolean bIndemnified)
    {
        set<id> conIds = new Set<id>();
        List<Contact> objConRec = new List<contact>();
        List<Id> lstIds= new List<id>();
        Account accObj = [SELECT Id,Name,CMI_Moratorium__c,CMI_Account_Status__c,CMI_CDA_Status__c,CMI_Indemnified__c,CMI_Account_Num__c FROM Account WHERE Id =:accid];
        System.debug('Account info in callout method is'+accObj);
        List<Contact> conObj=[SELECT Id,Username__c,IAM_Person_Type__c,IAM_Contact_Status__c,email,LastName,FirstName,CMI_User_not_Created__c,CMI_Dummy_Email__c FROM Contact WHERE Id =:conid];
        System.debug('Contact info in callout method is'+conObj);
        
        
            for(Contact con: conObj) {
                if(con.IAM_Contact_Status__c == 'Active') {
                    //added by vineet
             con.IAM_DN_Value__c=IAM_Utility.getDNValue(con.Username__c,con.IAM_Person_Type__c);
                    conIds.add(con.Id);
                }
            }
        system.debug('conIds--->'+conIds);
        //Replacing static varible 'Status' with the account Status field in the send to pc parameters since its first time send to pc we will
        //be getting same status present in record at the time of update or create.
        String strResponse=CMI_CompanyInformation.CalloutResponseContents(appFeatureId, accid,accObj.CMI_Account_Status__c,'Send To PC');
        System.debug('Response from the API class when it class Send to PC'+strResponse);
        // String Responce = CMI_CompanyInformation.CalloutResponseContents(accid,'Active','Generate CDA'); 
        // String strResponse = CMI_CdaHttpRest.send(accid,'Generate CDA');
        if(String.isempty(CId))
        {
            //DA portal changes - @Anupam
            //if((strResponse =='successfull'||strResponse =='OK')&&(conObj[0].CMI_Dummy_Email__c==false) && accObj.CMI_Moratorium__c == 'No' && accObj.CMI_Indemnified__c == true){
            if((strResponse =='successfull'||strResponse =='OK')&&(conObj[0].CMI_Dummy_Email__c==false) && sMoratorium == 'No' && bIndemnified == true){
                System.debug('Enetered CDA calling clause');
                accObj.CMI_CDA_Status__c= 'Sent to Customer';
                CMI_CdaHttpRest_old.send(accid,'Generate Service Agreement');
            }
            else
            {
                accObj.CMI_CDA_Status__c= 'New customer request'; 
            }
            system.debug('accObj==DoCallout==' + accObj);
            try{  
                if((accObj.CMI_Moratorium__c == 'No')&&(conObj[0].CMI_Dummy_Email__c==false))
                //if((sMoratorium == 'No')&&(conObj[0].CMI_Dummy_Email__c==false))
                {
                    System.debug('Entered User generation Clause');
                    String strResponse1=CMI_clsGenerateUserIdOnAccount.generateUserId(accObj.id,'CMI_APIAccountCreation');
                    System.debug('Response from the API class when it class Send to PC'+strResponse1);
                    if(strResponse1=='User succesfully generated'||strResponse=='User succesfully generated')
                    {
                        //List<User> U=[Select id from User where CompanyName=:accObj.Name];
                        
                        accObj.CMI_Account_Status__c='Active';
                        for(User U :[Select id from User where CompanyName=:accObj.Name AND ContactId=:conObj[0].id and email=:conObj[0].email ])
                        {
                            lstIds.add(U.id);
                        }
                        try {
                            for(string userid:lstIds){
                                system.resetpassword(userid,true);
                                // sendmailTableauID('keerthy.Gurumurthy@cummins.com',accObj.id,conObj[0].Id);
                                Account a1= [select id from account where id =: accid];
                                Contact c=[select id, name,CMI_IsActive__c from Contact where Contact.AccountId=:a1.id];
                                c.CMI_IsActive__c=true;
                                //        sendmailTableauID(a1.id,c.id); 
                            }
                        } catch (Exception ce) {
                            //ce.printStackTrace();
                        }
                        
                    }else
                    {
                        System.debug('String Response is ======'+strResponse1);
                        //Setting User not created flag on the Contact Object because of the error in user creation.
                        conObj[0].CMI_User_not_Created__c=True;
                        cmiError(strResponse1);
                        //Apex email class to send email to admin to notify that user is not created.
                        string Erroremail=strResponse1+'API Acoount Creation';
                        
                        CMI_CreateUsersHelper.sendmailToAdmin(conObj,Erroremail);
                    }
                    //DA Portal changes for creating user record -  @Anupam
                }else if(sMoratorium == 'No'&& bIndemnified == True && conObj[0].CMI_Dummy_Email__c==false && conIds.size() >0){
                        system.debug('inside user creation else if');
                        objConRec = IAM_contactHelperClass.getContactForUser(conIds);
                    String sReturnValue = IAM_CreateUser.CreateUser(objConRec); 
                        system.debug('sReturnValue--->'+sReturnValue);
                    if(sReturnValue=='OK')
                    {
                        //List<User> U=[Select id from User where CompanyName=:accObj.Name];
                        
                        accObj.CMI_Account_Status__c='Active';
                        for(User U :[Select id,CMI_Customer_List__c from User where CompanyName=:accObj.Name AND ContactId=:objConRec[0].id and email=:objConRec[0].email ])
                        {
                            lstIds.add(U.id);
                            conObj[0].IAM_Contact_Owner__c = U.Id;
                            
                        }
                        system.debug('lstIds--->'+lstIds);
                        
                        try {
                            for(string userid:lstIds){
                                system.resetpassword(userid,true);
                                // sendmailTableauID('keerthy.Gurumurthy@cummins.com',accObj.id,conObj[0].Id);
                                Account a1= [select id from account where id =: accid];
                                Contact c=[select id, name,CMI_IsActive__c from Contact where Contact.AccountId=:a1.id];
                                c.CMI_IsActive__c=true;
                                //        sendmailTableauID(a1.id,c.id); 
                            }
                        } catch (Exception ce) {
                            //ce.printStackTrace();
                        }
                        
                    }else
                    {
                        System.debug('String Response is ======'+sReturnValue);
                        //Setting User not created flag on the Contact Object because of the error in user creation.
                        conObj[0].CMI_User_not_Created__c=True;
                        cmiError(sReturnValue);
                        //Apex email class to send email to admin to notify that user is not created.
                        string Erroremail=sReturnValue+'API Acoount Creation';
                        
                        CMI_CreateUsersHelper.sendmailToAdmin(conObj,Erroremail);
                    }
                }
            }
            
            catch (System.DmlException e) {
                cmiError(e.getMessage());
                //  Database.rollback(sp); 
                //  accObj= accObj.clone(false);
                // return null;
            }  
            
            Update conObj;
        } 
        system.debug('Newly updated account details'+accObj);
        update accObj;                       
    }
    
    
    
    public static void sendContactemail(Account acc,Contact newcon)
    {
        
        
        EmailTemplate template=new EmailTemplate ();
        template = [SELECT id FROM EmailTemplate WHERE name = 'CMI_Moratorium_Period'];
        
        String[] BCCAddresses =new List<String>();
        String[] toAddresses =new List<String>();
        toAddresses.add(newcon.Email); 
        BCCAddresses.add(system.label.CMI_BCCNotification_Email);
        system.debug('BCCAddresses  '+BCCAddresses );
        //KG added
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
        
        Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
        //KG add
        for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) 
        {
            if(owa.Address.contains('noreply')) 
                mail1.setOrgWideEmailAddressId(owa.id); 
        }
        mail1.setTargetObjectId(newcon.id);
        system.debug('newCon.id'+newCon.id);
        mail1.setTemplateId(template.id);
        
        //mail1.setSenderDisplayName(u.Name);
        //mail1.setReplyTo('noreply@salesforce.com');
        mail1.setWhatId(acc.id);
        system.debug('Account id'+acc.id);
        mail1.setTreatTargetObjectAsRecipient(false); 
        mail1.setToAddresses(toAddresses);
        //mail1.setBccAddresses(BCCAddresses);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1 });   
        
        
    }
    
    public static string createAccountFeature(Account accObj,IAM_DA_Portal_TSP_Name__mdt tspData, CustomerPayloadInfo customerPayloadObj){
        system.debug('Inside createAccountFeature method');
        String AccountFeatureId = '';
        App_Mapping__c appMap =[Select IAM_Application_Name__c,IAM_Default_Role__c from App_Mapping__c where Name =:System.Label.IAM_AppName_ConnectedSolutions LIMIT 1]; //Modified by Karthik -05/18/2021
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Account_Name__c = accObj.id;                
        app.IAM_Subscription_End_Date__c = Date.newInstance(2199, 12, 31);
        app.IAM_Application_Name__c = System.Label.IAM_AppName_ConnectedSolutions;
        app.IAM_Role__c = appMap.IAM_Default_Role__c;
        //app.CMI_Indemnified__c= true;
        app.IAM_Source__c='PC_API';                   
        //if(CustomerPayloadInfo.Tspname =='PACCAR Solutions' ){ 
        app.IAM_Status__c = tspData.IAM_App_Status__c;
        app.CMI_Moratorium__c = tspData.IAM_Moratorium__c;
        app.CMI_Indemnified__c= tspData.IAM_Indemnified__c;
        //}else{
        //app.IAM_Status__c = System.Label.IAM_Status_Pending;
        //app.CMI_Moratorium__c = 'No';
        //app.CMI_Indemnified__c=true;
        //}                
        app.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(System.Label.IAM_AppName_ConnectedSolutions).getRecordTypeId();
        /*if(String.isNotBlank(customerPayloadObj.urgentFaultNotification)){
          app.CMI_Urgent_Fault_Notification__c=customerPayloadObj.urgentFaultNotification;    
        }else{
            app.CMI_Urgent_Fault_Notification__c='No System';
        }*/
        /*app.CMI_Stop_Now__c=customerPayloadObj.stopNow;
        app.CMI_Service_Soon__c=customerPayloadObj.serviceSoon;
        app.CMI_Service_Now__c=customerPayloadObj.serviceNow;*/ //-Karthik Made changes while testing--5/7/2021
        app.CMI_Urgent_Fault_Notification__c='No System';
        app.CMI_CDA_Status__c=tspData.IAM_CDA_Status__c;
        system.debug('tspData.IAM_CDA_Status__c--->'+tspData.IAM_CDA_Status__c);
        system.debug('app.CMI_CDA_Status--->'+app.CMI_CDA_Status__c);
        /*if(String.isNotBlank(customerPayloadObj.otherFaultNotification)){
          app.CMI_Other_Fault_Notifications__c=customerPayloadObj.otherFaultNotification;    
        }else{
           app.CMI_Other_Fault_Notifications__c='No System';     
        }*/
        app.CMI_Other_Fault_Notifications__c='No System';
        app.CMI_Email_Flag__c=customerPayloadObj.emailFlag;
        app.IAM_From_JIT_Execution__c=true;
        for(string objstr :customerPayloadObj.urgentFaultNotificationEmail){
            if(app.CMI_Urgent_Fault_Notification_Email__c!= Null || app.CMI_Urgent_Fault_Notification_Email__c!= ''){
                app.CMI_Urgent_Fault_Notification_Email__c=objstr;
            }
            else{
                app.CMI_Urgent_Fault_Notification_Email__c= app.CMI_Urgent_Fault_Notification_Email__c+','+objstr;
            }
        }
        System.debug('Account access app insert'+app);
        insert app;
        AccountFeatureId = app.Id;
        
        return AccountFeatureId;
        
    }
    
    public static void createUserFeature(Contact conObj,String appFeatureId, IAM_DA_Portal_TSP_Name__mdt tspData, String sAccObjId){
        
       
        Account AccRec = [Select Id, CMI_Account_Num__c From Account where Id =: sAccObjId Limit 1];
        IAM_Contact_Provisioning__c conAccessObj = new IAM_Contact_Provisioning__c(); 
        conAccessObj.IAM_Contact__c= conObj.id; 
        conAccessObj.IAM_Account_Application__c = appFeatureId;
        //conAccessObj.IAM_Start_Date__c = date.valueof(date.today().format()); 
        conAccessObj.IAM_End_Date__c =Date.newInstance(2199, 12, 31);
        conAccessObj.IAM_Application_Name__c = System.Label.IAM_AppName_ConnectedSolutions;
        conAccessObj.IAM_Role__c ='PrimaryContact';
        //if(CustomerPayloadInfo.Tspname =='PACCAR Solutions' ){ 
        conAccessObj.IAM_Status__c =tspData.IAM_User_Feature_Access_Status__c;
        conAccessObj.IAM_From_JIT_Execution__c=true;
        conAccessObj.IAM_DA_Customer_List__c=AccRec.CMI_Account_Num__c;
        //}else{
        //conAccessObj.IAM_Status__c = System.Label.IAM_Status_Pending; 
        //}                   
        conAccessObj.RecordtypeId =Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(System.Label.IAM_AppName_ConnectedSolutions).getRecordTypeId();
        System.debug('user access app insert--->'+conAccessObj);
        insert conAccessObj;
    }
    
    //email for TableauId generation 
    /*public static void sendmailTableauID(String AccId,String ConId){

EmailTemplate template = [SELECT id FROM EmailTemplate WHERE name  ='CMI_Tableau Id Creation'];
String str = system.label.CMI_TableauID;
List<String> lstString = str.split(',');
system.debug('---list of string---'+lstString );
String[] toAddresses = lstString ;
OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) 
{
if(owa.Address.contains('noreply')) 
mail.setOrgWideEmailAddressId(owa.id); 
}
String fromAddress='noreply.identity@cummins.com';
mail.setTargetObjectId(ConId);
mail.setTreatTargetObjectAsRecipient(false); 
mail.setTemplateId(template.id);
mail.setToAddresses(toAddresses);
mail.setWhatId(AccId);
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}     */
    
    
}