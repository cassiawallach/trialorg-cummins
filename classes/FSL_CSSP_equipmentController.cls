public without sharing class FSL_CSSP_equipmentController {
    
    
    public static Id asstrecId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Customer_Created').getRecordTypeId();
  
    @AuraEnabled(cacheable = true)
    public static List<Asset> getAssetslist(String accId){
      
        string strAccountId = '';   //UserInfo.getUserId(); 
        User us = [select Id, Name, contactId, contact.AccountId from user Where Id =:UserInfo.getUserId()];
        system.debug('accId====='+us.contact.AccountId);
        strAccountId = us.contact.AccountId;
        //List<Account> a  = [Select Account_ID__c, (Select Id, Product2.Name, Name From Assets) From Account];
        
        /*return [SELECT Id,name, SerialNumber, Status, Equipment_Id__c,AccountId, Make__c, Model__c, Unit_Number__c, VIN__c 
                FROM Asset];*/
        return [SELECT Id,name, SerialNumber, Status,Service_Model__c,Registration__c, Equipment_Id__c,AccountId, Make__c, Model__c, Unit_Number__c, VIN__c 
                FROM Asset 
                where Accountid=:strAccountId];
    }
    @AuraEnabled(cacheable = true)
    public static List<Asset>getAssetsRecord(string asstID){

        return [SELECT Id,name, SerialNumber, Status, Equipment_Id__c, Make__c, Model__c, Unit_Number__c, VIN__c, Registration__c FROM Asset where Id=:asstID];
       
    }
    @AuraEnabled
    
    public static Asset saveAssetRecord(string make,string model,string assetnumber, string enginegeneratormodel, string unitnumber,string licenseNumber){
        try {

            string strAccountId = '';   //UserInfo.getUserId(); 
            User us = [select Id, Name, contactId, contact.AccountId from user Where Id =:UserInfo.getUserId()];
            system.debug('accId====='+us.contact.AccountId);
            strAccountId = us.contact.AccountId;

            Asset ast = new Asset();
            ast.name = assetnumber;
            ast.Unit_Number__c = unitnumber;
            ast.Make__c = make;
            ast.Model__c = model;
            ast.Service_Model__c = enginegeneratormodel;
            ast.Registration__c=licenseNumber;
            ast.AccountId=strAccountId;
            ast.recordtypeid=asstrecId;

            insert ast;
            system.debug('@@@@AssetDetails====>'+ast);
            return ast;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled  
   public static string saveCase(Case serviceRequest) {   //, string file, string fileName  
        
       String serviceReqId = '';
       String serviceTeritoryId = '';
       String serviceTeritoryStreet = '';
       String serviceTeritoryCity = '';
       String serviceTeritoryState = '';
       String serviceTeritoryCountry = '';
       String serviceTeritoryZipcode = '';
       try{ 
           Asset assetRec = new Asset();//Added  code for Story# CT4-718
            system.debug('serviceRequest.AssetId<>'+serviceRequest.AssetId);
           RecordType caserecordTypeId = [SELECT Id, Name FROM RecordType WHERE Name='IA Request'];
           if(serviceRequest.AssetId!=null){//Added  code for Story# CT4-718
            assetRec=[select id,Name,Make__c,Model__c,Service_Model__c,Registration__c,Unit_Number__c from Asset where id=:serviceRequest.AssetId];
           }
           system.debug('assetRec<>'+assetRec);
         
          
           serviceRequest.recordtypeid = caserecordTypeId.id;
           serviceRequest.Status = 'New';
           if(serviceRequest.AssetId!=null){//Added line for Story# CT4-718
            serviceRequest.Make__c=assetRec.Make__c;
            serviceRequest.Model__c=assetRec.Model__c;
           }
           else{//Added below code for Story# CT4-718
            
            serviceRequest.Make__c='';
            serviceRequest.Model__c='';
            serviceRequest.AssetId=null;

           }
           
           serviceRequest.Is_Created_From_Portal__c = true;
           Insert serviceRequest;
          // contactId = serviceRequest.Id;   
           serviceReqId = serviceRequest.Id;  
           serviceTeritoryId = serviceRequest.Service_Territory__c;
           system.debug('serviceTeritoryId===='+serviceTeritoryId);
           system.debug('serviceRequest<><>'+serviceRequest);
           //system.debug('file<><>'+file);
           //system.debug('fileName<><>'+fileName);
    
     return serviceReqId;  //Added below code for Story# CT4-718
    } catch (Exception e) {
        system.debug('Exception<?>'+e.getMessage() + e.getLineNumber());
        return  null;
    }
    
   } 
    
    
   
   @AuraEnabled(cacheable = true)
   public static list<user> currentuser( string loggedInUserId){
       system.debug('loggedInUserId'+loggedInUserId);
    list<user> loggedInUser = new list<user>();
       try {
           
        loggedInUser = [SELECT Id,FirstName, AccountId,Account.FSL_Source_ERP__c,ContactId,LastName,Contact.FirstName,Contact.Phone,Contact.MailingStreet,  Username FROM User WHERE Id=:loggedInUserId];
        system.debug('loggedInUser'+loggedInUser);
       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
       }
       return loggedInUser;
   }   
    
    @AuraEnabled(cacheable = true)
    public static Contact getContactId(){
        Contact  Contactresponse = new Contact();
        try {
            
           String ContactId  = [SELECT Id, contactId   FROM User WHERE Id = :Userinfo.getUserId()].ContactId; 
            
           if(string.isNotBlank(ContactId)){
                Contact Con = [Select Id, Name, Email, Phone, AccountId, Account.Name, Account.BillingAddress 
                               FROM Contact 
                               WHERE Id = :ContactId];
                if(Con != null){
                    Contactresponse = Con;
                }
            }
        } catch (Exception e) { 
            throw new AuraHandledException(e.getMessage()); 
        }
        return Contactresponse;  
    }
    /*
    @AuraEnabled(cacheable = true)
    public static List<String> getPickLstValue(){
        list<user> loggedInUser = new list<user>();
        List<String> pickListValuesList = new List<String>();
        try {
           loggedInUser = [SELECT Id, AccountId,Account.FSL_Source_ERP__c  FROM User WHERE Id=:Userinfo.getUserId()]; 
           
           Schema.DescribeFieldResult fieldResult = Contact.FSL_Comm_Triggers__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
           for(Schema.PicklistEntry f : ple) {
            
            if(f.getValue() != 'Invoice Ready') {
            for(User us:loggedInUser){
              if(us.Account.FSL_Source_ERP__c=='BMS'){
                //pickListValuesList.add(new SelectOption(f.getLabel(), f.getValue()));
                pickListValuesList.add(f.getLabel());
                }
                
              }
            }
        }
        } catch (Exception e) { 
            throw new AuraHandledException(e.getMessage()); 
        }
        return pickListValuesList;  
    }
    @AuraEnabled(cacheable = true)
   public static List<Contact>getContactList(){
       
    list<user> loggedInUser = new list<user>();
     List<Contact>  Contactresponse = new List<Contact>();
       try {
           
        loggedInUser = [SELECT Id, AccountId,ContactId,Contact.FSL_Comm_Triggers__c,Contact.Text_SMS_Notification_Frequency__c,Contact.Email_Notification_Frequency__c  FROM User WHERE Id=:Userinfo.getUserId()];
        Contactresponse =[Select Id,FSL_Comm_Triggers__c,Text_SMS_Notification_Frequency__c,Email_Notification_Frequency__c FROM Contact WHERE Id = :loggedInUser[0].ContactId];
       
               
       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
       }
       return Contactresponse ;
   }
   */
   @AuraEnabled(cacheable = true)
    public static List<Asset> getAssetslists(){
      
        string strAccountId = '';   //UserInfo.getUserId(); 
        User us = [select Id, Name, contactId, contact.AccountId from user Where Id =:UserInfo.getUserId()];
        system.debug('accId====='+us.contact.AccountId);
        strAccountId = us.contact.AccountId;
        //List<Account> a  = [Select Account_ID__c, (Select Id, Product2.Name, Name From Assets) From Account];
        
        /*return [SELECT Id,name, SerialNumber, Status, Equipment_Id__c,AccountId, Make__c, Model__c, Unit_Number__c, VIN__c 
                FROM Asset];*/
        return [SELECT Id,name, SerialNumber, Status,Service_Model__c,Registration__c, Equipment_Id__c,AccountId, Make__c, Model__c, Unit_Number__c, VIN__c 
                FROM Asset 
                where Accountid=:strAccountId];
    }
}