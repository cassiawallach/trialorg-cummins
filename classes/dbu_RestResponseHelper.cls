public with sharing class dbu_RestResponseHelper {
    public static void SetRestResponse(Integer statusCode, String httpCode, String errorMessage)
    {
         
        try {
            System.System.debug('statusCode=>'+ statusCode);
            System.System.debug('httpCode=>'+ httpCode);
            System.System.debug('errorMessage=>'+ errorMessage);
            
            RestResponse res = RestContext.response;
            res.statusCode = statusCode;
            dbu_SalesforceRestResponse[] errs = new dbu_SalesforceRestResponse[]{ 
                new dbu_SalesforceRestResponse(httpCode, errorMessage)
            };
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(JSON.serialize(errs));
            //res.responseBody = JSON.serialize(errs);
            
        } catch (Exception e) {
            System.System.debug('Error while setting up rest response:'+e.getMessage());
           // dbu_Integration_Error_Log.createErrorLog(null,e.getMessage(),errorMessage,'','Inventory Service','Exception');
            
        }
        
    }
}