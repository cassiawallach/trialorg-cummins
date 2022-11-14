@RestResource(urlMapping='/Customer/User/')
global with sharing class CMI_CustomerUser {
    
    //==============================================================================================
    // *** REST Post *** :  Requires the cummins customer id of Account and reutrn results as Response Type
    // Class is mainly used to insert or update user.
    //===============================================================================================
    @HttpPost
    global static CMI_ResponseHandler Post(UserInfo UserInfo)
    {
        system.debug('request====' + UserInfo );
                                
        RestRequest req = RestContext.request;
        CMI_ResponseHandler response = new CMI_ResponseHandler();
        integer emailpresent=0 ;
        List<Account> acc=new List<Account>();
        List<CMI_TSP__c> tsp=new List<CMI_TSP__c>(); 
        List<Contact> conupdate=new List<Contact>(); 
        List<id> cids=new list<id>();
        List<id> cpids=new list<id>();//Contact ids which are primary and fname and lname is not equal to Unknown.
        List<Contact> con=new List<Contact>();
        List<User> uAll=new List<User>();
        List<User> uActive=new List<User>();
        List<user> uEmail=new List<User>();
        String Cid=UserInfo.cId;
        Set<id> uprsntid=new set<id>();
        List<user> uFalse=new List<user>();
        system.debug('CID value is==='+Cid);
        if(!string.isempty(Cid)){
            acc=[Select id,name,CMI_Account_Status__c,CMI_Moratoriumcal__c,CMI_CId__c from account where CMI_CId__c=:Cid Limit 1];
            System.debug('Printing the account details of the customer sk obtained in the url'+acc);
            if(!acc.isEmpty()){
                //Is there a possibility to have multiple TSP's? 
                tsp=[SELECT id,CMI_Account_Name__c,CMI_Telematics_ID__c,CMI_TSP_Id__c,CMI_TSP_Name__c FROM CMI_TSP__c WHERE CMI_Account_Name__c =:acc[0].id];
                System.debug('Printing the datails of TSP to be Updated'+tsp);
           
         
            //Checking contact with the email that need to be uploaded. we need to modify this Query depending upon the dummy email flag.

            conupdate=[select FirstName,LastName,Email,CMI_Contact_Type__c from Contact where ((Email=:UserInfo.email or CMI_Flagged_E_mail_Address__c=:UserInfo.email) AND Accountid=:acc[0].id) limit 1];
            if(!conupdate.isEmpty()){
                System.debug('Printing the Contact details of the Contact that need to be updated. '+conupdate);
            }

            //setting contact ids for update and checking purposes
             
                        //Querying all the contacts to check if there are any contacts for this account.
                        con=[Select id,firstname,lastname,email,CMI_Contact_Type__c,CMI_Flagged_E_mail_Address__c,recordtypeid from contact where Accountid=:acc[0].id];
                        System.debug('Printing all the contacts of the Custome sk given in the Payload:'+con);
                        
                        //Add all the contact ids which contain Firstname and lastname as  Unknown
                        if(!con.isEmpty()){
                            //Query for all the users for respective contacts
                            uAll=[Select id,username,firstname,lastname,email from user where Contactid=:con];
                            System.debug('Printing all the users in that Account'+uAll);
                            uActive=[Select id,username,firstname,lastname,email from user where Contactid=:con and isActive=True];
                            System.debug('Printing all the active users in that account '+uActive);
                            for(Contact c :con){
                                if((c.firstname.ContainsIgnoreCase('unknown') || c.lastname.ContainsIgnoreCase('unknown'))&&c.CMI_Contact_Type__c=='Primary'){
                                    cids.add(c.id);
                                    System.debug('Printing unknown ids'+cids);
                                }//need these because we need to change these to secondary if we get a new valid contacct to insert.
                                    System.debug('Condition for primary Contact'+((!c.firstname.ContainsIgnoreCase('unknown') || !c.lastname.ContainsIgnoreCase('unknown'))&&c.CMI_Contact_Type__c=='Primary'));
                                
                                if((!c.firstname.ContainsIgnoreCase('unknown') || !c.lastname.ContainsIgnoreCase('unknown'))&&c.CMI_Contact_Type__c=='Primary'){
                                    System.debug('Printing Contact id that is going to ADD'+c.id);
                                    cpids.add(c.id);
                                    System.debug('Printing unknown ids'+cpids);
                                }
                                
                                //this is to know if email is Present in contacts and is active user.

                                System.debug('Printing user contact details' +c.email+'and email coming in payload is '+userInfo.email);
                                if(c.email==userInfo.email || c.CMI_Flagged_E_mail_Address__c==userInfo.email ){
                                uprsntid.add(c.id);
                                
                                }
                                System.debug('check to see if contact id exists with same email id'+ uprsntid);
                            }

                            if(!uprsntid.isEmpty()){
                                uEmail=[Select id,email,username,Contactid,contact.email,isActive from user where Contactid=:uprsntid];
                                System.debug('user whose email is same as of that in payload an in same account'+uEmail);
                                if(!uEmail.isEmpty()){
                                    for(user u:uEmail){
                                        if(u.isActive==True){
                                            emailpresent++;
                                        }else if(u.isActive==false){
                                            uFalse.add(u);
                                        }
                                    }
                                    System.debug('Email Present counter'+emailpresent);
                                    System.debug('user that needs to be update while insert false'+uFalse);
                                }

                            }
                        }

            }
        }
        string Fieldname = ValidateRequest(UserInfo,acc,tsp,Cid,conupdate,con,emailpresent);
        system.debug('Fieldname====' + Fieldname);
       
        
        if(Fieldname == '')
           { 
            try
            {
                Savepoint sp = Database.setSavepoint();  
                Contact newCon=new Contact();    
               try
               {
                //Default values that need to be set for both update and create operations.
                   System.debug('inserting and updating contact begins');
                    newCon.firstname=UserInfo.firstname;
                    newCon.lastname=UserInfo.lastname;
                    newCon.Phone=UserInfo.phonenumber;
                    newCon.CMI_User_Id__c=UserInfo.userId;
                    /*this is to put the contact type same when operation is update and if operation is create it has to go through abelow conditions.
                    if(UserInfo.operation.ContainsIgnoreCase('Update')&& !conupdate.isEmpty()){
                    newCon.CMI_Contact_Type__c=conupdate[0].CMI_Contact_Type__c;
                    }*/
                      
                //Below whole operation is for Create Functionality only.
                    if(UserInfo.operation.ContainsIgnoreCase('Create')&& uFalse.isEmpty() && uprsntid.isEmpty())
                    {
                       System.debug('setting contact type');
                        //Setting Contact type value to the new contact goin to be inserted?
                        if(con.isEmpty()){
                            newCon.CMI_Contact_Type__c='Primary';
                        }else if(!con.isEmpty()&& uActive.isEmpty()){
                            System.debug('Active user empty Condition contact type'+(!con.isEmpty()&& uActive.isEmpty()));
                            newCon.CMI_Contact_Type__c='Primary';
                        }else if(!con.isEmpty() && (cids.isEmpty() || !cids.isEmpty()) && cpids.isEmpty()){
                            System.debug('Else if 1');
                            System.debug('value of the Condition the is checking'+(!con.isEmpty() && cids.isEmpty() && cpids.isEmpty()));
                            newCon.CMI_Contact_Type__c='Primary';
                        }else if(!con.isEmpty() && (cids.isEmpty() || !cids.isEmpty()) && !cpids.isEmpty()){
                            System.debug('Else if 2 in Contact type');
                            System.debug('value of the Condition the is checking'+(!con.isEmpty() && (cids.isEmpty() || !cids.isEmpty()) && !cpids.isEmpty()));
                            newCon.CMI_Contact_Type__c='Secondary';
                        }

                        //Setting Dummy email id depending upon the email
                        List<Contact> con1=[select FirstName,LastName,Email,CMI_Contact_Type__c from Contact where Email=:UserInfo.email limit 1];
                        System.debug('Email check in the Whole Org while Inserting'+ con1);
                        //What if there is a user for this email and is of secondary?
                        if(con1.size() > 0 ){
                            String tspemail=tsp[0].CMI_TSP_Name__c+'.'+tsp[0].CMI_TSP_ID__c;
                            String regex=('[^a-z/gA-Z0-9.]');
                            string m=tspemail.replaceAll(regex,'');
                            newCon.email=m+'@noemail.com';
                            system.debug('Dummy emaid id has been created'+newCon.email);
                            //Assaigning some Default values.
                            newCon.CMI_User_not_Created__c=true;
                            newCon.CMI_Dummy_Email__c=true;
                            newCon.CMI_Flagged_E_mail_Address__c=UserInfo.email;
                        }else{
                            //Setting email value that came in the payload
                            newCon.email=UserInfo.email;
                        }
                    
                        //Setting all the required variables to Insert Contact
                        newCon.RecordtypeId=Schema.SObjectType.contact.getRecordTypeInfosByName().get('Product_Connectivity').getRecordTypeId();
                        newCon.Accountid=acc[0].id;
                        //inserting new Contact
                        //Database.SaveResult sr = Database.insert(newCon, false);
                        //System.debug('Printing insert result'+sr);
                        System.debug('Printing Contact Details after insertion :'+newcon);
                        insert newCon;
                        System.debug('Printing Contact Details after insertion :'+newcon);

                        //Now updating the cids which are primary and now converted to secondary when we got valid contact details for creatoin of contact.
                    
                        if(!con.isEmpty() && !(newCon.firstname.ContainsIgnoreCase('unknown') || newCon.lastname.ContainsIgnoreCase('unknown'))&&newCon.CMI_Contact_Type__c=='Primary')
                        {
                            List<Contact> uCon=[Select id,firstname,email,lastname,CMI_Contact_Type__c from Contact where id=:con];
                            System.debug('Printing contact details whose contacts need to be updated to Secondary');
                            for(Contact c:uCon){
                                if(c.id!=newCon.id){
                                    c.CMI_Contact_Type__c='Secondary';
                                }
                            }
                            update uCon;
                        }
                    }
                    //End of Contact insertion
                    //Update of contact begins when user and Contact record are present in insert function
                    if(UserInfo.operation.ContainsIgnoreCase('Create')&& (uFalse.isEmpty()||!uFalse.isEmpty()) &&!uprsntid.isEmpty()){

                        System.debug('User operation create but update has to perform');
                        List<Contact> upids= new List<Contact>();
                        List<Contact> conpids= [Select id,email from Contact where id=:uprsntid and (email=:userInfo.email or CMI_Flagged_E_mail_Address__c=:userInfo.email)];
                        System.debug('Printing user deatils uFalse'+uFalse);
                        List<user> upd=[Select id,Contactid,contact.email,username,email,companyname from user where id=:uFalse and email=:userinfo.email];
                        System.debug('Printing the user record upd'+upd);
                        //Setting Contact type 
                        if(con.isEmpty()||uAll.isEmpty()){
                            System.debug('user Primary1'+ (con.isEmpty()||uAll.isEmpty()));
                            newCon.CMI_Contact_Type__c='Primary';
                        }else if(!con.isEmpty()&&uAll.isEmpty()){
                            System.debug('user Primary 2'+ (!con.isEmpty()&&uActive.isEmpty()));
                            newCon.CMI_Contact_Type__c='Primary';
                        }else if(!con.isEmpty()&& !uAll.isEmpty() && uActive.isEmpty()){
                            System.debug('user Primary 3'+ (!con.isEmpty()&& !uAll.isEmpty() && uActive.isEmpty()));
                            newCon.CMI_Contact_Type__c='Primary';
                        }else if(!con.isEmpty()&&!uAll.isEmpty()&&!uActive.isempty()){
                            System.debug('user Secondary'+ (!con.isEmpty()&&!uAll.isEmpty()&&!uActive.isempty()));
                            newCon.CMI_Contact_Type__c='Secondary';
                        }else{
                            System.debug('else condition');
                            newCon.CMI_Contact_type__c='Secondary';
                        }
                       if(!upd.isEmpty()){
                        newCon.id=upd[0].ContactId;
                        newCon.email=upd[0].Contact.email;
                        }else{
                            newCon.id=conpids[0].Id;
                        newCon.email=conpids[0].email;
                        }
                        update newCon;
                        System.debug('Printing values for contact'+newCon);

                        //Calling update future class  to update the user.
                        if(!upd.isEmpty()){
                                updateUser(newCon.id);
                            }  
                        if(newCon.CMI_Contact_Type__c=='Primary'){   
                         System.debug('Inserted contact type is Primary'); 
                            for(Contact c:con){
                                if(c.id!=upd[0].Contactid){
                                
                                    c.CMI_Contact_Type__c='Secondary';
                                    upids.add(c);
                                }
                            }   
                        }
                        System.debug('Printing contacts that need to be updated  to secondary'+ upids);
                        update upids;

                    }


                    //Update of Contact begins
                    if(!acc.isEmpty() && !conupdate.isEmpty() && UserInfo.operation.ContainsIgnoreCase('update')){
                        newCon.id=conupdate[0].id;
                        System.debug('Value of the contact that is going to update is '+ newCon);
                        update newCon;
                        List<User> usr =[Select id,firstname,lastname from user where contactId = : newCon.id];
                        System.debug('Printing the user deatils of the contact'+usr );
                        //Calling update future class  to update the user.
                        if(!usr.isEmpty()){
                                updateUser(newCon.id);
                            }         
                        }
                         
                
                       
                        
                    

                    //if inserted or updated Contact Type is primary then wee need to do Send to PC by calling Future Method\
                    
                    //this part of code needs to get executed when update operation is performed.
                   if(!conupdate.isEmpty() && userInfo.operation.ContainsIgnoreCase('Update')){
                       if(conupdate[0].CMI_Contact_Type__c=='Primary'){
                        DoCallout(acc[0].id);     
                        //sendmailinvite(conupdate[0].email,acc[0].id,conupdate[0].Id); 
                        }
                   }
                   
                   //This part of code needs to be performed when insert operation is performed. 
                    if((newCon.CMI_Contact_Type__c=='Primary')){
                        DoCallout(acc[0].id);     
                       // sendmailinvite(newCon.email,acc[0].id,newCon.Id);     
                        }
                    
                


                    response.StatusCode = '200';
                    response.Status = 'Success';
                    response.Data = null;        
                    if(newCon.CMI_Dummy_Email__c==true && UserInfo.operation.ContainsIgnoreCase('Create')){
                        response.Message = 'Contact '+UserInfo.operation+'d Successfully and Dummy email is set.';
                    }else{
                    response.Message = 'Contact '+UserInfo.operation+'d Successfully';  
                    }
                }catch (System.DmlException e) 
                {
                    CMI_APIAccountCreation.cmiError(e.getMessage());
                    system.debug('DmlException====' + e);
                    response.StatusCode = '404';
                    response.Status = 'Unable to '+UserInfo.operation+' Contact';
                    response.Data = null;
                    for (Integer i = 0; i < e.getNumDml(); i++) {
                    // Process exception here
                        response.Message =  e.getDmlMessage(i); 
                    }
                    Database.rollback(sp);
                    return response;
                }  
    
            }
            catch (System.DmlException e) 
            {
                CMI_APIAccountCreation.cmiError(e.getMessage());
                response.StatusCode = '404';
                response.Status = 'Unable to '+UserInfo.operation+' Contact';
                response.Data = null;
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    // Process exception here
                    response.Message =  e.getDmlMessage(i); 
                }
                 //sendmailToAdmin(userdetails.firstname,userdetails.ContactfirstName,userdetails.ContactLastName,userdetails.Contactemail,response.Message);
            }            
        }
        else
        {
            CMI_APIAccountCreation.cmiError(Fieldname);
            response.StatusCode = '404';
            response.Status = 'Unable to '+UserInfo.operation+' Contact';
            response.Data = null;         
            response.Message = 'Fail : ' + Fieldname;
            //sendmailToAdmin(CustomerPayloadInfo.firstname,CustomerPayloadInfo.ContactfirstName,CustomerPayloadInfo.ContactLastName,CustomerPayloadInfo.Contactemail,response.Message);
        }
        return response;
    }
    
    private static string ValidateRequest(UserInfo userdetails,List<account> accnt,List<CMI_TSP__c> TSP,String CId,List<Contact> con2,list<Contact> con3,integer emailprsnt)
    {

        
        
        string Fieldname = '';
        
        if(String.isEmpty(CId)){

            Fieldname=Fieldname+'Customer SK is required, ';
        }
        if(!String.isEmpty(CId)&&accnt.isEmpty()){

            Fieldname=Fieldname+'445:There is no Customer with specified Customer SK '+CId+' ,';
        }
        //Reject user creation request if customer status is inactive
          if(!string.isempty(Cid)){
            List<Account> acc=[Select id,name,CMI_Account_Status__c,CMI_CId__c from account where CMI_CId__c=:Cid Limit 1];
          if(!acc.isEmpty()){
         if(acc[0].CMI_Account_Status__c =='Inactive'){

            Fieldname=Fieldname+'445:This Customer with specified Customer SK '+CId+' is inactive'+' ,';
        }
        }
        }
        //validation for update
        if(con2.isEmpty() && userdetails.operation.ContainsIgnoreCase('Update')){
            Fieldname=Fieldname+'484:User with the specified email is not present in the Customer with sk '+userdetails.cId+' ,';
        }
        System.debug('both last name and first name are unknown');
        
        //check if fn and ln is unknown in the payload
        System.debug('value of the assumtion'+(!con2.isEmpty() && userdetails.operation.ContainsIgnoreCase('Update') &&(userdetails.firstname.ContainsIgnoreCase('Unknown') || userdetails.Lastname.ContainsIgnoreCase('Unknown'))));
        if(!con2.isEmpty() && userdetails.operation.ContainsIgnoreCase('Update') &&(userdetails.firstname.ContainsIgnoreCase('Unknown') || userdetails.Lastname.ContainsIgnoreCase('Unknown'))){
            Fieldname=Fieldname+'485:User update cannot be performed because Contact FirstName and LastName is Unknown ,';
        }
        //end
       if(!con2.isEmpty() && userdetails.operation.ContainsIgnoreCase('Update') && (!(con2[0].firstname.ContainsIgnoreCase('unknown') || con2[0].lastname.ContainsIgnoreCase('unknown')))&& con2[0].CMI_Contact_Type__c=='Primary'){
          Fieldname=Fieldname+'485:User update cannot be performed for primary contact,';
          }
     
        //Checcking if all the fields only we have found account with the required SK. 
        if(!String.isEmpty(CId) && !accnt.isEmpty() && userdetails.operation.ContainsIgnoreCase('Create') && !con3.isEmpty()){
             if(!con3.isEmpty()){
                //Need to add aditional logic 
             if(emailprsnt!=0){
                    Fieldname=Fieldname+'483:user with this email is already registered for this customer,' ;
                 }   
            }
            
            //logic to update primary contact
          if(!String.isEmpty(CId) && !accnt.isEmpty() && userdetails.operation.ContainsIgnoreCase('Update') && !con3.isEmpty()){
            for(contact c:con3){
          if(c.firstname != 'unknown'|| c.lastname != 'unknown'){
                
                System.debug('Printing contact type' +c.CMI_Contact_Type__c);
                    if(c.CMI_Contact_Type__c=='Primary'){
            
                Fieldname = Fieldname + '485:primary contact lastname cannot be updated, ';
            }
           }
           }
           }
            if(userdetails.cId!=accnt[0].CMI_CId__c)
            {
                Fieldname=Fieldname + '445:Customer SK does not match with the Existing records,';
            }
            if(userdetails.operation == null || userdetails.operation.trim() == '')
            {
                Fieldname = Fieldname + '485:Operation that need to be performed is required, ';
            }
            
            if(userdetails.firstname == null || userdetails.firstname.trim() == '')
            {
                Fieldname = Fieldname + '485:firstname is required, ';
            }
            
            if(userdetails.firstname != null && userdetails.firstname.length() > 50)
            {
                Fieldname = Fieldname + '485:firstname maximum length is 50 characters , ';
            }
            if(userdetails.lastname == null || userdetails.lastname.trim() == '')
            {
               
                Fieldname = Fieldname + '485:lastname is required, ';
            }
           
            
            if(userdetails.lastname != null && userdetails.lastname.length() > 50)
            {
                Fieldname = Fieldname + '485:lastname maximum length is 50 characters , ';
            }
            if(userdetails.email == null || userdetails.email == '')
            {
            Fieldname = Fieldname + '485:Contactemail is required, ';
            }
            if(userdetails.email != null && userdetails.email != '')
            {
            
                if(!CMI_APIAccountCreation.validateEmail(userdetails.email.split(',')))
                {
                Fieldname = Fieldname + '485:Provide a valid Contactemail, ';
                }
            if(userdetails.email != null && userdetails.email.length() > 100)
            {
                Fieldname = Fieldname + '485:Contactemail maximum length is 100 characters, ';
            }    
           
            }


      }
             
            Fieldname = Fieldname.removeEnd(', ');
        
        
        return Fieldname ;
    }
    
    
    //Adding custom Exception sub-class 
    public class NoRecordMatchException extends Exception {}    
    
    
    global class CMI_ResponseHandler {
    
        //List of custom attributes that we want to check the status of the org
        public String Status {get; set;}
        public List<sObject> Data {get;set;}
        public String Message {get;set;}
        public String StatusCode {get; set;}
        
         
    }
   
    global class UserInfo {
           
             public string cId{set;get;}
             public string firstname{set;get;}
             public string lastname{set;get;}
             public string email{set;get;}
             public string userId{set;get;}
             public string phonenumber{set;get;}
             public string operation{set;get;}
             
        }  
   
