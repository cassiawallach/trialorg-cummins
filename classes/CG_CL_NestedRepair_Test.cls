@isTest
public class CG_CL_NestedRepair_Test  {
    
    public static testmethod void CG_CL_NestedRepair_Test1(){
        
       
        //Main Controller
        css_repair_job controller = new css_repair_job();
        String selectedFaulcodeId = ApexPages.CurrentPage().getParameters().get('fcid');
        String source = ApexPages.CurrentPage().getParameters().get('source');
        String solId = ApexPages.CurrentPage().getParameters().get('solid');
        String nSolId = ApexPages.CurrentPage().getParameters().get('Nsolid');
        
        //Service Job 
        list<CSS_Job_Order__c> Serlist=new list<CSS_Job_Order__c>();
        CSS_Job_Order__c SerRec=new CSS_Job_Order__c();
        SerRec.DSID__c='12345';
        SerRec.DSID_Status__c='open';
        SerRec.ESN__c ='79464646';
        SerRec.CSS_Channel_Code__c ='7943';
        SerRec.Customer_Name__c='ABC';
        //SerRec.Failure_Date__c =d;
        SerRec.Failure_Point__c=2.2;
        SerRec.Unit_Number__c='1234';
        SerRec.Territory_Class__c='test';
        SerRec.Qsol_Engine_Family_Code__c='1234';
        SerRec.Service_Model__c='ESN';
        SerRec.Service_Model_N__c = 445566;
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.VIN__c='1XKAD49X6CJ305490';
        SerRec.Customer_Name__c='ABC';
        //SerRec.Warranty_Start_Date__c=d;
        SerRec.Failure_Point_Measure__c = 'MI'; 
        SerRec.Application__c='Automotive'; 
        SerRec.sub_Type__c='cedan';
        SerRec.INSITE_UpdateTimeStamp__c= system.today();
        SerRec.INSITE_ESN_Choice__c='Not Selected';
        SerRec.Shop_Work_Order__c='1234';
        SerRec.DSID_Creation_Timestamp__c=system.today();
        SerRec.DSID_WorkGroup__c='Wrkgrp';
        SerRec.Equipment_ID__c='Equip';
        SerRec.Status__c = 'Triage & Diagnosis/Repair' ;
        SerRec.Previous_Status__c = 'Triage & Diagnosis' ;
        SerRec.CSS_Job_Location_Code__c='56270-56255';
        SerRec.PSN_Not_Available__c = true;
        SerRec.Actual_Technician_Time__c=1.2;
        Serlist.add(SerRec);
        insert Serlist;
        
       
        id Ins_JobId = ApexPages.currentPage().getParameters().put('id',SerRec.id);
        
        //CSS_Job_Order__c rJobOrd = [Select Id,Name from CSS_Job_Order__c where id =: Ins_JobId];
        //system.debug('rJobOrd'+rJobOrd);
        
        //ApexPages.currentPage().getParameters().put('id', rJobOrd.Id);
        
        //Solution
        list<css_solutions__c> solsList=new list<css_solutions__c>();
        css_solutions__c sol1=new css_solutions__c();
        sol1.CSS_Nested_Solutions__c=solId;
        sol1.Repair_Notes__c='testing';
        sol1.Service_Job__c=SerRec.id;
       // sol1.FSL_Service_Job__c=SerRec.id;
        solsList.add(sol1);
        insert solsList;
        
        CSS_Solutions__c NSoln=new CSS_Solutions__c();
        NSoln.id=nSolId;
        NSoln.Repair_Notes__c='testing';
        Nsoln.name='prashanthi';
        Nsoln.Report_Comments__c='test123';
        Nsoln.Service_Job__c=SerRec.id;
        //Nsoln.FSL_Service_Job__c=SerRec.id;
        upsert NSoln;
        
        
        List<CSS_Fault_Code__c> FCLst = new List<CSS_Fault_Code__c>();
        CSS_Fault_Code__c FC = new CSS_Fault_Code__c();
        FC.Name = '3539';
        Fc.Related_Fault_Code__c = '';
        FCLst.add(FC);
        Insert FcLst;
        
        //Solution Component
        css_solution_component__c solcomp1 = new css_solution_component__c();
        solcomp1.Service_Job__c=SerRec.id;
        solcomp1.Solutions__c=Nsoln.id;
        //solcomp1.CSS_Claims__c=claims.id;
        //solcomp1.AccountCode__c = 'Select';
        solcomp1.AccountCodeType__c = 'One';
        solcomp1.AccountCodeEdit__c = 'TestAE';
        solcomp1.System_Code__c = 'WE';
        solcomp1.Component_Code__c = 'QP';
        solcomp1.CoveredPartsQty__c = '123';
        solcomp1.CoveredOCAmount__c = '123';
        //sc.add(solcomp1);
        // insert solcomp1;
        
        //Part Option
        RecordType rtp = [SELECT id,Name 
                          FROM RecordType 
                          WHERE name='Parts']; 
                          
        list<CSS_Parts_Options__c> partlist = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partComp1 = new CSS_Parts_Options__c();
        partComp1.selected_part__c = false;
        partComp1.Replacement_Reason__c= 'Select One';
        partComp1.Quantity__c=10;
        partlist.add(partComp1);
        
        CSS_Parts_Options__c partComp2 = new CSS_Parts_Options__c();
        partComp2.selected_part__c = false;
        partcomp2.Solutions__c=Nsoln.id;
        partcomp2.Service_Job__c=SerRec.id;
        partcomp2.RecordTypeId =rtp.id;
        partComp2.Replacement_Reason__c= 'Select One';
        partComp2.Quantity__c=10;
        partlist.add(partComp2);
        insert partlist;
        
        
        CSS_Job_Order__c SerRec1=new CSS_Job_Order__c();
        SerRec1.id=Ins_JobId;
        SerRec1.DSID__c='12345';
        //SerRec1.OwnerId = tq.Id;
        SerRec1.DSID_Status__c='open';
        SerRec1.ESN__c ='79464646';
        SerRec1.CSS_Channel_Code__c ='7943';
        SerRec1.Customer_Name__c='ABC';
        //SerRec1.Failure_Date__c =d;
        SerRec1.Failure_Point__c=2.2;
        SerRec1.Unit_Number__c='1234';
        SerRec1.Territory_Class__c='test';
        SerRec1.Qsol_Engine_Family_Code__c='1234';
        SerRec1.Service_Model__c='ESN';
        SerRec1.Service_Model_N__c = 445566;
        SerRec1.Make__c='test';
        SerRec1.Model__c='test1';
        SerRec1.VIN__c='1XKAD49X6CJ305490';
        SerRec1.Customer_Name__c='ABC';
        //SerRec1.Warranty_Start_Date__c=d;
        SerRec1.Failure_Point_Measure__c = 'MI'; 
        SerRec1.Application__c='Automotive'; 
        SerRec1.sub_Type__c='cedan';
        SerRec1.INSITE_UpdateTimeStamp__c= system.today();
        SerRec1.INSITE_ESN_Choice__c='Not Selected';
        SerRec1.Shop_Work_Order__c='1234';
        SerRec1.DSID_Creation_Timestamp__c=system.today();
        SerRec1.DSID_WorkGroup__c='Wrkgrp';
        SerRec1.Equipment_ID__c='Equip';
        SerRec1.Status__c = 'Triage & Diagnosis/Repair' ;
        SerRec1.Previous_Status__c = 'Triage & Diagnosis' ;
        SerRec1.CSS_Job_Location_Code__c='56270-56255';
        SerRec1.PSN_Not_Available__c = true;
        SerRec1.Actual_Technician_Time__c=1.2;
        upsert SerRec1;
        
        List<CSS_JobEventTemporary__c> qsolRetrivedFCMasters =new  List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        //jobevent.key__c='79464646'+':'+cl.id;
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        qsolRetrivedFCMasters.add(jobevent);
        insert qsolRetrivedFCMasters;
        
        
        CSS_Solutions__c NSoln2=new CSS_Solutions__c();
        //NSoln2.id='a0829000001xVdJAAU';
        NSoln2.name='prashanthi';
        NSoln2.Repair_Response__c=null;
        NSoln2.Repair_Notes__c='testing';
        Nsoln2.Service_Job__c=SerRec.id;
        //Nsoln2.FSL_Service_Job__c=SerRec.id;
        upsert NSoln2;
        
       // CSS_Solutions__c  sol2= [select id,Name,Report_Comments__c,Solution_Title__c,Repair_Response__c ,Repair_notes__c,Diagnostic_Response__c,Diagnostic_notes__c,Nested_Rank__c,CSS_Nested_Solutions__r.Rank__c from CSS_Solutions__c where id ='a0829000001xVdJAAU'];
        
        
        CSS_Solutions__c NSoln1=new CSS_Solutions__c();
        //NSoln1.id='a0829000001xVdJAAU';
        Nsoln1.name='prashanthi';
        NSoln1.Repair_Response__c='Repair Successful with additional parts/procedures.';
        Nsoln1.Repair_Notes__c=null;
        Nsoln1.Service_Job__c=SerRec.id;
        //Nsoln1.FSL_Service_Job__c=SerRec.id;
        upsert NSoln1;
        
        list<CSS_Solution_Component__c> solcomplist=new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp11=new CSS_Solution_Component__c();
        solcomp11.Solutions__c = NSoln.Id;
        solcomp11.Selected_Component__c=true;
        solcomp11.Service_Job__c = serrec.id ;
        solcomplist.add(solcomp11);
        insert solcomplist;
        
        //Wrapppers
        CG_CL_NestedRepair.solWrapper solw=new  CG_CL_NestedRepair.solWrapper('Success','20','comment','12345'); 
        list<CG_CL_NestedRepair.srtPartWrapper> srtpartlist=new list<CG_CL_NestedRepair.srtPartWrapper>();
        CG_CL_NestedRepair.srtPartWrapper srtp1=new CG_CL_NestedRepair.srtPartWrapper(partComp2.id,partComp2.id,true,'Turbo charger',10,10,'Select one');
        srtpartlist.add(srtp1);
        list<CG_CL_NestedRepair.srtCompWrapper> srtcomplist=new list<CG_CL_NestedRepair.srtCompWrapper>();
        String s1='test';
        String s2='test1';
        list<String> childIds=new list<String>();
        childIds.add(s1);
        childIds.add(s2);
        
        CG_CL_NestedRepair.srtCompWrapper srtcomp=new CG_CL_NestedRepair.srtCompWrapper(solcomp1.id,true,'compName',childIds,srtpartlist,'faultCode','systemCode','compCode','accountCode');
        srtcomplist.add(srtcomp);
        
        
        ApexPages.CurrentPage().getParameters().put('id',SerRec1.id);
        
        Test.startTest();
        CG_CL_NestedRepair nestrep = new CG_CL_NestedRepair(controller);
        CG_CL_NestedRepair.NestedSolutionsClass nesol=  new  CG_CL_NestedRepair.NestedSolutionsClass();
        nestrep.recFaultCode = FCLst;
        nestrep.source='Insite';
        nesol.solID = NSoln1.id;
        nesol.solNum = 'Prashanthi';
        nesol.solTitle ='Black Smoke';
        nesol.Resolution='testing';
        nesol.RepairNotes='success';
        nestrep.ErrorMessage=true;
        nestrep.solNum='20';
        nestrep.onChangeId=NSoln.id;
        nestrep.dsidind='N';
        nestrep.selectedFaulcode='THAC';
        nestrep.sKNumber='12345';
        nestrep.selectedDiagRespNested='abcdefgh';
        nestrep.failDiagResp=true;
        nestrep.failDiagResp1=true;
        nestrep.solDetFailed=true;
        nestrep.solErrorMsg='test123';
        nestrep.selectedNestSolId='12345';
        nestrep.queryFrom='nested';
        nestrep.nestSolNumber='12345';
        nestrep.validateResponse();
        nestrep.faultCodeClick();
        nestrep.onClickOfNSolns();
        // nestrep.onClickOfNSolns();
        nestrep.getSolutionDetails();
        nestrep.qsolredirect();
        nestrep.updateFeedBackForSol();
        //nestrep.reportProblemComments();
        nestrep.getPartsList();
        nestrep.validateResponse();
        //nestrep.srtAccesscheckList();
        //PageReference pr = new PageReference('/CSS_srtAccessChecklistPae?SolId='+NSoln2.Id);
        //PageReference ref=nestrep.srtAccesscheckList();
        nestrep.actionMethodOf();
        //nestrep.UpdateSolNotes();
        nestrep.refreshPartsList();
        nestrep.selSolution = '';
        nestrep.rJobOrd=SerRec;
        nestrep.selectedNestSolTitle1 = '';
        nestrep.partssave(srtcomplist);
        //nestrep.partssave();
        //nestrep.UpdateSolNotes();
        //CG_CL_NestedRepair.getAccountCodes('79464646','spCode',system.today(),'failurePoint','failureMeasure','engAppCode',system.today()-20,'20466','Y','Name');
        nestrep.getreplacementReasonOptions();
        nestrep.returnToRepairView();
        nestrep.nestFailDiagResp=true;
        //nestrep.returnToParentSolution();
        //nestrep.returnToParentSolution();
        nestrep.reportProblemComments();
        CSS_EDSAuthentication.reportProblem(SerRec1.DSID__c, Nsoln.name, Nsoln.Report_Comments__c);
        Test.stopTest();
    }
    
