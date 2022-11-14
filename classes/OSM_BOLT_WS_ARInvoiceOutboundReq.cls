/************************************************************
Name:  OSM_BOLT_SW_BusinessLayerHandler 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is JSON to apex class for AR Invoice Service class. 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/05/2018     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_BOLT_WS_ARInvoiceOutboundReq {

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
        public AR_INV_INBND_STG_ROW AR_INV_INBND_STG_ROW;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public class AR_INV_INBND_STG_ROW {
        //public String TRX_ID;
        public String ENTITY_CODE;
        public String AMOUNT;
        public String VAT_AMOUNT;
        public String LINE_TYPE;
        public String TAX_CODE;
        public String SIGN;
        public String BATCH_SOURCE_NAME;
        public String INTERFACE_LINE_CONTEXT;
        public String INTERFACE_LINE_ATTRIBUTE1;
        public String INTERFACE_LINE_ATTRIBUTE2;
        public String INTERFACE_LINE_ATTRIBUTE3;
        //public String INTERFACE_LINE_ATTRIBUTE4;
        public String ACCOUNT_CLASS;
        public String LINK_TO_LINE_ATTRIBUTE2;
        public String SEGMENT1;
        public String SEGMENT2;
        public String SEGMENT3;
        public String SEGMENT4;
        public String SEGMENT5;
        public String SEGMENT6;
        public String SEGMENT7;
        public String CODE_COMBINATION_ID;
        public String CURRENCY_CODE;
        public String SET_OF_BOOKS_ID;
        public String CUST_TRX_TYPE_NAME;
        public String CUST_TRX_TYPE_ID;
        public String TRX_TYPE;
        public String BATCH_NUMBER;
        public String BATCH_DATE;
        public String BILL_TO_CUSTOMER_NUM;
        public String INVOICE_TYPE;
        public String ORACLE_CUSTOMER_NUMBER;
        public String TERM_NAME;
        public String TRX_DATE;
        public String TRX_NUMBER;
        public String ORIG_SYSTEM_BILL_CUSTOMER_REF;
        public String ORIG_SYSTEM_BILL_ADDRESS_REF;
        public String INVOICE_REF_FOR_CREDIT_MEMO ;
        public String PURCHASE_ORDER ;
        //public String CREATION_DATE;
        //public String CREATED_BY;
        //public String LAST_UPDATE_DATE;
        //public String LAST_UPDATED_BY;
        public String CONVERSION_DATE;
        public String CONVERSION_RATE;
        public String CONVERSION_TYPE;
        public String COMMENTS;
        public String OPERATING_UNIT;
        public String TRANSACTION_ID;
        public String GL_DATE;
        public String INTERFACE_LINE_ATTRIBUTE4;
        public String TRANSACTION_INFO_CONTEXT;
    }
      
    public static OSM_BOLT_WS_ARInvoiceOutboundReq parse(String json) {
        return (OSM_BOLT_WS_ARInvoiceOutboundReq) System.JSON.deserialize(json, OSM_BOLT_WS_ARInvoiceOutboundReq.class);
    }
}