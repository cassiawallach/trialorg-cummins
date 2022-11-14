/*********************************************************************************
Author       :   Sushma Rajput
Created Date :   4th September,2019
Description  :   Unit test class for  LDAP_util.
*********************************************************************************/
@isTest
public class LDAP_util_Test {
   
    static testMethod void testParse() {
    String json = '{'+
    '   \"access_token\": \"ffYVjhpw7pEigWdjJWmZ9ACyNCySnQB3SbtPGk0H4vYkJ09Hwwzfrv\",'+
    '   \"token_type\": \"Bearer\",'+
    '   \"expires_in\": 1200,'+
    '   \"refresh_token\": \"ffYVjhpw7pEigWdjJWmZ9ACyNCySnQB3SbtPGk0H4vYkJ09Hwwzfrv\",'+
    '   \"scope\": \"CSSCloud\"'+
    '}';
    
    CSS_J2AToken_SRT utilObj = LDAP_util.parse(json);
    System.assert(utilObj != null);
  }
}