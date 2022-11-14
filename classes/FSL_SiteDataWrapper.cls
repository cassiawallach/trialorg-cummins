/**********************************************************************
Name:FSL_SiteDataWrapper
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  This is the wrapper class for Site details
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE               DETAIL                                
1.0 -   SRIPRADA SESHAM    2/8/2019       INITIAL DEVELOPMENT                     
***********************************************************************/

public class FSL_SiteDataWrapper 
{
    	public Header Header{get;set;}
        public list<DataAreaVal> DataArea {get;set;}
        public FSL_SiteDataWrapper()
        {
            Header = New Header();
            DataArea = new list<DataAreaVal>();
        }
	public class Header
    {
        string Status = '';
        string ReturnCodeDescription = '';
       	public  Sender Sender;
        string Target = '';
        string Location = '';
    }
    
    public class Sender
    {
        string ServiceName = '';
         public string SenderID;
       // string MessageID = '';
    }
    public class DataAreaVal
    {
        public string SiteID = '';
        public string SiteName = '';
        public string DistributorCode = '';
        public string CustomerCode = '';
        public string Address2 = '';
        public string Address3 = '';
        public string PostalCode = '';
        public string PostalCodeSuffix = ''; //added as part of FBI-105 changes
        public string Latitude = '';
        public string Address1 = '';
        public string City = '';
        public string TaxDistrict = '';
        public string ContactID = '';
        public string Longitude = '';
        public string EmailAddress = '';
        public string ContactPhoneNo = '';
        public string State = '';
        public string Country = '';
        public string ContactName = '';
        public string BranchCode = '';
        public string LastUpdatedDate = '';
        public string EventFlag = '';
      //  public list<AccountData> AccountDetails;
        public DataAreaVal ()
        {
            // AccountDetails = new list<AccountData>();
            
        }

    }    
    public class DataResponse
    {
        public string CustomerCode ='';
        public string SiteID ='';
        public string ReturnCodeDescription ='';
       public string Status ='';
    }
}