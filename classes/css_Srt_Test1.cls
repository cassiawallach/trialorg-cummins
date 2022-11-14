@isTest
public class css_Srt_Test1
{
    static testMethod void css_Srt_Test1_DiagSRT1()
    {
        Test.setMock(HttpCalloutMock.class, new CSS_Diagnosis_SRT_Test());
        //  Test.setMock(HttpCalloutMock.class, new CSS_Repair_SRT_Test());
        test.starttest();
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250');
        insert job1;
        solutions = new CSS_Solutions__c(Name='K43662142',Service_Job__c=job1.Id);
        insert solutions;
        /*Set<String> UpdatedSRTIDs = new Set<String>();
        UpdatedSRTIDs.add('Test');*/
        List<CSS_SRT__C> SRTs = new List<CSS_SRT__c>();
        CSS_SRT__C diagSRT = new CSS_SRT__C();
        diagSRT.Name ='Test';
        //diagSRT.Component_Id__c='F05000100';
        diagSRT.Type__c='Diagnosis';
        diagSRT.SRT_Type__c='Diagnosis';
        diagSRT.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        diagSRT.SRT_ID__c='asd';
        diagSRT.SRT_Access_Code__c='asdf';
        diagSRT.Solution_Number__c= solutions.id; //K48722870;
        diagSRT.Step_Description__c='Step Number-00';
        diagSRT.Job_Order__c=job1.Id;
        diagSRT.SRT_Quantity__c=1;
        diagSRT.isPerformed__c=True;
        diagSRT.SRT_Time__c=1.1;
        diagSRT.SRT_ORDER__C = 1;
        diagSRT.Assignment__c = 'PRIMARY';
        SRTs.add(diagSRT);
        
        CSS_SRT__C diagSRT1 = new CSS_SRT__C();
        diagSRT1.Name ='Test';
        //diagSRT.Component_Id__c='F05000100';
        diagSRT1.Type__c='Diagnosis';
        diagSRT1.SRT_Type__c='Diagnosis';
        diagSRT1.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        diagSRT1.SRT_ID__c='asd-00';
        diagSRT1.SRT_Access_Code__c='asdf';
        diagSRT1.Solution_Number__c= solutions.id; //K48722870;
        diagSRT1.Step_Description__c='hgfr';
        diagSRT1.Job_Order__c=job1.Id;
        diagSRT1.SRT_Quantity__c=1;
        diagSRT1.isPerformed__c=True;
        diagSRT1.SRT_Time__c=1.1;
        diagSRT1.SRT_ORDER__C = 1;
        diagSRT1.Assignment__c = 'PRIMARY';
        SRTs.add(diagSRT1);
        
        insert SRTs;
        List<CSS_SRT__C> SRTs1 = new List<CSS_SRT__c>();
        CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        //repSRT.Component_Id__c='F05000100';
        repSRT1.Type__c='Repair';
        repSRT1.SRT_Type__c='Repair';
        repSRT1.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        repSRT1.SRT_ID__c='asd-00';
        repSRT1.SRT_Access_Code__c='asdf';
        // repSRT.Solution_Number__c= K48722870;
        repSRT1.Step_Description__c='Step Number-00';
        repSRT1.Job_Order__c=job1.Id;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.SRT_Time__c=1.1;
        repSRT1.SRT_Order__c = 2;
        repSRT1.Assignment__c ='PRIMARY';
        insert repSRT1;
        SRTs1.add(repSRT1);
        Map<ID,String> sol = new Map<ID,String>();
        Map<id,id> jobOrder = new Map<id,id>();
        sol.put(solutions.id,solutions.name);
        jobOrder.put(solutions.id,solutions.Service_Job__c);
        //test.starttest();
        Boolean isRep = false;
        Set<String> UpdatedSRTIDs = new Set<String>();
        UpdatedSRTIDs.add('Test');
        List<css_srt__c> diagSRTtobeUpdated = new list<css_Srt__c>();
        List<css_srt__c> repSRTtobeUpdated = new list<css_Srt__c>();
        CSS_SRT.splreceiveToken('Test');
        CSS_SRT.receiveToken();
        
        
        system.debug('HIIIIIIIIIIIIIIIIIIIIIII');
        CSS_SRT.diagnosticSRT(jobOrder,sol,job1.service_model__c,'a',1.1); 
        Test.stoptest();
        
    }
    //ExistDiagSRT with diff data
    @isTest static void css_Srt_Test1_DiagSRT2()
    {
        Test.setMock(HttpCalloutMock.class, new CSS_Diagnosis_SRT_Test());
        //  Test.setMock(HttpCalloutMock.class, new CSS_Repair_SRT_Test());
        test.starttest();
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250');
        insert job1;
        solutions = new CSS_Solutions__c(Name='K43662142',Service_Job__c=job1.Id);
        insert solutions;
        /*Set<String> UpdatedSRTIDs = new Set<String>();
        UpdatedSRTIDs.add('Test');*/
        List<CSS_SRT__C> SRTs = new List<CSS_SRT__c>();
                
        CSS_SRT__C diagSRT1 = new CSS_SRT__C();
        diagSRT1.Name ='Test';
        //diagSRT.Component_Id__c='F05000100';
        diagSRT1.Type__c='Diagnosis';
        diagSRT1.SRT_Type__c='Diagnosis';
        diagSRT1.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        diagSRT1.SRT_ID__c='asd-00';
        diagSRT1.SRT_Access_Code__c='asdf';
        diagSRT1.Solution_Number__c= solutions.id; //K48722870;
        diagSRT1.Step_Description__c='Step Number-00';
        diagSRT1.Job_Order__c=job1.Id;
        diagSRT1.SRT_Quantity__c=1;
        diagSRT1.isPerformed__c=True;
        diagSRT1.SRT_Time__c=1.1;
        diagSRT1.SRT_ORDER__C = 1;
        diagSRT1.Assignment__c = 'PRIMARY';
        SRTs.add(diagSRT1);
        
        insert SRTs;
        List<CSS_SRT__C> SRTs1 = new List<CSS_SRT__c>();
        CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        //repSRT.Component_Id__c='F05000100';
        repSRT1.Type__c='Repair';
        repSRT1.SRT_Type__c='Repair';
        repSRT1.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        repSRT1.SRT_ID__c='asd-00';
        repSRT1.SRT_Access_Code__c='asdf';
        // repSRT.Solution_Number__c= K48722870;
        repSRT1.Step_Description__c='Step Number-00';
        repSRT1.Job_Order__c=job1.Id;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.SRT_Time__c=1.1;
        repSRT1.SRT_Order__c = 2;
        repSRT1.Assignment__c ='PRIMARY';
        insert repSRT1;
        SRTs1.add(repSRT1);
        Map<ID,String> sol = new Map<ID,String>();
        Map<id,id> jobOrder = new Map<id,id>();
        sol.put(solutions.id,solutions.name);
        jobOrder.put(solutions.id,solutions.Service_Job__c);
        //test.starttest();
        Boolean isRep = false;
        Set<String> UpdatedSRTIDs = new Set<String>();
        UpdatedSRTIDs.add('Test');
        List<css_srt__c> diagSRTtobeUpdated = new list<css_Srt__c>();
        List<css_srt__c> repSRTtobeUpdated = new list<css_Srt__c>();
        CSS_SRT.splreceiveToken('Test');
        CSS_SRT.receiveToken();
        
        
        system.debug('HIIIIIIIIIIIIIIIIIIIIIII');
        CSS_SRT.diagnosticSRT(jobOrder,sol,job1.service_model__c,'a',1.1); 
        Test.stoptest();
        
    }
 
