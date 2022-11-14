@RestResource(urlMapping='/Account/CDHAccountUpdates/*')
global with sharing class IAM_CDH_CUSTOMER_PUBLISH{
    
    //==============================================================================================
    // *** REST Post *** :  Requires the cummins user id of user access and feature and reutrn results as Response Type
    //===============================================================================================
    @HttpPost
    global static CMI_ResponseHandler Post(DataArea DataArea)
    {
        system.debug('request====' + DataArea);
                                
        RestRequest req = RestContext.request;
        CMI_ResponseHandler response = new CMI_ResponseHandler();
         
         //Getting TSP deatils for Update         
       System.debug('Printign data rea'+DataArea.ListOfCustomers.Customer);
       
        
        List<Account> accountsToUpdate = new List<Account>();//variable to store Accounts after querying with Account Number
        List<Customer> cst=new List<Customer>();//List to store all the customers in the data area and to loop through those customer.
        Map<String,List<CrossRef>> mapAcnCrf=new Map<String,List<CrossRef>>();
        Map<String,Customer> mapAcnCustomer= new Map<String,Customer>();
        Map<String,String> mapECN =new Map<String,String>();// map to store all ECNS from the list of customers that we get in the publish.
        
        cst=DataArea.ListOfCustomers.Customer;
        for(Customer cs:cst){
            System.debug('Printing account numbers for different account'+cs.AccountNumber);
            
            //add all the custom references in the map with key as a ECN and List of Cross Reference 
            //Loop in through cross references and do the required update on the account dpending upon the Attributes.
            ListOfCrossRef CrossRefResponse = cs.ListOfCrossRef;
            List<CrossRef> crf = new List<CrossRef>();//Variable to loop in through all Cross refernces for first time this variables needs to be decleared newly for every customer.
            String customerCode='';
            //looping through cross references to get the Account number for SFIAM an store all the cross references in a new list and Store them in a map with Accountnumber as the key.
             crf= CrossRefResponse.CrossRef;
              for(CrossRef ecnVal:crf){
              //Below attribute should always be in the Label and should be equal to IAM. Please do not change that.
                    if(ecnVal.Attribute3!=null && ecnVal.Attribute3.trim()=='IAM'){
                        if(!String.isBlank(ecnVal.Attribute1)){
                            //Assaigning Account number field to the customerCode.
                            customerCode=ecnVal.Attribute1;
                        }
                    }
                }
             System.debug('Printing Customer Code'+customerCode);   
            //Checking if customerCode is Empty or nor
            if(!String.isBlank(customerCode)){
                //adding crf to the map 
                if(!mapAcnCrf.ContainsKey(customerCode)){
                    mapAcnCrf.put(customerCode,crf);
                }
                
                if(!mapAcnCustomer.ContainsKey(customerCode)){
                    mapAcnCustomer.put(customerCode,cs);
                }
                
                if(!mapECN.ContainsKey(CustomerCode)){
                    mapECN.put(customerCode,cs.EnterpriseCustomerNumber);
                }
            }   
          }
           System.debug('Printing map Details Cross references.'+mapAcnCrf) ;
           System.debug('Printing map Customer details'+mapAcnCustomer);
           System.debug('Printing map of ECN numbers'+mapECN);
           
           //Perform the query by getting all the keys from the customer Cross referce map.
           if(!mapAcnCrf.isEmpty()){
               accountsToUpdate=[select id,IAM_ECN__c,IAM_Service_Provider_Code__c from Account Where IAM_Service_Provider_Code__c=:mapAcnCrf.keySet()];
               System.debug('Prinring account details '+accountsToUpdate);
           }
       //update ecnAtrri; 
           
           //inserting list of Cross references.
          List<IAM_CDH_Cross_References__c> cdhlist=new List<IAM_CDH_Cross_References__c>();

            if(!accountsToUpdate.isEmpty()){
            for(Account ant: accountsToUpdate){
               List<CrossRef> crfs =mapAcnCrf.get(ant.IAM_Service_Provider_Code__c) ;
           
               System.debug('Printing cross references for that Account'+crfs);
           
               if(!crfs.isEmpty()){
               for(CrossRef c:crfs){
               IAM_CDH_Cross_references__c cdh= new IAM_CDH_Cross_references__c();
               cdh.IAM_Customer_ID__c=c.Attribute1;
               cdh.IAM_Party_Site_ID__c=c.Attribute2;
               cdh.IAM_Source_System__c=c.Attribute3;
               cdh.IAM_Account__c=ant.id;
               cdhlist.add(cdh);
               }
               
               } 
               
               //Updating Account ECN number as well in the Publish.
               ant.IAM_ECN__c=mapECN.get(ant.IAM_Service_Provider_Code__c);  
           }
           System.debug('Printing Cross references that are going to insert'+cdhlist);
           if(!cdhlist.isEmpty()){
            
               insert cdhlist; 
           }
           
           Update accountsToUpdate;
        }
        
            response.StatusCode = '200';
            response.Status = 'Success';
            response.Data = null;
            string tspexist = '';            
            response.Message = 'Success ';
            
        
        return response;
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
   
   global class DataArea{
      Public ListOfCustomers ListOfCustomers;
   }
     
   global class ListOfCustomers {
      Public Customer[] Customer;
    }  
   
    Public class Customer {
       public String CDHCreationDate;  
       public String CustomerSystemCode;   
       public String DomesticUltimateDUNSNumber;   
       public String EnterpriseCustomerNumber; 
       public String SPCode;   
       public String RowID;    
       public String TransactionType;  
        Public String GlobalUltimateDUNSNumber; 
        Public String OwnershipSubType; 
        Public String CDHLastUpdateDate;   
        Public String FaxNumber;    
        Public ListOfCrossRef ListOfCrossRef;
        Public String CDHCreatedBy; 
        Public String DUNSNumber;   
        Public String BatchNumber;  
        Public String DistCode; 
        Public ListOfAddresses ListOfAddresses;
        Public String CDHLastUpdatedBy; 
        Public String CDHUID;   
        Public String AccountNumber;    
        Public String BusinessName; 
        Public String EntityCode;   
        Public String Location; 
        Public String PhoneNumber;  
        Public String CDHRestrictedPartyCode;   
        Public String Name; 
        Public String OwnershipType;    
        Public String LegalName;    
        Public String Status;   
        Public String HierarchyCdName;  
        Public String ParentDUNSNumber; 
        Public String PublishDate;  
        Public String HierarchyCode;    
    }
    
    Public class ListOfCrossRef {
       Public CrossRef[] CrossRef;
    }
    
    Public class CrossRef {
        Public String EnterpriseCustomerNumber; 
        Public String Attribute44;  
        Public String Attribute45;  
        Public String RowID;    
        Public String Attribute46;  
        Public String SystemCode;   
        Public String Attribute47;  
        Public String Attribute40;  
        Public String Attribute41;  
        Public String Attribute42;  
        Public String Attribute43;  
        Public String CDHLastUpdateDate;    
        Public String AddressRejectCode;    
        Public String DimensionType;  
        Public String Attribute38;  
        Public String Attribute37;  
        Public String CDHCreatedBy; 
        Public String Attribute39;  
        Public String CDHLastUpdatedBy; 
        Public String EBSOperatingUnit; 
        Public String AccountNumber;    
        Public String Attribute35;  
        Public String Attribute36;  
        Public String Attribute33;  
        Public String Attribute34;  
        Public String Attribute31;  
        Public String Attribute32;  
        Public String Attribute30;  
        Public String Attribute29;  
        Public String Attribute28;  
        Public String Attribute27;  
        Public String Attribute26;  
        Public String CDHCreationDate;  
        Public String GlobalID; 
        Public String Attribute1;   
        Public String Type; 
        Public String Attribute3;   
        Public String Attribute2;   
        Public String Attribute5;   
        Public String Attribute4;   
        Public String Attribute20;  
        Public String Attribute7;   
        Public String TransactionType;  
        Public String Attribute21;  
        Public String Attribute6;   
        Public String Attribute48;  
        Public String Attribute22;  
        Public String Attribute9;   
        Public String Attribute49;  
        Public String Attribute23;  
        Public String Attribute8;   
        Public String Attribute24;  
        Public String Attribute25;  
        Public String Attribute16;  
        Public String Attribute55;  
        Public String Attribute15;  
        Public String Attribute18;  
        Public String Attribute17;  
        Public String Attribute52;  
        Public String Attribute51;  
        Public String Attribute19;  
        Public String Attribute54;  
        Public String Attribute53;  
        Public String Attribute50;  
        Public String BatchNumber;  
        Public String Attribute10;  
        Public String Attribute13;  
        Public String Attribute14;  
        Public String Attribute11;  
        Public String Attribute12;  
        Public String Name; 
        Public String PublishDate;  
    }
    
    Public class ListOfAddresses {
      Public  Address[] Address;
    } 
   Public class Address {
        Public String CDHCreationDate;  
        Public String EnterpriseCustomerNumber; 
        Public String RowID;    
        Public String TransactionType; 
        Public String Zipcode;  
        Public String CDHLastUpdateDate;    
        Public String Region;   
        Public String CDHCreatedBy; 
        Public String AddressName;  
        Public String StateProvince;    
        Public String CountryCode;  
        Public String AddressSystemCode;    
        Public String StateFlag;    
        Public String BatchNumber;  
        Public String CDHLastUpdatedBy; 
        Public String CDHUID;   
        Public String AccountNumber;    
        Public String VerifiedStatusMessage; 
        Public String Country;  
        Public String SubRegion;    
        Public String City; 
        Public String PrimaryAddressFlag;   
        Public String AddressID;    
        Public String Status;   
        Public String County;   
        Public String EndDate;  
        Public String VerifiedFlag; 
        Public String AddressLine4; 
        Public String AddressLine1; 
        Public String AddressLine2; 
        Public String PublishDate;  
        Public String FullAddress;  
        Public String AddressLine3; 
    }     
}