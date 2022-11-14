/**********************************************************************
Name:FSLCumminsServiceUtility
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the Unit Lookup on the work order.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSLCumminsServiceUtility 
{
    //commented as this method no longer use after mule change by vinod 9/9
    /*public static HttpRequest createHttpRequest(String endPoint, String authType, String token, String method, List<String> contentHdrs, String reqBody, Integer timeout)
    {
        HttpRequest httpReq = new HttpRequest();
        httpReq.setHeader('Authorization', token);
        if(method.equalsIgnoreCase('POST'))
            httpReq.setBody(reqBody);
        httpReq.setMethod(method);
        httpReq.setEndpoint(endPoint);        
        httpReq.setHeader(contentHdrs[0],contentHdrs[1]);
        httpReq.setTimeout(timeout);
        return httpReq;
    }*/
     public static CG_IP_OAGWrapper createHttpRequest(String serviceName, String endPoint, String method, String reqBody, Integer timeout)
    {
        HttpRequest httpReq = new HttpRequest();        
        /* httpReq.setMethod('GET');
        FSLCumminsServiceUtility fslGetTkn=new FSLCumminsServiceUtility();
        String authorizationHeader;
        if(authType == 'BEARER')
        authorizationHeader = 'Bearer '+fslGetTkn.getAccessibilityCheckListToken();
		*/
        /*httpReq.setHeader('Authorization', token);
        httpReq.setBody(reqBody);
        httpReq.setMethod(method);
        httpReq.setEndpoint(endPoint);        
        httpReq.setHeader(contentHdrs[0],contentHdrs[1]);
        httpReq.setTimeout(timeout);*/
        CG_IP_OAGWrapper reqWrapper;
        reqWrapper = new CG_IP_OAGWrapper();
        reqWrapper.jsonReqBody = reqBody;
        reqWrapper.serviceName = serviceName;
        reqWrapper.methodType = method;
        reqWrapper.endPoint = endPoint;
        return reqWrapper;
    }
    /*public static HttpResponse sendHttpRequest(HttpRequest httpReq)
    {
        Http h = new Http();
        return h.send(httpReq);
    }*/
}