/**********************************************************************************************************************************
Name:FSL_CustomerContactWrapper
Copyright © 2019  Cummins
===================================================================================================================================
===================================================================================================================================
Purpose:                                                            
This is the wrapper class for Customer Contact details.
===================================================================================================================================
========================================================================================================================================
History                                                            
-------                                                            
VERSION                     AUTHOR                  DATE                            DETAIL                                
1.0 -                       PiyushR                 2/10/2019                       INITIAL DEVELOPMENT                     
***********************************************************************************************************************************/


public class FSL_CustomerContactWrapper {
        public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class DataArea {
        public String CustomerNumber;
        public String FirstName;
        public String MI;
        public String LastName;
        public String Salutation;
        public String Position;
        public String LocationAddressline1;
        public String LocationAddressline2;
        public String LocationAddressline3;
        public String City;
        public String State;
        public String PostalCode;
        public String PostalCodeSuffix;
        public String Country;
        public String PhoneAreaCode;
        public String PhoneNumber;
        public String Ext;
        public String FaxAreaCode;
        public String FaxNumber;
        public String Email;
        public String Comments;
        public String ContactID;
        public String LocationAddressline4;
        public String LastUpdatedDate;
        public String EventFlag;
        public String MobilePhoneNumber;
        public String EmailNotification;
        public String TextNotification;
        public String NightlyCommunication;
        public String LanguagePreference;
    }

    public Header Header;
    public List<DataArea> DataArea;

    public class Header {
        public String Status;
        public Sender Sender;
        public String Target;
        public String Location;
    }
     public class DataResponse
    {
        public string CustomerNumber ='';
        public string ContactID ='';
        public string ReturnCodeDescription ='';
         public string Status ='';
    }
    
   /* public static FSL_CustomerContactWrapper parse(String json) {
        return (FSL_CustomerContactWrapper) System.JSON.deserialize(json, FSL_CustomerContactWrapper.class);
    }*/

}