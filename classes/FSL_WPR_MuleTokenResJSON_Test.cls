/*
* Test Class for Apex Controller - FSL_WPR_MuleTokenResJSON
* Author - Piyush Rani
*/ 
@isTest
public class FSL_WPR_MuleTokenResJSON_Test {
    @isTest
    private static void testResponseJSON() {
        string sh='{ "token_type": "Bearer", "expires_in": "3600", "ext_expires_in": "3600", "expires_on": "1561467793", "not_before": "1561463893", "resource": "https://api-ue-devnf-aw-ex.cummins.com/cmi-sp", "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1" }';
        FSL_WPR_MuleTokenResJSON obj = FSL_WPR_MuleTokenResJSON.parse(sh);
        system.assert(obj!=null);
    }
}