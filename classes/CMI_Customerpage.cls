global without sharing class CMI_Customerpage {
    public Contact newCon{get;set;}
    Public Account acc{get;set;}
   // public List<Account> accList{get;set;}
    Public boolean urgNotEmailRequired{get;set;}
    public string errorAccountName{set;get;}
    public string errorAddress{set;get;}
    public string errorCity{set;get;}
    public string errorContactFirstName{set;get;}
    public string errorContactLastName{set;get;}
    public string errorContactEmail{set;get;}
    public string errorContactEmail1{set;get;}
    public string errorContactPhone{set;get;}
    public boolean Donotsendemails{set;get;} 
    //public string errorCumminsSupportFirstName{set;get;}
    //public string errorCumminsSupportLastName{set;get;}
    //public string errorCumminsSupportEmail{set;get;}
    public string Telematicsserviceprovider{set;get;}
    public string errorStateerror{set;get;}
    public string errorStateCountry{set;get;}
    public string errorPostalcode{set;get;}
    public string errorempty {get;set;}
    public string errorOtherTsp{set;get;}
    public String errorCumminsValidEmail{get; set;}
    Global String aid{set;get;}
    public Boolean displayInputputText{get;set;}
    //public Boolean chkBx{get;set;}
    //public String input{get;set;}
    public String CMIothertsp{set;get;}
    public string CMIUrgentFaultNotification{set;get;}
    public string CMIOtherFaultNotifications {set;get;}
    public string CMIStopNow{set;get;}
    public string CMIServiceNow{set;get;}
    public string CMIServiceSoon{set;get;}
    public string CMIinformation{set;get;}
    public boolean isSuccessDivShow {get;set;}
    public boolean isShowCloseButton {get;set;}
    public boolean isShowCancelButton {get;set;}
    public String a;
    Global String encrypt;
    public String CMIUrgentFaultNotificationEmails{set;get;}
    private final ApexPages.StandardController controller;
    Public boolean EmailSectionEnable{get;set;}
    public list<String> EnteredEmail {get;set;} 
    public boolean showDelayNotification {get;set;}
    
    public boolean showPrimaryEmail {get;set;}
    
    //picklist
    public List<SelectOption> TelematicsService{set;get;}
    public list<string> lstTeleService{set;get;}
    public CMI_Customerpage(ApexPages.StandardController controller) {

    EnteredEmail  = new list<String>();
        this.controller= controller;  
        TelematicsService=new List<SelectOption>();
        lstTeleService=new list<string>();
        Schema.DescribeFieldResult fieldResult = Account.CMI_Telematics_Service_Provider__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
        for( Schema.PicklistEntry f : ple)
        {
            TelematicsService.add(new SelectOption( f.getValue(),  f.getValue()));

                         
        }
        acc=new Account();
        //acc.CMI_Urgent_Fault_Notification__c ='No System';
        //acc.CMI_Other_Fault_Notifications__c ='No System';
        newCon=new Contact(); 
        urgNotEmailRequired = false;
        isSuccessDivShow = false;
        showPrimaryEmail  = true;
        isShowCloseButton= false;
        isShowCancelButton = true;
        EmailSectionEnable=true;
    }
    
    
    
    
    
    public PageReference click(){    
         if(acc.CMI_Email_Flag__c==true){
             displayInputputText = true;
         }
         else{
             displayInputputText = false;
        }
         return null;
    }
    
    public PageReference clickDonotsend(){          
         if(Donotsendemails==true){     
             displayInputputText = true;        
             acc.CMI_Email_Flag__c=false;       
         }      
         else{      
             acc.CMI_Email_Flag__c=true;        
             displayInputputText = false;       
        }       
         return null;       
    }
    
    
    
    
    public void emailpoplate_new(){
            EmailSectionEnable=true;     
    }
    
    
    public PageReference emailpoplate()
    {        
    //acc.CMI_Urgent_Fault_Notification_Email__c=newCon.Email;        
    system.debug(acc+'newCon.Email==='+newCon.email);       
    return null;        
    }  
    
     public PageReference emailpoplate1()
    {        
    acc.CMI_Urgent_Fault_Notification_Email__c=ApexPages.currentPage().getParameters().get('allemail');    
    System.debug('Email populate 1');
    EmailSectionEnable=true;     
    showPrimaryEmail  = true;

    //system.debug(acc+'newCon.Email==='+newCon.email);       
    return null;        
    } 
    
    public PageReference emailpoplate2()
    {        
    acc.CMI_Urgent_Fault_Notification_Email__c='';   
    System.debug('acc.CMI_Urgent_Fault_Notification__c '+acc.CMI_Urgent_Fault_Notification__c);
    System.debug('acc.CMI_Other_Fault_Notifications__c  '+acc.CMI_Other_Fault_Notifications__c );
    System.debug('Donotsendemails '+Donotsendemails);
     if((acc.CMI_Urgent_Fault_Notification__c ==null && acc.CMI_Other_Fault_Notifications__c ==null && (null != Donotsendemails && Donotsendemails)) || (acc.CMI_Urgent_Fault_Notification__c =='No System' && acc.CMI_Other_Fault_Notifications__c =='No System' && (null != Donotsendemails && Donotsendemails))){
   System.debug('111111111111');
    EmailSectionEnable=false;   
    showPrimaryEmail = false;  
    }else{
    System.debug('2222222222222');
    EmailSectionEnable=true;     
    showPrimaryEmail  = true;
    }
    //system.debug(acc+'newCon.Email==='+newCon.email);       
    return null;        
    } 
    
    
    
         
    public String getURL() {
        String URL = ApexPages.CurrentPage().GetURL();
        return URL.substring(0,URL.indexOf('?'));
    }
    public PageReference reset() {
        acc=new Account();
        newCon=new Contact(); 
        PageReference pageRef = new PageReference(getURL());
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference back() {
      PageReference demoPage = new pagereference('/CS_CustomLoginPage');
      demoPage.setRedirect(true);
      return demoPage;
       
    }
    public void TelematicsServiceOther(){
        acc.CMI_Telematics_Service_Provider__c=null;
        string strteleService='';
        for(string s:lstTeleService){
            strteleService+=s+';';
        
        }
        if(strteleService!=null && strteleService!=''){
        acc.CMI_Telematics_Service_Provider__c=strteleService.substring(0,strteleService.length()-1);

        }
    
    }
    
    public pagereference send(){
    system.debug('test== '+ApexPages.currentPage().getParameters().get('allemail') +acc.CMI_Urgent_Fault_Notification_Email__c);
        string strteleService='';
        for(string s:lstTeleService){
            strteleService+=s+';';
        
        }
        if(strteleService!=null && strteleService!=''){
        acc.CMI_Telematics_Service_Provider__c=strteleService.substring(0,strteleService.length()-1);

        }
        Boolean errofound = false;
        errorAccountName='';
        errorAddress='';
        errorCity='';
        errorCumminsValidEmail = '';
        errorContactFirstName='';
        errorContactLastName='';
        errorContactEmail='';
        errorContactEmail1='';
        errorContactPhone='';
        CMIothertsp='';
        //errorCumminsSupportFirstName='';
        //errorCumminsSupportLastName='';
        //errorCumminsSupportEmail='';
        Telematicsserviceprovider='';
        errorStateerror='';
        errorStateCountry='';
        errorPostalcode='';
        errorOtherTsp = '';
        CMIUrgentFaultNotification='';
        CMIOtherFaultNotifications=''; 
        CMIStopNow='';
        CMIServiceNow='';
        CMIServiceSoon='';
        CMIinformation='';
        if(acc.name == '' || acc.name == Null){
            errorAccountName='Please fill out Company Name';  
            errofound = true;
        }
        if(acc.BillingCountryCode == Null){
           errorStateCountry='Please fill out Country';  
            errofound = true;
        }
        if(acc.BillingStreet == '' ||acc.BillingStreet == Null ){
            errorAddress='Please fill out Address';  
            errofound = true;
        }
        if(acc.BillingCity == '' || acc.BillingCity == null){
                errorCity='Please fill out City';  
            errofound = true;
        }
        if(acc.BillingStateCode == '' ||acc.BillingStateCode == Null ){
             //   errorStateerror='Please fill out State';  
           // errofound = true;
        }
        if(acc.BillingPostalCode == '' ||acc.BillingPostalCode == Null ){
               errorPostalcode='Please fill out Postal Code/Province';  
            errofound = true;
        }
        if(newCon.FirstName == '' ||newCon.FirstName == Null ){
                errorContactFirstName='Please fill out Contact First Name';  
            errofound = true;
        }
        if(newCon.LastName == '' ||newCon.LastName == Null ){
              errorContactLastName='Please fill out Contact Last Name';  
            errofound = true;
        }
        if(newCon.Email == ''||newCon.Email == Null ){
                errorContactEmail='Please fill out Contact Email';  
            errofound = true;
        }
        else if(newCon.Email!=null && newCon.Email.contains('@') ){
           list<string> lstMail=newCon.Email.split('@');
          
            if(lstMail==null || lstMail.size()!=2 || !lstMail[1].contains('.') || lstMail[0].contains(',') || lstMail[1].contains(',')){    
      
                errorContactEmail='Please fill out Valid Contact Email';  
                errofound = true;
                }
        }
        else{
           
                errorContactEmail='Please fill out Valid Contact Email';  
                errofound = true;
                
        }
        if(newCon.phone == '' ||newCon.phone == Null ){
            errorContactPhone='Please fill out Contact Phone';  
            errofound = true;
           }
        
        
     /*   if(newCon.phone!= null && !validatePhone(newCon)){
        
                errorContactPhone='Please fill out Valid Contact Phone';  
            errofound = true;
        } 
        if(acc.CMI_Cummins_Support_First_Name__c == '' || acc.CMI_Cummins_Support_First_Name__c == Null){
                errorCumminsSupportFirstName='Please fill out Cummins Support First Name';  
            errofound = true;
        }
        if(acc.CMI_Cummins_Support_Last_Name__c == '' || acc.CMI_Cummins_Support_Last_Name__c == Null){
                errorCumminsSupportLastName='Please fill out Cummins Support Last Name';  
            errofound = true;
        }
       if(acc.CMI_Cummins_Support_Email__c == '' || acc.CMI_Cummins_Support_Email__c == Null){
                errorCumminsSupportEmail='Please fill out Cummins Support Email';  
            errofound = true;
        }*/
        /*if(acc.CMI_Other_TSP__c == '' || acc.CMI_Other_TSP__c == Null){
                errorOtherTsp='Please fill out Other Tsp';  
            errofound = true;
        }*/
        if(acc.CMI_Telematics_Service_Provider__c =='' || acc.CMI_Telematics_Service_Provider__c ==null)
        {
            Telematicsserviceprovider='Please select Telematics service provider';  
            errofound = true;
        }
      if(acc.CMI_Telematics_Service_Provider__c!=null&&acc.CMI_Telematics_Service_Provider__c!=''){
        
       system.debug('cminamesTSP'+acc.CMI_Telematics_Service_Provider__c);  
       List<string> TSP=acc.CMI_Telematics_Service_Provider__c.split(';');
       system.debug('TSPnames=='+TSP);
        if(TSP.size()==1&&TSP[0]=='Other TSP'){
            if(acc.CMI_Telematics_Service_Provider__c=='Other TSP'){
         if(acc.CMI_Other_TSP__c == '' || acc.CMI_Other_TSP__c == Null){
                   errorOtherTsp='Please fill out Other Tsp';  
                    errofound = true;
            }
           }
        }else{
        
             for(string s:acc.CMI_Telematics_Service_Provider__c.split(';')){
                if(s=='Other TSP'){
                   if(acc.CMI_Other_TSP__c == '' || acc.CMI_Other_TSP__c == Null){
                   errorOtherTsp='Please fill out Other Tsp';  
                   errofound = true;
                } 
            }
           }
           }
            
       
     }
     
          
      if(acc.CMI_Cummins_Support_Email__c != Null && acc.CMI_Cummins_Support_Email__c != '') {      
            if(!validateEmail(acc.CMI_Cummins_Support_Email__c,false))      
            {       
                errorCumminsValidEmail='Please fill out valid Email Address';       
                errofound = true;       
            }       
        }
        
                
      if(acc.CMI_Email_Flag__c==true && acc.CMI_Urgent_Fault_Notification_Email__c!=null && acc.CMI_Urgent_Fault_Notification_Email__c!='') {     
            if(!validateEmail(acc.CMI_Urgent_Fault_Notification_Email__c,false))        
            {       
                CMIUrgentFaultNotification='Please fill out valid Email Address';       
                errofound = true;       
            }   
            
            EnteredEmail  = acc.CMI_Urgent_Fault_Notification_Email__c.split(',');
            }    
        else if(acc.CMI_Email_Flag__c!=false){
            CMIUrgentFaultNotification='Please fill out  Email Address';  
                errofound = true;
        
        }
        
        if(acc.CMI_Email_Flag__c==true && acc.CMI_Urgent_Fault_Notification__c == 'Email' && acc.CMI_Urgent_Fault_Notification_Email__c == null){
            CMIUrgentFaultNotification='Please fill out Urgent Fault Notification Email';  
            errofound = true;
        }
        
        /*if(acc.CMI_Other_Fault_Notifications__c == 'Email' && acc.CMI_Other_Fault_Notifications_Email__c == null){
            CMIOtherFaultNotifications ='Please Fill out Other Fault Notification Email';
            errofound = true;
        }*/
        if(acc.CMI_Email_Flag__c==true)  
          {
            if(acc.CMI_Stop_Now__c ==''||acc.CMI_Stop_Now__c== null)
            {
                CMIStopNow='Please select value for stop now';
                errofound = true;
            }
            
            
            
            if(acc.CMI_Service_Now__c==''||acc.CMI_Service_Now__c== null)
            {
                CMIServiceNow='Please select value for service now';
                errofound = true;
            }
            if(acc.CMI_Service_Soon__c==''||acc.CMI_Service_Soon__c== null){
                CMIServiceSoon='Please select value for service soon';
                errofound = true;
            }
            //if(acc.CMI_Information__c==''||acc.CMI_Information__c== null){
              //  CMIServiceSoon='Please select value for information';
                //errofound = true;
           // }
        }
            
        if(errofound == true){
       
//                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Email Address'));
 
            return null;
        }
        else{
            try{
                Savepoint sp = Database.setSavepoint(); 
                try{               
                   user u= [select username from user where id='00561000000rPnZ'];
                    //acc.Primary_Email__c= newCon.Email; 
                    acc.Owner=u;
                    
                    acc.CMI_Account_Status__c='Pending';
                    acc.CMI_CDA_Status__c='New Customer Request';
                    acc.CMI_Region__c='North America and Caribbean';
                    acc.Type='Customer';
                    acc.RecordTypeId=system.label.CMI_Record_type ;
                   
                    //RecordType r= [Select Id From RecordType where Name ='Product_Connectivity' and sObjectType ='Account'  limit 1];
                    //System.debug('recordType====='+r);
                    //acc.RecordType=r;
                    if(acc.CMI_Email_Flag__c == false){
                    
                    System.debug('Yes its a boolean');
                    acc.CMI_Email_Flag__c = (boolean)acc.CMI_Email_Flag__c;
                    }
                    System.debug('>>>>>>>>>>>> '+acc.CMI_Email_Flag__c);
                    Insert acc;
                    System.debug('Account Details====='+acc);
                    
                    list<CMI_TSP__c> lstTSP=new list<CMI_TSP__c>();
                    System.debug(lstTeleservice);
                    System.debug(acc.id);
                    if(acc.CMI_Telematics_Service_Provider__c!=null && acc.CMI_Telematics_Service_Provider__c!=''){
                        for(string s:acc.CMI_Telematics_Service_Provider__c.split(';')){
                            CMI_TSP__c objTSP=new CMI_TSP__c();
                             if(s=='Other TSP'){
                                objTSP.CMI_Account_Name__c=acc.id;
                                objTSP.CMI_TSP_Name__c=s;
                                objTSP.CMI_Other_TSP_Name__c=acc.CMI_Other_TSP__c;
                                }
                                else{
                               objTSP.CMI_Account_Name__c=acc.id;
                               objTSP.CMI_TSP_Name__c=s;
                                }
                            //objTSP.name=s;
                            lstTSP.add(objTSP);
                        }
                        System.debug(lstTSP);
                        if(!lstTSP.isempty()){
                        System.debug('Account Details lstTSP====='+lstTSP);
                            insert lstTSP;
                        }
                    }
                    system.debug('Printing details'+acc);
                    newCon.AccountId= acc.Id;
                    aid= acc.Id;
                    system.debug('account is isss===='+aid);
                    newCon.CMI_Contact_Type__c='Primary';
                    RecordType r1= [Select Id From RecordType where Name ='Product_Connectivity' and sObjectType ='Contact'  limit 1];
                    System.debug('recordType====='+r1);
                    //newCon.RecordType=r1;
                  Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Product_Connectivity').getRecordTypeId();
                    System.debug('Contact recordtype======='+devRecordTypeId);
                    newCon.RecordTypeId=devRecordTypeId; 
                    insert newCon;
                    System.debug('newCon====='+newCon);
                    Account a2= [select CMI_cid__c from Account where id =: aid];
                    encrypt= a2.CMI_cid__c;
                    aes256(encrypt);
                    system.debug('encrypt'+encrypt);
                    sendSupportemail();
                    Account a1= [select id from account where id =: aid];
                    Contact c=[select id, name from Contact where Contact.AccountId=:a1.id];
                  //  sendmailTableauID(a1.id,c.id); 
                    isSuccessDivShow= true;
                    //Approval.ProcessSubmitRequest req1 =  new Approval.ProcessSubmitRequest();
                    // req1.setObjectId(acc.id);
                    // Submit the approval request for the account
                    // Approval.ProcessResult result = Approval.process(req1);
                    // system.debug('Approval details'+result );    
                }
                catch(exception e){
                    Database.rollback(sp); 
                    system.debug('exception: is comming 1'+e);
                    acc= acc.clone(false);
                    return null;  
                }
                
                
                if(acc.CMI_Telematics_Service_Provider__c=='Other TSP'){
                pagereference pg = Page.CMI_OtherTSP_page;
                    pg.setRedirect(true);
                    return pg;
                }
                else{
                  isSuccessDivShow= true;
                  isShowCloseButton= true;
                  isShowCancelButton = false;
                 showPrimaryEmail = false;
                       system.debug('simply returning one');
              
                  return null;
                }
                
            }
            catch(DMLException ex){
                ApexPages.addMessages(ex);
            }
            
                  system.debug('simply returning two');
              
            return null;
        }
    }
    
    public string aes256(String encrypt){
    Blob data = Blob.valueOf(encrypt);
    system.debug('encrypt'+data);
    String password ='12350801756252444444';
    String salt = '23143546709877777777345';
    Blob key = EncodingUtil.base64Decode(password+salt);
    System.debug(key);
    Blob cTESN = Crypto.encryptWithManagedIV('AES256', key, data);

    String encodedCipherTextjid = EncodingUtil.base64Encode(cTESN ); 
    //String encodedCipherTextuid = EncodingUtil.urlEncode(EncodingUtil.base64Encode(cTuserId),'UTF-8'); 
    //string fnlString = 'esn='+encodedCipherTextesn+'&dsid='+encodedCipherTextjid+'&toolName=CSS&userId='+encodedCipherTextuid; 
    System.debug('encrypted::'+encodedCipherTextjid);
    String s=encodedCipherTextjid;
    system.debug('String'+s);
    Account a2= [select CMI_cid__c,CMI_Customer_SK__c from Account where id =: aid];
    a2.CMI_Customer_SK__c=s;
    system.debug('String'+a2.CMI_Customer_SK__c);
    update a2;
    return null;
    }
    
    

   public void sendSupportemail()
{
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
    string sEmailAddresses = acc.CMI_Cummins_Support_Email__c;
    EmailTemplate template=new EmailTemplate ();
    if(sEmailAddresses==null || sEmailAddresses ==''){
    sEmailAddresses=system.label.CMI_CC_Email;
    template = [SELECT id FROM EmailTemplate WHERE name = 'CMI_Unknown Contact'];
    
    }else{
    sEmailAddresses=acc.CMI_Cummins_Support_Email__c;
    template = [SELECT id FROM EmailTemplate WHERE name = 'CMI_SupportSubmit'];
    }
    String[] addr= sEmailAddresses.split(',');
    
    
    
    String[] BCCAddresses =new List<String>();
    system.debug('BCCAddresses  '+BCCAddresses );
    BCCAddresses.add(system.label.CMI_BCCNotification_Email);
    //KG added
  
    
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
  
   mail1.setWhatId(acc.id);
   system.debug('Account id'+acc.id);
    mail1.setTreatTargetObjectAsRecipient(false); 
    mail1.setToAddresses(addr);
  //  mail1.setBccAddresses(BCCAddresses);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1 });
 
}
public static Boolean validateEmail(String emails,boolean isSingleEmail) {      
    Boolean res = true;     
    system.debug('emails==' + emails);          
    List<String> lstemails = emails.split(',');     
    if(isSingleEmail && lstemails.size() > 0)       
    {       
        res = false;        
        return res;         
    }       
    system.debug('lstemails==' + lstemails);        
    for(string email: lstemails)        
    {       
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>       
        Pattern MyPattern = Pattern.compile(emailRegex);        
        Matcher MyMatcher = MyPattern.matcher(email);       
        if (!MyMatcher.matches())       
            res = false;        
                
    }       
    system.debug('res==' + res);        
    return res;         
                
            
    }
    
    
}