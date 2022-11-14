public class IAM_CST_ReqParserNew {
    public Static String newCSTPayload(Set<id> conids){
     String JSONString='';
     
     List<Contact> conList=[SELECT id,FirstNAme,LAstNAme,Email,Username__c,IAM_Ext_Legacy_UID__c,Phone,Account.IAM_service_Provider_code__c from Contact where id=:conids];
     List<UserPayload> lstWrapper = new List<UserPayload>();
     for(Contact con:conList){
         lstWrapper.add(new Userpayload(con));
     }
        System.debug('Printing request wrapper'+lstWrapper);
        if(lstWrapper!=null){
            JSONString = JSON.serialize(lstWrapper);
            System.debug('Printing serialized string '+JSONString);
        }
     
     return JSONString;
        
    }
    
    
    
  
    public class UserPayload{
        public string first_name{set;get;}
        public string middle_name{set;get;}
        public string last_name{set;get;}
        public string company_email{set;get;}
        public string company_phone{set;get;}
        public string sp_code{set;get;}
        public string username{set;get;}
        public string current_username {set;get;}
        public string sfiam_id {set;get;}
        public string previous_username {set;get;}
       
        
        public UserPayload(Contact con){
        
            system.debug('calling the userinfo');
            
            this.first_name=con.firstName;
            this.middle_Name='';
            this.last_name=con.lastname;
            this.company_email=con.email;
            this.company_Phone=con.phone;
            this.sp_code=con.Account.IAM_Service_Provider_code__c;
            this.Username=Con.Username__c;
            this.current_username=UserInfo.getUserName();
            this.sfiam_id=con.id;
            this.previous_username=Con.IAM_Ext_Legacy_UID__C;
            
            }

}
    
    }