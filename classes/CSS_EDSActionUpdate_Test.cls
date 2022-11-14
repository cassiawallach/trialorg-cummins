@isTest
public class CSS_EDSActionUpdate_Test {
 @isTest static void testGetSelectSRT(){
        
        Test.setMock(HttpCalloutMock.class, new CSS_SelectAccSRT_Test());
        List<CSS_SRT__c> srtList = new List<CSS_SRT__c>(); 
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c cjb = new CSS_Job_Order__c();
        cjb.Customer_Name__c = 'Test SRT';
        cjb.DSID__c = 'DSBDT4760';
        cjb.Account__c=acc.id;
        insert cjb;
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.name = 'K81572426';
        sol.Solution_Title__c ='Engine control module (ECM) Calibration Revision History check';
        insert sol;
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.name = '19-361';
        srt.SRT_Title__c = 'Component Connector and Pin - Inspection, Each Four';
        srt.Job_Order__c = cjb.id;
        srt.Solution_Number__c = sol.id;
        insert srt;
        srtList.add(srt);
        CSS_ActionRequestWrapper wrap = new CSS_ActionRequestWrapper(srtList,cjb.DSID__c);
        CSS_EDSActionsUpdate.SelectAccessSRT(wrap);
    }
    @isTest static void testSelectComponents(){
        Test.setMock(HttpCalloutMock.class, new CSS_SelectCompo_Test());
        List<CSS_SRT__c> srtList = new List<CSS_SRT__c>(); 
        CSS_Job_Order__c cjb = new CSS_Job_Order__c();
        cjb.Customer_Name__c = 'Test SRT';
        cjb.DSID__c = 'DSBDT4760';
        insert cjb;
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.name = 'K81572426';
        sol.Solution_Title__c ='Engine control module (ECM) Calibration Revision History check';
        insert sol;
        List<CSS_Solution_Component__c> lstSolComp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Solutions__c = sol.id;
        solComp.Service_Job__c = cjb.id;
        solComp.name = 'ABC';
        insert solComp;
        lstSolComp.add(solComp);
        CSS_ComponentRequestWrapper compRe = new CSS_ComponentRequestWrapper(lstSolComp,cjb.DSID__c);
        CSS_EDSActionsUpdate.SelectComponents(compRe);
    }
    @isTest static void testInsiteFaultCode(){
        List<CSS_Fault_Code__c> fauCod = new List<CSS_Fault_Code__c>();
        Test.setMock(HttpCalloutMock.class, new CSS_InsiteFaultCode_Test());
        string dsid = 'DSBDT4760';
        CSS_Fault_Code__c fau = new CSS_Fault_Code__c();
        fau.name = '441';
        fau.Related_Fault_Code__c = '3385,2243';
        insert fau;
        fauCod.add(fau);
        CSS_Fault_Code__c fau1 = new CSS_Fault_Code__c();
        fau1.name = '441';
        fau1.Related_Fault_Code__c = '3385,2243';
        insert fau1;
        fauCod.add(fau1);
        CSS_Fault_Code__c fau2 = new CSS_Fault_Code__c();
        fau2.name = '441';
        fau2.Related_Fault_Code__c = '3385,2243';
        insert fau2;
        fauCod.add(fau2);
        CSS_Fault_Code__c fau3 = new CSS_Fault_Code__c();
        fau3.name = '441';
        fau3.Related_Fault_Code__c = '3385,2243';
        insert fau3;
        fauCod.add(fau3);
        CSS_Fault_Code__c fau4 = new CSS_Fault_Code__c();
        fau4.name = '441';
        fau4.Related_Fault_Code__c = '3385,2243';
        insert fau4;
        fauCod.add(fau4);
        CSS_Fault_Code__c fau5 = new CSS_Fault_Code__c();
        fau5.name = '441';
        fau5.Related_Fault_Code__c = '3385,2243';
        insert fau5;
        fauCod.add(fau5);
        
        CSS_EDSActionsUpdate.insiteFaultCodes(fauCod,dsid);
    }
    @isTest static void testOutofOrder(){
        Test.setMock(HttpCalloutMock.class, new CSS_OutofOrder_Test());
        List<CSS_Solutions__c> lstSol = new List<CSS_Solutions__c>();
        string dsid = 'DSBDT4760';
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.name = 'K81572426';
        sol.Solution_Title__c ='Engine control module (ECM) Calibration Revision History check';
        sol.Rank__c = 3;
        insert sol;
        lstSol.add(sol);
        CSS_EDSActionsUpdate.outOfOrderAck(lstSol,dsid);
    }
    @isTest static void testCaseViewed(){
        Test.setMock(HttpCalloutMock.class, new CSS_RepeatVisitAck_Test());
        string dsid = 'DSBDT4760';
        CSS_EDSActionsUpdate.caseViewed('K03070139', 1, dsid);
    }
    @isTest static void testRepeatVisit(){
        Test.setMock(HttpCalloutMock.class, new CSS_RepeatVisitAck_Test());
        string cNum = '123456';
        string dsid = 'DSBDT4760';
        CSS_EDSActionsUpdate.RepeatFlagAck(cNum,dsid);
    }
    @isTest static void testDiagCaseViewed(){
        Test.setMock(HttpCalloutMock.class, new CSS_RepeatVisitAck_Test());
        List<string> solAdd = new List<string>();
        solAdd.add(JSON.Serialize(new solWrapper('Most likely the solution','K24241010','Test','DSBDT7137')));
        CSS_EDSActionsUpdate.caseDiagStatusUpdate(solAdd);
    }
    @isTest static void testDiagCase(){
        Test.setMock(HttpCalloutMock.class, new CSS_RepeatVisitAck_Test());
        List<string> solAdd = new List<string>();
        solAdd.add(JSON.Serialize(new solWrapper('Not the solution','K24241010','Test','DSBDT7137')));
        CSS_EDSActionsUpdate.caseDiagStatusUpdate(solAdd);
    }
    @isTest static void testDiagCaseVie(){
        Test.setMock(HttpCalloutMock.class, new CSS_RepeatVisitAck_Test());
        List<string> solAdd = new List<string>();
        solAdd.add(JSON.Serialize(new solWrapper('Could not perform the solution verification','K24241010','Test','DSBDT7137')));
        CSS_EDSActionsUpdate.caseDiagStatusUpdate(solAdd);
    }
    @isTest static void testRepCaseViewed(){
        Test.setMock(HttpCalloutMock.class, new CSS_RepeatVisitAck_Test());
        List<string> solAdd = new List<string>();
        solAdd.add(JSON.Serialize(new solWrapper('Repair Successful.','K24241010','Test','DSBDT7137')));
        CSS_EDSActionsUpdate.caseRepStatusUpdate(solAdd);
    }
    @isTest static void testRepCase(){
        Test.setMock(HttpCalloutMock.class, new CSS_RepeatVisitAck_Test());
        List<string> solAdd = new List<string>();
        solAdd.add(JSON.Serialize(new solWrapper('Repair Successful with additional parts/procedures.','K24241010','Test','DSBDT7137')));
        CSS_EDSActionsUpdate.caseRepStatusUpdate(solAdd);
    }
    @isTest static void testRepCaseVie(){
        Test.setMock(HttpCalloutMock.class, new CSS_RepeatVisitAck_Test());
        List<string> solAdd = new List<string>();
        solAdd.add(JSON.Serialize(new solWrapper('Repair performed but didnot resolve the root cause.','K24241010','Test','DSBDT7137')));
        CSS_EDSActionsUpdate.caseRepStatusUpdate(solAdd);
    }
    @isTest static void testRepCaseView(){
        Test.setMock(HttpCalloutMock.class, new CSS_RepeatVisitAck_Test());
        List<string> solAdd = new List<string>();
        solAdd.add(JSON.Serialize(new solWrapper('Repair not performed.','K24241010','Test','DSBDT7137')));
        CSS_EDSActionsUpdate.caseRepStatusUpdate(solAdd);
    }
    public class solWrapper{
        public string solNum{get;set;}
        public string status{get;set;}
        public string comment{get;set;}
        public string dsid{get;set;}  
        public solWrapper(string status,string solNum,string comment,string dsid){
            this.solNum = solNum;
            this.status = status;
            this.comment = comment;
            this.dsid=dsid;
        }
    }
}