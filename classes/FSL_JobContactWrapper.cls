/**********************************************************************
Name:FSL_JobContactWrapper
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  This is the wrapper class for Job contact details
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE               DETAIL                                
1.0 -   SRIPRADA SESHAM    2/15/2019       INITIAL DEVELOPMENT                     
****************************************************************************/

public class FSL_JobContactWrapper 
{
    public list<DataArea> DataArea{get;set;}
    public Header Header;
    public FSL_JobContactWrapper()
    {
        DataArea = new list<DataArea>();
        Header = new Header();
    }
    public class DataArea 
    {
        public string DistributorCode = '';
        public string CustomerCode = '';
        public string BranchCode = '';
        public string ContactPhoneNo = '';
        public string ContactID = '';
        public string ContactName = '';
        public string EmailAddress = '';
        public string EmailNotification = '';
        public string TextNotification = '';
        public string LanguagePreference = '';
        public string NightlyCommunication = '';
        public string MobilePhoneNumber = '';
        public string LastUpdatedDate= '';
        public string EventFlag = '';   
       /* public list<ContactData> ContactDetails;
        public DataArea()
        {
            ContactDetails = new list<ContactData>();
        }*/
    }
    public class Header 
    {
        public string Status = '';
        public string ReturnCodeDescription = '';
        public Sender Sender = new Sender();
        public string Target = '';
        public string Location = '';
    }
    public class Sender
    {
        public string ServiceName = '';
        public string SenderID = '';        
    }
   
   /* public class ContactData
    {
        public string ContactPhoneNo = '';
        public string ContactID = '';
        public string ContactName = '';
        public string EmailAddress = '';
        public string LastUpdatedDate= ''; 
        public string EventFlag = '';   
    }*/
     public class DataResponse
    {
        public string CustomerCode ;
        public string ContactID ;
        public string ReturnCodeDescription ;
       public string Status ;
    }
}