    public static testmethod void CG_CL_NestedRepair_Test2(){
        
        css_repair_job controller = new css_repair_job();
        String selectedFaulcodeId = ApexPages.CurrentPage().getParameters().get('fcid');
        String source = ApexPages.CurrentPage().getParameters().get('source');
        String solId = ApexPages.CurrentPage().getParameters().get('solid');
        String nSolId = ApexPages.CurrentPage().getParameters().get('Nsolid');
        list<CSS_Job_Order__c> Serlist=new list<CSS_Job_Order__c>();
        CSS_Job_Order__c SerRec=new CSS_Job_Order__c();
        //SerRec.id=Ins_JobId;
        SerRec.DSID__c='12345';
        //SerRec.Creator_Location__c='24566';
        //SerRec.OwnerId = tq.Id;
        SerRec.DSID_Status__c='open';
        SerRec.ESN__c ='79464646';
        SerRec.CSS_Channel_Code__c ='7943';
        SerRec.Customer_Name__c='ABC';
        //SerRec.Failure_Date__c =d;
        SerRec.Failure_Point__c=2.2;
        SerRec.Unit_Number__c='1234';
        SerRec.Territory_Class__c='test';
        SerRec.Qsol_Engine_Family_Code__c='1234';
        SerRec.Service_Model__c='ESN';
        SerRec.Service_Model_N__c = 445566;
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.VIN__c='1XKAD49X6CJ305490';
        SerRec.Customer_Name__c='ABC';
        //SerRec.Warranty_Start_Date__c=d;
        SerRec.Failure_Point_Measure__c = 'MI'; 
        SerRec.Application__c='Automotive'; 
        SerRec.sub_Type__c='cedan';
        SerRec.INSITE_UpdateTimeStamp__c= system.today();
        SerRec.INSITE_ESN_Choice__c='Not Selected';
        SerRec.Shop_Work_Order__c='1234';
        SerRec.DSID_Creation_Timestamp__c=system.today();
        SerRec.DSID_WorkGroup__c='Wrkgrp';
        SerRec.Equipment_ID__c='Equip';
        SerRec.Status__c = 'Triage & Diagnosis/Repair' ;
        SerRec.Previous_Status__c = 'Triage & Diagnosis' ;
        SerRec.CSS_Job_Location_Code__c='56270-56255';
        SerRec.PSN_Not_Available__c = true;
        SerRec.Actual_Technician_Time__c=1.2;
        Serlist.add(SerRec);
        insert Serlist;
        
        list<css_solutions__c> solsList=new list<css_solutions__c>();
        css_solutions__c sol1=new css_solutions__c();
        sol1.CSS_Nested_Solutions__c=solId;
        sol1.Repair_Notes__c='testing';
        sol1.Service_Job__c=SerRec.id;
        //sol1.FSL_Service_Job__c=SerRec.id;
        solsList.add(sol1);
        insert solsList;
        CSS_Solutions__c NSoln=new CSS_Solutions__c();
        NSoln.id=nSolId;
        NSoln.Repair_Notes__c='testing';
        Nsoln.name='prashanthi';
        Nsoln.Report_Comments__c='test123';
        Nsoln.Service_Job__c=SerRec.id;
        //Nsoln.FSL_Service_Job__c=SerRec.id;
        upsert NSoln;
        //String Ins_JobId = ApexPages.CurrentPage().getParameters().get('Id'); 
        // System.debug('Ins_JobId>>>'+Ins_JobId);
        
        ApexPages.currentPage().getParameters().put('id', Serlist[0].Id);
        String Ins_JobId =ApexPages.currentPage().getParameters().get('id');
        System.debug('SerRec'+SerRec);
        CSS_Job_Order__c rJobOrd =[Select Id,Name, Service_Model__c, ReconEngineFlag__c, ESN__c,ESN_Insite__c,DSID__c,DSID_WorkGroup__c,INSITE_UpdateTimeStamp__c,Status__c,Previous_Status__c,INSITE_ESN_Choice__c,Qsol_Engine_Family_Code__c,Equipment_ID__c,Mileage__c, Mileage_Measure__c,Failure_Date__c,Failure_Point__c,Failure_Point_Measure__c,Warranty_Start_Date__c,CSS_Job_Location_Code__c,ApplicationCode__c,Creator_Location__c from CSS_Job_Order__c where id= :Ins_JobId];
        system.debug('rJobOrd'+rJobOrd);
        
        RecordType rtp = [SELECT id,Name 
                          FROM RecordType 
                          WHERE name='Parts']; 
        list<CSS_Parts_Options__c> partlist = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partComp1 = new CSS_Parts_Options__c();
        partComp1.selected_part__c = false;
        partComp1.Replacement_Reason__c= 'Select One';
        partComp1.Quantity__c=10;
        partlist.add(partComp1);
        CSS_Parts_Options__c partComp2 = new CSS_Parts_Options__c();
        partComp2.selected_part__c = false;
        partcomp2.Solutions__c=Nsoln.id;
        partcomp2.Service_Job__c=SerRec.id;
        partcomp2.RecordTypeId =rtp.id;
        partComp2.Replacement_Reason__c= 'Select One';
        partComp2.Quantity__c=10;
        partlist.add(partComp2);
        insert partlist;
        CG_CL_NestedRepair.solWrapper solw=new  CG_CL_NestedRepair.solWrapper('Success','20','comment','12345'); 
        list<CG_CL_NestedRepair.srtPartWrapper> srtpartlist=new list<CG_CL_NestedRepair.srtPartWrapper>();
        CG_CL_NestedRepair.srtPartWrapper srtp1=new CG_CL_NestedRepair.srtPartWrapper(partComp2.id,partComp2.id,true,'Turbo charger',10,10,'Select one');
        srtpartlist.add(srtp1);
        list<CG_CL_NestedRepair.srtCompWrapper> srtcomplist=new list<CG_CL_NestedRepair.srtCompWrapper>();
        String s1='test';
        String s2='test1';
        list<String> childIds=new list<String>();
        childIds.add(s1);
        childIds.add(s2);
        css_solution_component__c solcomp1 = new css_solution_component__c();
        solcomp1.Service_Job__c=SerRec.id;
        solcomp1.Solutions__c=Nsoln.id;
        //solcomp1.CSS_Claims__c=claims.id;
        //solcomp1.AccountCode__c = 'Select';
        solcomp1.AccountCodeType__c = 'One';
        solcomp1.AccountCodeEdit__c = 'TestAE';
        solcomp1.System_Code__c = 'WE';
        solcomp1.Component_Code__c = 'QP';
        solcomp1.CoveredPartsQty__c = '123';
        solcomp1.CoveredOCAmount__c = '123';
        //sc.add(solcomp1);
        // insert solcomp1;
        CG_CL_NestedRepair.srtCompWrapper srtcomp1=new CG_CL_NestedRepair.srtCompWrapper(solcomp1.id,true,'compName',childIds,srtpartlist,'faultCode','systemCode','compCode','accountCode');
        CG_CL_NestedRepair.srtCompWrapper srtcomp2=new CG_CL_NestedRepair.srtCompWrapper(solcomp1.id,true,'compName',childIds,srtpartlist,'faultCode','systemCode','compCode','accountCode');
        CG_CL_NestedRepair.srtCompWrapper srtcomp3=new CG_CL_NestedRepair.srtCompWrapper(solcomp1.id,true,'compName',childIds,srtpartlist,'faultCode','systemCode','compCode','accountCode');
        CG_CL_NestedRepair.srtCompWrapper srtcomp4=new CG_CL_NestedRepair.srtCompWrapper(solcomp1.id,true,'compName',childIds,srtpartlist,'faultCode','systemCode','compCode','accountCode');
        CG_CL_NestedRepair.srtCompWrapper srtcomp5=new CG_CL_NestedRepair.srtCompWrapper(solcomp1.id,true,'compName',childIds,srtpartlist,'faultCode','systemCode','compCode','accountCode');
        CG_CL_NestedRepair.srtCompWrapper srtcomp6=new CG_CL_NestedRepair.srtCompWrapper(solcomp1.id,true,'compName',childIds,srtpartlist,'faultCode','systemCode','compCode','accountCode');
        CG_CL_NestedRepair.srtCompWrapper srtcomp7=new CG_CL_NestedRepair.srtCompWrapper(solcomp1.id,true,'compName',childIds,srtpartlist,'faultCode','systemCode','compCode','accountCode');
        CG_CL_NestedRepair.srtCompWrapper srtcomp8=new CG_CL_NestedRepair.srtCompWrapper(solcomp1.id,true,'compName',childIds,srtpartlist,'faultCode','systemCode','compCode','accountCode');
        CG_CL_NestedRepair.srtCompWrapper srtcomp9=new CG_CL_NestedRepair.srtCompWrapper(solcomp1.id,true,'compName',childIds,srtpartlist,'faultCode','systemCode','compCode','accountCode');
        CG_CL_NestedRepair.srtCompWrapper srtcomp10=new CG_CL_NestedRepair.srtCompWrapper(solcomp1.id,true,'compName',childIds,srtpartlist,'faultCode','systemCode','compCode','accountCode');
        CG_CL_NestedRepair.srtCompWrapper srtcomp11=new CG_CL_NestedRepair.srtCompWrapper(solcomp1.id,true,'compName',childIds,srtpartlist,'faultCode','systemCode','compCode','accountCode');
        
        srtcomplist.add(srtcomp1);
        srtcomplist.add(srtcomp2);
        srtcomplist.add(srtcomp3);
        srtcomplist.add(srtcomp4);
        srtcomplist.add(srtcomp5);
        srtcomplist.add(srtcomp6);
        srtcomplist.add(srtcomp7);
        srtcomplist.add(srtcomp8);
        srtcomplist.add(srtcomp9);
        srtcomplist.add(srtcomp10);
        srtcomplist.add(srtcomp11);
        
        list<CSS_Solution_Component__c> solcomplist=new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp11=new CSS_Solution_Component__c();
        solcomp11.Solutions__c = NSoln.Id;
        //solcomp1.id=NSoln.id;
        solcomp11.Selected_Component__c=true;
        solcomp11.Service_Job__c = Ins_JobId ;
        
        solcomplist.add(solcomp11);
        //insert solcomplist;
        CSS_Solutions__c NSoln1=new CSS_Solutions__c();
       // NSoln1.id='a0829000001xVdJAAU';
        Nsoln1.name='prashanthi';
        NSoln1.Repair_Response__c='Repair Successful with additional parts/procedures.';
        Nsoln1.Repair_Notes__c=null;
        Nsoln1.Service_Job__c=SerRec.id;
        //Nsoln1.FSL_Service_Job__c=SerRec.id;
        upsert NSoln1;
        // CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(Id = srtp1.partIds,selected_part__c = false,Replacement_Reason__c= 'Select One',Quantity__c=srtp1.defaultQty);
        CG_CL_NestedRepair nestrep = new CG_CL_NestedRepair(controller);
        CG_CL_NestedRepair.NestedSolutionsClass nesol=  new  CG_CL_NestedRepair.NestedSolutionsClass();
        nesol.solID = NSoln1.id;
        nesol.solNum = 'Prashanthi';
        nesol.solTitle ='Black Smoke';
        nesol.Resolution='testing';
        nesol.RepairNotes='success';
        nestrep.ErrorMessage=true;
        nestrep.solNum='20';
        nestrep.onChangeId=NSoln.id;
        nestrep.dsidind='N';
        nestrep.selectedFaulcode='THAC';
        nestrep.sKNumber='12345';
        nestrep.selectedDiagRespNested='abcdefgh';
        nestrep.failDiagResp=true;
        nestrep.failDiagResp1=true;
        List<CSS_JobEventTemporary__c> qsolRetrivedFCMasters =new  List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        //jobevent.key__c='79464646'+':'+cl.id;
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        qsolRetrivedFCMasters.add(jobevent);
        insert qsolRetrivedFCMasters;
        nestrep.solDetFailed=true;
        nestrep.solErrorMsg='test123';
        nestrep.selectedNestSolId='12345';
        nestrep.queryFrom='nested';
        nestrep.nestSolNumber='12345';
        nestrep.validateResponse();
        CSS_Solutions__c NSoln2=new CSS_Solutions__c();
        //NSoln2.id='a0829000001xVdJAAU';
        NSoln2.name='prashanthi';
        NSoln2.Repair_Response__c=null;
        NSoln2.Repair_Notes__c='testing';
        Nsoln2.Service_Job__c=SerRec.id;
        //Nsoln2.FSL_Service_Job__c=SerRec.id;
        upsert NSoln2;
        //CSS_Solutions__c  sol2= [select id,Name,Report_Comments__c,Solution_Title__c,Repair_Response__c ,Repair_notes__c,Diagnostic_Response__c,Diagnostic_notes__c,Nested_Rank__c,CSS_Nested_Solutions__r.Rank__c from CSS_Solutions__c where id ='a0829000001xVdJAAU'];
        nestrep.faultCodeClick();
        nestrep.onClickOfNSolns();
        // nestrep.onClickOfNSolns();
        nestrep.getSolutionDetails();
        nestrep.qsolredirect();
        nestrep.updateFeedBackForSol();
        //nestrep.reportProblemComments();
        nestrep.getPartsList();
        nestrep.validateResponse();
        //PageReference pr = new PageReference('/CSS_srtAccessChecklistPae?SolId='+NSoln2.Id);
        //PageReference ref=nestrep.srtAccesscheckList();
        nestrep.actionMethodOf();
        //nestrep.UpdateSolNotes();
        nestrep.refreshPartsList();
        nestrep.selSolution = 'Repair Successful.';
        //PageReference pr = new PageReference('/CSS_srtAccessChecklistPae?SolId='+sol2.Id);
        nestrep.selectedNestSolTitle1 = 'Repair Successful.';
        nestrep.partssave(srtcomplist);
        //nestrep.partssave();
        //nestrep.UpdateSolNotes();
        //CG_CL_NestedRepair.getAccountCodes('79464646','spCode',system.today(),'failurePoint','failureMeasure','engAppCode',system.today()-20,'20466','Y','Name');
        nestrep.getreplacementReasonOptions();
        nestrep.returnToRepairView();
        //nestrep.srtAccesscheckList();
        nestrep.nestFailDiagResp=true;
        //nestrep.returnToParentSolution();
        
        //nestrep.returnToParentSolution();
        CSS_Job_Order__c SerRec1=new CSS_Job_Order__c();
        SerRec1.id=Ins_JobId;
        SerRec1.DSID__c='12345';
        //SerRec1.OwnerId = tq.Id;
        SerRec1.DSID_Status__c='open';
        SerRec1.ESN__c ='79464646';
        SerRec1.CSS_Channel_Code__c ='7943';
        SerRec1.Customer_Name__c='ABC';
        //SerRec1.Failure_Date__c =d;
        SerRec1.Failure_Point__c=2.2;
        SerRec1.Unit_Number__c='1234';
        SerRec1.Territory_Class__c='test';
        SerRec1.Qsol_Engine_Family_Code__c='1234';
        SerRec1.Service_Model__c='ESN';
        SerRec1.Service_Model_N__c = 445566;
        SerRec1.Make__c='test';
        SerRec1.Model__c='test1';
        SerRec1.VIN__c='1XKAD49X6CJ305490';
        SerRec1.Customer_Name__c='ABC';
        //SerRec1.Warranty_Start_Date__c=d;
        SerRec1.Failure_Point_Measure__c = 'MI'; 
        SerRec1.Application__c='Automotive'; 
        SerRec1.sub_Type__c='cedan';
        SerRec1.INSITE_UpdateTimeStamp__c= system.today();
        SerRec1.INSITE_ESN_Choice__c='Not Selected';
        SerRec1.Shop_Work_Order__c='1234';
        SerRec1.DSID_Creation_Timestamp__c=system.today();
        SerRec1.DSID_WorkGroup__c='Wrkgrp';
        SerRec1.Equipment_ID__c='Equip';
        SerRec1.Status__c = 'Triage & Diagnosis/Repair' ;
        SerRec1.Previous_Status__c = 'Triage & Diagnosis' ;
        SerRec1.CSS_Job_Location_Code__c='56270-56255';
        SerRec1.PSN_Not_Available__c = true;
        SerRec1.Actual_Technician_Time__c=1.2;
        upsert SerRec1;
        //CSS_EDSAuthentication.reportProblem(SerRec1.DSID__c, Nsoln.name, Nsoln.Report_Comments__c);
        // nestrep.reportProblemComments();
    }
    