    @isTest static void testRepairSrt(){
        Test.setMock(HttpCalloutMock.class, new CSS_Repair_SRT_Test());
        List<string> solCompAdd = new List<string>();
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        CSS_Solution_Component__c solComp;
        css_claims__C Claim;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',Equipment_ID__c='EQ7667',Qsol_Engine_Family_Code__c='56');
        insert job1;
        system.debug('job1>>>>'+job1);
        
        solutions = new CSS_Solutions__c(Name='K20430055',Service_Job__c=job1.Id);
        insert solutions;
        system.debug('solutions>>>'+solutions);
        solComp = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F19000990',Solutions__c=solutions.Id,Service_Job__c=job1.id);
        insert solComp;
        system.debug('solComp'+solComp);
        Claim = new CSS_Claims__c(CSS_Job__c=job1.Id);
        List<CSS_SRT__C> repairSRT = new List<CSS_SRT__c>();
        CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        repSRT1.Component_Id__c=solComp.id;
        repSRT1.SRT_Type__c='Repair';
        repsrt1.Type__c='Repair';
        repSRT1.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT1.SRT_ID__c='asd-00';
        repSRT1.SRT_Access_Code__c='A';
        repSRT1.Solution_Number__c= solutions.id;
        repSRT1.Step_Description__c='hgfr';
        repSRT1.Job_Order__c=job1.id;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.Access_Code__c='A';
        repSRT1.SRT_Time__c=1.1;
        repsrt1.Assignment__c='PRIMARY';
        repsrt1.css_claims__c = Claim.id;
        repairSRT.add(repSRT1);
        CSS_SRT__C repSRT2 = new CSS_SRT__C();
        repSRT2.Name ='Test1';
        repSRT2.Component_Id__c=solComp.id;
        repSRT2.SRT_Type__c='Repair';
        repSRT2.Type__c='Repair';
        repSRT2.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT2.SRT_ID__c='asd-00';
        repSRT2.SRT_Access_Code__c='C';
        repSRT2.Solution_Number__c= solutions.id;
        repSRT2.Step_Description__c='hgfr';
        repSRT2.Job_Order__c=job1.id;
        repSRT2.SRT_Quantity__c=1;
        repSRT2.Access_Code__c='A';
        repSRT2.isPerformed__c=True;
        repSRT2.SRT_Time__c=1.1;
        repSRT2.Assignment__c='ALTERNATIVE';
        repairSRT.add(repSRT2);
        CSS_SRT__C repSRT3 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Repair';
        repSRT3.Type__c='Repair';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-01';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        repairSRT.add(repSRT3);
        
        CSS_SRT__C repSRT4 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diag Access';
        repSRT3.Type__c='Diag Access';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-00';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        //repSRT3.CSS_CLaims__C=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        repairSRT.add(repSRT4);
        
        CSS_SRT__C repSRT5 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diagnosis';
        repSRT3.Type__c='Diagnosis';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-00';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PRIMARY';
        repairSRT.add(repSRT5);
        
        CSS_SRT__C repSRT6 = new CSS_SRT__C();
        repSRT3.Name ='Test3';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diagnosis';
        repSRT3.Type__c='Diagnosis';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='Step Number-00';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PRIMARY';
        repairSRT.add(repSRT6);
        
        insert repairSRT;
        system.debug('job1>>>>'+job1);
        system.debug('repSRT1>>>>'+repairSRT);
        
        CSS_SRT__c srtcheck =[SELECT id, Job_Order__c, SRT_ID__c, Assignment__c, SRT_Access_Code__c FROM CSS_SRT__c WHERE (Job_Order__c =:job1.id AND (type__c = 'Repair' OR type__c = 'Repair Access')) limit 1];
        system.debug('srtcheck>>>'+srtcheck);
        //solCompAdd.add(JSON.Serialize(new solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',1.1)));
        test.startTest();
        
        Boolean isRep = false;
        //Test.setMock(HttpCalloutMock.class, new CSS_Repair_SRT_Test());
        
        CSS_SRT.solCompWrapper comp =new CSS_SRT.solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null);
        solCompAdd.add(JSON.Serialize(comp));
        CSS_SRT.repairSRT(solCompAdd);
        double data = 120.00;
        String json = '{ '+
            
'\"solID\": \"'+solutions.id+'\", '+
'\"jobID\": \"'+job1.id+'\", '+
'\"serviceModel\": \"serviceModel\", '+
'\"equipID\": \"equipID\", '+
'\"compID\": \"'+solComp.id+'\", '+
'\"efc\": \"efc\", '+
'\"compoName\": \"compoName\" '+
'\"jobName\": \"jobName\" '+
        '\"claimID\": \"'+data+'\" '+
            
'}';
        List<String> lst = new List<String>();
        lst.add(json);
        css_srt.repairSRTManualClaim(solCompAdd);
        test.stopTest();
    }
    @isTest static void testRepairSrt1(){
        Test.setMock(HttpCalloutMock.class, new CSS_Repair_SRT_Sec_Test());
        List<string> solCompAdd = new List<string>();
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        CSS_Solution_Component__c solComp;
        css_claims__C Claim;
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',Equipment_ID__c='EQ7667',Qsol_Engine_Family_Code__c='56');
        insert job1;
        system.debug('job1>>>>'+job1);
        
        solutions = new CSS_Solutions__c(Name='K20430055',Service_Job__c=job1.Id);
        insert solutions;
        system.debug('solutions>>>'+solutions);
        solComp = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F19000990',Solutions__c=solutions.Id,Service_Job__c=job1.id);
        insert solComp;
        system.debug('solComp'+solComp);
        Claim = new CSS_Claims__c(CSS_Job__c=job1.Id);
        List<CSS_SRT__C> repairSRT = new List<CSS_SRT__c>();
        CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        repSRT1.Component_Id__c=solComp.id;
        repSRT1.SRT_Type__c='Repair';
        repsrt1.Type__c='Repair';
        repSRT1.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT1.SRT_ID__c='asd-00';
        repSRT1.SRT_Access_Code__c='A';
        repSRT1.Solution_Number__c= solutions.id;
        repSRT1.Step_Description__c='hgfr';
        repSRT1.Job_Order__c=job1.id;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.Access_Code__c='A';
        repSRT1.SRT_Time__c=1.1;
        repsrt1.Assignment__c='PRIMARY';
        repsrt1.css_claims__c = Claim.id;
        repairSRT.add(repSRT1);
        CSS_SRT__C repSRT2 = new CSS_SRT__C();
        repSRT2.Name ='Test1';
        repSRT2.Component_Id__c=solComp.id;
        repSRT2.SRT_Type__c='Repair';
        repSRT2.Type__c='Repair';
        repSRT2.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT2.SRT_ID__c='asd-00';
        repSRT2.SRT_Access_Code__c='C';
        repSRT2.Solution_Number__c= solutions.id;
        repSRT2.Step_Description__c='hgfr';
        repSRT2.Job_Order__c=job1.id;
        repSRT2.SRT_Quantity__c=1;
        repSRT2.Access_Code__c='A';
        repSRT2.isPerformed__c=True;
        repSRT2.SRT_Time__c=1.1;
        repSRT2.Assignment__c='ALTERNATIVE';
        repairSRT.add(repSRT2);
        CSS_SRT__C repSRT3 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Repair';
        repSRT3.Type__c='Repair';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-01';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        repairSRT.add(repSRT3);
        
        CSS_SRT__C repSRT4 = new CSS_SRT__C();
        repSRT3.Name ='Test20';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diag Access';
        repSRT3.Type__c='Diag Access';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-00';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        //repSRT3.CSS_CLaims__C=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        insert repSRT4;
        //repairSRT.add(repSRT4);
        
        CSS_SRT__C repSRT5 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diagnosis';
        repSRT3.Type__c='Diagnosis';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-00';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PRIMARY';
        repairSRT.add(repSRT5);
        
        CSS_SRT__C repSRT6 = new CSS_SRT__C();
        repSRT3.Name ='Test3';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diagnosis';
        repSRT3.Type__c='Diagnosis';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PRIMARY';
        repairSRT.add(repSRT6);
        
        insert repairSRT;
        system.debug('job1>>>>'+job1);
        system.debug('repSRT1>>>>'+repairSRT);
        
        CSS_SRT__c srtcheck =[SELECT id, Job_Order__c, SRT_ID__c, Assignment__c, SRT_Access_Code__c FROM CSS_SRT__c WHERE (Job_Order__c =:job1.id AND (type__c = 'Repair' OR type__c = 'Repair Access')) limit 1];
        system.debug('srtcheck>>>'+srtcheck);
        //solCompAdd.add(JSON.Serialize(new solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',1.1)));
        test.startTest();
        
        Boolean isRep = false;
        //Test.setMock(HttpCalloutMock.class, new CSS_Repair_SRT_Test());
        
        CSS_SRT.solCompWrapper comp =new CSS_SRT.solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null);
        solCompAdd.add(JSON.Serialize(comp));
        CSS_SRT.repairSRT(solCompAdd);
        double data = 120.00;
        String json = '{ '+
            
