//Adding comment for deployment -- Akansha MV_688 8/25/2022
@isTest
public class CG_BL_ODM_Test {
    @testSetup
    static void testdata(){
        
        List<CSS_Integration_Details__c> conDetailsList = new List<CSS_Integration_Details__c>();
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='CG_ODMHeaderValidation';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='CG_ODMHeaderValidation';
        conDetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/header';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='al1ufLm+eGhMQGBP8LNDxP5pPZpbHDAAxeqrz3m3jVc=';
        conDetails.Passcode__c='LU8Ih/SyVzsBI5orDsQgiPXRBslYyUpejYY0rJEwOZUNi9E/Pdv/O7L0K6ixrMbvX0kXyGRL/PimO4JrvQwA1A==';
        conDetails.Username__c='fF16z3F9QZ3PhXtxtcwFD4BQkKe5Lk//8GwngwxCoNiUuHS5jc0kFZOGbLzQC/H7OOFpjPEn6K3kYzVvaSmsbw==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';
        conDetailsList.add(conDetails);
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name='CG_ODMPartsService';
        conDetails1.IsActive__c=true;
        conDetails1.ApplicationName__c='CG_ODMPartsService';
        conDetails1.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/parts';
        conDetails1.Method_Type__c='POST';
        conDetails1.Key__c='C4sulMbYCfRx3CVUszchtEza9MnsYklLiVygpQWh+Ng=';
        conDetails1.Passcode__c='EYE0ipFnJiWAxa55wzsWyEoEinjaEKq+i0Aoc7t5zasuq4+yRbsQ931Qn+Zvs/hTz73rseO1Pp+PfnCt67st8A==';
        conDetails1.Username__c='wB8gCc4HTRkWbRrKOz1sA7hkx+4Wo/iW71OrejFFi+8F942FQ1LaqjbdUzyMw2k1hfbVMJt4+oz9fi9vQjxZkQ==';
        conDetails1.AuthEnv__c='MuleAuth';
        conDetails1.Timeout__c=120000;
        conDetails1.Logging__c='BOTH';
        conDetailsList.add(conDetails1);
        
        CSS_Integration_Details__c conDetails2 = new CSS_Integration_Details__c();
        conDetails2.Name='CG_ODMSRTService';
        conDetails2.IsActive__c=true;
        conDetails2.ApplicationName__c='CG_ODMSRTService';
        conDetails2.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/srt';
        conDetails2.Method_Type__c='POST';
        conDetails2.Key__c='pT0JaPTrclNC0IEw1kKouItFrZj8FoIaOeTa3BfBtBU=';
        conDetails2.Passcode__c='9PO5osUZ1FXtuffsCXoER030YVFd0zHb04jCTDIJHSGo0/D8Dvg7TnDDzFug0XvikpylhLpzOIafKZgA4oZU8Q==';
        conDetails2.Username__c='TxsRUjX4tkHbJhmizDEJgQl1iR3gz+ymxvMvlfMcJNgRn8Mzg6zjx3vikWhbni+ApR1wimYlTfglndjlcNiDKQ==';
        conDetails2.AuthEnv__c='MuleAuth';
        conDetails2.Timeout__c=120000;
        conDetails2.Logging__c='BOTH';
        conDetailsList.add(conDetails2);
        
        CSS_Integration_Details__c conDetails3 = new CSS_Integration_Details__c();
        conDetails3.Name='CG_ODMTravelService';
        conDetails3.IsActive__c=true;
        conDetails3.ApplicationName__c='CG_ODMTravelService';
        conDetails3.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/travel';
        conDetails3.Method_Type__c='POST';
        conDetails3.Key__c='7+xApd8H85R81jMkjwdkiKF38kBy/5/Kn0BeJ6oiSyQ=';
        conDetails3.Passcode__c='aPdH2aljLpJNcn257bFad+/cJLEPLgjaDgOff/aMdt14Ftt1S2RBg4gX5E3QDdg0SyU7LFuo0r7BZ7pMrI8IHg==';
        conDetails3.Username__c='ozWoOPV+t28bMeXvUvsLBSxaYOOJbs9Hiq5qltWsIeKH3B3kzMZEe0Fe+kzdSDng4NZGB4mPEJK9iH5ILKyoQQ==';
        conDetails3.AuthEnv__c='MuleAuth';
        conDetails3.Timeout__c=120000;
        conDetails3.Logging__c='BOTH';
        conDetailsList.add(conDetails3);
        
        CSS_Integration_Details__c conDetails4 = new CSS_Integration_Details__c();
        conDetails4.Name='CG_OtherClaimablesValidation';
        conDetails4.IsActive__c=true;
        conDetails4.ApplicationName__c='CG_OtherClaimablesValidation';
        conDetails4.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/othclaimables';
        conDetails4.Method_Type__c='POST';
        conDetails4.Key__c='mqgAfQpGo+aL4xOLDepQfYriZU65gOseboO7EZA3Ncs=';
        conDetails4.Passcode__c='155b3DOk0+mO4T7XK9vC3OdeIxUSar3PlGUg7t9CU/Ov7wSOCI19l69Gh86ChDmYJfimMwXYw+VFgMcn4+Le9g==';
        conDetails4.Username__c='/N8HSCbsSbPYhcDJdQLyef4ZJjE2Jp39TDgQhhAfud/ZmfUYdWTbj5hoioh1YMUxnUM1ea+qJy0E/5ysNh+I6w==';
        conDetails4.AuthEnv__c='MuleAuth';
        conDetails4.Timeout__c=120000;
        conDetails4.Logging__c='BOTH';
        conDetailsList.add(conDetails4);
        
        CSS_Integration_Details__c conDetails5 = new CSS_Integration_Details__c();
        conDetails5.Name='CG_FailureValidation';
        conDetails5.IsActive__c=true;
        conDetails5.ApplicationName__c='CG_FailureValidation';
        conDetails5.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/failure';
        conDetails5.Method_Type__c='POST';
        conDetails5.Key__c='qLA4RqeHtxDlK14xH6l/HaQxxMZgALq11JMifWLiIu4=';
        conDetails5.Passcode__c='yEZSCZ1hNlVb19+yTjhpx1ecHO57KOQCiVBZphqw+KjdV0Gq6MegeUAKOAte+WnIIGF0hEvnjuqDWJfcWpfzjA==';
        conDetails5.Username__c='QICgngUC+kpmjf+YZzZCR2m2ClqcX8ffdIxr6qc0uQzr01gqOAt+SOwrc3fcydoKFORtcoNedXjka6i75gQjgQ==';
        conDetails5.AuthEnv__c='MuleAuth';
        conDetails5.Timeout__c=120000;
        conDetails5.Logging__c='BOTH';
        conDetailsList.add(conDetails5);
        
        CSS_Integration_Details__c conDetails6 = new CSS_Integration_Details__c();
        conDetails6.Name='ODMPreSubmitValidation';
        conDetails6.IsActive__c=true;
        conDetails6.ApplicationName__c='ODMPreSubmitValidation';
        conDetails6.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/presubmit';
        conDetails6.Method_Type__c='POST';
        conDetails6.Key__c='sZ5pvJOx0d2RuDFLlOwLhWBJthGTPSpdecFDV/BOsgI=';
        conDetails6.Passcode__c='lECcMTZ+JgxDkAbhugDRxA8xtYAUFyNunmsy59S/0+/Gv0xKJkyPKpfVADCjdVJ4IFoF3uVn7QtEsb3GwMjcQg==';
        conDetails6.Username__c='udj63yv8S6fRVW2L27pz6oMnjPO/85K5FSHT4WC7SdoN9XjA2SeweXZJ2GTkiPQdR3DIZIm46VU7wzd6JU+jRA==';
        conDetails6.AuthEnv__c='MuleAuth';
        conDetails6.Timeout__c=120000;
        conDetails6.Logging__c='BOTH';
        conDetailsList.add(conDetails6);
        
        insert conDetailsList;
        CSS_JobEventTemporary__c  jobevt = new CSS_JobEventTemporary__c();
        jobevt.Attribute1__c='NPW';
        jobevt.Attribute3__c='35';
        jobevt.Attribute9__c='y';
        jobevt.Attribute7__c='';
        jobevt.Key__c='AccountCodes';
        
        CSS_JobEventTemporary__c  jobevt1 = new CSS_JobEventTemporary__c();
        jobevt1.Attribute1__c='NPW';
        jobevt1.Attribute3__c='36';
        jobevt1.Attribute9__c='y';
        jobevt1.Attribute7__c='';
        jobevt1.Key__c='AccountCodes';
        list<CSS_JobEventTemporary__c> jobevtlist = new  list<CSS_JobEventTemporary__c>();
        jobevtlist.add(jobevt);
        jobevtlist.add(jobevt1);
        insert jobevtlist;
    }
    
