/************************************************************
Name:  CS_Header
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Controller class for CS_Header visual force component.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION   AUTHOR                   DATE              DETAIL                                
1.0 -   Keerthy Gurumurthy      23/04/2018        INITIAL DEVELOPMENT  
1.1 -   Nishant Verma           23/04/2019     Added code for fetching Image from 
                                               Attachments in the child object
1.2 -   Karthik Golakaram       10/23/2020    Added Variables for display purpose
                                              depending upon application name
1.3 -   KArthik Golakaram       11/3/2020     Made Changes to dispaly language drop down
                                              Added Pasrameter  
*****************************************************/
/********************************************************************************
***********************************************************************************/

global without sharing class CS_header {
    global String currentRecordId {get; set;}
    global App_Mapping__c app{get; set;}
    global Map<String,String>params{get;set;}
    global string imgId{get; set;}
    global string selectedLanguage{get; set;}
    global string appname{get;set;}
    global string logouturl{get; set;}
    global Boolean isMyFleetGuardCustomerPortal{get;set;}
    global Boolean isFleetGuardFit{get;set;}
    global Boolean toDisplayAppName{get;set;}
    global Boolean isregularSupport{get;set;}
    global Boolean isChangePasswordPage{get;set;}
    
    global CS_header () {
        params=ApexPages.CurrentPage().getparameters();
        System.debug('Printing all parameters'+params);
        app=IAM_Login_Utillity.getAppMapping(params);
        appname = app.Name;
        logouturl=app.IAM_Logout_URL__c;
        toDisplayAppName=true;
        isregularSupport=true;
        isChangePasswordPage=IAM_ChangePasswordController.checkPageName();
        System.debug('Printing application name from app mapping'+appname);
        
        // Change for dynamic logo on login page 
        //string currentRecordId =ApexPages.currentPage().getParameters().get('appid');

        String appID =app.id;
        if(app.Name==Label.IAM_AppName_FleetguardFit){
            isFleetguardFit=True;
            isMyFleetGuardCustomerPortal=false;
            toDisplayAppName=false;
            isregularSupport=false;
        }else if(app.Name==label.IAM_AppName_Fleetguard_Customer){
            isFleetguardFit=false;
            isMyFleetGuardCustomerPortal=true;
        }
        System.debug('Printing application name from app mapping'+appID);
        if(app!=null){
            //commented by Karthik for issue of Connected solutions
            List<Attachment> attachListObj = [select Id from Attachment where parentId =:appID];
            if(attachListObj != null && attachListObj.size()>0){
                imgId= attachListObj[0].id;
            }
        }
    } 
}