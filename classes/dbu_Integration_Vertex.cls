global class dbu_Integration_Vertex {
    
    private  static String ENP_POINT_URL;
    private final static String REQUEST_BODY = 'grant_type=client_credentials&client_id={0}&client_secret={1}&scope={2}';
    private  static String RESOURCE_URL;
    private  static String SCOPE;
    private  static String CONSUMER_KEY;
    private  static String CONSUMER_SECRET;
    private  static String METHOD_TYPE;
    private  static Integer Timeout = 120000;
    private final static String TAX_INVOICE_END_POINT;
    
    private static String getAccessToken(){
        TokenResponse resp; 
        String reqJsonBody;
        Map<String, String> reqMap = new Map<String, String>();
        try{
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_VertexQuote_Auth');
            ENP_POINT_URL = conDetails.End_Point__c;
            CONSUMER_KEY = conDetails.Key__c;
            CONSUMER_SECRET = conDetails.Passcode__c;
            METHOD_TYPE = conDetails.Method_Type__c;
            RESOURCE_URL = conDetails.Resource__c;
            if(conDetails.Timeout__c != null)
                Timeout = Integer.valueOf(conDetails.Timeout__c);
            //SCOPE = conDetails.Logging__c;
            reqMap.put('client_id',CONSUMER_KEY);
            reqMap.put('client_secret',CONSUMER_SECRET);
            reqMap.put('resource',RESOURCE_URL);
            reqJsonBody = JSON.serialize(reqMap);
            System.debug('reqJsonBody===\t'+reqJsonBody+'ENP_POINT_URL\t'+ENP_POINT_URL+'\tCONSUMER_KEY'+CONSUMER_KEY+'\t CONSUMER_SECRET'+CONSUMER_SECRET+'\t METHOD_TYPE'+METHOD_TYPE);
            HttpRequest req = new HttpRequest();
            req.setEndpoint(ENP_POINT_URL);
            req.setMethod(METHOD_TYPE);
            req.setTimeout(Timeout);
            req.setBody(reqJsonBody);
            req.setHeader('Content-Type','application/json');
            //req.setBody(String.format(REQUEST_BODY ,new string[]{CONSUMER_KEY,CONSUMER_SECRET,
            //    RESOURCE_URL}));
           
            Http http = new Http();
            HttpResponse res = http.send(req);
            System.debug('resp of access token:::::::::::'+resp);
            resp = (TokenResponse)JSON.deserialize(res.getbody(), TokenResponse.class);
            system.debug('name and acce token '+ resp.token_type +' '+ resp.access_token);
            return resp.token_type +' '+ resp.access_token;
        }catch(Exception ce){
            dbu_Integration_Error_Log.createErrorLog(null,ce.getMessage(),reqJsonBody,'','Vertex Auth Service','Exception');
            String Token = 'Error';//INC2628005
            return token;//INC2628005
        }       
    }
    public class TokenResponse {       
        public String token_type;        
        public String expires_in;        
        public String access_token;   
        public String refresh_token;
        public String scope;
    }
    @AuraEnabled
    public static dbu_Vertex_GeneralizedoutputWrapper getTaxQuote(dbu_Vertex_GeneralizedInputWrapper objVertexGeneralWrapper){
        string mSec;
        dbu_Vertex_GeneralizedoutputWrapper objReturn = new dbu_Vertex_GeneralizedoutputWrapper();
        string correctedJsonStr;//INC2628005
        string correctedResponse;//INC2628005
        try{
            System.debug('objVertexGeneralWrapper:=> '+JSON.serialize(objVertexGeneralWrapper));
            String accessToken = getAccessToken();
             // Production CR change to avoid 403 forbidden issue for vertex API 
             if(accessToken == 'Error' || String.isBlank(accessToken)){
                objReturn.Status = 'Error';
                return objReturn;
            }
            dbu_VertexquoteResponseWrapper responseObj = new dbu_VertexquoteResponseWrapper();
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_VertexQuote_Service');
            METHOD_TYPE = conDetails.Method_Type__c;
            RESOURCE_URL = conDetails.End_Point__c;
            CONSUMER_KEY = conDetails.Key__c;
            CONSUMER_SECRET = conDetails.Passcode__c;
            if(conDetails.Timeout__c != null)
                Timeout = Integer.valueOf(conDetails.Timeout__c);
            dbu_VertexQuoteRequestWrapper requestObj = Dbu_Vertex_Service_Helper.populateDynamicData(objVertexGeneralWrapper);
            //string reqjson='{"Header": {"Transaction": {"Trusted_ID": "","TransactionID": "","Transaction_Type": "SALE","QuotationRequestDocumentNumber": "00000313","DocumentDate": "2018-07-13"},"Target": {"TargetID": "Vertex"},"Sender": {"ServiceName": "QuotationRequest","SenderID": "OSM"}},"DataArea": {"Seller": {"Physical_Origin": {"State": "IN","Postal_Code": "47201-6258","Country": "USA","City": "Columbus","AddressLine2": "","AddressLine1": "500 Jackson St"},"Division_Code": "CMI","Company_Code": "00","AdministrativeOrigin": {"State": "IN","Postal_Code": "47201-6258","Country": "USA","City": "Columbus","AddressLine2": "","AddressLine1": "500 Jackson St"}},"ProductList": [{"UnitOfMeasure": "","RC": "207","Quantity": "4","ProductCode": "5678901-OHT","ProductClassCode": "SW-Web Access","LineItemNumber": "00001140","ExtendedPrice": "470.40","DiscountPercentage": "","DiscountAmount": "","CustomerName": "USA Truck Inc","BC": "598"}],"DiscountPercent": "","DiscountAmount": "","Customer": {"Destination_Addesss": {"State": "IN","Postal_Code": "47201","Country": "United States","City": "Indiana","AddressLine2": "Ashbrook Dr","AddressLine1": "3701"},"Customer_Code": "409280","Administrive_Destination": {"Postal_Code": "47201","Country": "United States","City": "Indiana","Administrative_Main_Division": "IN","AddressLine2": "Ashbrook Dr","AddressLine1": "3701"}}}}';
            string jsonStr= JSON.serialize(requestObj);
            correctedJsonStr = jsonStr.replace('Transaction_z','Transaction');//INC2628005
             System.debug('dbu_VertexQuoteRequestWrapper jsonStr: '+correctedJsonStr);
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type','application/json');
            System.debug('accessToken::::::::::::::'+accessToken+'\tRESOURCE_URL\t'+RESOURCE_URL+'\tMETHOD_TYPE\t'+METHOD_TYPE);
            req.setHeader('Authorization', accessToken);
            /*Shriram on 27thJan2021*/
            req.setHeader('client_id',CONSUMER_KEY);
            req.setHeader('client_secret',CONSUMER_SECRET);
            /*Ended by Shriram on 27thJan2021*/
            req.setEndpoint(RESOURCE_URL);
            req.setMethod(METHOD_TYPE);
            //req.setBody(JSON.serialize(requestObj));
            req.setBody(correctedJsonStr);
            req.setTimeout(Timeout);
            Http http = new Http();
            Long reqTime = DateTime.now().getTime();
            HttpResponse res = http.send(req);
            Long respTime = DateTime.now().getTime();
            System.debug('res.getbody()=>'+ res.getbody());
            String serverResponse = res.getbody();
            correctedResponse = serverResponse.replace('Transaction','Transaction_Z');//INC2628005
            System.debug('correctedResponse=>'+ correctedResponse); 
            long milliSeconds = respTime-reqTime ;
            mSec='***TIME::' +string.ValueOf(milliSeconds)+ ':: TIME***';          
        if (res.getStatusCode() == 200) {
                responseObj = (dbu_VertexquoteResponseWrapper)JSON.deserialize(correctedResponse, dbu_VertexquoteResponseWrapper.class);
                System.debug(res.getBody());
                system.debug('responseObj=> ' + JSON.serialize(responseObj));
                                /////////////////////////////////////////////////////////////
                //else
                //{
                    objReturn.DataArea = new dbu_Vertex_GeneralizedoutputWrapper.DataArea();
                    objReturn.DataArea.ProductList = new List<dbu_Vertex_GeneralizedoutputWrapper.ProductList>();
                    //objReturn.DataArea.ProductList.Taxes = new List<OSM_VERTEX_WS_GeneralizedoutputWrapper.Taxes>();
                    objReturn.Header = new dbu_Vertex_GeneralizedoutputWrapper.Header();
                    objReturn.Header.Transaction_Z = new dbu_Vertex_GeneralizedoutputWrapper.Transaction_Z();
                    
                    objReturn.DataArea.TotalTax = Double.ValueOf(responseObj.DataArea.TotalTax);
                    objReturn.Header.Transaction_Z.TransactionID = responseObj.Header.Transaction_Z.TransactionID;
                    
                    for(dbu_VertexquoteResponseWrapper.ProductList  objProductList: responseObj.DataArea.ProductList)
                    {
                        dbu_Vertex_GeneralizedoutputWrapper.ProductList newObj = new dbu_Vertex_GeneralizedoutputWrapper.ProductList();
                        newObj.LineItemTotalTax =Double.valueOf(objProductList.LineItemTotalTax);
                        newObj.ProductClassCode = objProductList.ProductClassCode;
                        newObj.LineItemNumber = Integer.ValueOf(objProductList.LineItemNumber);
                        newObj.ProductCode = objProductList.ProductCode;
                        /* New logic for Tax at cart Item level*/
                        newObj.Taxes=new List<dbu_Vertex_GeneralizedoutputWrapper.Taxes>();
                       System.debug('??????objProductList.Taxes===========\t'+objProductList.Taxes);
                       if(objProductList.Taxes!=null){
                        for(dbu_VertexquoteResponseWrapper.Taxes tax:objProductList.Taxes){
                         dbu_Vertex_GeneralizedoutputWrapper.Taxes taxObj=new dbu_Vertex_GeneralizedoutputWrapper.Taxes();
                             System.debug('TAX______'+tax);
                             taxObj.taxResult=tax.taxResult;
                             taxObj.taxType=tax.taxType;
                             //taxObj.reasonCode=tax.reasonCode;
                             //taxObj.isService=tax.isService;
                             taxObj.situs=tax.situs;
                             taxObj.taxCollectedFromParty=tax.taxCollectedFromParty;
                             taxObj.taxStructure=tax.taxStructure;
                             taxObj.jurisdictionLevel=tax.jurisdictionLevel;
                             taxObj.jurisdictionId=tax.jurisdictionId;
                             taxObj.JurisdictionValue=tax.JurisdictionValue;
                             taxObj.CalculatedTax =tax.CalculatedTax;
                             taxObj.EffectiveRate =tax.EffectiveRate ;
                             taxObj.Taxable =tax.Taxable ;
                             taxObj.NonTaxable =tax.NonTaxable ;
                             taxObj.impositionId =tax.impositionId ;
                             taxObj.impositionValue=tax.impositionValue ;
                             taxObj.impositionTypeId =tax.impositionTypeId ;
                             taxObj.ImpositionTypevalue =tax.ImpositionTypevalue ;
                             taxObj.TaxRuleId=tax.TaxRuleId ;
                             newObj.Taxes.add(taxObj);
                         }
                                             
                        System.debug('objReturn.DataArea.ProductList____'+objReturn.DataArea.ProductList);
                    }  
                        /** Ended here 15th April */
                        System.debug('response newObj=>'+ JSON.serialize(newObj));
                    objReturn.DataArea.ProductList.add(newObj);
                    objReturn.errorFlag = false;
                }
               createErrorLog(res.getStatusCode(),mSec,correctedJsonStr,res.getBody(),'Vertex Service','Success');
                return objReturn;
        // START CWiebe CHG0113065
        } else if (res.getStatusCode() == 503) {
            objReturn.DataArea = new dbu_Vertex_GeneralizedoutputWrapper.DataArea();
            objReturn.DataArea.ProductList = new List<dbu_Vertex_GeneralizedoutputWrapper.ProductList>();
            objReturn.Header = new dbu_Vertex_GeneralizedoutputWrapper.Header();
            objReturn.Header.Transaction_Z = new dbu_Vertex_GeneralizedoutputWrapper.Transaction_Z();
            
            objReturn.DataArea.TotalTax = Double.ValueOf('0.00');

            // objReturn.Header.Transaction_Z.TransactionID = responseObj.Header.Transaction_Z.TransactionID;
            
            for(dbu_VertexquoteRequestWrapper.ProductList  objProductList: requestObj.DataArea.ProductList)
            {
                dbu_Vertex_GeneralizedoutputWrapper.ProductList newObj = new dbu_Vertex_GeneralizedoutputWrapper.ProductList();
                // newObj.LineItemTotalTax =Double.valueOf(objProductList.LineItemTotalTax);
                newObj.ProductClassCode = objProductList.ProductClassCode;
                newObj.LineItemNumber = Integer.ValueOf(objProductList.LineItemNumber);
                newObj.ProductCode = objProductList.ProductCode;
                /* New logic for Tax at cart Item level*/
                newObj.Taxes=new List<dbu_Vertex_GeneralizedoutputWrapper.Taxes>();
                // System.debug('??????objProductList.Taxes===========\t'+objProductList.Taxes);
                /*
                if(objProductList.Taxes!=null){
                    for(dbu_VertexquoteResponseWrapper.Taxes tax:objProductList.Taxes){
                        dbu_Vertex_GeneralizedoutputWrapper.Taxes taxObj=new dbu_Vertex_GeneralizedoutputWrapper.Taxes();
                        System.debug('TAX______'+tax);
                        taxObj.taxResult=tax.taxResult;
                        taxObj.taxType=tax.taxType;
                        //taxObj.reasonCode=tax.reasonCode;
                        //taxObj.isService=tax.isService;
                        taxObj.situs=tax.situs;
                        taxObj.taxCollectedFromParty=tax.taxCollectedFromParty;
                        taxObj.taxStructure=tax.taxStructure;
                        taxObj.jurisdictionLevel=tax.jurisdictionLevel;
                        taxObj.jurisdictionId=tax.jurisdictionId;
                        taxObj.JurisdictionValue=tax.JurisdictionValue;
                        taxObj.CalculatedTax =tax.CalculatedTax;
                        taxObj.EffectiveRate =tax.EffectiveRate ;
                        taxObj.Taxable =tax.Taxable ;
                        taxObj.NonTaxable =tax.NonTaxable ;
                        taxObj.impositionId =tax.impositionId ;
                        taxObj.impositionValue=tax.impositionValue ;
                        taxObj.impositionTypeId =tax.impositionTypeId ;
                        taxObj.ImpositionTypevalue =tax.ImpositionTypevalue ;
                        taxObj.TaxRuleId=tax.TaxRuleId ;
                        newObj.Taxes.add(taxObj);
                    }                   
                    System.debug('objReturn.DataArea.ProductList____'+objReturn.DataArea.ProductList);
                } 
                */
                /** Ended here 15th April */
                System.debug('request newObj=>'+ JSON.serialize(newObj));
                objReturn.DataArea.ProductList.add(newObj);
            }
            objReturn.errorFlag = false;
            objReturn.Status = 'Unavailable';
            createErrorLog(res.getStatusCode(),mSec,correctedJsonStr,res.getBody(),'Vertex Service','Unavailable');
            return objReturn;
        // END CWiebe CHG0113065
        } else {
            system.debug('requet data else ' + responseObj);
            System.debug('response with error ' + res.getBody());
            createErrorLog(res.getStatusCode(),mSec,correctedJsonStr,res.getBody(),'Vertex Service',res.getStatus());
            objReturn.Status = 'Error';//INC2628005
            return objReturn;
        }                        
        }catch(Exception ce){
           createErrorLog(null,mSec+ce.getMessage()+' '+ce.getLineNumber(),correctedJsonStr,correctedResponse,'Vertex Service','Error');//INC2628005
            objReturn.Status = 'Error';//INC2628005
            return objReturn;          
        }                       
    }
    
    @future
    public static void createErrorLog(Integer ErrorCode,String ErrorDescription,String Request, String Response,String ServiceName,String Status){
        
        dbu_Integration_Error_Log.createErrorLog(ErrorCode,ErrorDescription,Request,Response,ServiceName,Status);
    }
    @AuraEnabled
    public static dbu_Vertex_GeneralizedoutputWrapper getTaxInvoice(dbu_Vertex_GeneralizedInputWrapper objVertexGeneralWrapper){
        // try{
        //     System.debug('objVertexGeneralWrapper:=> '+JSON.serialize(objVertexGeneralWrapper));
        //  //String accessToken = getAccessToken(); TEMPORARITY COMMENTED
        //  //dbu_VertexQuoteRequestWrapper requestObj = new dbu_VertexQuoteRequestWrapper();
        //  dbu_VertexquoteResponseWrapper responseObj = new dbu_VertexquoteResponseWrapper();
        //     dbu_Vertex_GeneralizedoutputWrapper objReturn = new dbu_Vertex_GeneralizedoutputWrapper();
        //  //dbu_Integrationdetails__c conDetails = dbu_Integrationdetails__c.getValues('VertexQuote');
        //  CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('VertexQuote');
        //     METHOD_TYPE = conDetails.Method_Type__c;
        //     //RESOURCE_URL = conDetails.Resource__c; TEMPORARITY COMMENTED
        //     RESOURCE_URL = TAX_INVOICE_END_POINT;
        //     dbu_VertexQuoteRequestWrapper requestObj = Dbu_Vertex_Service_Helper.populateDynamicData(objVertexGeneralWrapper);
        //     //string reqjson='{"Header": {"Transaction": {"Trusted_ID": "","TransactionID": "","Transaction_Type": "SALE","QuotationRequestDocumentNumber": "00000313","DocumentDate": "2018-07-13"},"Target": {"TargetID": "Vertex"},"Sender": {"ServiceName": "QuotationRequest","SenderID": "OSM"}},"DataArea": {"Seller": {"Physical_Origin": {"State": "IN","Postal_Code": "47201-6258","Country": "USA","City": "Columbus","AddressLine2": "","AddressLine1": "500 Jackson St"},"Division_Code": "CMI","Company_Code": "00","AdministrativeOrigin": {"State": "IN","Postal_Code": "47201-6258","Country": "USA","City": "Columbus","AddressLine2": "","AddressLine1": "500 Jackson St"}},"ProductList": [{"UnitOfMeasure": "","RC": "207","Quantity": "4","ProductCode": "5678901-OHT","ProductClassCode": "SW-Web Access","LineItemNumber": "00001140","ExtendedPrice": "470.40","DiscountPercentage": "","DiscountAmount": "","CustomerName": "USA Truck Inc","BC": "598"}],"DiscountPercent": "","DiscountAmount": "","Customer": {"Destination_Addesss": {"State": "IN","Postal_Code": "47201","Country": "United States","City": "Indiana","AddressLine2": "Ashbrook Dr","AddressLine1": "3701"},"Customer_Code": "409280","Administrive_Destination": {"Postal_Code": "47201","Country": "United States","City": "Indiana","Administrative_Main_Division": "IN","AddressLine2": "Ashbrook Dr","AddressLine1": "3701"}}}}';
        //     string jsonStr= JSON.serialize(requestObj);
        //     string correctedJsonStr = jsonStr.replace('Transaction_z','Transaction');
           
        //     System.debug('jsonStr: '+correctedJsonStr);
        //     HttpRequest req = new HttpRequest();
        //  req.setHeader('Content-Type','application/json');
        //     req.setHeader('client_id','1ebed545196240749e6a847585ca16f0');
        //     req.setHeader('client_secret','5ED106EC31b144c4B98a897412ee22dA');
        //  //NEXT LINE IS TEMPORARY
        //  String accessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6ImppYk5ia0ZTU2JteFBZck45Q0ZxUms0SzRndyIsImtpZCI6ImppYk5ia0ZTU2JteFBZck45Q0ZxUms0SzRndyJ9.eyJhdWQiOiJodHRwczovL2FwaS11ZS1kZXZuZi1hdy1leC5jdW1taW5zLmNvbS9tYXJrZXRwbGFjZS9pbnZvaWNlcyIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2IzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZC8iLCJpYXQiOjE1OTc5MDg2NzUsIm5iZiI6MTU5NzkwODY3NSwiZXhwIjoxNTk3OTEyNTc1LCJhaW8iOiJFMkJnWUdqYjVQWTFJMjcrOUFON3JpbitmaUQ3RHdBPSIsImFwcGlkIjoiMWE1YjAwNTctOGJiYy00Nzg0LTk1MDEtMmYwYWM5OTE5NTAzIiwiYXBwaWRhY3IiOiIxIiwiaWRwIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvYjMxYTVkODYtNmRkYS00NDU3LTg1ZTUtYzU1YmJjMDc5MjNkLyIsIm9pZCI6ImVlNzQwZmM2LWVjNTEtNDhkYy1hNzlhLTU3YzQ1ZTMyMWJlMiIsInN1YiI6ImVlNzQwZmM2LWVjNTEtNDhkYy1hNzlhLTU3YzQ1ZTMyMWJlMiIsInRpZCI6ImIzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZCIsInV0aSI6InhpYmIyMElZUWtpQnFYSTlLRmhWQUEiLCJ2ZXIiOiIxLjAifQ.wKtStK29L9_u_Uf5uFyS_hKb24UFJTsJlBMumPN-OYVYPHljXC3SxRvD8IMe4U1T0XAIoegayhpLsLpQcqn1YLo5sL12FuUS46q-ngMb7jIC9axWeIDmXlD9w5vLOz5dRHWmIZHzaiAXldUszFMgz2crJZM20-ZSocnDWQ6bHmTf936ShypkFrbrowW3oX0XHcTHfD5n35VZlIi0TOWwRBZiPCCIvaFWOSlF4KIbZsZZjUUVE5YvHLZJeEcMYMXw0raTPNjsLO1rhZ54a0igqjrdhfzyXhNprIYTuEVTfKOWyQd45RIvLtozEAYJZPPHPSMT0CRGiVEdWMsFeOFH2g';
        //     req.setHeader('Authorization','Bearer '+ accessToken);
        //     req.setEndpoint(RESOURCE_URL);
        //     req.setMethod(METHOD_TYPE);
        //     //req.setBody(JSON.serialize(requestObj));
        //     req.setBody(correctedJsonStr);
        //     req.setTimeout(120000);
        //    System.debug('jsonStr=>'+ correctedJsonStr);
        //     Http http = new Http();
        //     HttpResponse res = http.send(req);
        //  System.debug('res.getbody()=>'+ res.getbody());
        //     String serverResponse = res.getbody();
        //  string correctedResponse = serverResponse.replace('Transaction','Transaction_Z');
        //     System.debug('correctedResponse=>'+ correctedResponse);           
        // if (res.getStatusCode() == 200) {
        //         responseObj = (dbu_VertexquoteResponseWrapper)JSON.deserialize(correctedResponse, dbu_VertexquoteResponseWrapper.class);
        //      System.debug(res.getBody());
        //         system.debug('responseObj=> ' + JSON.serialize(responseObj));
        //                      /////////////////////////////////////////////////////////////
        //      //else
        //         //{
        //             objReturn.DataArea = new dbu_Vertex_GeneralizedoutputWrapper.DataArea();
        //             objReturn.DataArea.ProductList = new List<dbu_Vertex_GeneralizedoutputWrapper.ProductList>();
        //             //objReturn.DataArea.ProductList.Taxes = new List<OSM_VERTEX_WS_GeneralizedoutputWrapper.Taxes>();
        //             objReturn.Header = new dbu_Vertex_GeneralizedoutputWrapper.Header();
        //             objReturn.Header.Transaction_Z = new dbu_Vertex_GeneralizedoutputWrapper.Transaction_Z();
                    
        //             objReturn.DataArea.TotalTax = Double.ValueOf(responseObj.DataArea.TotalTax);
        //             objReturn.Header.Transaction_Z.TransactionID = responseObj.Header.Transaction_Z.TransactionID;
                    
            
        //             for(dbu_VertexquoteResponseWrapper.ProductList  objProductList: responseObj.DataArea.ProductList)
        //             {
        //                 dbu_Vertex_GeneralizedoutputWrapper.ProductList newObj = new dbu_Vertex_GeneralizedoutputWrapper.ProductList();
        //                 //newObj.Product = objProductList.Product;
        //                 newObj.LineItemTotalTax =Double.valueOf(objProductList.LineItemTotalTax);
        //                 newObj.ProductClassCode = objProductList.ProductClassCode;
        //                 newObj.LineItemNumber = Integer.ValueOf(objProductList.LineItemNumber);
        //                 newObj.ProductCode = objProductList.ProductCode;
                         /*newObj.Taxes=new List<dbu_Vertex_GeneralizedoutputWrapper.Taxes>();
                       if(objProductList.Taxes!=null){
                        for(dbu_VertexquoteResponseWrapper.Taxes tax:objProductList.Taxes){
                         dbu_Vertex_GeneralizedoutputWrapper.Taxes taxObj=new dbu_Vertex_GeneralizedoutputWrapper.Taxes();
                             System.debug('TAX______'+tax);
                             taxObj.taxResult=tax.taxResult;
                             taxObj.taxType=tax.taxType;
                             //taxObj.reasonCode=tax.reasonCode;
                             //taxObj.isService=tax.isService;
                             taxObj.situs=tax.situs;
                             taxObj.taxCollectedFromParty=tax.taxCollectedFromParty;
                             taxObj.taxStructure=tax.taxStructure;
                             taxObj.jurisdictionLevel=tax.jurisdictionLevel;
                             taxObj.jurisdictionId=tax.jurisdictionId;
                             taxObj.JurisdictionValue=tax.JurisdictionValue;
                             taxObj.CalculatedTax =tax.CalculatedTax;
                             taxObj.EffectiveRate =tax.EffectiveRate ;
                             taxObj.Taxable =tax.Taxable ;
                             taxObj.NonTaxable =tax.NonTaxable ;
                             taxObj.impositionId =tax.impositionId ;
                             taxObj.impositionValue=tax.impositionValue ;
                             taxObj.impositionTypeId =tax.impositionTypeId ;
                             taxObj.ImpositionTypevalue =tax.ImpositionTypevalue ;
                             taxObj.TaxRuleId=tax.TaxRuleId ;
                             newObj.Taxes.add(taxObj);
                         }
                                             
                        System.debug('objReturn.DataArea.ProductList____'+objReturn.DataArea.ProductList);
                    } */  
        //                 System.debug('response newObj=>'+ JSON.serialize(newObj));
        //             dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),res.getBody(),JSON.serialize(objVertexGeneralWrapper),JSON.serialize(responseObj),'Vertex Service',res.getStatus());
        //             objReturn.DataArea.ProductList.add(newObj);
        //             objReturn.errorFlag = false;
        //         }
        //     //}
        //      //////////////////////////////////////////////////////////////////
        //         return objReturn;
        //         //return res;
        // } else {
        //     system.debug('requet data else ' + responseObj);
        //     System.debug('response with error ' + res.getBody());
        //     dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),res.getBody(),JSON.serialize(objVertexGeneralWrapper),JSON.serialize(responseObj),'Vertex Service',res.getStatus());
        //     return objReturn;
        //     //return res;
        // }                        
        // }catch(CallOutException ce){
        //     dbu_Integration_Error_Log.createErrorLog(null,ce.getMessage(),JSON.serialize(objVertexGeneralWrapper),'','Vertex Service','Exception');
        //     throw ce;           
        // }      
        return null;                 
    }
    
    public class dbuVertexInvoiceRequestWrapper{
        public Header Header {get;set;} 
        public DataArea DataArea {get;set;} 
    }
    
    public class Sender {
        public String ServiceName {get;set;} 
        public String SenderID {get;set;} 
    }
    public class Physical_Origin {
        public String State {get;set;} 
        public String Postal_Code {get;set;} 
        public String Country {get;set;} 
        public String City {get;set;} 
        public String AddressLine2 {get;set;} 
        public String AddressLine1 {get;set;} 
    }
    public class ProductList {
        public String UnitOfMeasure {get;set;} 
        public String RC {get;set;} 
        public String Quantity {get;set;} 
        public String ProductCode {get;set;} 
        public String ProductClassCode {get;set;} 
        public String LineItemNumber {get;set;} 
        public String ExtendedPrice {get;set;} 
        public String DiscountPercentage {get;set;} 
        public String DiscountAmount {get;set;} 
        public String CustomerName {get;set;} 
        public String BC {get;set;} 
    }
    public class Target {
        public String TargetID {get;set;} 
    
    }
    public class DataArea {
        public Seller Seller {get;set;} 
        public List<ProductList> ProductList {get;set;} 
        public String DiscountPercent {get;set;} 
        public String DiscountAmount {get;set;} 
        public Customer Customer {get;set;} 
    }
    public class Header {
        public Transaction_Z Transaction_Z {get;set;} // in json: Transaction
        public Target Target {get;set;} 
        public Sender Sender {get;set;} 
    }   
    public class Customer {
        public Destination_Addesss Destination_Addesss {get;set;} 
        public String Customer_Code {get;set;} 
        public Administrive_Destination Administrive_Destination {get;set;} 
    }   
        
    public class Seller {
        public Physical_Origin Physical_Origin {get;set;} 
        public String Division_Code {get;set;} 
        public String Company_Code {get;set;} 
        public AdministrativeOrigin AdministrativeOrigin {get;set;} 
    }   
    public class Administrive_Destination {
        public String Postal_Code {get;set;} 
        public String Country {get;set;} 
        public String City {get;set;} 
        public String Administrative_Main_Division {get;set;} 
        public String AddressLine2 {get;set;} 
        public String AddressLine1 {get;set;} 
    }   
    public class Transaction_Z {
        public String Trusted_ID {get;set;} 
        public String TransactionID {get;set;} 
        public String Transaction_Type {get;set;} 
        public String InvoiceRequestDocumentNumber {get;set;} 
        public String DocumentDate {get;set;} 
    }       
    public  class AdministrativeOrigin{
         public String State;
         public String Postal_Code;
         public String Country;
         public String City;
         public String AddressLine2;
         public String AddressLine1;
    }
    public class Destination_Addesss{
        public String State;
        public String Postal_Code;
        public String Country;
        public String City;
        public String AddressLine2;
        public String AddressLine1;
    }
}