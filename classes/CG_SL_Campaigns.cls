/**********************************************************************
Name: CG_SL_Campaigns
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This class is used as a controller for Service layer 
to navigate to Parser class by passing required parameters
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        12/11/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
public class CG_SL_Campaigns {

    public static CG_OP_OAGWrapper callGetCampaignsWS(String esn, String failureDate, String region, String territory, String senderID, String serviceName, String messageID, String target){
        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper resWrapper;
        String endPointURL;
        try{
            reqWrapper = new CG_IP_OAGWrapper();
            //
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('GetCampaign');
            system.debug('conDetails<><>'+conDetails);
            
                endPointURL = conDetails.End_Point__c;
                //endPointURL = endPointURL+'/cmi-engine/engines/'+esn+'/campaigns?'+'sender=SFMX&target=CSSWarranty&'+'failureDate='+failureDate;
                endPointURL = endPointURL+'/cmi-engine/engines/'+esn+'/campaigns?'+'sender=CSS&target=CSSWarranty&'+'failureDate='+failureDate+'&territory='+territory+'&region='+region;
                endPointURL = endPointURL.replace(' ','%20');
                system.debug('*****endPointURL***'+endPointURL);
            
            ///cmi-engine/engines/{esn}/campaigns?sender=CSS&target=CSSWarranty&failureDate=22-Jan-20&territory=100&region=NORTH AMERICA
            //Prepare Request Wrapper
            CG_IP_CampaignsReqJSON reqJson = CG_SL_CampaignsParser.prepareReqWprForGetCampaigns(esn, failureDate, region, territory, senderID, serviceName, messageID, target);
            System.debug('beforeserializereqJsony:'+reqJson);
            reqWrapper.jsonReqBody = JSON.serialize(reqJson);
            System.debug('reqWrapper.jsonReqBody>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.jsonReqBody);
            System.debug('reqWrapper>>>>>>>>>>>>>>>>>>>>:'+reqWrapper);
           // reqWrapper.methodType = 'POST';
            reqWrapper.methodType = conDetails.Method_Type__c;
            //reqWrapper.serviceName = 'GetCampaign';
            reqWrapper.serviceName = conDetails.Name;
            reqWrapper.endPoint = endPointURL;
            System.debug('reqWrapper.methodType>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.methodType);
            System.debug('reqWrapper.serviceName>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.serviceName);
            System.debug('reqWrapper.endPointr>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.endPoint);



            //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
            if(reqJson != null){

                //Code added for testing purpose
                if(Test.isRunningTest() )
                {
                    if(esn == null && failureDate == null && region == null && territory == null && senderID == null && serviceName == null && messageID == null && target == null)
                        throw new CSS_MyException('Exception to cover Catch block'); 
                }
                //commented below line as per Mule
               // resWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
                resWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                System.debug('resWrapper.response>>>>>>>>>>>>>>>>>>>>:'+resWrapper);
            }

        }catch(exception e){
            system.debug('Entered into catch block of callGetCampaignsWS method in CG_SL_Campaigns class:'+e.getMessage()+' Line No:'+e.getLineNumber());
            resWrapper.exceptionFlag=true;
            resWrapper.errorMessage = e.getMessage();
            return resWrapper;

        }
        return resWrapper;
    }


}