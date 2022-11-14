/*
 * Test Class for Apex Controller - FSL_CustomerInfoWrapper
 * Author - Piyush Rani
 * Author - Rajesh
 */ 
@isTest
public class FSL_CustomerInfoWrapper_Test {
    static testMethod void testParse() {
        String json = '{'+
            '\"Header\": {'+
            '   \"Status\": \"\",'+
            '   \"Sender\":       {'+
            '        \"ServiceName\": \"GetCustomerInfo\",'+
            '        \"SenderID\": \"Movex\"'+
            '     },'+
            '   \"Target\": \"CSS\",'+
            '   \"Location\": \" \"'+
            ' },'+
            '\"DataArea\": ['+
            ' {'+
            '  \"CustomerCode\":\"321\", '+
            '  \"LocationAddressline3\":\"VENDOR CUM001\",'+
            '  \"PhoneNumber\":\"03 9420 9946\",'+
            '  \"Country\":\"Australia\",'+
            '  \"CustomerName\":\"VS321 AUSTRALIA PTY LTD\",'+
            '  \"City\":\" \",'+
            '  \"LocationAddressline2\":\"LOCKED BAG 32016\",'+
            '  \"LocationAddressline1\":\"VENDOR CUM001\",'+
            '  \"AreaCode\":\" \",'+
            '  \"PaymentType\":\"Cheque Allocate\",'+
            '  \"State\":\"South Australia\",'+
            '  \"Postalcode2\":\"8003\",'+
            '  \"Postalcode1\":\" \",'+
            '  \"CreditLimit\":\"475000.00\",'+
            '  \"QuoteCustomer\":\" \",'+
            '  \"RequirePO\":\" \",'+
            '  \"AmountDue\":\" \",'+
            '  \"AvailableCredit\":\" \",'+
            '  \"LocationAddressline4\":\"VIC  8003\",'+
            '  \"County\":\"networkintegritypaya@visionstream.com.au\",'+
             ' \"LanguagePreference\":\"English\",'+
            '  \"PayerDetails\" : ['+
            '    {'+
            '      \"PayerContactName\":\" \",'+
            '     \"PayerAccountCode\":\" \"'+
            '  }'+
            '   ],'+
            '  \"LastUpdatedDate\":\"2019-03-29T13:40:00\",'+
            '  \"EventFlag\":\"ADD\",'+
            '  \"ERP_Status\" : \"INACTIVE\"'+
            ' },'+
            ' {'+
            '  \"CustomerCode\":\"123\", '+
            '  \"LocationAddressline3\":\"VENDOR CUM001\",'+
            '  \"PhoneNumber\":\"03 9420 9946\",'+
            '  \"Country\":\"Australia\",'+
            '  \"CustomerName\":\"VS123 AUSTRALIA PTY LTD\",'+
            '  \"City\":\" \",'+
            '  \"LocationAddressline2\":\"LOCKED BAG 32016\",'+
            '  \"LocationAddressline1\":\"VENDOR CUM001\",'+
            '  \"AreaCode\":\" \",'+
            '  \"PaymentType\":\"Cheque Allocate\",'+
            '  \"State\":\"South Australia\",'+
            '  \"Postalcode2\":\"8003\",'+
            '  \"Postalcode1\":\" \",'+
            '  \"CreditLimit\":\"475000.00\",'+
            '  \"QuoteCustomer\":\" \",'+
            '  \"RequirePO\":\" \",'+
            '  \"AmountDue\":\" \",'+
            '  \"AvailableCredit\":\" \",'+
            '  \"LocationAddressline4\":\"VIC  8003\",'+
            '  \"County\":\"networkintegritypaya@visionstream.com.au\",'+
            '  \"PayerDetails\" : ['+
            '    {'+
            '      \"PayerContactName\":\" \",'+
            '     \"PayerAccountCode\":\" \"'+
            '  }'+
            '   ],'+
            '  \"LastUpdatedDate\":\"2019-03-29T13:40:00\",'+
            '  \"EventFlag\":\"ADD\",'+
            '  \"ERP_Status\" : \"INACTIVE\"'+
            ' }'+
            ']'+
            '}';
        FSL_CustomerInfoWrapper obj = FSL_CustomerInfoWrapper.parse(json);
        System.assert(obj != null);
    }
}