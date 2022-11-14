//Adding comment for deployment ---- Sriprada S
@isTest
public class FSL_SymptomfcSearch_Test {
    public static testmethod void FSL_SymptomfcSearchMethod(){ //GIT push2
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        String JSON = '{"ToolId":"Guidanz Web","Contentflag":false,"JobNumber":"00001613","UserID":"AB123","WorkgroupID":"ALBANY-EAST-ALBANY-02024","Usertype":"Dealer","Userrole":"Technician","PGAGroup":"PGA 01","Customername":"Kenworth","Unitnumber":"","ShopWONumber":"123456","ESN":"79797979","SMN":"ISX15 CM2350 X101","Domain":"Engine","ApplicationCode":"130","Applicationdescription":"Automotive","Marketingconfigurationcode":"BB","Generatornumber":"C1600 N5CD","Alternatornumber":"C1600 N5CD","Controllername":"Deif","PSBUPlant":"CPG â€“ UK","PSBUModel":"C550 D5","PSBUSpec":"A","ECMCode":"A01031.01","Make":"Kenworth","Model":"T800","Faulttype":"1","FaultCodelist":[{"CumminsFaultCode":"7922","SPN":"","FMI":"","PCode":""}],"Highlevelsymptom":"Exhaust Smoke Color","Lowlevelsymptom":"Black Smoke","Complaintcode":"302","Offlineflag":true,"Repeatvisitflag":true,"Reconflag":true,"EngineMileage":"345213","Mileageunit":"km","Enginehours":"212321","VIN":"1XKYD49X5EJ392882","Languagekey":"en"}';
        //test
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        insert acc;
        test.startTest();
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.email='priyanka.thotakura@cummins.com';
        con.AccountId=acc.id;
        insert con; 
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.AccountId=acc.Id;//using account id as ase account id
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644334';
        ase.Application_Code__c='234';
        insert ase;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST ST Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        ServiceTerritory st1= new ServiceTerritory();
        st1.name = 'TEST ST1 Mobile';
        st1.OperatingHoursId=oh.id;
        st1.IsActive=true;
        st1.Location_Code__c='05550-03941';
        st1.FSL_Service_Territory_Code__c='03941';
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
        wo.Fault_Code_Communication_Trigger__c=true; //new
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId     = recdtypeId;
        //wo.Repair_Solution__c  = sol.Id;
        // wo.Branch_Code__c=5123;
        
        insert wo;
        wo.ServiceTerritoryId=st1.Id;
        update wo;
        
        FSL_Symptom__c symp= new FSL_Symptom__c();
        symp.Name='symptom test';
        symp.Symptom__c='Black Smoke';
        symp.Symptom_Category__c='Exhaust Smoke Color';
        insert symp;
        
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        
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
        
        CSS_Fault_Code__c spnfmi=new CSS_Fault_Code__c();
        spnfmi.Name=spnfc.name;
        //fcode.Fault_Code__c=cfc.id;
        spnfmi.Type__c = 'Fault';
        spnfmi.Fault_Code_Type__c = '2';
        spnfmi.Service_Order__c = wo.id;
        spnfmi.extfield__c = spnfc.id+' '+wo.id;
        insert spnfmi;
        
        CSS_Fault_Code__c pcode=new CSS_Fault_Code__c();
        pcode.Name=pfc.name;
        //fcode.Fault_Code__c=cfc.id;
        pcode.Type__c = 'Fault';
        pcode.Fault_Code_Type__c = '3';
        pcode.Service_Order__c = wo.id;
        pcode.extfield__c = pfc.id+' '+wo.id;
        insert pcode;
        
        CSS_Fault_Code__c symptoms=new CSS_Fault_Code__c();
        symptoms.Name=symp.Symptom__c;
        //fcode.Fault_Code__c=cfc.id;
        symptoms.Type__c = 'Symptom';
        symptoms.Fault_Code_Type__c = '0';
        symptoms.Service_Order__c = wo.id;
        symptoms.extfield__c = symp.id+' '+wo.id;
        insert symptoms;
        
        CSS_Solutions__c sol= new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.FSL_Service_Job__c = wo.Id;
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        insert sol;
        
        CSS_Integration_Details__c setting = new CSS_Integration_Details__c();
        setting.Name = 'FSL_CDS_GetSolutions';
        setting.AuthEnv__c = 'CDS_GetTokenSolutionStg';
        setting.End_Point__c='https://cdssolutions-stg.cummins.com/api/GetSolution';
        setting.Username__c='562e164f-f255-4eff-9c29-3ceed139c0dd';
        setting.Passcode__c='nFdnKFgXVjKg5JZTOmA2zzCaSUgh0FZi6GXvJBYFV4M=';
        setting.Method_Type__c='POST';
        setting.Timeout__c=120000;
        insert setting;
        
        StaticResourceCalloutMock mock1 = new StaticResourceCalloutMock();
        mock1.setStaticResource('FSL_CDSaccessToken');
        mock1.setStatusCode(200);
        mock1.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock1);
        
