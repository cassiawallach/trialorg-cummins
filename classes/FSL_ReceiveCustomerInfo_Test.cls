/******
 * Test Class for Apex Controller - FSL_ReceiveCustomerInfo
 * Author - Piyush Rani 
 **************/ 
@isTest
public class FSL_ReceiveCustomerInfo_Test {
    @isTest 
    static void testERPStatusBlank() {
         Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Guidanz').getRecordTypeId();
        
        List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.FSL_ERP_Customer_Code__c = '1310102';//'1964';
        acc.Name = 'Test Acc 1964';
        acc.Cmi_account_status__c = 'Active';
        acc.RecordTypeId = recTypeId;
        acc.Type = 'Customer';
        acc.FSL_Source_ERP__c = 'BMS';
        acc.Language_Preference__c = 'English';
        acc.National_Account__c =true;
        acc.Is_Internal_Account__c =true;
        accList.add(acc);
        
        Account acc2 = new Account();
        acc2.FSL_ERP_Customer_Code__c = '321';
        acc2.Name = 'Test Acc 321';
        acc2.Cmi_account_status__c = 'Active';
        acc2.RecordTypeId = recTypeId;
        acc2.Type = 'Customer';
        acc2.FSL_Source_ERP__c = 'BMS';
        acc2.Language_Preference__c = 'English';
        acc2.National_Account__c =true;
        acc.Is_Internal_Account__c =true;
        accList.add(acc2);
        insert accList;
        
        Contact con = new Contact();
        con.FirstName = 'Travis';
        con.LastName = 'Grigg';
        con.AccountId = accList[0].Id;
        con.FSL_Contact_Id__c = '40';
        con.Phone = '(042) 988-3045';
        con.Email = 'test@test.com';
        con.IAM_Contact_Status__c = 'Inactive';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        insert con;      
        
        accList[0].FSL_Source_ERP__c = 'BMS';
        update accList;
         
        FSL_ERP_Country_Translation__mdt ect= new FSL_ERP_Country_Translation__mdt();
        ect.MasterLabel='Eire';
        ect.Country__c='Ireland';
         
        CSS_CountryStateValues__c cc=new CSS_CountryStateValues__c();
        cc.CountryCode__c='US';
        cc.StateCode__c='WA';
        cc.StateName__c='Washington';
        cc.CountryName__c='United States';
        cc.name='US WA';
        insert cc;
       
        Test.startTest();
        String reqStr = FSL_TestDataUtility.getCustomerData();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/CustomerData';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(getJSONData());
        RestContext.request = req;
        RestContext.response= res;
        
        FSL_ReceiveCustomerInfo.doPostOperation();  
        req.requestBody = Blob.valueof(getJSONDataTestOne());
        RestContext.request = req;
        RestContext.response= res;
        FSL_ReceiveCustomerInfo.doPostOperation();
        
        req.requestBody = Blob.valueof(getJSONDataTestTwo());
        RestContext.request = req;
        RestContext.response= res;
        FSL_ReceiveCustomerInfo.doPostOperation();
        
        req.requestBody = Blob.valueof(getJSONDataTest3());
        RestContext.request = req;
        RestContext.response= res;
        FSL_ReceiveCustomerInfo.doPostOperation();
        
        req.requestBody = Blob.valueof(getJSONDataTest4());
        RestContext.request = req;
        RestContext.response= res;
        FSL_ReceiveCustomerInfo.doPostOperation();
        
        req.requestBody = Blob.valueof(getJSONDataTest4());
        RestContext.request = req;
        RestContext.response= res;
        FSL_ReceiveCustomerInfo.doPostOperation();
        
        req.requestBody = Blob.valueof(getJSONDataTest5());
        RestContext.request = req;
        RestContext.response= res;
        FSL_ReceiveCustomerInfo.doPostOperation();
        
        req.requestBody = Blob.valueof(getJSONDataTest6());
        RestContext.request = req;
        RestContext.response= res;
        FSL_ReceiveCustomerInfo.doPostOperation();
                
        req.requestBody = Blob.valueof(testParse());
        RestContext.request = req;
        RestContext.response= res;
        FSL_ReceiveCustomerInfo.doPatchOperation();
        
        req.requestBody = Blob.valueof(testParse());
        RestContext.request = req;
        RestContext.response= res;
        FSL_ReceiveCustomerInfo.handleUpdateCustomerRequest(req);
        
        req.requestBody = Blob.valueof(getJSONDataTest7());
        RestContext.request = req;
        RestContext.response= res;
        FSL_ReceiveCustomerInfo.handleUpdateCustomerRequest(req);
        
        Test.stopTest();
    }
    
