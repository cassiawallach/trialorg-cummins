@isTest
public class CG_BL_BMS_Test {//test
    //Bharat Testing GitLab
    //Adding test comment - 10/26/2018
    //Gitlab testing session
    public static testmethod void fetchBMSCustomerDetails() {
        
        Test.startTest();
          CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.Name = 'BMSPrivateSRTs';
            conDetails.AuthEnv__c = 'OAGOAUTH';
            conDetails.ApplicationName__c = 'BMSPrivateSRTs';
            conDetails.End_Point__c = 'https://services-stg.cummins.com/css/BMSPrivateSRTs';
            conDetails.Method_Type__c = 'POST';
            conDetails.Timeout__c = 2.0;
            insert conDetails;
             Test.setMock(HttpCalloutMock.class, new CG_OP_BMSPrivateSRTsResJSON_Mock());
        CG_OP_OAGWrapper oag = CG_BL_BMS.fetchBMSCustomerDetails('BMS', '3742', 'BMS');
        Test.stopTest();
    }
    
    public static testmethod void createBMSAccount() {
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new CG_OP_BMSPrivateSRTsResJSON_Mock());
        CG_OP_OAGWrapper cbMSaccount = CG_BL_BMS.createBMSAccount('BMS', 'Sterling road', 'Point Road', 'Rich street', '34752', '7867564534', 'Calgary', 'Alberta', '56453', '0452', '0786786754', 'CA', 'Eng', 'Appointment', '85660-85670');
        Test.stopTest();
    }
    
    public static testmethod void getMISCChargeLOVs() {
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new CG_OP_BMSPrivateSRTsResJSON_Mock());
        CG_OP_OAGWrapper misc = CG_BL_BMS.getMISCChargeLOVs('BMS', '3742', 'BMS');
        Test.stopTest();
    }
    
    public static testmethod void Test_DeleteBMSJob() {
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new CG_OP_BMSPrivateSRTsResJSON_Mock());
        CG_OP_OAGWrapper DelBMS = CG_BL_BMS.deleteBMSJob('CSS-00074718','56270-56255','WOQT','WOQT','','Cancelled');
        Test.stopTest();
    }
    
    /* public static testmethod void Test_sendFailurecode() {
      Test.startTest();
      CSS_Solution_Component__c SC=new CSS_Solution_Component__c();
        SC.Name ='12131313';
        SC.system_code__c='testSC';
        SC.Component_Code__c='TestCC';  
        SC.Failure_Mode__c='TestFM';
        SC.Claim_Type__c='TestCT';
        SC.Create_User__c='Karthik';
        SC.Change_User__c='Karthik';
        Insert SC;
    List<CSS_Solution_Component__c> FailuresList=new List<CSS_Solution_Component__c>();
        FailuresList.Add(SC);
    CG_OP_OAGWrapper sendFailurecode =  CG_BL_BMS.sendFailurecode('56270-56255','CSS-00074718','WOQT','WOQT','','Test','2424',FailuresList);
    Test.stopTest();
    }*/
    
    public static testmethod void testForGetBMSPrivateSRTsMethod(){
        Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test2());
        user u = CSS_TestData.createTestUser(false);
        u.User_Location__c='56230-56230';
        u.Username='TestUser3@cummins.com';
        u.Email='TestUser3@cummins.com';
        
        insert u;
        system.runAs(u)
        {
            css_job_order__c wo = new css_job_order__c();
            wo.Customer_Name__c='TestUser3';
            wo.Customer_Code__c='123';
            wo.ESN__c='58762320';
            wo.CSS_Job_Location_Code__c='56230-56230';
            WO.Qsol_Engine_Family_Code__c='10';
            WO.AccessCode__c='C';
            insert wo;
            
            /*css_job_order__c wo3 = new css_job_order__c();
            wo3.Customer_Name__c='TestUser3';
            wo3.Customer_Code__c='123';
            wo3.ESN__c='58762320';
            wo3.CSS_Job_Location_Code__c='56230-56230';
            WO3.Qsol_Engine_Family_Code__c='10';
            WO3.AccessCode__c='D';
            insert wo3;*/
            
            css_job_order__c wo2 =[Select Id,Creator_Location__c,Qsol_Engine_Family_Code__c,AccessCode__c from CSS_Job_Order__c limit 1];
            CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'BMSPrivateSRTs';
        csInt.ApplicationName__c='BMSPrivateSRTs';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/standardrepairstime/private';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='GET';
        insert csInt;
            test.startTest();
             //Test.setMock(HttpCalloutMock.class, new CG_OP_BMSPrivateSRTsResJSON_Mock());CG_SL_BMSMock_Test2
            //Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test2());
            CG_BL_BMS bm = new CG_BL_BMS();
            CG_BL_BMS.getBMSPrivateSRTs(wo.id);
            test.stopTest();
        }
    }
     public static testmethod void testForGetBMSPrivateSRTsMethod1(){
         Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test2());
        user u = CSS_TestData.createTestUser(false);
        u.User_Location__c='56230-56230';
        u.Username='TestUser3@cummins.com';
        u.Email='TestUser3@cummins.com';
        
        insert u;
        system.runAs(u)
        {
          
            
           
            CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'BMSPrivateSRTs';
        csInt.ApplicationName__c='BMSPrivateSRTs';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/standardrepairstime/private';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='GET';
        insert csint;
            
            test.startTest();
             //Test.setMock(HttpCalloutMock.class, new CG_OP_BMSPrivateSRTsResJSON_Mock());
            //Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test2());
            CG_BL_BMS bm = new CG_BL_BMS();
            CG_BL_BMS.getBMSPrivateSRTs(null);
            test.stopTest();
        }
    }
    
    public static testmethod void testForAccessCodeR(){
        Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test2());
        user u1 = CSS_TestData.createTestUser(true);
        u1.User_Location__c='56230-56230';
        //u1.Username='TestUSer2@cummins.com';
        //u1.Email='TestUser2@cummins.com';
        
        update u1;
        system.runAs(u1)
        {
            css_job_order__c wo1 = new css_job_order__c();
            wo1.Customer_Name__c='TestUser2';
            wo1.Customer_Code__c='123';
            wo1.ESN__c='58762320';
            wo1.CSS_Job_Location_Code__c='56230-56230';
            WO1.Qsol_Engine_Family_Code__c='10';
            WO1.AccessCode__c='R';
            upsert wo1;
            css_job_order__c wo3 =[Select Id,Creator_Location__c,Qsol_Engine_Family_Code__c,AccessCode__c from CSS_Job_Order__c limit 10];
            CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'BMSPrivateSRTs';
        csInt.ApplicationName__c='BMSPrivateSRTs';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/standardrepairstime/private';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='GET';
        insert csint;
            //Test.setMock(HttpCalloutMock.class, new CG_OP_BMSPrivateSRTsResJSON_Mock());
            
            test.startTest();
            // Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test2());
            CG_BL_BMS bm = new CG_BL_BMS();
            CG_BL_BMS.getBMSPrivateSRTs(wo3.id);
            test.stopTest();
        }
    }
    
}