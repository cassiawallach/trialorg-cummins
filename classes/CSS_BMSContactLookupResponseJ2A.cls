/**********************************************************************
Name: CSS_BMSContactLookupRequestJ2A
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    This is used to parse the Response JSON for Contact Lookup 
Service
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Anirudh Pesari   04/10/2017       INITIAL DEVELOPMENT                    
***********************************************************************/
public class CSS_BMSContactLookupResponseJ2A
{
    public Header Header;
    public List<DataArea> DataArea{get;set;}
    public class Header{
        public String ReturnCodeDescription{get;set;}
        public String Status{get;set;}
        public Sender Sender;
        public Target Target;
        public Location Location;
    }
    public class Sender{
        public string ServiceName;
        public string MessageID;
        public string SenderID;
    }
    public class Target{
        public string TargetID;
    }
    public class Location{
        public string LocationID{get;set;}
    }
    public class DataArea{
        public String CustomerNumber{get;set;}
        public String FirstName{get;set;}
        public String MI{get;set;}
        public String LastName{get;set;}
        public String Salutation{get;set;}
        public String Position{get;set;}
        public String LocationAddressline1{get;set;}
        public String LocationAddressline2{get;set;}
        public String LocationAddressline3{get;set;}
        public String City{get;set;}
        public String State{get;set;}
        public String PostalCode{get;set;}
        public String PostalCodeSuffix{get;set;}
        public String Country{get;set;}
        public String PhoneAreaCode{get;set;}
        public String PhoneNumber{get;set;}
        public String Ext{get;set;}
        public String FaxAreacode{get;set;}
        public String FaxNumber{get;set;}
        public String Email{get;set;}
        public String Comments{get;set;}
        public String ContactID{get;set;}
    }
    public static CSS_BMSContactLookupResponseJ2A parse(String json) {
        return (CSS_BMSContactLookupResponseJ2A) System.JSON.deserialize(json, CSS_BMSContactLookupResponseJ2A.class);
    }
}