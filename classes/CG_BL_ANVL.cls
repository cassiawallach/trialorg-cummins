/**********************************************************************
Name:CG_BL_ANVL
Copyright © 2011  Cummins
======================================================================
======================================================================
Purpose:                                                            
This class is used to perform buisiness logic for ANVL integration i.e
query required fields for the service and save the response.
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                 
1.0 - Bharath Reddy   	10/10/2018     	INITIAL POC                        
2.0 - Anirudh Reddy    11/28/2018       Initial Development
***********************************************************************/
public class CG_BL_ANVL {
    
    
    
    @future (callout=true)
    public static void ANVL_RequestResponse (Id cssJOId) {
        
        try{
            //Query Service Job to get the assigned technicians
            CSS_Job_Order__c cssJO = new CSS_Job_Order__c();
            cssJO = [SELECT Id, Name, Shop_Work_Order__c,Account__r.CG_ANVL_Enabled__c,Assigned_to__r.FederationIdentifier,
                     Category_Desc__c,Complaint_Type_Desc__c, ESN__c,Service_Model__c,Account__r.IAM_Service_Provider_Code__c,ApplicationCode__c, 
                     Application_Desc__c, Repair_Location__c,Customer_Name__c,Customer_Code__c, Assigned_to__c, Additional_Tech1__c,
                     Additional_Tech1__r.FederationIdentifier, Additional_Tech2__c,Additional_Tech2__r.FederationIdentifier, 
                     Additional_Tech3__c,Additional_Tech3__r.FederationIdentifier, Additional_Tech4__c,Additional_Tech4__r.FederationIdentifier,
                     Additional_Tech5__c,Additional_Tech5__r.FederationIdentifier, Additional_Tech6__c,Additional_Tech6__r.FederationIdentifier, 
                     Additional_Tech7__c,Additional_Tech7__r.FederationIdentifier, Additional_Tech8__c,Additional_Tech8__r.FederationIdentifier, 
                     Additional_Tech9__c,Additional_Tech9__r.FederationIdentifier, CreatedDate,Account__r.Name,LastModifiedDate 
                     FROM CSS_Job_Order__c WHERE Id=:cssJOId LIMIT 1];
            system.debug('Anirudh cssJO'+cssJO);
            if(cssJO.Account__r.CG_ANVL_Enabled__c){
                //Call service Layer to make Webservice Call
                CG_OP_OAGWrapper ANVLCallOut;
                ANVLCallOut = CG_SL_ANVL.ANVLWebservice(cssJO);
                system.debug('ANVLCallOut**'+ANVLCallOut);
                saveANVLResponse(ANVLCallOut,cssJO.Name);
            }    
        }
        catch(exception e) {
            system.debug('Entered into catch block of ANVL_RequestResponse method in CG_BL_ANVL class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }
    }
    
    public static void saveANVLResponse(CG_OP_OAGWrapper ANVLCallOut,String JobId){
        try{
        CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('CG_ANVLService');
        if(conDetails.Logging__c != null && conDetails.Logging__c != '' && conDetails.Logging__c == 'BOTH'){
            insertIntegrationDetails(ANVLCallOut,JobId);
        }else if(conDetails.Logging__c != null && conDetails.Logging__c != '' && conDetails.Logging__c == 'ERROR'){
            if(ANVLCallOut.exceptionFlag == true){
                insertIntegrationDetails(ANVLCallOut,JobId);
            }
        }else{
            //Dont Insert any data.
        } 
        }catch(exception e){
            system.debug('Entered into catch block of saveANVLResponse method in CG_BL_ANVL class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }
    }
    
    public static void insertIntegrationDetails(CG_OP_OAGWrapper ANVLCallOut,String JobId){
        try{
        CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();
        
        intDetails.Auth_Call_Time__c = (ANVLCallOut.totalAuthCallTime != null ? ANVLCallOut.totalAuthCallTime : 0);
        intDetails.Error_Description__c = (ANVLCallOut.exceptionMessage != null && ANVLCallOut.exceptionMessage != ''  ? ANVLCallOut.exceptionMessage : '');
        intDetails.Processed_Data__c =  (ANVLCallOut != null && ANVLCallOut.request != null ? ANVLCallOut.request.getBody() : '');
        intDetails.Response_Body__c = (ANVLCallOut != null &&  ANVLCallOut.response != null ? ANVLCallOut.response.getBody() : '');
        intDetails.Service_Call_Time__c = (ANVLCallOut.totalServiceCallTime != null ? ANVLCallOut.totalServiceCallTime : 0);
        intDetails.Service_Job_Number__c = JobId;
        intDetails.Service_Name__c = 'ANVLService';
        intDetails.Source__c = 'ANVL';
        insert intDetails;
        }catch(exception e){
            system.debug('Entered into catch block of insertIntegrationDetails method in CG_BL_ANVL class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }
    }
    
}