/******
Name:  OSM_FSDPDF_REQ
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       17/12/2018     INITIAL DEVELOPMENT 
*******/
public class OSM_FSDPDF_REQ {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public Header Header;
    public DataArea DataArea;

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String  DistributorID;
        public String CustomerCode;
        public List<CInvoice_Header> CInvoice_Header;
        public String Attribute01;
        public String Attribute02;
        public String Attribute03;
    }

    public class Header {
        public String Status;
        public Sender Sender;
        public Target Target;
    }

    public class CInvoice_Header {
        public Integer BMS_OE_REFERENCE;
        public String BRANCH_LOCATION;
        public String ORDER_SOURCE_TYPE;
        public Integer BMS_INVOICE_NUMBER;
        
        public String OSM_INVOICE_NUMBER; // for now actually contains the Order Number
        
        public String BMSInvoicePDF;
        public String Attribute01;
        public String Attribute02;
        public String Attribute03;
    }

    
    public static OSM_FSDPDF_REQ parse(String json) {
        return (OSM_FSDPDF_REQ) System.JSON.deserialize(json, OSM_FSDPDF_REQ.class);
    }
}