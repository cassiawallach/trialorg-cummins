public without sharing class FSL_CL_PMRecommendationsService {
    
    @future(callout=true)
    public static void sendRecommendations(Id RecommendationId){
        FSL_Recommendation__c recommendation = [SELECT id,Name,Service_Order__r.WorkOrderNumber,Service_Order__r.Shop_Work_Order__c,
                                                Service_Order__r.Account.FSL_ERP_Customer_Code__c,Service_Order__r.WorkType.Name,
                                                Urgency__c,Detailed_Repair_Information__c,Parts_Information__c,On_site_Labor_Time_for_Repair__c,
                                                Service_Order__r.ServiceTerritory.Location_Code__c
                                                FROM FSL_Recommendation__c 
                                                WHERE Id = :RecommendationId
                                                LIMIT 1];
        FSL_CL_PMRecommendationsWrapper reqObj = new FSL_CL_PMRecommendationsWrapper();
        
        reqObj.Header = new FSL_CL_PMRecommendationsWrapper.Header();
        reqObj.Header.Sender = new FSL_CL_PMRecommendationsWrapper.Sender('PMRecommendationsInfo','Guidanz');
        reqObj.Header.Target = new FSL_CL_PMRecommendationsWrapper.Target('BMS');
        if(recommendation.Service_Order__r?.ServiceTerritory?.Location_Code__c != null){
            reqObj.Header.Location = new FSL_CL_PMRecommendationsWrapper.Location(recommendation.Service_Order__r?.ServiceTerritory?.Location_Code__c.left(11));
        } else{
            reqObj.Header.Location = new FSL_CL_PMRecommendationsWrapper.Location('');
        }
        reqObj.DataArea = new FSL_CL_PMRecommendationsWrapper.DataArea();
        
        FSL_CL_PMRecommendationsWrapper.Recommendation recmObj= new FSL_CL_PMRecommendationsWrapper.Recommendation();
        recmObj.RecommendationId = recommendation.Name;
        recmObj.WorkOrderNumber = recommendation.Service_Order__r.WorkOrderNumber;
        recmObj.ShopWorkOrder = recommendation.Service_Order__r.Shop_Work_Order__c != null ? recommendation.Service_Order__r.Shop_Work_Order__c : '';
        recmObj.CustomerCode = recommendation.Service_Order__r.Account.FSL_ERP_Customer_Code__c;
        recmObj.OrderType = recommendation.Service_Order__r.WorkType.Name;
        if(string.isNotBlank(recommendation.Urgency__c))
            if('Recommended with next PM'.equalsIgnoreCase(recommendation.Urgency__c))
                recmObj.SubType = 'PMR';
            else if('Recommended before next PM'.equalsIgnoreCase(recommendation.Urgency__c))
                recmObj.SubType = 'PMR ASAP';
            else if('Recommended Now - Emergency'.equalsIgnoreCase(recommendation.Urgency__c))
                recmObj.SubType = 'PMR EMERGENT';
        recmObj.RepairInformation = recommendation.Detailed_Repair_Information__c != null ? recommendation.Detailed_Repair_Information__c : '';
        recmObj.PartsInformation = recommendation.Parts_Information__c != null ? recommendation.Parts_Information__c : '';
        recmObj.EstimatedRepairTime = recommendation.On_site_Labor_Time_for_Repair__c != null ? recommendation.On_site_Labor_Time_for_Repair__c : '';
        reqObj.DataArea.Recommendations = recmObj;
            

        System.debug('@@@Req Body:'+JSON.serialize(reqObj));

        CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
        CG_OP_OAGWrapper resWrapper;
        String accessToken;
        final String SERVICE_NAME = 'FSL_PMRecommendationsInfo';
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails = CSS_getConnnectionDetails.getConnection(SERVICE_NAME);
        
        CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(conDetails.AuthEnv__c,SERVICE_NAME);
        accesstoken = accessTokenOPWrap.accessToken;
        reqWrapper.jsonReqBody = JSON.serialize(reqObj);
        reqWrapper.serviceName = SERVICE_NAME;
        reqWrapper.methodType = conDetails.Method_Type__c;
        reqWrapper.endPoint = conDetails.End_Point__c;
        //Send Request
        resWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
        System.debug('###RES:'+ resWrapper);
        if(resWrapper.response != null){
            String resBody = resWrapper.response.getBody();
            if(!Test.isRunningTest()){
                resBody = resWrapper.response.getBody();
            } else{
                resBody = '{"DataArea": {"Recommendations" : {"QuoteId" : "1235"}}}';
            }
            FSL_CL_PMRecommendationsResponseWrapper resObject = (FSL_CL_PMRecommendationsResponseWrapper)Json.deserialize(resBody,FSL_CL_PMRecommendationsResponseWrapper.class);
            recommendation.Quote_ID__c = resObject.DataArea.Recommendations.QuoteId;
                recommendation.Status__c = 'Request for Quote Sent';
        }
        if(resWrapper.exceptionFlag){
            recommendation.Status__c = 'In Progress';
        }
            update recommendation;
    }

}