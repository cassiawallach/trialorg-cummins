/*************************************************************************
Name: FSLSolutionComponentsCls_Test
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
These is used for the display of the solution components Test class.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Vinod Yelala                4/19/2019                      
**************************************************************************/
@isTest
public class FSLSolutionComponentsCls_Test {
    static testMethod void testlogic1()
    {
        FSLTestDataSetupCls.createIntegrationConfigs(); 
        Account a = FSLTestDataSetupCls.createAccountData();
        Asset ast=FSLTestDataSetupCls.createAssetRecord();
        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a, st); 
        knowledge__kav knw=new knowledge__kav(urlname='testurl',title='testtitile');
        insert knw; 
        CSS_Solutions__c sol1 = new CSS_Solutions__c(FSL_Service_Job__c=wo.Id, Solution_Title__c='testSol',Solution__c='Solution1', FSL_Solution_Content__c=knw.id);
        insert sol1;
        Test.startTest();
        FSL_Component__c fscmp = new FSL_Component__c(name='F19000170',Component_ID__c='F19000170',Knowledge__c=knw.id);
        insert fscmp;
        //Test.startTest();
        FSLSolutionComponentsCls.getSolComps(sol1.id,knw.UrlName,wo.id);
        CSS_Solutions__c sol = new CSS_Solutions__c(Solution_Title__c='testSol',Solution__c='Solution1',FSL_Service_Job__c=wo.Id, FSL_Solution_Content__c=knw.id);
        insert sol;
        CSS_Solution_Component__c solcmp = new CSS_Solution_Component__c(Solutions__c=sol.id, Fault_Code__c='test123');
        insert solcmp;
        //CSS_Parts_Options__c solpart= new CSS_Parts_Options__c(Solutions__c=sol.id, FailurepartId__c=solcmp.id);
        insert new FSL_Parts__c(Solution__c = sol.id, CSS_Solution_Component__c = solcmp.id, Service_Order__c=wo.Id);
        //solpart1.add(new FSL_Parts__c(Solution__c = csol1.id, CSS_Solution_Component__c = solcmps1[0].id,Service_Order__c=wo.Id));
        //insert solpart;
        FSLSolutionComponentsCls.getSolComps(sol.id, knw.urlname,wo.id);
        FSLSolutionComponentsCls.getRepairReasonLOVs();
        FSLSolutionComponentsCls.getCustParts(wo.Id);
        FSLSolutionComponentsCls.getFailures(sol.id);
        Test.stopTest();
    }
    
     static testMethod void CG_WS_MuleCatchMethod() {
        HttpRequest req =null;
        
        CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
        reqWrapper.jsonReqBody = null;//'{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        reqWrapper.methodType = 'POST';
        reqWrapper.timeOut = 1;
        reqWrapper.serviceName = null;//'Mule Auth Token';
       // CG_CL_HttpRequestMock mock1 = new CG_CL_HttpRequestMock(null,'complete',reqWrapper.jsonReqBody,null);
        //CG_WS_Mule.calloutGeneric(reqWrapper);
       // CG_WS_Mule.calloutGenericMule(reqWrapper);
        FSLGetPartsListSRTIntegrationHelper.calloutGenericMuleNamedCred(reqWrapper);
        //CG_WS_Mule.getAccessToken('','');
    }
    
    static testMethod void testGetFailure()
    {
        Test.startTest();
        
        Account a = FSLTestDataSetupCls.createAccountData();
        Asset ast=FSLTestDataSetupCls.createAssetRecord();
        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a, st); 
        CSS_Solutions__c sol = new CSS_Solutions__c(Solution_Title__c='testSol',Solution__c='Solution1',FSL_Service_Job__c=wo.Id);
        insert sol;
        
        CSS_Solution_Component__c solcmp = new CSS_Solution_Component__c(Solutions__c=sol.id, Fault_Code__c='test123');
        insert solcmp;
        
        FSL_Fail_Mode__c failmodel = new FSL_Fail_Mode__c(name='failmode');
        insert failmodel;
        
        FSL_Failure__c fsfls = new FSL_Failure__c(Name='testf',Component_Code__c='123' ,System_Code__c='123',Failure_Name__c='32e');
        insert fsfls;
        //added comment as part of deployment
        FSLSolutionComponentsCls.getfailurename(fsfls.id ,failmodel.id , sol.Id, null, null, wo.id);
        String Json = '{"DataArea":{"Details":[{"Status":"Approved","CampaignStartDate":"2018-02-02","FailCode":"WSNF","SrtList":[{"SrtCode":"00-901-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"},{"SrtCode":"00-902-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Road Repairs)"},{"SrtCode":"13-004-00","SrtDescription":"Starting Motor - Remove and Install, One (Common Rail Fuel System)"},{"SrtCode":"13-104-00","SrtDescription":"Starting Motor - Remove and Install, Each"},{"SrtCode":"99-902-00","SrtDescription":"Non SRT details- Campaign/TRP/ATC-0.1Hr"}],"MultipleTimes":"N","CampaignDesc":"ISB6.7 EURO5, QSB6.7 TIER3 TERBERG STARTER TRP","FailMode":"WN","InShopSrtLimitFlag":"N","CompleteIndicator":"N","CampaignNumber":1982,"BusinessUnit":"CMI","CampaignEndDate":"2020-02-28","PartList":[{"PartNumber":"499670900","PartDescription":"MOTOR,STARTING","PartQuantity":1}],"CampaignType":"TRP"}]},"Header":{"Status":"Success"}}';
        FSL_GETCampaignServiceswrapper obj = FSL_GETCampaignServiceswrapper.parse(Json);
        Test.stopTest();
    }
    static testMethod void testgetCustParts() {
         Test.startTest();
       	 Account a = FSLTestDataSetupCls.createAccountData();
         Asset ast=FSLTestDataSetupCls.createAssetRecord();
         ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
         Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a, st); 
         FSLAddCustPartsCls.getCSSParts(wo.Id);
        Test.stopTest();
            
        
    }
}