@istest
public class CG_WPR_MuleTokenResJSON_test {
    
    static testmethod void testmthod1(){
        string sh='{ "token_type": "Bearer", "expires_in": "3600", "ext_expires_in": "3600", "expires_on": "1561467793", "not_before": "1561463893", "resource": "https://api-ue-devnf-aw-ex.cummins.com/cmi-sp", "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1" }';
        CG_WPR_MuleTokenResJSON obj=CG_WPR_MuleTokenResJSON.parse(sh);
        system.assert(obj!=null);
    }

}