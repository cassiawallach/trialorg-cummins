public with sharing class dbu_SalesforceRestResponse {
    public String errorCode;
    public String message;
    public dbu_SalesforceRestResponse(String errorCode, string message){
        this.errorCode = errorCode;
        this.message = message;
    }
}