        //FSL_SymptomFCSearch_Request_Wrap rewrap=new FSL_SymptomFCSearch_Request_Wrap();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('FSL_fcresponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        
        /* StaticResourceCalloutMock mock3 = new StaticResourceCalloutMock();
mock3.setStaticResource('FSL_symptomresponse');
mock3.setStatusCode(200);
mock3.setHeader('Content-Type', 'application/json');
Test.setMock(HttpCalloutMock.class, mock3); */
        
        test.stopTest();
        CG_OP_OAGWrapper returnWrapper = FSL_SymptomfcSearch.callODMHeaderService(wo.id,'',cfc.id,'','','');
        System.debug('returnWrapper.bmsStatus:::: '+returnWrapper.bmsStatus);
        FSL_SymptomfcSearch.callODMHeaderService(wo.id,spnfc.id,'','','','');
        FSL_SymptomfcSearch.callODMHeaderService(wo.id,'','',pfc.Id,'','');
        FSL_SymptomfcSearch.callODMHeaderService(wo.id,'','','','Exhaust Smoke Color','Black Smoke');
        FSL_SymptomFCSearch_Request_Wrap.parse(JSON);
        System.assertEquals(true, returnWrapper.exceptionFlag);
        
    }
    public static testmethod void FSL_SymptomSearchMethod(){
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        String JSON = '{"ToolId":"Guidanz Web","Contentflag":false,"JobNumber":"00001613","UserID":"AB123","WorkgroupID":"ALBANY-EAST-ALBANY-02024","Usertype":"Dealer","Userrole":"Technician","PGAGroup":"PGA 01","Customername":"Kenworth","Unitnumber":"","ShopWONumber":"123456","ESN":"79797979","SMN":"ISX15 CM2350 X101","Domain":"Engine","ApplicationCode":"130","Applicationdescription":"Automotive","Marketingconfigurationcode":"BB","Generatornumber":"C1600 N5CD","Alternatornumber":"C1600 N5CD","Controllername":"Deif","PSBUPlant":"CPG â€“ UK","PSBUModel":"C550 D5","PSBUSpec":"A","ECMCode":"A01031.01","Make":"Kenworth","Model":"T800","Faulttype":"1","FaultCodelist":[{"CumminsFaultCode":"7922","SPN":"","FMI":"","PCode":""}],"Highlevelsymptom":"Exhaust Smoke Color","Lowlevelsymptom":"Black Smoke","Complaintcode":"302","Offlineflag":true,"Repeatvisitflag":true,"Reconflag":true,"EngineMileage":"345213","Mileageunit":"km","Enginehours":"212321","VIN":"1XKYD49X5EJ392882","Languagekey":"en"}';
        
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        insert acc;
        test.startTest();
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.email='priyanka.thotakura@cummins.com';
        con.AccountId=acc.id;
        insert con; 
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.AccountId=acc.Id;//using account id as ase account id
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644334';
        ase.Application_Code__c='234';
        insert ase;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST ST Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        ServiceTerritory st1= new ServiceTerritory();
        st1.name = 'TEST ST1 Mobile';
        st1.OperatingHoursId=oh.id;
        st1.IsActive=true;
        st1.Location_Code__c='05550-03941';
        st1.FSL_Service_Territory_Code__c='03941';
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
        wo.Fault_Code_Communication_Trigger__c=true; //new
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId     = recdtypeId;
        //wo.Repair_Solution__c  = sol.Id;
        // wo.Branch_Code__c=5123;
        
        insert wo;
        wo.ServiceTerritoryId=st1.Id;
        update wo;
        FSL_Symptom__c symp= new FSL_Symptom__c();
        symp.Name='symptom test';
        symp.Symptom__c='Black Smoke';
        symp.Symptom_Category__c='Exhaust Smoke Color';
        insert symp;
        
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        
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
        
        CSS_Fault_Code__c spnfmi=new CSS_Fault_Code__c();
        spnfmi.Name=spnfc.name;
        //fcode.Fault_Code__c=cfc.id;
        spnfmi.Type__c = 'Fault';
        spnfmi.Fault_Code_Type__c = '2';
        spnfmi.Service_Order__c = wo.id;
        spnfmi.extfield__c = spnfc.id+' '+wo.id;
        insert spnfmi;
        
        CSS_Fault_Code__c pcode=new CSS_Fault_Code__c();
        pcode.Name=pfc.name;
        //fcode.Fault_Code__c=cfc.id;
        pcode.Type__c = 'Fault';
        pcode.Fault_Code_Type__c = '3';
        pcode.Service_Order__c = wo.id;
        pcode.extfield__c = pfc.id+' '+wo.id;
        insert pcode;
        
        CSS_Fault_Code__c symptoms=new CSS_Fault_Code__c();
        symptoms.Name=symp.Symptom__c;
        //fcode.Fault_Code__c=cfc.id;
        symptoms.Type__c = 'Symptom';
        symptoms.Fault_Code_Type__c = '0';
        symptoms.Service_Order__c = wo.id;
        symptoms.extfield__c = symp.id+' '+wo.id;
        insert symptoms;
        
        CSS_Solutions__c sol= new CSS_Solutions__c();
        sol.Name='S00000345';
        sol.FSL_Service_Job__c = wo.Id;
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        //sol.FSL_Solution_Content__c=obj1.id;
        insert sol;
        
        // knowledge__kav obj1 = [SELECT Id,Title,KnowledgeArticleId,UrlName FROM knowledge__kav WHERE UrlName =: sol.name];
        
        Knowledge__kav kv= new Knowledge__kav();
        // list<Knowledge__kav> kList = new list<Knowledge__kav>();
        kv.Verification__c='abc';
        kv.Repairs__c='*#SnNo#*';
        kv.UrlName=sol.Name;
        kv.Title=sol.Solution_Title__c;
        // kList.add(kv);
        insert kv;
        
        CSS_Integration_Details__c setting = new CSS_Integration_Details__c();
        setting.Name = 'FSL_CDS_GetSolutions';
        setting.AuthEnv__c = 'CDS_GetTokenSolutionStg';
        setting.End_Point__c='https://cdssolutions-stg.cummins.com/api/GetSolution';
        setting.Username__c='562e164f-f255-4eff-9c29-3ceed139c0dd';
        setting.Passcode__c='nFdnKFgXVjKg5JZTOmA2zzCaSUgh0FZi6GXvJBYFV4M=';
        setting.Method_Type__c='POST';
        setting.Timeout__c=120000;
        insert setting;
        
        StaticResourceCalloutMock mock1 = new StaticResourceCalloutMock();
        mock1.setStaticResource('FSL_CDSaccessToken');
        mock1.setStatusCode(200);
        mock1.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock1);
        
        StaticResourceCalloutMock mock3 = new StaticResourceCalloutMock();
        mock3.setStaticResource('FSL_symptomresponse');
        mock3.setStatusCode(200);
        mock3.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock3); 
        
        test.stopTest();
        // FSL_SymptomfcSearch.callODMHeaderService(wo.id,'',cfc.id,'','','');
        // FSL_SymptomfcSearch.callODMHeaderService(wo.id,spnfc.id,'','','','');
        // FSL_SymptomfcSearch.callODMHeaderService(wo.id,'','',pfc.Id,'','');
        CG_OP_OAGWrapper returnWrapper = FSL_SymptomfcSearch.callODMHeaderService(wo.id,'','','','Exhaust Smoke Color','Black Smoke');
        System.assertEquals('Passed', returnWrapper.bmsStatus);
        FSL_SymptomFCSearch_Request_Wrap.parse(JSON);
        
    }
    
}