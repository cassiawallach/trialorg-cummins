/************************************************************
Name:  OSM_BMS_WS_CustomerOuboundRes
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is the response wrapper class.

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta            23/10/2018     INITIAL DEVELOPMENT          


*************************************************************/
public class OSM_BMS_WS_CustomerOuboundRes {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String CustomerCode;
        public String LocationAddressline3;
        public String PhoneNumber;
        public String Country;
        public String CustomerName;
        public String City;
        public String LocationAddressline2;
        public String LocationAddressline1;
        public String AreaCode;
        public String PaymentType;
        public String State;
        public String Postalcode2;
        public String Postalcode1;
        public String CreditLimit;
        public String QuoteCustomer;
        public String RequirePO;
        public Decimal AmountDue;
        public Decimal AvailableCredit;
    }

    public class Header {
        public String Status;
        public Sender Sender;
        public Target Target;
        public Location Location;
        public String ReturnCodeDescription;
    }

    public List<DataArea> DataArea;
    public Header Header;

    public class Location {
        public String LocationID;
    }

    
    public static OSM_BMS_WS_CustomerOuboundRes parse(String json) {
        return (OSM_BMS_WS_CustomerOuboundRes) System.JSON.deserialize(json, OSM_BMS_WS_CustomerOuboundRes.class);
    }
}