    static TestMethod void TestBLODM() {
        CG_BL_ODM odm= new CG_BL_ODM();
        Boolean showodmerrormsg=true;
        Id ttmlid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        Id OtherClaimables = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        Test.startTest();
        CSS_Job_Order__c jo=new CSS_Job_Order__c();
        CSS_Claims__c cc=new CSS_Claims__c();
        CSS_PSN__c psn=new CSS_PSN__c();
        CSS_Solution_Component__c sc1= new CSS_Solution_Component__c();
        sc1.AccountCodeEdit__c='test';
        sc1.System_Code__c='IF';
        sc1.Component_Code__c='IA';
        sc1.Failure_Mode__c='SC';
        sc1.Type__c='ATC';
        insert sc1;
        CSS_Solution_Component__c sc2=new CSS_Solution_Component__c();
        sc2.AccountCodeEdit__c = 'test2';
        sc2.System_Code__c='IF';
        sc2.Component_Code__c='AI';
        sc2.Type__c = 'TRP';
        sc2.ODM_Status__c = 'ERROR';
        insert sc2;
        List<CSS_Solution_Component__c> SolComp= new List<CSS_Solution_Component__c>();
        SolComp.add(sc1);
        SolComp.add(sc2);
        
        CSS_Integration_Error__c ie1=new CSS_Integration_Error__c();
        
        CSS_Integration_Error__c ie2=new CSS_Integration_Error__c();
        ie2.Auth_Call_Time__c=0;
        ie2.Processed_Data__c='test';
        ie2.Response_Body__c='success';
        ie2.Service_Call_Time__c=1.0;
        ie2.Source__c = 'ODM';
        ie2.Service_Name__c = 'ODMHeaderValidation';
        List<CSS_Integration_Error__c> lstClaimsIntDetails=new list<CSS_Integration_Error__c>();
        lstClaimsIntDetails.add(ie1);
        lstClaimsIntDetails.add(ie2);
        CSS_Parts_Options__c po=new CSS_Parts_Options__c();
        po.RecordTypeid=ttmlid;
        po.Part_Name__c = 'Connected Head';
        po.Service_Job__c = jo.Id;
        po.selected_part__c = true;
        po.FailurepartId__c = sc1.Id;
        po.Part_Assignment__c = 'Primary';
        // po.Solutions__c=solution.Id;
        //po.RecordTypeId=recTyIdpart;
        po.Covered__c=100;
        po.Service_partnumber__c='1234567RX';
        po.Unit_Price__c='10';
        po.Type__c='Towing';
        insert po;
        CSS_Parts_Options__c po1=new CSS_Parts_Options__c();
        po1.RecordTypeid=OtherClaimables;
        po1.Part_Name__c = 'Connected Head';
        po1.Service_Job__c = jo.Id;
        po1.selected_part__c = true;
        po1.FailurepartId__c = sc1.Id;
        po1.Part_Assignment__c = 'Primary';
        // po.Solutions__c=solution.Id;
        //po.RecordTypeId=recTyIdpart;
        po1.Covered__c=100;
        po1.Service_partnumber__c='1234567RX';
        po1.Unit_Price__c='10';
        po1.Type__c='Towing';
        insert po1;
        list<CSS_Parts_Options__c> lpo= new list<CSS_Parts_Options__c>();
        lpo.add(po);
        lpo.add(po1);
        
        
        List<CSS_Integration_Error__c> l1=CG_BL_ODM.callODMHeaderValidationClaimService(jo,cc,psn,'JOB',SolComp,'WarrantyOverview');
        List<CSS_Integration_Error__c> l2=CG_BL_ODM.callODMHeaderValidationClaimService(jo,cc,psn,'CLAIM',SolComp,'WarrantyOverview');
        
        boolean b=CG_BL_ODM.callODMHeaderValidationService(jo,cc,psn,'JOB',SolComp,'WarrantyOverview');
        boolean bo=CG_BL_ODM.callODMHeaderValidationService(jo,cc,psn,'CLAIM',SolComp,'WarrantyOverview');
        boolean b1=CG_BL_ODM.callODMFailureValidationService(jo,cc,psn,'JOB',SolComp,'WarrantyOverview');
        boolean b12=CG_BL_ODM.callODMFailureValidationService(jo,cc,psn,'CLAIM',SolComp,'WarrantyOverview');
        CG_BL_ODM.calljobODMHeaderFailureValidationService('Source');
        boolean b2=CG_BL_ODM.callClaimsODMPartsValidationService(jo,cc,psn,'JOB',SolComp,lpo,TRUE);
        boolean b22=CG_BL_ODM.callClaimsODMPartsValidationService(jo,cc,psn,'CLAIM',SolComp,lpo,TRUE);
        boolean b3=CG_BL_ODM.callODMPartsValidationService(jo,cc,psn,'JOB',SolComp,lpo,TRUE);
        boolean b33=CG_BL_ODM.callODMPartsValidationService(jo,cc,psn,'CLAIM',SolComp,lpo,TRUE);
        boolean b4=CG_BL_ODM.callODMTravelValidationService(jo,cc,psn,'JOB',SolComp,lpo);
        boolean b44=CG_BL_ODM.callODMTravelValidationService(jo,cc,psn,'CLAIM',SolComp,lpo);
        boolean b5=CG_BL_ODM.callODMOtherClaimableValidationService(jo,cc,psn,'JOB',SolComp,lpo);
        boolean b55=CG_BL_ODM.callODMOtherClaimableValidationService(jo,cc,psn,'CLAIM',SolComp,lpo);
        boolean b6=CG_BL_ODM.callODMSRTServices('testing','123');
        boolean b7 = CG_BL_ODM.callODMSRTServicesold('testing','123');
        
        CG_ODM_ResJSONParser odmres=new CG_ODM_ResJSONParser();
        css_srt__c srt1=new css_srt__c();
        css_srt__c srt2=new css_srt__c();
        list<css_srt__c> lsrt=new list<css_srt__c>();
        lsrt.add(srt1);
        lsrt.add(srt2);
        CG_OP_OAGWrapper responseWrapper = new CG_OP_OAGWrapper();
        CG_BL_ODM.captureStatusesMessages(odmres,lsrt,lpo,200);
        CG_BL_ODM.insertIntegrationLogs(responseWrapper,lstClaimsIntDetails,'jobName','serviceName');
        CG_ODM_ReqJSONParser odmreq=CG_BL_ODM.prepareServiceJobHeaderValidationReqJSON(sc1,jo,'ServiceName');
        CG_ODM_ReqJSONParser odmreq1=CG_BL_ODM.prepareClaimHeaderValidationReqJSON(sc2,cc,psn,'ServiceName');
        Map<string, list<CSS_Solution_Component__c>> SCAccountCodeMap=new Map<string, list<CSS_Solution_Component__c>>();
        SCAccountCodeMap.put('123',SolComp);
        Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap=new Map<string, list<CSS_Parts_Options__c>>();
        POAccountCodeMap.put('abc',lpo);
        POAccountCodeMap.put('123IFIA',lpo);
        POAccountCodeMap.put('35IFIA',lpo);
        Map<string, list<CSS_SRT__c>> SRTAccountCodeMap=new Map<string, list<CSS_SRT__c>>();
        SRTAccountCodeMap.put('abc',lsrt);
        String s1='123';
        String s2='abc';
        List<String> partsWarranty=new List<String>();
        partsWarranty.add(s1);
        partsWarranty.add(s2);
        List<String> fieldActionClaimAccCodes = new List<String>();
        fieldActionClaimAccCodes.add('23');
        fieldActionClaimAccCodes.add('Test');
        fieldActionClaimAccCodes.add('Test1');
        fieldActionClaimAccCodes.add('Test2');
        Boolean IsClaim=true;
        CSS_JobEventTemporary__c JOBEVENT = new CSS_JobEventTemporary__c();
        list<CSS_Integration_Error__c> ics=CG_BL_ODM.performODMPreSubmitServiceCS(SCAccountCodeMap,POAccountCodeMap,SRTAccountCodeMap,partsWarranty, fieldActionClaimAccCodes,cc, psn, jo,IsClaim);
        CG_ODM_PreSubmit_ReqJSONParser psrjson=new CG_ODM_PreSubmit_ReqJSONParser();
        list<CG_ODM_PreSubmit_ReqJSONParser> lpsr= new list<CG_ODM_PreSubmit_ReqJSONParser>();
        lpsr= CG_BL_ODM.CallODMpreSubmitValidationserviceCS(SCAccountCodeMap,POAccountCodeMap,SRTAccountCodeMap,partsWarranty, fieldActionClaimAccCodes,cc, psn, jo,IsClaim);
        CG_ODM_PreSubmit_ReqJSONParser.Engine engine=CG_BL_ODM.passEngineValuestoODM(cc,jo,TRUE);
        CG_ODM_PreSubmit_ReqJSONParser.Engine engine1=CG_BL_ODM.passEngineValuestoODM(cc,jo,FALSE);
        CG_ODM_PreSubmit_ReqJSONParser.ServiceProvider sp=CG_BL_ODM.passingserviceprovider(cc,jo,psn,IsClaim);
        String ss=CG_BL_ODM.fetchComplaintCode(cc,jo,IsClaim);
        JOBEVENT.attribute1__c='CategoryComplaintCodes';
        JOBEVENT.Reason__c='{"DataArea":{"Details":[{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LOSS - OVERFLOW","BusinessUnit":"EBU","ComplaintCode":"106","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL CONSUMPTION EXCESSIVE","BusinessUnit":"EBU","ComplaintCode":"117","ActiveFlag":"Y"},{"Category":"Leak","Description":"EXHAUST LEAK","BusinessUnit":"EBU","ComplaintCode":"118","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE SHUTS DOWN OR STALLS","BusinessUnit":"EBU","ComplaintCode":"205","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE SURGES","BusinessUnit":"EBU","ComplaintCode":"212","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"LOW POWER","BusinessUnit":"EBU","ComplaintCode":"213","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"VIBRATION","BusinessUnit":"EBU","ComplaintCode":"401","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"INOPERATIVE COMPONENT","BusinessUnit":"EBU","ComplaintCode":"404","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE RUNS ROUGH","BusinessUnit":"EBU","ComplaintCode":"215","ActiveFlag":"Y"},{"Category":"Leak","Description":"DEF LEAK","BusinessUnit":"EBU","ComplaintCode":"609","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK INTERNAL - IN OIL","BusinessUnit":"EBU","ComplaintCode":"115","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK INTERNAL - IN COOLANT","BusinessUnit":"EBU","ComplaintCode":"116","ActiveFlag":"Y"},{"Category":"Leak","Description":"COMPRESSION LEAK","BusinessUnit":"EBU","ComplaintCode":"120","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"CHECK ENGINE LIGHT - RED","BusinessUnit":"EBU","ComplaintCode":"202","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE WILL NOT SHUT DOWN","BusinessUnit":"EBU","ComplaintCode":"211","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"CRUISE CONTROL","BusinessUnit":"EBU","ComplaintCode":"503","ActiveFlag":"Y"},{"Category":"Other","Description":"INSPECTION","BusinessUnit":"EBU","ComplaintCode":"603","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL IN AIR SYSTEM","BusinessUnit":"EBU","ComplaintCode":"121","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO NOISE","BusinessUnit":"EBU","ComplaintCode":"123","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO BLOWING OIL OUT EXHAUST","BusinessUnit":"EBU","ComplaintCode":"124","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO BLOWING OIL IN INTAKE","BusinessUnit":"EBU","ComplaintCode":"125","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"CHECK ENGINE LIGHT - YELLOW","BusinessUnit":"EBU","ComplaintCode":"201","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT REACH RPM","BusinessUnit":"EBU","ComplaintCode":"206","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"IDLE SPEED HIGH","BusinessUnit":"EBU","ComplaintCode":"208","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"POOR THROTTLE RESPONSE","BusinessUnit":"EBU","ComplaintCode":"214","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"HIGH BLOW-BY","BusinessUnit":"EBU","ComplaintCode":"408","ActiveFlag":"Y"},{"Category":"Other","Description":"REBUILD","BusinessUnit":"EBU","ComplaintCode":"602","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN WILL NOT COMPLETE","BusinessUnit":"EBU","ComplaintCode":"606","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"101","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT BUILD AIR OR BUILDS SLOWLY","BusinessUnit":"EBU","ComplaintCode":"122","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ROUGH IDLE","BusinessUnit":"EBU","ComplaintCode":"209","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"BLACK SMOKE","BusinessUnit":"EBU","ComplaintCode":"302","ActiveFlag":"Y"},{"Category":"Other","Description":"VOLTAGE (GENSET)","BusinessUnit":"EBU","ComplaintCode":"505","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"STARTER MOTOR MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"508","ActiveFlag":"Y"},{"Category":"Other","Description":"CAMPAIGN / TRP","BusinessUnit":"EBU","ComplaintCode":"601","ActiveFlag":"Y"},{"Category":"Other","Description":"FAILED EMISSION TEST","BusinessUnit":"EBU","ComplaintCode":"604","ActiveFlag":"Y"},{"Category":"Other","Description":"MAINTENANCE","BusinessUnit":"EBU","ComplaintCode":"605","ActiveFlag":"Y"},{"Category":"Other","Description":"TELEMATICS","BusinessUnit":"EBU","ComplaintCode":"990","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"HARD START","BusinessUnit":"EBU","ComplaintCode":"203","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT START","BusinessUnit":"EBU","ComplaintCode":"204","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE MISFIRE","BusinessUnit":"EBU","ComplaintCode":"210","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"ENGINE BRAKE MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"406","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BLOWING DIPSTCK OUT","BusinessUnit":"EBU","ComplaintCode":"407","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK INTERNAL - NOT IN OIL","BusinessUnit":"EBU","ComplaintCode":"102","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"107","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL TEMPERATURE LOW","BusinessUnit":"EBU","ComplaintCode":"109","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL PRESSURE HIGH","BusinessUnit":"EBU","ComplaintCode":"112","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL CONSUMPTION EXCESSIVE","BusinessUnit":"EBU","ComplaintCode":"113","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"IDLE SPEED LOW","BusinessUnit":"EBU","ComplaintCode":"207","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WHITE SMOKE","BusinessUnit":"EBU","ComplaintCode":"301","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"NOISE IN ENGINE","BusinessUnit":"EBU","ComplaintCode":"402","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT CARRY LOAD (GENSET)","BusinessUnit":"EBU","ComplaintCode":"504","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN TOO FREQUENT","BusinessUnit":"EBU","ComplaintCode":"608","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK INTERNAL - IN OIL","BusinessUnit":"EBU","ComplaintCode":"103","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL IN COOLANT","BusinessUnit":"EBU","ComplaintCode":"108","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"114","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"BLUE SMOKE","BusinessUnit":"EBU","ComplaintCode":"303","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE OVERSPEED","BusinessUnit":"EBU","ComplaintCode":"409","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BELT PROBLEM","BusinessUnit":"EBU","ComplaintCode":"410","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"ALTERNATOR MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"507","ActiveFlag":"Y"},{"Category":"Other","Description":"OTHER - SEE TEXT FOR DESCRIPTION","BusinessUnit":"EBU","ComplaintCode":"999","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN WILL NOT START","BusinessUnit":"EBU","ComplaintCode":"607","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT TEMPERATURE LOW","BusinessUnit":"EBU","ComplaintCode":"104","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT TEMPERATURE HIGH","BusinessUnit":"EBU","ComplaintCode":"105","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL TEMPERATURE HIGH","BusinessUnit":"EBU","ComplaintCode":"110","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL PRESSURE LOW","BusinessUnit":"EBU","ComplaintCode":"111","ActiveFlag":"Y"},{"Category":"Leak","Description":"AIR LEAK","BusinessUnit":"EBU","ComplaintCode":"119","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"NOISY COMPONENT","BusinessUnit":"EBU","ComplaintCode":"403","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"LOOSE OR BROKEN MOUNTING HARDWARE","BusinessUnit":"EBU","ComplaintCode":"405","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BREAKER TRIPPING","BusinessUnit":"EBU","ComplaintCode":"506","ActiveFlag":"Y"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}';
        JOBEVENT.Key__c = 'AccountCodes' ;
        JOBEVENT.Attribute3__c =sc1.AccountCodeEdit__c;
        insert JOBEVENT;
        String ss1=CG_BL_ODM.fetchComplaintCode(cc,jo,IsClaim);
        Test.setMock(HttpCalloutMock.class, new CG_ODM_ResJSONParser_Mock());
        CG_ODM_PreSubmit_ReqJSONParser.Claim claim1=CG_BL_ODM.passClaimsValuestoODM(cc,jo,psn,'accountTwoDigit',IsClaim);
        CG_ODM_PreSubmit_ReqJSONParser.Claim claim2=CG_BL_ODM.passPartsWarrantyValuestoODM(sc1,cc,jo,psn,'accountTwoDigit',claim1,true,isClaim);
        CG_ODM_PreSubmit_ReqJSONParser.Claim claim21=CG_BL_ODM.passPartsWarrantyValuestoODM(sc1,cc,jo,psn,'accountTwoDigit',claim1,false,false);
        list<CG_ODM_PreSubmit_ReqJSONParser.SrtList> srtm=CG_BL_ODM.passSRTValuestoODM(lsrt,'repairLocation','test');
        list<CG_ODM_PreSubmit_ReqJSONParser.Travels> ttml= CG_BL_ODM.passTTMLValuestoODM(lpo,'test');
        list<CG_ODM_PreSubmit_ReqJSONParser.OtherClaimables> ot= CG_BL_ODM.passOCValuestoODM(lpo,'test');
        
        
        test.stopTest();
    }
    static testmethod void testmethod1()
    {
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            css_claims__c claims = CSS_TestData.createclaims(true,joorder.Id);
            CSS_Solutions__c solution = css_testdata.createSolutions(true, joorder.Id);
            CSS_Solution_Component__c solcomp = css_testdata.createSRT(true, joorder.Id,solution.Id);
            CSS_Parts_Options__c parts1= css_testdata.createParts_new(true, joorder.Id, solComp.Id, solution.Id, claims.id);
            CSS_Parts_Options__c parts11= css_testdata.createParts(true, joorder.Id, solComp.Id, solution.Id);
            CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
            parts.Part_Name__c = 'Connected Head';
            parts.Service_Job__c = joorder.Id;
            parts.selected_part__c = true;
            parts.FailurepartId__c = solComp.Id;
            parts.Part_Assignment__c = 'Primary';
            parts.Solutions__c=solution.Id;
            parts.RecordTypeId=recTyIdpart;
            parts.Covered__c=100;
            parts.Service_partnumber__c='1234567RX';
            parts.Unit_Price__c='10';
            insert parts;
            system.debug('partop>>'+parts.RecordType.name);
            list<CSS_Parts_Options__c> partoplist = new list<CSS_Parts_Options__c>();
            partoplist.add(parts);
            partoplist.add(parts1);
            partoplist.add(parts11);
            
            list<CSS_Parts_Options__c> partoplist1=[select id,RecordType.name,Option_Number__c,Covered__c,Service_partnumber__c,Unit_Price__c from CSS_Parts_Options__c];
            system.debug('partoplist>>'+partoplist1);
            Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
            CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
            partsoption.quantity__c = 100;
            partsoption.Item__c = 'Select One';
            partsoption.Covered__c = 100;
            partsoption.RecordTypeId = recTypeIdpart1;
            partsoption.Amount__c = 122;
            partsoption.Fail_Code__c = 'test';
            partsoption.Account_Code__c = 'test';
            partsoption.Part_Description__c = 'test-PD';
            partsoption.Service_Job__c = JOorder.id;
            insert partsoption;
            list<CSS_Parts_Options__c> partoplist2=new list<CSS_Parts_Options__c>();
            partoplist2.add(partsoption);
            
            test.startTest();
            Test.setMock(HttpCalloutMock.class, new CG_ODM_ResJSONParser_Mock());
            list<CG_ODM_PreSubmit_ReqJSONParser.Parts> partsListParser= CG_BL_ODM.passPartsValuestoODM(partoplist,'test');
            CG_BL_ODM.passOCValuestoODM(partoplist2,'test');
            system.debug('partoplist ends>>'+partsListParser);
            test.stopTest();
        }
    }
    static testmethod void testmethod4()
    {
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        insert jo;
        list<id> idlist = new list<id>();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        
        insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = null;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = '';
        AddsolComp.AccountCodeEdit__c = '';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        AddsolComp.Service_Job__c=jo.id;
        insert AddsolComp;
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        AddsolComp1.CSS_Claims__c = testclaimsRec.id;
        AddsolComp1.Action__c = 'Repair';
        AddsolComp.Solutions__c = solRef.id;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.Selected_Component__c = True;
        AddsolComp1.AccountCode__c = '';
        AddsolComp1.AccountCodeEdit__c = '';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
        AddsolComp1.Service_Job__c=null;
        AddsolComp1.ODM_Status_Code__c='SUCCESS';
        insert AddsolComp1;
        idlist.add(AddsolComp1.id);
        LIST<CSS_Solution_Component__c> SOLIST12=NEW LIST<CSS_Solution_Component__c>();
        SOLIST12.add(AddsolComp1);
        SOLIST12.add(AddsolComp);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
        Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c =''; 
        po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.ODM_Status__c = '';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
        CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = null;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c =''; 
        // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id; 
        po1.ODM_Status__c = '';
        lstpo.add(po1);
        
        CSS_Parts_Options__c po2 =new CSS_Parts_Options__c();
        po2.Notes__c='123';
        po2.RecordTypeId = recTypeIdpart;
        po2.CSS_Claims__c = testclaimsRec.id;
        po.Service_Job__c=jo.Id;
        po2.OEM__c ='123';
        po2.Quantity__c =1;
        po2.Selected_part__c =true;
        po2.Part_Name__c ='123456';
        po2.Service_partnumber__c ='123';
        po2.Parts_Type__c ='Custom';
        po2.Account_Code__c =''; 
        // po1.Solutions__c=solRef.id;
        po2.FailurepartId__c =AddsolComp.Id; 
        po2.ODM_Status__c = '';
        lstpo.add(po2);
        
        insert lstpo;
        list<CSS_Job_Order__c> jolist =new list<CSS_Job_Order__c>();
        jolist.add(jo);
        
        // CSS_SRT__c srt=css_testdata.createSRT(true,'repair',solRef.Id,jo.Id);
        list<CSS_SRT__c> srtlist = new  list<CSS_SRT__c>();
        // srtlist.add(srt);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new CG_ODM_ResJSONParser_Mock());
        list<CG_ODM_PreSubmit_ReqJSONParser.Parts> partsListParser= CG_BL_ODM.passPartsValuestoODM(lstpo,'test');
        system.debug('partoplist ends>>'+partsListParser);
        
        CG_BL_ODM.updatelstjob = jolist;
        CG_BL_ODM.calljobODMHeaderFailureValidationService('JOB');
        CG_BL_ODM.updatelstjob = NULL;
        CG_BL_ODM.updatelstsolComp=SOLIST12;
        CG_BL_ODM.calljobODMHeaderFailureValidationService('JOB');
        cg_bl_odm.updateSRTList=srtlist;
        // CG_BL_ODM.updateTravelList();
        
        CG_BL_ODM.updateODMSRTServiceResponse();
        test.stopTest();
    }
    static testmethod void testmethod111()
    {
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        insert jo;
        list<id> idlist = new list<id>();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        
        insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = null;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = '';
        AddsolComp.AccountCodeEdit__c = '';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        AddsolComp.Service_Job__c=jo.id;
        insert AddsolComp;
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        AddsolComp1.CSS_Claims__c = testclaimsRec.id;
        AddsolComp1.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.Selected_Component__c = True;
        AddsolComp1.AccountCode__c = '';
        AddsolComp1.AccountCodeEdit__c = '';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
        AddsolComp1.Service_Job__c=null;
        insert AddsolComp1;
        idlist.add(AddsolComp1.id);
        LIST<CSS_Solution_Component__c> SOLIST12=NEW LIST<CSS_Solution_Component__c>();
        SOLIST12.add(AddsolComp1);
        SOLIST12.add(AddsolComp);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
        Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c =''; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.ODM_Status__c = '';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
        CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = null;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c =''; 
        // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id; 
        po1.ODM_Status__c = '';
        lstpo.add(po1);
        
        CSS_Parts_Options__c po2 =new CSS_Parts_Options__c();
        po2.Notes__c='123';
        po2.RecordTypeId = recTypeIdpart;
        po2.CSS_Claims__c = testclaimsRec.id;
        po.Service_Job__c=jo.Id;
        po2.OEM__c ='123';
        po2.Quantity__c =1;
        po2.Selected_part__c =true;
        po2.Part_Name__c ='123456';
        po2.Service_partnumber__c ='123';
        po2.Parts_Type__c ='Custom';
        po2.Account_Code__c =''; 
        // po1.Solutions__c=solRef.id;
        po2.FailurepartId__c =AddsolComp.Id; 
        po2.ODM_Status__c = 'ERROR';
        lstpo.add(po2);
        
        insert lstpo;
        list<CSS_Job_Order__c> jolist =new list<CSS_Job_Order__c>();
        jolist.add(jo);
        
        // CSS_SRT__c srt=css_testdata.createSRT(true,'repair',solRef.Id,jo.Id);
        list<CSS_SRT__c> srtlist = new  list<CSS_SRT__c>();
        // srtlist.add(srt);
        test.startTest();
        list<CG_ODM_PreSubmit_ReqJSONParser.Parts> partsListParser= CG_BL_ODM.passPartsValuestoODM(lstpo,'test');
        system.debug('partoplist ends>>'+partsListParser);
        CG_BL_ODM.updatelstjob = jolist;
        CG_BL_ODM.updatelstsolComp=SOLIST12;
        cg_bl_odm.updateSRTList=srtlist;
        // CG_BL_ODM.updateTravelList=prtlist;
        
        
        system.debug('Starts>>');
        CG_BL_ODM.callODMHeaderValidationClaimService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', SOLIST12, 'WarrantyOverview');
        CG_BL_ODM.callODMHeaderValidationService(jo, testclaimsRec, testpsnNewRec, 'JOB', SOLIST12, NULL);
        system.debug('ends>>');
        list<CG_ODM_ResJSONParser.message> nullList;
       CG_BL_ODM.ODMFailureChevronDisplayMsgs  = nullList;
        CG_BL_ODM.passClaimsValuestoODM(testclaimsRec, jo, testpsnNewRec, '61', false);
        CG_BL_ODM.passClaimsValuestoODM(testclaimsRec, jo, testpsnNewRec, '61', true);
        
        CG_BL_ODM.callODMFailureValidationService(jo, testclaimsRec, testpsnNewRec, 'JOB', SOLIST12, 'WarrantyOverview');
        CG_BL_ODM.callODMFailureValidationService(jo, testclaimsRec, testpsnNewRec, 'JOB', SOLIST12, null);
        CG_BL_ODM.callODMFailureValidationService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', SOLIST12, 'WarrantyOverview');
        CG_BL_ODM.callClaimsODMPartsValidationService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', SOLIST12, lstpo, true);
        CG_BL_ODM.callClaimsODMPartsValidationService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', SOLIST12, lstpo, false);   
        CG_BL_ODM.passEngineValuestoODM(testclaimsRec, jo, false);
        CG_BL_ODM.passEngineValuestoODM(testclaimsRec, jo, true);
        CG_BL_ODM.passingserviceprovider(testclaimsRec, jo, testpsnNewRec, false);
        CG_BL_ODM.passingserviceprovider(testclaimsRec, jo, testpsnNewRec, true);
        CG_BL_ODM.updatelstjob = jolist;
        CG_BL_ODM.calljobODMHeaderFailureValidationService('JOB');
        CG_BL_ODM.updatelstjob = NULL;
        CG_BL_ODM.updatelstsolComp=SOLIST12;
        CG_BL_ODM.calljobODMHeaderFailureValidationService('JOB');
        CG_BL_ODM.callClaimsODMPartsValidationServiceDisplayMsgs();
        CG_BL_ODM.returnODMSRTMessages();
        cg_bl_odm.updateSRTList=srtlist;
        
        CG_BL_ODM.updateODMSRTServiceResponse();
        test.stopTest();
    } 
    static testmethod void testmethod11()
    {
        list<CSS_Integration_Details__c> conDetailslist=[select id,name,AuthEnv__c,ApplicationName__c,End_Point__c,Method_Type__c,Timeout__c from CSS_Integration_Details__c];
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        insert jo;
        list<id> idlist = new list<id>();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        
        insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        List<CSS_Accreditation__c> lstaccrd = new list<CSS_Accreditation__c>();
        CSS_Accreditation__c accrd1 = new CSS_Accreditation__c();
        accrd1.Account__c = testclaimsRec.Account__c;
        accrd1.Service_Model_Name__c = testpsnNewRec.Service_Model__c;
        accrd1.Service_Level__c = 'akanksha';
        accrd1.StartDate__c = system.today();
        accrd1.EndDate__c = system.today()+30;
        insert accrd1;
        lstaccrd.add(accrd1);
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = testclaimsRec.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        // AddsolComp.AccountCode__c = 'EMSWarranty35';
        AddsolComp.AccountCodeEdit__c = 'EMSWarranty36';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        AddsolComp.Service_Job__c=jo.id;
        Addsolcomp.ODM_Status__c='ERROR';
        //   insert AddsolComp;
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        AddsolComp1.CSS_Claims__c = testclaimsRec.id;
        AddsolComp1.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.Selected_Component__c = True;
        // AddsolComp1.AccountCode__c = 'EMSWarranty35';
        AddsolComp1.AccountCodeEdit__c = 'EMSWarranty35';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
        AddsolComp1.Service_Job__c=null;
        // insert AddsolComp1;
        CSS_Solution_Component__c AddsolComp2 = new CSS_Solution_Component__c();
        AddsolComp2.Component_Id__c ='F0051000';
        AddsolComp2.CSS_Claims__c = testclaimsRec.id;
        AddsolComp2.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp2.Quantity__c = 4;
        AddsolComp1.Selected_Component__c = True;
        // AddsolComp1.AccountCode__c = 'EMSWarranty35';
        AddsolComp2.AccountCodeEdit__c = 'EMSWarranty65';
        AddsolComp2.CoveredPartsQty__c = null;
        AddsolComp2.Charlength__c = true;
        AddsolComp2.Name = 'Test'+Math.random();
        AddsolComp2.Service_Job__c=null;
        idlist.add(AddsolComp1.id);
        LIST<CSS_Solution_Component__c> SOLIST12=NEW LIST<CSS_Solution_Component__c>();
        SOLIST12.add(AddsolComp1);
        SOLIST12.add(AddsolComp);
        SOLIST12.add(AddsolComp2);
        insert SOLIST12;
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
        Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c =''; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.ODM_Status__c = '';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
        CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = null;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c =''; 
        // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id; 
        po1.ODM_Status__c = 'ERROR';
        lstpo.add(po1);
        
        CSS_Parts_Options__c po2 =new CSS_Parts_Options__c();
        po2.Notes__c='123';
        po2.RecordTypeId = recTypeIdpart;
        po2.CSS_Claims__c = testclaimsRec.id;
        po.Service_Job__c=jo.Id;
        po2.OEM__c ='123';
        po2.Quantity__c =1;
        po2.Selected_part__c =true;
        po2.Part_Name__c ='123456';
        po2.Service_partnumber__c ='123';
        po2.Parts_Type__c ='Custom';
        po2.Account_Code__c ='';
        // po1.Solutions__c=solRef.id;
        po2.FailurepartId__c =AddsolComp.Id; 
        po2.ODM_Status__c = 'ERROR';
        lstpo.add(po2);
        
        insert lstpo;
        list<CSS_Job_Order__c> jolist =new list<CSS_Job_Order__c>();
        jolist.add(jo);
        
        List<CSS_Solution_Component__c > lstSComp = new list<CSS_Solution_Component__c >();
        CSS_Solution_Component__c Scomp= new CSS_Solution_Component__c();
        SComp.Component_Id__c ='F0051000';
        SComp.CSS_Claims__c = testclaimsRec.id;
        SComp.Action__c = 'Repair';
        SComp.Quantity__c = 4;
        SComp.Selected_Component__c = True;
        SComp.AccountCodeEdit__c = 'EMSWarranty36';
        SComp.CoveredPartsQty__c = null;
        SComp.Charlength__c = true;
        SComp.Name = 'Test'+Math.random();
        SComp.Service_Job__c=jo.id;
        SComp.ODM_Status__c='ERROR';
        lstSComp.add(SComp);
        insert lstSComp;          
        // CSS_SRT__c srt=css_testdata.createSRT(true,'repair',solRef.Id,jo.Id);
        list<CSS_SRT__c> srtlist = new  list<CSS_SRT__c>();
        // srtlist.add(srt);
        CSS_Claims__c claimsobj = [SELECT Id, OwnerId, IsDeleted,Account__r.RSS_RESP_BRANCH_CODE__c, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Customer_Name__c, Customer_Code__c, Contact_First_Name__c, Contact_Last_Name__c, Address__c, Contact_Id__c, Country__c, State__c, Customer_Phone__c, ZipCode__c, TSR1__c, Customer_Contact_Phone__c, Distributor_Authorization_FN__c, TSR2__c, Distributor_Authorization_LN__c, Repair_Location__c, Distributor_Authorization_WWID__c, Service_Date__c, TSR3__c, Email_Address__c, Repair_Completion__c, TSR4__c, PACCAR_Authorization_FN__c, PACCAR_Authorization_LN__c, PACCAR_Authorization_WWID__c, Location__c, Location_Code__c, CSS_Job__c, Catastrophic__c, TSR5__c, Shop_Work_Order__c, Authorization_Comments__c, ESN__c, TSR6__c, Service_Model__c, TSR7__c, TSR8__c, Account__c, Status__c, TSR9__c, TSR10__c, CoverageResponse__c, Region__c, Territory__c, Claim_Submitted__c, Payment_Details__c, EditComplaint__c, EditCause__c, EditCorrection__c, EditCoverage__c, JobComplaintLastModified__c, JobEditComplaint__c, JobEditCause__c, JobEditCoverage__c, JobEditCorrection__c, JobCauseLastModified__c, JobCorrectionLastModified__c, JobCoverageLastModified__c, Territory_Class__c, CSS_Channel_Of_Distribution__c, Territory_Class_Name__c, CSS_Channel_Code__c, Claims_Category__c, Claims_Category2__c, Claims_Category3__c, Claims_Category4__c, Claims_Category5__c, Claims_Category2_Desc__c, Claims_Category3_Desc__c, Claims_Category4_Desc__c, Claims_Category5_Desc__c, Claims_Complaint_Type__c, Claims_Complaint_Type2__c, Claims_Complaint_Type3__c, Claims_Complaint_Type4__c, Claims_Complaint_Type5__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c, Claims_General_Symptoms__c, Claims_Preventive_Maintenance__c, Claims_Expedited_Service__c, Claims_Additional_Comments__c, Claims_Category_Desc__c, Complaint_Type_Desc__c, CVIN__c, Assigned_To__c, Additional_Tech1__c, Additional_Tech2__c, Additional_Tech3__c, Additional_Tech4__c, Additional_Tech5__c, Additional_Tech6__c, Additional_Tech7__c, Additional_Tech8__c, Additional_Tech9__c, Actual_Technician_Time__c, AccessCode__c, ODM_Status_Message__c, ODM_Pre_submit_Status__c, Claims_city__c, ODM_Status__c, SP_CLAIM_ALLOWED_DAYS__c, InactiveDate__c, SP_PACCAR__c, SP_CHANNEL_OF_DISTRIBUTION__c, SP_REGIONCODE__c, SP_LTA_FLAG__c, SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_ACCOUNT_STATUS__c, SP_TERRITORY_CODE__c, SP_TERRITORY__c, SP_CMI_SP_EXPIRATION__c, BillToCode__c, BuildDate__c, DesignPhaseCode__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_Group_Name__c, SP_PromotionId__c, ODM_Pre_submit_Status_Message__c, ProductApplicationCode__c, SP_INSHOP_LABOR_RATE__c, SP_FIELD_SERVICE_LABOR_RATE__c, ODM_Status_Code__c, SP_SCMDeductiblePercentage__c, SP_WarrantyTrainingStatus__c, SP_State__c, SP_SCMDollarAmt__c, Automotive_App_Flag__c, bmsCreateAccount__c, SP_PrimaryOEMCode__c, CSS_Travel_Rate__c, Information_Only_Claim__c, EngineFamilyName__c, ShipDate__c, ETOOldESN__c, SP_Country__c, Mutual_Exclusive_Message__c, SP_WarrantyCertificationEndDate__c, Pending_Authorization__c, Not_Authorized_Comments__c, License_Plate_State_Error_message__c, Rejection_Comments__c, Amount_Due__c, Available_Credit__c, Credit_Limit__c, Non_SRT_Details__c, Quote_ID__c, SP_AccountStatus__c, SP_BusinessUnit__c, SP_CampaignTRP__c, SP_CommunicationMethod__c, SP_CommunicationOccurrence__c, SP_CostEffectiveExclusion__c, SP_CutOffClaimAmt__c, SP_DisableWebAccessFlag__c, SP_DistributorHQCode__c, SP_DistributorHQName__c, SP_DSID__c, SP_DTNAFlag__c, SP_FreezeSubmitButton__c, SP_MaxClaimAmt__c, SP_NewOEM__c, SP_PMUSplitPayment__c, SP_Policy__c, SP_PrimaryOEMName__c, SP_ProductCertification__c, SP_RepairLevel__c, SP_TechActualHoursRequired__c, SP_ViewDollarAmount__c, SP_WarrantyEmail__c, SP_WarrantyFax__c, SP_WarrantyTrainingCertification__c, SP_WWSPSSPFlag__c, ReconEngineFlag__c, AuthorizationTimeStamp__c, CaptureUserwhoapprovedAuthorized__c, Rejection_Timestamp__c, RejectedByUser__c, Dealer_Service_Job__c, Actual_Time_for_Diagnostics__c, Actual_Time_for_Repair__c, PartReturnToCenter__c, Total_PSN_Count__c, IsCopyclaim__c, Multi_PSN_Claim__c, PACCAR_Flag__c, SiebelClaimNumber__c, PolicyClaim__c FROM CSS_Claims__c limit 1];
        list<CSS_Solution_Component__c> solcomplist=[SELECT Notes__c, ODM_Status_Message__c, Name, Component_Id__c, Service_Model__c, Engine_Family_Code__c, Equip_ID__c, System_Code__c, Unique_Component__c, Component_Code__c, Failure_Mode__c, Fail_Code__c, Fail_Code_Editable__c, CoveredTravelBaseFareAmt__c, CoveredOCAmount__c, CoveredLaborHrs__c, CoveredTowingMiles__c, CampaignLaborPercentage__c, CoveredTravelLabor__c, CertificateNumber__c, CampaignTowingPercentage__c, AccountCodeType__c, CoveredPartsQty__c, Status__c, CampaignOCPercentage__c, DeductibleAmount__c, FailCode_Formula__c, AccountCode__c, CampaignPartsPercentage__c, CoveredMealsLodgingAmt__c, WarrantyId__c, CoveredTravelMiles__c, CampaignTravelPercentage__c, ODM_Status_Code__c, CSS_Account_Formula__c, AccountCodeEdit__c, AccountCode_Call_Status__c, Type__c, Failure_Measure__c, Campaign_Description__c, Business_Unit__c, Authorization_Number__c, Approval_Code__c, CSS_CoverageType__c, URL__c, OldSolCompID__c, Create_User__c, Change_User__c, Selected_Claim_Type__c, SysCodeAndCompCode__c, Claim_FailCode__c, SystemCode_Desc__c, ComponentCode_Desc__c, Fault_Code__c, FailMode_Desc__c, FaultCode_Desc__c, RoadRelay_Warranty__c, OwnerId, CreatedById, LastModifiedById, Service_Job__c, Solutions__c, CSS_Claims__c, Action__c, Parts_Warranty__c, Customer_Take_Possession__c, Pay_Code__c, Claim_Type__c, ODM_Status__c, Id, Quantity__c, SRT_Total__c, CoveredPartsQty_Percentage__c, Failure_Point__c, CreatedDate, LastModifiedDate, SystemModstamp,LastActivityDate, Part_Warranty_Start_Date__c, Failure_Date__c, Campaign_Start_Date__c, Campaign_End_Date__c, IsDeleted, Selected_Component__c, Charlength__c, SRT_Fetched__c, In_Shop_SRT_Limit_Flag__c, Multiple_Times__c, Complete_Indicator__c, Performed__c, Performed_Review__c, Reviewed__c, Claims_Failure_Select__c, Info_Only_Claim__c FROM CSS_Solution_Component__c];
        list<CSS_JobEventTemporary__c> jobevtlist=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Source__c, Type__c, JobOrder__c, Key__c, KeyType__c, Attribute1__c, Attribute2__c, Attribute3__c, Attribute4__c, Attribute5__c, Attribute6__c, Attribute7__c, Attribute8__c, Attribute9__c, Attribute10__c, ExpireDateTime__c, RawData__c, Attribute11__c, Attribute12__c, Attribute13__c, Attribute14__c, Circuit_Description__c, Comp_Location__c, Effect__c, Engine__c, Fault_Code_Description__c, File_Name__c, FMI__c, Lamp__c, Reason__c, Service_Model_Name__c, SPN__c, SRT_Access_Checklist__c, Attribute15__c, Active__c, Account_Code__c FROM CSS_JobEventTemporary__c];
        list<CSS_Parts_Options__c> partoplist=[SELECT Id,recordtype.name, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Option_Number__c, Repair_Group__c, Group_Name__c, Service_Job__c, Option_ESN__c, Part_Name__c, Part_Description__c, OEM__c, Parts_Type__c, Service_partnumber__c, Quantity__c, part_size__c, Notes__c, Unique_Parts_Option__c, FailureName__c, selected_part__c, FailurepartId__c, Assignment__c, Solutions__c, Replacement_Reason__c, Part_Assignment__c, ReturnToFactory__c, Covered__c, Fail_Code__c, Default_Part_Quantity__c, Account_Code__c, Item__c, Quantity_Ordered__c, Technician__c, Type__c, Days__c, Mileage__c, HoursTravelled__c, ExpenseTotal__c, CSS_Claims__c, Tracking_Number__c, RID__c, Amount__c, Quantity_Used__c, Parts_Return__c, Sell_Price__c, Warranty_Allocation__c, Comments__c, Line_Type__c, Serial_Number__c, Serial_Number_Vendor__c, Model__c, Option__c, SSN__c, VIN__c, PartOC__c, Address1__c, Address2__c, City__c, State__c, Zip__c, Create_User__c, Create_Date__c, Change_User__c, Change_Date__c, Claim_Type__c, Css_Estimate__c, isManual__c, ODM_Status__c, ODM_Status_Message__c, Get_Fail_Code_Formula__c, Unit_Price__c, Previous_Item__c, BMS_Quantity__c, Claimtype__c, Price_Book__c, ReturnWaiver__c, Return_Instructions__c, Misc_LOV__c, Siebel_Value__c, Item_BMS__c, Type_BMS__c, ODM_Status_Code__c, Siebel_Claim_Number__c, Shipping_Address__c, Info_Only_Claim__c FROM CSS_Parts_Options__c];
        
        test.startTest();
        Map<string,list<CSS_Solution_Component__c>> mapSolComp= new  Map<string, list<CSS_Solution_Component__c>>();
        mapSolComp.put('35',lstSComp);

        system.debug('Starts>>');
        system.debug('SOLIST12>>'+SOLIST12);
        list<CG_ODM_ResJSONParser.message> nullList;
       CG_BL_ODM.ODMFailureChevronDisplayMsgs  = nullList;
        CG_BL_ODM.callODMHeaderValidationClaimService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', solcomplist, 'WarrantyOverview');
        CG_BL_ODM.callODMHeaderValidationClaimService(jo, testclaimsRec, testpsnNewRec, 'JOB', solcomplist, null);
        CG_BL_ODM.callODMHeaderValidationService(jo, testclaimsRec, testpsnNewRec, 'JOB', solcomplist, NULL);
        CG_BL_ODM.callODMHeaderValidationService(jo, testclaimsRec, testpsnNewRec, 'JOB', solcomplist, 'WarrantyOverview');
        
        CG_BL_ODM.callODMHeaderValidationService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', solcomplist, 'WarrantyOverview');
        CG_BL_ODM.callODMFailureValidationService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', solcomplist, 'FailureChevron');
        CG_BL_ODM.callODMFailureValidationService(jo, testclaimsRec, testpsnNewRec, 'JOB', solcomplist, NULL);
        CG_BL_ODM.callClaimsODMPartsValidationService(jo, claimsobj, testpsnNewRec, 'CLAIM', solcomplist, partoplist, TRUE);
        CG_BL_ODM.callClaimsODMPartsValidationService(jo, claimsobj, testpsnNewRec, 'CLAIM', solcomplist, partoplist, false);
        
        system.debug('ends>>');
        
        test.stopTest();
    }
    static testmethod void testmethod12()
    {
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        list<CSS_Integration_Details__c> conDetailslist=[select id,name,AuthEnv__c,ApplicationName__c,End_Point__c,Method_Type__c,Timeout__c from CSS_Integration_Details__c];
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        jo.ODM_Status_Message__c='ODM Message';
        insert jo;
        
        list<id> idlist = new list<id>();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.Account__C = acc.id;
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        
        insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = testclaimsRec.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        // AddsolComp.AccountCode__c = 'EMSWarranty35';
        AddsolComp.AccountCodeEdit__c = 'EMSWarranty36';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        AddsolComp.Service_Job__c=jo.id;
        Addsolcomp.ODM_Status__c='ERROR';
        //   insert AddsolComp;
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        Addsolcomp1.System_Code__c='AB';
        Addsolcomp1.Component_Code__c='CD';
        AddsolComp1.CSS_Claims__c = testclaimsRec.id;
        AddsolComp1.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.Selected_Component__c = True;
        // AddsolComp1.AccountCode__c = 'EMSWarranty35';
        AddsolComp1.AccountCodeEdit__c = 'EMSWarranty35';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
        AddsolComp1.Service_Job__c=null;
        // insert AddsolComp1;
        idlist.add(AddsolComp1.id);
        LIST<CSS_Solution_Component__c> SOLIST12=NEW LIST<CSS_Solution_Component__c>();
        SOLIST12.add(AddsolComp1);
        SOLIST12.add(AddsolComp);
        insert SOLIST12;
        
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
        Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        Id recTypeIdTTML = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c ='EMSWarranty35'; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.Fail_Code__c='ABCD';
        po.ODM_Status__c = '';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
        CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = null;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c ='EMSWarranty35'; 
        // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id;
        po1.Fail_Code__c='ABCD';
        po1.ODM_Status__c = 'ERROR';
        lstpo.add(po1);
        
        CSS_Parts_Options__c po2 =new CSS_Parts_Options__c();
        po2.Notes__c='123';
        po2.RecordTypeId = recTypeIdpart;
        po2.CSS_Claims__c = testclaimsRec.id;
        po.Service_Job__c=jo.Id;
        po2.OEM__c ='123';
        po2.Quantity__c =1;
        po2.Selected_part__c =true;
        po2.Part_Name__c ='123456';
        po2.Service_partnumber__c ='123';
        po2.Parts_Type__c ='Custom';
        po2.Fail_Code__c='ABCD';
        po2.Account_Code__c ='EMSWarranty35';
        // po1.Solutions__c=solRef.id;
        po2.FailurepartId__c =AddsolComp.Id; 
        po2.ODM_Status__c = 'ERROR';
        lstpo.add(po2);
        CSS_Parts_Options__c po5 =new CSS_Parts_Options__c();
        po5.Notes__c='123';
        po5.RecordTypeId = recTypeIdTTML;
        po5.CSS_Claims__c = null;
        po5.OEM__c ='123';
        po5.Quantity__c =1;
        po5.Selected_part__c =true;
        po5.Part_Name__c ='123456';
        po5.Service_partnumber__c ='123';
        po5.Parts_Type__c ='Custom';
        po5.Account_Code__c ='EMSWarranty35'; 
        // po5.Solutions__c=solRef.id;
        po5.FailurepartId__c =AddsolComp.Id;
        po5.Fail_Code__c='ABCD';
        po5.ODM_Status__c = 'ERROR';
        lstpo.add(po5);
        insert lstpo;
        list<CSS_Job_Order__c> jolist =new list<CSS_Job_Order__c>();
        jolist.add(jo);
        
          CSS_Job_Order__c servicejob= new CSS_Job_Order__c();
        servicejob.Status__c = 'Intake';
        servicejob.INSITE_UpdateTimeStamp__c =system.today();
        servicejob.INSITE_ESN_Choice__c='Not Selected';
        servicejob.Qsol_Engine_Family_Code__c = 'code';
        servicejob.Warranty_Start_Date__c = date.today();
        servicejob.CSS_Job_Location_Code__c = 'location';
        servicejob.DSID_WorkGroup__c='Wrkgrp';
        servicejob.Status__c = 'Triage & Diagnosis Complete' ;
        servicejob.Previous_Status__c = 'Triage & Diagnosis' ;
        servicejob.Failure_Date__c = date.today();
        servicejob.Account__c = acc.id;
        insert servicejob;
        
    
        CSS_PSN__c psnobj=[SELECT Id, Name, CSS_Claims__c, Unit_Number__c, Application__c, License_Plate_State__c, Service_Model__c, Make__c, Model__c, VIN__c, Product_Hours__c, Warranty_Start_Date__c, Mileage_Measure__c, Unit_Type__c, Failure_Date__c, Primary__c, Before_In_Service__c, Mileage__c, Qsol_Engine_Family_Code__c, Qsol_Warranty_Start__c, Qsol_Technical_Config__c, Mission_Disabling__c, Calibration_Before__c, Calibration_After__c, Justification__c, PSN__c, CoverageFlag__c, Equipment_ID__c, AccessCode__c, ApplicationCode__c, Warranty_Authorization_Flag__c, Location_Certification__c, Revision_Before__c, Revision_After__c, Failure_Point__c, ProductAppcodeErrorflag__c, Siebel_Claim_No__c FROM CSS_PSN__c limit 1];
       // CSS_Claims__c claimsobj = [SELECT Id, OwnerId, IsDeleted,Account__r.RSS_RESP_BRANCH_CODE__c, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp,Customer_Name__c, Customer_Code__c, Contact_First_Name__c, Contact_Last_Name__c, Address__c, Contact_Id__c, Country__c, State__c, Customer_Phone__c, ZipCode__c, TSR1__c, Customer_Contact_Phone__c, Distributor_Authorization_FN__c, TSR2__c, Distributor_Authorization_LN__c, Repair_Location__c, Distributor_Authorization_WWID__c, Service_Date__c, TSR3__c, Email_Address__c, Repair_Completion__c, TSR4__c, PACCAR_Authorization_FN__c, PACCAR_Authorization_LN__c, PACCAR_Authorization_WWID__c, Location__c, Location_Code__c, CSS_Job__c, Catastrophic__c, TSR5__c, Shop_Work_Order__c, Authorization_Comments__c, ESN__c, TSR6__c, Service_Model__c, TSR7__c, TSR8__c, Account__c, Status__c, TSR9__c, TSR10__c, CoverageResponse__c, Region__c, Territory__c, Claim_Submitted__c, Payment_Details__c, EditComplaint__c, EditCause__c, EditCorrection__c, EditCoverage__c, JobComplaintLastModified__c, JobEditComplaint__c, JobEditCause__c, JobEditCoverage__c, JobEditCorrection__c, JobCauseLastModified__c, JobCorrectionLastModified__c, JobCoverageLastModified__c, Territory_Class__c, CSS_Channel_Of_Distribution__c, Territory_Class_Name__c, CSS_Channel_Code__c, Claims_Category__c, Claims_Category2__c, Claims_Category3__c, Claims_Category4__c, Claims_Category5__c, Claims_Category2_Desc__c, Claims_Category3_Desc__c, Claims_Category4_Desc__c, Claims_Category5_Desc__c, Claims_Complaint_Type__c, Claims_Complaint_Type2__c, Claims_Complaint_Type3__c, Claims_Complaint_Type4__c, Claims_Complaint_Type5__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c, Claims_General_Symptoms__c, Claims_Preventive_Maintenance__c, Claims_Expedited_Service__c, Claims_Additional_Comments__c, Claims_Category_Desc__c, Complaint_Type_Desc__c, CVIN__c, Assigned_To__c, Additional_Tech1__c, Additional_Tech2__c, Additional_Tech3__c, Additional_Tech4__c, Additional_Tech5__c, Additional_Tech6__c, Additional_Tech7__c, Additional_Tech8__c, Additional_Tech9__c, Actual_Technician_Time__c, AccessCode__c, ODM_Status_Message__c, ODM_Pre_submit_Status__c, Claims_city__c, ODM_Status__c, SP_CLAIM_ALLOWED_DAYS__c, InactiveDate__c,  SP_PACCAR__c, SP_CHANNEL_OF_DISTRIBUTION__c, SP_REGIONCODE__c, SP_LTA_FLAG__c, SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_ACCOUNT_STATUS__c, SP_TERRITORY_CODE__c, SP_TERRITORY__c, SP_CMI_SP_EXPIRATION__c, BillToCode__c, BuildDate__c, DesignPhaseCode__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_Group_Name__c, SP_PromotionId__c, ODM_Pre_submit_Status_Message__c, ProductApplicationCode__c, SP_INSHOP_LABOR_RATE__c, SP_FIELD_SERVICE_LABOR_RATE__c, ODM_Status_Code__c, SP_SCMDeductiblePercentage__c, SP_WarrantyTrainingStatus__c, SP_State__c, SP_SCMDollarAmt__c, Automotive_App_Flag__c, bmsCreateAccount__c, SP_PrimaryOEMCode__c, CSS_Travel_Rate__c, Information_Only_Claim__c, EngineFamilyName__c, ShipDate__c, ETOOldESN__c, SP_Country__c, Mutual_Exclusive_Message__c, SP_WarrantyCertificationEndDate__c, Pending_Authorization__c, Not_Authorized_Comments__c, License_Plate_State_Error_message__c, Rejection_Comments__c, Amount_Due__c, Available_Credit__c, Credit_Limit__c, Non_SRT_Details__c, Quote_ID__c, SP_AccountStatus__c, SP_BusinessUnit__c, SP_CampaignTRP__c, SP_CommunicationMethod__c, SP_CommunicationOccurrence__c, SP_CostEffectiveExclusion__c, SP_CutOffClaimAmt__c, SP_DisableWebAccessFlag__c, SP_DistributorHQCode__c, SP_DistributorHQName__c, SP_DSID__c, SP_DTNAFlag__c, SP_FreezeSubmitButton__c, SP_MaxClaimAmt__c, SP_NewOEM__c, SP_PMUSplitPayment__c, SP_Policy__c, SP_PrimaryOEMName__c, SP_ProductCertification__c, SP_RepairLevel__c, SP_TechActualHoursRequired__c, SP_ViewDollarAmount__c, SP_WarrantyEmail__c, SP_WarrantyFax__c, SP_WarrantyTrainingCertification__c, SP_WWSPSSPFlag__c, ReconEngineFlag__c, AuthorizationTimeStamp__c, CaptureUserwhoapprovedAuthorized__c, Rejection_Timestamp__c, RejectedByUser__c, Dealer_Service_Job__c, Actual_Time_for_Diagnostics__c, Actual_Time_for_Repair__c, PartReturnToCenter__c, Total_PSN_Count__c, IsCopyclaim__c, Multi_PSN_Claim__c, PACCAR_Flag__c, SiebelClaimNumber__c, PolicyClaim__c FROM CSS_Claims__c limit 1];
        list<CSS_Solution_Component__c> solcomplist=[SELECT Notes__c, ODM_Status_Message__c, Name, Component_Id__c, Service_Model__c, Engine_Family_Code__c, Equip_ID__c, System_Code__c, Unique_Component__c, Component_Code__c, Failure_Mode__c, Fail_Code__c, Fail_Code_Editable__c, CoveredTravelBaseFareAmt__c, CoveredOCAmount__c, CoveredLaborHrs__c, CoveredTowingMiles__c, CampaignLaborPercentage__c, CoveredTravelLabor__c, CertificateNumber__c, CampaignTowingPercentage__c, AccountCodeType__c, CoveredPartsQty__c, Status__c, CampaignOCPercentage__c, DeductibleAmount__c, FailCode_Formula__c, AccountCode__c, CampaignPartsPercentage__c, CoveredMealsLodgingAmt__c, WarrantyId__c, CoveredTravelMiles__c, CampaignTravelPercentage__c, ODM_Status_Code__c, CSS_Account_Formula__c, AccountCodeEdit__c, AccountCode_Call_Status__c, Type__c, Failure_Measure__c, Campaign_Description__c, Business_Unit__c, Authorization_Number__c, Approval_Code__c, CSS_CoverageType__c, URL__c, OldSolCompID__c, Create_User__c, Change_User__c, Selected_Claim_Type__c, SysCodeAndCompCode__c, Claim_FailCode__c, SystemCode_Desc__c, ComponentCode_Desc__c, Fault_Code__c, FailMode_Desc__c, FaultCode_Desc__c, RoadRelay_Warranty__c, OwnerId, CreatedById, LastModifiedById, Service_Job__c, Solutions__c, CSS_Claims__c, Action__c, Parts_Warranty__c, Customer_Take_Possession__c, Pay_Code__c, Claim_Type__c, ODM_Status__c, Id, Quantity__c, SRT_Total__c, CoveredPartsQty_Percentage__c, Failure_Point__c, CreatedDate, LastModifiedDate, SystemModstamp, lastActivityDate,Part_Warranty_Start_Date__c, Failure_Date__c, Campaign_Start_Date__c, Campaign_End_Date__c, IsDeleted, Selected_Component__c, Charlength__c, SRT_Fetched__c, In_Shop_SRT_Limit_Flag__c, Multiple_Times__c, Complete_Indicator__c, Performed__c, Performed_Review__c, Reviewed__c, Claims_Failure_Select__c, Info_Only_Claim__c FROM CSS_Solution_Component__c];
        list<CSS_JobEventTemporary__c> jobevtlist=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Source__c, Type__c, JobOrder__c, Key__c, KeyType__c, Attribute1__c, Attribute2__c, Attribute3__c, Attribute4__c, Attribute5__c, Attribute6__c, Attribute7__c, Attribute8__c, Attribute9__c, Attribute10__c, ExpireDateTime__c, RawData__c, Attribute11__c, Attribute12__c, Attribute13__c, Attribute14__c, Circuit_Description__c, Comp_Location__c, Effect__c, Engine__c, Fault_Code_Description__c, File_Name__c, FMI__c, Lamp__c, Reason__c, Service_Model_Name__c, SPN__c, SRT_Access_Checklist__c, Attribute15__c, Active__c, Account_Code__c FROM CSS_JobEventTemporary__c];
        list<CSS_Parts_Options__c> partoplist=[SELECT Id,recordtype.name, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Option_Number__c, Repair_Group__c, Group_Name__c, Service_Job__c, Option_ESN__c, Part_Name__c, Part_Description__c, OEM__c, Parts_Type__c, Service_partnumber__c, Quantity__c, part_size__c, Notes__c, Unique_Parts_Option__c, FailureName__c, selected_part__c, FailurepartId__c, Assignment__c, Solutions__c, Replacement_Reason__c, Part_Assignment__c, ReturnToFactory__c, Covered__c, Fail_Code__c, Default_Part_Quantity__c, Account_Code__c, Item__c, Quantity_Ordered__c, Technician__c, Type__c, Days__c, Mileage__c, HoursTravelled__c, ExpenseTotal__c, CSS_Claims__c, Tracking_Number__c, RID__c, Amount__c, Quantity_Used__c, Parts_Return__c, Sell_Price__c, Warranty_Allocation__c, Comments__c, Line_Type__c, Serial_Number__c, Serial_Number_Vendor__c, Model__c, Option__c, SSN__c, VIN__c, PartOC__c, Address1__c, Address2__c, City__c, State__c, Zip__c, Create_User__c, Create_Date__c, Change_User__c, Change_Date__c, Claim_Type__c, Css_Estimate__c, isManual__c, ODM_Status__c, ODM_Status_Message__c, Get_Fail_Code_Formula__c, Unit_Price__c, Previous_Item__c, BMS_Quantity__c, Claimtype__c, Price_Book__c, ReturnWaiver__c, Return_Instructions__c, Misc_LOV__c, Siebel_Value__c, Item_BMS__c, Type_BMS__c, ODM_Status_Code__c, Siebel_Claim_Number__c, Shipping_Address__c, Info_Only_Claim__c FROM CSS_Parts_Options__c];
        CSS_SRT__c srt=css_testdata.createSRT(false,'repair',solRef.Id,jo.Id);
        srt.CSS_Claims__c = testclaimsRec.Id;
        srt.SRT_ID__c='001';
        SRT.isPerformed__c=TRUE;
        srt.ODM_Status__c='ERROR';
        SRT.Account_Code__c='EMSWarranty35';
        SRT.Account_Code_Description__c='EMSWarranty35';
        SRT.Type__c='Repair';
        SRT.FailCode__c='ABCD';
        
        CSS_srt__c srt1=css_testdata.createsrt(false,'repair',solRef.Id,jo.Id);
        srt1.CSS_Claims__c = testclaimsRec.Id;
        srt1.srt_ID__c='002';
        srt1.isPerformed__c=TRUE;
        srt1.ODM_Status__c='ERROR';
        srt1.Account_Code__c='EMSWarranty35';
        srt1.Account_Code_Description__c='EMSWarranty35';
        srt1.Type__c='Repair';
        srt1.FailCode__c='ABC';
        
        LIST<CSS_SRT__c> SRTLIST = new  LIST<CSS_SRT__c>();
        SRTLIST.add(SRT);
        SRTLIST.add(srt1);
        //insert SRTLIST;
        
        
        LIST<CSS_SRT__c> SRTLst1=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, SRT_Time_String__c, SRT_Decimal_Time__c, SRT_Title__c, SRT_Type__c, SRT_Order__c, SRT_Warrantable__c, Access_Code__c, SRT_Select__c, Override__c, OverrideReason__c, Special_Access_Code__c, Special_Access_Code_Desc__c, Percentage__c, Step_Description__c, SRT_Details__c, Overlap__c, SRT_Access_Code__c, SRT_Message__c, Access_Code_S1__c, SRT_Time__c, Access_Code_S2__c, SRT_ID__c, Access_Code_S3__c, Type__c, Job_Order__c, Access_Code_S4__c, Access_Code_A__c, Access_Code_B__c, Access_Code_D__c, Access_Code_R__c, Access_Code_C__c, Access_Code_S5__c, Access_Code_S6__c, SRT_AccessiblityCheck__c, Solution_Number__c, SRTAdmi_Check__c, SRT_Notes__c, Component_Id__c, Solution_Title__c, Access_Code_S7__c, isPerformed__c, SRT_Quantity__c, Job_Engine_Access_Code__c, Diagnosis_Time__c, CSS_UniqueSRTValues__c, CaseName__c, SRT_Status_Message__c, Response_Message__c, Assignment__c, Step_Id__c, Access_Code_S8__c, SRT_Category__c, Failure_Name__c, SRT_Time_Hr_Min__c, Admin_Miles_In__c, Admin_Miles_Out__c, Admin_Left_Shop__c, Admin_Arrive_Job__c, Admin_Start_Job__c, Admin_Finish_Job__c, Admin_Leave_Job__c, Admin_Arrive_Shop__c, Access_Code_S9__c, S1_Description__c, S2_Description__c, S3_Description__c, S4_Description__c, S5_Description__c, S6_Description__c, S7_Description__c, S8_Description__c, S9_Description__c, Access_Code_Saved__c, Diag_Access_Time__c, Repair_Time__c, Additional_SRT_Calculated__c, Repair_Access_Calculated__c, Adjustment_Reason__c, Quote_ID__c, SRT_Family__c, Component_Type__c, Actual_Hour__c, Billed_Hour__c, Bill__c, Troubleshoot__c, Flexible__c, Private_Work__c, Service_Model_Name__c, Warranty_Allocation__c, Account_Code__c, Claim_Type__c, Create_Date__c, Create_User__c, Change_Date__c, Change_User__c, CSS_Claims__c, Overlap_SRT_Number__c, SRT_Group_Desc__c, ODM_Status__c, FailCode__c, Claimed_Hours__c,  Fail_Code_Description__c, Account_Code_Description__c, IsPopUpSRT__c, Overlap_Step_Id__c, Calculated_Claimed_Hours__c, Overlap_SRT_Title__c, Overlap_Hours__c, Adjusted_Overlap_Hours__c, Extended_Hours__c, Symptom_Name__c, Fault_Code_Name__c, AccountCode_Formula__c, SRT_Estimate__c, Hours_BMS__c, Troubleshoot_BMS__c, Flexible_BMS__c, Private_BMS__c, Special_BMS__c, ODM_Status_Message__c, SRT_Amount__c, isSrtFailCode__c, ODM_Status_Code__c, SRT_Time_Formula__c, Info_Only_Claim__c FROM CSS_SRT__c];
        
        test.startTest();
        system.debug('Starts>>');
        system.debug('SOLIST12>>'+SOLIST12);
        //CG_BL_ODM.ODMMessage='success';
        CG_BL_ODM.callODMHeaderValidationClaimService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', solcomplist, 'WarrantyOverview');
        CG_BL_ODM.callODMHeaderValidationClaimService(jo, testclaimsRec, testpsnNewRec, 'JOB', solcomplist, null);
        CG_BL_ODM.callODMHeaderValidationService(jo, testclaimsRec, testpsnNewRec, 'JOB', solcomplist, NULL);
        CG_BL_ODM.callODMHeaderValidationService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', solcomplist, 'WarrantyOverview');
        CG_BL_ODM.callClaimsODMPartsValidationService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', solcomplist, partoplist, TRUE);
        CG_BL_ODM.callClaimsODMPartsValidationService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', solcomplist, partoplist, false);
        CG_BL_ODM.callODMSRTServices('Claim', testclaimsRec.id);
        CG_BL_ODM.callODMSRTServices('Job', servicejob.id);
        CG_BL_ODM.callODMSRTServicesold('Claim', testclaimsRec.id);
        CG_BL_ODM.callODMSRTServicesold('Job', servicejob.id);
        
        Map<string,list<CSS_Solution_Component__c>> SCAccountCodeMap= new  Map<string, list<CSS_Solution_Component__c>>();
        SCAccountCodeMap.put('35',solcomplist);
        
       
        Map<string,list<CSS_Parts_Options__c>> POAccountCodeMap=new Map<string, list<CSS_Parts_Options__c>>();
        POAccountCodeMap.put('35ABCD',partoplist);
        Map<string,list<CSS_SRT__c>> SRTAccountCodeMap = new Map<string,list<CSS_SRT__c>>();
        SRTAccountCodeMap.put('35ABCD',SRTLst1);
        List<String> partsWarranty = new List<String>();
        partsWarranty.add('35');
        partsWarranty.add('36');
        List<String> fieldActionClaimAcc = new List<String>();
        fieldActionClaimAcc.add('Test');
        fieldActionClaimAcc.add('Test1');
        fieldActionClaimAcc.add('Test2');
        
        CG_BL_ODM.performODMPreSubmitServiceCS(SCAccountCodeMap, POAccountCodeMap, SRTAccountCodeMap, partsWarranty, fieldActionClaimAcc, testclaimsRec, psnobj, servicejob, true);
        CG_BL_ODM.performODMPreSubmitServiceCS(SCAccountCodeMap, POAccountCodeMap, SRTAccountCodeMap, partsWarranty, fieldActionClaimAcc, testclaimsRec, psnobj, servicejob, false);
        
        system.debug('ends>>');
        
        test.stopTest();
    }
    static testmethod void testmethod13(){
        
        list<CSS_Integration_Details__c> conDetailslist=[select id,name,AuthEnv__c,ApplicationName__c,End_Point__c,Method_Type__c,Timeout__c from CSS_Integration_Details__c];
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        jo.ODM_Status_Message__c='ODM Message';
        insert jo;
        list<id> idlist = new list<id>();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        
        insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = testclaimsRec.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        // AddsolComp.AccountCode__c = 'EMSWarranty35';
        AddsolComp.AccountCodeEdit__c = 'EMSWarranty36';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        AddsolComp.Service_Job__c=jo.id;
        Addsolcomp.ODM_Status__c='ERROR';
        //   insert AddsolComp;
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        Addsolcomp1.System_Code__c='AB';
        Addsolcomp1.Component_Code__c='CD';
        AddsolComp1.CSS_Claims__c = testclaimsRec.id;
        AddsolComp1.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.Selected_Component__c = True;
        // AddsolComp1.AccountCode__c = 'EMSWarranty35';
        AddsolComp1.AccountCodeEdit__c = 'EMSWarranty35';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
        AddsolComp1.Service_Job__c=null;
        // insert AddsolComp1;
        idlist.add(AddsolComp1.id);
        LIST<CSS_Solution_Component__c> SOLIST12=NEW LIST<CSS_Solution_Component__c>();
        SOLIST12.add(AddsolComp1);
        SOLIST12.add(AddsolComp);
        insert SOLIST12;
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
        Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        Id recTypeIdTTML = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c ='EMSWarranty35'; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.Fail_Code__c='ABCD';
        po.ODM_Status__c = '';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
        CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = null;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c ='EMSWarranty35'; 
        // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id;
        po1.Fail_Code__c='ABCD';
        po1.ODM_Status__c = 'ERROR';
        lstpo.add(po1);
        
        CSS_Parts_Options__c po2 =new CSS_Parts_Options__c();
        po2.Notes__c='123';
        po2.RecordTypeId = recTypeIdpart;
        po2.CSS_Claims__c = testclaimsRec.id;
        po.Service_Job__c=jo.Id;
        po2.OEM__c ='123';
        po2.Quantity__c =1;
        po2.Selected_part__c =true;
        po2.Part_Name__c ='123456';
        po2.Service_partnumber__c ='123';
        po2.Parts_Type__c ='Custom';
        po2.Fail_Code__c='ABCD';
        po2.Account_Code__c ='EMSWarranty35';
        // po1.Solutions__c=solRef.id;
        po2.FailurepartId__c =AddsolComp.Id; 
        po2.ODM_Status__c = 'ERROR';
        lstpo.add(po2);
        CSS_Parts_Options__c po5 =new CSS_Parts_Options__c();
        po5.Notes__c='123';
        po5.RecordTypeId = recTypeIdTTML;
        po5.CSS_Claims__c = null;
        po5.OEM__c ='123';
        po5.Quantity__c =1;
        po5.Selected_part__c =true;
        po5.Part_Name__c ='123456';
        po5.Service_partnumber__c ='123';
        po5.Parts_Type__c ='Custom';
        po5.Account_Code__c ='EMSWarranty35'; 
        // po5.Solutions__c=solRef.id;
        po5.FailurepartId__c =AddsolComp.Id;
        po5.Fail_Code__c='ABCD';
        po5.ODM_Status__c = 'ERROR';
        po5.Service_Job__c=jo.id;
        lstpo.add(po5);
        insert lstpo;
        list<CSS_Job_Order__c> jolist =new list<CSS_Job_Order__c>();
        jolist.add(jo);
        
        
        CSS_Job_Order__c joorder=[Select Id,Name,IsAppointment__c, bmsCreateAccount__c,CSS_Bms_ContactBoolean__c,Email_Address__c,Email_check_box__c,BMSStatus__c,Contact_ID__c,Customer_Name__c,Customer_Code__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Address__c,City__c,ZipCode__c,Country__c,CSS_Charge_Account_Status__c,Shop_Work_Order__c,Application__c, Unit_Number__c, Status__c, css_resolution__c,CSS_Feedback_Comments__c, Previous_Status__c,previousESN_MultiLoc__c,date_in__c,Date_in_Shop__c,
                                  ESN__c, ESN_IA__c, First_Name__c,BMS_Last_Name__c, Mileage__c,CSS_Hours__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, LastModifiedDate,CreatedDate, Location_Certification__c,CSS_State__c,Primary_Segment__c,Before_In_Service__c,ESN_Locked__c, 
                                  Make__c,Model__c,AccessCode__c,Failure_Date__c,Failure_Point__c,Failure_Point_Measure__c,Service_Model__c,VIN__c,VIN_Flag__c,Warranty_Start_Date__c,Region__c,Creator_Location__c,EditCoverage__c,Unit_Type__c, Sub_Type__c,Account__r.ERP_System__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                                  Repeat_Visit__c,TSR_EscalateNumber__c,RecentVisit__c,Repeat_Or_Recent_Calc__c,JobLocation__c,CSS_Job_Location_Code__c,CreatedById,Qsol_Engine_Family_Code__c,Repair_Location__c,Territory__c,Warranty_Authorization_Flag__c,PSN_Not_Available__c,Sub_Status__c,LastUpdateSubStatus__c,Actual_Technician_Time__c,SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,
                                  ProductApplicationCode__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_Country__c,EngineFamilyName__c,Account__c,SP_ClaimAllowedDays__c,SP_RegionCode__c,SP_TerritoryCode__c,BillToCode__c,DesignPhaseCode__c,Sp_TERRITORY__c,
                                  ProductApplicationDesp__c,warrantyIndicatorFlag__c,Automotive_App_Flag__c,
                                  MarineFlag__c,OemCode__c,EtoConversionDate__c,BuildDate__c,CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c, 
                                  (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC),Category__c,Category2__c,Category3__c,Category4__c,Category5__c,Complaint_Type__c,Complaint_Type2__c,Complaint_Type3__c,Complaint_Type4__c,Complaint_Type5__c, Preventive_Maintenance__c,Expedited_Service__c, Category_Desc__c, Category2_Desc__c, Category3_Desc__c, Category4_Desc__c, Category5_Desc__c, Complaint_Type_Desc__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c, Application_Desc__c,ApplicationCode__c,
                                  (Select Id,Name, Case_Name__c, Service_Job__c,Repair_response__c,Solution_Title__c ,Solution__c,Diagnostic_Response__c FROM CSS_Solutions__r),
                                  (Select id, name , performed__c, performed_review__c, Reviewed__c from CSS_CampTsbTrp__r where performed_review__c=True and performed__c=False),
                                  (select Id,name,OrderReference__c from css_quotes__r)
                                  from CSS_Job_Order__c];
        CSS_PSN__c psnobj=[SELECT Id, Name, CSS_Claims__c, Unit_Number__c, Application__c, License_Plate_State__c, Service_Model__c, Make__c, Model__c, VIN__c, Product_Hours__c, Warranty_Start_Date__c, Mileage_Measure__c, Unit_Type__c, Failure_Date__c, Primary__c, Before_In_Service__c, Mileage__c, Qsol_Engine_Family_Code__c, Qsol_Warranty_Start__c, Qsol_Technical_Config__c, Mission_Disabling__c, Calibration_Before__c, Calibration_After__c, Justification__c, PSN__c, CoverageFlag__c, Equipment_ID__c, AccessCode__c, ApplicationCode__c, Warranty_Authorization_Flag__c, Location_Certification__c, Revision_Before__c, Revision_After__c, Failure_Point__c, ProductAppcodeErrorflag__c, Siebel_Claim_No__c FROM CSS_PSN__c limit 1];
        CSS_Claims__c claimsobj = [SELECT Id, OwnerId, IsDeleted,Account__r.RSS_RESP_BRANCH_CODE__c, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp,Customer_Name__c, Customer_Code__c, Contact_First_Name__c, Contact_Last_Name__c, Address__c, Contact_Id__c, Country__c, State__c, Customer_Phone__c, ZipCode__c, TSR1__c, Customer_Contact_Phone__c, Distributor_Authorization_FN__c, TSR2__c, Distributor_Authorization_LN__c, Repair_Location__c, Distributor_Authorization_WWID__c, Service_Date__c, TSR3__c, Email_Address__c, Repair_Completion__c, TSR4__c, PACCAR_Authorization_FN__c, PACCAR_Authorization_LN__c, PACCAR_Authorization_WWID__c, Location__c, Location_Code__c, CSS_Job__c, Catastrophic__c, TSR5__c, Shop_Work_Order__c, Authorization_Comments__c, ESN__c, TSR6__c, Service_Model__c, TSR7__c, TSR8__c, Account__c, Status__c, TSR9__c, TSR10__c, CoverageResponse__c, Region__c, Territory__c, Claim_Submitted__c, Payment_Details__c, EditComplaint__c, EditCause__c, EditCorrection__c, EditCoverage__c, JobComplaintLastModified__c, JobEditComplaint__c, JobEditCause__c, JobEditCoverage__c, JobEditCorrection__c, JobCauseLastModified__c, JobCorrectionLastModified__c, JobCoverageLastModified__c, Territory_Class__c, CSS_Channel_Of_Distribution__c, Territory_Class_Name__c, CSS_Channel_Code__c, Claims_Category__c, Claims_Category2__c, Claims_Category3__c, Claims_Category4__c, Claims_Category5__c, Claims_Category2_Desc__c, Claims_Category3_Desc__c, Claims_Category4_Desc__c, Claims_Category5_Desc__c, Claims_Complaint_Type__c, Claims_Complaint_Type2__c, Claims_Complaint_Type3__c, Claims_Complaint_Type4__c, Claims_Complaint_Type5__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c, Claims_General_Symptoms__c, Claims_Preventive_Maintenance__c, Claims_Expedited_Service__c, Claims_Additional_Comments__c, Claims_Category_Desc__c, Complaint_Type_Desc__c, CVIN__c, Assigned_To__c, Additional_Tech1__c, Additional_Tech2__c, Additional_Tech3__c, Additional_Tech4__c, Additional_Tech5__c, Additional_Tech6__c, Additional_Tech7__c, Additional_Tech8__c, Additional_Tech9__c, Actual_Technician_Time__c, AccessCode__c, ODM_Status_Message__c, ODM_Pre_submit_Status__c, Claims_city__c, ODM_Status__c, SP_CLAIM_ALLOWED_DAYS__c, InactiveDate__c,  SP_PACCAR__c, SP_CHANNEL_OF_DISTRIBUTION__c, SP_REGIONCODE__c, SP_LTA_FLAG__c, SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_ACCOUNT_STATUS__c, SP_TERRITORY_CODE__c, SP_TERRITORY__c, SP_CMI_SP_EXPIRATION__c, BillToCode__c, BuildDate__c, DesignPhaseCode__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_Group_Name__c, SP_PromotionId__c, ODM_Pre_submit_Status_Message__c, ProductApplicationCode__c, SP_INSHOP_LABOR_RATE__c, SP_FIELD_SERVICE_LABOR_RATE__c, ODM_Status_Code__c, SP_SCMDeductiblePercentage__c, SP_WarrantyTrainingStatus__c, SP_State__c, SP_SCMDollarAmt__c, Automotive_App_Flag__c, bmsCreateAccount__c, SP_PrimaryOEMCode__c, CSS_Travel_Rate__c, Information_Only_Claim__c, EngineFamilyName__c, ShipDate__c, ETOOldESN__c, SP_Country__c, Mutual_Exclusive_Message__c, SP_WarrantyCertificationEndDate__c, Pending_Authorization__c, Not_Authorized_Comments__c, License_Plate_State_Error_message__c, Rejection_Comments__c, Amount_Due__c, Available_Credit__c, Credit_Limit__c, Non_SRT_Details__c, Quote_ID__c, SP_AccountStatus__c, SP_BusinessUnit__c, SP_CampaignTRP__c, SP_CommunicationMethod__c, SP_CommunicationOccurrence__c, SP_CostEffectiveExclusion__c, SP_CutOffClaimAmt__c, SP_DisableWebAccessFlag__c, SP_DistributorHQCode__c, SP_DistributorHQName__c, SP_DSID__c, SP_DTNAFlag__c, SP_FreezeSubmitButton__c, SP_MaxClaimAmt__c, SP_NewOEM__c, SP_PMUSplitPayment__c, SP_Policy__c, SP_PrimaryOEMName__c, SP_ProductCertification__c, SP_RepairLevel__c, SP_TechActualHoursRequired__c, SP_ViewDollarAmount__c, SP_WarrantyEmail__c, SP_WarrantyFax__c, SP_WarrantyTrainingCertification__c, SP_WWSPSSPFlag__c, ReconEngineFlag__c, AuthorizationTimeStamp__c, CaptureUserwhoapprovedAuthorized__c, Rejection_Timestamp__c, RejectedByUser__c, Dealer_Service_Job__c, Actual_Time_for_Diagnostics__c, Actual_Time_for_Repair__c, PartReturnToCenter__c, Total_PSN_Count__c, IsCopyclaim__c, Multi_PSN_Claim__c, PACCAR_Flag__c, SiebelClaimNumber__c, PolicyClaim__c FROM CSS_Claims__c limit 1];
        list<CSS_Solution_Component__c> solcomplist=[SELECT Notes__c, ODM_Status_Message__c, Name, Component_Id__c, Service_Model__c, Engine_Family_Code__c, Equip_ID__c, System_Code__c, Unique_Component__c, Component_Code__c, Failure_Mode__c, Fail_Code__c, Fail_Code_Editable__c, CoveredTravelBaseFareAmt__c, CoveredOCAmount__c, CoveredLaborHrs__c, CoveredTowingMiles__c, CampaignLaborPercentage__c, CoveredTravelLabor__c, CertificateNumber__c, CampaignTowingPercentage__c, AccountCodeType__c, CoveredPartsQty__c, Status__c, CampaignOCPercentage__c, DeductibleAmount__c, FailCode_Formula__c, AccountCode__c, CampaignPartsPercentage__c, CoveredMealsLodgingAmt__c, WarrantyId__c, CoveredTravelMiles__c, CampaignTravelPercentage__c, ODM_Status_Code__c, CSS_Account_Formula__c, AccountCodeEdit__c, AccountCode_Call_Status__c, Type__c, Failure_Measure__c, Campaign_Description__c, Business_Unit__c, Authorization_Number__c, Approval_Code__c, CSS_CoverageType__c, URL__c, OldSolCompID__c, Create_User__c, Change_User__c, Selected_Claim_Type__c, SysCodeAndCompCode__c, Claim_FailCode__c, SystemCode_Desc__c, ComponentCode_Desc__c, Fault_Code__c, FailMode_Desc__c, FaultCode_Desc__c, RoadRelay_Warranty__c, OwnerId, CreatedById, LastModifiedById, Service_Job__c, Solutions__c, CSS_Claims__c, Action__c, Parts_Warranty__c, Customer_Take_Possession__c, Pay_Code__c, Claim_Type__c, ODM_Status__c, Id, Quantity__c, SRT_Total__c, CoveredPartsQty_Percentage__c, Failure_Point__c, CreatedDate, LastModifiedDate, SystemModstamp, lastActivityDate,Part_Warranty_Start_Date__c, Failure_Date__c, Campaign_Start_Date__c, Campaign_End_Date__c, IsDeleted, Selected_Component__c, Charlength__c, SRT_Fetched__c, In_Shop_SRT_Limit_Flag__c, Multiple_Times__c, Complete_Indicator__c, Performed__c, Performed_Review__c, Reviewed__c, Claims_Failure_Select__c, Info_Only_Claim__c FROM CSS_Solution_Component__c];
        list<CSS_JobEventTemporary__c> jobevtlist=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Source__c, Type__c, JobOrder__c, Key__c, KeyType__c, Attribute1__c, Attribute2__c, Attribute3__c, Attribute4__c, Attribute5__c, Attribute6__c, Attribute7__c, Attribute8__c, Attribute9__c, Attribute10__c, ExpireDateTime__c, RawData__c, Attribute11__c, Attribute12__c, Attribute13__c, Attribute14__c, Circuit_Description__c, Comp_Location__c, Effect__c, Engine__c, Fault_Code_Description__c, File_Name__c, FMI__c, Lamp__c, Reason__c, Service_Model_Name__c, SPN__c, SRT_Access_Checklist__c, Attribute15__c, Active__c, Account_Code__c FROM CSS_JobEventTemporary__c];
        list<CSS_Parts_Options__c> partoplist=[SELECT Id,recordtype.name, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Option_Number__c, Repair_Group__c, Group_Name__c, Service_Job__c, Option_ESN__c, Part_Name__c, Part_Description__c, OEM__c, Parts_Type__c, Service_partnumber__c, Quantity__c, part_size__c, Notes__c, Unique_Parts_Option__c, FailureName__c, selected_part__c, FailurepartId__c, Assignment__c, Solutions__c, Replacement_Reason__c, Part_Assignment__c, ReturnToFactory__c, Covered__c, Fail_Code__c, Default_Part_Quantity__c, Account_Code__c, Item__c, Quantity_Ordered__c, Technician__c, Type__c, Days__c, Mileage__c, HoursTravelled__c, ExpenseTotal__c, CSS_Claims__c, Tracking_Number__c, RID__c, Amount__c, Quantity_Used__c, Parts_Return__c, Sell_Price__c, Warranty_Allocation__c, Comments__c, Line_Type__c, Serial_Number__c, Serial_Number_Vendor__c, Model__c, Option__c, SSN__c, VIN__c, PartOC__c, Address1__c, Address2__c, City__c, State__c, Zip__c, Create_User__c, Create_Date__c, Change_User__c, Change_Date__c, Claim_Type__c, Css_Estimate__c, isManual__c, ODM_Status__c, ODM_Status_Message__c, Get_Fail_Code_Formula__c, Unit_Price__c, Previous_Item__c, BMS_Quantity__c, Claimtype__c, Price_Book__c, ReturnWaiver__c, Return_Instructions__c, Misc_LOV__c, Siebel_Value__c, Item_BMS__c, Type_BMS__c, ODM_Status_Code__c, Siebel_Claim_Number__c, Shipping_Address__c, Info_Only_Claim__c FROM CSS_Parts_Options__c];
        CSS_SRT__c srt=css_testdata.createSRT(false,'repair',solRef.Id,jo.Id);
        srt.CSS_Claims__c=claimsobj.Id;
        srt.SRT_ID__c='001';
        SRT.isPerformed__c=TRUE;
        srt.ODM_Status__c='ERROR';
        SRT.Account_Code__c='EMSWarranty35';
        SRT.Account_Code_Description__c='EMSWarranty35';
        SRT.Type__c='Repair';
        SRT.FailCode__c='ABCD';
        CSS_srt__c srt1=css_testdata.createsrt(false,'repair',solRef.Id,jo.Id);
        srt1.CSS_Claims__c=claimsobj.Id;
        srt1.srt_ID__c='002';
        srt1.isPerformed__c=TRUE;
        srt1.ODM_Status__c='ERROR';
        srt1.Account_Code__c='EMSWarranty35';
        srt1.Account_Code_Description__c='EMSWarranty35';
        srt1.Type__c='Repair';
        srt1.FailCode__c='ABC';
        LIST<CSS_SRT__c> SRTLIST = new  LIST<CSS_SRT__c>();
        SRTLIST.add(SRT);
        SRTLIST.add(srt1);
        //insert SRTLIST;
        LIST<CSS_SRT__c> SRTLst1=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, SRT_Time_String__c, SRT_Decimal_Time__c, SRT_Title__c, SRT_Type__c, SRT_Order__c, SRT_Warrantable__c, Access_Code__c, SRT_Select__c, Override__c, OverrideReason__c, Special_Access_Code__c, Special_Access_Code_Desc__c, Percentage__c, Step_Description__c, SRT_Details__c, Overlap__c, SRT_Access_Code__c, SRT_Message__c, Access_Code_S1__c, SRT_Time__c, Access_Code_S2__c, SRT_ID__c, Access_Code_S3__c, Type__c, Job_Order__c, Access_Code_S4__c, Access_Code_A__c, Access_Code_B__c, Access_Code_D__c, Access_Code_R__c, Access_Code_C__c, Access_Code_S5__c, Access_Code_S6__c, SRT_AccessiblityCheck__c, Solution_Number__c, SRTAdmi_Check__c, SRT_Notes__c, Component_Id__c, Solution_Title__c, Access_Code_S7__c, isPerformed__c, SRT_Quantity__c, Job_Engine_Access_Code__c, Diagnosis_Time__c, CSS_UniqueSRTValues__c, CaseName__c, SRT_Status_Message__c, Response_Message__c, Assignment__c, Step_Id__c, Access_Code_S8__c, SRT_Category__c, Failure_Name__c, SRT_Time_Hr_Min__c, Admin_Miles_In__c, Admin_Miles_Out__c, Admin_Left_Shop__c, Admin_Arrive_Job__c, Admin_Start_Job__c, Admin_Finish_Job__c, Admin_Leave_Job__c, Admin_Arrive_Shop__c, Access_Code_S9__c, S1_Description__c, S2_Description__c, S3_Description__c, S4_Description__c, S5_Description__c, S6_Description__c, S7_Description__c, S8_Description__c, S9_Description__c, Access_Code_Saved__c, Diag_Access_Time__c, Repair_Time__c, Additional_SRT_Calculated__c, Repair_Access_Calculated__c, Adjustment_Reason__c, Quote_ID__c, SRT_Family__c, Component_Type__c, Actual_Hour__c, Billed_Hour__c, Bill__c, Troubleshoot__c, Flexible__c, Private_Work__c, Service_Model_Name__c, Warranty_Allocation__c, Account_Code__c, Claim_Type__c, Create_Date__c, Create_User__c, Change_Date__c, Change_User__c, CSS_Claims__c, Overlap_SRT_Number__c, SRT_Group_Desc__c, ODM_Status__c, FailCode__c, Claimed_Hours__c,  Fail_Code_Description__c, Account_Code_Description__c, IsPopUpSRT__c, Overlap_Step_Id__c, Calculated_Claimed_Hours__c, Overlap_SRT_Title__c, Overlap_Hours__c, Adjusted_Overlap_Hours__c, Extended_Hours__c, Symptom_Name__c, Fault_Code_Name__c, AccountCode_Formula__c, SRT_Estimate__c, Hours_BMS__c, Troubleshoot_BMS__c, Flexible_BMS__c, Private_BMS__c, Special_BMS__c, ODM_Status_Message__c, SRT_Amount__c, isSrtFailCode__c, ODM_Status_Code__c, SRT_Time_Formula__c, Info_Only_Claim__c FROM CSS_SRT__c];
        
        test.startTest();
        system.debug('Starts>>');
        system.debug('SOLIST12>>'+SOLIST12);
        //CG_BL_ODM.ODMMessage='succuess';
        CG_BL_ODM.callODMHeaderValidationClaimService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', solcomplist, 'WarrantyOverview');
        CG_BL_ODM.callODMHeaderValidationClaimService(jo, testclaimsRec, testpsnNewRec, 'JOB', solcomplist, null);
        CG_BL_ODM.callODMHeaderValidationService(jo, testclaimsRec, testpsnNewRec, 'JOB', solcomplist, NULL);
        CG_BL_ODM.callODMHeaderValidationService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', solcomplist, 'WarrantyOverview');
        /*  CG_BL_ODM.callODMFailureValidationService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', solcomplist, 'FailureChevron');
CG_BL_ODM.callODMFailureValidationService(jo, testclaimsRec, testpsnNewRec, 'JOB', solcomplist, NULL);*/
        CG_BL_ODM.callClaimsODMPartsValidationService(jo, claimsobj, testpsnNewRec, 'CLAIM', solcomplist, partoplist, TRUE);
        CG_BL_ODM.callClaimsODMPartsValidationService(jo, claimsobj, testpsnNewRec, 'CLAIM', solcomplist, partoplist, false);
        CG_BL_ODM.callODMSRTServices('Claim', claimsobj.id);
        CG_BL_ODM.callODMSRTServices('Job', joorder.id);
        CG_BL_ODM.callODMSRTServicesold('Claim', claimsobj.id);
        CG_BL_ODM.callODMSRTServicesold('Job', joorder.id);
        
        
        Map<string,list<CSS_Solution_Component__c>> SCAccountCodeMap= new  Map<string, list<CSS_Solution_Component__c>>();
        SCAccountCodeMap.put('35',solcomplist);
        
        Map<string,list<CSS_Parts_Options__c>> POAccountCodeMap=new Map<string, list<CSS_Parts_Options__c>>();
        POAccountCodeMap.put('35ABCD',partoplist);
        Map<string,list<CSS_SRT__c>> SRTAccountCodeMap = new Map<string,list<CSS_SRT__c>>();
        SRTAccountCodeMap.put('35ABCD',SRTLst1);
        List<String> partsWarranty = new List<String>();
        partsWarranty.add('35');
        partsWarranty.add('36');
        List<String> fieldActionClaimAcc = new List<String>();
        fieldActionClaimAcc.add('Test');
        fieldActionClaimAcc.add('Test1');
        fieldActionClaimAcc.add('Test2');
        
        CG_BL_ODM.performODMPreSubmitServiceCS(SCAccountCodeMap, POAccountCodeMap, SRTAccountCodeMap, partsWarranty, fieldActionClaimAcc, claimsobj, psnobj, joorder, true);
        CG_BL_ODM.performODMPreSubmitServiceCS(SCAccountCodeMap, POAccountCodeMap, SRTAccountCodeMap, partsWarranty, fieldActionClaimAcc, claimsobj, psnobj, joorder, false);
        
        system.debug('ends>>');
        
        test.stopTest();
        
    }
    static testmethod void testmethod1221()
    {
        list<CSS_Integration_Details__c> conDetailslist=[select id,name,AuthEnv__c,ApplicationName__c,End_Point__c,Method_Type__c,Timeout__c from CSS_Integration_Details__c];
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        jo.ODM_Status_Message__c='ODM Message';
        insert jo;
        list<id> idlist = new list<id>();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
        Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        Id recTypeIdTTML = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        
        
        list<CSS_Job_Order__c> jolist =new list<CSS_Job_Order__c>();
        jolist.add(jo);
        
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_job_order__c jo111 = new css_job_order__c();
        jo111.Customer_Code__c='123';
        jo111.Customer_Name__c='Gopal';
        jo111.ODM_Status_Message__c='ODM Message';
        jo111.Account__c=acc.id;
        insert jo111;
        css_claims__c claims11 = CSS_TestData.createclaims(false,jo111.Id);
        claims11.Account__c=acc.id;
        insert claims11;
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = claims11.id;
        insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = claims11.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        // AddsolComp.AccountCode__c = 'EMSWarranty35';
        AddsolComp.AccountCodeEdit__c = 'EMSWarranty36';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        AddsolComp.Service_Job__c=jo111.id;
        Addsolcomp.ODM_Status__c='ERROR';
        AddsolComp.Failure_Mode__c='ABCD';
        //   insert AddsolComp;
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        Addsolcomp1.System_Code__c='AB';
        Addsolcomp1.Component_Code__c='CD';
        AddsolComp1.CSS_Claims__c = claims11.id;
        AddsolComp1.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.Selected_Component__c = True;
        // AddsolComp1.AccountCode__c = 'EMSWarranty35';
        AddsolComp1.AccountCodeEdit__c = 'EMSWarranty35';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
        AddsolComp1.Service_Job__c=jo111.Id;
        AddsolComp1.Failure_Mode__c='AB';
        // insert AddsolComp1;
        idlist.add(AddsolComp1.id);
        LIST<CSS_Solution_Component__c> SOLIST12=NEW LIST<CSS_Solution_Component__c>();
        SOLIST12.add(AddsolComp1);
        //SOLIST12.add(AddsolComp);
        insert SOLIST12;
        CSS_SRT__c srt=css_testdata.createSRT(false,'repair',solRef.Id,jo.Id);
        srt.CSS_Claims__c=claims11.Id;
        srt.SRT_ID__c='001';
        SRT.isPerformed__c=TRUE;
        srt.ODM_Status__c='ERROR';
        SRT.Account_Code__c='EMSWarranty35';
        SRT.Account_Code_Description__c='EMSWarranty35';
        SRT.Type__c='Repair';
        SRT.FailCode__c='ABCD';
        CSS_srt__c srt1=css_testdata.createsrt(false,'repair',solRef.Id,jo.Id);
        srt1.CSS_Claims__c=claims11.Id;
        srt1.job_order__c=jo111.id;
        srt1.srt_ID__c='002';
        srt1.isPerformed__c=TRUE;
        srt1.ODM_Status__c='ERROR';
        srt1.Account_Code__c='EMSWarranty35';
        srt1.Account_Code_Description__c='EMSWarranty35';
        srt1.Type__c='Field Action';
        srt1.FailCode__c='ABCD';
        srt1.SRT_Category__c='AdditionalDiag';
        srt1.SRT_AccessiblityCheck__c=true;
        LIST<CSS_SRT__c> SRTLIST = new  LIST<CSS_SRT__c>();
        //SRTLIST.add(SRT);
        SRTLIST.add(srt1);
        insert SRTLIST;
        //LIST<CSS_SRT__c> SRTLst1=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, SRT_Time_String__c, SRT_Decimal_Time__c, SRT_Title__c, SRT_Type__c, SRT_Order__c, SRT_Warrantable__c, Access_Code__c, SRT_Select__c, Override__c, OverrideReason__c, Special_Access_Code__c, Special_Access_Code_Desc__c, Percentage__c, Step_Description__c, SRT_Details__c, Overlap__c, SRT_Access_Code__c, SRT_Message__c, Access_Code_S1__c, SRT_Time__c, Access_Code_S2__c, SRT_ID__c, Access_Code_S3__c, Type__c, Job_Order__c, Access_Code_S4__c, Access_Code_A__c, Access_Code_B__c, Access_Code_D__c, Access_Code_R__c, Access_Code_C__c, Access_Code_S5__c, Access_Code_S6__c, SRT_AccessiblityCheck__c, Solution_Number__c, SRTAdmi_Check__c, SRT_Notes__c, Component_Id__c, Solution_Title__c, Access_Code_S7__c, isPerformed__c, SRT_Quantity__c, Job_Engine_Access_Code__c, Diagnosis_Time__c, CSS_UniqueSRTValues__c, CaseName__c, SRT_Status_Message__c, Response_Message__c, Assignment__c, Step_Id__c, Access_Code_S8__c, SRT_Category__c, Failure_Name__c, SRT_Time_Hr_Min__c, Admin_Miles_In__c, Admin_Miles_Out__c, Admin_Left_Shop__c, Admin_Arrive_Job__c, Admin_Start_Job__c, Admin_Finish_Job__c, Admin_Leave_Job__c, Admin_Arrive_Shop__c, Access_Code_S9__c, S1_Description__c, S2_Description__c, S3_Description__c, S4_Description__c, S5_Description__c, S6_Description__c, S7_Description__c, S8_Description__c, S9_Description__c, Access_Code_Saved__c, Diag_Access_Time__c, Repair_Time__c, Additional_SRT_Calculated__c, Repair_Access_Calculated__c, Adjustment_Reason__c, Quote_ID__c, SRT_Family__c, Component_Type__c, Actual_Hour__c, Billed_Hour__c, Bill__c, Troubleshoot__c, Flexible__c, Private_Work__c, Service_Model_Name__c, Warranty_Allocation__c, Account_Code__c, Claim_Type__c, Create_Date__c, Create_User__c, Change_Date__c, Change_User__c, CSS_Claims__c, Overlap_SRT_Number__c, SRT_Group_Desc__c, ODM_Status__c, FailCode__c, Claimed_Hours__c,  Fail_Code_Description__c, Account_Code_Description__c, IsPopUpSRT__c, Overlap_Step_Id__c, Calculated_Claimed_Hours__c, Overlap_SRT_Title__c, Overlap_Hours__c, Adjusted_Overlap_Hours__c, Extended_Hours__c, Symptom_Name__c, Fault_Code_Name__c, AccountCode_Formula__c, SRT_Estimate__c, Hours_BMS__c, Troubleshoot_BMS__c, Flexible_BMS__c, Private_BMS__c, Special_BMS__c, ODM_Status_Message__c, SRT_Amount__c, isSrtFailCode__c, ODM_Status_Code__c, SRT_Time_Formula__c, Info_Only_Claim__c FROM CSS_SRT__c];
        CSS_Parts_Options__c po51 =new CSS_Parts_Options__c();
        po51.Notes__c='123';
        po51.RecordTypeId = recTypeIdTTML;
        po51.CSS_Claims__c = claims11.id;
        po51.OEM__c ='123';
        po51.Quantity__c =1;
        po51.Selected_part__c =true;
        po51.Part_Name__c ='123456';
        po51.Service_partnumber__c ='123';
        po51.Parts_Type__c ='Custom';
        po51.Account_Code__c ='EMSWarranty35'; 
        po51.Service_Job__c=jo111.id;
        po51.FailurepartId__c =AddsolComp.Id;
        po51.Fail_Code__c='ABCD';
        po51.ODM_Status__c = 'ERROR';
        lstpo.add(po51);
        insert lstpo;
        test.startTest();
        system.debug('Starts>>');
        system.debug('SOLIST12>>'+SOLIST12);
        
        
        CG_BL_ODM.callODMSRTServices('Claim', claims11.id);
        CG_BL_ODM.callODMSRTServices('Job', jo111.id);
          CG_BL_ODM.callODMSRTServicesold('Claim', claims11.id);
        CG_BL_ODM.callODMSRTServicesold('Job', jo111.id);
        test.stopTest();
    }
    static testmethod void testmethod121()
    {
        list<CSS_Integration_Details__c> conDetailslist=[select id,name,AuthEnv__c,ApplicationName__c,End_Point__c,Method_Type__c,Timeout__c from CSS_Integration_Details__c];
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        insert jo;
        list<id> idlist = new list<id>();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        testclaimsRec.ODM_Status_Message__c='success';
        testclaimsRec.ODM_Status_Code__c='200';
        
        insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = testclaimsRec.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        // AddsolComp.AccountCode__c = 'EMSWarranty35';
        AddsolComp.AccountCodeEdit__c = 'EMSWarranty36';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        AddsolComp.Service_Job__c=jo.id;
        //Addsolcomp.ODM_Status__c='ERROR';
        Addsolcomp.ODM_Status__c='PASSED';
        //   insert AddsolComp;
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        Addsolcomp1.System_Code__c='AB';
        Addsolcomp1.Component_Code__c='CD';
        AddsolComp1.CSS_Claims__c = testclaimsRec.id;
        AddsolComp1.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.Selected_Component__c = True;
        // AddsolComp1.AccountCode__c = 'EMSWarranty35';
        AddsolComp1.AccountCodeEdit__c = 'EMSWarranty35';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
        AddsolComp1.Service_Job__c=null;
        // insert AddsolComp1;
        idlist.add(AddsolComp1.id);
        LIST<CSS_Solution_Component__c> SOLIST12=NEW LIST<CSS_Solution_Component__c>();
        SOLIST12.add(AddsolComp1);
        SOLIST12.add(AddsolComp);
        insert SOLIST12;
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
        Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        Id recTypeIdTTML = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        Id recTypeIdBMSParts = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
        Id recTypeIdOC = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c ='EMSWarranty35'; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.Fail_Code__c='ABCD';
        po.ODM_Status__c = 'PASSED';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
        CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = null;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c ='EMSWarranty35'; 
        // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id;
        po1.Fail_Code__c='ABCD';
        po1.ODM_Status__c = 'PASSED';
        lstpo.add(po1);
        
        CSS_Parts_Options__c po2 =new CSS_Parts_Options__c();
        po2.Notes__c='123';
        po2.RecordTypeId = recTypeIdBMSParts;
        po2.CSS_Claims__c = testclaimsRec.id;
        po.Service_Job__c=jo.Id;
        po2.OEM__c ='123';
        po2.Quantity__c =1;
        po2.Selected_part__c =true;
        po2.Part_Name__c ='123456';
        po2.Service_partnumber__c ='123';
        po2.Parts_Type__c ='Custom';
        po2.Fail_Code__c='ABCD';
        po2.Account_Code__c ='EMSWarranty36';
        // po1.Solutions__c=solRef.id;
        po2.FailurepartId__c =AddsolComp.Id; 
        po2.ODM_Status__c = 'ERROR';
        lstpo.add(po2);
        CSS_Parts_Options__c po5 =new CSS_Parts_Options__c();
        po5.Notes__c='123';
        po5.RecordTypeId = recTypeIdBMSParts;
        po5.CSS_Claims__c = null;
        po5.OEM__c ='123';
        po5.Quantity__c =1;
        po5.Selected_part__c =true;
        po5.Part_Name__c ='123456';
        po5.Service_partnumber__c ='123';
        po5.Parts_Type__c ='Custom';
        po5.Account_Code__c ='EMSWarranty35'; 
        // po5.Solutions__c=solRef.id;
        po5.FailurepartId__c =AddsolComp.Id;
        po5.Fail_Code__c='ABCD';
        po5.ODM_Status__c = 'ERROR';
        lstpo.add(po5);
        CSS_Parts_Options__c po6 =new CSS_Parts_Options__c();
        po6.Notes__c='123';
        po6.RecordTypeId = recTypeIdTTML;
        po6.CSS_Claims__c = null;
        po6.OEM__c ='123';
        po6.Quantity__c =1;
        po6.Selected_part__c =true;
        po6.Part_Name__c ='123456';
        po6.Service_partnumber__c ='123';
        po6.Parts_Type__c ='Custom';
        po6.Account_Code__c ='EMSWarranty35'; 
        // po6.Solutions__c=solRef.id;
        po6.FailurepartId__c =AddsolComp.Id;
        po6.Fail_Code__c='ABCD';
        po6.ODM_Status__c = 'PASSED';
        lstpo.add(po6);
        
        CSS_Parts_Options__c po8 =new CSS_Parts_Options__c();
        po8.Notes__c='123';
        po8.RecordTypeId = recTypeIdOC;
        po8.CSS_Claims__c = null;
        po8.OEM__c ='123';
        po8.Quantity__c =1;
        po8.Selected_part__c =true;
        po8.Part_Name__c ='123456';
        po8.Service_partnumber__c ='123';
        po8.Parts_Type__c ='Custom';
        po8.Account_Code__c ='EMSWarranty35'; 
        // po8.Solutions__c=solRef.id;
        po8.FailurepartId__c =AddsolComp.Id;
        po8.Fail_Code__c='ABCD';
        po8.ODM_Status__c = 'ERROR';
        lstpo.add(po8);
        
        CSS_Parts_Options__c po9 =new CSS_Parts_Options__c();
        po9.Notes__c='123';
        po9.RecordTypeId = recTypeIdOC;
        po9.CSS_Claims__c = null;
        po9.OEM__c ='123';
        po9.Quantity__c =1;
        po9.Selected_part__c =true;
        po9.Part_Name__c ='123456';
        po9.Service_partnumber__c ='123';
        po9.Parts_Type__c ='Custom';
        po9.Account_Code__c ='EMSWarranty36'; 
        // po9.Solutions__c=solRef.id;
        po9.FailurepartId__c =AddsolComp.Id;
        po9.Fail_Code__c='ABCD';
        po9.ODM_Status__c = 'ERROR';
        lstpo.add(po9);
        CSS_Parts_Options__c po7 =new CSS_Parts_Options__c();
        po7.Notes__c='123';
        po7.RecordTypeId = recTypeIdTTML;
        po7.CSS_Claims__c = null;
        po7.OEM__c ='123';
        po7.Quantity__c =1;
        po7.Selected_part__c =true;
        po7.Part_Name__c ='123456';
        po7.Service_partnumber__c ='123';
        po7.Parts_Type__c ='Custom';
        po7.Account_Code__c ='EMSWarranty36'; 
        // po7.Solutions__c=solRef.id;
        po7.FailurepartId__c =AddsolComp.Id;
        po7.Fail_Code__c='ABCD';
        po7.ODM_Status__c = 'PASSED';
        lstpo.add(po7);
        insert lstpo;
        list<CSS_Job_Order__c> jolist =new list<CSS_Job_Order__c>();
        jolist.add(jo);
        
        
        CSS_Job_Order__c joorder=[Select Id,Name,IsAppointment__c, bmsCreateAccount__c,CSS_Bms_ContactBoolean__c,Email_Address__c,Email_check_box__c,BMSStatus__c,Contact_ID__c,Customer_Name__c,Customer_Code__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Address__c,City__c,ZipCode__c,Country__c,CSS_Charge_Account_Status__c,Shop_Work_Order__c,Application__c, Unit_Number__c, Status__c, css_resolution__c,CSS_Feedback_Comments__c, Previous_Status__c,previousESN_MultiLoc__c,date_in__c,Date_in_Shop__c,
                                  ESN__c, ESN_IA__c, First_Name__c,BMS_Last_Name__c, Mileage__c,CSS_Hours__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, LastModifiedDate,CreatedDate, Location_Certification__c,CSS_State__c,Primary_Segment__c,Before_In_Service__c,ESN_Locked__c, 
                                  Make__c,Model__c,AccessCode__c,Failure_Date__c,Failure_Point__c,Failure_Point_Measure__c,Service_Model__c,VIN__c,VIN_Flag__c,Warranty_Start_Date__c,Region__c,Creator_Location__c,EditCoverage__c,Unit_Type__c, Sub_Type__c,Account__r.ERP_System__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                                  Repeat_Visit__c,TSR_EscalateNumber__c,RecentVisit__c,Repeat_Or_Recent_Calc__c,JobLocation__c,CSS_Job_Location_Code__c,CreatedById,Qsol_Engine_Family_Code__c,Repair_Location__c,Territory__c,Warranty_Authorization_Flag__c,PSN_Not_Available__c,Sub_Status__c,LastUpdateSubStatus__c,Actual_Technician_Time__c,SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,
                                  ProductApplicationCode__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_Country__c,EngineFamilyName__c,Account__c,SP_ClaimAllowedDays__c,SP_RegionCode__c,SP_TerritoryCode__c,BillToCode__c,DesignPhaseCode__c,Sp_TERRITORY__c,
                                  ProductApplicationDesp__c,warrantyIndicatorFlag__c,Automotive_App_Flag__c,
                                  MarineFlag__c,OemCode__c,EtoConversionDate__c,BuildDate__c,CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c, 
                                  (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC),Category__c,Category2__c,Category3__c,Category4__c,Category5__c,Complaint_Type__c,Complaint_Type2__c,Complaint_Type3__c,Complaint_Type4__c,Complaint_Type5__c, Preventive_Maintenance__c,Expedited_Service__c, Category_Desc__c, Category2_Desc__c, Category3_Desc__c, Category4_Desc__c, Category5_Desc__c, Complaint_Type_Desc__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c, Application_Desc__c,ApplicationCode__c,
                                  (Select Id,Name, Case_Name__c, Service_Job__c,Repair_response__c,Solution_Title__c ,Solution__c,Diagnostic_Response__c FROM CSS_Solutions__r),
                                  (Select id, name , performed__c, performed_review__c, Reviewed__c from CSS_CampTsbTrp__r where performed_review__c=True and performed__c=False),
                                  (select Id,name,OrderReference__c from css_quotes__r)
                                  from CSS_Job_Order__c];
        CSS_PSN__c psnobj=[SELECT Id, Name, CSS_Claims__c, Unit_Number__c, Application__c, License_Plate_State__c, Service_Model__c, Make__c, Model__c, VIN__c, Product_Hours__c, Warranty_Start_Date__c, Mileage_Measure__c, Unit_Type__c, Failure_Date__c, Primary__c, Before_In_Service__c, Mileage__c, Qsol_Engine_Family_Code__c, Qsol_Warranty_Start__c, Qsol_Technical_Config__c, Mission_Disabling__c, Calibration_Before__c, Calibration_After__c, Justification__c, PSN__c, CoverageFlag__c, Equipment_ID__c, AccessCode__c, ApplicationCode__c, Warranty_Authorization_Flag__c, Location_Certification__c, Revision_Before__c, Revision_After__c, Failure_Point__c, ProductAppcodeErrorflag__c, Siebel_Claim_No__c FROM CSS_PSN__c limit 1];
        CSS_Claims__c claimsobj = [SELECT Id, OwnerId, IsDeleted,Account__r.RSS_RESP_BRANCH_CODE__c, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp,Customer_Name__c, Customer_Code__c, Contact_First_Name__c, Contact_Last_Name__c, Address__c, Contact_Id__c, Country__c, State__c, Customer_Phone__c, ZipCode__c, TSR1__c, Customer_Contact_Phone__c, Distributor_Authorization_FN__c, TSR2__c, Distributor_Authorization_LN__c, Repair_Location__c, Distributor_Authorization_WWID__c, Service_Date__c, TSR3__c, Email_Address__c, Repair_Completion__c, TSR4__c, PACCAR_Authorization_FN__c, PACCAR_Authorization_LN__c, PACCAR_Authorization_WWID__c, Location__c, Location_Code__c, CSS_Job__c, Catastrophic__c, TSR5__c, Shop_Work_Order__c, Authorization_Comments__c, ESN__c, TSR6__c, Service_Model__c, TSR7__c, TSR8__c, Account__c, Status__c, TSR9__c, TSR10__c, CoverageResponse__c, Region__c, Territory__c, Claim_Submitted__c, Payment_Details__c, EditComplaint__c, EditCause__c, EditCorrection__c, EditCoverage__c, JobComplaintLastModified__c, JobEditComplaint__c, JobEditCause__c, JobEditCoverage__c, JobEditCorrection__c, JobCauseLastModified__c, JobCorrectionLastModified__c, JobCoverageLastModified__c, Territory_Class__c, CSS_Channel_Of_Distribution__c, Territory_Class_Name__c, CSS_Channel_Code__c, Claims_Category__c, Claims_Category2__c, Claims_Category3__c, Claims_Category4__c, Claims_Category5__c, Claims_Category2_Desc__c, Claims_Category3_Desc__c, Claims_Category4_Desc__c, Claims_Category5_Desc__c, Claims_Complaint_Type__c, Claims_Complaint_Type2__c, Claims_Complaint_Type3__c, Claims_Complaint_Type4__c, Claims_Complaint_Type5__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c, Claims_General_Symptoms__c, Claims_Preventive_Maintenance__c, Claims_Expedited_Service__c, Claims_Additional_Comments__c, Claims_Category_Desc__c, Complaint_Type_Desc__c, CVIN__c, Assigned_To__c, Additional_Tech1__c, Additional_Tech2__c, Additional_Tech3__c, Additional_Tech4__c, Additional_Tech5__c, Additional_Tech6__c, Additional_Tech7__c, Additional_Tech8__c, Additional_Tech9__c, Actual_Technician_Time__c, AccessCode__c, ODM_Status_Message__c, ODM_Pre_submit_Status__c, Claims_city__c, ODM_Status__c, SP_CLAIM_ALLOWED_DAYS__c, InactiveDate__c,SP_PACCAR__c, SP_CHANNEL_OF_DISTRIBUTION__c, SP_REGIONCODE__c, SP_LTA_FLAG__c, SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_ACCOUNT_STATUS__c, SP_TERRITORY_CODE__c, SP_TERRITORY__c, SP_CMI_SP_EXPIRATION__c, BillToCode__c, BuildDate__c, DesignPhaseCode__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_Group_Name__c, SP_PromotionId__c, ODM_Pre_submit_Status_Message__c, ProductApplicationCode__c, SP_INSHOP_LABOR_RATE__c, SP_FIELD_SERVICE_LABOR_RATE__c, ODM_Status_Code__c, SP_SCMDeductiblePercentage__c, SP_WarrantyTrainingStatus__c, SP_State__c, SP_SCMDollarAmt__c, Automotive_App_Flag__c, bmsCreateAccount__c, SP_PrimaryOEMCode__c, CSS_Travel_Rate__c, Information_Only_Claim__c, EngineFamilyName__c, ShipDate__c, ETOOldESN__c, SP_Country__c, Mutual_Exclusive_Message__c, SP_WarrantyCertificationEndDate__c, Pending_Authorization__c, Not_Authorized_Comments__c, License_Plate_State_Error_message__c, Rejection_Comments__c, Amount_Due__c, Available_Credit__c, Credit_Limit__c, Non_SRT_Details__c, Quote_ID__c, SP_AccountStatus__c, SP_BusinessUnit__c, SP_CampaignTRP__c, SP_CommunicationMethod__c, SP_CommunicationOccurrence__c, SP_CostEffectiveExclusion__c, SP_CutOffClaimAmt__c, SP_DisableWebAccessFlag__c, SP_DistributorHQCode__c, SP_DistributorHQName__c, SP_DSID__c, SP_DTNAFlag__c, SP_FreezeSubmitButton__c, SP_MaxClaimAmt__c, SP_NewOEM__c, SP_PMUSplitPayment__c, SP_Policy__c, SP_PrimaryOEMName__c, SP_ProductCertification__c, SP_RepairLevel__c, SP_TechActualHoursRequired__c, SP_ViewDollarAmount__c, SP_WarrantyEmail__c, SP_WarrantyFax__c, SP_WarrantyTrainingCertification__c, SP_WWSPSSPFlag__c, ReconEngineFlag__c, AuthorizationTimeStamp__c, CaptureUserwhoapprovedAuthorized__c, Rejection_Timestamp__c, RejectedByUser__c, Dealer_Service_Job__c, Actual_Time_for_Diagnostics__c, Actual_Time_for_Repair__c, PartReturnToCenter__c, Total_PSN_Count__c, IsCopyclaim__c, Multi_PSN_Claim__c, PACCAR_Flag__c, SiebelClaimNumber__c, PolicyClaim__c FROM CSS_Claims__c limit 1];
        list<CSS_Solution_Component__c> solcomplist=[SELECT Notes__c, ODM_Status_Message__c, Name, Component_Id__c, Service_Model__c, Engine_Family_Code__c, Equip_ID__c, System_Code__c, Unique_Component__c, Component_Code__c, Failure_Mode__c, Fail_Code__c, Fail_Code_Editable__c, CoveredTravelBaseFareAmt__c, CoveredOCAmount__c, CoveredLaborHrs__c, CoveredTowingMiles__c, CampaignLaborPercentage__c, CoveredTravelLabor__c, CertificateNumber__c, CampaignTowingPercentage__c, AccountCodeType__c, CoveredPartsQty__c, Status__c, CampaignOCPercentage__c, DeductibleAmount__c, FailCode_Formula__c, AccountCode__c, CampaignPartsPercentage__c, CoveredMealsLodgingAmt__c, WarrantyId__c, CoveredTravelMiles__c, CampaignTravelPercentage__c, ODM_Status_Code__c, CSS_Account_Formula__c, AccountCodeEdit__c, AccountCode_Call_Status__c, Type__c, Failure_Measure__c, Campaign_Description__c, Business_Unit__c, Authorization_Number__c, Approval_Code__c, CSS_CoverageType__c, URL__c, OldSolCompID__c, Create_User__c, Change_User__c, Selected_Claim_Type__c, SysCodeAndCompCode__c, Claim_FailCode__c, SystemCode_Desc__c, ComponentCode_Desc__c, Fault_Code__c, FailMode_Desc__c, FaultCode_Desc__c, RoadRelay_Warranty__c, OwnerId, CreatedById, LastModifiedById, Service_Job__c, Solutions__c, CSS_Claims__c, Action__c, Parts_Warranty__c, Customer_Take_Possession__c, Pay_Code__c, Claim_Type__c, ODM_Status__c, Id, Quantity__c, SRT_Total__c, CoveredPartsQty_Percentage__c, Failure_Point__c, CreatedDate, LastModifiedDate, SystemModstamp, LastActivityDate, Part_Warranty_Start_Date__c, Failure_Date__c, Campaign_Start_Date__c, Campaign_End_Date__c, IsDeleted, Selected_Component__c, Charlength__c, SRT_Fetched__c, In_Shop_SRT_Limit_Flag__c, Multiple_Times__c, Complete_Indicator__c, Performed__c, Performed_Review__c, Reviewed__c, Claims_Failure_Select__c, Info_Only_Claim__c FROM CSS_Solution_Component__c];
        list<CSS_JobEventTemporary__c> jobevtlist=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Source__c, Type__c, JobOrder__c, Key__c, KeyType__c, Attribute1__c, Attribute2__c, Attribute3__c, Attribute4__c, Attribute5__c, Attribute6__c, Attribute7__c, Attribute8__c, Attribute9__c, Attribute10__c, ExpireDateTime__c, RawData__c, Attribute11__c, Attribute12__c, Attribute13__c, Attribute14__c, Circuit_Description__c, Comp_Location__c, Effect__c, Engine__c, Fault_Code_Description__c, File_Name__c, FMI__c, Lamp__c, Reason__c, Service_Model_Name__c, SPN__c, SRT_Access_Checklist__c, Attribute15__c, Active__c, Account_Code__c FROM CSS_JobEventTemporary__c];
        list<CSS_Parts_Options__c> partoplist=[SELECT Id,recordtype.name, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Option_Number__c, Repair_Group__c, Group_Name__c, Service_Job__c, Option_ESN__c, Part_Name__c, Part_Description__c, OEM__c, Parts_Type__c, Service_partnumber__c, Quantity__c, part_size__c, Notes__c, Unique_Parts_Option__c, FailureName__c, selected_part__c, FailurepartId__c, Assignment__c, Solutions__c, Replacement_Reason__c, Part_Assignment__c, ReturnToFactory__c, Covered__c, Fail_Code__c, Default_Part_Quantity__c, Account_Code__c, Item__c, Quantity_Ordered__c, Technician__c, Type__c, Days__c, Mileage__c, HoursTravelled__c, ExpenseTotal__c, CSS_Claims__c, Tracking_Number__c, RID__c, Amount__c, Quantity_Used__c, Parts_Return__c, Sell_Price__c, Warranty_Allocation__c, Comments__c, Line_Type__c, Serial_Number__c, Serial_Number_Vendor__c, Model__c, Option__c, SSN__c, VIN__c, PartOC__c, Address1__c, Address2__c, City__c, State__c, Zip__c, Create_User__c, Create_Date__c, Change_User__c, Change_Date__c, Claim_Type__c, Css_Estimate__c, isManual__c, ODM_Status__c, ODM_Status_Message__c, Get_Fail_Code_Formula__c, Unit_Price__c, Previous_Item__c, BMS_Quantity__c, Claimtype__c, Price_Book__c, ReturnWaiver__c, Return_Instructions__c, Misc_LOV__c, Siebel_Value__c, Item_BMS__c, Type_BMS__c, ODM_Status_Code__c, Siebel_Claim_Number__c, Shipping_Address__c, Info_Only_Claim__c FROM CSS_Parts_Options__c];
        CSS_SRT__c srt=css_testdata.createSRT(false,'repair',solRef.Id,jo.Id);
        srt.CSS_Claims__c=claimsobj.Id;
        srt.SRT_ID__c='001';
        SRT.isPerformed__c=TRUE;
        srt.ODM_Status__c='PASSED';
        SRT.Account_Code__c='EMSWarranty35';
        SRT.Account_Code_Description__c='EMSWarranty35';
        SRT.Type__c='Repair';
        SRT.FailCode__c='ABCD';
        CSS_srt__c srt1=css_testdata.createsrt(false,'repair',solRef.Id,jo.Id);
        srt1.CSS_Claims__c=claimsobj.Id;
        srt1.srt_ID__c='002';
        srt1.isPerformed__c=TRUE;
        srt1.ODM_Status__c='PASSED';
        srt1.Account_Code__c='EMSWarranty35';
        srt1.Account_Code_Description__c='EMSWarranty35';
        srt1.Type__c='Repair';
        srt1.FailCode__c='ABC';
        LIST<CSS_SRT__c> SRTLIST = new  LIST<CSS_SRT__c>();
        SRTLIST.add(SRT);
        SRTLIST.add(srt1);
        // insert SRTLIST;
        LIST<CSS_SRT__c> SRTLst1=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, SRT_Time_String__c, SRT_Decimal_Time__c, SRT_Title__c, SRT_Type__c, SRT_Order__c, SRT_Warrantable__c, Access_Code__c, SRT_Select__c, Override__c, OverrideReason__c, Special_Access_Code__c, Special_Access_Code_Desc__c, Percentage__c, Step_Description__c, SRT_Details__c, Overlap__c, SRT_Access_Code__c, SRT_Message__c, Access_Code_S1__c, SRT_Time__c, Access_Code_S2__c, SRT_ID__c, Access_Code_S3__c, Type__c, Job_Order__c, Access_Code_S4__c, Access_Code_A__c, Access_Code_B__c, Access_Code_D__c, Access_Code_R__c, Access_Code_C__c, Access_Code_S5__c, Access_Code_S6__c, SRT_AccessiblityCheck__c, Solution_Number__c, SRTAdmi_Check__c, SRT_Notes__c, Component_Id__c, Solution_Title__c, Access_Code_S7__c, isPerformed__c, SRT_Quantity__c, Job_Engine_Access_Code__c, Diagnosis_Time__c, CSS_UniqueSRTValues__c, CaseName__c, SRT_Status_Message__c, Response_Message__c, Assignment__c, Step_Id__c, Access_Code_S8__c, SRT_Category__c, Failure_Name__c, SRT_Time_Hr_Min__c, Admin_Miles_In__c, Admin_Miles_Out__c, Admin_Left_Shop__c, Admin_Arrive_Job__c, Admin_Start_Job__c, Admin_Finish_Job__c, Admin_Leave_Job__c, Admin_Arrive_Shop__c, Access_Code_S9__c, S1_Description__c, S2_Description__c, S3_Description__c, S4_Description__c, S5_Description__c, S6_Description__c, S7_Description__c, S8_Description__c, S9_Description__c, Access_Code_Saved__c, Diag_Access_Time__c, Repair_Time__c, Additional_SRT_Calculated__c, Repair_Access_Calculated__c, Adjustment_Reason__c, Quote_ID__c, SRT_Family__c, Component_Type__c, Actual_Hour__c, Billed_Hour__c, Bill__c, Troubleshoot__c, Flexible__c, Private_Work__c, Service_Model_Name__c, Warranty_Allocation__c, Account_Code__c, Claim_Type__c, Create_Date__c, Create_User__c, Change_Date__c, Change_User__c, CSS_Claims__c, Overlap_SRT_Number__c, SRT_Group_Desc__c, ODM_Status__c, FailCode__c, Claimed_Hours__c, Fail_Code_Description__c, Account_Code_Description__c, IsPopUpSRT__c, Overlap_Step_Id__c, Calculated_Claimed_Hours__c, Overlap_SRT_Title__c, Overlap_Hours__c, Adjusted_Overlap_Hours__c, Extended_Hours__c, Symptom_Name__c, Fault_Code_Name__c, AccountCode_Formula__c, SRT_Estimate__c, Hours_BMS__c, Troubleshoot_BMS__c, Flexible_BMS__c, Private_BMS__c, Special_BMS__c, ODM_Status_Message__c, SRT_Amount__c, isSrtFailCode__c, ODM_Status_Code__c, SRT_Time_Formula__c, Info_Only_Claim__c FROM CSS_SRT__c];
        
        test.startTest();
        system.debug('Starts>>');
        system.debug('SOLIST12>>'+SOLIST12);
        /*  CG_BL_ODM.callODMHeaderValidationClaimService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', solcomplist, 'WarrantyOverview');
CG_BL_ODM.callODMHeaderValidationClaimService(jo, testclaimsRec, testpsnNewRec, 'JOB', solcomplist, null);
CG_BL_ODM.callODMHeaderValidationService(jo, testclaimsRec, testpsnNewRec, 'JOB', solcomplist, NULL);
CG_BL_ODM.callODMHeaderValidationService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', solcomplist, 'WarrantyOverview');
CG_BL_ODM.callODMFailureValidationService(jo, testclaimsRec, testpsnNewRec, 'CLAIM', solcomplist, 'FailureChevron');
CG_BL_ODM.callODMFailureValidationService(jo, testclaimsRec, testpsnNewRec, 'JOB', solcomplist, NULL);
CG_BL_ODM.callClaimsODMPartsValidationService(jo, claimsobj, testpsnNewRec, 'CLAIM', solcomplist, partoplist, TRUE);
CG_BL_ODM.callClaimsODMPartsValidationService(jo, claimsobj, testpsnNewRec, 'JOB', solcomplist, partoplist, TRUE);*/
        CG_BL_ODM.callClaimsODMPartsValidationService(jo, claimsobj, testpsnNewRec, 'CLAIM', solcomplist, partoplist, false);
        CG_BL_ODM.callClaimsODMPartsValidationService(jo, claimsobj, testpsnNewRec, 'JOB', solcomplist, partoplist, false);
        /*   CG_BL_ODM.callODMSRTServices('Claim', claimsobj.id);
CG_BL_ODM.callODMSRTServices('Job', joorder.id);

Map<string,list<CSS_Solution_Component__c>> SCAccountCodeMap= new  Map<string, list<CSS_Solution_Component__c>>();
SCAccountCodeMap.put('35',solcomplist);

Map<string,list<CSS_Parts_Options__c>> POAccountCodeMap=new Map<string, list<CSS_Parts_Options__c>>();
POAccountCodeMap.put('35ABCD',partoplist);
Map<string,list<CSS_SRT__c>> SRTAccountCodeMap = new Map<string,list<CSS_SRT__c>>();
SRTAccountCodeMap.put('35ABCD',SRTLst1);
List<String> partsWarranty = new List<String>();
partsWarranty.add('35');
partsWarranty.add('36');
CG_BL_ODM.performODMPreSubmitServiceCS(SCAccountCodeMap, POAccountCodeMap, SRTAccountCodeMap, partsWarranty, claimsobj, psnobj, joorder, true);
CG_BL_ODM.performODMPreSubmitServiceCS(SCAccountCodeMap, POAccountCodeMap, SRTAccountCodeMap, partsWarranty, claimsobj, psnobj, joorder, false);
*/
        system.debug('ends>>');
        
        test.stopTest();
    }
    static testmethod void testmethod123()
    {
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        insert jo;
        list<id> idlist = new list<id>();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        testclaimsRec.ODM_Status_Message__c='success';
        testclaimsRec.ODM_Status_Code__c='200';
        
        insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        CSS_SRT__c srtVar = new CSS_SRT__c();
        srtVar.Solution_Number__c = solRef.id;
        srtVar.Job_Order__c = solref.Service_Job__r.id;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.SRT_ID__c = 'test';
        srtVar.Account_Code__c  = 'EMSWarranty35';
        srtVar.Access_Code_A__c = 65;
        srtVar.ODM_Status__c='YTBV';
        srtVar.name = 'Test'+Math.random();
        srtVar.Type__c = 'Field Action';
        srtVar.CSS_Claims__c=testclaimsRec.id;
        srtVar.SRT_Category__c ='AdditionalDiag';
        srtVar.isPerformed__c =True;
        srtVar.FailCode__c='ABCD';
        // insert srtVar;
        system.debug('srtVar1 '+srtVar);
        system.debug('srtVar2 '+srtVar.AccountCode_Formula__c);
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = testclaimsRec.id;
        AddsolComp.AccountCode__c = '65';
        AddsolComp.AccountCodeType__c='CMP – Field Actions';
        AddsolComp.AccountCodeEdit__c = 'CMP – Field Actions 65';
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        // AddsolComp.AccountCode__c = 'EMSWarranty35';
        
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        AddsolComp.Service_Job__c=jo.id;
        //Addsolcomp.ODM_Status__c='ERROR';
        Addsolcomp.ODM_Status__c='PASSED';
        Addsolcomp.System_Code__c='IF';
        Addsolcomp.Component_Code__c='IA';
        Addsolcomp.Failure_Mode__c='SC';
        //   insert AddsolComp;
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        Addsolcomp1.System_Code__c='AB';
        Addsolcomp1.Component_Code__c='CD';
        AddsolComp1.CSS_Claims__c = testclaimsRec.id;
        AddsolComp1.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.Selected_Component__c = True;
        // AddsolComp1.AccountCode__c = 'EMSWarranty35';
        AddsolComp1.AccountCodeEdit__c = 'EMSWarranty35';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
        AddsolComp1.Service_Job__c=null;
        // insert AddsolComp1;
        idlist.add(AddsolComp1.id);
        LIST<CSS_Solution_Component__c> SOLIST12=NEW LIST<CSS_Solution_Component__c>();
        SOLIST12.add(AddsolComp1);
        SOLIST12.add(AddsolComp);
        insert SOLIST12;
        system.debug('SOLIST12 '+SOLIST12);
        system.debug('SOLIST12 '+SOLIST12[0].CSS_Account_Formula__c);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
        Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        Id recTypeIdTTML = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        Id recTypeIdBMSParts = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
        Id recTypeIdOC = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c ='EMSWarranty35'; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.Fail_Code__c='ABCD';
        po.ODM_Status__c = 'PASSED';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
        CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = null;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c ='EMSWarranty35'; 
        // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id;
        po1.Fail_Code__c='ABCD';
        po1.ODM_Status__c = 'PASSED';
        lstpo.add(po1);
        
        CSS_Parts_Options__c po2 =new CSS_Parts_Options__c();
        po2.Notes__c='123';
        po2.RecordTypeId = recTypeIdBMSParts;
        po2.CSS_Claims__c = testclaimsRec.id;
        po.Service_Job__c=jo.Id;
        po2.OEM__c ='123';
        po2.Quantity__c =1;
        po2.Selected_part__c =true;
        po2.Part_Name__c ='123456';
        po2.Service_partnumber__c ='123';
        po2.Parts_Type__c ='Custom';
        po2.Fail_Code__c='ABCD';
        po2.Account_Code__c ='EMSWarranty36';
        // po1.Solutions__c=solRef.id;
        po2.FailurepartId__c =AddsolComp.Id; 
        po2.ODM_Status__c = 'ERROR';
        lstpo.add(po2);
        CSS_Parts_Options__c po5 =new CSS_Parts_Options__c();
        po5.Notes__c='123';
        po5.RecordTypeId = recTypeIdBMSParts;
        po5.CSS_Claims__c = null;
        po5.OEM__c ='123';
        po5.Quantity__c =1;
        po5.Selected_part__c =true;
        po5.Part_Name__c ='123456';
        po5.Service_partnumber__c ='123';
        po5.Parts_Type__c ='Custom';
        po5.Account_Code__c ='EMSWarranty35'; 
        // po5.Solutions__c=solRef.id;
        po5.FailurepartId__c =AddsolComp.Id;
        po5.Fail_Code__c='ABCD';
        po5.ODM_Status__c = 'ERROR';
        lstpo.add(po5);
        CSS_Parts_Options__c po6 =new CSS_Parts_Options__c();
        po6.Notes__c='123';
        po6.RecordTypeId = recTypeIdTTML;
        po6.CSS_Claims__c = null;
        po6.OEM__c ='123';
        po6.Quantity__c =1;
        po6.Selected_part__c =true;
        po6.Part_Name__c ='123456';
        po6.Service_partnumber__c ='123';
        po6.Parts_Type__c ='Custom';
        po6.Account_Code__c ='EMSWarranty35'; 
        // po6.Solutions__c=solRef.id;
        po6.FailurepartId__c =AddsolComp.Id;
        po6.Fail_Code__c='ABCD';
        po6.ODM_Status__c = 'PASSED';
        lstpo.add(po6);
        
        CSS_Parts_Options__c po8 =new CSS_Parts_Options__c();
        po8.Notes__c='123';
        po8.RecordTypeId = recTypeIdOC;
        po8.CSS_Claims__c = null;
        po8.OEM__c ='123';
        po8.Quantity__c =1;
        po8.Selected_part__c =true;
        po8.Part_Name__c ='123456';
        po8.Service_partnumber__c ='123';
        po8.Parts_Type__c ='Custom';
        po8.Account_Code__c ='EMSWarranty35'; 
        // po8.Solutions__c=solRef.id;
        po8.FailurepartId__c =AddsolComp.Id;
        po8.Fail_Code__c='ABCD';
        po8.ODM_Status__c = 'ERROR';
        lstpo.add(po8);
        
        CSS_Parts_Options__c po9 =new CSS_Parts_Options__c();
        po9.Notes__c='123';
        po9.RecordTypeId = recTypeIdOC;
        po9.CSS_Claims__c = null;
        po9.OEM__c ='123';
        po9.Quantity__c =1;
        po9.Selected_part__c =true;
        po9.Part_Name__c ='123456';
        po9.Service_partnumber__c ='123';
        po9.Parts_Type__c ='Custom';
        po9.Account_Code__c ='EMSWarranty36'; 
        // po9.Solutions__c=solRef.id;
        po9.FailurepartId__c =AddsolComp.Id;
        po9.Fail_Code__c='ABCD';
        po9.ODM_Status__c = 'ERROR';
        lstpo.add(po9);
        CSS_Parts_Options__c po7 =new CSS_Parts_Options__c();
        po7.Notes__c='123';
        po7.RecordTypeId = recTypeIdTTML;
        po7.CSS_Claims__c = null;
        po7.OEM__c ='123';
        po7.Quantity__c =1;
        po7.Selected_part__c =true;
        po7.Part_Name__c ='123456';
        po7.Service_partnumber__c ='123';
        po7.Parts_Type__c ='Custom';
        po7.Account_Code__c ='EMSWarranty36'; 
        // po7.Solutions__c=solRef.id;
        po7.FailurepartId__c =AddsolComp.Id;
        po7.Fail_Code__c='ABCD';
        po7.ODM_Status__c = 'PASSED';
        lstpo.add(po7);
        insert lstpo;
        list<CSS_Job_Order__c> jolist =new list<CSS_Job_Order__c>();
        jolist.add(jo);
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new CG_ODM_ResJSONParser_Mock());
        Boolean resu =  CG_BL_ODM.callODMSRTServicesold('Job',AddsolComp.Service_Job__r.id);
        test.stopTest();
        
    }
    static testmethod void testmethod124()
    {
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        insert jo;
        list<id> idlist = new list<id>();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'rp@sct.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.TSR1__c = '1234';
        testclaimsRec.TSR2__c = '1234';
        testclaimsRec.TSR3__c = '1234';
        testclaimsRec.TSR4__c = '1234';
        testclaimsRec.TSR5__c = '1234';
        testclaimsRec.TSR6__c = '1234';
        testclaimsRec.TSR7__c = '1234';
        testclaimsRec.TSR8__c = '1234';
        testclaimsRec.TSR9__c = '1234';
        testclaimsRec.TSR10__c = '1234';
        testclaimsRec.Country__c = '1234';
        testclaimsRec.State__c = '1234';
        testclaimsRec.ZipCode__c = '12345-1234';
        testclaimsRec.ODM_Status_Message__c='success';
        testclaimsRec.ODM_Status_Code__c='200';
        
        insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        CSS_SRT__c srtVar = new CSS_SRT__c();
        srtVar.Solution_Number__c = solRef.id;
        srtVar.Job_Order__c = solref.Service_Job__r.id;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.SRT_ID__c = 'test';
        srtVar.Account_Code__c  = 'EMSWarranty35';
        srtVar.Access_Code_A__c = 65;
        srtVar.ODM_Status__c='YTBV';
        srtVar.name = 'Test'+Math.random();
        srtVar.Type__c = 'Field Action';
        srtVar.CSS_Claims__c=testclaimsRec.id;
        srtVar.SRT_Category__c ='AdditionalDiag';
        srtVar.isPerformed__c =True;
        srtVar.FailCode__c='ABCD';
        // insert srtVar;
        CSS_SRT__c srtVa = new CSS_SRT__c();
        srtVa.Solution_Number__c = solRef.id;
        srtVa.Job_Order__c = solref.Service_Job__r.id;
        srtVa.SRT_AccessiblityCheck__c=True;
        srtVa.SRT_ID__c = 'test';
        srtVa.Account_Code__c  = 'EMSWarranty35';
        srtVa.Access_Code_A__c = 65;
        srtVa.ODM_Status__c='YTBV';
        srtVa.name = 'Test'+Math.random();
        srtVa.Type__c = 'Field Action';
        srtVa.CSS_Claims__c=testclaimsRec.id;
        srtVa.SRT_Category__c ='AdditionalDiag';
        srtVa.isPerformed__c =True;
        srtVa.FailCode__c='ABCD';
        //insert srtVa;
        system.debug('srtVar2 '+srtVar);
        system.debug('srtVar2 '+srtVar.AccountCode_Formula__c);
        List<CSS_SRT__c> lsrt1=new List<CSS_SRT__c>();
        lsrt1.add(srtVar);
        lsrt1.add(srtVa);
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = testclaimsRec.id;
        AddsolComp.AccountCode__c = '65';
        AddsolComp.AccountCodeType__c='CMP – Field Actions';
        AddsolComp.AccountCodeEdit__c = 'CMP – Field Actions 65';
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        // AddsolComp.AccountCode__c = 'EMSWarranty35';
        
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        AddsolComp.Service_Job__c=jo.id;
        //Addsolcomp.ODM_Status__c='ERROR';
        Addsolcomp.ODM_Status__c='PASSED';
        Addsolcomp.System_Code__c='IF';
        Addsolcomp.Component_Code__c='IA';
        Addsolcomp.Failure_Mode__c='SC';
        //   insert AddsolComp;
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        Addsolcomp1.System_Code__c='AB';
        Addsolcomp1.Component_Code__c='CD';
        AddsolComp1.CSS_Claims__c = testclaimsRec.id;
        AddsolComp1.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.Selected_Component__c = True;
        // AddsolComp1.AccountCode__c = 'EMSWarranty35';
        AddsolComp1.AccountCodeEdit__c = 'EMSWarranty35';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
        AddsolComp1.Service_Job__c=null;
        // insert AddsolComp1;
        idlist.add(AddsolComp1.id);
        LIST<CSS_Solution_Component__c> SOLIST12=NEW LIST<CSS_Solution_Component__c>();
        SOLIST12.add(AddsolComp1);
        SOLIST12.add(AddsolComp);
        insert SOLIST12;
        system.debug('SOLIST12 '+SOLIST12);
        system.debug('SOLIST12 '+SOLIST12[0].CSS_Account_Formula__c);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
        Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        Id recTypeIdTTML = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        Id recTypeIdBMSParts = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
        Id recTypeIdOC = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c ='EMSWarranty35'; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.Fail_Code__c='ABCD';
        po.ODM_Status__c = 'PASSED';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
        CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = null;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c ='EMSWarranty35'; 
        // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id;
        po1.Fail_Code__c='ABCD';
        po1.ODM_Status__c = 'PASSED';
        lstpo.add(po1);
        
        CSS_Parts_Options__c po2 =new CSS_Parts_Options__c();
        po2.Notes__c='123';
        po2.RecordTypeId = recTypeIdBMSParts;
        po2.CSS_Claims__c = testclaimsRec.id;
        po.Service_Job__c=jo.Id;
        po2.OEM__c ='123';
        po2.Quantity__c =1;
        po2.Selected_part__c =true;
        po2.Part_Name__c ='123456';
        po2.Service_partnumber__c ='123';
        po2.Parts_Type__c ='Custom';
        po2.Fail_Code__c='ABCD';
        po2.Account_Code__c ='EMSWarranty36';
        // po1.Solutions__c=solRef.id;
        po2.FailurepartId__c =AddsolComp.Id; 
        po2.ODM_Status__c = 'ERROR';
        lstpo.add(po2);
        CSS_Parts_Options__c po5 =new CSS_Parts_Options__c();
        po5.Notes__c='123';
        po5.RecordTypeId = recTypeIdBMSParts;
        po5.CSS_Claims__c = null;
        po5.OEM__c ='123';
        po5.Quantity__c =1;
        po5.Selected_part__c =true;
        po5.Part_Name__c ='123456';
        po5.Service_partnumber__c ='123';
        po5.Parts_Type__c ='Custom';
        po5.Account_Code__c ='EMSWarranty35'; 
        // po5.Solutions__c=solRef.id;
        po5.FailurepartId__c =AddsolComp.Id;
        po5.Fail_Code__c='ABCD';
        po5.ODM_Status__c = 'ERROR';
        lstpo.add(po5);
        CSS_Parts_Options__c po6 =new CSS_Parts_Options__c();
        po6.Notes__c='123';
        po6.RecordTypeId = recTypeIdTTML;
        po6.CSS_Claims__c = testclaimsRec.id;
        po6.OEM__c ='123';
        po6.Quantity__c =1;
        po6.Selected_part__c =true;
        po6.Part_Name__c ='123456';
        po6.Service_partnumber__c ='123';
        po6.Parts_Type__c ='Custom';
        po6.Account_Code__c ='EMSWarranty35'; 
        // po6.Solutions__c=solRef.id;
        po6.FailurepartId__c =AddsolComp.Id;
        po6.Fail_Code__c='ABCD';
        po6.ODM_Status__c = 'YTBV';
        po6.Service_Job__c=jo.id;
        lstpo.add(po6);
        
        CSS_Parts_Options__c po8 =new CSS_Parts_Options__c();
        po8.Notes__c='123';
        po8.RecordTypeId = recTypeIdOC;
        po8.CSS_Claims__c = null;
        po8.OEM__c ='123';
        po8.Quantity__c =1;
        po8.Selected_part__c =true;
        po8.Part_Name__c ='123456';
        po8.Service_partnumber__c ='123';
        po8.Parts_Type__c ='Custom';
        po8.Account_Code__c ='EMSWarranty35'; 
        // po8.Solutions__c=solRef.id;
        po8.FailurepartId__c =AddsolComp.Id;
        po8.Fail_Code__c='ABCD';
        po8.ODM_Status__c = 'ERROR';
        lstpo.add(po8);
        
        CSS_Parts_Options__c po9 =new CSS_Parts_Options__c();
        po9.Notes__c='123';
        po9.RecordTypeId = recTypeIdOC;
        po9.CSS_Claims__c = null;
        po9.OEM__c ='123';
        po9.Quantity__c =1;
        po9.Selected_part__c =true;
        po9.Part_Name__c ='123456';
        po9.Service_partnumber__c ='123';
        po9.Parts_Type__c ='Custom';
        po9.Account_Code__c ='EMSWarranty36'; 
         po9.Solutions__c=solRef.id;
        po9.FailurepartId__c =AddsolComp.Id;
        po9.Fail_Code__c='ABCD';
        po9.ODM_Status__c = 'ERROR';
        lstpo.add(po9);
        CSS_Parts_Options__c po7 =new CSS_Parts_Options__c();
        po7.Notes__c='123';
        po7.RecordTypeId = recTypeIdTTML;
        po7.CSS_Claims__c = null;
        po7.OEM__c ='123';
        po7.Quantity__c =1;
        po7.Selected_part__c =true;
        po7.Part_Name__c ='123456';
        po7.Service_partnumber__c ='123';
        po7.Parts_Type__c ='Custom';
        po7.Account_Code__c ='EMSWarranty36'; 
        // po7.Solutions__c=solRef.id;
        po7.FailurepartId__c =AddsolComp.Id;
        po7.Fail_Code__c='ABCD';
        po7.ODM_Status__c = 'PASSED';
        lstpo.add(po7);
        insert lstpo;
        list<CSS_Job_Order__c> jolist =new list<CSS_Job_Order__c>();
        jolist.add(jo);
        String json='{"Header": {'+
            '        "Target": {'+
            '            "TargetID": "TargetID"'+
            '        },'+
            '        "Sender": {'+
            '            "SenderID": "oh559",'+
            '            "ServiceName": "ServiceName"'+
            '        }'+
            '    },'+
            '    "Response": {'+
            '        "claim": {'+
            '            "Engine": {'+
            '                "billToCode": "oh559",'+
            '                "warrantyIndicatorFlag": "oh559",'+
            '                "marineFlag": "oh559",'+
            '                "buildDate": "oh559",'+
            '                "productApplicationDesp": "oh559",'+
            '                "oemCode": "oh559",'+
            '                "designPhaseCode": "oh559",'+
            '                "engineFamilyCode": "oh559",'+
            '                "serviceModel": "oh559",'+
            '                "etoConversionDate": "oh559"'+
            '            },'+
            '            "CG_ODM_ResJSONParser.messages": [{'+
            '"messageID":"sfdsfsd",'+
            '                "description": "oh559",'+
            '                "code": "oh559",'+
            '                "type": "oh559"'+
            '            }],'+
            '            "ServiceProvider": {'+
            '                "channelOfDistribution": "oh559",'+
            '                "region": "oh559",'+
            '                "claimAllowedDays": "oh559",'+
            '                "territory": "oh559",'+
            '                "outfileAllClaimsFlag": "oh559",'+
            '                "regionCode": "oh559",'+
            '                "inactiveDate": "oh559",'+
            '                "status": "oh559",'+
            '                "groupName": "oh559",'+
            '                "channelDescription": "oh559",'+
            '                "paccarChecked": "oh559",'+
            '                "ltaChecked": "oh559",'+
            '                "engineEffectiveDate": "oh559",'+
            '                "engineExpirationdate": "oh559",'+
            '                "serviceModelName": "oh559",'+
            '                "oemCode": "oh559",'+
            '                "spState": "oh559",'+
            '                "spCountry": "oh559",'+
            '                "spServiceLevel": "oh559",'+
            '                "spWarrantyTrainingStatus": "oh559",'+
            '                "spCertificationEndDate": "oh559",'+
            '                "spSCMDollarAmt": "oh559",'+
            '                "spSCMDeductiblePct": "oh559"'+
            '            },'+
            '            "AdditionalESN": [{'+
            '                "ESN": "oh559"'+
            '            }],'+
            '            "ComplaintCode": {'+
            '                "code": "oh559"'+
            '            },'+
            '            "Parts": [{'+
            '                "CG_ODM_ResJSONParser.messages": [{'+
            '"partSRTCode":"sfdsfsd",'+
            '                    "description": "oh559",'+
            '                    "code": "oh559",'+
            '                    "type": "oh559"'+
            '                }],'+
            '                "lineNumber": "oh559",'+
            '                "partId": "oh559",'+
            '                "partPrice": "oh559",'+
            '                "partName": "oh559",'+
            '                "reconPartFlag": "oh559",'+
            '                "priceBook": "oh559",'+
            '                "exceptionPriceBook": "oh559",'+
            '                "channelCode": "oh559",'+
            '                "standardPriceBook": "oh559",'+
            '                "pricingRegion": "oh559",'+
            '                "partAllowedFlag": "oh559",'+
            '                "partReturnFlag": "oh559",'+
            '                "qtyApproved": "oh559",'+
            '                "adjPartPercentage": "oh559",'+
            '                "MCEPSelectionFlag": "N",'+
            '                "NXpartId": "",'+
            '                "NXpartPrice": "",'+
            '                "NXpriceBookName": "",'+
            '                "RXpartId": "",'+
            '                "RXpartPrice": "",'+
            '                "RXpriceBookName": ""'+
            '            }],'+
            '            "Failure": [{'+
            '                "CG_ODM_ResJSONParser.messages": [{'+
            '"partSRTCode":"sfdsfsd",'+
            '                    "description": "oh559",'+
            '                    "code": "oh559",'+
            '                    "type": "oh559"'+
            '                }],'+
            '                "acctCodeInfo": {'+
            '                    "accountCodeType": "oh559",'+
            '                    "chryslerFlag": "oh559",'+
            '                    "multiESNFlag": "oh559",'+
            '                    "accountCodeWarrantyFlag": "oh559"'+
            '                },'+
            '                "campaign": {'+
            '                    "accountCode": "oh559",'+
            '                    "campaignId": "oh559",'+
            '                    "campaignType": "oh559",'+
            '                    "completeIndicator": "oh559",'+
            '                    "effectiveDate": "oh559",'+
            '                    "engineComponentCode": "oh559",'+
            '                    "expiryDateIntl": "oh559",'+
            '                    "expiryDateNA": "oh559",'+
            '                    "failMode": "oh559",'+
            '                    "multiFlag": "oh559",'+
            '                    "status": "oh559",'+
            '                    "systemCode": "oh559",'+
            '                    "cmpEngineStatusCode": "oh559"'+
            '                },'+
            '                "lineNumber": "oh559",'+
            '                "failCode": "oh559",'+
            '                "failMode": "oh559",'+
            '                "accountCode": "oh559",'+
            '                "payCode": "oh559",'+
            '                "status": "oh559",'+
            '                "authorizationNumber": "oh559",'+
            '                "approvalCode": "oh559",'+
            '                "campaignId": "oh559",'+
            '                "coverageType": "oh559",'+
            '                "totalLaborAmt": "oh559",'+
            '                "totalSRTHours": "oh559",'+
            '                "totalTowingAmt": "oh559",'+
            '                "accountCodeDesp": "oh559",'+
            '                "policyFlag": "oh559",'+
            '                "programID": "oh559",'+
            '                "overrideFlag": "oh559",'+
            '                "inShopCampaignFlag": "oh559",'+
            '                "travelCoveredFlag": "Y",'+
            '                "GSQID": "oh559"'+
            '            }],'+
            '            "OtherClaimables": [{'+
            '                "CG_ODM_ResJSONParser.messages": {'+
            '"partSRTCode":"sfdsfsd",'+
            '                    "description": "oh559",'+
            '                    "code": "oh559",'+
            '                    "type": "oh559"'+
            '                },'+
            '                "lineNumber": "oh559",'+
            '                "Item": "oh559",'+
            '                "details": "oh559",'+
            '                "amount": "oh559"'+
            '            }],'+
            '            "Travels": [{'+
            '                "CG_ODM_ResJSONParser.messages": [{'+
            '"partSRTCode":"sfdsfsd",'+
            '                    "description": "oh559",'+
            '                    "code": "oh559",'+
            '                    "type": "oh559"'+
            '                }],'+
            '                "lineNumber": "oh559",'+
            '                "hours": "oh559",'+
            '                "mealsCharges": "oh559",'+
            '                "towingCharges": "oh559",'+
            '                "travelDistance": "oh559"'+
            '            }],'+
            '            "SrtList": [{'+
            '"CG_ODM_ResJSONParser.messages": [{'+
            '"partSRTCode":"sfdsfsd",'+
            '                    "description": "oh559",'+
            '                    "code": "oh559",'+
            '                    "type": "oh559"'+
            '                },'+
            ' {'+
            '"partSRTCode":"sfdsfsd",'+
            '                    "description": "oh559",'+
            '                    "code": "oh559",'+
            '                    "type": "oh559"'+
            '                }],'+
            '                "lineNumber": "oh559",'+
            '                "code": "oh559",'+
            '                "hours": "oh559",'+
            '                "offsiteCheck": "oh559",'+
            '                "description": "oh559",'+
            '                "quantity": "oh559",'+
            '                "srtAllowedFlag": "oh559"'+
            '            }],'+
            '            "claimNumber": "oh559",'+
            '            "claimStatus": "oh559",'+
            '            "claimSource": "oh559",'+
            '            "cmiServiceProviderCode": "oh559",'+
            '            "serviceModelName": "oh559",'+
            '            "cmiEngineSerialNumber": "oh559",'+
            '            "productApplicationCode": "oh559",'+
            '            "warrantyStartDate": "oh559",'+
            '            "failureDate": "oh559",'+
            '            "claimCreatedDate": "oh559",'+
            '            "claimSubmittedDate": "oh559",'+
            '            "claimReceivedDate": "oh559",'+
            '            "engineFamily": "oh559",'+
            '            "failurePoint": "oh559",'+
            '            "bisFlag": "oh559",'+
            '            "multiESNFlag": "oh559",'+
            '            "failureMeasure": "oh559",'+
            '            "reconPartsWarrantyFlag": "oh559",'+
            '            "manualAdjudicationFlag": "oh559",'+
            '"Status":"safaaf",'+
            '            "roNumber": "oh559",'+
            '            "engineApplicationCode": "oh559",'+
            '            "serviceProviderName": "oh559",'+
            '            "distributorCode": "oh559",'+
            '            "totalClaimAmt": "oh559",'+
            '            "groupName": "oh559",'+
            '            "thresholdAmount": "oh559",'+
            '            "thresholdHrs": "oh559",'+
            '            "approverName": "oh559",'+
            '            "level": "oh559",'+
            '            "button": "oh559",'+
            '            "newPartsWarrantyFlag": "oh559",'+
            '            "possessionFlag": "oh559",'+
            '            "ecmCalibBefore": "oh559",'+
            '            "ecmCalibAfter": "oh559",'+
            '            "manufacturer": "oh559",'+
            '            "paccarFlag": "oh559",'+
            '            "paccarCertifiedLocationFlag": "oh559",'+
            '            "paccarPaymentRoutingFlag": "oh559",'+
            '            "countryCode": "oh559",'+
            '            "HeaderCampaign": "oh559",'+
            '            "penalty": "oh559",'+
            '            "certificationFlag": "oh559",'+
            '            "roadRelayWarrantyFlag": "oh559",'+
            '            "headerCampaignId": "oh559",'+
            '            "modelSeries": "oh559",'+
            '            "applicationName": "oh559",'+
            '            "claimSubSource": "oh559",'+
            '            "MCEPFlag": "Y"'+
            '        },'+
            '        "DecisionID": "DecisionID"'+
            '    }'+
            '}';
        
        CG_ODM_ResJSONParser resp = CG_ODM_ResJSONParser.parse(json);  
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new CG_ODM_ResJSONParser_Mock());
        CG_BL_ODM.captureStatusesMessages(resp,lsrt1,lstpo,20);
        Boolean resu =  CG_BL_ODM.callODMSRTServicesold('Claim',testclaimsRec.id);
        test.stopTest();
        
    }
    
    static TestMethod void passingAccountCodeInfoMethod(){
        
        List<CSS_JobEventTemporary__c> evntlst = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c obj = new CSS_JobEventTemporary__c();
        obj.Key__c = 'AccountCodes';
        obj.Attribute3__c = 'Testing';
        insert obj;
        CSS_JobEventTemporary__c obj1 = new CSS_JobEventTemporary__c();
        obj1.Key__c = 'AccountCodes';
        obj1.Attribute3__c = 'Testing';
        insert obj1;
        evntlst.add(obj);
        evntlst.add(obj1);
        Test.startTest();
        CG_BL_ODM.passingAccountCodeInfo('Testing');
        Test.stopTest();
    }
}