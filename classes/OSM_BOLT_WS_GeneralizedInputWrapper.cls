/************************************************************
Name:  OSM_BOLT_WS_GeneralizedInputWrapper 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is generalized input wrapper class for AR Invoice and 
Journal Entry containing their dynamic paramters.  
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/05/2018     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_BOLT_WS_GeneralizedInputWrapper {

        public boolean isIntercompanyInvoice;
        public DataArea DataArea;
        public Header Header;
        
       public class AR_INV_INBND_STG_ROW{
            //Dynamic Fields - ARInvoice
            public String AMOUNT;
            public String SIGN; 
            public String INTERFACE_LINE_ATTRIBUTE2;
            public String INTERFACE_LINE_ATTRIBUTE3;
            public String CUST_TRX_TYPE_NAME;
            public String TRX_TYPE;
            public String BILL_TO_CUSTOMER_NUM;
            public String TRX_DATE;
            public String TRX_NUMBER;
            public String ORIG_SYSTEM_BILL_CUSTOMER_REF;
            public String ORIG_SYSTEM_BILL_ADDRESS_REF;
            public String BATCH_NUMBER;
            public String BATCH_DATE;
            public String ORACLE_CUSTOMER_NUMBER;
            public String TERM_NAME;
            public String SEGMENT4; //Common
            public String SEGMENT5; //Common
            public String CURRENCY_CODE; //Common
            public String CONVERSION_DATE;
            public String CONVERSION_RATE;
            public String CONVERSION_TYPE;
            public String COMMENTS;
            //public String CREATED_BY; //Common
            //public String CREATION_DATE; //Common
            //public String LAST_UPDATE_DATE; //Common
            //public String LAST_UPDATED_BY; //Common
            public String TRANSACTION_ID;
            public String ENTITY_CODE;
            public String GL_DATE;
            public String OPERATING_UNIT;
            public String PURCHASE_ORDER;
            public String INVOICE_REF_FOR_CREDIT_MEMO ;
        }
    
        //Stage Table
        public class JE_INV_INBND_STG_ROW{
            //Dynamic Fields - JournalEntry
            public String LEDGER_ID;
            public String LEDGER_NAME;
            public String ACCOUNTING_DATE;    
            public String CURRENCY_CODE; //Common           
            public String DATE_CREATED;
            public String CURRENCY_CONVERSION_DATE;
            public String USER_CURRENCY_CONVERSION_TYPE;
            public String CURRENCY_CONVERSION_RATE;
            // public String SEGMENT5;  //Commented for Mar-860
            public String REFERENCE6;
            public List<JE_INV_INBND_STG_ROW_LINES> JE_INV_INBND_STG_ROW_LINES;
            public String GROUP_ID; 
            public String CREATED_BY; //Common
            public String CREATION_DATE; //Common
            public String LAST_UPDATE_DATE; //Common
            public String LAST_UPDATED_BY; //Common
            public String INVOICE_DATE;
        }   

        //StageLine Table
        public class JE_INV_INBND_STG_ROW_LINES {
        public String SEGMENT5; //Added for Mar-860
            public String SEGMENT4; //Common
            public String ENTERED_DR;
            public String ENTERED_CR;
            public String ACCOUNTED_DR;
            public String ACCOUNTED_CR;
        }
        
        public class JE_CTRL_TBL_ROW {
            public String Order_Number;
            public String BATCH_AMOUNT;
            public String BATCH_ID;
            public String CREATION_DATE; //Common
            public String CREATED_BY;
            public String LAST_UPDATE_DATE;
            public String LAST_UPDATED_BY;
        }       
        
        public class Header{
            public JE_CTRL_TBL_ROW JE_CTRL_TBL_ROW;
            public Sender Sender;
        }
        
        public class Sender {
            public String ServiceName;
            public String SenderID;
        }
        
        public class DataArea{
            public AR_INV_INBND_STG_ROW AR_INV_INBND_STG_ROW;
            public JE_INV_INBND_STG_ROW JE_INV_INBND_STG_ROW;
        }
    
    public static OSM_BOLT_WS_GeneralizedInputWrapper parse(String json) {
        return (OSM_BOLT_WS_GeneralizedInputWrapper) System.JSON.deserialize(json, OSM_BOLT_WS_GeneralizedInputWrapper.class);
    }
}