    public static testmethod void CG_CL_NestedRepair_Test3(){
        css_repair_job controller = new css_repair_job();
        CG_CL_NestedRepair nestrep = new CG_CL_NestedRepair(controller);
        CG_CL_NestedRepair.NestedSolutionsClass nesol=new  CG_CL_NestedRepair.NestedSolutionsClass();
        nestrep.ErrorMessage=true;
        nestrep.solNum='20';
        nestrep.validateResponse();
        list<CSS_Job_Order__c> Serlist=new list<CSS_Job_Order__c>();
        CSS_Job_Order__c SerRec=new CSS_Job_Order__c();
        //SerRec.id=Ins_JobId;
        SerRec.DSID__c='12345';
        //SerRec.Creator_Location__c='24566';
        //SerRec.OwnerId = tq.Id;
        SerRec.DSID_Status__c='open';
        SerRec.ESN__c ='79464646';
        SerRec.CSS_Channel_Code__c ='7943';
        SerRec.Customer_Name__c='ABC';
        //SerRec.Failure_Date__c =d;
        SerRec.Failure_Point__c=2.2;
        SerRec.Unit_Number__c='1234';
        SerRec.Territory_Class__c='test';
        SerRec.Qsol_Engine_Family_Code__c='1234';
        SerRec.Service_Model__c='ESN';
        SerRec.Service_Model_N__c = 445566;
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.VIN__c='1XKAD49X6CJ305490';
        SerRec.Customer_Name__c='ABC';
        //SerRec.Warranty_Start_Date__c=d;
        SerRec.Failure_Point_Measure__c = 'MI'; 
        SerRec.Application__c='Automotive'; 
        SerRec.sub_Type__c='cedan';
        SerRec.INSITE_UpdateTimeStamp__c= system.today();
        SerRec.INSITE_ESN_Choice__c='Not Selected';
        SerRec.Shop_Work_Order__c='1234';
        SerRec.DSID_Creation_Timestamp__c=system.today();
        SerRec.DSID_WorkGroup__c='Wrkgrp';
        SerRec.Equipment_ID__c='Equip';
        SerRec.Status__c = 'Triage & Diagnosis/Repair' ;
        SerRec.Previous_Status__c = 'Triage & Diagnosis' ;
        SerRec.CSS_Job_Location_Code__c='56270-56255';
        SerRec.PSN_Not_Available__c = true;
        SerRec.Actual_Technician_Time__c=1.2;
        Serlist.add(SerRec);
        insert Serlist;
        CSS_Solutions__c NSoln2=new CSS_Solutions__c();
        //NSoln2.id='a0829000001xVdJAAU';
        NSoln2.name='prashanthi';
        NSoln2.Repair_Response__c=null;
        NSoln2.Repair_Notes__c=null;
        NSoln2.Service_Job__c=SerRec.id;
        //NSoln2.FSL_Service_Job__c=SerRec.id;
        upsert NSoln2;
        nestrep.faultCodeClick();
        
        nestrep.getSolutionDetails();
        nestrep.qsolredirect();
        nestrep.updateFeedBackForSol();
        //nestrep.reportProblemComments();
        nestrep.getPartsList();
        nestrep.validateResponse();
        //PageReference pr = new PageReference('/CSS_srtAccessChecklistPae?SolId='+NSoln2.Id);
        //PageReference ref=nestrep.srtAccesscheckList();
        nestrep.actionMethodOf();
        //nestrep.UpdateSolNotes();
        nestrep.refreshPartsList();
        nestrep.selSolution = 'Repair Successful.';
        
        nestrep.selectedNestSolTitle1 = 'Repair Successful.';
        nestrep.partssave(null);
        //nestrep.partssave();
        //nestrep.UpdateSolNotes();
        // CG_CL_NestedRepair.getAccountCodes(null,null,null,null,null,null,null,null,null,null);
        nestrep.getreplacementReasonOptions();
        nestrep.returnToRepairView();
        
        nestrep.nestFailDiagResp=true;
        nestrep.UpdateSolNotes();
        nestrep.returnToParentSolution();
        
        CSS_Solutions__c NSoln=new CSS_Solutions__c();
        //NSoln.id=nSolId;
        NSoln.Repair_Notes__c='testing';
        Nsoln.name='prashanthi';
        Nsoln.Report_Comments__c='test123';
        Nsoln.Service_Job__c=SerRec.id;
        //Nsoln.FSL_Service_Job__c=SerRec.id;
        insert NSoln;
        // nestrep.srtAccesscheckList();
    }
    
