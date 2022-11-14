/******
Name:  OSM_WS_GeneralizedSubmitOrderOutputWrap
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       23/10/2018     INITIAL DEVELOPMENT 
*******/
public class OSM_WS_GeneralizedSubmitOrderOutputWrap{
    public String errorMsg;
    public Boolean errorFlag;
    public OSM_Integration_Log__c log;
    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public P_FSD_OUT P_FSD_OUT;
        public String P_DIST_CODE;
        public String P_CUSTOMER_CODE;
    }

    public DataArea DataArea;
    public Header Header;

    public class P_FSD_OUT {
        
        public String PDF_REMITTO_ADDRESS;
        
        public String REMIT_TO_STATE;
        public String REMIT_TO_POSTAL_CODE;
        public String REMIT_TO_NAME;
        public String BMS_PO_NUMBER;
        public String REMIT_TO_ADDRESS;
        public String BRANCH_LOCATION;
        public String Attribute01;
        public String TOTAL_DISCOUNT;
        public String ORDER_SOURCE_TYPE;
        public String INVOICE_TOTAL;
        public String Attribute03;
        public String BMS_INVOICE_NUMBER;
        public String Attribute02;
        public String INVOICE_DATE;
        public String CREATE_DATE;
        public String BMS_OE_REFERENCE;
        public String REMIT_TO_CITY;
            }

    public class Header {
        public String Status;
        public Sender Sender;
        public Target Target;
        public String ReturnCodeDescription;
        public Location Location;
    }

    public class Location {
        public String LocationID;
    }
    
    public OSM_WS_GeneralizedSubmitOrderOutputWrap()
    {
        
    }
}