    @isTest
    public static String getJSONData() {
        return '{'+
        '\"Header\": {'+
        '   \"Status\": \"\",'+
        '   \"Sender\":       {'+
        '        \"ServiceName\": \"GetCustomerInfo\",'+
        '        \"SenderID\": \"BMS\"'+
        '     },'+
        '   \"Target\": \"BMS\",'+
        '   \"Location\": \" \"'+
        ' },'+
        '\"DataArea\": ['+
        ' {'+
        '  \"CustomerCode\":\"1964\",'+
        '  \"LocationAddressline3\":\"Cummins CUM321\",'+
        '  \"PhoneNumber\":\"03 9420 9946\",'+
        '  \"Country\":\"Eire\",'+
        '  \"CustomerName\":\"PRPR AUSTRALIA Pvt LTD\",'+
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
        '  \"AmountDue\":\"10000\",'+
        '  \"Type\":\"Net\",'+
        '  \"PrimaryMarketSegment\":\"Agriculture\",'+
        '  \"AvailableCredit\":\"100\",'+
        '  \"LocationAddressline4\":\"VIC  8003\",'+
        '  \"County\":\"networkintegritypaya@visionstream.com.au\",'+
        '  \"LanguagePreference\":\"English\",'+
        '  \"PayerDetails\" : ['+
        '    {'+
        '      \"PayerContactName\":\" \",'+
        '     \"PayerAccountCode\":\" \"'+
        '  }'+
        '   ],'+
        '  \"LastUpdatedDate\":\"2019-03-29T13:40:00\",'+
        '  \"EventFlag\":\"\",'+
        '  \"ERP_Status\" : \"Inactive\"'+
        ' },'+
        ' {'+
        '  \"CustomerCode\":\"321\",'+
        '  \"LocationAddressline3\":\"Cummins CUM321\",'+
        '  \"PhoneNumber\":\"03 9420 9946\",'+
        '  \"Country\":\"Great Britain\",'+
        '  \"CustomerName\":\"PRPR AUSTRALIA Pvt LTD\",'+
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
        '  \"AmountDue\":\"1000\",'+
        '  \"Type\":\"Net",'+
        '  \"PrimaryMarketSegment\":\"Agriculture\",'+
        '  \"AvailableCredit\":\"100\",'+
        '  \"LocationAddressline4\":\"VIC  8003\",'+
        '  \"County\":\"networkintegritypaya@visionstream.com.au\",'+
        '  \"PayerDetails\" : ['+
        '    {'+
        '      \"PayerContactName\":\" \",'+
        '     \"PayerAccountCode\":\" \"'+
        '  }'+
        '   ],'+
        '  \"LastUpdatedDate\":\"2019-03-29T13:40:00\",'+
        '  \"EventFlag\":\"\",'+
        '  \"ERP_Status\" : \"Active\"'+
        ' }'+
        ']'+
        '}';
    }
    
    @isTest
    public static String getJSONDataTestOne() {
        return '{'+
        '\"Header\": {'+
        '   \"Status\": \"\",'+
        '   \"Sender\":       {'+
        '        \"ServiceName\": \"GetCustomerInfo\",'+
        '        \"SenderID\": \"BMS\"'+
        '     },'+
        '   \"Target\": \"BMS\",'+
        '   \"Location\": \" \"'+
        ' },'+
        '\"DataArea\": ['+
        ' {'+
        '  \"CustomerCode\":\"1964\",'+
        '  \"InternalCustomer\":\"true\", '+
        '  \"LocationAddressline3\":\"Cummins CUM321\",'+
        '  \"PhoneNumber\":\"03 9420 9946\",'+
        '  \"Country\":\"Great Britain\",'+
        '  \"CustomerName\":\"PRPR AUSTRALIA Pvt LTD\",'+
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
        '  \"AmountDue\":\"10000\",'+
        '  \"Type\":\"Net\",'+
        '  \"PrimaryMarketSegment\":\"Agriculture\",'+
        '  \"AvailableCredit\":\"100\",'+
        '  \"LocationAddressline4\":\"VIC  8003\",'+
        '  \"County\":\"networkintegritypaya@visionstream.com.au\",'+
         '  \"LanguagePreference\":\"English\",'+
        '  \"PayerDetails\" : ['+
        '    {'+
        '      \"PayerContactName\":\" \",'+
        '     \"PayerAccountCode\":\" \"'+
        '  }'+
        '   ],'+
        '  \"LastUpdatedDate\":\"2019-03-29T13:40:00\",'+
        '  \"EventFlag\":\"\",'+
        '  \"ERP_Status\" : \"Active\"'+
        ' },'+
        ' {'+
        '  \"CustomerCode\":\"321\",'+
        '  \"InternalCustomer\":\"true\", '+
        '  \"LocationAddressline3\":\"Cummins CUM321\",'+
        '  \"PhoneNumber\":\"03 9420 9946\",'+
        '  \"Country\":\"Eire\",'+
        '  \"CustomerName\":\"PRPR AUSTRALIA Pvt LTD\",'+
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
        '  \"AmountDue\":\"1000\",'+
        '  \"Type\":\"Credit",'+
        '  \"PrimaryMarketSegment\":\"Agriculture\",'+
        '  \"AvailableCredit\":\"100\",'+
        '  \"LocationAddressline4\":\"VIC  8003\",'+
        '  \"County\":\"networkintegritypaya@visionstream.com.au\",'+
        '  \"PayerDetails\" : ['+
        '    {'+
        '      \"PayerContactName\":\"Test\",'+
        '     \"PayerAccountCode\":\"1020\"'+
        '  }'+
        '   ],'+
        '  \"LastUpdatedDate\":\"2019-03-29T13:40:00\",'+
        '  \"EventFlag\":\"\",'+
        '  \"ERP_Status\" : \"Inactive\"'+
        ' }'+
        ']'+
        '}';
    }
    
