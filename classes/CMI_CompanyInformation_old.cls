global without sharing class CMI_CompanyInformation_old{
   // Class method to renumber Line Items for a given Invoice number.
   // Returns a string that indicates success or failure.
  
        webservice static String CalloutResponseContents(String accountid,string status,string buttonName) {
        System.debug(status);
        HttpResponse res;
         string errorDescription='';
         String sCompanyId;
         String JSONString;
         String emailresponse='';
         string AccStatus;
         string httpsres;
        
       try{
            system.debug(status+'invoiceName==='+accountid);
            //string accountid='0014100000350dq';
            list<id> cids = new list<id>();
            CustomerPayloadInfo lstWapperforPut;
              //added on 1/5 by Karthik
            map<id,string> TSPmap=new map<id,string>();
             map<id,string> TSPold=new map<id,string>();
             for(CMI_TSP__c c:[select id,CMI_TSP_Id__c,(Select NewValue,oldValue,field From Histories order by createddate desc) from CMI_TSP__c where CMI_Account_Name__c=:AccountId]){
                 System.debug('TSP object that is retrieved is '+c);   
                 for(CMI_TSP__History a:c.Histories){
                     system.debug('history object of the selected tsp of particular account is '+a);
                        if(a.field=='Created'){
                            System.debug('tsp is created enterd' );
                            TSPmap.put(c.id,'create');
                            System.debug('tsp after adding created'+TSPmap);
                        }else{
                            
                            string s= Schema.getGlobalDescribe().get('CMI_TSP__c').getDescribe().fields.getMap().get(a.field).getDescribe().getLabel();
                            string oldValue= (String) a.get('oldValue');
                            string newValue= (String) a.get('NewValue'); 
                            if((oldValue!=''||oldValue!=null)&&oldValue!=newValue&&(c.CMI_TSP_Id__c==null||c.CMI_TSP_Id__c=='')){
                            TSPmap.put(c.id,'created');  
                            System.debug('TSP MAp for tsp id null is==='+TSPmap);
                            }else if((oldValue!=''||oldValue!=null)&&oldValue!=newValue&&(c.CMI_TSP_Id__c!=null||c.CMI_TSP_Id__c!='')){
                             TSPmap.put(c.id,'changed');   
                            System.debug('TSP MAp for tsp id null is==='+TSPmap);    
                            }
                 
                            //TSPmap.put(c.id,'The value of '+s +' '+'is changed from'+a.OldValue+' to a new value '+a.NewValue);
                            TSPold.put(c.id,oldValue);
                            System.debug('TSP MAp for tsp id null is==='+TSPold);
                            }
                        break;
                    }
              }
              //end of additon
              
            for(Account obj:[select CMI_Cummins_Support_First_Name__c,CMI_Indemnified__c,CMI_CDA_Status__c,RecordType.Name,CMI_Urgent_Fault_Notification_Email__c,BillingStreet,BillingCountry,CSS_Language__c,CMI_Cummins_Support_Last_Name__c,CMI_Cummins_Customer_Id__c,Name,CMI_Other_Fault_Notifications_Email__c,(select FirstName,lastName,phone,email,CMI_Contact_Type__c,CMI_Flagged_E_mail_Address__c,LastModifiedBy.Name,LastModifiedDate,CreatedBy.Name,CreatedDate from contacts),CMI_Account_Status__c,(select CMI_TSP_Name__c,CMI_Other_TSP_Name__c,CMI_TSP_Id__c,LastModifiedBy.Name,LastModifiedDate,CreatedBy.Name,CreatedDate from TSPs__r ),CMI_Telematics_Service_Provider__c,
                            CSS_Timezone__c,CMI_Stop_Now__c,CMI_Service_Now__c,CMI_CId__c,CMI_Activated_By__c,CMI_Activation_Date__c,LastModifiedBy.Name,LastModifiedDate,CreatedBy.Name,CreatedDate,CMI_Email_Flag__c,CMI_Cummins_Support_Email__c,CMI_Other_TSP__c,CMI_Address2__c,BillingCity,BillingState,BillingPostalCode,CMI_Address3__c,CMI_Service_Soon__c,BillingCountryCode,CMI_Region__c,CMI_Care_service_level__c,CMI_Urgent_Fault_Notification__c,CMI_Other_Fault_Notifications__c from Account where id=:AccountId]){
                
                
                    if(String.isEmpty(sCompanyId)){
                        sCompanyId=obj.CMI_CId__c;
                        system.debug('CId value  is '+ sCompanyId);
                       }
                    
                     if(obj.CMI_Email_Flag__c==false){
                    emailresponse='No';
                    }else{
                    emailresponse='Yes';
                    }
                    //added on 1/5 for making the account status as active if it is active-indemnified.
                    if((String.isEmpty(AccStatus))&&(obj.RecordType.Name=='PC_API')&&(buttonName=='Send To PC'||buttonName=='Generate Service Agreement')&&(status=='Active-Indemnified'))
                    //if(status=='Active-Indemnified')
                    {
                    

                    System.debug('Account status isActive indemnified');
                    AccStatus='Active';
                    
                    }
                    else{
                    AccStatus=status;
                    }
                    //end of adition
                    system.debug('status sending to the pc system is:==='+AccStatus);
                    System.debug('Status got from the account is==='+status);
                    lstWapperforPut=new CustomerPayloadInfo(obj,AccStatus,emailresponse,TSPmap,TSPold);
                    
                    //if(AccStatus=='Inactive'){
                        for(contact c : obj.contacts){
                            cids.add(c.id);
                            system.debug(cids);
                        }
                    //}
                
            }
             
            if(lstWapperforPut!=null){
             //string url='http://connectionsolutions.cummins.com/customerRegistration/customer/{cId}/tspinfo/{custRef}/serviceagreement';
             string url=system.label.CMI_httpurlforAccount+sCompanyId;
             
             system.debug(url);
             string key=System.label.CMI_APIKey;
             JSONString = JSON.serialize(lstWapperforPut);
             Http h = new Http();
             HttpRequest req = new HttpRequest();
             req.setEndpoint(url);
             req.setMethod('PUT');
             system.debug('JSONString====='+JSONString);
             req.setHeader('Content-Type', 'application/json');
             req.setHeader('Authorization','APIKEY '+key);

             req.setBody(JSONString);
            // req.setCompressed(true);    
             res = h.send(req);
             System.debug('http response code is '+res.getStatusCode());
             if(res.getStatusCode()==200){
             httpsres='OK';
             //calling class for updating users status//
              userUpdate(accountid,cids,buttonName);
              
             /*list<id> uIds=new list<id>();
                if(!cids.isEmpty()){
                    system.debug('users==='+cids);
                     if(buttonName=='Activate'||buttonName=='De-Activate'){
                         system.debug('users==='+cids);
                        list<user> users=[select id,isActive from user where contactid=:cids ];
                        system.debug('users==='+users);
                        for(user u:users){
                        
                            if(buttonName=='Activate'){
                            
                                u.isActive=true;
                                uIds.add(u.id);
                            }else{
                                u.isActive=false;
                               //uIds.add(u.id)
                            }
                        }
                        if(!users.isEmpty()){
                        system.debug('users==='+users);
                            update users;
                            if(!uIds.isempty()){
                                CMI_CreateUsersHelper.doResetPassword(uIds);
                            }
                        }
                    }
                    else{
                    system.debug('***');
                   }
                 }*/
            }else if(res.getStatusCode() != 200 ){
                    
                    JSONParser parser = JSON.createParser(res.getBody());
                     while(parser.nextToken() != null){
                    /* if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'errorCode'){
                      parser.nextToken();
                            errorDescription +='Error Code : '+ parser.getText()+';';
                            System.debug('error Description==='+errorDescription);
                     
                     }*/
                        if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'errorDescription'){
                        
                            parser.nextToken();
                            errorDescription += parser.getText()+',\n';
                            System.debug('error Description==='+errorDescription);
                           
                           //errorDescription += JSONToken.VALUE_STRING+'===='+parser.nextToken() +';';
                          }
                           /*if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'errorLocation'){
                      parser.nextToken();
                            errorDescription +='Error Location : '+ parser.getText()+';';
                            System.debug('error Description==='+errorDescription);
                           }*/
                          
                    }
                    
                    cmiError(res.getStatus(),buttonName,JSONString+errorDescription); 
                }
            }
        }catch(exception e){
            cmiError(e.getMessage(),buttonName,JSONString);
            System.debug('ERROR Message:-->:'+ e);
            return e.getMessage();
        }
        string strresult=errorDescription!='' && errorDescription!=null ?errorDescription:httpsres;
        // On success, return a message to the calling program.
        system.debug(strresult);
        system.debug(res.getStatus());
        system.debug(res.getStatusCode());
        return strresult;
    }

    public static void cmiError(String msg,string buttonName,String s){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Source__c='IDENTITY';
        errObj.Error_Type__c=buttonName;
        errObj.Error_Description__c = msg;
        errObj.Processed_Data__c=s;
        insert errObj;
    }
    
    
      public static void userUpdate(string accountid,List<id> cids,string buttonName){
    list<id> uIds=new list<id>();
    list<Account> acc=[select id,Name,IsCustomerPortal from account where id=:accountid];
      System.debug('Account info before deactivating'+acc);
                if(!cids.isEmpty()){
                    system.debug('users==='+cids);
                     if(buttonName=='Activate'||buttonName=='De-Activate'||buttonName=='Generate User ID'){ 
                     list<Account> ObjAcc=[select id,name,IsCustomerPortal from Account where Id=:accountid];                    
                        list<user> users=[select id,isActive from user where contactid=:cids ];
                        system.debug('users==='+users);
                     for(account a:ObjAcc){
                        for(user u:users){
                        
                            if(buttonName=='Activate'||buttonName=='Generate User ID'){
                            
                                u.isActive=true;
                                //u.IsPortalEnabled=true;
                                //a.IsCustomerPortal=true;
                                uIds.add(u.id);
                            }else{
                                u.isActive=false;
                                //u.IsPortalEnabled=false;
                                //a.IsCustomerPortal=false;
                            }
                        }
                      }
                      system.debug('Account details before deactivating user==='+acc);
                      system.debug('User details before deactivating user==='+users);
                        if(!users.isEmpty()){
                        //update ObjAcc;
                        system.debug('users==='+users);
                            update users;
                            if(!uIds.isempty()){
                                CMI_CreateUsersHelper.doResetPassword(uIds);
                            }
                        }
                    }
                    
                 }
    
    }
    
    //Wrapper class begins//
     
        public class CustomerPayloadInfo{
           // public customerInfo customerInfo{set;get;}
            public string cmiCustomerId{set;get;}
            public string accountName{set;get;}
            public string countryName{set;get;}
            public string language{set;get;}
             public string serviceLevel{set;get;}
             public string regionName{set;get;}
             public string status{set;get;}
             public string CDAStatus{set;get;}
             public string addressLine1{set;get;}
             public string addressLine2{set;get;}
             public string addressLine3{set;get;}
             public string city{set;get;}
             public string stateName{set;get;}
             public string zipcode{set;get;}
             public string accountRepName{set;get;}
             public string activatedTime{set;get;}
             public string activatedBy{set;get;}
             public string createdBy{set;get;}
             public string createdTime{set;get;}
             public string lastUpdatedBy{set;get;}
             public string lastUpdatedTime{set;get;}
             //public string accountRepEmail{set;get;}
             List <string> accountRepEmail;
             public string emailResponseFlag{set;get;}
             public list<EquipmentInfo> EquipmentInfo{set;get;}
              public list<TspInfo> TspInfo{set;get;}
           // public boolean indemnified{set;get;}
            
            public CustomerPayloadInfo(Account Acc,string status,string emailresponse,map<id,string> tspmap,map<id,string> tspold){
            if(Acc.CMI_Cummins_Customer_Id__c!=null){
            this.cmiCustomerId=Acc.CMI_Cummins_Customer_Id__c;
            }
            else{
            this.cmiCustomerId='TEMP'+Acc.CMI_CId__c;
            }
                //this.cmiCustomerId=Acc.CMI_Cummins_Customer_Id__c;
                
                this.accountName=Acc.Name;
                this.countryName=Acc.BillingCountry;
                this.language=Acc.CSS_Language__c;
                this.serviceLevel=Acc.CMI_Care_service_level__c;
                this.regionName=Acc.CMI_Region__c;
                this.status=status;
                this.createdBy=Acc.CreatedBy.Name;
                this.createdTime=string.valueOfGmt(Acc.CreatedDate); 
                this.CDAStatus=Acc.CMI_CDA_Status__c;
                this.addressLine1=Acc.BillingStreet;
                this.addressLine2=Acc.CMI_Address2__c;
                this.addressLine3=Acc.CMI_Address3__c;
                this.city=Acc.BillingCity;
                this.stateName=Acc.BillingState;
                this.zipcode=Acc.BillingPostalCode;
               // this.activatedBy=Acc.CMI_Activated_By__c;
               if(status=='Active'&& Acc.CMI_Activated_By__c==null)
                {
                this.activatedBy=UserInfo.getName();
                }
                else
                {
                this.activatedBy=Acc.CMI_Activated_By__c;
                }
                this.lastUpdatedBy= Acc.LastModifiedBy.Name;
                this.lastUpdatedTime= string.valueOfGmt(Acc.LastModifiedDate);
                if(status=='Active'&& Acc.CMI_Activation_Date__c==null)
                {
                this.activatedTime=string.valueOfGmt(DateTime.now());
                }
                else
                {
                this.activatedTime=string.valueOfGmt(Acc.CMI_Activation_Date__c);
                }
                //this.indemnified = Acc.CMI_Indemnified__c;
                if(Acc.CMI_Cummins_Support_First_Name__c!=null&&Acc.CMI_Cummins_Support_First_Name__c!=''&&Acc.CMI_Cummins_Support_Last_Name__c!=null&&Acc.CMI_Cummins_Support_Last_Name__c!=''){
                this.accountRepName=Acc.CMI_Cummins_Support_First_Name__c+' '+Acc.CMI_Cummins_Support_Last_Name__c;
                }else if(Acc.CMI_Cummins_Support_First_Name__c!=null&&Acc.CMI_Cummins_Support_First_Name__c!=''){
                this.accountRepName=Acc.CMI_Cummins_Support_First_Name__c;
                }else if(Acc.CMI_Cummins_Support_Last_Name__c!=null&&Acc.CMI_Cummins_Support_Last_Name__c!=''){
                this.accountRepName=Acc.CMI_Cummins_Support_Last_Name__c;
                }else{
                this.accountRepName='';
                }
                //this.accountRepEmail=Acc.CMI_Cummins_Support_Email__c;
               
               
                if(Acc.CMI_Cummins_Support_Email__c!=null&&Acc.CMI_Cummins_Support_Email__c!=''){
                accountRepEmail=new List<string>();
                accountRepEmail=Acc.CMI_Cummins_Support_Email__c.Split(',');
                }
                this.emailResponseFlag=emailresponse;
                EquipmentInfo=new list<EquipmentInfo>();
                this.EquipmentInfo.add(new EquipmentInfo(Acc));
                TspInfo=new list<TspInfo>();
                for(CMI_TSP__c objTSP:Acc.TSPs__r){
                    this.TspInfo.add(new TspInfo(Acc,objTSP.CreatedBy.name,objTSP.CreatedDate,objTSP.LastModifiedBy.Name,objTSP.LastModifiedDate,objTSP.CMI_TSP_Name__c,objTSP.CMI_TSP_Id__c,objTSP.CMI_Other_TSP_Name__c,tspmap.get(objTSP.id),tspold.get(objTSP.id)));
                
                } 
                
                
            }
        
        }
       
       public class EquipmentInfo{
            public groupInfo groupInfo{set;get;}
            public contactInfo contactInfo{set;get;}
            public  EquipmentInfo(Account Acc){
                this.groupInfo=new groupInfo(Acc);
                //contactInfo=new list<contactInfo>();
                for(Contact c:Acc.contacts){
                if(c.CMI_Contact_Type__c=='Primary'){
                    this.contactInfo=new contactInfo(c,Acc.CMI_Urgent_Fault_Notification_Email__c,Acc.CMI_Email_Flag__c);
                    }
                }
            }
        }    
       public class ContactInfo{
            public string firstName{set;get;}
            public string lastName{set;get;}
            public string phoneNo{set;get;}
            public string email{set;get;}
            public string contactCreatedBy{set;get;}
            public string contactCreatedTime{set;get;}
            public string contactLastUpdatedBy{set;get;}
            public string contactLastUpdatedTime{set;get;}
            public string flaggedemail{set;get;} 
            List<String> notificationEmail;
            List<String> bccNotificationEmail= new List<String>();

             public ContactInfo(Contact objCont,string NotifyEmail,Boolean flag) {
            this.firstName=objCont.firstName;
            this.lastName=objCont.lastName;
            this.phoneNo=objCont.phone;
             if(!string.isempty(objCont.CMI_Flagged_E_mail_Address__c)){
                this.email=objCont.CMI_Flagged_E_mail_Address__c;
                }
                else{
            this.email=objCont.email;
            }
            this.contactCreatedBy=objCont.CreatedBy.Name;
            this.contactCreatedTime=string.valueOfGmt(objCont.CreatedDate); 
            this.contactLastUpdatedBy= objCont.LastModifiedBy.Name;
            this.contactLastUpdatedTime= string.valueOfGmt(objCont.LastModifiedDate);
                   
            bccNotificationEmail.add(system.label.CMI_BCCNotification_Email);
            if(flag==true){
                notificationEmail=new List<String>();
                notificationEmail=NotifyEmail.split(',');
            }
          }
    
    
        }
         public class TSPinfo{
            
            public string custRef{set;get;}
            public Boolean isKnown{set;get;}
            public string name{set;get;}
            public Boolean isActive{set;get;}
            public string  status{set;get;}
            public string  oldCustRef{set;get;}
            public boolean indemnified{set;get;}
            public string tspCreatedBy{set;get;}
            public string tspCreatedTime{set;get;}
            public string tspLastUpdatedBy{set;get;}
            public string tspLastUpdatedTime{set;get;}
             
            
            public TSPinfo(Account acc,string createdby,Datetime createdtime,string modifiedby,Datetime modifiedbytime,string SP,string CID,string OtherTSP, string TspStatus,string TspOld) {
            if(sp!='Other TSP'){
                this.custRef=CID;
                this.isKnown=true;
                this.name=sp;
                this.isActive=true;
                this.status=TspStatus;
                this.oldCustRef=TspOld;
                this.indemnified=acc.CMI_Indemnified__c;
                }
                else{
                this.custRef=CID;
                this.isKnown=false;
                this.name=OtherTSP;
                this.isActive=false;
                this.status=TspStatus;
                this.oldCustRef=TspOld;
                this.indemnified=acc.CMI_Indemnified__c;
                }
                
            this.tspCreatedBy=createdby;
            this.tspCreatedTime=string.valueOfGmt(createdtime); 
            this.tspLastUpdatedBy= modifiedby;
            this.tspLastUpdatedTime= string.valueOfGmt(modifiedbytime);
            
            }

        }
        public class GroupInfo{
            
            public string name{set;get;}
            public string responseTimeZone{set;get;}
            public integer stopNowEmailSuppressTime{set;get;}
            public integer serviceNowEmailSuppressTime{set;get;}
            public integer serviceSoonEmailSuppressTime{set;get;}
            public integer informationEmailSuppressTime{set;get;}
            public boolean notifyOnNonImmediateFault{set;get;}
            public string urgentFaultNotification{set;get;}
            public string nonUrgentFaultNotification{set;get;}
            public GroupInfo(Account objAcc) {
                map<String,integer> maphours=new map<String,integer>();
                maphours.put('1 hour',1);
                maphours.put('4 hours',4);
                maphours.put('8 hours',8);
                maphours.put('12 hours',12);
                maphours.put('1 day',24);
                maphours.put('2 days',48);
                maphours.put('3 days',72);
                maphours.put('No delay',0);
                this.name='';
                //this.responseTimeZone=objAcc.CSS_Timezone__c;
                this.responseTimeZone='US';
                this.stopNowEmailSuppressTime=maphours.get(objAcc.CMI_Stop_Now__c);
                this.serviceNowEmailSuppressTime=maphours.get(objAcc.CMI_Service_Now__c);
                this.serviceSoonEmailSuppressTime=maphours.get(objAcc.CMI_Service_Soon__c);
                //this.informationEmailSuppressTime='';
                this.notifyOnNonImmediateFault=false;
                this.urgentFaultNotification=objAcc.CMI_Urgent_Fault_Notification__c;
                this.nonUrgentFaultNotification=objAcc.CMI_Other_Fault_Notifications__c;
                

            }

        }
        
    webservice static String TspValidation(String accountid,String buttonName) {
       string strTsp='';
       Account Acc;
       string errorTsp='';
       List<User> u=[select id,Name,UserRole.Name from user where id=:Userinfo.getUserId()];
       System.debug('account id==='+Acc);
       Account objAcc=[select CMI_CDA_Status__c,Name,CMI_Moratorium__c,RecordType.Name,CMI_Moratorium_End_Date__c,CMI_Moratorium_Start_Date__c,CMI_Indemnified__c,CMI_Request_withdrawn__c,BillingCountry,CMI_Cummins_Support_Email__c,CMI_CId__c,CMI_Care_Service_Level__c,CMI_Cummins_Customer_Id__c,CMI_Telematics_Service_Provider__c,CMI_Account_Status__c,CMI_Region__c,CSS_Language__c,CMI_Email_Flag__c,CMI_Urgent_Fault_Notification__c,CMI_Urgent_Fault_Notification_Email__c,CMI_Service_Now__c,CMI_Stop_Now__c,CMI_Service_Soon__c,(select FirstName,lastName,phone,email from contacts where CMI_Contact_Type__c='Primary')  from Account where id=:AccountId];
        contact c;
        system.debug('objacc.contact=='+objAcc.contacts);
        if(!objAcc.contacts.isEmpty()){
         c=objAcc.contacts;
         }else{
         errorTsp+='Please provide Primary Contact details for this particular account.\n';
         }
        system.debug(c);
                       
                       
         
       List <CMI_TSP__c> a =[select CMI_TSP_Name__c,CMI_TSP_Id__c from CMI_TSP__c where CMI_Account_Name__c=:accountid];
       if(a.size()!=0){
       system.debug('size of list =='+a.size());
       system.debug('name====='+a[0].CMI_TSP_Name__c);
       }
       if((buttonName=='Activate')&&(u[0].UserRole.Name=='PC_Admin')){
       errorTsp+='You do not have access to Activate account. \n';
       
       }
       if((objAcc.CMI_CDA_Status__c!='Signed by Customer')&&(buttonName=='Activate')&&(objAcc.RecordType.Name=='Product_Connectivity')){
          errorTsp+='CDA status is not Signed by Customer. \n';
          }
          if((objAcc.CMI_CDA_Status__c=='New Customer Request')&&(buttonName=='Activate')&&(objAcc.RecordType.Name=='PC_API')){
          errorTsp+='CDA status is still New Customer Request. \n';
          }
       if((objAcc.CMI_Care_Service_Level__c==''||objAcc.CMI_Care_Service_Level__c==null)&&buttonName=='Activate'&&(objAcc.RecordType.Name=='Product_Connectivit'||objAcc.RecordType.Name=='PC_API')){
          errorTsp+='Care Service Level is required. \n';
          }
          
          //API record fields validation and added on 1/5 by karthik
          
          if((objAcc.CMI_Moratorium__c==null||objAcc.CMI_Moratorium__c=='')&&buttonName=='Activate'&&objAcc.RecordType.Name=='PC_API'){
          errorTsp+='Moartorium flag is not checked. \n';
          }
          if((objAcc.CMI_Indemnified__c==false)&&buttonName=='Activate'&&objAcc.RecordType.Name=='PC_API'){
          errorTsp+='Indemnified flag needs to be true. \n';
          }
          if((objAcc.CMI_Moratorium__c!='No')&&(objAcc.CMI_Moratorium_Start_Date__c==null)&&buttonName=='Activate'&&objAcc.RecordType.Name=='PC_API'){
          errorTsp+='Moratorium Start date is required. \n';
          }
          if((objAcc.CMI_Moratorium__c!='No')&&(objAcc.CMI_Moratorium_End_Date__c==null)&&buttonName=='Activate'&&objAcc.RecordType.Name=='PC_API'){
          errorTsp+='Moratorium End date is required. \n';
          }
        
          if(objAcc.BillingCountry==null||objAcc.BillingCountry==null ){
         errorTsp+='BillingCountry is required. \n';
          }
    
          if((objAcc.CMI_Cummins_Customer_Id__c==objAcc.CMI_CId__c||objAcc.CMI_Cummins_Customer_Id__c==null||objAcc.CMI_Cummins_Customer_Id__c==null )&&buttonName=='Activate'&&(objAcc.RecordType.Name=='Product_Connectivity'||objAcc.RecordType.Name=='PC_API')){
         errorTsp+='Cummins Customer ID is Invalid \n';
          }
     
     
      if(objAcc.CMI_Account_Status__c=='Active'&&buttonName=='Activate'&&(objAcc.RecordType.Name=='Product_Connectivity'||objAcc.RecordType.Name=='PC_API')){
          errorTsp+='Account cannot be activated becacuse Account status is Active. \n';
          }
          
       if(objAcc.CSS_Language__c==null||objAcc.CSS_Language__c==''){
       errorTsp+='Please select Language. \n';
       }
       if(objAcc.CMI_Region__c==null||objAcc.CMI_Region__c==''){
       errorTsp+='Please select Region. \n';
       }
       if(!objAcc.contacts.isEmpty()){
       /*if(c.FirstName==null||c.FirstName==''){
       errorTsp+='Customer first name is required. \n';
       }*/
       if(c.lastname==null||c.lastname==''){
       errorTsp+='Customer last name is required. \n';
       }
       if(c.phone==null||c.phone==''){
       errorTsp+='Customer Phone number is required. \n';
       }
       if(c.email==null||c.email==''){
       errorTsp+='Customer email address is required. \n';
       }
       }
       if(objAcc.CMI_Cummins_Support_Email__c!=null&&objAcc.CMI_Cummins_Support_Email__c!=''){
       system.debug('cummins validation');
       List<string> Sepemail = objAcc.CMI_Cummins_Support_Email__c.split(',');
       System.debug('size==='+Sepemail.size());
       if(Sepemail.size()!=0){ 
        String Emails=ValidateEmails(Sepemail,Sepemail.size());
        system.debug(Emails);
        if(Emails!='true'){
        system.debug('function result');
        errorTsp+='Please enter a valid cummins support email.\n';
           }
        }
       }
      
       
       
       
       if(a.size()!=0&&a.size()==1&&a[0].CMI_TSP_Name__c=='Other TSP'&&buttonName=='Activate'){
       errorTsp+= 'Account cannot be activated because Customer has selected '+a[0].CMI_TSP_Name__c+'.';
         }
         
         if(objAcc.CMI_Account_Status__c!='Active'&&buttonName=='Send To PC'){
        system.debug(errorTsp);
        if(errorTsp!=null&&errorTsp!=''){
         return errorTsp;
         }else{
         system.debug('is valid');
          return 'valid'; 
          } 
         }
         else{
        if(a.size()!=0){
       for(CMI_TSP__c obj:a){
       System.debug('obj===='+obj);
       
       if(obj.CMI_TSP_Name__c!='Other TSP'){
           
            if(obj.CMI_TSP_Name__c!=null && obj.CMI_TSP_Name__c!='' &&(obj.CMI_TSP_Id__c==null || obj.CMI_TSP_Id__c=='')){
                errorTsp+='Please enter the TSP Id of '+obj.CMI_TSP_Name__c+'.\n';
                }
            }
          }         
         }else{
             errorTsp+='Account cannot be activated because no TSP is selected. \n';        
               }
               
               
                if(errorTsp!=''){
                System.debug('errorTsp==='+errorTsp);
                 String value=errorTsp;
                  cmiError(value,buttonName,'No Processed data');
                 return value;
                }
       }
       
             return 'valid' ;  
            
      }
      
      //class for validating cummins support Email.
     public Static String ValidateEmails(List<string> emails,integer length){
      
        
        integer count = 0;
        system.debug('in function');
        
          
          String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
                
              system.debug('inside size');  
             for (integer i = 0, len =length; i < len; i++) {
             string Email = emails[i];
                        
            Pattern MyPattern = Pattern.compile(emailRegex);
            Matcher MyMatcher = MyPattern.matcher(Email);

            if (!MyMatcher.matches()){ 
            count = count +1; 
            system.debug('count==='+count);
            
            }
         }
          
        
         if(count!=0){
         system.debug('result');
             return 's';
             }else{
             return 'true';
             }
       }
        webservice static String MoritoriumValidation(String accountid,String buttonName) {
        
        string returnvalue='';
        string error='';
        
        Account objAcc=[select CMI_CDA_Status__c,Name,CMI_Moratorium__c,RecordType.Name,CMI_Moratorium_End_Date__c,CMI_Moratorium_Start_Date__c,CMI_Indemnified__c,CMI_Request_withdrawn__c,BillingCountry,CMI_Cummins_Support_Email__c,CMI_CId__c,CMI_Care_Service_Level__c,CMI_Cummins_Customer_Id__c,CMI_Telematics_Service_Provider__c,CMI_Account_Status__c,CMI_Region__c,CSS_Language__c,CMI_Email_Flag__c,CMI_Urgent_Fault_Notification__c,CMI_Urgent_Fault_Notification_Email__c,CMI_Service_Now__c,CMI_Stop_Now__c,CMI_Service_Soon__c,(select FirstName,lastName,phone,email from contacts where CMI_Contact_Type__c='Primary')  from Account where id=:AccountId];
        
        if(objAcc.CMI_Moratorium__c=='No'){
        returnvalue='Moratorium No';
        return returnvalue;
        }else
        {
        returnvalue='Yes';
        return returnvalue;
        
        }
      }
       webservice static String RecordValidation(String accountid,String buttonName) {
        
        string returnvalue='';
        string error='';
        
        Account objAcc=[select CMI_CDA_Status__c,Name,CMI_Moratorium__c,RecordType.Name,RecordType.id,CMI_Moratorium_End_Date__c,CMI_Moratorium_Start_Date__c,CMI_Indemnified__c,CMI_Request_withdrawn__c,BillingCountry,CMI_Cummins_Support_Email__c,CMI_CId__c,CMI_Care_Service_Level__c,CMI_Cummins_Customer_Id__c,CMI_Telematics_Service_Provider__c,CMI_Account_Status__c,CMI_Region__c,CSS_Language__c,CMI_Email_Flag__c,CMI_Urgent_Fault_Notification__c,CMI_Urgent_Fault_Notification_Email__c,CMI_Service_Now__c,CMI_Stop_Now__c,CMI_Service_Soon__c,(select FirstName,lastName,phone,email from contacts where CMI_Contact_Type__c='Primary')  from Account where id=:AccountId];
        
        if(objAcc.RecordType.id=='0124C000000Cimd'){
        returnvalue='PC_API';
        return returnvalue;
        }else
        {
        returnvalue='No';
        return returnvalue;
        
        }
      }
}