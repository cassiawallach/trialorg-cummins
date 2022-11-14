@isTest
public class CSS_QuickServe_Test { 
    static CSS_Job_Order__c JO; 
    static CSS_Job_Order__c JO1; 
    static testMethod void faultCodeOverview(){ 
        string apiKey = '1234';
        string esn = '79464646'; 
         string esnData = '79464646';
        string faultCode = '441';
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
         cid.name = 'GetFaultCodeOverviewQsolREST';//'GetOptionsforQsolREST';GetFaultCodeOverviewQsolREST
         cid.ApplicationName__c = 'GetFaultCodeOverviewQsolREST';
         cid.End_Point__c = 'https://qs-stg.cummins.com/integrationservices/api/getFaultCodeOverview?serialNumber=';//'https://qs-stg.cummins.com/integrationservices/api/catalog/optionlist?serialNumber=';
         cid.logging__c = 'BOTH';
         cid.AuthEnv__c = 'QsolToken';
         cid.Method_Type__c = 'GET';
         cid.Timeout__c = 12000;
         insert cid;
         
        //Test.setMock(HttpCalloutMock.class, new CG_J2AQsolTokenMock());
       // List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
       Test.startTest();
       
        Test.setMock(WebServiceMock.class, new CSS_GetFaultCodeOverview_Test());        
        //CSS_JobEventTemporary__c fci = CSS_QuickServe.getFaultCodeOverview_Existing(faultCode,esnData); //not in use method
         CSS_JobEventTemporary__c fci1 = CSS_QuickServe.getFaultCodeOverview(faultCode,esnData);
        Test.stopTest();
        
       /*  Test.setMock(WebServiceMock.class, new CSS_GetFaultCodeOverview_Test());        
        CSS_JobEventTemporary__c fci = CSS_QuickServe.getFaultCodeOverview(faultCode,esn);
        Test.stopTest();*/
        //System.assertEquals('Amber',fci);
    }
    /* static testMethod void tsbsForFaultCode(){
Test.setMock(WebServiceMock.class, new CSS_GetTsbForFaultCode_Test());
string faultCode = CSS_QuickServe.getTsbsForFaultCode();
}*/
    static testMethod void qsol(){
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());        
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());  
        JO = NEW CSS_Job_Order__c();
       // List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        CSS_getEngineDataReqJ2A enginereq = new CSS_getEngineDataReqJ2A();        
        CSS_getEngineDataReqJ2A.DataArea Req = new CSS_getEngineDataReqJ2A.DataArea();
        Req.ESN='79384192';
        enginereq.DataArea = Req;        
        Id contactRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName()
        .get('Guidanz').getRecordTypeId();
        CSS_getEngineDataResponseJ2A engineData = new CSS_getEngineDataResponseJ2A(); 
        
         Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Guidanz').getRecordTypeId();
        
        account a = new account();
        a.name = 'Testing';
        a.ACCOUNT_STATUS__c = 'true';
        a.RecordtypeId  = recordTypeId;
        insert a;
        
        contact con = new contact();
        con.FirstName='Test2';
        con.Lastname = 'krishna';
        con.AccountId = a.Id;
        con.RecordtypeId    =contactRecId;
        insert con;
        
        Asset lstAsset = new Asset();
        lstAsset.Name = 'krish';
        lstAsset.AccountId = a.id;
        lstAsset.ContactId = con.id;
        lstAsset.type__c = 'Products';
        lstAsset.SerialNumber = '79464646';
        lstAsset.Automotive_Application_Flag__c = 'N';
        lstAsset.Model__c = 'krishna';
        lstAsset.ETO_Conversion_Date__c = date.today();
        lstAsset.Marine_Application_Flag__c = 'N';
        lstAsset.Engine_Bill_To_Code__c = 'krishna';
        lstAsset.Equipment_Id__c = 'krishna';
        lstAsset.Customer_Name__c = 'krishna';
        lstAsset.Build_Date__c = date.today();
        lstAsset.Make__c = 'asdasd'; // Correct?
        lstAsset.Engine_Family_Code__c= 'krishna';
        lstAsset.Warranty_Start_Date__c= date.today();
        lstAsset.Product_Application_Code__c= 'KR';
        lstAsset.Service_Model__c= 'krishna';
        lstAsset.Access_Code__c= 'krishna';
        lstAsset.Product_Application_Description__c= 'krishna';
        lstAsset.VIN__c= 'krishna';
        lstAsset.Equipment_Configuration__c= 'krishna';
        lstAsset.No_Warranty__c = true;
        lstAsset.Critical_Part_List_Number__c= 'krishna';
        lstAsset.OEM_SP_Code__c= 'krishna';
        lstAsset.Design_Phase_Code__c= 'krishna';
        lstAsset.Equipment_Configuration__c= 'krishna';
        lstAsset.Paccar_Flag__c = true;
        lstAsset.Engine_Family_Name__c= 'krishna';
        lstAsset.Ship_Date__c = date.today();
        lstAsset.ETO_Old_PSN__c = '352523552';
        insert lstAsset;
        
        Test.startTest();  
        engineData = CSS_WS_SBL.getEngineData(enginereq);
        //engineData = CSS_WS_SBL.getEngineData(null);
        //CSS_QuickServe.getDataPlateDocSave_Existing(JO.id,JO.ESN__c); //not in use method
        Date Mydate = CSS_QuickServe.parseQSOLDate('15-1-2005');
         CSS_QuickServe.getDataPlateDocSave(JO.id,JO.ESN__c,JO.Make__c,JO.Model__c,JO.PSN_Not_Available__c);
         CSS_List_Of_Values__c ListOfValue = new CSS_List_Of_Values__c();
         ListOfValue.Code__c = '130';
         ListOfValue.Picklist_Values_1__c = 'AUTOMOTIVE';
         ListOfValue.Picklist_Values_2__c = 'AUTOMOTIVE';
         ListOfValue.Picklist_Values_3__c = 'AUTOMOTIVE';
         ListOfValue.Type__c = 'Application Code';
         ListOfValue.Name = '1';
         insert ListOfValue;
         CSS_QuickServe.getDataPlateDocSave(JO.id,JO.ESN__c,'UNLISTED','ALL',TRUE);
       
        CSS_QuickServe.qsolIntegrationError('testError');
        Test.stopTest();
    }
    static testMethod void qsol2(){
      JO = NEW CSS_Job_Order__c();
       // List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.PSN_Not_Available__c=false;
        insert JO;
        CSS_quickserveCumminsComWebservices.ModelName mn= new CSS_quickserveCumminsComWebservices.ModelName();
        mn.Response=null;
        mn.ResponseMessage=null;
        mn.vin='test';
        mn.buildDate=null;
      //CSS_QuickServe.getDataPlateDocSave_Existing(JO.id,null); //not in use method
    }
    static testMethod void qsol1(){
        //Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());        
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());  
        JO = NEW CSS_Job_Order__c();
       // List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        CSS_getEngineDataReqJ2A enginereq = new CSS_getEngineDataReqJ2A();        
        CSS_getEngineDataReqJ2A.DataArea Req = new CSS_getEngineDataReqJ2A.DataArea();
        Req.ESN='79384192';
        enginereq.DataArea = Req;        
       CSS_getEngineDataResponseJ2A engineData = new CSS_getEngineDataResponseJ2A(); 
       /*String json='{\r\n\t\"DataArea\": {\r\n\t\t\"EtoConversionDate\": \"\",\r\n\t\t\"EquipmentId\": \"EQ7503\",\r\n\t\t\"EngineAppCode\": \"130\",\r\n\t\t\"DesignPhaseCode\": \"21\",\r\n\t\t\"ETOOldPSN\": \"12345678\",\r\n\t\t\"ETOOldESN\": \"23231245\",\r\n\t\t\"Manufacturer\": \"AUTOCAR\",\r\n\t\t\"OEMSPCode\": \"01005\",\r\n\t\t\"CriticalPartsListNumber\": \"8257\",\r\n\t\t\"CustomerName\": \"testingTTMl\",\r\n\t\t\"ProdAppCode\": \"BB\",\r\n\t\t\"ServiceModelName\": \"ISX CM570\",\r\n\t\t\"EngineFamilyName\": \"ISXSIGNATURE(APEX)\",\r\n\t\t\"EquipmentConfiguration\": \"CAB OVER\",\r\n\t\t\"PACCARFlag\": \"\",\r\n\t\t\"Esn\": \"79462880\",\r\n\t\t\"EngineBillToCode\": \"01405\",\r\n\t\t\"MarineAppFlag\": \"N\",\r\n\t\t\"AccessCode\": \"B\",\r\n\t\t\"ShipDate\": \"2011-03-05 00:00:00.0\",\r\n\t\t\"AutomotiveAppFlag\": \"Y\",\r\n\t\t\"EngineFamilyCode\": \"10\",\r\n\t\t\"BuildDate\": \"2011-03-01T00:00:00.000-06:00\",\r\n\t\t\"EngineAppDesc\": \"AUTOMOTIVE\",\r\n\t\t\"NoWarranty\": \"N\",\r\n\t\t\"ProdAppDesc\": \"AUTOMOTIVE\",\r\n\t\t\"Model\": \"ACX\",\r\n\t\t\"VIN\": \"3HSDJAPT9CN565886\",\r\n\t\t\"WarrantyStartDate\": \"2018-10-01T00:00:00.000-05:00\"\r\n\t},\r\n\t\"Header\": {\r\n\t\t\"Status\": \"Success\"\r\n\t}\r\n}'+
            '';
        CSS_getEngineDataResponseJ2A.parse(json);
        CSS_getEngineDataResponseJ2A.DataArea cont = new CSS_getEngineDataResponseJ2A.DataArea();
        cont.ETOOldESN = '7946463778';*/
        Test.startTest();  
        engineData = CSS_WS_SBL.getEngineData(enginereq);
        //engineData = CSS_WS_SBL.getEngineData(null);
        CSS_List_Of_Values__c ListOfValue = new CSS_List_Of_Values__c();
         ListOfValue.Code__c = '130';
         ListOfValue.Picklist_Values_1__c = 'AUTOMOTIVE';
         ListOfValue.Picklist_Values_2__c = 'AUTOMOTIVE';
         ListOfValue.Picklist_Values_3__c = 'AUTOMOTIVE';
         ListOfValue.Type__c = 'Application Code';
         ListOfValue.Name = '1';
         insert ListOfValue;
        CSS_QuickServe.getDataPlateDocSave(JO.id,JO.ESN__c,'UNLISTED','ALL',true);
         //CSS_QuickServe.getDataPlateDocSave_Existing(JO.id,JO.ESN__c);
        /* ============================== */
        CSS_QuickServe.qsolIntegrationError('testError');
        Test.stopTest();
    }
    
    static testMethod void qsol5(){
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());        
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());  
        JO = NEW CSS_Job_Order__c();
       // List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79664889';
        JO.Mileage_Measure__c='19';
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        CSS_getEngineDataReqJ2A enginereq = new CSS_getEngineDataReqJ2A();        
        CSS_getEngineDataReqJ2A.DataArea Req = new CSS_getEngineDataReqJ2A.DataArea();
        Req.ESN='79664889';
        enginereq.DataArea = Req;        
        Id contactRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName()
        .get('Guidanz').getRecordTypeId();
        CSS_getEngineDataResponseJ2A engineData = new CSS_getEngineDataResponseJ2A(); 
        
         Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Guidanz').getRecordTypeId();
        
        account a = new account();
        a.name = 'Testing';
        a.ACCOUNT_STATUS__c = 'true';
        a.RecordtypeId = recordTypeId;
        insert a;
        
        contact con = new contact();
        con.FirstName='Test2';
        con.Lastname = 'krishna';
        con.AccountId = a.Id;
        con.RecordtypeId    =contactRecId;
        insert con;
        
        Asset lstAsset = new Asset();
        lstAsset.Name = 'krish';
        lstAsset.AccountId = a.id;
        lstAsset.ContactId = con.id;
        lstAsset.type__c = 'Products';
        lstAsset.SerialNumber = '79664889';
        lstAsset.Automotive_Application_Flag__c = 'N';
        lstAsset.Model__c = 'krishna';
        lstAsset.ETO_Conversion_Date__c = date.today();
        lstAsset.Marine_Application_Flag__c = 'N';
        lstAsset.Engine_Bill_To_Code__c = 'krishna';
        lstAsset.Equipment_Id__c = 'krishna';
        lstAsset.Customer_Name__c = 'krishna';
        lstAsset.Build_Date__c = date.today();
        lstAsset.Make__c = 'asdasd'; // Correct?
        lstAsset.Engine_Family_Code__c= 'krishna';
        lstAsset.Warranty_Start_Date__c= date.today();
        lstAsset.Product_Application_Code__c= 'KR';
        lstAsset.Service_Model__c= 'krishna';
        lstAsset.Access_Code__c= 'krishna';
        lstAsset.Product_Application_Description__c= 'krishna';
        lstAsset.VIN__c= 'krishna';
        lstAsset.Equipment_Configuration__c= 'krishna';
        lstAsset.No_Warranty__c = true;
        lstAsset.Critical_Part_List_Number__c= 'krishna';
        lstAsset.OEM_SP_Code__c= 'krishna';
        lstAsset.Design_Phase_Code__c= 'krishna';
        lstAsset.Equipment_Configuration__c= 'krishna';
        lstAsset.Paccar_Flag__c = true;
        lstAsset.Engine_Family_Name__c= 'krishna';
        lstAsset.Ship_Date__c = date.today();
        lstAsset.ETO_Old_PSN__c = '352523552';
        lstAsset.Type_PSN__c='Engines-79664889';
        insert lstAsset;
        
        Test.startTest();  
        engineData = CSS_WS_SBL.getEngineData(enginereq);
        //engineData = CSS_WS_SBL.getEngineData(null);
        //CSS_QuickServe.getDataPlateDocSave_Existing(JO.id,JO.ESN__c); //not in use method
        Date Mydate = CSS_QuickServe.parseQSOLDate('15-1-2005');
         CSS_QuickServe.getDataPlateDocSave(JO.id,'79664889','UNLISTED','ALL',true);
         CSS_List_Of_Values__c ListOfValue = new CSS_List_Of_Values__c();
         ListOfValue.Code__c = '130';
         ListOfValue.Picklist_Values_1__c = 'AUTOMOTIVE';
         ListOfValue.Picklist_Values_2__c = 'AUTOMOTIVE';
         ListOfValue.Picklist_Values_3__c = 'AUTOMOTIVE';
         ListOfValue.Type__c = 'Application Code';
         ListOfValue.Name = '1';
         insert ListOfValue;
         //CSS_QuickServe.getDataPlateDocSave(JO.id,JO.ESN__c,'UNLISTED','ALL',TRUE);
       
        CSS_QuickServe.qsolIntegrationError('testError');
        Test.stopTest();
    }
    
    static testMethod void fslAsset(){
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());  
        JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79384192';
        JO.Mileage_Measure__c='19';
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        
        try{
            Asset assetObj = new Asset();
            assetObj.Name = '79384192';
            assetObj.Automotive_Application_Flag__c = 'Y';
            assetObj.Model__c = 'True';
            assetObj.SerialNumber = '79384192';
            assetObj.ETO_Conversion_Date__c = null;
            assetObj.Marine_Application_Flag__c = 'Y';
            assetObj.Engine_Bill_To_Code__c = 'True';
            assetObj.Equipment_Id__c = 'True';
            assetObj.Customer_Name__c = 'True';
            assetObj.Build_Date__c = null;
            assetObj.Make__c = 'True';
            assetObj.Engine_Family_Code__c = 'True';
            assetObj.Warranty_Start_Date__c = null;
            assetObj.Product_Application_Code__c = '10';
            assetObj.Service_Model__c = 'True';
            assetObj.Access_Code__c = 'True';
            assetObj.Product_Application_Description__c = 'True';
            //assetObj.EngineAppDesc = '';
            assetObj.VIN__c = 'True';
            assetObj.Equipment_Configuration__c = 'True';
            assetObj.No_Warranty__c = True;
            assetObj.Critical_Part_List_Number__c = 'True';
            assetObj.OEM_SP_Code__c = 'True';
            assetObj.Design_Phase_Code__c = 'True';
            assetObj.Equipment_Configuration__c = 'True';
            assetObj.Paccar_Flag__c = True;
            assetObj.Engine_Family_Name__c = 'True';
            assetObj.Ship_Date__c = null;
            assetObj.ETO_Old_PSN__c = '79424242';
            assetObj.ETO_Old_PSN__c = '79424242';
            insert assetObj;
         }catch(Exception e){
             system.debug('in catch in asset>:'+e.getMessage()+' LineNo:'+e.getLineNumber());
         }
        
        Test.startTest(); 
        
        CSS_getEngineDataReqJ2A enginereq = new CSS_getEngineDataReqJ2A();        
        CSS_getEngineDataReqJ2A.DataArea Req = new CSS_getEngineDataReqJ2A.DataArea();
        Req.ESN='79384192';
        enginereq.DataArea = Req; 
        
        CSS_getEngineDataResponseJ2A engineData = new CSS_getEngineDataResponseJ2A(); 
        CSS_getEngineDataResponseJ2A mn = new CSS_getEngineDataResponseJ2A(); //GSSC_97, ROD:Qsol changes
        mn = CG_BL_Intake.GetEngineDataPlateQSOL('79384192');
        
        engineData = CSS_WS_SBL.getEngineData(enginereq);
        //engineData = CSS_WS_SBL.getEngineData(null);
        CSS_QuickServe.getDataPlateDocSave(JO.id,JO.ESN__c,JO.Make__c,JO.Model__c,JO.PSN_Not_Available__c);
        CSS_List_Of_Values__c ListOfValue = new CSS_List_Of_Values__c();
         ListOfValue.Code__c = '130';
         ListOfValue.Picklist_Values_1__c = 'AUTOMOTIVE';
         ListOfValue.Picklist_Values_2__c = 'AUTOMOTIVE';
         ListOfValue.Picklist_Values_3__c = 'AUTOMOTIVE';
         ListOfValue.Type__c = 'Application Code';
         ListOfValue.Name = '1'; 
         insert ListOfValue;
        CSS_QuickServe.getDataPlateDocSave(JO.id,JO.ESN__c,'UNLISTED','ALL',TRUE);
        CSS_QuickServe.qsolIntegrationError('testError');
        Test.stopTest();
    }
    
    static testMethod void tsbsDoc(){
        JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        //List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        CSS_QuickServe.getQsolDocSave_Existing(jo.id,jo.ESN__c,'en');
        CSS_QuickServe.getQsolDocSaveforClaims_Existing(jo.id,jo.ESN__c,'en');
        map<Id,String> map1= new map<Id,String>();
        map1.put(jo.id,'anb');
        map1.put(jo.id,'abc');
        CSS_Claims__c claim1=new CSS_Claims__c();
        claim1.CSS_Job__c=JO.id;
        insert claim1;
        Test.startTest();
       //CSS_QuickServe.getJobOptions_Existing(map1,True); //not used this method
        test.stopTest();
        // System.assertEquals('TSB070007', docNumber);
    }
    
     static testMethod void tsbsDocs(){
        JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        CSS_Job_Order__c JO1 = NEW CSS_Job_Order__c();
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.ESN__c = '79464646';
        JO1.Mileage_Measure__c='19';
        JO1.Qsol_Engine_Family_Code__c='IN';
        insert JO1;
        
        //List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        /*Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        CSS_QuickServe.getQsolDocSave(jo.id,jo.ESN__c,'en');
        CSS_QuickServe.getQsolDocSaveforClaims(jo.id,jo.ESN__c,'en');*/
       
         list<CSS_Claims__c> claimlist=new list<CSS_Claims__c>();
        CSS_Claims__c claim1=new CSS_Claims__c();
         //claim1.id=jo.id;
        claim1.CSS_Job__c=JO.id;
        insert claim1;
         CSS_Claims__c claim2=new CSS_Claims__c();
         //claim1.id=jo.id;
        claim2.CSS_Job__c=JO1.id;
        insert claim2;
         claimlist.add(claim1);
         claimlist.add(claim2);
          map<Id,String> map1= new map<Id,String>();
        map1.put(claim1.id,'79464646');
        map1.put(claim2.id,'79464646');
        
        
         
        Test.setMock(HttpCalloutMock.class, new CG_J2AQsolTokenMock()); 
        
         CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
         cid.name = 'GetOptionsforQsolREST';
         cid.ApplicationName__c = 'GetOptionsforQsolREST';
         cid.End_Point__c = 'https://qs-stg.cummins.com/integrationservices/api/catalog/optionlist?serialNumber=';
         cid.logging__c = 'BOTH';
         cid.AuthEnv__c = 'QsolToken';
         cid.Method_Type__c = 'GET';
         cid.Timeout__c = 12000;
         insert cid;
         
        Test.setMock(HttpCalloutMock.class, new CG_J2AQsolTokenMock1());
         
        Test.startTest();
       CSS_QuickServe.getJobOptions(map1,True);
         //CSS_QuickServe.getJobOptions(map1,false);
        test.stopTest();
        // System.assertEquals('TSB070007', docNumber);
    }
    
    static testMethod void getJobOptionsTest(){
        JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        CSS_Job_Order__c JO1 = NEW CSS_Job_Order__c();
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.ESN__c = '79464646';
        JO1.Mileage_Measure__c='19';
        JO1.Qsol_Engine_Family_Code__c='IN';
        insert JO1;

         list<CSS_Claims__c> claimlist=new list<CSS_Claims__c>();
        CSS_Claims__c claim1=new CSS_Claims__c();
         //claim1.id=jo.id;
        claim1.CSS_Job__c=JO.id;
        insert claim1;
         CSS_Claims__c claim2=new CSS_Claims__c();
         //claim1.id=jo.id;
        claim2.CSS_Job__c=JO1.id;
        insert claim2;
         claimlist.add(claim1);
         claimlist.add(claim2);
          map<Id,String> map1= new map<Id,String>();
        map1.put(claim1.id,'79464646');
        map1.put(claim2.id,'79464646');
         
        Test.setMock(HttpCalloutMock.class, new CG_J2AQsolTokenMock()); 
        
        CSS_Integration_Details__c cidToken = CSS_TestData.createIntegrationDetails(false);
         cidToken.name = 'QsolToken';
         cidToken.ApplicationName__c = 'QsolToken';
         cidToken.End_Point__c = 'https://qs-stg.cummins.com/integrationservices/token/generate';
         cidToken.logging__c = 'BOTH';
         cidToken.AuthEnv__c = '';
         cidToken.Method_Type__c = 'POST';
         cidToken.Timeout__c = 12000;
         insert cidToken;
        
         CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
         cid.name = 'GetOptionsforQsolREST';
         cid.ApplicationName__c = 'GetOptionsforQsolREST';
         cid.End_Point__c = 'https://qs-stg.cummins.com/integrationservices/api/catalog/optionlist?serialNumber=';
         cid.logging__c = 'BOTH';
         cid.AuthEnv__c = 'QsolToken';
         cid.Method_Type__c = 'GET';
         cid.Timeout__c = 12000;
         insert cid;
         
        Test.setMock(HttpCalloutMock.class, new CG_J2AQsolTokenMock1());
         
        Test.startTest();
       CSS_QuickServe.getJobOptions(map1,True);
         //CSS_QuickServe.getJobOptions(map1,false);
        test.stopTest();
        // System.assertEquals('TSB070007', docNumber);
    }
    
    
    static testMethod void insertDocs(){
        // CSS_QuickServe.insertFaultsDetails();
    }
    static testMethod void linkMgmt_Existing(){
        JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79462241';
        JO.Mileage_Measure__c='19';
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        //List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        Test.startTest();
        Test.setMock(WebServiceMock.class, new CSS_LinkMgmt_Test());
        CSS_QuickServe.linkMgmt_Existing('en','Pro|','019-019|',JO.id);
        CSS_QuickServe.linkMgmt('en','jsonfile','019-019',JO.id);
        Test.stopTest();
        // System.assertEquals('TSB070007', docNumber);
    }
    static testMethod void linkMgmt(){
        JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79462241';
        JO.Mileage_Measure__c='19';
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        //List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        Test.startTest();
        Test.setMock(WebServiceMock.class, new CSS_LinkMgmt_Test());
        CSS_QuickServe.linkMgmt('en','Pro','019-019',JO.id);
        CSS_QuickServe.linkMgmt('en','jsonfile','019-019',JO.id);
        Test.stopTest();
        // System.assertEquals('TSB070007', docNumber);
    }
    static testMethod void Options(){
        JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79462241';
        JO.Mileage_Measure__c='19';
        insert JO;
        JO1 = NEW CSS_Job_Order__c();
        JO1.Customer_Name__c = 'CumminsTnDsdas';
        JO1.ESN__c = '794621231';
        JO1.Mileage_Measure__c='19';
        JO1.Qsol_Engine_Family_Code__c='IN';
        insert JO1;
       // List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        Map<Id,String> joMap = new Map<Id,String>();
        joMap.put(JO1.Id, JO1.ESN__c);
        Test.setMock(WebServiceMock.class, new CSS_GetQSOLOptions_Test());
        //CSS_QuickServe.getJobOptions(joMap);
        // System.assertEquals('TSB070007', docNumber);
    }
    static testMethod void getQsolDocSaveLang_Existing(){
        JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
       List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
           Test.startTest();
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        CSS_QuickServe.getQsolDocSaveLang_Existing(jo.id,jo.ESN__c,'en');
        test.stopTest();
        // System.assertEquals('TSB070007', docNumber);
    }
     static testMethod void getQsolDocSaveLang(){
        JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        Test.startTest();
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        CSS_QuickServe.getQsolDocSaveLang(jo.id,jo.ESN__c,'en');
        test.stopTest();
        
    }
    static testMethod void engineDataSiebel(){
        CSS_getEngineDataReqJ2A enginereq = new CSS_getEngineDataReqJ2A();        
        CSS_getEngineDataReqJ2A.DataArea Req = new CSS_getEngineDataReqJ2A.DataArea();
        Req.ESN='79384192';
        //List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        enginereq.DataArea = Req;        
        CSS_getEngineDataResponseJ2A engineresp = new CSS_getEngineDataResponseJ2A(); 
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());       
        engineresp = CSS_WS_SBL.getEngineData(enginereq);
        //engineresp = CSS_WS_SBL.getEngineData(null);
        test.stopTest();
    }
    static testMethod void catchblock(){
        //CSS_QuickServe.getFaultCodeOverview_Existing(null,null); //not in use method
        CSS_QuickServe.getDataPlateDocSave(null,null,null,null,null);
        CSS_QuickServe.getQsolDocSave_Existing(null,null,null);
        CSS_QuickServe.getQsolDocSave(null,null,null);
        CSS_QuickServe.getQsolDocSaveforClaims(null,null,null);
        CSS_QuickServe.linkMgmt_Existing(null,null,null,null);
        CSS_QuickServe.getQsolDocSaveLang(null,null,null);
        CSS_QuickServe.getQsolDocSaveLang_Existing(null,null,null);
    }
    @testsetup
    static void testdata(){
        test.startTest();
        list<CSS_Integration_Details__c> recs= new list<CSS_Integration_Details__c>();
        CSS_Integration_Details__c condetails = new CSS_Integration_Details__c();
        condetails.name='QSOL Auth Token';
        condetails.ApplicationName__c='QSOL Soft';
        condetails.AuthEnv__c='QSOL Auth Tokens';
        condetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
        condetails.grant_type__c='Refresh_full';
        condetails.IsActive__c=true;
        condetails.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL172LYrK6URZB3zKLO45503MD61NA8STQCRvGn7Qroo3CkG7RRlFe9Bw==';
        condetails.Logging__c='BOTH';
        condetails.Method_Type__c='POST';
        condetails.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL172LYrK6URZB3zKLO45503MD61NA8LSTQCRvGn7Qroo3CkG7RRlFe9Bw==';
        condetails.Timeout__c=120;
        condetails.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO5QlGuxTVNg/ly+0Sy1nWe57U01ngfRWq9ogg3q6LfncwdAZmBg==';
        recs.add(condetails);
        CSS_Integration_Details__c condetails1 = new CSS_Integration_Details__c();
        condetails1.name='GetWattantyDocsforQsolREST';
        condetails1.ApplicationName__c='QSOL Soft';
        condetails1.AuthEnv__c='QSOL Auth Token';
        condetails1.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data';
        condetails1.grant_type__c='Refresh_full';
        condetails1.IsActive__c=true;
        condetails1.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails1.Logging__c='BOTH';
        condetails1.Method_Type__c='POST';
        condetails1.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails1.Timeout__c=120;
        condetails1.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails1);
        CSS_Integration_Details__c condetails2 = new CSS_Integration_Details__c();
        condetails2.name='GetLinkMgmtQsolREST';
        condetails2.ApplicationName__c='QSOL Soft';
        condetails2.AuthEnv__c='QSOL Auth Token';
        condetails2.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data';
        condetails2.grant_type__c='Refresh_full';
        condetails2.IsActive__c=true;
        condetails2.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails2.Logging__c='BOTH';
        condetails2.Method_Type__c='POST';
        condetails2.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails2.Timeout__c=120;
        condetails2.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails2);
        CSS_Integration_Details__c condetails3 = new CSS_Integration_Details__c();
        condetails3.name='GetOptionsforQsolREST';
        condetails3.ApplicationName__c='QSOL Soft';
        condetails3.AuthEnv__c='QSOL Auth Token';
        condetails3.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data';
        condetails3.grant_type__c='Refresh_full';
        condetails3.IsActive__c=true;
        condetails3.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails3.Logging__c='BOTH';
        condetails3.Method_Type__c='POST';
        condetails3.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails3.Timeout__c=120;
        condetails3.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails3);
        CSS_Integration_Details__c condetails5 = new CSS_Integration_Details__c();
        condetails5.name='GetFaultCodeOverviewQsolREST';
        condetails5.ApplicationName__c='QSOL Soft';
        condetails5.AuthEnv__c='QSOL Auth Token';
        condetails5.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data';
        condetails5.grant_type__c='Refresh_full';
        condetails5.IsActive__c=true;
        condetails5.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails5.Logging__c='BOTH';
        condetails5.Method_Type__c='POST';
        condetails5.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails5.Timeout__c=120;
        condetails5.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails5);
        insert recs; 
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79664889';
        JO.Mileage_Measure__c='19';
        JO.Qsol_Business_Unit__c='1234';
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        CSS_Claims__c claim1=new CSS_Claims__c();
        claim1.CSS_Job__c=JO.id;
        insert claim1;
        
        asset ac= new asset();
        ac.Name='testasset';
        ac.SerialNumber='79664889';
        test.stopTest();
    }
    static testMethod void CssQuickService(){
        string json ='{"apiToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw","ResponseCode":"200"}';
        string json1  ='[{ "documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"TSB","language":"en","status":"OPEN","documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html"}, { "documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"TRP","language":"en","status":"OPEN","documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html"},{ "documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"ATC","language":"en","status":"OPEN","documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html"},{"documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"CAMPAIGN","language":"en","status":"OPEN", "documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html" }]';
        CG_CL_HttpRequestMock mock3 = new CG_CL_HttpRequestMock(202,'Complete',json1,null);
        String getoptionjson = '['+
            '    {'+
            '        \"optionNumber\": \"PE1027-05\",'+
            '        \"optionDescription\": \"Aftertreatment Device\",'+
            '        \"repairGroup\": \"11.01.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PE1715-03\",'+
            '        \"optionDescription\": \"DOSER,FLUID\",'+
            '        \"repairGroup\": \"11.01.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PE1715-01\",'+
            '        \"optionDescription\": \"Fluid Doser\",'+
            '        \"repairGroup\": \"11.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"CP1183-03\",'+
            '        \"optionDescription\": \"Air Compressor\",'+
            '        \"repairGroup\": \"12.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"ER1014-07\",'+
            '        \"optionDescription\": \"Exhaust Recirculation\",'+
            '        \"repairGroup\": \"11.01.1\"'+
            '    },'+
           '    {'+
            '        \"optionNumber\": \"IC1112-01\",'+
            '        \"optionDescription\": \"CONNECTION,AIR INTAKE\",'+
            '        \"repairGroup\": \"10.01.2\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"IM1837\",'+
            '        \"optionDescription\": \"Air Intake Manifold\",'+
            '        \"repairGroup\": \"10.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"IT1033-01\",'+
            '        \"optionDescription\": \"Air Transfer Connection\",'+
            '        \"repairGroup\": \"10.01.2\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10321\",'+
            '        \"optionDescription\": \"Turbocharger\",'+
            '        \"repairGroup\": \"10.05\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10357\",'+
            '        \"optionDescription\": \"NOZZLE, PISTON COOLING\",'+
            '        \"repairGroup\": \"01.01.2\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10357\",'+
            '        \"optionDescription\": \"PISTON, CONN ROD AND\",'+
            '        \"repairGroup\": \"01.04\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10359\",'+
            '        \"optionDescription\": \"Cylinder Head\",'+
            '        \"repairGroup\": \"02.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10360\",'+
            '        \"optionDescription\": \"Injector\",'+
            '        \"repairGroup\": \"06.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"TB1469-02\",'+
            '        \"optionDescription\": \"ARRANGEMENT,TURBOCHARGER\",'+
            '        \"repairGroup\": \"10.06.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"TP1813-02\",'+
            '        \"optionDescription\": \"PLUMBING,TURBOCHARGER\",'+
            '        \"repairGroup\": \"10.06.2\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"BB1909\",'+
            '        \"optionDescription\": \"BLOCK,CYLINDER\",'+
            '        \"repairGroup\": \"01.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"BB1909\",'+
            '        \"optionDescription\": \"Crankshaft\",'+
            '        \"repairGroup\": \"01.02\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"BB1909\",'+
            '        \"optionDescription\": \"Cus Accessory Brace\",'+
            '        \"repairGroup\": \"16.04.2\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"BB1909\",'+
            '        \"optionDescription\": \"Cylinder Liner Kit\",'+
            '        \"repairGroup\": \"01.01.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"BB1909\",'+
            '        \"optionDescription\": \"Gear Housing Brace\",'+
            '        \"repairGroup\": \"01.09.2\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"BB1909\",'+
            '        \"optionDescription\": \"Gear Housing Sensor Adapter\",'+
            '        \"repairGroup\": \"01.09.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"BB1909\",'+
            '        \"optionDescription\": \"Gear Housing/Idler Gears\",'+
            '        \"repairGroup\": \"01.09\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"EB1207\",'+
            '        \"optionDescription\": \"Engine Brake\",'+
            '        \"repairGroup\": \"03.04\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"HC1004\",'+
            '        \"optionDescription\": \"Cabin Heater Plumbing\",'+
            '        \"repairGroup\": \"08.13.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10321\",'+
            '        \"optionDescription\": \"Turbocharger\",'+
            '        \"repairGroup\": \"10.05\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10342\",'+
            '        \"optionDescription\": \"CAMSHAFT\",'+
            '        \"repairGroup\": \"01.07\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10357\",'+
            '        \"optionDescription\": \"NOZZLE, PISTON COOLING\",'+
            '        \"repairGroup\": \"01.01.2\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10357\",'+
            '        \"optionDescription\": \"PISTON, CONN ROD AND\",'+
            '        \"repairGroup\": \"01.04\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10359\",'+
            '        \"optionDescription\": \"Cylinder Head\",'+
            '        \"repairGroup\": \"02.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10360\",'+
            '        \"optionDescription\": \"Injector\",'+
            '        \"repairGroup\": \"06.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"RL1754-03\",'+
            '        \"optionDescription\": \"LEVER,ROCKER\",'+
            '        \"repairGroup\": \"03.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"VC1088\",'+
            '        \"optionDescription\": \"ARRANGEMENT,VALVE COVER\",'+
            '        \"repairGroup\": \"03.01.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"CI1725-01\",'+
            '        \"optionDescription\": \"Air Cpr Inlet Arrangement\",'+
            '        \"repairGroup\": \"12.01.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"CP1183-03\",'+
            '        \"optionDescription\": \"Air Compressor\",'+
            '        \"repairGroup\": \"12.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"WP1744-03\",'+
            '        \"optionDescription\": \"PUMP,WATER\",'+
            '        \"repairGroup\": \"08.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"FH11059-12\",'+
            '        \"optionDescription\": \"Flywheel Housing\",'+
            '        \"repairGroup\": \"16.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"WR1717-01\",'+
           '        \"optionDescription\": \"Wiring Accessories\",'+
            '        \"repairGroup\": \"21.02\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"CH1021-02\",'+
            '        \"optionDescription\": \"AID,COO HEATER STARTING\",'+
            '        \"repairGroup\": \"10.02\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"CP1183-03\",'+
            '        \"optionDescription\": \"Air Compressor\",'+
            '        \"repairGroup\": \"12.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"EC1726-04\",'+
            '        \"optionDescription\": \"THERMOSTAT\",'+
            '        \"repairGroup\": \"08.07\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"HC1004\",'+
            '        \"optionDescription\": \"Cabin Heater Plumbing\",'+
            '        \"repairGroup\": \"08.13.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"IM1837\",'+
            '        \"optionDescription\": \"Air Intake Manifold\",'+
            '        \"repairGroup\": \"10.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"TH1217\",'+
            '        \"optionDescription\": \"ARRANGEMENT,THM HOUSING\",'+
            '        \"repairGroup\": \"08.07\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"TH1711\",'+
            '        \"optionDescription\": \"HOUSING,THERMOSTAT\",'+
            '        \"repairGroup\": \"08.07\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"TP1813-02\",'+
            '        \"optionDescription\": \"PLUMBING,TURBOCHARGER\",'+
            '        \"repairGroup\": \"10.06.2\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"WF1242-02\",'+
            '        \"optionDescription\": \"RESISTOR,CORROSION\",'+
            '        \"repairGroup\": \"08.08\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"WI1118\",'+
            '        \"optionDescription\": \"CONNECTION,WATER INLET\",'+
            '        \"repairGroup\": \"08.07.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"WO1126-02\",'+
            '        \"optionDescription\": \"CONNECTION,WATER OUTLET\",'+
            '        \"repairGroup\": \"08.07.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"WP1744-03\",'+
            '        \"optionDescription\": \"PUMP,WATER\",'+
            '        \"repairGroup\": \"08.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"CF1072\",'+
            '        \"optionDescription\": \"Ref Compressor Mounting\",'+
            '        \"repairGroup\": \"12.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"DA1237-03\",'+
            '        \"optionDescription\": \"Vibration Damper\",'+
            '        \"repairGroup\": \"01.02.2\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"EH1120-02\",'+
            '        \"optionDescription\": \"Alternator Mounting\",'+
            '        \"repairGroup\": \"13.02.3\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"EM1355-01\",'+
            '        \"optionDescription\": \"Front Engine Support\",'+
            '        \"repairGroup\": \"16.03\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"FA1511-01\",'+
            '        \"optionDescription\": \"DRIVE,FAN\",'+
            '        \"repairGroup\": \"08.03\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"FH11059-12\",'+
            '        \"optionDescription\": \"Flywheel Housing\",'+
            '        \"repairGroup\": \"16.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"FW1020-06\",'+
            '        \"optionDescription\": \"Flywheel\",'+
            '        \"repairGroup\": \"16.02\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"FW1701\",'+
            '        \"optionDescription\": \"MOUNTING,FLYWHEEL\",'+
            '        \"repairGroup\": \"16.02.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"GG1749-01\",'+
            '        \"optionDescription\": \"COVER,FRONT GEAR\",'+
            '        \"repairGroup\": \"01.06\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"LA1718-02\",'+
            '        \"optionDescription\": \"Lifting Bracket Mounting\",'+
            '        \"repairGroup\": \"17.06\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10321\",'+
            '        \"optionDescription\": \"Turbocharger\",'+
            '        \"repairGroup\": \"10.05\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10357\",'+
            '        \"optionDescription\": \"NOZZLE, PISTON COOLING\",'+
            '        \"repairGroup\": \"01.01.2\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10357\",'+
            '        \"optionDescription\": \"PISTON, CONN ROD AND\",'+
            '        \"repairGroup\": \"01.04\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10359\",'+
            '        \"optionDescription\": \"Cylinder Head\",'+
            '        \"repairGroup\": \"02.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10360\",'+
            '        \"optionDescription\": \"Injector\",'+
            '        \"repairGroup\": \"06.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"SM1732-02\",'+
            '        \"optionDescription\": \"MOUNTING,STARTING MOTOR\",'+
            '        \"repairGroup\": \"13.05.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"WR1717-01\",'+
            '        \"optionDescription\": \"Wiring Accessories\",'+
            '        \"repairGroup\": \"21.02\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"CH1021-02\",'+
            '        \"optionDescription\": \"AID,COO HEATER STARTING\",'+
            '        \"repairGroup\": \"10.02\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PH1818-09\",'+
            '        \"optionDescription\": \"Engine Control Module\",'+
            '        \"repairGroup\": \"05.06.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PH1826-01\",'+
            '        \"optionDescription\": \"Eng Cnt Module Plumbing\",'+
            '        \"repairGroup\": \"05.06.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"SV1001\",'+
            '        \"optionDescription\": \"Engine Operating Voltage\",'+
            '        \"repairGroup\": \"13.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"WR1717-01\",'+
            '        \"optionDescription\": \"Wiring Accessories\",'+
            '        \"repairGroup\": \"21.02\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"DL1068\",'+
            '        \"optionDescription\": \"LOCATION, DRAIN\",'+
            '        \"repairGroup\": \"06.07\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"FD1706\",'+
            '        \"optionDescription\": \"Fuel Drain Plumbing\",'+
            '        \"repairGroup\": \"17.05\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"FF1308\",'+
            '        \"optionDescription\": \"FILTER,FUEL\",'+
            '        \"repairGroup\": \"06.04\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"FP10278\",'+
            '        \"optionDescription\": \"PUMP, FUEL\",'+
            '        \"repairGroup\": \"05.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"FS1732\",'+
            '        \"optionDescription\": \"Fuel System Primer\",'+
            '        \"repairGroup\": \"05.19\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"PP10323-03\",'+
            '        \"optionDescription\": \"PLUMBING,INJECTOR\",'+
            '        \"repairGroup\": \"06.01.2\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"BR1296\",'+
            '        \"optionDescription\": \"BREATHER,CRANKCASE\",'+
            '        \"repairGroup\": \"03.02\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"LC1751-01\",'+
            '        \"optionDescription\": \"COOLER,ENGINE OIL\",'+
            '        \"repairGroup\": \"07.05\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"LF1232-03\",'+
            '        \"optionDescription\": \"FILTER,FULL FLOW OIL\",'+
            '        \"repairGroup\": \"07.03\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"LG1148-04\",'+
            '        \"optionDescription\": \"GAUGE,OIL LEVEL\",'+
            '        \"repairGroup\": \"07.02\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"LP1729-03\",'+
            '        \"optionDescription\": \"PUMP,LUBRICATING OIL\",'+
            '        \"repairGroup\": \"07.06\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"OB1443-02\",'+
            '        \"optionDescription\": \"ARRANGEMENT,OIL FILL\",'+
            '        \"repairGroup\": \"07.02\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"TP1813-02\",'+
            '        \"optionDescription\": \"PLUMBING,TURBOCHARGER\",'+
            '        \"repairGroup\": \"10.06.2\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"DO1813\",'+
            '        \"optionDescription\": \"SOFTWARE,CUS INTERFACE\",'+
            '        \"repairGroup\": \"99.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"FCP846\",'+
            '        \"optionDescription\": \"CALIBRATION,FUEL PUMP\",'+
            '        \"repairGroup\": \"99.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"FR10993\",'+
            '        \"optionDescription\": \"RATING,FUEL\",'+
            '        \"repairGroup\": \"99.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"NN1735\",'+
            '        \"optionDescription\": \"Nameplate\",'+
            '        \"repairGroup\": \"01.06.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"SC12085\",'+
            '        \"optionDescription\": \"SOFTWARE,CALIBRATION\",'+
            '        \"repairGroup\": \"99.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"EB1207\",'+
            '        \"optionDescription\": \"Engine Brake\",'+
            '        \"repairGroup\": \"03.04\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"AP8122\",'+
            '        \"optionDescription\": \"Agency Approval\",'+
            '        \"repairGroup\": \"01.06.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"FA1511-01\",'+
            '        \"optionDescription\": \"Fan Drive\",'+
            '        \"repairGroup\": \"08.03\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"FW1701\",'+
            '        \"optionDescription\": \"FLYWHEEL MOUNTING\",'+
            '        \"repairGroup\": \"16.02.1\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"LA1112\",'+
            '        \"optionDescription\": \"ARRANGEMENT, LIFTING\",'+
            '        \"repairGroup\": \"17.06\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"OP1230\",'+
            '        \"optionDescription\": \"Oil Pan\",'+
            '        \"repairGroup\": \"07.01\"'+
            '    },'+
            '    {'+
            '        \"optionNumber\": \"SS1097-01\",'+
            '        \"optionDescription\": \"PAINT\",'+
            '        \"repairGroup\": \"03.01\"'+
            '    }'+
            ']';
        String enginejson = '{'+
            '    \"engineSerialNumber\": \"79462241\",'+
            '    \"data\": ['+
            '        {'+
            '            \"vin\": \"1NPTX4EX3CD137011\",'+
            '            \"marketingEngineModel\": \"ISX15 450\",'+
            '            \"serviceEngineModel\": \"ISX15 CM2250\",'+
            '            \"epaModelName\": \"BCEXH0912XAP\",'+
            '            \"engineBuildPlant\": \"JEP - JAMESTOWN ENGINE PLANT\",'+
            '            \"engineBuildDate\": \"2011-02-23T00:00:00Z\",'+
            '            \"warrantyStartDate\": \"2012-03-16T00:00:00Z\",'+
            '            \"ecmCode\": \"CL10135\",'+
            '            \"fuelPumpPartNumber\": \"4088507\",'+
            '            \"fuelPumpCalibration\": \"P846\",'+
            '            \"marketingConfig\": \"D103009BB09\",'+
            '            \"technicalConfig\": \"D103009BX03\",'+
            '            \"cplNumber\": \"CPL3719\",'+
            '            \"customerNumber\": \"1608\",'+
            '            \"shopOrder\": \"SO33045\",'+
            '            \"businessUnit\": \"EBU\"'+
            '        }'+
            '    ]'+
            '}';
        String faultcodejson = '{'+
            '    \"faultCode\": \"2636\",'+
            '    \"pid\": \"S27\",'+
            '    \"spn\": \"641\",'+
            '    \"fmi\": \"9\",'+
            '    \"lamp\": \"Red\",'+
            '    \"srt\": \"\",'+
            '    \"description\": \"VGT Actuator Driver Circuit - Abnormal Update Rate\",'+
            '    \"compLocation\": \"The VGT actuator is located on the turbocharger bearing housing.\",'+
            '    \"circuitDescription\": \"The variable geometry turbocharger (VGT) is electronically activated by the VGT actuator. The VGT actuator is a smart device and receives information via the J1939 data link from the primary engine control module (ECM). The VGT actuator performs its own diagnostics and reports malfunctions back to the primary engine ECM, using the J1939 data link. The ECM then decodes the error message and converts it to a fault code.\",'+
            '    \"reason\": \"VGT Actuator Driver Circuit - Abnormal Update Rate. No communications on the J1939 data link between the engine ECM and the smart VGT controller.\",'+
            '    \"effect\": \"Possible reduced engine performance.\",'+
            '    \"sysName\": \"\",'+
            '    \"url\": \"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/procedures/454/454-fc2636.html\",'+
            '    \"engine\": \"454\"'+
            '}';
        String linkjson = '{'+
            '    \"qsolLink\": \"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/procedures/145/145-fc1682.html\",'+
            '    \"language\": \"en\"'+
            '}';
        
        CG_CL_HttpRequestMock mock1 = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock mock2 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        CG_CL_HttpRequestMock linkmock = new CG_CL_HttpRequestMock(200,'Complete',linkjson,null);
        CG_CL_HttpRequestMock optionmock = new CG_CL_HttpRequestMock(200,'Complete',getoptionjson,null);
        CG_CL_HttpRequestMock enginemock = new CG_CL_HttpRequestMock(200,'Complete',enginejson,null);
        CG_CL_HttpRequestMock faultcodemock = new CG_CL_HttpRequestMock(200,'Complete',faultcodejson,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',mock1);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data',mock2);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=TSB&language=en',mock2);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=TRP&language=en',mock2);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=ATC&language=en',mock2);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=CAMPAIGN&language=en',mock2);
        
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889',enginemock);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&faultCode=',faultcodemock);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&faultCode=&businessUnit=1234&language=en&documentType=jsonfile&documentId=019-019',linkmock);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&businessUnit=1234&language=en&documentType=jsonfile&documentId=019-019',linkmock);
        
         HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        system.debug('select name from customSettingName__c'+[select name from CSS_Integration_Details__c]);
        system.debug('select name from customSettingName__c'+CSS_Integration_Details__c.getValues('GetWattantyDocsforQsolREST'));

        test.startTest();
        CSS_Job_Order__c JO = [select id from CSS_Job_Order__c limit 1 ];
        
        CSS_QuickServe.getQsolDocSave(JO.id,'79664889','en');
        CSS_Claims__c claim1=[select id from CSS_Claims__c limit 1 ];
        
        CSS_QuickServe.getQsolDocSaveforClaims(claim1.id,'79664889','en');
        CSS_QuickServe.linkMgmt('en','jsonfile','019-019',JO.id);
        CSS_QuickServe.getQsolDocSaveLang(JO.id,'79664889','en');
        map<Id,String> map1= new map<Id,String>();
        map1.put(claim1.id,'79664889');
        CSS_QuickServe.getJobOptions(map1,True);
        //CSS_QuickServe.getFaultCodeOverview('2636','79664889');
        endpointsResponse.clear();
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',mock1);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data',mock3);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=TSB&language=en',mock3);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=TRP&language=en',mock3);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=ATC&language=en',mock3);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=CAMPAIGN&language=en',mock3);
        
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889',enginemock);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&faultCode=2636',faultcodemock);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&faultCode=&businessUnit=1234&language=en&documentType=jsonfile&documentId=019-019',linkmock);
        
        HttpCalloutMock multiCalloutMock1 =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock1);
        CSS_QuickServe.getQsolDocSaveforClaims(claim1.id,'79664889','en');
        CSS_QuickServe.getQsolDocSaveforClaims(claim1.id,'79664889','en');
        CSS_QuickServe.linkMgmt('en','jsonfile','019-019',JO.id);
        CSS_QuickServe.getQsolDocSaveLang(JO.id,'79664889','en');
        CSS_QuickServe.getJobOptions(map1,false);
        //CSS_QuickServe.getFaultCodeOverview('2636','79664889');
        test.stopTest();
    }
    static testMethod void CG_SL_QSOLService(){
        string json ='{"apiToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2Fw","ResponseCode":"200"}';
        string json1  ='[{ "documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"TSB","language":"en","status":"OPEN","documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html"}, { "documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"TRP","language":"en","status":"OPEN","documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html"},{ "documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"ATC","language":"en","status":"OPEN","documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html"},{"documentNum":"ATC1943", "documentDesc":"ISX15 CM2350 FUEL PUMP TAPPET ATC FOR RYDER","type":"CAMPAIGN","language":"en","status":"OPEN", "documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/2019/atc1943.html" }]';
        CG_CL_HttpRequestMock mock3 = new CG_CL_HttpRequestMock(202,'Complete',json1,null);
        String getoptionjson = '[     {         "optionNumber": "PE1027-05",         "optionDescription": "Aftertreatment Device",         "repairGroup": "11.01.1"     },     {         "optionNumber": "PE1715-03",         "optionDescription": "DOSER,FLUID",         "repairGroup": "11.01.1"     },     {         "optionNumber": "PE1715-01",         "optionDescription": "Fluid Doser",         "repairGroup": "11.01"     },     {         "optionNumber": "CP1183-03",         "optionDescription": "Air Compressor",         "repairGroup": "12.01"     },     {         "optionNumber": "ER1014-07",         "optionDescription": "Exhaust Recirculation",         "repairGroup": "11.01.1"     },     {         "optionNumber": "IC1112-01",         "optionDescription": "CONNECTION,AIR INTAKE",         "repairGroup": "10.01.2"     },     {         "optionNumber": "IM1837",         "optionDescription": "Air Intake Manifold",         "repairGroup": "10.01"     },     {         "optionNumber": "IT1033-01",         "optionDescription": "Air Transfer Connection",         "repairGroup": "10.01.2"     },     {         "optionNumber": "PP10321",         "optionDescription": "Turbocharger",         "repairGroup": "10.05"     },     {         "optionNumber": "PP10357",         "optionDescription": "NOZZLE, PISTON COOLING",         "repairGroup": "01.01.2"     },     {         "optionNumber": "PP10357",         "optionDescription": "PISTON, CONN ROD AND",         "repairGroup": "01.04"     },     {         "optionNumber": "PP10359",         "optionDescription": "Cylinder Head",         "repairGroup": "02.01"     },     {         "optionNumber": "PP10360",         "optionDescription": "Injector",         "repairGroup": "06.01"     },     {         "optionNumber": "TB1469-02",         "optionDescription": "ARRANGEMENT,TURBOCHARGER",         "repairGroup": "10.06.1"     },     {         "optionNumber": "TP1813-02",         "optionDescription": "PLUMBING,TURBOCHARGER",         "repairGroup": "10.06.2"     },     {         "optionNumber": "BB1909",         "optionDescription": "BLOCK,CYLINDER",         "repairGroup": "01.01"     },     {         "optionNumber": "BB1909",         "optionDescription": "Crankshaft",         "repairGroup": "01.02"     },     {         "optionNumber": "BB1909",         "optionDescription": "Cus Accessory Brace",         "repairGroup": "16.04.2"     },     {         "optionNumber": "BB1909",         "optionDescription": "Cylinder Liner Kit",         "repairGroup": "01.01.1"     },     {         "optionNumber": "BB1909",         "optionDescription": "Gear Housing Brace",         "repairGroup": "01.09.2"     },     {         "optionNumber": "BB1909",         "optionDescription": "Gear Housing Sensor Adapter",         "repairGroup": "01.09.1"     },     {         "optionNumber": "BB1909",         "optionDescription": "Gear Housing/Idler Gears",         "repairGroup": "01.09"     },     {         "optionNumber": "EB1207",         "optionDescription": "Engine Brake",         "repairGroup": "03.04"     },     {         "optionNumber": "HC1004",         "optionDescription": "Cabin Heater Plumbing",         "repairGroup": "08.13.1"     },     {         "optionNumber": "PP10321",         "optionDescription": "Turbocharger",         "repairGroup": "10.05"     },     {         "optionNumber": "PP10342",         "optionDescription": "CAMSHAFT",         "repairGroup": "01.07"     },     {         "optionNumber": "PP10357",         "optionDescription": "NOZZLE, PISTON COOLING",         "repairGroup": "01.01.2"     },     {         "optionNumber": "PP10357",         "optionDescription": "PISTON, CONN ROD AND",         "repairGroup": "01.04"     },     {         "optionNumber": "PP10359",         "optionDescription": "Cylinder Head",         "repairGroup": "02.01"     },     {         "optionNumber": "PP10360",         "optionDescription": "Injector",         "repairGroup": "06.01"     },     {         "optionNumber": "RL1754-03",         "optionDescription": "LEVER,ROCKER",         "repairGroup": "03.01"     },     {         "optionNumber": "VC1088",         "optionDescription": "ARRANGEMENT,VALVE COVER",         "repairGroup": "03.01.1"     },     {         "optionNumber": "CI1725-01",         "optionDescription": "Air Cpr Inlet Arrangement",         "repairGroup": "12.01.1"     },     {         "optionNumber": "CP1183-03",         "optionDescription": "Air Compressor",         "repairGroup": "12.01"     },     {         "optionNumber": "WP1744-03",         "optionDescription": "PUMP,WATER",         "repairGroup": "08.01"     },     {         "optionNumber": "FH11059-12",         "optionDescription": "Flywheel Housing",         "repairGroup": "16.01"     },     {         "optionNumber": "WR1717-01",         "optionDescription": "Wiring Accessories",         "repairGroup": "21.02"     },     {         "optionNumber": "CH1021-02",         "optionDescription": "AID,COO HEATER STARTING",         "repairGroup": "10.02"     },     {         "optionNumber": "CP1183-03",         "optionDescription": "Air Compressor",         "repairGroup": "12.01"     },     {         "optionNumber": "EC1726-04",         "optionDescription": "THERMOSTAT",         "repairGroup": "08.07"     },     {         "optionNumber": "HC1004",         "optionDescription": "Cabin Heater Plumbing",         "repairGroup": "08.13.1"     },     {         "optionNumber": "IM1837",         "optionDescription": "Air Intake Manifold",         "repairGroup": "10.01"     },     {         "optionNumber": "TH1217",         "optionDescription": "ARRANGEMENT,THM HOUSING",         "repairGroup": "08.07"     },     {         "optionNumber": "TH1711",         "optionDescription": "HOUSING,THERMOSTAT",         "repairGroup": "08.07"     },     {         "optionNumber": "TP1813-02",         "optionDescription": "PLUMBING,TURBOCHARGER",         "repairGroup": "10.06.2"     },     {         "optionNumber": "WF1242-02",         "optionDescription": "RESISTOR,CORROSION",         "repairGroup": "08.08"     },     {         "optionNumber": "WI1118",         "optionDescription": "CONNECTION,WATER INLET",         "repairGroup": "08.07.1"     },     {         "optionNumber": "WO1126-02",         "optionDescription": "CONNECTION,WATER OUTLET",         "repairGroup": "08.07.1"     },     {         "optionNumber": "WP1744-03",         "optionDescription": "PUMP,WATER",         "repairGroup": "08.01"     },     {         "optionNumber": "CF1072",         "optionDescription": "Ref Compressor Mounting",         "repairGroup": "12.01"     },     {         "optionNumber": "DA1237-03",         "optionDescription": "Vibration Damper",         "repairGroup": "01.02.2"     },     {         "optionNumber": "EH1120-02",         "optionDescription": "Alternator Mounting",         "repairGroup": "13.02.3"     },     {         "optionNumber": "EM1355-01",         "optionDescription": "Front Engine Support",         "repairGroup": "16.03"     },     {         "optionNumber": "FA1511-01",         "optionDescription": "DRIVE,FAN",         "repairGroup": "08.03"     },     {         "optionNumber": "FH11059-12",         "optionDescription": "Flywheel Housing",         "repairGroup": "16.01"     },     {         "optionNumber": "FW1020-06",         "optionDescription": "Flywheel",         "repairGroup": "16.02"     },     {         "optionNumber": "FW1701",         "optionDescription": "MOUNTING,FLYWHEEL",         "repairGroup": "16.02.1"     },     {         "optionNumber": "GG1749-01",         "optionDescription": "COVER,FRONT GEAR",         "repairGroup": "01.06"     },     {         "optionNumber": "LA1718-02",         "optionDescription": "Lifting Bracket Mounting",         "repairGroup": "17.06"     },     {         "optionNumber": "PP10321",         "optionDescription": "Turbocharger",         "repairGroup": "10.05"     },     {         "optionNumber": "PP10357",         "optionDescription": "NOZZLE, PISTON COOLING",         "repairGroup": "01.01.2"     },     {         "optionNumber": "PP10357",         "optionDescription": "PISTON, CONN ROD AND",         "repairGroup": "01.04"     },     {         "optionNumber": "PP10359",         "optionDescription": "Cylinder Head",         "repairGroup": "02.01"     },     {         "optionNumber": "PP10360",         "optionDescription": "Injector",         "repairGroup": "06.01"     },     {         "optionNumber": "SM1732-02",         "optionDescription": "MOUNTING,STARTING MOTOR",         "repairGroup": "13.05.1"     },     {         "optionNumber": "WR1717-01",         "optionDescription": "Wiring Accessories",         "repairGroup": "21.02"     },     {         "optionNumber": "CH1021-02",         "optionDescription": "AID,COO HEATER STARTING",         "repairGroup": "10.02"     },     {         "optionNumber": "PH1818-09",         "optionDescription": "Engine Control Module",         "repairGroup": "05.06.1"     },     {         "optionNumber": "PH1826-01",         "optionDescription": "Eng Cnt Module Plumbing",         "repairGroup": "05.06.1"     },     {         "optionNumber": "SV1001",         "optionDescription": "Engine Operating Voltage",         "repairGroup": "13.01"     },     {         "optionNumber": "WR1717-01",         "optionDescription": "Wiring Accessories",         "repairGroup": "21.02"     },     {         "optionNumber": "DL1068",         "optionDescription": "LOCATION, DRAIN",         "repairGroup": "06.07"     },     {         "optionNumber": "FD1706",         "optionDescription": "Fuel Drain Plumbing",         "repairGroup": "17.05"     },     {         "optionNumber": "FF1308",         "optionDescription": "FILTER,FUEL",         "repairGroup": "06.04"     },     {         "optionNumber": "FP10278",         "optionDescription": "PUMP, FUEL",         "repairGroup": "05.01"     },     {         "optionNumber": "FS1732",         "optionDescription": "Fuel System Primer",         "repairGroup": "05.19"     },     {         "optionNumber": "PP10323-03",         "optionDescription": "PLUMBING,INJECTOR",         "repairGroup": "06.01.2"     },     {         "optionNumber": "BR1296",         "optionDescription": "BREATHER,CRANKCASE",         "repairGroup": "03.02"     },     {         "optionNumber": "LC1751-01",         "optionDescription": "COOLER,ENGINE OIL",         "repairGroup": "07.05"     },     {         "optionNumber": "LF1232-03",         "optionDescription": "FILTER,FULL FLOW OIL",         "repairGroup": "07.03"     },     {         "optionNumber": "LG1148-04",         "optionDescription": "GAUGE,OIL LEVEL",         "repairGroup": "07.02"     },     {         "optionNumber": "LP1729-03",         "optionDescription": "PUMP,LUBRICATING OIL",         "repairGroup": "07.06"     },     {         "optionNumber": "OB1443-02",         "optionDescription": "ARRANGEMENT,OIL FILL",         "repairGroup": "07.02"     },     {         "optionNumber": "TP1813-02",         "optionDescription": "PLUMBING,TURBOCHARGER",         "repairGroup": "10.06.2"     },     {         "optionNumber": "DO1813",         "optionDescription": "SOFTWARE,CUS INTERFACE",         "repairGroup": "99.01"     },     {         "optionNumber": "FCP846",         "optionDescription": "CALIBRATION,FUEL PUMP",         "repairGroup": "99.01"     },     {         "optionNumber": "FR10993",         "optionDescription": "RATING,FUEL",         "repairGroup": "99.01"     },     {         "optionNumber": "NN1735",         "optionDescription": "Nameplate",         "repairGroup": "01.06.1"     },     {         "optionNumber": "SC12085",         "optionDescription": "SOFTWARE,CALIBRATION",         "repairGroup": "99.01"     },     {         "optionNumber": "EB1207",         "optionDescription": "Engine Brake",         "repairGroup": "03.04"     },     {         "optionNumber": "AP8122",         "optionDescription": "Agency Approval",         "repairGroup": "01.06.1"     },     {         "optionNumber": "FA1511-01",         "optionDescription": "Fan Drive",         "repairGroup": "08.03"     },     {         "optionNumber": "FW1701",         "optionDescription": "FLYWHEEL MOUNTING",         "repairGroup": "16.02.1"     },     {         "optionNumber": "LA1112",         "optionDescription": "ARRANGEMENT, LIFTING",         "repairGroup": "17.06"     },     {         "optionNumber": "OP1230",         "optionDescription": "Oil Pan",         "repairGroup": "07.01"     },     {         "optionNumber": "SS1097-01",         "optionDescription": "PAINT",         "repairGroup": "03.01"     } ]';
        String enginejson = '{     "engineSerialNumber": "79462241",     "data": [         {             "vin": "1NPTX4EX3CD137011",             "marketingEngineModel": "ISX15 450",             "serviceEngineModel": "ISX15 CM2250",             "epaModelName": "BCEXH0912XAP",             "engineBuildPlant": "JEP - JAMESTOWN ENGINE PLANT",             "engineBuildDate": "2011-02-23T00:00:00Z",             "warrantyStartDate": "2012-03-16T00:00:00Z",             "ecmCode": "CL10135",             "fuelPumpPartNumber": "4088507",             "fuelPumpCalibration": "P846",             "marketingConfig": "D103009BB09",             "technicalConfig": "D103009BX03",             "cplNumber": "CPL3719",             "customerNumber": "1608",             "shopOrder": "SO33045",             "businessUnit": "EBU"         }     ] }';
        String faultcodejson = '{     "faultCode": "2636",     "pid": "S27",     "spn": "641",     "fmi": "9",     "lamp": "Red",     "srt": "",     "description": "VGT Actuator Driver Circuit - Abnormal Update Rate",     "compLocation": "The VGT actuator is located on the turbocharger bearing housing.",     "circuitDescription": "The variable geometry turbocharger (VGT) is electronically activated by the VGT actuator. The VGT actuator is a smart device and receives information via the J1939 data link from the primary engine control module (ECM). The VGT actuator performs its own diagnostics and reports malfunctions back to the primary engine ECM, using the J1939 data link. The ECM then decodes the error message and converts it to a fault code.",     "reason": "VGT Actuator Driver Circuit - Abnormal Update Rate. No communications on the J1939 data link between the engine ECM and the smart VGT controller.",     "effect": "Possible reduced engine performance.",     "sysName": "",     "url": "https://qs-stg.cummins.com/qs3/pubsys2/xml/en/procedures/454/454-fc2636.html",     "engine": "454" }';
        String linkjson = '{     "qsolLink": [         "https://qs-stg.cummins.com/qs3/pubsys2/xml/en/procedures/145/145-fc1682.html"     ],     "language": "en" }';
        
        CG_CL_HttpRequestMock mock1 = new CG_CL_HttpRequestMock(200,'Complete',json,null);
        CG_CL_HttpRequestMock mock2 = new CG_CL_HttpRequestMock(200,'Complete',json1,null);
        CG_CL_HttpRequestMock linkmock = new CG_CL_HttpRequestMock(200,'Complete',linkjson,null);
        CG_CL_HttpRequestMock optionmock = new CG_CL_HttpRequestMock(200,'Complete',getoptionjson,null);
        CG_CL_HttpRequestMock enginemock = new CG_CL_HttpRequestMock(200,'Complete',enginejson,null);
        CG_CL_HttpRequestMock faultcodemock = new CG_CL_HttpRequestMock(200,'Complete',faultcodejson,null);
        Map<String, HttpCalloutMock> endpointsResponse =new Map<String,HttpCalloutMock>();
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',mock1);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data',mock2);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=TSB&language=en',mock2);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=TRP&language=en',mock2);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=ATC&language=en',mock2);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=CAMPAIGN&language=en',mock2);
        
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889',enginemock);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&faultCode=',faultcodemock);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&faultCode=&businessUnit=1234&language=en&documentType=jsonfile&documentId=019-019',linkmock);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&businessUnit=1234&language=en&documentType=jsonfile&documentId=019-019',linkmock);
        
         HttpCalloutMock multiCalloutMock =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        test.startTest();
        CSS_Job_Order__c JO = [select id from CSS_Job_Order__c limit 1 ];
        
        CSS_QuickServe.getQsolDocSave(JO.id,'79664889','en');
        CSS_Claims__c claim1=[select id from CSS_Claims__c limit 1 ];
        
        CSS_QuickServe.getQsolDocSaveforClaims(claim1.id,'79664889','en');
        CSS_QuickServe.linkMgmt('en','jsonfile','019-019',JO.id);
        CSS_QuickServe.getQsolDocSaveLang(JO.id,'79664889','en');
        map<Id,String> map1= new map<Id,String>();
        map1.put(claim1.id,'79664889');
        CSS_QuickServe.getJobOptions(map1,True);
        //CSS_QuickServe.getFaultCodeOverview('2636','79664889');
        CSS_List_Of_Values__c ListOfValue = new CSS_List_Of_Values__c();
         ListOfValue.Code__c = '130';
         ListOfValue.Picklist_Values_1__c = 'AUTOMOTIVE';
         ListOfValue.Picklist_Values_2__c = 'AUTOMOTIVE';
         ListOfValue.Picklist_Values_3__c = 'AUTOMOTIVE';
         ListOfValue.Type__c = 'Application Code';
         ListOfValue.Name = '1';
         insert ListOfValue;
        CSS_QuickServe.getDataPlateDocSave(JO.id,'79664889','UNLISTED','ALL',true);
        /*List<Asset> lstAsset = new List<Asset>();
        Asset asset1 = new Asset();
        asset1.SerialNumber = '79664889';
        asset1.No_Warranty__c = true;
        asset1.Type__c = 'Engines';
        asset1.Name = 'TestAsset';
        insert asset1;
        lstAsset.add(asset1);
        Asset asset2 = new Asset();
        asset2.SerialNumber = '79664889';
        asset2.No_Warranty__c = true;
        insert asset2;
        lstAsset.add(asset2);*/
        //CSS_QuickServe.getDataPlateDocSave(JO.id,'79664889');
        endpointsResponse.clear();
        CG_CL_HttpRequestMock linkmock1 = new CG_CL_HttpRequestMock(202,'Complete',linkjson,null);
        CG_CL_HttpRequestMock optionmock1 = new CG_CL_HttpRequestMock(202,'Complete',getoptionjson,null);
        CG_CL_HttpRequestMock enginemock1 = new CG_CL_HttpRequestMock(202,'Complete',enginejson,null);
        CG_CL_HttpRequestMock faultcodemock1 = new CG_CL_HttpRequestMock(202,'Complete',faultcodejson,null);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',mock1);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data',mock3);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=TSB&language=en',mock3);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=TRP&language=en',mock3);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=ATC&language=en',mock3);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&documentType=CAMPAIGN&language=en',mock3);
        
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889',enginemock1);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&faultCode=2636',faultcodemock1);
        endpointsResponse.put('https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/send/data79664889&faultCode=&businessUnit=1234&language=en&documentType=jsonfile&documentId=019-019',linkmock1);
        
        HttpCalloutMock multiCalloutMock1 =  new CG_CL_HTTPMultiRequestMock(endpointsResponse);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock1);
        CSS_QuickServe.getQsolDocSaveforClaims(claim1.id,'79664889','en');
        CSS_QuickServe.getQsolDocSaveforClaims(claim1.id,'79664889','en');
        CSS_QuickServe.linkMgmt('en','jsonfile','019-019',JO.id);
        CSS_QuickServe.getQsolDocSaveLang(JO.id,'79664889','en');
        CSS_QuickServe.getJobOptions(map1,false);
        //CSS_QuickServe.getFaultCodeOverview('2636','79664889');
        test.stopTest(); 
    }
    
   
    
}