     @isTest
    public static String getJSONDataTest3() {
        return '{'+
        '\"Header\": {'+
        '   \"Status\": \"\",'+
        '   \"Sender\":       {'+
        '        \"ServiceName\": \"GetCustomerInfo\",'+
        '        \"SenderID\": \"MOVEX-UK\"'+
        '     },'+
        '   \"Target\": \"MOVEX-UK\",'+
        '   \"Location\": \" \"'+
        ' },'+
        '\"DataArea\": ['+
        ' {'+
        '  \"CustomerCode\":\"1964\",'+
        '  \"InternalCustomer\":\"true\", '+
        '  \"LocationAddressline3\":\"Cummins CUM321\",'+
        '  \"PhoneNumber\":\"03 9420 9946\",'+
        '  \"Country\":\"Great Britain\",'+
        '  \"CustomerName\":\"PRPR AUSTRALIA Pvt LTD\",'+
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
        '  \"AmountDue\":\"100\",'+
        '  \"Type\":\"Net\",'+
        '  \"PrimaryMarketSegment\":\"Agriculture\",'+
        '  \"AvailableCredit\":\"100\",'+
        '  \"LocationAddressline4\":\"VIC  8003\",'+
        '  \"County\":\"networkintegritypaya@visionstream.com.au\",'+
         '  \"LanguagePreference\":\"English\",'+
        '  \"PayerDetails\" : ['+
        '    {'+
        '      \"PayerContactName\":\"Test\",'+
        '     \"PayerAccountCode\":\"1020\"'+
        '  }'+
        '   ],'+
        '  \"LastUpdatedDate\":\"2019-03-29T13:40:00\",'+
        '  \"EventFlag\":\"\",'+
        '  \"ERP_Status\" : \"Inactive\"'+
        ' },'+
        ' {'+
        '  \"CustomerCode\":\"321\",'+
        '  \"InternalCustomer\":\"true\", '+
        '  \"LocationAddressline3\":\"Cummins CUM321\",'+
        '  \"PhoneNumber\":\"03 9420 9946\",'+
        '  \"Country\":\"Eire\",'+
        '  \"CustomerName\":\"PRPR AUSTRALIA Pvt LTD\",'+
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
        '  \"AmountDue\":\"150\",'+
        '  \"Type\":\"Credit\",'+
        '  \"PrimaryMarketSegment\":\"Agriculture\",'+
        '  \"AvailableCredit\":\"100\",'+
        '  \"LocationAddressline4\":\"VIC  8003\",'+
        '  \"County\":\"networkintegritypaya@visionstream.com.au\",'+
        '  \"PayerDetails\" : ['+
        '    {'+
        '      \"PayerContactName\":\"Test\",'+
        '     \"PayerAccountCode\":\"1020\"'+
        '  }'+
        '   ],'+
        '  \"LastUpdatedDate\":\"2019-03-29T13:40:00\",'+
        '  \"EventFlag\":\"\",'+
        '  \"ERP_Status\" : \"Active\"'+
        ' }'+
        ']'+
        '}';
    }
    
