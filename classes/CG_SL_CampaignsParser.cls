/**********************************************************************
Name: CG_SL_CampaignsParser
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This class is used as a Parser for Service layer 
			
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        12/11/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
public class CG_SL_CampaignsParser {

    /**
     * This is used for Preparing Request JSON
     * 
     */
    public static CG_IP_CampaignsReqJSON prepareReqWprForGetCampaigns(String esn, String failureDate, String region, String territory, String senderID, String serviceName, String messageID, String target){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareReqWprForGetCampaigns method of CG_SL_CampaignsParser $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CG_IP_CampaignsReqJSON reqJSONWrapper = null;
        CG_IP_CampaignsReqJSON.Header headerObj = null;
        CG_IP_CampaignsReqJSON.Sender senderObj = null;
        CG_IP_CampaignsReqJSON.DataArea dataAreaObj = null;
        try{
            //Prepare Request JSON
        	reqJSONWrapper = new CG_IP_CampaignsReqJSON();
            headerObj = new CG_IP_CampaignsReqJSON.Header();
            senderObj = new CG_IP_CampaignsReqJSON.Sender();
            dataAreaObj = new CG_IP_CampaignsReqJSON.DataArea();
            
            senderObj.SenderID = senderID;
            senderObj.ServiceName = serviceName;
            senderObj.MessageID = messageID;
            headerObj.Target = target;
            dataAreaObj.Esn = esn;
            dataAreaObj.FailureDate = failureDate;
            dataAreaObj.Region = region;
            dataAreaObj.Territory = territory;
            
            headerObj.Sender =  senderObj;
            reqJSONWrapper.Header = headerObj;
            reqJSONWrapper.DataArea = dataAreaObj;
            
        }catch(Exception ex){
            System.debug('in catch of CG_SL_CampaignsParser of CG_SL_CampaignsParser >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }finally{
            headerObj=null;senderObj=null;
        }
        return reqJSONWrapper;
    }
    
}