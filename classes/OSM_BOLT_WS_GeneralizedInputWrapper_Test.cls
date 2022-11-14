//Test Class for the class OSM_BOLT_WS_GeneralizedInputWrapper
@IsTest
public class OSM_BOLT_WS_GeneralizedInputWrapper_Test {
	static testMethod void testParse() {
        String json = '{'+
        '  \"Header\": {' +
        '    	\"Sender\": {' +
        '           \"ServiceName\": \"ARInvoiceOutbound\",'+
        '           \"SenderID\": \"OSM\"'+
        '       	},'+
        '   	 \"Target\": {'+
        '           \"TargetID\": \"BOLT\"'+
        '         }'+
        '   },'+
        '  \"DataArea\": {'+
        '    \"AR_INV_INBND_STG_ROW\": {'+
        '      \"AMOUNT\": \"1134.44\",'+
        '      \"SIGN\": null,'+
        '      \"INTERFACE_LINE_ATTRIBUTE2\": \"869640563\",'+
        '      \"SEGMENT4\": \"0020009\",'+
        '      \"SEGMENT5\": \"000\",'+
        '      \"CURRENCY_CODE\": \"USD\",'+
        '      \"CUST_TRX_TYPE_NAME\": \"869511d\",'+
        '      \"TRX_TYPE\": null,'+
        '      \"BILL_TO_CUSTOMER_NUM\": \"05037\",'+
        '      \"TRX_DATE\": \"09-FEB-2018\",'+
        '      \"TRX_NUMBER\": \"869640563\",'+
        '      \"ORIG_SYSTEM_BILL_ADDRESS_REF\": \"03933B\",'+
        '      \"CREATION_DATE\": null,'+
        '      \"BATCH_NUMBER\": \"839\",'+
        '      \"BATCH_DATE\": \"09-FEB-2018\",'+
        '      \"ORACLE_CUSTOMER_NUMBER\": \"327580\",'+
        '      \"TERM_NAME\": \"021\"'+
        '    },'+
        '    \"JE_INV_INBND_STG_ROW\": {'+
        '       \"JOURNAL_ID\": \"1612185505439\",'+
      	'		\"SYSTEM_CODE\": \"SOMSUS_01\",'+
      	'		\"STATUS\": \"VALIDATED\",'+
      	'		\"LEDGER_ID\": \"2041\",'+
      	'		\"LEDGER_NAME\": \"US Primary USD\",'+
      	'		\"CHART_OF_ACCOUNTS_ID\": \"50368\",'+
      	'		\"ACCOUNTING_DATE\": \"09-FEB-2018\",'+
      	'		\"CURRENCY_CODE\": \"USD\",'+
      	'		\"DATE_CREATED\": \"09-FEB-2018\",'+
      	'		\"ACTUAL_FLAG\": \"A\",'+
      	'		\"USER_JE_CATEGORY_NAME\": \"Sales Invoices\",'+
      	'		\"USER_JE_SOURCE_NAME\": \"OSM\",'+
      	'		\"CURRENCY_CONVERSION_DATE\": \"09-FEB-2018\",'+
      	'		\"USER_CURRENCY_CONVERSION_TYPE\": \"User\",'+
      	'		\"CURRENCY_CONVERSION_RATE\": \"1.23\",'+
      	'		\"SEGMENT1\": \"869\",'+
      	'		\"SEGMENT2\": \"511\",'+
      	'		\"SEGMENT3\": \"5116650\",'+
      	'		\"SEGMENT4\": \"0020009\",'+
      	'		\"SEGMENT5\": \"000\",'+
      	'		\"SEGMENT6\": \"00000\",'+
      	'		\"SEGMENT7\": \"0000\",'+
        '     \"JE_INV_INBND_STG_ROW_LINES\":[{' +
            '		\"ENTERED_DR\": \"134303.22\",'+
            '		\"ENTERED_CR\": \"0\",'+
            '		\"ACCOUNTED_DR\": \"134303.22\",'+
            '		\"ACCOUNTED_CR\": \"0\"'+
            '    }],'+
      	'		\"REFERENCE1\": \"BC045RC045\",'+
      	'		\"REFERENCE2\": null,'+
      	'		\"REFERENCE3\": null,'+
      	'		\"REFERENCE4\": null,'+
      	'		\"REFERENCE5\": null,'+
      	'		\"REFERENCE6\": \"20161218023301\",'+
      	'		\"REFERENCE7\": null,'+
      	'		\"REFERENCE8\": null,'+
      	'		\"REFERENCE9\": null,'+
      	'		\"REFERENCE10\": null,'+
        '      \"GROUP_ID\": \"20161218023301\",'+
        '      \"INVOICE_DATE\": \"09-FEB-2018\",'+
        '      \"TAX_CODE\": null,'+
        '      \"CREATION_DATE\": \"12/18/2016 8:33:37 AM\",'+
        '      \"CREATED_BY\": \"1234\",'+
        '      \"LAST_UPDATE_DATE\": \"12/18/2016 8:33:39 AM\",'+
        '      \"LAST_UPDATED_BY\": \"1234\"'+
        '    }'+
        '  }'+
        '}';
        
        OSM_BOLT_WS_GeneralizedInputWrapper obj = OSM_BOLT_WS_GeneralizedInputWrapper.parse(json);
        System.assert(obj != null);
    }
}