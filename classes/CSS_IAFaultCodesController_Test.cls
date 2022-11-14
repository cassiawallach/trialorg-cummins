/**********************************************************************
Name: CSS_IAFaultCodesController_Test
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    This is test class for CSS_IAFaultCodesController                                                          
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Rajesh P        03/16/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest
public class CSS_IAFaultCodesController_Test {
    @isTest static void IAFaultCodesMethod(){
        Test.startTest();
        string ReqJSON='{"Header": {"ServiceName": "GetAssessData","ServiceVersion": "2.0","ToolID": "ATLASMOBILE","SenderID": "oh559","TargetID": "CSS" },"DataArea": {"PSN": "79484646","SERVICEMODELNAME": "ISX15 CM2250","ERT": "15255","MAKE": "PETERBILT","MODEL":"389","ACCESS": "B","UserLocation": ",7362332,44444-16402,56270-56255-P","CustomerName": "IA Cummins Test","ComplaintText": "Oil Leak Testing12345","IASNumber": "","FAULTLIST": [{"fc": "1117",        "occurenceTime": 12,"status": "active", "count": 1},{"fc": "1116", "occurenceTime": 654,"status": "active", "count": 1 },{"fc": "1118","occurenceTime": 7865,"status": "active","count": 1 },{ "fc": "1119", "occurenceTime": 80876,"status": "active", "count": 1 }]}}';
        string ResJSON='{"Header":{"TxnCodeDescription":"CG01-IAS record inserted successfully","Status":"Success","ServiceVersion":"2.0","ServiceName":"GetAssessData","ReturnCodeDescription":"Fault Details Data sent successfully"},"DataArea":{"unPrioritizedData":[{"upfc":"1116","rc":"4"},{"upfc":"1118","rc":"4"},{"upfc":"1119","rc":"4"}],"PSN":"79484646","prioritizedData":[{"rootCause4":"","rootCause3":"","rootCause2":"Engine Wiring Harness","rootCause1":"OEM Component","relfc":[],"rc4Likelihood":"","rc3Likelihood":"","rc2Likelihood":"11%","rc1Likelihood":"82%","prifc":"1117","lhrs":"5.65"}],"IASNumber":"IAS-0000000498","CSSEnabled":"Y","algorithm":"Advanced"}}';
        CSS_DataExchange_Parent__c LstRef1 = new CSS_DataExchange_Parent__c();
        LstRef1.IAS_Number__c='IAS-260';
        LstRef1.MAKE__c='PETERBILT';
        LstRef1.MODEL__c='389';
        LstRef1.ACCESS__c='B';
        LstRef1.Status__c='Success';
        LstRef1.Request_JSON__c=ReqJSON;
        LstRef1.Response_JSON__c=ResJSON;
        LstRef1.TargetID__c='CSS';
        LstRef1.SenderID__c='OK152';
        LstRef1.ServiceName__c='GetAssessData';
        LstRef1.CSS_Job_Number__c='59590';
        LstRef1.Complaint_Text__c='Oil Leak Testing12345';
        LstRef1.User_Location__c='7362332,44444-16402,56270-56255-P';
        insert LstRef1;
        system.debug('Rajesh-LstRef1==>'+LstRef1);
        CSS_IAFaultCodesController  IAFaultRef1 = new CSS_IAFaultCodesController();
        // IAFaultRef1.jobNumber = '12345';
        //IAFaultRef1.FaultCodeWrapper fw = new IAFaultRef1.FaultCodeWrapper();
        CSS_IAFaultCodesController.FaultCodeWrapper fcw = new CSS_IAFaultCodesController.FaultCodeWrapper();
        fcw.count = 2;
        fcw.fc = 'string';
        fcw.status = 'pass';
        fcw.relCodes = 'codes';
        fcw.formattedLastOccTime = 'time';
        fcw.lastOccTime = 2;
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2 wrpr = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2();
        CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2 wrprlabor = new CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2();
        CSS_WPR_TG_FaultDetailsDataResJSON_V2 wrprfault = new CSS_WPR_TG_FaultDetailsDataResJSON_V2();
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2.DataArea jidi = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2.DataArea();
        jidi.PSN = '12345';
        jidi.algorithm = 'string';

        Test.setMock(HttpCalloutMock.class, new CSS_IAFaultcodeMockTest());
        //pr.prifc = 'sss';
        List<CSS_IAFaultCodesController.FaultCodeWrapper> lstwr = new List<CSS_IAFaultCodesController.FaultCodeWrapper>();
        List<CSS_IAFaultCodesController.FaultCodeWrapper> lstun = new List<CSS_IAFaultCodesController.FaultCodeWrapper>();
        Map<String, CSS_IAFaultCodesController.FaultCodeWrapper> mapfault = new  Map<String, CSS_IAFaultCodesController.FaultCodeWrapper>();
        IAFaultRef1.priFCWrapList = lstwr;
        IAFaultRef1.unPriFCWrapList = lstun;
        IAFaultRef1.getPriUnPriWrapListsOfFC(lstwr, lstun, mapfault, wrpr);
        IAFaultRef1.getPriUnPriWrapListsOfLaborHours(lstwr, lstun, mapfault, wrprlabor);
        IAFaultRef1.getPriUnPriWrapListsOfFaultDetails(lstwr, lstun, mapfault, wrprfault);
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Roopa';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RoopaTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        jo.Request_JSON__c = ReqJSON;//'jsonnnn';
        jo.Response_JSON__c = ResJSON;//'jsonresponse';
        //JO.Name = '12345';
        insert jo;
        JO = [select id, Name from css_job_Order__c where id = : JO.id];
        system.debug('JO.Name**'+JO.Name);
        // CSS_Job_Order__c jo = CSS_TestData.createJobOrder(True);
        IAFaultRef1.jobNumber = JO.Name;

        IAFaultRef1.prepareFCsWrapper(jo);
        Test.stopTest();
    }

    @isTest static void IAFaultCodesMethod1(){
        Test.startTest();
        string ReqJSON='{"Header": {"ServiceName": "GetPrioritizedFC","ServiceVersion": "2.0","ToolID": "ATLASMOBILE","SenderID": "oh559","TargetID": "CSS" },"DataArea": {"PSN": "79484646","SERVICEMODELNAME": "ISX15 CM2250","ERT": "15255","MAKE": "PETERBILT","MODEL":"389","ACCESS": "B","UserLocation": ",7362332,44444-16402,56270-56255-P","CustomerName": "IA Cummins Test","ComplaintText": "Oil Leak Testing12345","IASNumber": "","FAULTLIST": [{"fc": "1117",        "occurenceTime": 12,"status": "active", "count": 1},{"fc": "1116", "occurenceTime": 654,"status": "active", "count": 1 },{"fc": "1118","occurenceTime": 7865,"status": "active","count": 1 },{ "fc": "1119", "occurenceTime": 80876,"status": "active", "count": 1 }]}}';
        string ResJSON='{"Header":{"TxnCodeDescription":"CG01-IAS record inserted successfully","Status":"Success","ServiceVersion":"2.0","ServiceName":"GetAssessData","ReturnCodeDescription":"Fault Details Data sent successfully"},"DataArea":{"unPrioritizedData":[{"upfc":"1116","rc":"4"},{"upfc":"1118","rc":"4"},{"upfc":"1119","rc":"4"}],"PSN":"79484646","prioritizedData":[{"rootCause4":"","rootCause3":"","rootCause2":"Engine Wiring Harness","rootCause1":"OEM Component","relfc":[],"rc4Likelihood":"","rc3Likelihood":"","rc2Likelihood":"11%","rc1Likelihood":"82%","prifc":"1117","lhrs":"5.65"}],"IASNumber":"IAS-0000000498","CSSEnabled":"Y","algorithm":"Advanced"}}';
        CSS_DataExchange_Parent__c LstRef1 = new CSS_DataExchange_Parent__c();
        LstRef1.IAS_Number__c='IAS-260';
        LstRef1.MAKE__c='PETERBILT';
        LstRef1.MODEL__c='389';
        LstRef1.ACCESS__c='B';
        LstRef1.Status__c='Success';
        LstRef1.Request_JSON__c=ReqJSON;
        LstRef1.Response_JSON__c=ResJSON;
        LstRef1.TargetID__c='CSS';
        LstRef1.SenderID__c='OK152';
        LstRef1.ServiceName__c='GetPrioritizedFC';
        LstRef1.CSS_Job_Number__c='59590';
        LstRef1.Complaint_Text__c='Oil Leak Testing12345';
        LstRef1.User_Location__c='7362332,44444-16402,56270-56255-P';
        insert LstRef1;
        system.debug('Rajesh-LstRef1==>'+LstRef1);
        CSS_IAFaultCodesController  IAFaultRef1 = new CSS_IAFaultCodesController();
        // IAFaultRef1.jobNumber = '12345';
        //IAFaultRef1.FaultCodeWrapper fw = new IAFaultRef1.FaultCodeWrapper();
        CSS_IAFaultCodesController.FaultCodeWrapper fcw = new CSS_IAFaultCodesController.FaultCodeWrapper();
        fcw.count = 2;
        fcw.fc = 'string';
        fcw.status = 'pass';
        fcw.relCodes = 'codes';
        fcw.formattedLastOccTime = 'time';
        fcw.lastOccTime = 2;
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2 wrpr = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2();
        CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2 wrprlabor = new CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2();
        CSS_WPR_TG_FaultDetailsDataResJSON_V2 wrprfault = new CSS_WPR_TG_FaultDetailsDataResJSON_V2();
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2.DataArea jidi = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2.DataArea();
        jidi.PSN = '12345';
        jidi.algorithm = 'string';

        Test.setMock(HttpCalloutMock.class, new CSS_IAFaultcodeMockTest());
        //pr.prifc = 'sss';
        List<CSS_IAFaultCodesController.FaultCodeWrapper> lstwr = new List<CSS_IAFaultCodesController.FaultCodeWrapper>();
        List<CSS_IAFaultCodesController.FaultCodeWrapper> lstun = new List<CSS_IAFaultCodesController.FaultCodeWrapper>();
        Map<String, CSS_IAFaultCodesController.FaultCodeWrapper> mapfault = new  Map<String, CSS_IAFaultCodesController.FaultCodeWrapper>();
        IAFaultRef1.priFCWrapList = lstwr;
        IAFaultRef1.unPriFCWrapList = lstun;
        IAFaultRef1.getPriUnPriWrapListsOfFC(lstwr, lstun, mapfault, wrpr);
        IAFaultRef1.getPriUnPriWrapListsOfLaborHours(lstwr, lstun, mapfault, wrprlabor);
        IAFaultRef1.getPriUnPriWrapListsOfFaultDetails(lstwr, lstun, mapfault, wrprfault);
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Roopa';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RoopaTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        jo.Request_JSON__c = ReqJSON;//'jsonnnn';
        jo.Response_JSON__c = ResJSON;//'jsonresponse';
        //JO.Name = '12345';
        insert jo;
        JO = [select id, Name from css_job_Order__c where id = : JO.id];
        system.debug('JO.Name**'+JO.Name);
        // CSS_Job_Order__c jo = CSS_TestData.createJobOrder(True);
        IAFaultRef1.jobNumber = JO.Name;

        IAFaultRef1.prepareFCsWrapper(jo);
        Test.stopTest();
    }

    @isTest static void IAFaultCodesMethod2(){
        Test.startTest();
        string ReqJSON='{"Header": {"ServiceName": "GetLaborHrsData","ServiceVersion": "2.0","ToolID": "ATLASMOBILE","SenderID": "oh559","TargetID": "CSS" },"DataArea": {"PSN": "79484646","SERVICEMODELNAME": "ISX15 CM2250","ERT": "15255","MAKE": "PETERBILT","MODEL":"389","ACCESS": "B","UserLocation": ",7362332,44444-16402,56270-56255-P","CustomerName": "IA Cummins Test","ComplaintText": "Oil Leak Testing12345","IASNumber": "","FAULTLIST": [{"fc": "1117",        "occurenceTime": 12,"status": "active", "count": 1},{"fc": "1116", "occurenceTime": 654,"status": "active", "count": 1 },{"fc": "1118","occurenceTime": 7865,"status": "active","count": 1 },{ "fc": "1119", "occurenceTime": 80876,"status": "active", "count": 1 }]}}';
        string ResJSON='{"Header":{"TxnCodeDescription":"CG01-IAS record inserted successfully","Status":"Success","ServiceVersion":"2.0","ServiceName":"GetAssessData","ReturnCodeDescription":"Fault Details Data sent successfully"},"DataArea":{"unPrioritizedData":[{"upfc":"1116","rc":"4"},{"upfc":"1118","rc":"4"},{"upfc":"1119","rc":"4"}],"PSN":"79484646","prioritizedData":[{"rootCause4":"","rootCause3":"","rootCause2":"Engine Wiring Harness","rootCause1":"OEM Component","relfc":[],"rc4Likelihood":"","rc3Likelihood":"","rc2Likelihood":"11%","rc1Likelihood":"82%","prifc":"1117","lhrs":"5.65"}],"IASNumber":"IAS-0000000498","CSSEnabled":"Y","algorithm":"Advanced"}}';
        CSS_DataExchange_Parent__c LstRef1 = new CSS_DataExchange_Parent__c();
        LstRef1.IAS_Number__c='IAS-260';
        LstRef1.MAKE__c='PETERBILT';
        LstRef1.MODEL__c='389';
        LstRef1.ACCESS__c='B';
        LstRef1.Status__c='Success';
        LstRef1.Request_JSON__c=ReqJSON;
        LstRef1.Response_JSON__c=ResJSON;
        LstRef1.TargetID__c='CSS';
        LstRef1.SenderID__c='OK152';
        LstRef1.ServiceName__c='GetLaborHrsData';
        LstRef1.CSS_Job_Number__c='59590';
        LstRef1.Complaint_Text__c='Oil Leak Testing12345';
        LstRef1.User_Location__c='7362332,44444-16402,56270-56255-P';
        insert LstRef1;
        system.debug('Rajesh-LstRef1==>'+LstRef1);
        CSS_IAFaultCodesController  IAFaultRef1 = new CSS_IAFaultCodesController();
        // IAFaultRef1.jobNumber = '12345';
        //IAFaultRef1.FaultCodeWrapper fw = new IAFaultRef1.FaultCodeWrapper();
        CSS_IAFaultCodesController.FaultCodeWrapper fcw = new CSS_IAFaultCodesController.FaultCodeWrapper();
        fcw.count = 2;
        fcw.fc = 'string';
        fcw.status = 'pass';
        fcw.relCodes = 'codes';
        fcw.formattedLastOccTime = 'time';
        fcw.lastOccTime = 2;
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2 wrpr = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2();
        CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2 wrprlabor = new CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2();
        CSS_WPR_TG_FaultDetailsDataResJSON_V2 wrprfault = new CSS_WPR_TG_FaultDetailsDataResJSON_V2();
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2.DataArea jidi = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2.DataArea();
        jidi.PSN = '12345';
        jidi.algorithm = 'string';

        Test.setMock(HttpCalloutMock.class, new CSS_IAFaultcodeMockTest());
        //pr.prifc = 'sss';
        List<CSS_IAFaultCodesController.FaultCodeWrapper> lstwr = new List<CSS_IAFaultCodesController.FaultCodeWrapper>();
        List<CSS_IAFaultCodesController.FaultCodeWrapper> lstun = new List<CSS_IAFaultCodesController.FaultCodeWrapper>();
        Map<String, CSS_IAFaultCodesController.FaultCodeWrapper> mapfault = new  Map<String, CSS_IAFaultCodesController.FaultCodeWrapper>();
        IAFaultRef1.priFCWrapList = lstwr;
        IAFaultRef1.unPriFCWrapList = lstun;
        IAFaultRef1.getPriUnPriWrapListsOfFC(lstwr, lstun, mapfault, wrpr);
        IAFaultRef1.getPriUnPriWrapListsOfLaborHours(lstwr, lstun, mapfault, wrprlabor);
        IAFaultRef1.getPriUnPriWrapListsOfFaultDetails(lstwr, lstun, mapfault, wrprfault);
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Roopa';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RoopaTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        jo.Request_JSON__c = ReqJSON;//'jsonnnn';
        jo.Response_JSON__c = ResJSON;//'jsonresponse';
        //JO.Name = '12345';
        insert jo;
        JO = [select id, Name from css_job_Order__c where id = : JO.id];
        system.debug('JO.Name**'+JO.Name);
        // CSS_Job_Order__c jo = CSS_TestData.createJobOrder(True);
        IAFaultRef1.jobNumber = JO.Name;

        IAFaultRef1.prepareFCsWrapper(jo);
        Test.stopTest();
    }
    
    //For AWS
    @isTest static void IAFaultCodesMethod3(){
        Test.startTest();
        String ReqJSON = '{"Header":{"serviceName":"IACSSJobCreation","serviceVersion":"4.0","toolID":"GUIDANZ","targetID":"CSS","senderId":"rf671"},"DataArea":{"userLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","iasNumber":"IAS-261","woNumber":"","username":"oh559","psn":"79838572","serviceModelName":"ISX15 CM2350 X101","make":"KENWORTH","access":"B","model":"T660","ecmCode":"","productType":"","psbuPlant":"","psbuModel":"","psbuSpec":"","ert":"15255","customerName":"IA Cummins Customer1","complaintText":"Oil Leak Testing","prodMileage":"","prodMileageUnit":"","prodHours":"","woEnabled":"","severity":"","languageKey":"","FAULTLIST":[{"fc":"3563","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3567","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"1683","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2375","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2374","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""}],"PrioritizedData":[{"prifc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"EGR Orifice Pressure Sensor","rc1Likelihood":"64%","rootCause2":"Engine Wiring Harness","rc2Likelihood":"15%","rootCause3":"Electrical Connector","rc3Likelihood":"15%","rootCause4":"","rc4Likelihood":"","lbrprob1":"78","lbrprob2":"11","lbrprob3":"0","lbrprob4":"11","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""}]},{"prifc":"3714","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"","rc1Likelihood":"","rootCause2":"","rc2Likelihood":"","rootCause3":"","rc3Likelihood":"","rootCause4":"","rc4Likelihood":"","lbrprob1":"","lbrprob2":"","lbrprob3":"","lbrprob4":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""}]}],"UnPrioritizedData":[{"upfc":"1117","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","rc":"","ReasonCodeDescription":""}]}}';
        string ResJSON = '{"Header":{"toolId":"GUIDANZ","status":"Success","serviceVersion":"4.0","serviceName":"IACSSJobCreation","senderId":"rf671","returnCodeDescription":"CG01-Guidanz Job is created successfully"},"DataArea":{"woNumber":"CSS-00631677","iasNumber":"IAS-261"}}';
        CSS_DataExchange_Parent__c LstRef1 = new CSS_DataExchange_Parent__c();
        LstRef1.IAS_Number__c='IAS-260';
        LstRef1.MAKE__c='PETERBILT';
        LstRef1.MODEL__c='389';
        LstRef1.ACCESS__c='B';
        LstRef1.Status__c='Success';
        LstRef1.Request_JSON__c=ReqJSON;
        LstRef1.Response_JSON__c=ResJSON;
        LstRef1.TargetID__c='CSS';
        LstRef1.SenderID__c='OK152';
        LstRef1.ServiceName__c='GetLaborHrsData';
        LstRef1.CSS_Job_Number__c='59590';
        LstRef1.Complaint_Text__c='Oil Leak Testing12345';
        LstRef1.User_Location__c='7362332,44444-16402,56270-56255-P';
        insert LstRef1;
        system.debug('Rajesh-LstRef1==>'+LstRef1);
        
        CSS_IAFaultCodesController  IAFaultRef1 = new CSS_IAFaultCodesController();
        // IAFaultRef1.jobNumber = '12345';
        //IAFaultRef1.FaultCodeWrapper fw = new IAFaultRef1.FaultCodeWrapper();
        CSS_IAFaultCodesController.FaultCodeWrapper fcw = new CSS_IAFaultCodesController.FaultCodeWrapper();
        fcw.count = 2;
        fcw.fc = 'string';
        fcw.status = 'pass';
        fcw.relCodes = 'codes';
        fcw.formattedLastOccTime = 'time';
        fcw.lastOccTime = 2;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Roopa';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RoopaTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        jo.Request_JSON__c = ReqJSON;//'jsonnnn';
        jo.Response_JSON__c = ResJSON;//'jsonresponse';
        //JO.Name = '12345';
        insert jo;
        JO = [select id, Name from css_job_Order__c where id = : JO.id];
        system.debug('JO.Name**'+JO.Name);
        // CSS_Job_Order__c jo = CSS_TestData.createJobOrder(True);
        IAFaultRef1.jobNumber = JO.Name;

        IAFaultRef1.prepareFCsWrapperForAWS(jo);
        Test.stopTest();
    }
    
    
}