    public static testmethod void CG_CL_NestedRepair_Test4(){
        
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'RoopaTnD';
        JO.Model__c = 'RoopaTestTnD';      
        JO.Application__c='Automotive'; 
        JO.Date_In__c= Date.today();
        JO.Notes__c= 'Repair';
        JO.INSITE_UpdateTimeStamp__c= Date.today();
        JO.Service_Model__c='ff';
        JO.General_Symptoms__c='ttrtrtrt';
        JO.ESN__c='73695829';
        //JO.Creator_Location__c = 'Ban';
        JO.DSID__c = 'DSBDW3048';
        JO.Mileage__c=23;
        JO.Category__c = 'Leak';
        JO.Complaint_Type__c = 'AIR LEAK';
        JO.Application_Desc__c='TEST';
        JO.Failure_Date__c= Date.Today();
        JO.Failure_Point_Measure__c ='sss';
        JO.DSID_Creation_Timestamp__c=Date.Today();
        JO.DSID_Status__c='open';
        JO.Shop_Work_Order__c = 'test';
        JO.Status__c = 'Triage & Diagnosis/Repair';
        JO.Unit_Number__c = 'test1234';
        JO.BMSStatus__c = 'open';
        JO.warranty_start_date__c = System.Today();
        jo.Category_Desc__c = 'f';
        JO.Category2_Desc__c='F';
        JO.Category3_Desc__c='F';
        JO.Category4_Desc__c='F';
        JO.Category5_Desc__c='F';
        jo.Complaint_Type_Desc__c = 'rrrr';
        jo.Email_Address__c ='a@abc.com';
        jo.Unit_Type__c = 'Conventional';
        //jo.Mileage_Measure__c = 'Miles';
        Jo.DSID_WorkGroup__c = 'PGA01';
        //Jo.DSID_WorkGroup__c = 'ORLANDO-CUMMINS POWER SOUTH, LLC-02004';
        jo.Previous_Status__c='Triage & Diagnosis';
        //Jo.Assigned_To__c = UserInfo.getUserId();
        insert jo;
        
        CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
        fauCodRef.Job_Order__c =jo.Id; 
        fauCodRef.Sequence__c=1;
        fauCodRef.Fault_Code_Type__c='BPD'; 
        fauCodRef.Primary_Fault_Code__c=3539; 
        fauCodRef.Status__c='A';
        insert fauCodRef;
        
        List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
        fauCodRefList.add(fauCodRef);
        
        list<CSS_SymptomQA__c> symlst = new list<CSS_SymptomQA__c>();
        CSS_SymptomQA__c symqa=new CSS_SymptomQA__c();
        symqa.name='TESST';
        symqa.Type__c='SearchString';
        insert symqa; 
        symlst.add(symqa);
        
        css_repair_job controller = new css_repair_job();
        CG_CL_NestedRepair nestrep = new CG_CL_NestedRepair(controller);
        nestrep.recFaultCode=fauCodRefList;
        nestrep.selectedFaulcodeId=symqa.id;
        
        CG_CL_NestedRepair.NestedSolutionsClass nesol=new  CG_CL_NestedRepair.NestedSolutionsClass();
        nestrep.ErrorMessage=true;
        nestrep.solNum='20';
        nestrep.validateResponse();
        
        CSS_Solutions__c NSoln21=new CSS_Solutions__c();
        NSoln21.Rank__c=4;
        NSoln21.name='prashanthi';
        NSoln21.Repair_Response__c='test';
        NSoln21.Repair_Notes__c='';
        NSoln21.Service_Job__c=JO.id;
        //NSoln21.FSL_Service_Job__c=JO.id;
        upsert NSoln21;
        
        List<CSS_Solutions__c> NSoln233=new List<CSS_Solutions__c>();
        CSS_Solutions__c NSoln2=new CSS_Solutions__c();
        NSoln2.id=NSoln21.id;
        NSoln2.name='prashanthi';
        NSoln2.Repair_Response__c='test';
        NSoln2.CSS_Nested_Solutions__r=NSoln21;
        NSoln2.Repair_Notes__c='';
        NSoln2.Service_Job__c=JO.id;
        //NSoln2.FSL_Service_Job__c=JO.id;
        upsert NSoln2;
        NSoln233.add(NSoln2);
        nestrep.NSoln=NSoln2;
        nestrep.rJobOrd=jo;
        nestrep.solsList=NSoln233;
        nestrep.selSolution = 'test';
        nestrep.selectedNestSolTitle1 = 'Repair Successful.';
        
        
        
        list<CSS_Parts_Options__c> partlist = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partComp1 = new CSS_Parts_Options__c();
        partComp1.selected_part__c = false;
        partComp1.Replacement_Reason__c= 'Select One';
        partComp1.Quantity__c=10;
        partlist.add(partComp1);
        CSS_Parts_Options__c partComp2 = new CSS_Parts_Options__c();
        partComp2.selected_part__c = false;
        partcomp2.Solutions__c=NSoln2.id;
        partcomp2.Service_Job__c=jo.id;
        //partcomp2.RecordTypeId =rtp.id;
        partComp2.Replacement_Reason__c= 'Select One';
        partComp2.Quantity__c=10;
        partlist.add(partComp2);
        insert partlist;
        CSS_Solution_Component__c solcomp11=new CSS_Solution_Component__c();
        solcomp11.Solutions__c = NSoln2.Id;
        //solcomp1.id=NSoln.id;
        solcomp11.Selected_Component__c=true;
        solcomp11.Service_Job__c = jo.id ;
        // insert solcomp11;
        nestrep.faultCodeClick();
        String s1='test';
        String s2='test1';
        list<String> childIds=new list<String>();
        childIds.add(s1);
        childIds.add(s2);
        CG_CL_NestedRepair.solWrapper solw=new  CG_CL_NestedRepair.solWrapper('Success','20','comment','12345'); 
        list<CG_CL_NestedRepair.srtPartWrapper> srtpartlist=new list<CG_CL_NestedRepair.srtPartWrapper>();
        CG_CL_NestedRepair.srtPartWrapper srtp1=new CG_CL_NestedRepair.srtPartWrapper(partComp2.id,partComp2.id,true,'Turbo charger',10,10,'Select one');
        srtpartlist.add(srtp1);
        
        
        
        List<CG_CL_NestedRepair.srtCompWrapper> fireLst = new List<CG_CL_NestedRepair.srtCompWrapper>();
        CG_CL_NestedRepair.srtCompWrapper srtcomp=new CG_CL_NestedRepair.srtCompWrapper(solcomp11.id,true,'compName',childIds,srtpartlist,'faultCode','systemCode','compCode',null);
        system.debug('srtcomp '+srtcomp);
        fireLst.add(srtcomp);
         String temp = JSON.serialize(fireLst);
        CSS_FN_SIEBEL.getWarrantyDetailCoverage('73595986','sp123',date.today()+1,'failpoint','failmeasure','engappcode',date.today(),'syscode33445','comp123','f123','acc123','a1O3B0000007DQsUAM',true,'campNum','N','Second Call', '',false,null);
        CG_CL_NestedRepair.getAccountCodes('PSN','spCode', date.today()+1,'failurePoint','failureMeasure','engAppCode', date.today(),temp,'reconFlag','Name');
        //CG_CL_NestedRepair.getAccountCodes('79464646','56255',system.today(),'failurePoint','failureMeasure','engAppCode',system.today()-20,temp,'Y','Name');
        system.debug('temp '+temp);
        
        
         CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
         cid.name = 'EDSgetSol';
         cid.ApplicationName__c = 'EDSgetSol';
         cid.End_Point__c = 'https://edstest.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/';
         cid.logging__c = '';
         cid.AuthEnv__c = '';
         cid.Method_Type__c = '';
         cid.Timeout__c = 120000;
         insert cid;
         
       
         CSS_accountLanguage__c aLang = new CSS_accountLanguage__c();
         aLAng.NAme = 'en_ZA';
         aLang.CSS_EDSLanguage__c = 'en';
         insert aLang;
         
         Test.setMock(HttpCalloutMock.class, new CSS_GetSolDetails_Test());
         nestrep.aLang = aLang;
         nestrep.rJobOrd = jo;
         nestrep.solutionId = NSoln2.id;
         nestrep.getSolutionDetails();
          
        
    }
    
