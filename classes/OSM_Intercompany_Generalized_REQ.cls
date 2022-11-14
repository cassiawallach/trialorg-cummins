/******
Name:  OSM_Intercompany_REQ
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       19/12/2018     INITIAL DEVELOPMENT 
2.0-   Sangeeta Rani     17/12/2019     Updated
*******/
public class OSM_Intercompany_Generalized_REQ {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String LocationID;
        public String CustomerCode;
        public Integer Attribute01;
        public String Attribute02;
        public String Attribute03;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public class CInvoice_Header {
        public String BMS_PO_NUMBER;
        public Integer BMS_OE_REFERENCE;
        public String ORDER_SOURCE_TYPE;
        public Integer BMS_INVOICE_NUMBER;
        public String ICInvoice_Number;
        public Date ICInvoice_Date;
        public String BRANCH_LOCATION;
        public String PO_Vendor;
        public Decimal INVOICE_TOTAL;
        public String CREDIT_MEMO;
        public Integer Attribute01;
        public String Attribute02;
        public String Attribute03;
    }
    
    public class R_PARTSLIST_SUBMIT {
        public String ITEM_NUMBER;
        public String PRODUCT;
        public String DESCRIPTION;
        public Integer QUANTITY;
        public String UOM;
        public Decimal SELLING_PRICE;
        public Decimal ITEM_COST;
        public String NONSTOCK_TYPE;
        public String LINE_TYPE;
        public String CUSTOMER_PO_NUMBER;
        public Integer Attribute01;
        public Integer Attribute02;
        public Integer Attribute03;
    }
    
    public class ChargeList {
        public Decimal MISC_CHARGE_AMOUNT;
        public String MISC_CHARGE;
        public Integer Attribute02;
        public Integer Attribute01;
    }


    public Header Header;
    public DataArea DataArea;
    public List<CInvoice_Header> CInvoice_Header;
    public List<ChargeList> ChargeList;
    public List<R_PARTSLIST_SUBMIT> R_PARTSLIST_SUBMIT;

    
    public static OSM_Intercompany_Generalized_REQ parse(String json) {
        return (OSM_Intercompany_Generalized_REQ) System.JSON.deserialize(json, OSM_Intercompany_Generalized_REQ.class);
    }
}