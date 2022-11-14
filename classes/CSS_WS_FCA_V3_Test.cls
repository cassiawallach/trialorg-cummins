@isTest

public class CSS_WS_FCA_V3_Test {
    
        static TestMethod void testprepareReqJSONForProitizedFCsServiceOfFCA(){
        CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex res = new CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex();
        
        
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2();     
        req.Header = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.Header();
        req.DataArea = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.DataArea();
        req.DataArea.faultlist = new List<CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.FAULTLIST>();            
        req.header.ServiceName = 'GetPrioritizedFC';
        req.header.ServiceVersion = '1.0';
        req.header.ToolID = 'ATLASMOBILE';
        req.header.SenderID = 'nt321';
        req.header.TargetID = 'CSS';        
        req.DataArea.PSN = '79634249';
        req.DataArea.SERVICEMODELNAME = 'ISX15 CM2350 X101';
        req.DataArea.ERT = '0';
        req.DataArea.MAKE = 'FREIGHTLINER';
        req.DataArea.MODEL = 'CASCADIA';
        req.DataArea.ACCESS = '';
        list<CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.FAULTLIST> fclist = new list<CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.FAULTLIST>();        
        //create 1st fault code
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.FAULTLIST fc1 = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.FAULTLIST();        
        fc1.fc = '1117';
        fc1.occurenceTime = 21319736;
        fc1.status = 'inactive';
        fc1.count = 1;
        //add failt code to faultcode list
        fclist.add(fc1);        
        
        //create 2nd fault code
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.FAULTLIST fc2 = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.FAULTLIST();        
        fc2.fc = '1682';
        fc2.occurenceTime = 21530503;
        fc2.status = 'active';
        fc2.count = 1;
        
        //add failt code to faultcode list
        fclist.add(fc2);      
        
        //create 3rd fault code
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.FAULTLIST fc3 = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.FAULTLIST();        
        fc3.fc = '1682';
        fc3.occurenceTime = 21530503;
        fc3.status = 'active';
        fc3.count = 1;
        
        //add failt code to faultcode list
        fclist.add(fc3);                   
        req.DataArea.faultList = fclist;   
        
        String token = 'https://connectedsolutions-stg.cummins.com/fca/getFaultPrioritization/';
        
        Test.startTest();        
        res = CSS_WS_FCA_V2.prepareReqJSONForProitizedFCsServiceOfFCA(req,token);        
        Test.stopTest();
        
    }

}