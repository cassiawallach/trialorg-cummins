/************************************************************
Name:  OSM_BOLT_WS_JournalEntryOutboundReq 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is JSON2Apex class for Journal Entry Outbound service
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/05/2018     INITIAL DEVELOPMENT          


*************************************************************/

public class OSM_BOLT_WS_JournalEntryOutboundReq {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class JE_CTRL_TBL_ROW {
        public String Order_Number;
        public String SYSTEM_CODE;
        public String STATUS;
        public String BATCH_AMOUNT;
        public String BATCH_ID;
        public String CREATION_DATE;
        public String CREATED_BY;
        public String LAST_UPDATE_DATE;
        public String LAST_UPDATED_BY;
    }

    public class JE_INV_INBND_STG_ROW_LINES {
        public String SEGMENT4;
        public String ENTERED_DR;
        public String ENTERED_CR;
        public String ACCOUNTED_DR;
        public String ACCOUNTED_CR;
        //Added for Mar-860
        public String SEGMENT1; 
        public String SEGMENT2;
        public String SEGMENT3;
        public String SEGMENT5;
        public String SEGMENT6;
        public String SEGMENT7;
    }

    public Header Header;
    public DataArea DataArea;

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public JE_INV_INBND_STG_ROW JE_INV_INBND_STG_ROW;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
        public JE_CTRL_TBL_ROW JE_CTRL_TBL_ROW;
    }

    public class JE_INV_INBND_STG_ROW {
        public String JOURNAL_ID;
        public String LEDGER_ID;
        public String LEDGER_NAME;
        public String CHART_OF_ACCOUNTS_ID;
        public String ACCOUNTING_DATE;
        public String CURRENCY_CODE;
        public String DATE_CREATED;
        //public String IN_CREATED_BY;
        public String ACTUAL_FLAG;
        public String USER_JE_CATEGORY_NAME;
        public String USER_JE_SOURCE_NAME;
        public String CURRENCY_CONVERSION_DATE;
        public String USER_CURRENCY_CONVERSION_TYPE;
        public String CURRENCY_CONVERSION_RATE;
        /*public String SEGMENT1; //Commented for Mar-860
        public String SEGMENT2;
        public String SEGMENT3;
        public String SEGMENT5;
        public String SEGMENT6;
        public String SEGMENT7; */
        public List<JE_INV_INBND_STG_ROW_LINES> JE_INV_INBND_STG_ROW_LINES;
        public String REFERENCE1;
        public String REFERENCE2;
        public String REFERENCE3;
        public String REFERENCE4;
        public String REFERENCE5;
        public String REFERENCE6;
        public String REFERENCE7;
        public String REFERENCE8;
        public String REFERENCE9;
        public String REFERENCE10;
        public String INVOICE_DATE;
        //public String TAX_CODE;
        //public String STATUS;
        public String GROUP_ID;
        public String CREATION_DATE;
        public String LAST_UPDATE_DATE;
        public String LAST_UPDATED_BY;
        public String CREATED_BY;
        public String SYSTEM_CODE; 
    }

    
    public static OSM_BOLT_WS_JournalEntryOutboundReq parse(String json) {
        return (OSM_BOLT_WS_JournalEntryOutboundReq) System.JSON.deserialize(json, OSM_BOLT_WS_JournalEntryOutboundReq.class);
    }
}