    public static testmethod void CG_CL_NestedRepair_Test5(){
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'RoopaTnD';
        
        JO.Model__c = 'RoopaTestTnD';      
        JO.Application__c='Automotive'; 
        JO.Date_In__c= Date.today();
        JO.Notes__c= 'Repair';
        JO.INSITE_UpdateTimeStamp__c= Date.today();
        JO.Service_Model__c='ff';
        JO.General_Symptoms__c='ttrtrtrt';
        JO.ESN__c='73695829';
        //JO.Creator_Location__c = 'Ban';
        JO.DSID__c = 'DSBDT7000';
        JO.Mileage__c=23;
        JO.Category__c = 'Leak';
        JO.Complaint_Type__c = 'AIR LEAK';
        JO.Application_Desc__c='TEST';
        JO.Failure_Date__c= Date.Today();
        JO.Failure_Point_Measure__c ='sss';
        JO.DSID_Creation_Timestamp__c=Date.Today();
        JO.DSID_Status__c='open';
        JO.Shop_Work_Order__c = 'test';
        JO.Status__c = 'Triage & Diagnosis/Repair';
        JO.Unit_Number__c = 'test1234';
        JO.BMSStatus__c = 'open';
        JO.warranty_start_date__c = System.Today();
        jo.Category_Desc__c = 'f';
        JO.Category2_Desc__c='F';
        JO.Category3_Desc__c='F';
        JO.Category4_Desc__c='F';
        JO.Category5_Desc__c='F';
        jo.Complaint_Type_Desc__c = 'rrrr';
        jo.Email_Address__c ='a@abc.com';
        jo.Unit_Type__c = 'Conventional';
        //jo.Mileage_Measure__c = 'Miles';
        //Jo.DSID_WorkGroup__c = null;
        //Jo.DSID_WorkGroup__c = 'ORLANDO-CUMMINS POWER SOUTH, LLC-02004';
        jo.Previous_Status__c='Triage & Diagnosis';
        //Jo.Assigned_To__c = UserInfo.getUserId();
        insert jo;
        /*   CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
fauCodRef.Job_Order__c =jo.Id; 
fauCodRef.Sequence__c=1;
fauCodRef.Fault_Code_Type__c='BPD'; 
fauCodRef.Primary_Fault_Code__c=3539; 
fauCodRef.Status__c='A';
insert fauCodRef;
List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
fauCodRefList.add(fauCodRef);

list<CSS_SymptomQA__c> symlst = new list<CSS_SymptomQA__c>();
CSS_SymptomQA__c symqa=new CSS_SymptomQA__c();
symqa.name='TESST';
symqa.Type__c='SearchString';
insert symqa; 
symlst.add(symqa);*/
        css_repair_job controller = new css_repair_job();
        CG_CL_NestedRepair nestrep = new CG_CL_NestedRepair(controller);
        //nestrep.recFaultCode=fauCodRefList;
        //   nestrep.selectedFaulcodeId=symqa.id;
        CG_CL_NestedRepair.NestedSolutionsClass nesol=new  CG_CL_NestedRepair.NestedSolutionsClass();
        nestrep.ErrorMessage=true;
        nestrep.solNum='20';
        nestrep.validateResponse();
        CSS_Solutions__c NSoln21=new CSS_Solutions__c();
        //NSoln21.id='a0829000001xVdJAAU';
        NSoln21.name='prashanthi';
        NSoln21.Repair_Response__c='test';
        NSoln21.Repair_Notes__c='';
        NSoln21.Service_Job__c=JO.id;
        //NSoln21.FSL_Service_Job__c=JO.id;
        upsert NSoln21;
        CSS_Solutions__c NSoln2=new CSS_Solutions__c();
        NSoln2.id=NSoln21.id;
        NSoln2.name='prashanthi';
        NSoln2.Repair_Response__c='test';
        NSoln2.Repair_Notes__c='';
        NSoln2.Service_Job__c=JO.id;
        //NSoln2.FSL_Service_Job__c=JO.id;
        upsert NSoln2;
        CSS_Solution_Component__c solcomp11=new CSS_Solution_Component__c();
        solcomp11.Solutions__c = NSoln2.Id;
        //solcomp1.id=NSoln.id;
        solcomp11.Selected_Component__c=true;
        solcomp11.Service_Job__c = jo.id ;
        //insert solcomp11;
        Id recTyIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts'); 
        list<CSS_Parts_Options__c> partlist = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partComp1 = new CSS_Parts_Options__c();
        partComp1.selected_part__c = false;
        partComp1.Replacement_Reason__c= 'Select One';
        partComp1.Quantity__c=10;
        partlist.add(partComp1);
        CSS_Parts_Options__c partComp2 = new CSS_Parts_Options__c();
        partComp2.selected_part__c = false;
        partComp2.FailurepartId__c = solcomp11.id;
        partComp2.Part_Assignment__c = 'Primary';
        partcomp2.Solutions__c=NSoln2.id;
        partcomp2.Service_Job__c=jo.id;
        partcomp2.RecordTypeId =recTyIdpart;
        partComp2.Replacement_Reason__c= 'Select One';
        partComp2.Quantity__c=10;
        partlist.add(partComp2);
        insert partlist;
        
        nestrep.faultCodeClick();
        
        nestrep.getSolutionDetails();
        nestrep.qsolredirect();
        nestrep.updateFeedBackForSol();
        //nestrep.reportProblemComments();
        nestrep.NSoln=NSoln2;
        nestrep.rJobOrd=jo;
        nestrep.Ins_JobId=jo.id;
        nestrep.getPartsList();
        nestrep.validateResponse();
        //PageReference pr = new PageReference('/CSS_srtAccessChecklistPae?SolId='+NSoln2.Id);
        //PageReference ref=nestrep.srtAccesscheckList();
        nestrep.actionMethodOf();
        //nestrep.UpdateSolNotes();
        nestrep.refreshPartsList();
        nestrep.selSolution = 'test';
        
        nestrep.selectedNestSolTitle1 = 'Repair Successful.';
        nestrep.partssave(null);
        //nestrep.partssave();
        //nestrep.UpdateSolNotes();
        // CG_CL_NestedRepair.getAccountCodes(null,null,null,null,null,null,null,null,null,null);
        nestrep.getreplacementReasonOptions();
        nestrep.returnToRepairView();
        
        nestrep.nestFailDiagResp=true;
        nestrep.NSoln=NSoln2;
        nestrep.rJobOrd=jo;
        nestrep.returnToParentSolution();
        
        String s1='test';
        String s2='test1';
        list<String> childIds=new list<String>();
        childIds.add(s1);
        childIds.add(s2);
        CG_CL_NestedRepair.solWrapper solw=new  CG_CL_NestedRepair.solWrapper('Success','20','comment','12345'); 
        list<CG_CL_NestedRepair.srtPartWrapper> srtpartlist=new list<CG_CL_NestedRepair.srtPartWrapper>();
        CG_CL_NestedRepair.srtPartWrapper srtp1=new CG_CL_NestedRepair.srtPartWrapper(partComp2.id,partComp2.id,true,'Turbo charger',10,10,'Select one');
        srtpartlist.add(srtp1);
        List<CG_CL_NestedRepair.srtCompWrapper> fireLst = new List<CG_CL_NestedRepair.srtCompWrapper>();
        CG_CL_NestedRepair.srtCompWrapper srtcomp=new CG_CL_NestedRepair.srtCompWrapper(solcomp11.id,true,'compName',childIds,srtpartlist,'faultCode','systemCode','compCode','accountCode');
        system.debug('srtcomp '+srtcomp);
        String temp = JSON.serialize(srtcomp);
        system.debug('temp '+temp);
        //CG_CL_NestedRepair.getAccountCodes('79464646','56255',system.today(),'failurePoint','failureMeasure','engAppCode',system.today()-20,temp,'Y','Name');
        CSS_Solutions__c NSoln=new CSS_Solutions__c();
        //NSoln.id=nSolId;
        NSoln.Repair_Notes__c='';
        Nsoln.name='prashanthi';
        NSoln.Repair_Response__c='test';
        Nsoln.Report_Comments__c='test123';
        Nsoln.Service_Job__c=jo.id;
        //Nsoln.FSL_Service_Job__c=jo.id;
        insert NSoln;
        // nestrep.srtAccesscheckList();
    }
    
