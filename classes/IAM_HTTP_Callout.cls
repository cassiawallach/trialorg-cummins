/*************************************************************************************
Name:  IAM_HTTP_Callout
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Utility Class to store HTTP callout methods
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Shubhangi Sardar          01/05/2021        INITIAL DEVELOPMENT
**************************************************************************************
**************************************************************************************/

public class IAM_HTTP_Callout {

    /* Send HTTP request without timeout and return response */
    public static HttpResponse sendHTTPRequest(String method, String endpoint,
    Map<String, String> headerMap, String body) {
        return sendRequest(method, endpoint, headerMap, body, null);
    }

    /* Send HTTP request with timeout and return response */
    public static HttpResponse sendHTTPRequest(String method, String endpoint,
    Map<String, String> headerMap, String body, Integer timeout) {
        return sendRequest(method, endpoint, headerMap, body, timeout);
    }

    /* Return HTTP Request */
    public static HttpResponse sendRequest(String method, String endpoint,
    Map<String, String> headerMap, String body, Integer timeout) {
        
        printRequest(method, endpoint, headerMap, body, timeout);
        /* Prepare Request and Return */
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndpoint(endpoint);

        if(headerMap != null) {
            for(String key : headerMap.keySet()) {
                request.setHeader(key, headerMap.get(key));
            }
        }
        if(body != null) {
            request.setBody(body);
        }
        if(timeout != null) {
            request.setTimeout(timeout);
        }

        Http hObj = new Http();
        HttpResponse response = hObj.send(request);
        printResponse(response);
        return response;
    }

    /* Print HTTP Request Parameters */
    public static void printRequest(String method, String endpoint,
    Map<String, String> headerMap, String body, Integer timeout) {
        System.debug('#### REQUEST METHOD - ' + method);
        System.debug('#### REQUEST ENDPOINT - ' + endpoint); 
        System.debug('#### REQUEST HEADER MAP - '+ headerMap);
        System.debug('#### REQUEST TIMEOUT - ' + timeout);
        System.debug('#### REQUEST BODY - ' +  body);
    }

    /* Print HTTP Response Parameters */
    public static void printResponse(HttpResponse response) {
        System.debug('#### RESPONSE - ' + response);
        if(response != null) {
            System.debug('#### RESPONSE STATUS - ' + response.getStatus());
            System.debug('#### RESPONSE STATUS CODE - ' + response.getStatusCode());
            System.debug('#### RESPONSE BODY - ' + response.getBody());
        }
    }
}