'\"solID\": \"'+solutions.id+'\", '+
'\"jobID\": \"'+job1.id+'\", '+
'\"serviceModel\": \"serviceModel\", '+
'\"equipID\": \"equipID\", '+
'\"compID\": \"'+solComp.id+'\", '+
'\"efc\": \"efc\", '+
'\"compoName\": \"compoName\" '+
'\"jobName\": \"jobName\" '+
        '\"claimID\": \"'+data+'\" '+
            
'}';
        List<String> lst = new List<String>();
        lst.add(json);
        css_srt.repairSRTManualClaim(solCompAdd);
        test.stopTest();
    }
    @isTest static void testRepairSrt2(){
        Test.setMock(HttpCalloutMock.class, new CSS_MockRepair_SRT_Test());
        List<string> solCompAdd = new List<string>();
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        CSS_Solution_Component__c solComp;
        
        
        
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='ISX15 CM2250',Equipment_ID__c='EQ7667',Qsol_Engine_Family_Code__c='56');
        insert job1;
        system.debug('job1>>>>'+job1);
        
        css_claims__c clams = new css_claims__c();
        clams.Customer_Name__c='Gopal';
        clams.Customer_Code__c='123';
        clams.ESN__c='53426754';
        clams.CSS_Job__c=job1.Id;
        clams.Actual_Technician_Time__c=2.0;
        insert clams;
        
        solutions = new CSS_Solutions__c(Name='K20430055',Service_Job__c=job1.Id);
        insert solutions;
        system.debug('solutions>>>'+solutions);
        solComp = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F19000990',Solutions__c=solutions.Id,Service_Job__c=job1.id,css_claims__c=clams.id);
        insert solComp;
        system.debug('solComp'+solComp);
        
        
        
        List<CSS_SRT__C> repairSRT = new List<CSS_SRT__c>();
        CSS_SRT__C repSRT1 = new CSS_SRT__C();
        repSRT1.Name ='Test';
        repSRT1.Component_Id__c=solComp.id;
        repSRT1.SRT_Type__c='Repair';
        repsrt1.Type__c='Repair';
        repSRT1.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT1.SRT_ID__c='asd-00';
        repSRT1.SRT_Access_Code__c='A';
        repSRT1.Solution_Number__c= solutions.id;
        repSRT1.Step_Description__c='hgfr';
        repSRT1.Job_Order__c=job1.id;
        repSRT1.SRT_Quantity__c=1;
        repSRT1.isPerformed__c=True;
        repSRT1.Access_Code__c='A';
        repSRT1.SRT_Time__c=1.1;
        repsrt1.Assignment__c='PRIMARY';
        repsrt1.css_claims__c = Clams.id;
        repairSRT.add(repSRT1);
        CSS_SRT__C repSRT2 = new CSS_SRT__C();
        repSRT2.Name ='Test1';
        repSRT2.Component_Id__c=solComp.id;
        repSRT2.SRT_Type__c='Repair';
        repSRT2.Type__c='Repair';
        repSRT2.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT2.SRT_ID__c='asd-00';
        repSRT2.SRT_Access_Code__c='C';
        repSRT2.Solution_Number__c= solutions.id;
        repSRT2.Step_Description__c='hgfr';
        repSRT2.Job_Order__c=job1.id;
        repSRT2.SRT_Quantity__c=1;
        repSRT2.Access_Code__c='A';
        repSRT2.isPerformed__c=True;
        repSRT2.SRT_Time__c=1.1;
        repSRT2.Assignment__c='ALTERNATIVE';
        repairSRT.add(repSRT2);
        CSS_SRT__C repSRT3 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Repair';
        repSRT3.Type__c='Repair';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-01';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        repairSRT.add(repSRT3);
        
        CSS_SRT__C repSRT4 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diag Access';
        repSRT3.Type__c='Diag Access';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-00';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='hgfr';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        //repSRT3.CSS_CLaims__C=1.1;
        repSRT3.Assignment__c='PROGRESSIVE DAMAGE';
        repairSRT.add(repSRT4);
        
        CSS_SRT__C repSRT5 = new CSS_SRT__C();
        repSRT3.Name ='Test2';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diagnosis';
        repSRT3.Type__c='Diagnosis';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd-00';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='Step Number-00';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PRIMARY';
        repairSRT.add(repSRT5);
        
        CSS_SRT__C repSRT6 = new CSS_SRT__C();
        repSRT3.Name ='Test3';
        repSRT3.Component_Id__c=solComp.id;
        repSRT3.SRT_Type__c='Diagnosis';
        repSRT3.Type__c='Diagnosis';
        repSRT3.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT3.SRT_ID__c='asd';
        repSRT3.SRT_Access_Code__c='A';
        repSRT3.Solution_Number__c= solutions.id;
        repSRT3.Step_Description__c='Step Number-00';
        repSRT3.Job_Order__c=job1.id;
        repSRT3.SRT_Quantity__c=1;
        repSRT3.Access_Code__c='A';
        repSRT3.isPerformed__c=True;
        repSRT3.SRT_Time__c=1.1;
        repSRT3.Assignment__c='PRIMARY';
        repairSRT.add(repSRT6);
        
        CSS_SRT__C repSRT7 = new CSS_SRT__C();
        repSRT7.Name ='Test2';
        repSRT7.Component_Id__c=solComp.id;
        repSRT7.SRT_Type__c='Repair';
        repSRT7.Type__c='Repair';
        repSRT7.SRT_Title__c='INSITE-se During Troubleshooting';
        repSRT7.SRT_ID__c='asd-00';
        repSRT7.SRT_Access_Code__c='A';
        repSRT7.Solution_Number__c= solutions.id;
        repSRT7.Step_Description__c='hgfr';
        repSRT7.Job_Order__c=job1.id;
        repSRT7.CSS_Claims__C=clams.id;
        repSRT7.SRT_Quantity__c=1;
        repSRT7.Access_Code__c='A';
        repSRT7.isPerformed__c=True;
        repSRT7.SRT_Time__c=1.1;
        repSRT7.Assignment__c='PROGRESSIVE DAMAGE';
        //repairSRT.add(repSRT7);
        insert repSRT7;
        insert repairSRT;
        system.debug('job1>>>>'+job1);
        system.debug('repSRTKal>>>>'+repSRT7);
        system.debug('repSRT1>>>>'+repairSRT);
        
        CSS_SRT__c srtcheck =[SELECT id, Job_Order__c, SRT_ID__c, Assignment__c, SRT_Access_Code__c FROM CSS_SRT__c WHERE (Job_Order__c =:job1.id AND (type__c = 'Repair' OR type__c = 'Repair Access')) limit 1];
        system.debug('srtcheck>>>'+srtcheck);
        //solCompAdd.add(JSON.Serialize(new solCompWrapper(solComp.Solutions__c,solComp.Service_Job__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',1.1)));
        test.startTest();
        
        Boolean isRep = false;
        //Test.setMock(HttpCalloutMock.class, new CSS_Repair_SRT_Test());
        
        CSS_SRT.solCompWrapper comp =new CSS_SRT.solCompWrapper(solComp.Solutions__c,solComp.css_claims__c,solComp.Service_Model__c,solComp.Equip_ID__c,solComp.id,solComp.Engine_Family_Code__c,solComp.Component_Id__c,'A',null);
        solCompAdd.add(JSON.Serialize(comp));
        CSS_SRT.repairSRT(solCompAdd);
        double data = 120.00;
        String json = '{ '+
            
'\"solID\": \"'+solutions.id+'\", '+
'\"jobID\": \"'+job1.id+'\", '+
'\"serviceModel\": \"serviceModel\", '+
'\"equipID\": \"equipID\", '+
'\"compID\": \"'+solComp.id+'\", '+
'\"efc\": \"efc\", '+
'\"compoName\": \"compoName\" '+
'\"jobName\": \"jobName\" '+
        '\"claimID\": \"'+data+'\" '+
            
'}';
        List<String> lst = new List<String>();
        lst.add(json);
        css_srt.repairSRTManualClaim(solCompAdd);
        test.stopTest();
    }
}