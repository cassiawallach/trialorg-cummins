//Adding Comment to check   code coverage--Piyush
@isTest
public class FSL_CL_GETSOLUTIONS_Test {
    @isTest
    static void FSL_SymptomfcSearchMethod(){
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getQSOLToken';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'FSL_GetApiToken_QSOL';
        insert conDetails;
        
        CSS_Integration_Details__c conDetails4 = new CSS_Integration_Details__c();
        conDetails4.End_Point__c = 'https//test.com/getRetrieveOptionList';
        conDetails4.Passcode__c = 'Admin';
        conDetails4.Username__c = 'Admin';
        conDetails4.Name = 'FSL_QSOL_RetrieveOptionList'; 
        insert conDetails4;
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        Id recTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Options').getRecordTypeId();
        
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
        insert con;
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;added comment
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644334';
        ase.Application_Code__c='234';
        insert ase;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        //  oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST ST Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c = '02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        ServiceTerritory st1= new ServiceTerritory();
        st1.name = 'TEST ST1 Mobile';
        st1.OperatingHoursId=oh.id;
        st1.IsActive=true;
        st1.Location_Code__c='05550-03941';
        st1.FSL_Service_Territory_Code__c = '03941';
        st1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st1.Territory__c = 'AUSTRALIA';
        insert st1;
        
        case cs=new case();
        cs.AccountId=acc.id;
        cs.ContactId=con.id;
        cs.AssetId=ase.id;
        //cs.Category1__c='Leak';
        //cs.Category1__c='AIR LEAK';
        //09/10/2020 ; Rajashekar N ; No Longer needed General_Symptoms__c field; 
            //Replaced with description filed 
       // cs.General_Symptoms__c='test symptoms';
       cs.Description = 'test symptoms';
        cs.Service_Territory__c=st.id;
        //cs.ServiceJob__c=wo.id;
        cs.BusinessHoursId=bhs.id;
        insert cs;
        
        workorder wo=new workorder();
        wo.ServiceTerritoryId=st.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.CaseId=cs.id;
        wo.SelectedSolution__c='abc';
        // wo.FaultCodeId__c='1167';
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId     = recdtypeId;
        //wo.Repair_Solution__c  = sol.Id;
        // wo.Branch_Code__c=5123;
        
        insert wo;
        
        wo.ServiceTerritoryId=st1.Id;
        FSL_workorderListTriggerHandle.avoidAfterupdate = true;
        FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
        //update wo;
        FSL_Symptom__c symp= new FSL_Symptom__c();
        symp.Name='symptom test';
        symp.Symptom__c='Black Smoke';
        symp.Symptom_Category__c='Exhaust Smoke Color';
        insert symp;
        
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        
        List<CSS_Fault_Code__c> listFaultCode = new List<CSS_Fault_Code__c>();
        for(Integer i = 0; i < 4 ; i++){
            CSS_Fault_Code__c objFaultCode = new CSS_Fault_Code__c();
            objFaultCode.Name = 'Test Fault Code' + i;
            objFaultCode.Fault_Code_Type__c = '1';
            objFaultCode.Number_of_Solutions__c = '4';
            objFaultCode.sequence__c = 2;
            objFaultCode.Service_Order__c = wo.Id; 
            listFaultCode.add(objFaultCode);
        }     
        insert listFaultCode; 
        
        test.startTest();
        List<CSS_Solutions__c> listSolutions = new List<CSS_Solutions__c>();        
        for(Integer i = 0; i < 2 ; i++){
            CSS_Solutions__c objSolutions = new CSS_Solutions__c();
            objSolutions.FSL_Service_Job__c = wo.Id;
            objSolutions.FaultCode__c = listFaultCode[i].Id;              
            objSolutions.userTimestamp__c = system.now() - i;
            listSolutions.add(objSolutions);
        }      
        CSS_Solutions__c objSolutions = new CSS_Solutions__c();
        objSolutions.FaultCode__c = listFaultCode[0].Id;    
         objSolutions.FSL_Service_Job__c = wo.Id;
        objSolutions.userTimestamp__c = system.now();
        listSolutions.add(objSolutions);
        insert listSolutions;
        
        List<FSL_SRT__c> ListSRT = new List<FSL_SRT__c>();
        FSL_SRT__c objSRT1 = new FSL_SRT__c();
        objSRT1.CSS_Fault_Code__c = listFaultCode[0].Id;
        objSRT1.Solution_Number__c = listSolutions[0].Id;
        objSRT1.Service_Order__c = wo.Id;
        objSRT1.SRT_Select__c = true;
        objSRT1.SRT_Time__c = 1.0;
        objSRT1.Type__c = 'Diagnosis';
        ListSRT.add(objSRT1);
        
        FSL_SRT__c objSRT2 = new FSL_SRT__c();
        objSRT2.CSS_Fault_Code__c = listFaultCode[0].Id;
        objSRT2.Solution_Number__c = listSolutions[0].Id;
        objSRT2.Service_Order__c = wo.Id;
        objSRT2.SRT_Select__c = true;
        objSRT2.SRT_Time__c = 1.0;
        objSRT2.Type__c = 'Diagnosis';
        ListSRT.add(objSRT2);
        
        insert ListSRT;
        
        
        FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
        spnfc.SPN__c ='3597-2';
        spnfc.Name = '3597-2';
        insert spnfc;
        FSL_PCode__c pfc= new FSL_PCode__c();
        pfc.CDS_ID__c='p008';
        pfc.Name='p008';
        insert pfc;
        
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        //fcode.Fault_Code__c=cfc.id;
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = wo.id;
        fcode.extfield__c = cfc.id+' '+wo.id;
        insert fcode;
        
        FSL_workorderListTriggerHandle.avoidAfterupdate =true;
        FSL_workorderListTriggerHandle.avoidBeforeUpdate =true;
        FSL_workorderListTriggerHandle.is4CInsertRun=true;
       FSL_workorderListTriggerHandle.runWarrantyService=true;
        FSL_workorderListTriggerHandle.isSOCInsert=true;
        FSL_workorderListTriggerHandle.isSOCInsert1=true;
      //  wo.FaultCodeId__c=fcode.id;
        update wo;
        
        List<CSS_Fault_Code__c> lstInsFC = new List<CSS_Fault_Code__c>();
        CSS_Fault_Code__c spnfmi=new CSS_Fault_Code__c();
        spnfmi.Name=spnfc.name;
        //fcode.Fault_Code__c=cfc.id;
        spnfmi.Type__c = 'Fault';
        spnfmi.Fault_Code_Type__c = '2';
        spnfmi.Service_Order__c = wo.id;
        spnfmi.extfield__c = spnfc.id+' '+wo.id;
        lstInsFC.add(spnfmi);
        
        CSS_Fault_Code__c pcode=new CSS_Fault_Code__c();
        pcode.Name=pfc.name;
        //fcode.Fault_Code__c=cfc.id;
        pcode.Type__c = 'Fault';
        pcode.Fault_Code_Type__c = '3';
        pcode.Service_Order__c = wo.id;
        pcode.extfield__c = pfc.id+' '+wo.id;
        lstInsFC.add(pcode);
        
        CSS_Fault_Code__c symptoms=new CSS_Fault_Code__c();
        symptoms.Name=symp.Symptom__c;
        //fcode.Fault_Code__c=cfc.id;
        symptoms.Type__c = 'Symptom';
        symptoms.Fault_Code_Type__c = '0';
        symptoms.Service_Order__c = wo.id;
        symptoms.extfield__c = symp.id+' '+wo.id;
        lstInsFC.add(symptoms);
        
        insert lstInsFC;
        
        
        CSS_Parts_Options__c cssOptions = new CSS_Parts_Options__c();
        cssOptions.RecordTypeId = recTypeId;
        cssOptions.Option_Number__c = '4352144';
        cssOptions.Repair_Group__c = '17.02';
        cssOptions.Part_Description__c = 'Upper Engine Gasket Set';
        cssOptions.Service_Order__c = wo.Id;
        cssOptions.Option_ESN__c = ase.name;         
        insert cssOptions;
        
        
        CSS_Solutions__c sol= new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        sol.userTimestamp__c=datetime.now();
        sol.Unique_Solution__c='T00000690'+'-'+fcode.id;
        sol.FSL_Service_Job__c=wo.id;
        insert sol;
        
         
        //
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_CL_GETSOLUTIONS.changeRecord(wo.id,fcode.id);
        FSL_CL_GETSOLUTIONS.changesolRecord(wo.id,sol.id);
        FSL_CL_GETSOLUTIONS.updatesolRecordtd(wo.id,sol.id);
        FSL_CL_GETSOLUTIONS.getknowledge(sol.id);
        //FSL_CL_GETSOLUTIONS.wrapRec(wo.id,spnfc.id,cfc.id,pfc.Id,'Exhaust Smoke Color','Black Smoke');
        //FSL_CL_GETSOLUTIONS.wrapRecTable(wo.id,spnfc.id,cfc.id,pfc.Id,'Exhaust Smoke Color','Black Smoke');
        
        // FSL_CL_QSOLIntegrations.CallForOptionList('79788868');
        
        //FSL_CL_GETSOLUTIONS.getSolutionTable(wo.id);
        test.stopTest();
        
    }
    
        
    @isTest 
    static void FSL_SymptomfcSearchMethodII(){
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getQSOLToken';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'FSL_GetApiToken_QSOL';
        insert conDetails;
        
        CSS_Integration_Details__c conDetails4 = new CSS_Integration_Details__c();
        conDetails4.End_Point__c = 'https//test.com/getRetrieveOptionList';
        conDetails4.Passcode__c = 'Admin';
        conDetails4.Username__c = 'Admin';
        conDetails4.Name = 'FSL_QSOL_RetrieveOptionList'; 
        insert conDetails4;
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        Id recTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Options').getRecordTypeId();
        
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
        insert con;
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;added comment
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644334';
        ase.Application_Code__c='234';
        insert ase;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        //  oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST ST Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c = '02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        ServiceTerritory st1= new ServiceTerritory();
        st1.name = 'TEST ST1 Mobile';
        st1.OperatingHoursId=oh.id;
        st1.IsActive=true;
        st1.Location_Code__c='05550-03941';
        st1.FSL_Service_Territory_Code__c = '03941';
        st1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st1.Territory__c = 'AUSTRALIA';
        insert st1;
        
        case cs=new case();
        cs.AccountId=acc.id;
        cs.ContactId=con.id;
        cs.AssetId=ase.id;
        //cs.Category1__c='Leak';
        //cs.Category1__c='AIR LEAK';
        //09/10/2020 ; Rajashekar N ; No Longer needed General_Symptoms__c field; 
            //Replaced with description filed 
       // cs.General_Symptoms__c='test symptoms';
       cs.Description = 'test symptoms';
        cs.Service_Territory__c=st.id;
        //cs.ServiceJob__c=wo.id;
        cs.BusinessHoursId=bhs.id;
        insert cs;
        
        workorder wo=new workorder();
        wo.ServiceTerritoryId=st.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.CaseId=cs.id;
        wo.SelectedSolution__c='abc';
        // wo.FaultCodeId__c='1167';
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId     = recdtypeId;
        //wo.Repair_Solution__c  = sol.Id;
        // wo.Branch_Code__c=5123;
        
        insert wo;
        
        wo.ServiceTerritoryId=st1.Id;
        FSL_workorderListTriggerHandle.avoidAfterupdate = true;
        FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
        //update wo;
        FSL_Symptom__c symp= new FSL_Symptom__c();
        symp.Name='symptom test';
        symp.Symptom__c='Black Smoke';
        symp.Symptom_Category__c='Exhaust Smoke Color';
        insert symp;
        
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        
        List<CSS_Fault_Code__c> listFaultCode = new List<CSS_Fault_Code__c>();
        for(Integer i = 0; i < 4 ; i++){
            CSS_Fault_Code__c objFaultCode = new CSS_Fault_Code__c();
            objFaultCode.Name = 'Test Fault Code' + i;
            objFaultCode.Fault_Code_Type__c = '1';
            objFaultCode.Number_of_Solutions__c = '4';
            objFaultCode.sequence__c = 2;
            objFaultCode.Service_Order__c = wo.Id; 
            listFaultCode.add(objFaultCode);
        }     
        insert listFaultCode; 
        
        test.startTest();
        List<CSS_Solutions__c> listSolutions = new List<CSS_Solutions__c>();        
        for(Integer i = 0; i < 2 ; i++){
            CSS_Solutions__c objSolutions = new CSS_Solutions__c();
            objSolutions.FSL_Service_Job__c = wo.Id;
            objSolutions.FaultCode__c = listFaultCode[i].Id;              
            objSolutions.userTimestamp__c = system.now() - i;
            listSolutions.add(objSolutions);
        }      
        CSS_Solutions__c objSolutions = new CSS_Solutions__c();
        objSolutions.FaultCode__c = listFaultCode[0].Id;    
         objSolutions.FSL_Service_Job__c = wo.Id;
        objSolutions.userTimestamp__c = system.now();
        listSolutions.add(objSolutions);
        insert listSolutions;
        
        List<FSL_SRT__c> ListSRT = new List<FSL_SRT__c>();
        FSL_SRT__c objSRT1 = new FSL_SRT__c();
        objSRT1.CSS_Fault_Code__c = listFaultCode[0].Id;
        objSRT1.Solution_Number__c = listSolutions[0].Id;
        objSRT1.Service_Order__c = wo.Id;
        objSRT1.SRT_Select__c = true;
        objSRT1.SRT_Time__c = 1.0;
        objSRT1.Type__c = 'Diagnosis';
        ListSRT.add(objSRT1);
        
        FSL_SRT__c objSRT2 = new FSL_SRT__c();
        objSRT2.CSS_Fault_Code__c = listFaultCode[0].Id;
        objSRT2.Solution_Number__c = listSolutions[0].Id;
        objSRT2.Service_Order__c = wo.Id;
        objSRT2.SRT_Select__c = true;
        objSRT2.SRT_Time__c = 1.0;
        objSRT2.Type__c = 'Diagnosis';
        ListSRT.add(objSRT2);
        
        insert ListSRT;
        
        
        FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
        spnfc.SPN__c ='3597-2';
        spnfc.Name = '3597-2';
        insert spnfc;
        FSL_PCode__c pfc= new FSL_PCode__c();
        pfc.CDS_ID__c='p008';
        pfc.Name='p008';
        insert pfc;
        
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        //fcode.Fault_Code__c=cfc.id;
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = wo.id;
        fcode.extfield__c = cfc.id+' '+wo.id;
        insert fcode;
        
        FSL_workorderListTriggerHandle.avoidAfterupdate =true;
        FSL_workorderListTriggerHandle.avoidBeforeUpdate =true;
        FSL_workorderListTriggerHandle.is4CInsertRun=true;
        FSL_workorderListTriggerHandle.runWarrantyService=true;
        FSL_workorderListTriggerHandle.isSOCInsert=true;
        FSL_workorderListTriggerHandle.isSOCInsert1=true;
       // wo.FaultCodeId__c=fcode.id;
       // update wo;
        
        List<CSS_Fault_Code__c> lstInsFC = new List<CSS_Fault_Code__c>();
        CSS_Fault_Code__c spnfmi=new CSS_Fault_Code__c();
        spnfmi.Name=spnfc.name;
        //fcode.Fault_Code__c=cfc.id;
        spnfmi.Type__c = 'Fault';
        spnfmi.Fault_Code_Type__c = '2';
        spnfmi.Service_Order__c = wo.id;
        spnfmi.extfield__c = spnfc.id+' '+wo.id;
        lstInsFC.add(spnfmi);
        
        CSS_Fault_Code__c pcode=new CSS_Fault_Code__c();
        pcode.Name=pfc.name;
        //fcode.Fault_Code__c=cfc.id;
        pcode.Type__c = 'Fault';
        pcode.Fault_Code_Type__c = '3';
        pcode.Service_Order__c = wo.id;
        pcode.extfield__c = pfc.id+' '+wo.id;
        lstInsFC.add(pcode);
        
        CSS_Fault_Code__c symptoms=new CSS_Fault_Code__c();
        symptoms.Name=symp.Symptom__c;
        //fcode.Fault_Code__c=cfc.id;
        symptoms.Type__c = 'Symptom';
        symptoms.Fault_Code_Type__c = '0';
        symptoms.Service_Order__c = wo.id;
        symptoms.extfield__c = symp.id+' '+wo.id;
        lstInsFC.add(symptoms);
        
        insert lstInsFC;
        
        
        CSS_Parts_Options__c cssOptions = new CSS_Parts_Options__c();
        cssOptions.RecordTypeId = recTypeId;
        cssOptions.Option_Number__c = '4352144';
        cssOptions.Repair_Group__c = '17.02';
        cssOptions.Part_Description__c = 'Upper Engine Gasket Set';
        cssOptions.Service_Order__c = wo.Id;
        cssOptions.Option_ESN__c = ase.name;         
        insert cssOptions;
        
        
        CSS_Solutions__c sol= new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        sol.userTimestamp__c=datetime.now();
        sol.Unique_Solution__c='T00000690'+'-'+fcode.id;
        sol.FSL_Service_Job__c=wo.id;
        insert sol;
        
         
        //
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
       //FSL_CL_GETSOLUTIONS.changeRecord(wo.id,fcode.id);
        //FSL_CL_GETSOLUTIONS.changesolRecord(wo.id,sol.id);
        //FSL_CL_GETSOLUTIONS.updatesolRecordtd(wo.id,sol.id);
        //FSL_CL_GETSOLUTIONS.getknowledge(sol.id);
        FSL_CL_GETSOLUTIONS.wrapRec(wo.id,spnfc.id,cfc.id,pfc.Id,'Exhaust Smoke Color','Black Smoke');
        FSL_CL_GETSOLUTIONS.wrapRecTable(wo.id,spnfc.id,cfc.id,pfc.Id,'Exhaust Smoke Color','Black Smoke');
        
        //FSL_CL_QSOLIntegrations.CallForOptionList('79788868');
        
        FSL_CL_GETSOLUTIONS.getSolutionTable(wo.id);
        test.stopTest();
        
    }
}