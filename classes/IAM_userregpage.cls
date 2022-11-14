public with sharing class IAM_userregpage{
public String currentRecordId {get;set;}
public String parameterValue {get;set;}
Public Account acc{get;set;}
Public Contact contact{get;set;}
public IAM_Contact_Provisioning__c conprov{get;set;}

 public string errorContactFirstName{set;get;}
    public string errorContactLastName{set;get;}
    public string errorContactEmail{set;get;}
    public string errorContactPhone{set;get;}
     public string errorConRole{set;get;}

  public IAM_userregpage(ApexPages.StandardController controller) {
      acc=new Account();
        contact=new Contact(); 
        conprov=new IAM_Contact_Provisioning__c();
     currentRecordId  = ApexPages.CurrentPage().getparameters().get('aid');
       acc = [select id,name from Account where id =: currentRecordId ];
        parameterValue = ApexPages.CurrentPage().getparameters().get('aid');
  }
 /*public String getURL() {
        String URL = ApexPages.CurrentPage().GetURL();
        return URL.substring(0,URL.indexOf('?'));
    }
    */
    public PageReference reset() {
        acc=new Account();
        contact=new Contact(); 
        conprov=new IAM_Contact_Provisioning__c();
        PageReference pageRef = new PageReference(System.currentPageReference().getURL());
        pageRef.getParameters().put('aid',currentRecordId  );
        pageRef.setRedirect(true);
        
        return pageRef;
    }
  // save button is clicked
  public PageReference send() {
  Boolean errofound = false;
      errorContactFirstName='';
        errorContactLastName='';
        errorContactEmail='';
        errorContactPhone='';
        errorConRole='';
         if(contact.FirstName == '' ||contact.FirstName == Null ){
                errorContactFirstName='Please fill out Contact First Name';  
            errofound = true;
        }
        if(contact.LastName == '' ||contact.LastName == Null ){
              errorContactLastName='Please fill out Contact Last Name';  
            errofound = true;
        }
        if(contact.Email == '' ||contact.Email == Null ){
                errorContactEmail='Please fill out Contact Email';  
            errofound = true;
        }
        if(contact.Email!=null && !contact.Email.contains('@') ){
           list<string> lstMail=contact.Email.split('@');
          
            if(lstMail==null || lstMail.size()!=2 || !lstMail[1].contains('.')){    
      
                errorContactEmail='Please fill out Valid Contact Email';  
                errofound = true;
                }
        }
       if(conprov.IAM_DA_Calibaration_Role__c== '' ||conprov.IAM_DA_Calibaration_Role__c== Null ){
              errorConRole='Please fill out Role';  
            errofound = true;
        }
         if(errofound == true){
            return null;
        }
        else{
            try{
               
                Savepoint sp = Database.setSavepoint(); 
      try{               
      system.debug('contact entering'+acc );
      contact.AccountId=parameterValue ;
      contact.CMI_Contact_Type__c='Secondary';
      insert contact; // inserts the new record into the database
      system.debug('contact'+contact);
      IAM_Application__c app=[select id from IAM_Application__c where IaM_Account_Name__c=:parameterValue];
      system.debug('contact conprov'+app.id);
      conprov.IAM_Account_Application__c=app.id;
      conprov.IAM_Status__c='Active';
      conprov.IAM_Start_Date__c=system.today();
      conprov.IAM_Application_Name__c='Product Connectivity';
      insert conprov;
      system.debug('contact conprov'+conprov);
      // if successfully inserted new contact, then displays the thank you page.
      return Page.IAM_userregconfirm;
    }
     
                catch(exception e){
                Database.rollback(sp); 
                acc= acc.clone(false);
                return null;  
                    
                    }
                   
            
        }
 catch(DMLException ex){
                ApexPages.addMessages(ex);
                return null;
            }
    
  }
  
        }

}