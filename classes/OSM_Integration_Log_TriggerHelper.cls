public class OSM_Integration_Log_TriggerHelper {

    public static void updateFieldsFromRequestJSON( Map<Id, OSM_Integration_Log__c> logMap ) {

        if( logMap != null &&  logMap.size() > 0 ) {
        
            //SELECT Id, Service_Name__c, Request__c, Transaction_Payment__c , Status__c FROM OSM_Integration_Log__c
            Map<Id, String> journalEntryRequestMap = new  Map<Id, String>();
            Map<Id, String> arInvoiceRequestMap = new  Map<Id, String>();
            Map<Id, string> invoiceIdToRequstMap = new Map<Id,String>();
            Map<Id, String> interCmpRequestMap = new  Map<Id, String>();
            Set<Id> transactionPaymentIds = new Set<Id>();
            List<ccrz__E_TransactionPayment__c> updateTransactionPayments = new List<ccrz__E_TransactionPayment__c>();

            for( String logId : logMap.keySet() ) {
                if( logMap.get( logId ).Status__c != null && String.valueOf( logMap.get( logId ).Status__c ) == 'Success'  ) {

                    //Journal Entry
                    if( logMap.get( logId ).Service_Name__c != null && String.valueOf( logMap.get( logId ).Service_Name__c ) == 'Journal Entry' && logMap.get( logId ).Transaction_Payment__c != null && logMap.get( logId ).Request__c != null) {
                            journalEntryRequestMap.put( String.valueOf( logMap.get( logId ).Transaction_Payment__c ), String.valueOf( logMap.get( logId ).Request__c ) );
                            transactionPaymentIds.add(logMap.get( logId ).Transaction_Payment__c);
                    }

                    //AR Invoice
                    if( logMap.get( logId ).Service_Name__c != null && String.valueOf( logMap.get( logId ).Service_Name__c ) == 'AR Invoice' && logMap.get( logId ).Transaction_Payment__c != null && logMap.get( logId ).Request__c != null) {
                            arInvoiceRequestMap.put( String.valueOf( logMap.get( logId ).Transaction_Payment__c ), String.valueOf( logMap.get( logId ).Request__c ) );
                            transactionPaymentIds.add(logMap.get( logId ).Transaction_Payment__c );
                    }

                    //IntercompanyRequest
                    if( logMap.get( logId ).Service_Name__c != null && String.valueOf( logMap.get( logId ).Service_Name__c ) == 'IntercompanyRequest' && logMap.get( logId ).Invoice__c != null && logMap.get( logId ).Request__c != null ) {
                        invoiceIdToRequstMap.put( String.valueOf( logMap.get( logId ).Invoice__c ), String.valueOf( logMap.get( logId ).Request__c ) );    
                        //interCmpRequestMap.put( String.valueOf( logMap.get( logId ).Transaction_Payment__c ), String.valueOf( logMap.get( logId ).Request__c ) );
                    }
                }
            }

            List<ccrz__E_TransactionPayment__c> tpRecordsFromInvoice = [SELECT id,ccrz__InvoiceAppliedTo__c FROM ccrz__E_TransactionPayment__c WHERE ccrz__InvoiceAppliedTo__c=:invoiceIdToRequstMap.keySet()];
            Map<string, string> inoivceIdToTpId = new Map<string, string>();
            if(!tpRecordsFromInvoice.isEmpty()) {
                for(ccrz__E_TransactionPayment__c tp : tpRecordsFromInvoice){
                    inoivceIdToTpId.put(tp.ccrz__InvoiceAppliedTo__c, tp.id);
                }
            }
            
            if(!invoiceIdToRequstMap.isEmpty()) {
                for(string ids: invoiceIdToRequstMap.keySet()) {
                    if(inoivceIdToTpId.containskey(ids)) {
                        interCmpRequestMap.put( inoivceIdToTpId.get(ids), invoiceIdToRequstMap.get(ids) );
                    }
                }
            }

            System.debug('Prinitng inter company invoice details Map with tp Ids'+interCmpRequestMap);
            
            
            if( interCmpRequestMap != null && interCmpRequestMap.size() > 0 )
                transactionPaymentIds.addAll( interCmpRequestMap.keySet() );

        
            if( transactionPaymentIds != null && transactionPaymentIds.size() > 0) {
                for( Id tpId : transactionPaymentIds ) {

                    ccrz__E_TransactionPayment__c tp = new ccrz__E_TransactionPayment__c();
                    //Journal Entry Service
                    if( journalEntryRequestMap.containsKey( tpId ) && journalEntryRequestMap.get( tpId ) != null  ) {
                        // deserialize requestJSON;
                        JournalEntryWrapper jeWrap = (JournalEntryWrapper)JSON.deserialize( String.valueOf( journalEntryRequestMap.get( tpId ) ), JournalEntryWrapper.class);
                        
                        tp.id = tpId;

                        if( jeWrap != null && jeWrap.Header != null && jeWrap.Header.JE_CTRL_TBL_ROW != null && jeWrap.Header.JE_CTRL_TBL_ROW.BATCH_ID != null ) {
                            tp.BATCH_ID__c = jeWrap.Header.JE_CTRL_TBL_ROW.BATCH_ID;
                        }

                        if( jeWrap != null && jeWrap.Header != null && jeWrap.Header.JE_CTRL_TBL_ROW != null && jeWrap.Header.JE_CTRL_TBL_ROW.BATCH_AMOUNT != null ) {
                            tp.BATCH_AMOUNT__c = jeWrap.Header.JE_CTRL_TBL_ROW.BATCH_AMOUNT;
                        }
                        
                        
                        if( jeWrap != null && jeWrap.DataArea != null && jeWrap.DataArea.JE_INV_INBND_STG_ROW != null && jeWrap.DataArea.JE_INV_INBND_STG_ROW.JE_INV_INBND_STG_ROW_LINES != null ) {
                            List<cls_JE_INV_INBND_STG_ROW_LINES> rowlines =  jeWrap.DataArea.JE_INV_INBND_STG_ROW.JE_INV_INBND_STG_ROW_LINES;
                            if( rowlines != null && rowlines.size() > 0 ) {
                                tp.SEGMENT__c = '';
                                for( cls_JE_INV_INBND_STG_ROW_LINES rl : rowlines ) {
                                    tp.SEGMENT__c += rl.SEGMENT4 + 'has DR : ' + rl.ENTERED_DR + 'has CR : ' +rl.ENTERED_CR + ' | ';
                                    if(rl.SEGMENT4 == '1291000') {
                                        tp.OSM_1291000_ENTERED_CR__c = rl.ENTERED_DR;
                                        tp.OSM_1291000_ENTERED_DR__c = rl.ENTERED_CR;
                                    }

                                    if(rl.SEGMENT4 == '0020009') {
                                        tp.OSM_0020009_ENTERED_CR__c = rl.ENTERED_DR;
                                        tp.OSM_0020009_ENTERED_DR__c = rl.ENTERED_CR;
                                    }

                                    if(rl.SEGMENT4 == '2296000') {
                                        tp.OSM_2296000_ENTERED_CR__c = rl.ENTERED_DR;
                                        tp.OSM_2296000_ENTERED_DR__c = rl.ENTERED_CR;
                                    }
                                }
                            }
                        }
                        

                        if( jeWrap != null && jeWrap.DataArea != null && jeWrap.DataArea.JE_INV_INBND_STG_ROW != null && jeWrap.DataArea.JE_INV_INBND_STG_ROW.INVOICE_DATE != null ) {
                            tp.INVOICE_DATE__c = jeWrap.DataArea.JE_INV_INBND_STG_ROW.INVOICE_DATE;
                        }
                        
                    }

                    //AR Invoice Service
                    if( arInvoiceRequestMap.containsKey( tpId ) && arInvoiceRequestMap.get( tpId ) != null ) {
                        // deserialize requestJSON
                        ARInvoice arWrap = (ARInvoice)JSON.deserialize( String.valueOf( arInvoiceRequestMap.get( tpId ) ), ARInvoice.class);
                        tp.id = tpId;

                        if( arWrap != null && arWrap.DataArea != null && arWrap.DataArea.AR_INV_INBND_STG_ROW != null && arWrap.DataArea.AR_INV_INBND_STG_ROW.TRANSACTION_ID != null ) {
                            tp.TRANSACTION_ID__C = arWrap.DataArea.AR_INV_INBND_STG_ROW.TRANSACTION_ID;
                        }

                        if( arWrap != null && arWrap.DataArea != null && arWrap.DataArea.AR_INV_INBND_STG_ROW != null && arWrap.DataArea.AR_INV_INBND_STG_ROW.SEGMENT4 != null ) {
                            tp.AR_SEGMENT__c = arWrap.DataArea.AR_INV_INBND_STG_ROW.SEGMENT4;
                        }

                        if( arWrap != null && arWrap.DataArea != null && arWrap.DataArea.AR_INV_INBND_STG_ROW != null && arWrap.DataArea.AR_INV_INBND_STG_ROW.BILL_TO_CUSTOMER_NUM != null ) {
                            tp.BILL_TO_CUSTOMER_NUM__c = arWrap.DataArea.AR_INV_INBND_STG_ROW.BILL_TO_CUSTOMER_NUM;
                        }
                        
                        if( arWrap != null && arWrap.DataArea != null && arWrap.DataArea.AR_INV_INBND_STG_ROW != null && arWrap.DataArea.AR_INV_INBND_STG_ROW.BATCH_DATE != null ) {
                            tp.BATCH_DATE__C = arWrap.DataArea.AR_INV_INBND_STG_ROW.BATCH_DATE;
                        }
                        
                        if( arWrap != null && arWrap.DataArea != null && arWrap.DataArea.AR_INV_INBND_STG_ROW != null && arWrap.DataArea.AR_INV_INBND_STG_ROW.AMOUNT != null ) {
                            tp.AMOUNT__c = arWrap.DataArea.AR_INV_INBND_STG_ROW.AMOUNT;
                        }
                        
                    }

                    //IntercompanyRequest Service
                    if( interCmpRequestMap.containsKey( tpId ) && interCmpRequestMap.get( tpId ) != null ) {
                        // deserialize requestJSON 
                        IntercompanyRequestWrapper icWrap = (IntercompanyRequestWrapper)JSON.deserialize( String.valueOf( interCmpRequestMap.get( tpId ) ), IntercompanyRequestWrapper.class);
                        tp.id = tpId;

                        
                        if( icWrap != null && icWrap.R_PARTSLIST_SUBMIT != null ) {
                            List<cls_R_PARTSLIST_SUBMIT> rpartList =  icWrap.R_PARTSLIST_SUBMIT;
                            if( rpartList != null && rpartList.size() > 0 ) {
                                tp.R_PARTSLIST__c = '';
                                for( cls_R_PARTSLIST_SUBMIT rp : rpartList ) {
                                    tp.R_PARTSLIST__c += 'Item Number: '+rp.ITEM_NUMBER+' Quantity: '+ rp.QUANTITY + ', Item Cost: ' + rp.ITEM_COST + ' | ';
                                }
                            }
                        }
                        
                        if( icWrap != null && icWrap.CInvoice_Header != null ) {
                            List<cls_CInvoice_Header> invHeaders =  icWrap.CInvoice_Header;
                            if( invHeaders != null && invHeaders.size() > 0 ) {
                                tp.BMS_PO_NUMBER__c = '';
                                for( cls_CInvoice_Header ih : invHeaders ) {
                                    tp.BMS_PO_NUMBER__c += ih.BMS_PO_NUMBER ;
                                    tp.OSM_INVOICE_TOTAL__c = ih.INVOICE_TOTAL;
                                }
                            }
                        }
                        
                    }

                    if( tp.id != null ) {
                        updateTransactionPayments.add( tp );
                    }
                }

                if( updateTransactionPayments != null && updateTransactionPayments.size() > 0 ) {
                    update updateTransactionPayments;
                }
            }

        }
    }

    //JOURNAL ENTRY Wrapper
    public class JournalEntryWrapper{
        public cls_Header Header;
        public cls_DataArea DataArea;
    }
    public class cls_Header {
        public cls_Target Target;
        public cls_Sender Sender;
        public cls_JE_CTRL_TBL_ROW JE_CTRL_TBL_ROW;
    }
    public class cls_Target {
        public String TargetID;
    }
    public class cls_Sender {
        public String ServiceName; 
        public String SenderID;
    }
    public class cls_JE_CTRL_TBL_ROW {
        public String SYSTEM_CODE; 
        public String STATUS;
        public String Order_Number; 
        public String LAST_UPDATED_BY; 
        public String LAST_UPDATE_DATE; 
        public String CREATION_DATE; 
        public String CREATED_BY; 
        public String BATCH_ID; 
        public String BATCH_AMOUNT; 
    }
    
    public class cls_DataArea {
        public cls_JE_INV_INBND_STG_ROW JE_INV_INBND_STG_ROW;
    }
    public class cls_JE_INV_INBND_STG_ROW {
        public String USER_JE_SOURCE_NAME; 
        public String USER_JE_CATEGORY_NAME; 
        public String USER_CURRENCY_CONVERSION_TYPE; 
        public String SYSTEM_CODE;
        public String REFERENCE9;
        public String REFERENCE8;
        public String REFERENCE7;
        public String REFERENCE6; 
        public String REFERENCE5; 
        public String REFERENCE4;
        public String REFERENCE3; 
        public String REFERENCE2; 
        public String REFERENCE10;
        public String REFERENCE1; 
        public String LEDGER_NAME; 
        public String LEDGER_ID; 
        public String LAST_UPDATED_BY; 
        public String LAST_UPDATE_DATE; 
        public String JOURNAL_ID;
        public List<cls_JE_INV_INBND_STG_ROW_LINES> JE_INV_INBND_STG_ROW_LINES = new List<cls_JE_INV_INBND_STG_ROW_LINES>();
        public String INVOICE_DATE; 
        public String GROUP_ID;
        public String DATE_CREATED; 
        public String CURRENCY_CONVERSION_RATE; 
        public String CURRENCY_CONVERSION_DATE; 
        public String CURRENCY_CODE; 
        public String CREATION_DATE; 
        public String CREATED_BY; 
        public String CHART_OF_ACCOUNTS_ID; 
        public String ACTUAL_FLAG; 
        public String ACCOUNTING_DATE; 
    }
    
    public class cls_JE_INV_INBND_STG_ROW_LINES {
        public String SEGMENT7; 
        public String SEGMENT6; 
        public String SEGMENT5; 
        public String SEGMENT4; 
        public String SEGMENT3;
        public String SEGMENT2; 
        public String SEGMENT1;
        public String ENTERED_DR; 
        public String ENTERED_CR; 
        public String ACCOUNTED_DR; 
        public String ACCOUNTED_CR; 
    }


    //AR INVOICE Wrapper
    public class ARInvoice{
        public cls_HeaderAR Header;
        public cls_DataAreaAR DataArea;
    }
    public class cls_HeaderAR {
        public cls_TargetAR Target;
        public cls_SenderAR Sender;
    }
    public class cls_TargetAR {
        public String TargetID; 
    }
    public class cls_SenderAR {
        public String ServiceName; 
        public String SenderID;
    }
    public class cls_DataAreaAR {
        public cls_AR_INV_INBND_STG_ROW AR_INV_INBND_STG_ROW;
    }
    public class cls_AR_INV_INBND_STG_ROW {
        public String VAT_AMOUNT; 
        public String TRX_TYPE; 
        public String TRX_NUMBER; 
        public String TRX_DATE; 
        public String TRANSACTION_INFO_CONTEXT; 
        public String TRANSACTION_ID; 
        public String TERM_NAME; 
        public String TAX_CODE; 
        public String SIGN; 
        public String SET_OF_BOOKS_ID; 
        public String SEGMENT7;
        public String SEGMENT6; 
        public String SEGMENT5; 
        public String SEGMENT4; 
        public String SEGMENT3; 
        public String SEGMENT2; 
        public String SEGMENT1; 
        public String PURCHASE_ORDER; 
        public String ORIG_SYSTEM_BILL_CUSTOMER_REF; 
        public String ORIG_SYSTEM_BILL_ADDRESS_REF; 
        public String ORACLE_CUSTOMER_NUMBER; 
        public String OPERATING_UNIT; 
        public String LINK_TO_LINE_ATTRIBUTE2; 
        public String LINE_TYPE;
        public String INVOICE_TYPE; 
        public String INVOICE_REF_FOR_CREDIT_MEMO; 
        public String INTERFACE_LINE_CONTEXT; 
        public String INTERFACE_LINE_ATTRIBUTE4; 
        public String INTERFACE_LINE_ATTRIBUTE3; 
        public String INTERFACE_LINE_ATTRIBUTE2; 
        public String INTERFACE_LINE_ATTRIBUTE1; 
        public String GL_DATE; 
        public String ENTITY_CODE; 
        public String CUST_TRX_TYPE_NAME; 
        public String CUST_TRX_TYPE_ID; 
        public String CURRENCY_CODE; 
        public String CONVERSION_TYPE; 
        public String CONVERSION_RATE; 
        public String CONVERSION_DATE; 
        public String COMMENTS;
        public String CODE_COMBINATION_ID; 
        public String BILL_TO_CUSTOMER_NUM;
        public String BATCH_SOURCE_NAME;
        public String BATCH_NUMBER; 
        public String BATCH_DATE; 
        public String AMOUNT; 
        public String ACCOUNT_CLASS; 
    }
    

    //IntercompanyRequest Wrapper
    public class IntercompanyRequestWrapper{
        public List<cls_R_PARTSLIST_SUBMIT> R_PARTSLIST_SUBMIT = new List<cls_R_PARTSLIST_SUBMIT>();
        public cls_HeaderIR Header;
        public cls_DataAreaIR DataArea;
        public List<cls_CInvoice_Header> CInvoice_Header = new List<cls_CInvoice_Header>();
        public List<cls_ChargeList> ChargeList = new List<cls_ChargeList>();
    }
    public class cls_R_PARTSLIST_SUBMIT {
        public String UOM; 
        public Integer SELLING_PRICE; 
        public Integer QUANTITY;
        public String PRODUCT; 
        public String NONSTOCK_TYPE; 
        public String LINE_TYPE; 
        public String ITEM_NUMBER; 
        public string ITEM_COST; 
        public String DESCRIPTION; 
        public String CUSTOMER_PO_NUMBER; 
        public Integer Attribute03; 
        public Integer Attribute02; 
        public Integer Attribute01; 
    }
    public class cls_HeaderIR {
        public cls_TargetIR Target;
        public cls_SenderIR Sender;
    }
    public class cls_TargetIR {
        public String TargetID; 
    }
    public class cls_SenderIR {
        public String ServiceName; 
        public String SenderID; 
    }
    public class cls_DataAreaIR {
        public String LocationID; 
        public String CustomerCode; 
        public String Attribute03; 
        public String Attribute02; 
        public Integer Attribute01; 
    }
    public class cls_CInvoice_Header {
        public String PO_VENDOR; 
        public String ORDER_SOURCE_TYPE; 
        public Integer INVOICE_TOTAL; 
        public String ICInvoice_Number; 
        public String ICInvoice_Date; 
        public String CREDIT_MEMO; 
        public String BRANCH_LOCATION; 
        public String BMS_PO_NUMBER; 
        public Integer BMS_OE_REFERENCE; 
        public Integer BMS_INVOICE_NUMBER; 
        public String Attribute03; 
        public String Attribute02;
        public Integer Attribute01; 
    }
    public class cls_ChargeList {
        public Integer MISC_CHARGE_AMOUNT; 
        public String MISC_CHARGE; 
        public Integer Attribute02;
        public Integer Attribute01; 
    }


}