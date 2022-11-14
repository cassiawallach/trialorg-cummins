@isTest
global class CG_CL_AddFailure_GSQParts_Test 
{
    public static testmethod void testmethod1()
    {
        css_job_order__c jo =new css_job_order__c();
        jo.ESN__c='58764-58764';
        jo.Equipment_ID__c='34567';
        jo.Qsol_Engine_Family_Code__c='12345';
        jo.Service_Model__c='98765';
        insert jo;
     list<CSS_JobEventTemporary__c> lstjobeventemp = new list<CSS_JobEventTemporary__c>();
     CSS_JobEventTemporary__c jobeventemp1 = new CSS_JobEventTemporary__c();
        jobeventemp1.Attribute1__c= 'OTH';
        jobeventemp1.Attribute3__c= 'abc1';
        jobeventemp1.Attribute5__c= 'abc1';
        jobeventemp1.Attribute7__c= 'abx1';
        jobeventemp1.Attribute4__c= 'abc1';
        jobeventemp1.Active__c  = true;
        jobeventemp1.Attribute13__c= dateTime.now();
        jobeventemp1.key__c='FailCodes';
        jobeventemp1.Reason__c = 'fault code issue';
        //jobeventemp.Fault_Code_Description__c = 'qwerty';
        //jobeventemp.Attribute2__c= 'abc';
        lstjobeventemp.add(jobeventemp1);
        
      CSS_JobEventTemporary__c jobeventemp2 = new CSS_JobEventTemporary__c();
        jobeventemp2.Attribute1__c= 'OTH';
        jobeventemp2.Attribute4__c= 'abc1';
        jobeventemp2.Attribute5__c= 'abc1';
        jobeventemp2.Attribute3__c= 'abc1';
        //jobeventemp.Active__c  = true;
        //jobeventemp.Attribute13__C= 'sbc1';
        jobeventemp2.key__c='FailModes';
        jobeventemp2.Active__c=true;
        //jobeventemp.Reason__c = 'fault code issue';
        //jobeventemp.Fault_Code_Description__c = 'qwerty';
        lstjobeventemp.add(jobeventemp2);
        insert lstjobeventemp;
        
        apexpages.currentPage().getparameters().put('id',jo.Id);
        
        test.startTest();
        
        CSS_Integration_Details__c connection1 = new CSS_Integration_Details__c ();
        connection1.ApplicationName__c='SRT';
        connection1.Name='CG_GetFailureCodesSRT';
        connection1.End_Point__c='https://services-dev.cummins.com/css/RetrieveStandardRepairTime/';
        connection1.Method_Type__c='POST';
        connection1.Timeout__c=2.0;
        connection1.IsActive__c=true;
        connection1.Key__c='dz0AejpGdW3X1sgGVORjq7/zTV1lb0+VEQoH/aRqDj0=';
        connection1.Username__c='aXzi4HdAQ0q8NDFXCwkAxpLMkzYsfnsmbLWNY8aviw0=';
        connection1.Passcode__c='TI6CPyvKztOaUprj/t1f60stmcmgL9c+pPXyJfjTMLo=';
        connection1.Logging__c='Test';
        insert connection1;
        
        
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockSRTComponentLookupPass());
        
        CG_CL_AddFailure_GSQParts addfailuregsq = new CG_CL_AddFailure_GSQParts();
        addfailuregsq.selectedCustFName='';
        addfailuregsq.selectedSysCode='test';
        addfailuregsq.gsqFailurenames();
        addfailuregsq.selectedCustFName = 'abx1';
        // addfailuregsq.selectedSysCode = 'sys';
        addfailuregsq.selectedFName = '762';
        addfailuregsq.selectedSysCode = '567';
        addfailuregsq.selectedCompCode = '972';
        addfailuregsq.selectedFName = 'unlisted';
        addfailuregsq.invalidFailure=false;
        addfailuregsq.invalidCustFailure=false;
        addfailuregsq.invalidSysCode=false;
        addfailuregsq.invalidCompCode=false;
        addfailuregsq.invalidFaultCode=false;
        addfailuregsq.invalidFailMode=false;
        addfailuregsq.popupsave();
        addfailuregsq.changefailmode();
        addfailuregsq.changeSystemcode();
        addfailuregsq.changeComponentCode();
        
        
        addfailuregsq.selectedSysCode ='leak';
        addfailuregsq.changeCustFailures();
        
        addfailuregsq.selectedCompCode ='762';
        addfailuregsq.changeCustFailures();
        addfailuregsq.getfailurenames();
        addfailuregsq.getComponentCodes();
        addfailuregsq.getSystemCodes();
        addfailuregsq.getFailModes();
        addfailuregsq.getGsqcustFailurenameslist();
        addfailuregsq.cancelPopup();
        addfailuregsq.selectedFName = '762';
        addfailuregsq.selectedCustFNameValue = 'test';
        addfailuregsq.selectedSysCodeValue = '77';
        addfailuregsq.selectedCompCodeValue = '88';
        addfailuregsq.selectedFailModeValue='test1';
        addfailuregsq.popUpSave();
        
        addfailuregsq.selectedFailMode='test1';
        addfailuregsq.popUpSave();
        addfailuregsq.selectedFName = 'unlisted';
        //addfailuregsq.selectedCustFName = 'Sai';
        addfailuregsq.popUpSave();
        addfailuregsq.selectedFName = '';
        addfailuregsq.selectedSysCode = 'oil-leak';
        addfailuregsq.selectedCompCode ='acurator';
        addfailuregsq.popUpSave();
        addfailuregsq.selectedCompCode ='762';
        addfailuregsq.popUpSave();
        addfailuregsq.selectedFailMode =lstjobeventemp[1].Attribute1__c+'-'+lstjobeventemp[1].Attribute3__c.replace('\'\\','');//'762';
        addfailuregsq.popUpSave();
        addfailuregsq.checkCompCode();
        addfailuregsq.selectedFailMode='OTH-abc1';
        addfailuregsq.checkFailMode();
        addfailuregsq.selectedFName = 'Turbocharger';
        addfailuregsq.changeFailures();
        CSS_Solution_Component__c obj = new CSS_Solution_Component__c();
        obj.AccountCode__c='test';
        insert obj;
         addfailuregsq.selectedFailMode='test1';
        addfailuregsq.checkFailMode();
        test.stopTest();
    }
    
   
    public static testmethod void testmethod2()
    {
        css_job_order__c jo1 =new css_job_order__c();
        jo1.ESN__c='58764-58764';
        jo1.Equipment_ID__c='34567';
        jo1.Qsol_Engine_Family_Code__c='';
        jo1.Service_Model__c='';
        insert jo1;
        
        List<CSS_JobEventTemporary__c> lstjobeventemp = new List<CSS_JobEventTemporary__c>();
        
        
        
        
        CSS_JobEventTemporary__c jobeventemp1 = new CSS_JobEventTemporary__c();
        jobeventemp1.Effect__c ='qwert';
        jobeventemp1.Reason__c = 'fault code issue';
        jobeventemp1.Fault_Code_Description__c = 'qwerty';
        jobeventemp1.Active__c  = true;
        jobeventemp1.Attribute2__c= 'abc';
        jobeventemp1.Attribute3__c= 'abc1';
        jobeventemp1.Attribute1__c= 'OTH';
        jobeventemp1.Attribute5__c= 'abc1';
        jobeventemp1.Attribute4__c= 'abc1';
        jobeventemp1.Key__c='AccountCodes';
        lstjobeventemp.add(jobeventemp1); 
        
        CSS_JobEventTemporary__c jobeventemp = new CSS_JobEventTemporary__c();
        jobeventemp.Attribute1__c= 'OTH';
        jobeventemp.Attribute3__c= 'abc1';
        jobeventemp.Attribute5__c= 'abc1';
        jobeventemp.Attribute7__c= 'abx1';
        jobeventemp.Attribute4__c= 'abc1';
        jobeventemp.Active__c  = true;
        jobeventemp.Attribute13__c= dateTime.now();
        jobeventemp.key__c='FailCodes';
        //jobeventemp.Reason__c = 'fault code issue';
        //jobeventemp.Fault_Code_Description__c = 'qwerty';
        //jobeventemp.Attribute2__c= 'abc';
        lstjobeventemp.add(jobeventemp); 
        
        insert lstjobeventemp;
        
        apexpages.currentPage().getparameters().put('id',jo1.Id);
        
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockSRTComponentLookupPass());
        
        CG_CL_AddFailure_GSQParts addfailuregsq = new CG_CL_AddFailure_GSQParts();
        addfailuregsq.gsqFailurenames();
        addfailuregsq.selectedFName = 'test';
        addfailuregsq.selectedCompCode = '123';
        addfailuregsq.selectedSysCode = '55';
        
        addfailuregsq.changeCustFailures();
        addfailuregsq.getfailurenames();
        addfailuregsq.getComponentCodes();
        addfailuregsq.getSystemCodes();
        addfailuregsq.getFailModes();
        addfailuregsq.getGsqcustFailurenameslist();
        addfailuregsq.cancelPopup();
        addfailuregsq.popUpSave();
        addfailuregsq.changeFailures();
        test.stopTest();
    }
    public static testmethod void testmethod3()
    {
        css_job_order__c jo =new css_job_order__c();
        jo.ESN__c='58764-58764';
        jo.Equipment_ID__c='34567';
        jo.Qsol_Engine_Family_Code__c='12345';
        jo.Service_Model__c='98765';
        insert jo;
        list<CSS_Parts_Options__c> Parts = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c po=new CSS_Parts_Options__c();
        po.Service_Job__c=jo.id;
  //      po.RecordType.Name = 'Options';
        Parts.add(po);
        CSS_Parts_Options__c po1=new CSS_Parts_Options__c();
        po1.Service_Job__c=jo.id;
    //    po1.RecordType.Name = 'parts';
        Parts.add(po1);
        insert Parts;
        CSS_SRTComponentLookupResponseJ2A.DataArea dArea = new CSS_SRTComponentLookupResponseJ2A.DataArea();
        dArea.ComponentCode ='CG';
        dArea.FailureMode ='';
        dArea.FailureID ='F30000860';
        dArea.FailureName ='Accessory Plate Cover Gasket';
        dArea.SystemCode='BG';
        CSS_SRTComponentLookupResponseJ2A controllerNew = new CSS_SRTComponentLookupResponseJ2A();
        controllerNew.DataArea = new list<CSS_SRTComponentLookupResponseJ2A.DataArea>();
        controllerNew.DataArea.add(dArea);
        
        
        //Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        CSS_SRTComponentLookupResponseJ2A srtlookup = new CSS_SRTComponentLookupResponseJ2A();
        //CSS_SRTComponentLookupResponseJ2A.DataArea jidi = new CSS_SRTComponentLookupResponseJ2A.DataArea(); 
        
        list<CSS_JobEventTemporary__c> lstjobeventemp = new list<CSS_JobEventTemporary__c>();
        
        CSS_JobEventTemporary__c jobeventemp1 = new CSS_JobEventTemporary__c();
        jobeventemp1.Attribute1__c= 'OTH';
        jobeventemp1.Attribute3__c= 'abc1';
        jobeventemp1.Attribute5__c= 'abc1';
        jobeventemp1.Attribute7__c= 'abx1';
        jobeventemp1.Attribute4__c= 'abc1';
        jobeventemp1.Active__c  = true;
        jobeventemp1.Attribute13__c= dateTime.now();
        jobeventemp1.key__c='FailCodes';
        jobeventemp1.Reason__c = ' fault code issue';
        //jobeventemp.Fault_Code_Description__c = 'qwerty';
        //jobeventemp.Attribute2__c= 'abc';
        lstjobeventemp.add(jobeventemp1);
        
        
        CSS_JobEventTemporary__c jobeventemp2 = new CSS_JobEventTemporary__c();
        jobeventemp2.Attribute1__c= 'OTH';
        jobeventemp2.Attribute4__c= 'abc1';
        jobeventemp2.Attribute5__c= 'abc1';
        jobeventemp2.Attribute3__c= 'abc1';
        //jobeventemp.Active__c  = true;
        //jobeventemp.Attribute13__C= 'sbc1';
        jobeventemp2.key__c='FailCodes';
        //jobeventemp.Reason__c = 'fault code issue';
        //jobeventemp.Fault_Code_Description__c = 'qwerty';
        lstjobeventemp.add(jobeventemp2);
        
        CSS_JobEventTemporary__c jobeventemp3 = new CSS_JobEventTemporary__c();
        jobeventemp3.Attribute1__c= 'OTH';
        jobeventemp3.Attribute4__c= 'abc1';
        jobeventemp3.Attribute3__c= '98765;;12345';
        //jobeventemp3.Reason__c = 'fault code issue';
        jobeventemp3.Reason__c = '{ "Header": { "ReturnCodeDescription": "Normal, Successful completion.", "ReturnCode": "ORA-00000", "MessageIdentifier": "S" }, "DataArea": [{ "SystemCode": "QC", "FailureName": "Air Compressor", "FailureMode": "", "FailureID": "F12000000", "ComponentCode": "AS" }, { "SystemCode": "QC", "FailureName": "Air Compressor Cylinder Head", "FailureMode": "", "FailureID": "F12000010", "ComponentCode": "CH" }] }';
        jobeventemp3.Key__c = 'getFailureCodesSRT';
        jobeventemp2.CreatedDate = system.today();
        lstjobeventemp.add(jobeventemp3);
        insert lstjobeventemp;
        
        apexpages.currentPage().getparameters().put('id',jo.Id);
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockSRTComponentLookupPass());
        
        CG_CL_AddFailure_GSQParts addfailuregsq = new CG_CL_AddFailure_GSQParts();
        addfailuregsq.gsqFailurenames();
        addfailuregsq.selectedCustFName = '762';
        addfailuregsq.selectedSysCode = '567';
        addfailuregsq.selectedCompCode = '972';
          addfailuregsq.changeFailures();
        addfailuregsq.changeCustFailures();
        
        addfailuregsq.getfailurenames();
        addfailuregsq.getComponentCodes();
        addfailuregsq.getSystemCodes();
        addfailuregsq.getFailModes();
        addfailuregsq.getGsqcustFailurenameslist();
        addfailuregsq.cancelPopup();
        addfailuregsq.popUpSave();
        // addfailuregsq.jobEvSCCC();
        
        
        test.stopTest();
    }
    public static testmethod void testmethod33()
    {
        css_job_order__c jo =new css_job_order__c();
        jo.ESN__c='58764-58764';
        jo.Equipment_ID__c='34567';
        jo.Qsol_Engine_Family_Code__c='12345';
        jo.Service_Model__c='98765';
        insert jo;
        list<CSS_Parts_Options__c> Parts = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c po=new CSS_Parts_Options__c();
        po.Service_Job__c=jo.id;
  //      po.RecordType.Name = 'Options';
        Parts.add(po);
        CSS_Parts_Options__c po1=new CSS_Parts_Options__c();
        po1.Service_Job__c=jo.id;
    //    po1.RecordType.Name = 'parts';
        Parts.add(po1);
        insert Parts;
        CSS_SRTComponentLookupResponseJ2A.DataArea dArea = new CSS_SRTComponentLookupResponseJ2A.DataArea();
        dArea.ComponentCode ='CG';
        dArea.FailureMode ='';
        dArea.FailureID ='F30000860';
        dArea.FailureName ='Accessory Plate Cover Gasket';
        dArea.SystemCode='BG';
        CSS_SRTComponentLookupResponseJ2A controllerNew = new CSS_SRTComponentLookupResponseJ2A();
        controllerNew.DataArea = new list<CSS_SRTComponentLookupResponseJ2A.DataArea>();
        controllerNew.DataArea.add(dArea);
        
        
        //Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        CSS_SRTComponentLookupResponseJ2A srtlookup = new CSS_SRTComponentLookupResponseJ2A();
        //CSS_SRTComponentLookupResponseJ2A.DataArea jidi = new CSS_SRTComponentLookupResponseJ2A.DataArea(); 
        
        list<CSS_JobEventTemporary__c> lstjobeventemp = new list<CSS_JobEventTemporary__c>();
        
        CSS_JobEventTemporary__c jobeventemp1 = new CSS_JobEventTemporary__c();
        jobeventemp1.Attribute1__c= 'OTH';
        jobeventemp1.Attribute3__c= 'abc1';
        jobeventemp1.Attribute5__c= 'abc1';
        jobeventemp1.Attribute7__c= 'abx1';
        jobeventemp1.Attribute4__c= 'abc1';
        jobeventemp1.Active__c  = true;
        jobeventemp1.Attribute13__c= dateTime.now();
        jobeventemp1.key__c='FailCodes';
        //jobeventemp1.Reason__c = ' fault code issue';
        //jobeventemp.Fault_Code_Description__c = 'qwerty';
        //jobeventemp.Attribute2__c= 'abc';
        lstjobeventemp.add(jobeventemp1);
        
        
        CSS_JobEventTemporary__c jobeventemp2 = new CSS_JobEventTemporary__c();
        jobeventemp2.Attribute1__c= 'unlisssted';
        jobeventemp2.Attribute4__c= 'unlisssted';
        jobeventemp2.Attribute5__c= 'abc1';
        jobeventemp2.Attribute3__c= 'abc1';
        //jobeventemp.Active__c  = true;
        //jobeventemp.Attribute13__C= 'sbc1';
        jobeventemp2.key__c='FailCodes';
        //jobeventemp.Reason__c = 'fault code issue';
        //jobeventemp.Fault_Code_Description__c = 'qwerty';
        lstjobeventemp.add(jobeventemp2);
        
        CSS_JobEventTemporary__c jobeventemp3 = new CSS_JobEventTemporary__c();
        jobeventemp3.Attribute1__c= 'OTH';
        jobeventemp3.Attribute4__c= 'abc1';
        jobeventemp3.Attribute3__c= '98765;;12345';
        //jobeventemp3.Reason__c = 'fault code issue';
        jobeventemp3.Reason__c = '{ "Header": { "ReturnCodeDescription": "Normal, Successful completion.", "ReturnCode": "ORA-00000", "MessageIdentifier": "S" }, "DataArea": [{ "SystemCode": "QC", "FailureName": "Air Compressor", "FailureMode": "", "FailureID": "F12000000", "ComponentCode": "AS" }, { "SystemCode": "QC", "FailureName": "Air Compressor Cylinder Head", "FailureMode": "", "FailureID": "F12000010", "ComponentCode": "CH" }] }';
        jobeventemp3.Key__c = 'getFailureCodesSRT';
        jobeventemp2.CreatedDate = system.today();
        lstjobeventemp.add(jobeventemp3);
        insert lstjobeventemp;
        
        apexpages.currentPage().getparameters().put('id',jo.Id);
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockSRTComponentLookupPass());
        
        CG_CL_AddFailure_GSQParts addfailuregsq = new CG_CL_AddFailure_GSQParts();
        addfailuregsq.selectedFName='unlisted';
        addfailuregsq.selectedCustFName='unlisted';
        Set<String> componentCodeList = new Set<String>();
        componentCodeList.add('element');
        addfailuregsq.componentCodeList=componentCodeList;
        addfailuregsq.gsqFailurenames();
        addfailuregsq.selectedSysCode = '567';
        addfailuregsq.selectedCustFName='';
        addfailuregsq.selectedCompCode='test';
        addfailuregsq.gsqFailurenames();
        //addfailuregsq.selectedCustFName = '762';
        addfailuregsq.selectedSysCode = '567';
        addfailuregsq.selectedCompCode = '972';
          addfailuregsq.checkCompCode();
        addfailuregsq.selectedFName='unlisssted';
        Map<String,String> failureNameWithSystemCodeMap = new map<string,string>();
        failureNameWithSystemCodeMap.put('unlisssted','unlisssted');
        Map<String,String> failureNameWithCompCodeMap = new map<string,string>();
        failureNameWithCompCodeMap.put('unlisssted','unlisssted');
        addfailuregsq.failureNameWithSystemCodeMap=failureNameWithSystemCodeMap;
            addfailuregsq.failureNameWithCompCodeMap=failureNameWithCompCodeMap;
        addfailuregsq.changeFailures();
        test.stopTest();
    }
    public static testmethod void testmethod4()
    {
        css_job_order__c jo =new css_job_order__c();
        jo.ESN__c='58764-58764';
        jo.Equipment_ID__c='34567';
        jo.Qsol_Engine_Family_Code__c='12345';
        jo.Service_Model__c='98765';
        insert jo;
        
        
        list<CSS_JobEventTemporary__c> lstjobeventemp = new list<CSS_JobEventTemporary__c>();
        
        
        
        
        CSS_JobEventTemporary__c jobeventemp1 = new CSS_JobEventTemporary__c();
        jobeventemp1.Reason__c = 'fault code issue';
        lstjobeventemp.add(jobeventemp1);
        insert lstjobeventemp;
        
        
        CSS_SRTComponentLookupResponseJ2A.DataArea dArea = new CSS_SRTComponentLookupResponseJ2A.DataArea();
        dArea.ComponentCode ='CG';
        dArea.FailureMode ='';
        dArea.FailureID ='F30000860';
        dArea.FailureName ='Accessory Plate Cover Gasket';
        dArea.SystemCode='BG';
        CSS_SRTComponentLookupResponseJ2A controllerNew = new CSS_SRTComponentLookupResponseJ2A();
        controllerNew.DataArea = new list<CSS_SRTComponentLookupResponseJ2A.DataArea>();
        controllerNew.DataArea.add(dArea);
        // controllerNew.DataArea = new list<CSS_Parts_Options__c>.fetchGSQServiceParts(solnComp, serviceJob);
        
        
        apexpages.currentPage().getparameters().put('id',jo.Id);
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockSRTComponentLookupPass());
        
        CG_CL_AddFailure_GSQParts addfailuregsq1 = new CG_CL_AddFailure_GSQParts();
        addfailuregsq1.getfailurenames();
        test.stopTest();
    }
    
    public static testmethod void testmethod5()
    {
        css_job_order__c jo =new css_job_order__c();
        jo.ESN__c='58764-58764';
        jo.Equipment_ID__c='34567';
        jo.Qsol_Engine_Family_Code__c='12345';
        jo.Service_Model__c='98765';
        insert jo;
        
        list<CSS_JobEventTemporary__c> lstjobeventemp = new list<CSS_JobEventTemporary__c>();
        
        CSS_JobEventTemporary__c jobeventemp1 = new CSS_JobEventTemporary__c();
        jobeventemp1.Attribute1__c= 'OTH';
        jobeventemp1.Attribute3__c= 'abc1';
        jobeventemp1.Attribute5__c= 'abc1';
        jobeventemp1.Attribute7__c= 'abx1';
        jobeventemp1.Attribute4__c= 'abc1';
        jobeventemp1.Active__c  = true;
        jobeventemp1.Attribute13__c= dateTime.now();
        jobeventemp1.key__c='FailCodes';
        jobeventemp1.Reason__c = 'fault code issue';
        lstjobeventemp.add(jobeventemp1);
        
        
      /*  CSS_JobEventTemporary__c jobeventemp2 = new CSS_JobEventTemporary__c();
        jobeventemp2.Attribute1__c= 'OTH';
        jobeventemp2.Attribute4__c= 'abc1';
        jobeventemp2.Attribute5__c= 'abc1';
        jobeventemp2.Attribute3__c= 'abc1';
        jobeventemp2.key__c='FailCodes';
        jobeventemp2.Reason__c = 'fault code issue';
        lstjobeventemp.add(jobeventemp2);
        insert lstjobeventemp;*/
        
        apexpages.currentPage().getparameters().put('id',jo.Id);
        
       
        // jobeventtemp1.Key__c='FailCodes';
        // jobeventemp1.add(jobeventtemp1);
        //insert jobeventemp1;
        
        apexpages.currentPage().getparameters().put('id',jo.Id);
        
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockSRTComponentLookupPass());
        CG_CL_AddFailure_GSQParts addfailuregsq = new CG_CL_AddFailure_GSQParts();
        addfailuregsq.selectedFName = 'unlisted';
        addfailuregsq.gsqFailurenames();
        addfailuregsq.selectedCustFName = 'abx1';
        addfailuregsq.selectedSysCode = 'test2';
        addfailuregsq.selectedCompCode = 'test3';
        addfailuregsq.changeFailures();
        addfailuregsq.changeCustFailures();
        addfailuregsq.getfailurenames();
        addfailuregsq.getComponentCodes();
        addfailuregsq.getSystemCodes();
        addfailuregsq.getFailModes();
        addfailuregsq.getGsqcustFailurenameslist();
        addfailuregsq.cancelPopup();
        addfailuregsq.popUpSave();
        
        test.stopTest();
    } 
    
    //For Cancellation Interface Test
    global class SingleRequestMockSRTComponentLookupPass implements HttpCalloutMock {
        
        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse resp = new HttpResponse();
            resp.setStatusCode(200);
            resp.setBody('{ "DataArea": [ { "ComponentCode": "CG", "FailureMode": "", "FailureID": "F30000860", "FailureName": "Accessory Plate Cover Gasket", "SystemCode": "BG" }], "Header": { "ReturnCodeDescription":"Normal, Successful completion.", "ReturnCode": "ORA-00000", "MessageIdentifier": "S" } }');
            return resp;
        }
    }
    
    public static testmethod void testmethod11()
    {
          css_job_order__c jo =new css_job_order__c();
          jo.ESN__c='58764-58764';
          jo.Equipment_ID__c='34567';
          jo.Qsol_Engine_Family_Code__c='12345';
          jo.Service_Model__c='98765';
          insert jo;
          
         
        
        list<CSS_JobEventTemporary__c> lstjobeventemp = new list<CSS_JobEventTemporary__c>();
           
        CSS_JobEventTemporary__c jobeventemp1 = new CSS_JobEventTemporary__c();
        jobeventemp1.Attribute1__c= 'OTH';
        jobeventemp1.Attribute3__c= 'abc1';
        jobeventemp1.Attribute5__c= 'abc1';
        jobeventemp1.Attribute7__c= 'abx1';
        jobeventemp1.Attribute4__c= 'abc1';
        jobeventemp1.Active__c  = true;
        jobeventemp1.Attribute13__c= dateTime.now();
        jobeventemp1.key__c='FailCodes';
        jobeventemp1.Reason__c = 'falut code issue';
        //jobeventemp.Fault_Code_Description__c = 'qwerty';
        //jobeventemp.Attribute2__c= 'abc';
        lstjobeventemp.add(jobeventemp1);
        

        CSS_JobEventTemporary__c jobeventemp2 = new CSS_JobEventTemporary__c();
        jobeventemp2.Attribute1__c= 'OTH';
        jobeventemp2.Attribute4__c= 'abc1';
        jobeventemp2.Attribute5__c= 'abc1';
        jobeventemp2.Attribute3__c= 'abc1';
        //jobeventemp.Active__c  = true;
        //jobeventemp.Attribute13__C= 'sbc1';
        jobeventemp2.key__c='FailCodes';
        //jobeventemp.Reason__c = 'falut code issue';
        //jobeventemp.Fault_Code_Description__c = 'qwerty';
        lstjobeventemp.add(jobeventemp2);
        insert lstjobeventemp;
          
           apexpages.currentPage().getparameters().put('id',jo.Id);
          
          test.startTest();
          
          Test.setMock(HttpCalloutMock.class, new SingleRequestMockSRTComponentLookupPass());
      
          CG_CL_AddFailure_GSQParts addfailuregsq = new CG_CL_AddFailure_GSQParts();
          addfailuregsq.gsqFailurenames();
          addfailuregsq.selectedCustFName = '123';
        addfailuregsq.selectedSysCode = 'sys';
          addfailuregsq.selectedFName = '762';
          addfailuregsq.selectedSysCode = '567';
          addfailuregsq.selectedCompCode = '972';
      
          addfailuregsq.changeFailures();
        
          
         addfailuregsq.selectedSysCode ='leak';
        addfailuregsq.changeCustFailures();
         
         addfailuregsq.selectedCompCode ='762';
        addfailuregsq.changeCustFailures();
          addfailuregsq.getfailurenames();
          addfailuregsq.getComponentCodes();
          addfailuregsq.getSystemCodes();
          addfailuregsq.getFailModes();
          addfailuregsq.getGsqcustFailurenameslist();
          addfailuregsq.cancelPopup();
        addfailuregsq.selectedFName = '762';
          addfailuregsq.popUpSave();
        addfailuregsq.selectedFName = 'unlisted';
        addfailuregsq.selectedCustFName = 'Sai';
          addfailuregsq.popUpSave();
          addfailuregsq.selectedFName = '';
        addfailuregsq.selectedSysCode = 'leak';
        addfailuregsq.popUpSave();
          addfailuregsq.selectedCompCode ='762';
          addfailuregsq.popUpSave();
        addfailuregsq.selectedFailMode ='762';
          addfailuregsq.popUpSave();
        CSS_Solution_Component__c obj = new CSS_Solution_Component__c();
        obj.AccountCode__c='test';
        insert obj;
          test.stopTest();
     }
    
    
    
}