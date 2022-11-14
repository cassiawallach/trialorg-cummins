@isTest(seealldata = false)
public class CSS_VerificationHistory_Test 
{
    public static testMethod void testmethod1() 
    {
        Test.startTest();
        //Create a job
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        insert JO;
        
        //Create a solution
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.Service_Job__c = JO.ID;
        sol1.Case_Name__c = 'K24241010';
        sol1.Solution_Title__c = 'Exhaust gas pressure sensor circuit response check';//Title Given
        sol1.Name = 'K24241010';
        sol1.CreatedDate = system.now();
        sol1.CreatedById = userinfo.getUserId();
        sol1.Diagnostic_Response__c ='';
        sol1.Repair_Response__c = 'Repair not performed.';//Repair response given
		insert sol1;
        CSS_Solutions__history solhis = new CSS_Solutions__history();
        solhis.ParentId = sol1.id;
        solhis.Field = 'Repair_Response__c';
        solhis.ParentId=sol1.Id;
        insert solhis;
        //Updating a solution
        sol1.Repair_Response__c = 'Repair Successful.';//Repair response Changed
        sol1.Solution_Title__c = 'Intake manifold pressure sensor supply voltage check';//Title Changed
        upsert sol1;
        system.debug('sol>>>>>>>>>'+sol1);
        
        
        list<CSS_Solution_Component__c> solcomplist =  new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Name='Electrical Connector';
        solcomp.Quantity__c=2;
        solcomp.Solutions__c = sol1.id;
        solcomp.Action__c = 'Repaired';
        solcomp.Selected_Component__c = false;
        solcomp.Component_Id__c = 'F19000530';
        solcomp.Service_Job__c = jo.id;
        insert solcomp;
        solcomplist.add(solcomp);
        
        //solution history list
        system.debug('Before Solution History List');
        List<CSS_Solutions__history> solhislist=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name From CSS_Solutions__history where Field='Diagnostic_Response__c'];
        system.debug('After Solution History List'+solhislist);
        
        
                

        List<CSS_Solutions__history> newsolhislist = new List<CSS_Solutions__history>();
        newsolhislist.add(solhis);
        CSS_Solutions__c sol2=[select id, name,Service_Job__c,Diagnostic_Response__c,Repair_Response__c from CSS_Solutions__c where id=:newsolhislist[0].parentid];
        sol2.Diagnostic_Response__c = 'Could not perform the solution verification';
        sol2.Repair_Response__c = 'Repair Successful';
        update sol2;

        PageReference pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        List<CSS_Solutions__history> cjh=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,parent.Name,parent.Solution_Title__c,parent.service_job__c,parent.service_job__r.LastModifiedDate, 
                                          CreatedBy.Name From CSS_Solutions__history where parent.service_job__c = :JO.id  limit 1];
        system.debug('cjh**'+cjh);
        system.debug('JO.id**'+JO.id);
        CSS_VerificationHistory srt = new CSS_VerificationHistory();
        srt.getRepairHistory();
        srt.getSolutionHistory();
        CSS_Solutions__c cjo =[select id,name,Diagnostic_Response__c from CSS_Solutions__c where id=:cjh[0].parentid];
        cjo.Diagnostic_Response__c = 'Most likely the solution';
        update cjo;
        
        ApexPages.currentPage().getParameters().put('id',sol1.id);
        CSS_VerificationHistory  audit2= new CSS_VerificationHistory ();
        audit2.Wid=sol1.id;
        audit2.getSolutionHistory();
          
        Test.stopTest();
    }
    public static testMethod void testmethod2() 
    {
        list<CSS_Solution_Component__c> solcomplist =  new list<CSS_Solution_Component__c>();
        
        //CSS_VerificationHistory.solHistory WRAPPER CLASS COVER
        CSS_VerificationHistory.solHistory SH = new CSS_VerificationHistory.solHistory();
        SH.diagResp= '1string';
        SH.caseName= 'K24241010';
        SH.solTitle= 'Fault Code 123 triggered by another fault code';
        SH.userName=userinfo.getname();
        SH.actionTaken='ra11fr563';
        SH.fieldName='Repair_Response__c';
        SH.newValue= 'Most likely the solution';
        SH.jobOrderDate= datetime.now();
        SH.dateChange=datetime.now();
        SH.csolComp=solcomplist;
        
        //CSS_VerificationHistory.solComp WRAPPER CLASS COVER
        CSS_VerificationHistory.solComp Sc = new CSS_VerificationHistory.solComp();
        Sc.userNameComp='test';
        Sc.actionTakenComp='test1';
        Sc.dateChangeComp=datetime.now();
        css_tnd_job tndjob =null;
        CSS_VerificationHistory verif = new CSS_VerificationHistory(tndjob);
        
    }
    
}