    @isTest
    public static String getJSONDataTestTwo() {
        return '{'+
        '\"Header\": {'+
        '   \"Status\": \"\",'+
        '   \"Sender\":       {'+
        '        \"ServiceName\": \"GetCustomerInfo\",'+
        '        \"SenderID\": \"MOVEX-UK\"'+
        '     },'+
        '   \"Target\": \"MOVEX-UK\",'+
        '   \"Location\": \" \"'+
        ' },'+
        '\"DataArea\": ['+
        ' {'+
        '  \"CustomerCode\":\"1964\",'+
        '  \"InternalCustomer\":\"true\", '+
        '  \"LocationAddressline3\":\"Cummins CUM321\",'+
        '  \"PhoneNumber\":\"03 9420 9946\",'+
        '  \"Country\":\"USA\",'+
        '  \"CustomerName\":\"PRPR AUSTRALIA Pvt LTD\",'+
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
        '  \"AmountDue\":\"120\",'+
        '  \"Type\":\"Net\",'+
        '  \"PrimaryMarketSegment\":\"Agriculture\",'+
        '  \"AvailableCredit\":\"100\",'+
        '  \"LocationAddressline4\":\"VIC  8003\",'+
        '  \"County\":\"networkintegritypaya@visionstream.com.au\",'+
         '  \"LanguagePreference\":\"English\",'+
        '  \"PayerDetails\" : ['+
        '    {'+
        '      \"PayerContactName\":\"Test\",'+
        '     \"PayerAccountCode\":\"1020\"'+
        '  }'+
        '   ],'+
        '  \"LastUpdatedDate\":\"2019-03-29T13:40:00\",'+
        '  \"EventFlag\":\"\",'+
        '  \"ERP_Status\" : \"Active\"'+
        ' }'+
        ']'+
        '}';
    }
    
    @isTest
    public static String getJSONDataTest4() {
        return '{'+
        '\"Header\": {'+
        '   \"Status\": \"\",'+
        '   \"Sender\":       {'+
        '        \"ServiceName\": \"GetCustomerInfo\",'+
        '        \"SenderID\": \"BMS\"'+
        '     },'+
        '   \"Target\": \"MOVEX-UK\",'+
        '   \"Location\": \" \"'+
        ' },'+
        '\"DataArea\": ['+
        ' {'+
        '  \"CustomerCode\":\"1964\",'+
        '  \"InternalCustomer\":\"true\", '+
        '  \"LocationAddressline3\":\"Cummins CUM321\",'+
        '  \"PhoneNumber\":\"03 9420 9946\",'+
        '  \"Country\":\"USA\",'+
        '  \"CustomerName\":\"PRPR AUSTRALIA Pvt LTD\",'+
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
        '  \"AmountDue\":\"100\",'+
        '  \"Type\":\"Net\",'+
        '  \"PrimaryMarketSegment\":\"Agriculture\",'+
        '  \"AvailableCredit\":\"100\",'+
        '  \"LocationAddressline4\":\"VIC  8003\",'+
        '  \"County\":\"networkintegritypaya@visionstream.com.au\",'+
         '  \"LanguagePreference\":\"English\",'+
        '  \"PayerDetails\" : ['+
        '    {'+
        '      \"PayerContactName\":\"Test\",'+
        '     \"PayerAccountCode\":\"1020\"'+
        '  }'+
        '   ],'+
        '  \"LastUpdatedDate\":\"2019-03-29T13:40:00\",'+
        '  \"EventFlag\":\"\",'+
        '  \"ERP_Status\" : \"Active\"'+
        ' }'+
        ']'+
        '}';
    }
    
