@isTest(SeeAllData=true)
public class CSS_QSol_V1_Test {
    static testMethod void test(){
        system.runAs(new user(id = userinfo.getUserId())){
            CSS_QSol_V1 qsol = new CSS_QSol_V1();
            CSS_CampTsbTrp__c ct = new CSS_CampTsbTrp__c();
            ct.name = 'CAM';
            ct.name = 'TRP';
            ct.name = 'TSB';
            CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();        
            jobOrder.ESN__c = '73695829';
            jobOrder.ESN_Insite__c = '73007222';
            jobOrder.DSID__c = 'DSBDT5664';
            jobOrder.DSID_WorkGroup__c = '1234' ;
            //jobOrder.INSITE_UpdateTimeStamp__c = '6/15/2016 10:17 AM';
            jobOrder.Status__c = 'Triage & Diagnosis' ;
            jobOrder.Previous_Status__c = 'Review' ;
            jobOrder.INSITE_ESN_Choice__c = 'Keep Typed ESN';
            insert jobOrder;
            
            list<CSS_CampTsbTrp__c> solutionList = new list<CSS_CampTsbTrp__c>();
            CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c( Doc_Num__c='TSB140168',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                             Type__c='CAM',Doc_Title__c='xyz' ,Performed__c= false,
                                                             Performed_Review__c= false,Reviewed__c= true , esn__c = 'Test6');
            solutionList.add(solRec);
            CSS_CampTsbTrp__c solRec2 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB14013368',URL__c='https://qsolpilot.cummins.com/qs9/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                              Type__c='TRP',Doc_Title__c='xyz' ,Performed__c= false,
                                                              Performed_Review__c= true,Reviewed__c= false , esn__c = 'Test4');
            solutionList.add(solRec2); 
            CSS_CampTsbTrp__c solRec1 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB1401689',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                              Type__c='TSB',Doc_Title__c='xyzk' ,Performed__c= true,
                                                              Performed_Review__c= false,Reviewed__c= false , esn__c = 'Tets3');
            solutionList.add(solRec1); 
            
            
            
            insert solutionList;
            
            
            
            
            list<CSS_CampTsbTrp__c> campTsbList = new list<CSS_CampTsbTrp__c>();
            CSS_CampTsbTrp__c campTsTr = new CSS_CampTsbTrp__c();
            campTsTr.Performed__c = true;
            campTsTr.Performed_Review__c = true;
            campTsTr.Reviewed__c= true;
            campTsbList.add(ct);
            campTsbList = [select Doc_Num__c,URL__c,Type__c,Doc_Title__c ,Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c limit 100];
            qsol.getJobESN();
            //qsol.getJobID();
            qsol.setJobESN('79464646');
            qsol.getCampaignsRecords();
            qsol.getCampRecords();
            qsol.getCampaignsCount();
            qsol.getTrpRecords();
            qsol.getTrpsRecords();
            qsol.getTrpsCount();
            qsol.getTsbRecords();
            qsol.getTsbsCount();
            qsol.getTsbsRecords();
            //  qsol.getRecords();
            qsol.getALLRecords();
            qsol.savectt();
            qsol.sort1(campTsbList);
            
            qsol.gettoken();
            qsol.getCampTRPATCs();
        }}
    
}