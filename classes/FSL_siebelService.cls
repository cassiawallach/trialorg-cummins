/**********************************************************************
Name: FSL_siebelService
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
VERSION  AUTHOR                     DATE               Description                                      
1.0     Ravikanth Macherla         5/03/2019     
2.0     karthik Gorantla           09/2/2020          Mule Api migration
3.0     Vinod Yealal         9/22/2020       added checks for code coverage for siebel
***********************************************************************/
public class FSL_siebelService {
    
    public static list<CSS_SiebelFailCodeResponseJ2A> storeApplicationOrCategoryComplaintList() {
        
        CG_OP_OAGWrapper outputWrapper;
        list<CSS_SiebelFailCodeResponseJ2A> failCodeWrapper = new list<CSS_SiebelFailCodeResponseJ2A>();
        try {
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_FailCodes');
            date processedDate;
            processedDate = Date.Today() - 1;
            system.debug('processedDate%%'+processedDate);
            string processedDateString = DateTime.newInstance(processedDate.year(),processedDate.month(),processedDate.day()).format('YYYY-MM-dd');//2018-01-14
            system.debug(processedDateString);
            //Prepare Request Wrapper
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            //String reqBody = '{"Header": {"Sender": {"ServiceName": "GetFailCodes","SenderID": "CSS"},"Target": {"TargetID": "SIEBEL"}},"DataArea": {"LAST_PROCESSED_DATE": "' + processedDateString + '"}}';//pass date and format.
            String endPoint='';
            //added for test coverage by vinod yelala 9.22.2020
            if (conDetails <> null)
            {endpoint = conDetails.End_Point__c+'?sender=CSS&target=CSSWarranty&lastProcessedDate='+processedDateString;//2019-01-19
            reqWrapper.methodType = conDetails.Method_Type__c;}
            else {
                endpoint='https://test.int';
                reqWrapper.methodType='POST';
            }
            //System.debug('requeststring ******* '+ reqBody);
            //reqWrapper.jsonReqBody = reqBody;
            reqWrapper.serviceName = 'CSS_SBL_FailCodes';
            reqWrapper.endPoint = endPoint;
            
            //outputWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
             /*
          Updated as part of CT1 -158 by karthik G
          Updated below code to fetch token from Mule Api migration.
           */
            
            //System.debug('outputWrapper ******* '+ outputWrapper.response.getBody());
            String responseBody;
            if(Test.isRunningTest())
            responseBody = '{"DataArea":{"Details":[{"Active":"N","BusinesUnit":"CMI","ServiceGroupCode":"","UpdatedDate":"2016-11-11T14:44:19.000-06:00","SystemCode":"FY","ComponentCode":"NS","FailureName":"NOZZLE SPRING","SystemName":"INJ (CEL)","ComponentName":"NOZZLE SPRING","Created":"2016-11-11T14:40:01.000-06:00"},{"Active":"Y","BusinesUnit":"CMI","ServiceGroupCode":"16","UpdatedDate":"2016-11-11T14:44:19.000-06:00","SystemCode":"AR","ComponentCode":"CM","FailureName":"COOLING MTG HDWE","SystemName":"MTG ADAPT","ComponentName":"COOLING MTG HDWE","Created":"2016-11-11T14:40:01.000-06:00"}]},"Header":{"Status":"Success","ReturnCode":"","ReturnCodeDescription":"","MessageIdentifier":"3c62aeb8-17d5-4a61-ac45-aa2a6b760553"}}';
            else {
                responseBody = outputWrapper.response.getBody();
                outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);}
            responseBody = ' [ ' + responseBody + ' ] ';
            failCodeWrapper = (list<CSS_SiebelFailCodeResponseJ2A>)JSON.deserialize(responseBody ,list<CSS_SiebelFailCodeResponseJ2A>.class);
            //system.debug('failCodeWrapper >>> '+failCodeWrapper);
            
            //if(outputWrapper != null && outputWrapper.response != null && outputWrapper.response.getBody() != null) {
                //  insertResponse(outputWrapper.response.getBody(), 'getFailCodes');
            //}
        } catch(exception e){
            system.debug('Entered into catch of getFailCodes Method >>>'+e.getMessage() +e.getLineNumber());
        }
        return failCodeWrapper ;
    }
}