    @isTest
    public static String getJSONDataTest5() {
        return '{'+
        '\"Header\": {'+
        '   \"Status\": \"\",'+
        '   \"Sender\":       {'+
        '        \"ServiceName\": \"GetCustomerInfo\",'+
        '        \"SenderID\": \"BMS\"'+
        '     },'+
        '   \"Target\": \"MOVEX-UK\",'+
        '   \"Location\": \" \"'+
        ' },'+
        '\"DataArea\": ['+
        ' {'+
        '  \"CustomerCode\":\"1964\",'+
        '  \"InternalCustomer\":\"true\", '+
        '  \"LocationAddressline3\":\"Cummins CUM321\",'+
        '  \"PhoneNumber\":\"03 9420 9946\",'+
        '  \"Country\":\"US\",'+
        '  \"CustomerName\":\"PRPR AUSTRALIA Pvt LTD\",'+
        '  \"City\":\" \",'+
        '  \"LocationAddressline2\":\"LOCKED BAG 32016\",'+
        '  \"LocationAddressline1\":\"VENDOR CUM001\",'+
        '  \"AreaCode\":\" \",'+
        '  \"PaymentType\":\"Cheque Allocate\",'+
        '  \"State\":\"South Australia\",'+
        '  \"Postalcode2\":\"8003\",'+
        '  \"Postalcode1\":\"47201\",'+
        '  \"CreditLimit\":\"475000.00\",'+
        '  \"QuoteCustomer\":\" \",'+
        '  \"RequirePO\":\" \",'+
        '  \"AmountDue\":\"120\",'+
        '  \"Type\":\"Net\",'+
        '  \"PrimaryMarketSegment\":\"Agriculture\",'+
        '  \"AvailableCredit\":\"100\",'+
        '  \"LocationAddressline4\":\"VIC  8003\",'+
        '  \"County\":\"networkintegritypaya@visionstream.com.au\",'+
         '  \"LanguagePreference\":\"English\",'+
        '  \"PayerDetails\" : ['+
        '    {'+
        '      \"PayerContactName\":\"Test\",'+
        '     \"PayerAccountCode\":\"1020\"'+
        '  }'+
        '   ],'+
        '  \"LastUpdatedDate\":\"2019-03-29T13:40:00\",'+
        '  \"EventFlag\":\"\",'+
        '  \"ERP_Status\" : \"Active\"'+
        ' }'+
        ']'+
        '}';
    }
    
    @isTest
    public static String getJSONDataTest6() {
        return '{'+
        '\"Header\": {'+
        '   \"Status\": \"\",'+
        '   \"Sender\":       {'+
        '        \"ServiceName\": \"GetCustomerInfo\",'+
        '        \"SenderID\": \"BMS\"'+
        '     },'+
        '   \"Target\": \"MOVEX-UK\",'+
        '   \"Location\": \" \"'+
        ' },'+
        '\"DataArea\": ['+
        ' {'+
        '  \"CustomerCode\":\"1964\",'+
        '  \"InternalCustomer\":\"true\", '+
        '  \"LocationAddressline3\":\"Cummins CUM321\",'+
        '  \"PhoneNumber\":\"03 9420 9946\",'+
        '  \"Country\":\"US\",'+
        '  \"CustomerName\":\"PRPR AUSTRALIA Pvt LTD\",'+
        '  \"City\":\" \",'+
        '  \"LocationAddressline2\":\"LOCKED BAG 32016\",'+
        '  \"LocationAddressline1\":\"VENDOR CUM001\",'+
        '  \"AreaCode\":\" \",'+
        '  \"PaymentType\":\"Cheque Allocate\",'+
        '  \"State\":\"South Australia\",'+
        '  \"Postalcode2\":\"8003\",'+
        '  \"Postalcode1\":\"47201\",'+
        '  \"CreditLimit\":\"475000.00\",'+
        '  \"QuoteCustomer\":\" \",'+
        '  \"RequirePO\":\" \",'+
        '  \"AmountDue\":\"120\",'+
        '  \"Type\":\"Net\",'+
        '  \"PrimaryMarketSegment\":\"Agriculture\",'+
        '  \"AvailableCredit\":\"100\",'+
        '  \"LocationAddressline4\":\"VIC  8003\",'+
        '  \"County\":\"networkintegritypaya@visionstream.com.au\",'+
         '  \"LanguagePreference\":\"English\",'+
        '  \"PayerDetails\" : ['+
        '    {'+
        '      \"PayerContactName\":\"Test\",'+
        '     \"PayerAccountCode\":\"1020\"'+
        '  }'+
        '   ],'+
        '  \"LastUpdatedDate\":\"2019-03-29T13:40:00\",'+
        '  \"EventFlag\":\"\",'+
        '  \"ERP_Status\" : \"InActive\"'+
        ' }'+
        ']'+
        '}';
    }
    
    static string getJSONDataTest7() {
        return '{'+
            '\"Header\": {'+
            '   \"Status\": \"\",'+
            '   \"Sender\":       {'+
            '        \"ServiceName\": \"GetCustomerInfo\",'+
            '        \"SenderID\": \"BMS\"'+
            '     },'+
            '   \"Target\": \"CSS\",'+
            '   \"Location\": \" \"'+
            ' },'+
            '\"DataArea\": ['+
            ' {'+
            '  \"CustomerCode\":\"321\", '+
            '  \"InternalCustomer\":\"true\", '+
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
        
    }
    
     static string testParse() {
        return '{'+
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
            '  \"InternalCustomer\":\"true\", '+
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
        
    }
}