    public static testmethod void CG_CL_NestedRepair_Test6(){
        
        CSS_Job_Order__c Jo =new CSS_Job_Order__c();
        Jo.Customer_Name__c = 'Oliver Trucking';
        Insert JO;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Repair Successful.';
        solAdd.Repair_notes__c = null;
        insert solAdd;
    
        List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solcomp.Solutions__c = solAdd.id;
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Claim_Type__c = 'Test';
        solComp.Selected_Claim_Type__c = 'Testing';
        solComp.Performed_Review__c = true;
        solComp.Status__c = 'Approved';
        solComp.Complete_Indicator__c =true;
        solComp.Multiple_Times__c =true;
        solComp.Fault_Code__c='turbocharger';
        solComp.AccountCodeType__c  = 'ACCOUNT TEAM COVERAGE';
        solComp.AccountCode__c = '27';
        solComp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        lstsolcomp.add(solcomp);
        insert lstsolcomp;
        
        List<CSS_Solution_Component__c> lstsolcomp1 = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp3 = new CSS_Solution_Component__c();
        solComp3.Component_Id__c ='F0051000';
        solcomp3.Solutions__c = solAdd.id;
        solComp3.Service_Job__c = Jo.id;
        solComp3.Action__c = '';
        solComp3.Type__c = 'Campaign';
        solComp3.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp3.CampaignPartsPercentage__c = '20';
        solcomp3.Performed_Review__c = True;
        solcomp3.Claim_Type__c = 'Test';
        solComp3.Selected_Claim_Type__c = 'Testing';
        solComp3.Performed_Review__c = true;
        solComp3.Status__c = 'Approved';
        solComp3.Complete_Indicator__c =true;
        solComp3.Multiple_Times__c =true;
        solComp3.Fault_Code__c='turbocharger';
        solComp3.AccountCodeType__c  = 'ACCOUNT TEAM COVERAGE';
        solComp3.AccountCode__c = '27';
        solComp3.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        lstsolcomp1.add(solcomp3);
        insert lstsolcomp1;
        
        RecordType rtp = [SELECT id,Name 
                              FROM RecordType 
                              WHERE name='Parts'];
                              
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts2 = new CSS_Parts_Options__c();
        parts2.FailurepartId__c = solcomp.id;
        parts2.Part_Assignment__c = 'Primary';
        parts2.Replacement_Reason__c = 'Select one';
        parts2.selected_part__c = True;
        parts2.Service_partnumber__c = '540571401';
        parts2.OEM__c = 'OEMWRS';
        parts2.Part_Name__c = 'TestPartCamp';
        parts2.ReturnToFactory__c = 'Campaign-TRP-ATC';
        parts2.Replacement_Reason__c = 'Campaign-TRP-ATC';
        parts2.Quantity__c = 55;
        parts2.Notes__c = 'Test Notes';
        parts2.Solutions__c = solAdd.id;
        parts2.recordtypeid = rtp.id;
        parts2.Service_Job__c = Jo.id;
        parts2.Account_Code__c='SERVICE TOOL WARRANTY 52';
        parts2.Fail_Code__c='THAC';
        lstparts.add(parts2); 
        insert lstparts;
        
        
        ApexPages.currentPage().getParameters().put('id',Jo.id);

        TEst.startTest();
        css_repair_job controller = new css_repair_job();
        CG_CL_NestedRepair Nest = new CG_CL_NestedRepair(controller);
        NEst.NSoln = solAdd;
        Nest.rJobOrd = JO;
        Nest.getPartsList();
        NEst.FeedBackVal = solAdd.Repair_Response__c;
        NEst.updateFeedBackForSol();
        Nest.validateResponse();
        Test.stopTest();
        
    }
    
    public static testmethod void CG_CL_NestedRepair_Test7(){
        
        CSS_Job_Order__c Jo =new CSS_Job_Order__c();
        Jo.Customer_Name__c = 'Oliver Trucking';
        Insert JO;
        
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Repair Successful.';
        solAdd.Repair_notes__c = null;
        insert solAdd;
        
        TEst.startTest();
        css_repair_job controller = new css_repair_job();
        CG_CL_NestedRepair Nest = new CG_CL_NestedRepair(controller);
        Nest.selectedSol = solAdd; 
        NEst.srtAccesscheckList();
        Test.stopTest();
        
        
    }
        
    
}