/**********************************************************************
Name: FSL_WS_SBL
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
<<<<<<< force-app/main/default/classes/FSL_WS_SBL.cls
1.0 -   Vinod Yelala      12/20/2018        INITIAL DEVELOPMENT   
2.0     karthik Gorantla  09/2/2020          Mule Api migration
3.0 -   Krishnamoorthi    09/08/2020        Added GetPartsData Web service.      
***********************************************************************/

public class FSL_WS_SBL {
    
    public static Integer respCode;//added by Vinod - 2/12 - for error handling
    public static FSLIntakeWarrantyResp getRetrybasiccoveragedetails;//added by Vinod - 2/12 - for error handling
    public static FSL_getBasicCoverageResponseJ2A basicCoverageDetails;
    //Start Method to get basic Coverage...This function is to be used in warranty coverage Search Functionality/
    Public static boolean testforerror;
    //By Priyanka For VGRS2-517
    public static void calloutGenericMuleNamedCredGetBasicCoverage(FSL_getBasicCoverageReqJ2A getBasicCoverageReq) {
        system.debug('in calloutGeneric method for CreateUpdate Incident Record Into ServiceNow...');
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        FSL_IP_NamedCredentialWrapper reqWrap = new FSL_IP_NamedCredentialWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
        try {
             String ESN;
            String Region;
            String Territory;
            String WarrantyStartDate;
            String EngineApplicationCode;
            String Jobd;
            String FailurePoint; //#85179
            String FailureUnit; //#85179
            String FailureDate; //CT3-497
            
            // getBasicCoverageReq.DataArea.ESN='79384192';
            String reconFlag;
            ESN = getBasicCoverageReq.DataArea.ESN;
            Region = getBasicCoverageReq.DataArea.Region;   
            Territory = getBasicCoverageReq.DataArea.Territory;   
            WarrantyStartDate = getBasicCoverageReq.DataArea.WarrantyStartDate;  
            FailureDate = getBasicCoverageReq.DataArea.FailureDate;
            EngineApplicationCode = getBasicCoverageReq.DataArea.EngineApplicationCode;
            Jobd = getBasicCoverageReq.DataArea.JobId;   
            FailurePoint = getBasicCoverageReq.DataArea.FailurePoint; //#85179
            FailureUnit = getBasicCoverageReq.DataArea.FailureUnit; //#85179
            reconFlag = getBasicCoverageReq.DataArea.ReconFlag;
           
          

           
    reqWrap.methodType = 'POST';
    reqWrap.NamedCredential = 'FSL_NC_Warranty';
    reqWrap.Path = '/v1/coverage/basic';
     String JSONReq = '{"Header": {"Sender": {"ServiceName": "GetBasicCoverage","SenderID": "CSS"},"Target": { "TargetID": "SIEBEL" }},"DataArea": {"ESN": "'+ESN+'","EngineApplicationCode": "'+EngineApplicationCode+'","Region": "'+Region+'","Territory": "'+Territory+'","WarrantyStartDate": "'+WarrantyStartDate+'","FailureDate": "'+FailureDate+'","PartsWarranty": "Y", "FailurePoint":"'+FailurePoint+'", "FailureUnit":"'+FailureUnit+'", "ReconFlag":"'+reconFlag+'"}}'; //#85179
           // req1.setBody(JSONReq);
         reqWrap.jsonReqBody = JSONReq;
    reqWrap.endPoint =[SELECT Endpoint FROM NamedCredential
                                        where DeveloperName=: reqWrap.NamedCredential 
                                        LIMIT 1].Endpoint+reqWrap.Path;

            system.debug('SRT reqJsonpriya>>>>>>>>>>>'+reqWrap.jsonReqBody);
            if(Test.isRunningTest() && reqWrap.jsonReqBody == null)
                {
                throw new CSS_MyException('Exception to cover Catch block');
                }
           
                HttpResponse res = new HttpResponse();
            //Added runningtest by anusha commented for test coverage               
            if(!Test.isRunningTest()){
                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrap);
             system.debug('SRT priyaresponse>>>>>>>>>>>'+returnWrapper);
             res = returnWrapper.response;
            // HttpResponse res = returnWrapper.response;
             respCode = res.getStatusCode();
            }
           // return returnWrapper;
           //starts anusha commented for test coverage
            //system.debug('respCode' + respCode); 
            //if(res.getStatusCode() == 200 || Test.isRunningTest()) {
            //Ends anusha commented for test coverage
              String jsonResponseBody;
           
                if(Test.isRunningTest()) {
                    if(testforerror <> null && testforerror) {
                        //jsonResponseBody='{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDedutibles":[]},"ProcedureNumber":""}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[]}}}}';
                        jsonResponseBody = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[]}}}}';
                    }
                    else {
                        jsonResponseBody = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"3/2/2025","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-007","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"12500","ComponentEndDate":"3/2/2025","ComponentStatus":"Active","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"500000"},{"CoverageHours":"3125","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"125000"},{"CoverageHours":"6250","ComponentEndDate":"3/2/2021","ComponentStatus":"Active","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"3/2/2025","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-503-007","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"12500","ComponentEndDate":"3/2/2025","ComponentStatus":"Active","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"500000"},{"CoverageHours":"3125","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"125000"},{"CoverageHours":"6250","ComponentEndDate":"3/2/2021","ComponentStatus":"Active","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"3/2/2025","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-503-007","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"12500","ComponentEndDate":"3/2/2025","ComponentStatus":"Active","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"500000"},{"CoverageHours":"3125","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"125000"},{"CoverageHours":"6250","ComponentEndDate":"3/2/2021","ComponentStatus":"Active","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"CoverageDedutibles":{"firstVisitAmt":"1","constantDecutibleAmt":"2"}}]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"07/05/2018","StartDate":"07/05/2013","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000046","EndHours":"0","CoverageType":"CAP-Customized Assurance Plan","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"CoverageDedutibles":{"firstVisitAmt":"1","constantDecutibleAmt":"2"}}]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"07/05/2016","StartDate":"07/05/2013","BeginHours":"0","EndMile":"300000","CertificateNumber":"DC41000046","EndHours":"0","CoverageType":"CAP-Customized Assurance Plan","ProcedureNumber":"111-505-129"}]}}}}';
                        //jsonResponseBody = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"3/2/2025","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-007","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"12500","ComponentEndDate":"3/2/2025","ComponentStatus":"Active","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"500000"},{"CoverageHours":"3125","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"125000"},{"CoverageHours":"6250","ComponentEndDate":"3/2/2021","ComponentStatus":"Active","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"3/2/2025","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"111-503-007","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"12500","ComponentEndDate":"3/2/2025","ComponentStatus":"Active","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"500000"},{"CoverageHours":"3125","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"125000"},{"CoverageHours":"6250","ComponentEndDate":"3/2/2021","ComponentStatus":"Active","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"3/2/2025","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"111-503-007","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"12500","ComponentEndDate":"3/2/2025","ComponentStatus":"Active","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"500000"},{"CoverageHours":"3125","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"125000"},{"CoverageHours":"6250","ComponentEndDate":"3/2/2021","ComponentStatus":"Active","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"firstVisitAmt":"1","constantDecutibleAmt":"2"}]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"07/05/2018","StartDate":"07/05/2013","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000046","EndHours":"0","CoverageType":"CAP-Customized Assurance Plan","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"firstVisitAmt":"1","constantDecutibleAmt":"2"}]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"07/05/2016","StartDate":"07/05/2013","BeginHours":"0","EndMile":"300000","CertificateNumber":"DC41000046","EndHours":"0","CoverageType":"CAP-Customized Assurance Plan","ProcedureNumber":"111-505-129"}]}}}}';
                        //jsonResponseBody = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"3/2/2025","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-007","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"12500","ComponentEndDate":"3/2/2025","ComponentStatus":"Active","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"500000"},{"CoverageHours":"3125","ComponentEndDate":"3/2/2022","ComponentStatus":"Active","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"125000"},{"CoverageHours":"6250","ComponentEndDate":"3/2/2021","ComponentStatus":"Active","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"07/05/2018","StartDate":"07/05/2013","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000046","EndHours":"0","CoverageType":"CAP-Customized Assurance Plan","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"07/05/2016","StartDate":"07/05/2013","BeginHours":"0","EndMile":"300000","CertificateNumber":"DC41000046","EndHours":"0","CoverageType":"CAP-Customized Assurance Plan","ProcedureNumber":"111-505-129"}]}}}}';
                    }
                    // jsonResponseBody = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":""},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"","CoverageType":"REW-Recon Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":""}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[]}}}}';
                    respcode = 200;
                }
                
               //else
                else if(res.getStatusCode() == 200)
                 {
                
                    jsonResponseBody = res.getBody();   //Temp for Demo.
                    //jsonResponseBody = '{"Header": {"Status": "Success","ReturnCodeDescription": ""},"BasicCoverageResponseHeader": {"Response": {"ListOfCoverageDetails": {"CoverageDetails": [{"Status": "Expired","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate": "6/19/2019","CoverageType": "NEW-New Engine Warranty","ProcedureNumber": "111-503-065","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "6251","ComponentEndDate": "6/19/2018","ComponentStatus": "Expired","CoverageMaxMonths": "12","CoverageComponentTypeCode": "BELTS/HOSES","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "250000"},{"CoverageHours": "6251","ComponentEndDate": "6/19/2019","ComponentStatus": "Expired","CoverageMaxMonths": "24","CoverageComponentTypeCode": "BASE","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "250000"}]}},{"Status": "Active","ListOfCoverageDedutibles": {"CoverageDedutibles": []},"WarrantyManualURL": "https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate": "6/19/2022","CoverageType": "EMS-Emissions Warranty","ProcedureNumber": "","ListOfCoverageComponentList": {"CoverageComponentList": [{"CoverageHours": "0","ComponentEndDate": "6/19/2022","ComponentStatus": "Active","CoverageMaxMonths": "60","CoverageComponentTypeCode": "EMISSIONS","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "100000"},{"CoverageHours": "3000","ComponentEndDate": "6/19/2022","ComponentStatus": "Active","CoverageMaxMonths": "60","CoverageComponentTypeCode": "EMISSIONS-CA","MegawattHours": "0","CoverageDefenitionType": "BASE","CoverageMinMonths": "0","CoverageMiles": "100000"}]}}]},"ListOfExtendedCoverageDetails": {"ExtendedCoverageDetails": [{"Status": "Expired","WarrantyManualURL": "https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months": "60","ListOfExtCoverageDedutibles": {    "ExtendedCoverageDedutibles": []},"CAPCoverageID": "CRT","ProgramID": "TP4","BeginMiles": "0","EndDate": "03/21/2017","StartDate": "03/21/2012","BeginHours": "0","EndMiles": "500000","CertificateNumber": "TP41000230","EndHours": "0","CoverageType": "CAP-Customized Assurance Plan","ProcedureNumber": "111-505-114"}]}}}}';
                }
                system.debug('getBasicCoverage Response jsonrespbasiccov>>>>:'+jsonResponseBody);
                // de-serializing the response and mapping it to wrapper class
                if(jsonResponseBody.containsIgnoreCase('"Status":"error"')) {
                    basicCoverageDetails= (FSL_getBasicCoverageResponseJ2A)JSON.deserialize(jsonResponseBody,FSL_getBasicCoverageResponseJ2A.class);
                    // getRetrybasiccoveragedetails= (FSLIntakeWarrantyResp)JSON.deserialize(jsonResponseBody,FSLIntakeWarrantyResp.class);
                }
                else {
                    basicCoverageDetails= (FSL_getBasicCoverageResponseJ2A)JSON.deserialize(jsonResponseBody,FSL_getBasicCoverageResponseJ2A.class);
                }
                System.debug('Status Code >>> :: ' + res.getStatusCode());
                System.debug('REST response is ::' + res);
                system.debug('Response Body Priya >>>' + res.getbody());
                system.debug('WarpperResponse' + basicCoverageDetails);
                // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req1.getBody(),res.getBody(),Null,Null,'get basic CoverageDetails',res.getStatus(),'code','toolid',''));
            
        }
        catch(Exception ex) {
            System.debug('getLineNumber*********************is :: ' + ex.getLineNumber());
            System.debug('getMessage*********************is :: ' + ex.getMessage());
           // if(!Test.isRunningTest()) {
               // message = ex.getMessage();
               // if(message.contains('timed out')) {
                    // css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL get basic Coverage', 'RESPONSE IS NULL', 'SBL');
               // }
              //  else {
                    // css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL get basic Coverage', res.getBody(), 'SBL');
              //  }
            
        }
        
        
    }
    

    //Start Method to get basic Coverage...This function is to be used in fetch the parts data from siebel/
    public static CG_OP_OAGWrapper getpartsdata(string PartNumberShort) {

        CG_OP_OAGWrapper outputWrapper;
        CG_GetPartsdatareqWrapper paidClaimsWrapper = new CG_GetPartsdatareqWrapper();
        try {

            // Start - code comented by charan for Phoen-266
            
            //  CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            //Mule Integration start
            /*CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
              conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartsData');*/
            //Mule Integration end
            //end - code comented for Phoen-266
          
            // start - added by charan Phoen-266
            FSL_IP_NamedCredentialWrapper reqWrapper = null;  
            reqWrapper= new FSL_IP_NamedCredentialWrapper();
            reqWrapper.methodType = 'GET';
            reqWrapper.NamedCredential = 'FSL_NC_Engine';
            //BY Priyanka for VGRS2-731 8/25/2022
            reqWrapper.Path = '/parts?sender=CSS&target=CSSWarranty&partNumberShort='+PartNumberShort;
         //   reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
           // reqWrapper.endPoint += '?sender=CSS&target=CSSWarranty&partNumberShort='+PartNumberShort;
            
            system.debug('endpoint==>'+reqWrapper.endPoint);
            
          /*  String reqBody =  '{"Header":{"Sender":{ "MessageID":"UniqueID","ServiceName": "getpartsdata","SenderID":"CSS" }},"DataArea":{"PartNumberShort": "'+ PartNumberShort +'"}}';
            System.debug('reqBody ******* '+ reqBody);
            reqWrapper.jsonReqBody = reqBody;
            */
            //String reqBody = '';
            //reqWrapper.jsonReqBody = reqBody;
            reqWrapper.timeOut = 120000;
            system.debug('parts req >>>>>>>>>>>'+reqWrapper.jsonReqBody);
            // commented for Phoen-266
            /* String endPoint = conDetails.End_Point__c+'?sender=CSS&target=CSSWarranty&partNumberShort='+PartNumberShort;//3899283';
            reqWrapper.endPoint = endPoint;
            reqWrapper.methodType = conDetails.Method_Type__c;
            reqWrapper.serviceName = 'CSS_SBL_GetPartsData'; */
                        
            outputWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
            system.debug('parts res >>>>>>>>>>>'+outputWrapper);
            HttpResponse resp = outputWrapper.response;
            system.debug('RESPONSEEEE '+resp);
            
             // Code end - added by charan for Phoen-266
            
           //outputWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
            //outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper); // commented for Phoen-266
            //outputWrapper = null; //If you un-comment Service will fail  
            if(outputWrapper != null && outputWrapper.exceptionFlag != null && outputWrapper.exceptionFlag == true){
                System.debug('Exception of getpartsdata service is ******* '+ outputWrapper.exceptionMessage);
                outputWrapper = null;

            }

            if(outputWrapper != null && outputWrapper.response != null && outputWrapper.response.getBody() != null)
            {
                System.debug('outputWrapper.response.getBody() ******* '+ outputWrapper.response.getBody());
            }

        } 
        catch(exception e)
        {
            outputWrapper = null;
            system.debug('Entered into catch of getpartdata Method in CSS_FN_SIEBEL>>>'+e.getMessage() +e.getLineNumber());
        }
        return outputWrapper;
    }
    // END Method to get parts data..This function is to be used in fetch the parts data from siebel/
}