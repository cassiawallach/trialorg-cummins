/**********************************************************************
Name: FSLFailModeService
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This process is used to populate the custom failure names, system code, component code and Fail mode from
Siebel warranty system
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              Description                           
1.0     Ravikanth Macherla         5/03/2019     
2.0     karthik Gorantla           09/2/2020          Mule migration with Method POST to GET
3.0     Diksha Rajpurohit          05/31/2022         Migrate to Named Credentials
***********************************************************************/
public class FSLFailModeService {
    
    public static list<FSLFailModeWrapper> storeApplicationOrCategoryComplaintList() {
        
        FSL_IP_NamedCredentialWrapper reqWrapper = new FSL_IP_NamedCredentialWrapper();
        CG_OP_OAGWrapper responseWrapper = null;
        List<FSLFailModeWrapper> fslCDSResps = new list<FSLFailModeWrapper>();
        
        reqWrapper.methodType = 'GET';
        reqWrapper.NamedCredential = 'FSL_NC_Engine';
        reqWrapper.Path = '/failmodes?sender=CSS&target=CSSWarranty';
        responseWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
        if(responseWrapper.exceptionFlag){
            System.debug('Inside FSLFailModeService, request failed with endpoint :: '+ responseWrapper.endPoint);
            System.debug('Inside FSLFailModeService, request failed with exception :: '+ responseWrapper.exceptionMessage);
            throw new CalloutException(responseWrapper.exceptionMessage);
        }
        String responseBody = responseWrapper.response.getBody();
        system.debug('response for fsl fail mode service :: '+responseBody);
        responseBody = ' [ ' + responseBody + ' ] ';
        try{
            fslCDSResps = (List<FSLFailModeWrapper>)JSON.deserialize(responseBody, List<FSLFailModeWrapper>.Class);
        	system.debug('Deserialized response for fslfailmodeservice :: '+fslCDSResps);	
        }
        catch(Exception e){
            system.debug('Deserialization failed in FSLFailModeService :: '+e.getMessage());
            throw e;
        }
        return fslCDSResps;
    }
}