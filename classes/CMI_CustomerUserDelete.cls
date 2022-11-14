@RestResource(urlMapping = '/Customer/User/Delete/')
global with sharing class CMI_CustomerUserDelete {

 //==============================================================================================
 // *** REST Post *** :  Requires the cummins customer id of Account and reutrn results as Response Type
 // Class is mainly used to insert or update user.
 //===============================================================================================
 @HttpPost
 global static CMI_ResponseHandler Post(UserDeleteInfo UserDeleteInfovar) {
  string Fieldname = '';
  system.debug('request====' + UserDeleteInfovar);
  RestRequest req = RestContext.request;
  CMI_ResponseHandler response = new CMI_ResponseHandler();
  List < Account > acc = new List < Account > ();
  List < Contact > con = new List < Contact > ();
  String Cid = UserDeleteInfovar.cId;
  system.debug('CID value is===' + Cid);

  Fieldname = ValidateRequest(UserDeleteInfovar);

  system.debug('Fieldname====' + Fieldname);


  if (Fieldname == '') {
        System.debug('>>> 25');
   //fetch the Account Based on CID given 

   acc = [Select id, name, CMI_Account_Status__c, CMI_Moratoriumcal__c, CMI_CId__c from account where CMI_CId__c = : Cid Limit 1];

   if (!acc.isEmpty()) {
   
        System.debug('>>> 31');
    //fetch contcat with the passed email id
    con = [Select id, firstname, lastname, email, CMI_Contact_Type__c, CMI_Flagged_E_mail_Address__c, recordtypeid from contact where Accountid = : acc[0].id and email = : UserDeleteInfovar.email limit 1];

    if (!con.isEmpty()) {
     System.debug('>>> 37');
     //if passed contact first name,Last name matches with the fetched contact enter this if
     //else throw an error
     list < contact > Allcontacts = [select id, CMI_Contact_Type__c, createdDate from contact where Accountid = : acc[0].id and id != : con[0].id order by createdDate desc];
        System.debug('checkContactAllfieldsMatch(con[0], UserDeleteInfovar) '+checkContactAllfieldsMatch(con[0], UserDeleteInfovar));
     if (checkContactAllfieldsMatch(con[0], UserDeleteInfovar)) {
      System.debug('>>> 42');
      user u = new user();
      try {
       System.debug('>>> 45');
       u = [select id, isActive from user where contactid = : con[0].id];
     
      } catch (Exception ex) {

    System.debug('>>>>>> 50');
      }

      if (u != null) {
    System.debug('>>>>>> 2 '+u);
       if (!u.isActive) {
       System.debug('>>>>>> 3');
       if(!Allcontacts.isEmpty()){
       if(con[0].CMI_Contact_Type__c == 'Primary'){
           contact c = Allcontacts[0];
          doUpdateContact(c.id, con[0].id);
          return sendSuccess();
       }else{
       
       
       }
       }
        return SendErrorResponse('Unable to delete user', 'User not Active');

       } else {
            System.debug('>>>>>> 4');
        if (con[0].CMI_Contact_Type__c != 'Primary') {
        
         System.debug('>>>>>> 5');
          u.isActive = false;
          update u;
         return sendSuccess();
        } else {
         //if in case contact is Primary
         System.debug('>>>>>> 6');
         if (!Allcontacts.isEmpty()) {
          contact c = Allcontacts[0];
          
            u.isActive = false;
          update u;
          doUpdateContact(c.id, con[0].id);
          return sendSuccess();
         } else {
         
         if(con[0].CMI_Contact_Type__c == 'Primary') {
             u.isActive = false;
              update u;
              
              return sendSuccess();
         }
        //if more than one contact Not Exist amnd Passed contact is Not Primary
          return SendErrorResponse('Unable to delete user', 'User not Active');
         }



        }

       }}
        else {
        System.debug('>>> 83');
        if (con[0].CMI_Contact_Type__c != 'Primary') {
        
         //if no user exist and passed email is not primary
         return SendErrorResponse('Unable to delete user', 'User not Active');
        } else {
         //if in case contact is Primary

         if (!Allcontacts.isEmpty()) {
          contact c = Allcontacts[0];
          doUpdateContact(c.id, con[0].id);
          return sendSuccess();
         } else {
          //if no user exist and passed email is primary but no other contacts exist
          return SendErrorResponse('Unable to delete user', 'User not Active');
         }
        }


       }





      } else {
      System.debug('>>>>>>> 107');
       String Fieldname1 = '485:User delete  cannot be performed because Contact FirstName and LastName is Unknown ,';

      return  SendErrorResponse('Unable to delete user', Fieldname1);

      }
     }

    } else {

     //send error in case Accoutn Not Exist
     return SendErrorResponse('Unable to delete user', '445:There is no Customer with specified Customer SK ' + CId);

    }
   } else {
   
   System.debug('>>>>> in else 116');
    CMI_APIAccountCreation.cmiError(Fieldname);
    response.StatusCode = '404';
    response.Status = 'Unable to delete user';
    response.Data = null;
    response.Message = 'Fail : ' + Fieldname;
   }
   
    System.debug('>>>>>at line 124');
   return response;
  }


  public static CMI_ResponseHandler sendSuccess() {

   CMI_ResponseHandler response = new CMI_ResponseHandler();

   response.StatusCode = '200';
   response.Status = 'Success';
   response.Data = null;
   response.Message = 'User deleted Successfully';
   return response;

  }

  public static string ValidateRequest(UserDeleteInfo userdetails) {


   string CId = userdetails.cId;
   string Fieldname = '';
   integer emailpresent = 0;
   if (String.isEmpty(userdetails.cId)) {

    Fieldname = Fieldname + 'Customer SK is required, ';
   }

   //validation for contacts



   //end





   if (userdetails.firstname == null || userdetails.firstname.trim() == '') {
    Fieldname = Fieldname + '485:firstname is required, ';
   }

   if (userdetails.firstname != null && userdetails.firstname.length() > 50) {
    Fieldname = Fieldname + '485:firstname maximum length is 50 characters , ';
   }
   if (userdetails.lastname == null || userdetails.lastname.trim() == '') {
    Fieldname = Fieldname + '485:lastname is required, ';
   }

   if (userdetails.lastname != null && userdetails.lastname.length() > 50) {
    Fieldname = Fieldname + '485:lastname maximum length is 50 characters , ';
   }
   if (userdetails.email == null || userdetails.email == '') {
    Fieldname = Fieldname + '485:Contactemail is required, ';
   }
   if (userdetails.email != null && userdetails.email != '') {

    if (!CMI_APIAccountCreation.validateEmail(userdetails.email.split(','))) {
     Fieldname = Fieldname + '485:Provide a valid Contactemail, ';
    }
    if (userdetails.email != null && userdetails.email.length() > 100) {
     Fieldname = Fieldname + '485:Contactemail maximum length is 100 characters, ';
    }

   }


   // }


   //Fieldname = Fieldname.removeEnd(', ');


   return Fieldname;
  }


  public static boolean checkContactAllfieldsMatch(Contact con, UserDeleteInfo UserDeleteInfovar) {

   if (((UserDeleteInfovar.firstname != '' && UserDeleteInfovar.firstname != null && UserDeleteInfovar.firstname != con.firstname) || (UserDeleteInfovar.lastname != '' && UserDeleteInfovar.lastname != null && UserDeleteInfovar.lastname != con.Lastname))) {
    return false;
   }


   return true;
  }


  //Adding custom Exception sub-class 
  public class NoRecordMatchException extends Exception {}


  global class CMI_ResponseHandler {

   //List of custom attributes that we want to check the status of the org
   public String Status {
    get;
    set;
   }
   public List < sObject > Data {
    get;
    set;
   }
   public String Message {
    get;
    set;
   }
   public String StatusCode {
    get;
    set;
   }


  }

  global class UserDeleteInfo {

   global UserDeleteInfo() {}

   public string cId {
    set;
    get;
   }
   public string firstname {
    set;
    get;
   }
   public string lastname {
    set;
    get;
   }
   public string email {
    set;
    get;
   }
   public string userId {
    set;
    get;
   }
   public string phonenumber {
    set;
    get;
   }

  }

  @future
  private static void doUpdateContact(String conid, string oldconid) {

   list < Contact > AllContacts = new list < Contact > ();
   contact con = [select id,email from Contact where id = : conid];
   con.CMI_Contact_Type__c = 'Primary';

   contact con1 = [select id from Contact where id = : oldconid];
   con1.CMI_Contact_Type__c = 'Secondary';

   AllContacts.add(con);
   AllContacts.add(con1);
   update AllContacts;


   System.debug('.AllContacts  0 ' + con1);
   System.debug('.AllContacts  1 ' + con);
       
       if(con!=null){
           List<user> u=[Select id,email,username,isActive,Contactid,Contact.Accountid from user where Contactid=:con.id and isActive=true];
           if(!u.isEmpty()){
               System.debug('enterd sent invite email and printing user details of primary contact'+u);
              // CMI_CustomerUser.sendmailinvite(u[0].email,u[0].contact.Accountid,u[0].contactid);
           }    
        }
  }

  public static CMI_ResponseHandler SendErrorResponse(String Status, String msg) {
   CMI_ResponseHandler response = new CMI_ResponseHandler();

   response.StatusCode = '404';
   response.Status = Status; //'Unable to delete user';
   response.Data = null;
   response.Message = msg;

   return response;
  }
  //email for invite user 
public static void sendmailinvite(String email,String AccId,Id ConId){

    system.debug('entered email function'+email);    
    EmailTemplate template = [SELECT id FROM EmailTemplate WHERE name  ='CMI_Invite Page'];
    System.debug('printing template'+template);
    String[] toAddresses = new String[]{email};
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
}  
 }