@future(callout=true)
 private static void DoCallout(String accid)
 {
 
    List<Account> accnt=[Select id,name,CMI_Account_Status__c from account where id=:accid LIMIT 1];
    System.debug('Account in the Future call'+accnt);
    //Making call out to PC(Send to pc)
    String strResponse=CMI_CompanyInformation.CalloutResponseContents(accid,accnt[0].CMI_Account_Status__c,'Send To PC');
    System.debug('Printing response coming from the Company information class'+ strResponse);
       //Making account status inactive depending upon the send to pc response
    if(strResponse =='successfull'||strResponse =='OK')
    {
        system.debug('Send to PC is Successful');
    }else{  
        CMI_APIAccountCreation.cmiError(strResponse);
    }
 }

 @future(callout=true)
 public static void updateUser(String conId) {

    user u = [select id, email, Username, firstname, lastname, alias,isActive from User where contactId = : conId];
    Contact newCon = [select id,CMI_TableauId__c, email, firstName, lastName from contact where id = : conId];
    //u.email = newCon.email;
    if(system.label.css_org=='cso'){
        u.Username = newCon.email;
    }else{
        u.Username = newCon.email + '.' + system.label.css_org;
    }
    u.firstName = newCon.FirstName;
    u.LastName = newCon.LastName;
    if(newCon.LastName.length() >= 4) {
        u.alias = newCon.FirstName.substring(0, 1) + '' + newCon.LastName.substring(0, 4);
    } else if (newCon.LastName.length() <= 2 && newCon.FirstName.length() <= 2) {
        u.alias = newCon.FirstName + '' + newCon.LastName;
    }
    if(u.isActive==false){
        u.isActive=True;
    }
    try {
        update u;
    } catch (exception e) {
        String errormessage=e.getMessage()+'Customer User Class';
    CMI_APIAccountCreation.cmiError(e.getMessage());   
    }
  }
   

}