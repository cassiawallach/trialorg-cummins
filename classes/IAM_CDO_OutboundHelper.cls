/************************************************************
Name:  IAM_CDO_OutboundHelper
Copyright © 2022  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Class for CDO out bound service                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Chetan Gaikwad	         25/05/2022         INITIAL DEVELOPMENT
1.1 -    Chetan Gaikwad          05/08/2022         Update API changes
*****************************************************/
public class IAM_CDO_OutboundHelper {
    @future (callout=true)
    public static void CDOOutboundCall(Id appId, String action){  
        String IAMtoCDO=''; 
        try{  
            IAMtoCDO =IAM_CDO_OutBoundReqParser.IAM_CDO_ReqParserClass(appId,action);
            System.debug('Printing registration payload'+IAMtoCDO); 
            String accessToken = IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_CDO_MuleAuth');
            CSS_Integration_Details__c iamCDO = IAM_getConnnectionDetails.getConnection('IAM_CDO_Registration_Mule');
            Http http = new Http();
            HttpResponse response;
            HttpRequest request = new HttpRequest();
            request.setEndpoint(iamCDO.End_Point__c);
            request.setHeader('Content-Type','application/json');
            request.setHeader('sourceSystem', 'SFIAM');
            request.setHeader('targetSystem', 'CDO');
            request.setHeader('Authorization','Bearer '+accessToken);
            if(action == 'create'){
                request.setMethod(iamCDO.Method_Type__c); 
            }else{
                 request.setMethod('PUT');
            }
            request.setHeader('resource', iamCDO.Resource__c);
            request.setBody(IAMtoCDO);
            System.debug('Printng request'+request);
            System.debug('Printing request body'+request.getBody()); 
            
            response = http.send(request);
            // If the request is successful, parse the JSON response.
            System.debug('response status' +response.getStatus() + response.getBody() +response.getStatusCode());
            
            if(response.getStatusCode() == 200) {
                IAM_CDO_OutBoundReqParser.CDOResponse cdoResponseValue = IAM_CDO_OutBoundReqParser.getResponseuserrequest(response.getBody());
                system.debug('Hey, You succeded to desrialize response');
                system.debug('@CDO return code response - '+cdoResponseValue.ReturnCode);
                system.debug('@CDO MessageIdentifier response - '+cdoResponseValue.MessageIdentifier);
                system.debug('@CDO Message response - '+cdoResponseValue.Message);
                system.debug('@CDO Status response - '+cdoResponseValue.Status);
                
                if(cdoResponseValue.ReturnCode != '200' || cdoResponseValue.Status!='SUCCESS'){
                    String responseError = '@Error : '+ cdoResponseValue.Status +' '+ cdoResponseValue.MessageIdentifier +' '+ cdoResponseValue.Message+'.';
                    IAM_ErrorHandling.IAMerrorcapture(IAMtoCDO,'IDENTITY-CDO',responseError);
                }
                
            } else{
                string Status=string.valueof(response.getStatusCode());
                string responsebody = string.valueof(response.getBody());
                responsebody = responsebody + 'status recorded in response '+Status;
                IAM_ErrorHandling.IAMerrorcapture(IAMtoCDO,'IDENTITY-CDO',responsebody);
            }      
        } 
        catch(Exception ex){
            System.debug('Exception in CDO user update' + ex);
            System.debug('Printing Stack Trace String'+ex.getStackTraceString());
            String msg = ex.getMessage();
            msg = msg + '<br>Details: '+ ex.getStackTraceString();
            IAM_ErrorHandling.IAMerrorcapture(IAMtoCDO,'IDENTITY-CDO',msg);
        }
    }

    public static Set<Id> getConnectedSoltuionProvisionings(Set<Id> ConIDs){
        set<Id> conProIds = new set<Id>();
        List<IAM_Contact_Provisioning__c> conProList = [select id, IAM_Contact__c from IAM_Contact_Provisioning__c where IAM_Application_Name__c =:system.label.IAM_AppName_ConnectedSolutions and IAM_Status__c='Active' and IAM_Contact__c IN :ConIDs];
        for(IAM_Contact_Provisioning__c cp:conProList){
            conProIds.add(cp.Id);
        }
        Return conProIds;
    }
}