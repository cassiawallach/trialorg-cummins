//Test Class for the class OSM_BOLT_WS_JournalEntryOutboundReq
/************************************************************
Name:  OSM_BOLT_WS_JournalEntryOutboundReq_Test 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for OSM_BOLT_WS_JournalEntryOutboundReq class
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         08/05/2018     INITIAL DEVELOPMENT          


*************************************************************/

@IsTest
public class OSM_BOLT_WS_JournalEntryOutboundReq_Test {
    
    static testMethod void testParse() {
        String json = '{  '+
        '   \"Header\":{  '+
        '      \"Sender\":{  '+
        '         \"ServiceName\":\"JournalEntry\",'+
        '         \"SenderID\":\"OSM\"'+
        '      },'+
        '      \"Target\":{  '+
        '         \"TargetID\":\"BOLT\"'+
        '      },'+
        '      \"JE_CTRL_TBL_ROW\":{  '+
        '         \"Order_Number\":\"O-0000000099\",'+
        '         \"SYSTEM_CODE\":\"OSM_01\",'+
        '         \"STATUS\":\"VALIDATED\",'+
        '         \"BATCH_AMOUNT\":\"9000.00\",'+
        '         \"BATCH_ID\":\"20161218023301\",'+
        '         \"CREATION_DATE\":\"12/18/2016 8:33:37 AM\",'+
        '         \"CREATED_BY\":\"1234\",'+
        '         \"LAST_UPDATE_DATE\":\"12/18/2016 8:33:39 AM\",'+
        '         \"LAST_UPDATED_BY\":\"1234\"'+
        '      }'+
        '   },'+
        '   \"DataArea\":{  '+
        '      \"JE_INV_INBND_STG_ROW\":{  '+
        '         \"JOURNAL_ID\":null,'+
        '         \"LEDGER_ID\":\"2041\",'+
        '         \"LEDGER_NAME\":\"US Primary USD\",'+
        '         \"CHART_OF_ACCOUNTS_ID\":\"50368\",'+
        '         \"ACCOUNTING_DATE\":\"09-FEB-2018\",'+
        '         \"CURRENCY_CODE\":\"USD\",'+
        '         \"DATE_CREATED\":\"09-FEB-2018\",'+
        '         \"IN_CREATED_BY\":\"-1\",'+
        '         \"ACTUAL_FLAG\":\"A\",'+
        '         \"USER_JE_CATEGORY_NAME\":\"Sales Invoices\",'+
        '         \"USER_JE_SOURCE_NAME\":\"OSM\",'+
        '         \"CURRENCY_CONVERSION_DATE\":\"09-FEB-2018\",'+
        '         \"USER_CURRENCY_CONVERSION_TYPE\":\"User\",'+
        '         \"CURRENCY_CONVERSION_RATE\":\"1.23\",'+
        '         \"SEGMENT1\":\"598\",'+
        '         \"SEGMENT2\":\"207\",'+
        '         \"SEGMENT3\":\"2076903\",'+
        '         \"SEGMENT5\":\"000\",'+
        '         \"SEGMENT6\":\"00000\",'+
        '         \"SEGMENT7\":\"0000\",'+
        '         \"JE_INV_INBND_STG_ROW_LINES\":[  '+
        '            {  '+
        '               \"SEGMENT4\":\"1291000\",'+
        '               \"ENTERED_DR\":\"8000.00\",'+
        '               \"ENTERED_CR\":\"0\",'+
        '               \"ACCOUNTED_DR\":\"9840.00\",'+
        '               \"ACCOUNTED_CR\":\"0\"'+
        '            },'+
        '            {  '+
        '               \"SEGMENT4\":\"0574000\",'+
        '               \"ENTERED_DR\":\"1200.00\",'+
        '               \"ENTERED_CR\":\"0\",'+
        '               \"ACCOUNTED_DR\":\"1476.00\",'+
        '               \"ACCOUNTED_CR\":\"0\"'+
        '            },'+
        '            {  '+
        '               \"SEGMENT4\":\"2296000\",'+
        '               \"ENTERED_DR\":\"0\",'+
        '               \"ENTERED_CR\":\"200.00\",'+
        '               \"ACCOUNTED_DR\":\"0\",'+
        '               \"ACCOUNTED_CR\":\"246.00\"'+
        '            },'+
        '            {  '+
        '               \"SEGMENT4\":\"0020012\",'+
        '               \"ENTERED_DR\":\"200.00\",'+
        '               \"ENTERED_CR\":\"9200.00\",'+
        '               \"ACCOUNTED_DR\":\"246.00\",'+
        '               \"ACCOUNTED_CR\":\"11316.00\"'+
        '            }'+
        '         ],'+
        '         \"REFERENCE1\":\"BC045RC045\",'+
        '         \"REFERENCE2\":null,'+
        '         \"REFERENCE3\":null,'+
        '         \"REFERENCE4\":null,'+
        '         \"REFERENCE5\":null,'+
        '         \"REFERENCE6\":\"20161218023301\",'+
        '         \"REFERENCE7\":null,'+
        '         \"REFERENCE8\":null,'+
        '         \"REFERENCE9\":null,'+
        '         \"REFERENCE10\":null,'+
        '         \"INVOICE_DATE\":\"09-FEB-2018\",'+
        '         \"TAX_CODE\":null'+
        '      }'+
        '   }'+
        '}';
        OSM_BOLT_WS_JournalEntryOutboundReq obj = OSM_BOLT_WS_JournalEntryOutboundReq.parse(json);
        System.assert(obj != null);
    }
}