/*Class to form the request payload. Account should be passed as an attribute to this to to get the payload 
*/

public class IAM_CDH_SyncRequestJsonParser{

    public String getIAMCDHRequestJson(Account accSFA){
        AccountWrapper accWrapr = new AccountWrapper();
        accWrapr.AccountNumber= (accSFA.IAM_Service_Provider_Code__c != null ? accSFA.IAM_Service_Provider_Code__c : '');
        accWrapr.accountName= (accSFA.Name != null ? accSFA.Name : '');
        accWrapr.mainPhoneNumber= (accSFA.CMI_Primary_Contact_Phone__c != null ? accSFA.CMI_Primary_Contact_Phone__c : '');
        accWrapr.MainFaxNumber= '';        
        accWrapr.Type= 'BILL TO';
        if(accSFA.CMI_Account_Status__c != null){
            if(accSFA.CMI_Account_Status__c=='Active'){
               accWrapr.AccountStatus= 'A';  
            }else if(accSFA.CMI_Account_Status__c=='Inactive'){
               accWrapr.AccountStatus='I'; 
            }
        }
       
        accWrapr.ECNNumber=(accSFA.IAM_ECN__c!= null ? accSFA.IAM_ECN__c : ''); 

        BillingAddressWrpr billAddress= new BillingAddressWrpr();

        billAddress.billingStreet= (accSFA.BillingStreet != null ? accSFA.BillingStreet : '');
            
        billAddress.billingStreet2= (accSFA.CMI_Address2__c!= null ? accSFA.CMI_Address2__c : '');


        billAddress.billingStreet3= '';
        billAddress.billingStreet4= ''; 

        billAddress.billingCity= (accSFA.BillingCity != null ? accSFA.BillingCity : '');
        billAddress.billingCountry= (accSFA.BillingCountryCode != null ? accSFA.BillingCountryCode : '');


        billAddress.BillingState= (accSFA.BillingStateCode != null ? accSFA.BillingStateCode : '');

            
        billAddress.billingPostalCode= (accSFA.BillingPostalCode != null ? accSFA.BillingPostalCode : '');           
        billAddress.billingcounty= '';


        billAddress.AddressRejectionCode='';
        billAddress.AddressVerifiedFlag=(accSFA.IAM_Verified_Flag__c != null ? accSFA.IAM_Verified_Flag__c : '');
        billAddress.AddressVerificationCode=(accSFA.IAM_Verification_code__c != null ? accSFA.IAM_Verification_code__c : '');

        accWrapr.BillingAddress=billAddress;

        ReqSender reqHeaderStr= new ReqSender(accSFA);
        TargetInfo targetInfoStr= new TargetInfo();
        HeaderInfo headerInfoStr= new HeaderInfo(reqHeaderStr, targetInfoStr);

        ReqHeader newRequestStr = new ReqHeader(headerInfoStr, accWrapr);
        // Serialize the JSON request.
        String requestStr = JSON.serialize(newRequestStr);
        return requestStr;

    }
            
    // Wrapper class for billing address
    public class BillingAddressWrpr{
        
        public string BillingStreet;
        public string BillingStreet2;
        public string BillingStreet3;
        public string BillingStreet4;
        public string BillingCity;
        public string BillingState;
        public string BillingCounty;
        public string BillingCountry;
        public string BillingPostalCode;        
        public string AddressRejectionCode;
        public string AddressVerifiedFlag;
        public string AddressVerificationCode;   
        
    }
    // Main wrapper class for Account - To send request to CDH
    public class AccountWrapper{
        
        public string AccountNumber;
        public string AccountName;   
        public string MainPhoneNumber;     
        public string MainFaxNumber;
        public string Type;
        public string AccountStatus;        
        public string ECNNumber;
        
        public BillingAddressWrpr BillingAddress;
    }
    // Header info wrapper class
    public class HeaderInfo{
        
        public ReqSender Sender;
        public TargetInfo Target; 
        
        public HeaderInfo(ReqSender SenderTmp, TargetInfo targetTmp){
            this.Sender=SenderTmp;
            this.Target=targetTmp;
        }
        
    }
    // Request header wrapper class
    public class ReqHeader {
        
        public HeaderInfo Header;
        public AccountWrapper Account;
        
        public ReqHeader(HeaderInfo headerTmp, AccountWrapper accountTmp) {
            this.Header=headerTmp;
            this.Account= accountTmp;
        }
    }
    // Request Sender wrapper class
    public class ReqSender {
        public String MessageID;
        public String ServiceName;
        public String SenderID;
                        
        public reqSender(Account acn) {
            this.SenderID = 'IAM';
            this.ServiceName = 'SyncCustomer';
            this.MessageID =(acn.IAM_Service_Provider_Code__c != null ? acn.IAM_Service_Provider_Code__c : '') ;
        }
    }
    // Target info
    public class TargetInfo{
        public string TargetID;
        
        public TargetInfo(){
            TargetId='CDH';   
        }
    }
}