/*********************************************************************************************************************************
Name:FSL_CustomerInfoWrapper
Copyright © 2019  Cummins
===================================================================================================================================
===================================================================================================================================
Purpose:                                                            
This is the wrapper class for Customer details.
===================================================================================================================================
===================================================================================================================================
History                                                            
-------                                                            
VERSION                     AUTHOR                  DATE                            DETAIL                                
1.0 -                       PiyushR                 2/10/2019                       INITIAL DEVELOPMENT                     
********************************************************************************************************************************/

public class FSL_CustomerInfoWrapper 
{
    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class DataArea {
        public String CustomerCode;
        public String InternalCustomer; //CT2-788 Karthik Pedditi
        public String LocationAddressline3;
        public String PhoneNumber;
        public String Country;
        public String CustomerName;
        public String City;
        public String LocationAddressline2;
        public String LocationAddressline1;
        public String AreaCode;
        public String PaymentType;
        public String TaxDistrict;
        public String State;
        public String Postalcode2;
        public String Postalcode1;
        public String CreditLimit;
        public String QuoteCustomer;
        public String RequirePO;
        public String AmountDue;
        public String AvailableCredit;
        public String LocationAddressline4;
        public String County;
        public List<PayerDetails> PayerDetails;
        public String LastUpdatedDate;
        public String EventFlag;
        public String ERP_Status;
        public String Type;
        public String PrimaryMarketSegment;
        public String LanguagePreference;
        public Boolean NationalAccount; //CT4-198
        public String NationalAccountMessage; //CT4-198
    }

    public Header Header;
    public List<DataArea> DataArea;

    public class Header {
        public String Status;
        public Sender Sender;
        public String Target;
        public String Location;
    }

    public class PayerDetails {
        public String PayerContactName;
        public String PayerAccountCode;
    }
    
    public static FSL_CustomerInfoWrapper parse(String json) {
        return (FSL_CustomerInfoWrapper) System.JSON.deserialize(json, FSL_CustomerInfoWrapper.class);
    }
}