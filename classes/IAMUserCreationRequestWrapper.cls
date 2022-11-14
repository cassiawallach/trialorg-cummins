public class IAMUserCreationRequestWrapper{
  
    public cls_Sender Sender;
    public cls_UserInformation[] UserInformation;
    class cls_Sender {
        public String ServiceName;  //IAMUSERCREATION
        public String SenderName;   //CloudCraze Customer
    }
    public class cls_UserInformation {
        public String FirstName;    //Jack
        public String LastName; //Gardner
        public String Alias;    //jgard
        public String ContactID;    //003f200002l2Ety
        public String Email;    //jack@filtrationcontrol.com
        public String CommunityNickname; //jack
        //public String Username; //jack@filtrationcontrol.com
        public String FederationIdentifier;    
        public String isActive; //TRUE
        public String ProfileID;    //2F00ef2000000jNij
        public String LocaleSidKey; //en_US
        public String LanguageLocaleKey; //en_US
        public String EmailEncodingKey; //UTF-8
        public String TimezoneSidKey;   //(GMT+00:00) Greenwich Mean Time (Europe/London)
        public String UserId;
        public String Phone;    
        public String CompanyName;
        public String Street;
        public String Country;
        public String City;
        public String State;
        public String PostalCode;
        public String Address;
    }
    
    public static IAMUserCreationRequestWrapper parse(String json){
        return (IAMUserCreationRequestWrapper) System.JSON.deserialize(json, IAMUserCreationRequestWrapper.class);
    }
    
}