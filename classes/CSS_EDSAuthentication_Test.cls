@isTest
public class CSS_EDSAuthentication_Test {
    static CSS_EDSAuthentication ext;
    static CSS_Job_Order__c JO;
    static PageReference pref; 
    private static void init() {
        //CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.DSID__c = 'DSBDT4082'; 
        insert(JO);
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string  edsUsername = conDetails.Username__c; //"scharette';
        string edsPassword = conDetails.Passcode__c;
        Test.setCurrentPage(pref);
        //ApexPages.StandardController con = new ApexPages.StandardController(JO);
        ext = new CSS_EDSAuthentication(); 
        CSS_EDSAuthentication.workJob = JO;
    }
    @isTest  static void testgetgenerateToken() {         
        string userGroup='ADMIN';
        string userName='edstestuser1';
        Blob key = Crypto.generateAesKey(128);
        string passPhrase = 'wEC38PruRaSw.bEm';
        Blob secretKey = Blob.valueOf(passPhrase);
        Blob tokenString = Blob.valueOf(CSS_EDSAuthentication.getToken(userName,userGroup)); 
        Blob encryptedStr = Crypto.encrypt('AES128',secretkey,secretKey,tokenString);       
        String encryptedKey = EncodingUtil.base64Encode(encryptedStr);
        String output = CSS_EDSAuthentication.getgenerateToken();  
    }
    @isTest static void testESNHistory(){
        Test.setMock(HttpCalloutMock.class, new CSS_ESNHistory_Test());
        CSS_Job_Order__c cjb = new CSS_Job_Order__c();
        cjb.ESN__c = '73676187';
        insert cjb;
        CSS_EDSAuthentication.getESNHistory(cjb.id, cjb.esn__c,'en');
    }
    @isTest static void testUpdateDSID(){
        Test.setMock(HttpCalloutMock.class, new CSS_UpdateDSID_Test());
        string fedid = 'edstestuser1';
        CSS_Job_Order__c cjb = new CSS_Job_Order__c();
        cjb.DSID__c = 'DSBDT4760';
        cjb.ESN__c = '79464646';
        cjb.Shop_Work_Order__c = 'Test';
        cjb.customer_name__c = 'test eds';
        cjb.Unit_Number__c = '1234';
        cjb.make__c = 'Test';
        cjb.model__c = 'Test';
        cjb.Equipment_ID__c = 'EQ7667';
        cjb.AccessCode__c = 'A';
        cjb.Failure_Point__c = 1000;
        cjb.Failure_Point_Measure__c = 'Hours';
        insert cjb;
        CSS_EDSAuthentication.getEDSUpdate(cjb.dsid__c,fedid,cjb.customer_name__c,cjb.make__c,cjb.model__c,cjb.AccessCode__c,cjb.Equipment_ID__c,cjb.Failure_Point__c,cjb.Failure_Point_Measure__c,cjb.Unit_Number__c,cjb.ESN__c,cjb.Shop_Work_Order__c);        
        CSS_EDSAuthentication.getTCUpdate(cjb.dsid__c,fedid,cjb.customer_name__c,cjb.make__c,cjb.model__c,cjb.AccessCode__c,cjb.Equipment_ID__c,cjb.Failure_Point__c,cjb.Failure_Point_Measure__c,cjb.Unit_Number__c,cjb.ESN__c,cjb.Shop_Work_Order__c);
    }
    @isTest static void testdetailsDSID(){
        Test.setMock(HttpCalloutMock.class, new CSS_DetailsDsid_Test());
        CSS_EDSAuthentication.detailsDSID('DSBDT4730','en');        
    }
    @isTest static void testUpdateDSI(){
        Test.setMock(HttpCalloutMock.class, new CSS_UpdateDSID_Test());
        string fedid = 'edstestuser1';
        CSS_Job_Order__c cjb = new CSS_Job_Order__c();
        cjb.DSID__c = 'DSBDT4760';
        cjb.ESN__c = '79464646';
        cjb.Shop_Work_Order__c = 'Test';
        cjb.customer_name__c = 'test eds';
        cjb.Unit_Number__c = '1234';
        cjb.make__c = 'Test';
        cjb.model__c = 'Test';
        cjb.Equipment_ID__c = 'EQ7667';
        cjb.AccessCode__c = 'A';
        cjb.Failure_Point__c = 0.1000;
        cjb.Failure_Point_Measure__c = 'Miles';
        insert cjb;
        CSS_EDSAuthentication.getEDSUpdate(cjb.dsid__c,fedid,cjb.customer_name__c,cjb.make__c,cjb.model__c,cjb.AccessCode__c,cjb.Equipment_ID__c,cjb.Failure_Point__c,cjb.Failure_Point_Measure__c,cjb.Unit_Number__c,cjb.ESN__c,cjb.Shop_Work_Order__c);        
    }
    @isTest static void testUpdateDS(){
        Test.setMock(HttpCalloutMock.class, new CSS_UpdateDSID_Test());
        string fedid = 'edstestuser1';
        CSS_Job_Order__c cjb = new CSS_Job_Order__c();
        cjb.DSID__c = 'DSBDT4760';
        cjb.ESN__c = '79464646';
        cjb.Shop_Work_Order__c = 'Test';
        cjb.customer_name__c = 'test eds';
        cjb.Unit_Number__c = '1234';
        cjb.make__c = 'Test';
        cjb.model__c = 'Test';
        cjb.Equipment_ID__c = 'EQ7667';
        cjb.AccessCode__c = 'A';
        cjb.Failure_Point__c = 0.1000;
        cjb.Failure_Point_Measure__c = 'Kilometers';
        insert cjb;
        CSS_EDSAuthentication.getEDSUpdate(cjb.dsid__c,fedid,cjb.customer_name__c,cjb.make__c,cjb.model__c,cjb.AccessCode__c,cjb.Equipment_ID__c,cjb.Failure_Point__c,cjb.Failure_Point_Measure__c,cjb.Unit_Number__c,cjb.ESN__c,cjb.Shop_Work_Order__c);        
    }
    @isTest static void testCreateDSID(){
        Test.setMock(HttpCalloutMock.class, new CSS_CreateDSID_Test());
     CSS_EDSAuthentication.getDSID('test','null','null','null',0.1,'null','null','null','null','null','null','null','test');      
    }
    /* @isTest static void testCreateDSI(){
Test.setMock(HttpCalloutMock.class, new CSS_CreateDS_Test());
CSS_EDSAuthentication.getDSID('79464646',null,null,0,'Miles',null,null,null,'nt861',null,null,null);        
}*/
    @isTest static void testCreateDS(){
        Test.setMock(HttpCalloutMock.class, new CSS_CreateDSID_Test());
      CSS_EDSAuthentication.getDSID('test','null','null','null',0.1,'null','null','null','null','null','null','null','test');        
    }
    @isTest static void testCreateD(){
        Test.setMock(HttpCalloutMock.class, new CSS_CreateDSID_Test());
     CSS_EDSAuthentication.getDSID('test','null','null','null',0.1,'null','null','null','null','null','null','null','test');      
    }
    @isTest static void testSymptomFCDSID(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomFCSearch_Test());
        CSS_EDSAuthentication.getFCSympSearch('123','null','null','null',0.1,'Miles','null','null','null','null','null','null','DSBDT4780','en','O');        
    }
    @isTest static void testSymptomFCDSI(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomFCSearch_Test());
        CSS_EDSAuthentication.getFCSympSearch('123','null','null','null',0.1,'Hours','null','null','null','null','null','null','DSBDT4780','en','O');        
    }
    @isTest static void testSymptomFCD(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomFCSearch_Test());
        CSS_EDSAuthentication.getFCSympSearch('123','null','null','null',0.1,'Hours','null','null','null','null','null','null','DSBDT4780','en','N');        
    }
    @isTest static void testSymptomFCDS(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomFCSearch_Test());
        CSS_EDSAuthentication.getFCSympSearch('123','null','null','null',0.1,'Kilometers','null','null','null','null','null','null','DSBDT4780','en','O');        
    }
    @isTest static void testGetPrevious(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetPreviousQues_Test());
        CSS_EDSAuthentication.getPreviousQues('DSBDT4780',1,'en','O');        
    }
    @isTest static void testGetPreviou(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetPreviousQuesSec_Test());
        CSS_EDSAuthentication.getPreviousQues('DSBDT4780',1,'en','N');        
    }
    @isTest static void testSymptomDSID(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomSearch_Test());
        CSS_EDSAuthentication.getSymptomSearch('smoke','null','null','null',0.1,'Miles','null','null','null','null','null','null','DSBDT4780','en','O');        
    }
    @isTest static void testSymptomDSIDSec(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomSearchSec_Test());
         CSS_EDSAuthentication.getSymptomSearch('smoke','null','null','null',0.1,'Miles','null','null','null','null','null','null','DSBDT4780','en','O');        
    }
    @isTest static void testSymptomDSIDThi(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomSearchThi_Test());
         CSS_EDSAuthentication.getSymptomSearch('smoke','null','null','null',0.1,'Miles','null','null','null','null','null','null','DSBDT4780','en','O');        
    }
    @isTest static void testSymptomD(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomSearch_Test());
        CSS_EDSAuthentication.getSymptomSearch('smoke','null','null','null',0.1,'Miles','null','null','null','null','null','null','DSBDT4780','en','O');        
    }
    @isTest static void testSymptomDSI(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomSearch_Test());
         CSS_EDSAuthentication.getSymptomSearch('smoke','null','null','null',0.1,'Miles','null','null','null','null','null','null','DSBDT4780','en','O');        
    }
    @isTest static void testSymptomDS(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomSearch_Test());
         CSS_EDSAuthentication.getSymptomSearch('smoke','null','null','null',0.1,'Miles','null','null','null','null','null','null','DSBDT4780','en','O');      
    }
    @isTest static void testSolution(){
        init();
        List<CSS_Fault_Code__c> faulCod = new List<CSS_Fault_Code__c>();
       
        Map<id,id> jobOrder = new Map<id,id>();
        //List<id> jobOrder = new List<id>{'a093B000000nsxU'};
        CSS_Fault_Code__c faultCode = new CSS_Fault_Code__c();
        faultCode.Name = '123';
        faultCode.Job_Order__c = JO.id;
        insert faultCode;
        CSS_Fault_Code__c faultCode1 = new CSS_Fault_Code__c();
        faultCode1.Name = '123';
        faultCode1.Job_Order__c = JO.id;
        insert faultCode1;
        jobOrder.put(faultCode.id,faultCode1.id);
        
        Map<ID,String> fCCode = new Map<ID,String>();
        CSS_Fault_Code__c faultCodeObj = new CSS_Fault_Code__c();
        faultCodeObj.Name = '123';
        faultCodeObj.Job_Order__c = JO.id;
        insert faultCodeObj;
        fCCode.put(faultCodeObj.id,'TestData');
        
        CSS_Job_Order__c cjb = new CSS_Job_Order__c();
        cjb.DSID__c = 'DSBDT4760';
        cjb.ESN__c = '79464646';
        cjb.Shop_Work_Order__c = 'Test';
        cjb.customer_name__c = 'test eds';
        cjb.Unit_Number__c = '1234';
        cjb.make__c = 'Test';
        cjb.model__c = 'Test';
        cjb.Equipment_ID__c = 'EQ7667';
        cjb.AccessCode__c = 'A';
        cjb.Failure_Point__c = 1000;
        cjb.Failure_Point_Measure__c = 'Hours';
        insert cjb;
        
        List<CSS_Solutions__c>solLst = new List<CSS_Solutions__c>();
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.FaultCode__c = faultCodeObj.Id;
        sol.Service_Job__c = cjb.Id;
        sol.Name = 'Sample Case Name';
        sol.Case_Name__c = 'Sample Case Name';
        sol.Solution_Title__c = 'Sample Title';
        sol.Rank__c =0;
        //sol.Unique_Solution__c = 'DataTest';
        insert sol;
        
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.FaultCode__c = faultCodeObj.Id;
        sol1.Service_Job__c = cjb.Id;
        sol1.Name = 'Sample Case Name';
        sol1.Case_Name__c = 'Sample Case Name';
        sol1.Solution_Title__c = 'Sample Title';
        sol1.Rank__c =0;
        //sol1.Unique_Solution__c = 'DataTest';
        insert sol1; 
        
        solLst.add(sol);
        solLst.add(sol1);
        
        upsert solLst; 
        
        Test.setMock(HttpCalloutMock.class, new CSS_Solutions_Test());
        
        CSS_EDSAuthentication.getFaultCodeSearch(jobOrder,fCCode,'dsi','lang',cjb);        
    }
    
    @isTest static void testExitDSID(){
        Test.setMock(HttpCalloutMock.class, new CSS_Exit_Test());
        CSS_EDSAuthentication.exitDSID('1234-5678','DSBDT4780');        
    }
    @isTest static void testGetQues(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        //List<string> ansID = new List<string>{'18313#8527'};
        string ansRadio = '18313#8529';
        string ques ='10%2336366';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getQues(null,'ansRadio','ques','dsid','en','O');        
    }
    @isTest static void testGetQuesClarifying(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        //List<string> ansID = new List<string>{'18313#8527'};
        string ansRadio = '18313#8529';
        string ques =null;
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getQues(null,'ansRadio','ques','dsid','en','O');        
    }
    @isTest static void testGetQu(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        //List<string> ansID = new List<string>{'18313#8527'};
        string ansRadio = '18313#8529';
        string ques ='10%2336366';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getQues(null,'ansRadio','ques','dsid','en','N');        
    }
    
      @isTest static void testGetQuone(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Testone());
        List<string> ansID = new List<string>{'18313#8527'};
        string ansRadio = null;
        string ques ='10%2336366';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getQues(ansID,'ansRadio','ques','dsid','en','N');        
   }
    
     
      @isTest static void testGetQutwos(){
            Test.setMock(HttpCalloutMock.class, new CSS_GetQuesTwo_Test());
        List<string> ansID = new List<string>{'18313#8527'};
        string ansRadio = null;
        string ques ='10%2336366';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getQues(ansID,'ansRadio','ques','dsid','en','N');        
   }
    
       @isTest static void testGetQuotwo(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        List<string> ansID = new List<string>{'18313#8527'};
        string ansRadio = null;
        string ques ='10%2336366';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getQues(ansID,'ansRadio','ques','dsid','en','N');        
   }
    
    
    
    @isTest static void testGetSolutionDetails(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSolDetails_Test());
        string caseNum = 'K21484443';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getSolutionDetails('caseNum','dsid','en',0,'O');        
    }
    @isTest static void testGetSolutionDeta(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSolDetails_Test());
        string caseNum = 'K21484443';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getSolutionDetails('caseNum','dsid','en',0,'N');        
    }
    @isTest static void testGetNextQues(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        string textSear = 'white smoke';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getNextQues('textSear','dsid','en','O');        
    }
    @isTest static void testGetNextQuesSec(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetPreviousQuesSec_Test());
        string textSear = 'white smoke';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getNextQues('textSear','dsid','en','O');        
    }
    @isTest static void testGetNextQu(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        string textSear = 'white smoke';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getNextQues('textSear','dsid','en','N');        
    }
      @isTest static void testGetNextQuone(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Testone());
        string textSear = 'white smoke';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getNextQues('textSear','dsid','en','N');        
    }
    
    
    
       @isTest static void testGetNextQutwo(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetQuesTwo_Test());
        string textSear = 'white smoke';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getNextQues('textSear','dsid','en','N');       
    }
    
        @isTest static void testGetNextQuthree(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetQuesThree_Test());
        string textSear = 'white smoke';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getNextQues('textSear','dsid','en','N');       
    }
    
    
    @IsTest static void testGetReportProblem(){
        Test.setMock(HttpCalloutMock.class, new CSS_ReportProblem_Test());
        string caseNum = 'K53992470';
        string dsid = 'DSBDT6091';
        CSS_EDSAuthentication.reportProblem('dsid','caseNum','Testing'); 
    }
    
    @isTest static void testgetDsidclose(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSolDetails_Test());
        string caseNum = 'K21484443';
        string dsid = 'DSBDT4780';
        CSS_EDSAuthentication.getDsidclose('testFeDBack','testWordGrp','caseNum','en','dsid');        
    }
    
    @isTest static void testgetEDSUpdateTnR(){
        Test.setMock(HttpCalloutMock.class, new CSS_UpdateDSID_Test());
        string fedid = 'edstestuser1';
        CSS_Job_Order__c cjb = new CSS_Job_Order__c();
        cjb.DSID__c = 'DSBDT4760';
        cjb.ESN__c = '79464646';
        cjb.Shop_Work_Order__c = 'Test';
        cjb.customer_name__c = 'test eds';
        cjb.Unit_Number__c = '1234';
        cjb.make__c = 'Test';
        cjb.model__c = 'Test';
        cjb.Equipment_ID__c = 'EQ7667';
        cjb.AccessCode__c = 'A';
        cjb.Failure_Point__c = 0.1000;
        cjb.Failure_Point_Measure__c = 'Hours';
        insert cjb;
        CSS_EDSAuthentication.getEDSUpdateTnR(cjb.dsid__c,fedid,cjb.customer_name__c,cjb.make__c,cjb.model__c,cjb.AccessCode__c,cjb.Equipment_ID__c,cjb.Failure_Point__c,cjb.Failure_Point_Measure__c,cjb.Unit_Number__c,cjb.ESN__c,cjb.Shop_Work_Order__c);        
    }
    @isTest static void testESNHistorySecond(){
        Test.setMock(HttpCalloutMock.class, new CSS_UpdateDSID_Test());
        CSS_Job_Order__c cjb = new CSS_Job_Order__c();
        cjb.ESN__c = '73676187';
        insert cjb;
        CSS_EDSAuthentication.getESNHistory(cjb.id, cjb.esn__c,'en');
    }
    @isTest static void testUpdate(){
        Test.setMock(HttpCalloutMock.class, new CSS_GetSolDetails_Test());
        string fedid = 'edstestuser1';
        CSS_Job_Order__c cjb = new CSS_Job_Order__c();
        cjb.DSID__c = 'DSBDT4760';
        cjb.ESN__c = '79464646';
        cjb.Shop_Work_Order__c = 'Test';
        cjb.customer_name__c = 'test eds';
        cjb.Unit_Number__c = '1234';
        cjb.make__c = 'Test';
        cjb.model__c = 'Test';
        cjb.Equipment_ID__c = 'EQ7667';
        cjb.AccessCode__c = 'A';
        cjb.Failure_Point__c = 0.1000;
        cjb.Failure_Point_Measure__c = 'Miles';
        insert cjb;
        CSS_EDSAuthentication.getEDSUpdate(cjb.dsid__c,fedid,cjb.customer_name__c,cjb.make__c,cjb.model__c,cjb.AccessCode__c,cjb.Equipment_ID__c,cjb.Failure_Point__c,cjb.Failure_Point_Measure__c,cjb.Unit_Number__c,cjb.ESN__c,cjb.Shop_Work_Order__c);        
    }
    @isTest static void testWrapper(){
        CSS_EDSAuthentication.faultCodeID fcWrap = new CSS_EDSAuthentication.faultCodeID('a','b','c','d',1);
    }
    
    @isTest static void CSS_EDSAuthentication1() {
init();
        //CSS_EDSAuthentication eds = new CSS_EDSAuthentication();
        CSS_EDSAuthentication.getESNHistory(JO.id, '', '');
        CSS_EDSAuthentication.detailsDSID('null','null');
        CSS_EDSAuthentication.getPreviousQues('null',3,'null','null');
        CSS_EDSAuthentication.getDSID('test','null','null','null',0.1,'null','null','null','null','null','null','null','test');
        //string s = 'test';
        CSS_EDSAuthentication.faultCodeID f = new CSS_EDSAuthentication.faultCodeID('null','null','null','null',null); 
        CSS_EDSAuthentication.ansChoice ans = new CSS_EDSAuthentication.ansChoice('','');
        CSS_EDSAuthentication.solutionEDS soln = new CSS_EDSAuthentication.solutionEDS('','',1);
        
    }
     @isTest static void CSS_EDSAuthentication2() {
        CSS_EDSAuthentication.getESNHistory(null, '', '');
        CSS_EDSAuthentication.detailsDSID('null','null');
        CSS_EDSAuthentication.getPreviousQues('null',3,'null','null');
        CSS_EDSAuthentication.getDSID('test','null','null','null',0.1,'null','null','null','null','null','null','null','test');
        //string s = 'test';
        CSS_EDSAuthentication.faultCodeID f = new CSS_EDSAuthentication.faultCodeID('null','null','null','null',null); 
        CSS_EDSAuthentication.ansChoice ans = new CSS_EDSAuthentication.ansChoice('','');
        CSS_EDSAuthentication.solutionEDS soln = new CSS_EDSAuthentication.solutionEDS('','',1);
        
    }
}