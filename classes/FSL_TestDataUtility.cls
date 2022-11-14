/************************************************************************************
Name: FSL_TestDataUtility
Copyright © 2019  Cummins
=====================================================================================
=====================================================================================
Purpose: For Accept logic from SR to SO
=====================================================================================
=====================================================================================
History
-------
VERSION  AUTHOR            		DATE                DETAIL
1.0      Lochana Rajut          06/23/2022     Added test data creation methods
2.0       Sakthiraj             08/05/2022     Added method to create Failure
************************************************************************************/
@isTest
public class FSL_TestDataUtility {
    //Creae Account - sinlge record
    public static Account createAccount() {
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account';
        insert acc;
        return acc;
    }

    public static String getRSWResponse() {
        return '{"Header":{"Target":{"TargetID":"RSW"},"Sender":{"SenderID":"CSS"}},"DataArea":{"workOrder":null,'+
        '"unitNumber":"123123","timestamp":"07/13/2022 04:19:10","nbSearches":"0","modelSeries":"T660",' +
        '"manufacturer":"KENWORTH","id":"00146800","faultCode":"123","faliurePoint":"0","faliureMeasure":"HR",' +
        '"EventType":"FTR","event":[],"esn":"79635342","dsStatus":"Closed","dsID":"00146800","dsClosureType":null,' +
        '"customerName":"IA Cummins Test","createDate":"07/13/2022 04:19:10","application":"","accessSRTID":""}}';
    }

    public static FSL_Switch__c createFSLSwitchRecord(String Name, Boolean isactive) {
        FSL_Switch__c FSlSwitch = new FSL_Switch__c(
            NAme=Name, IsActive__c=isactive
        );
        return FSlSwitch;
    }

    public static List<CSS_Solutions__c> create_CSSSolutions(Id woID, Integer cnt) {
        List<CSS_Solutions__c> lst = new List<CSS_Solutions__c>();
        for(Integer i=0; i<cnt; i++) {
            lst.add(new CSS_Solutions__c(
                FSL_Service_Job__c = woID
            ));
        }//for
        return lst;
    }

    public static List<CSS_Solution_Component__c> create_CSSSolutionComponents(List<CSS_Solutions__c> cssSolutionIds) {
        List<CSS_Solution_Component__c> lst = new List<CSS_Solution_Component__c>();
        for(CSS_Solutions__c obj : cssSolutionIds) {
            lst.add(new CSS_Solution_Component__c(
                Solutions__c = obj.id,
                Selected_Component__c = true,
                Component_Id__c = 'F19000170',
                FSL_Service_Job__c = obj.FSL_Service_Job__c
            ));
        }//for
        return lst;
    }
    

    //Create Custom Setting record - CSS_Integration_Details__c
    public static CSS_Integration_Details__c createCSSIntegrationDetails(String Name, String endPoint, String methodType) {
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name=Name;
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c=Name;
        conDetails.End_Point__c=endPoint;
        conDetails.Method_Type__c=methodType;
        conDetails.Key__c='UCAWpwjTAyl9GA07EtVfLE7ZRneHQbe9tFdQr3Scppo=';
        conDetails.Passcode__c='xfgYI9ubUYW1DHPjNJc1D46rhF7KFaYTDXTKB7IHweTwtHB2a3pOLEzY9fzjEWfVtHba+M8T7lk6BE5CvumgPA==';
        conDetails.Username__c='4AX7rk2oT4dNFvlO4NkqAhab+2T05ZVujysERwTX+I8ZCVZW5YStPHB8DyYk8G07M8aHo6uYsZeBYRX73F4ciQ==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';
        return conDetails;
    }
    
    public static Contact createContact(Id rectypeId, Id accId) {
        return new Contact(FirstName = 'First',
                                      LastName = 'Mishra',
                                      IAM_Contact_Status__c = 'Active',
                                      Username__c = 'testmishra@mymail.com',
                                      Email = 'testmishra@mymail.com',
                                      AccountId = accId,
                                      RecordTypeId = rectypeId);
    }

    
    public static List<Case> createCases(Id recordtypeId,Id accId, Id conId, Id assetId, Id territoryId, integer cnt) {
        List<Case> lstCases = new List<Case>();
        for(integer i=0; i< cnt; i++) {
            Case cs=new Case();
            cs.RecordTypeId=recordtypeId;
            cs.AccountId=accId;
            cs.ContactId=conId;
            cs.AssetId=assetId;
            cs.Description = 'test symptoms';
            cs.Service_Territory__c=territoryId;
            cs.IAS_Number__c = '12345' + String.valueOf(i);
            cs.Status='New';
            cs.Description = 'Test 123';
            cs.Product_Mileage__c = 1212;
            cs.Product_Hours__c = 2;
            cs.Product_Mileage_Unit__c= 'Km'; 
            cs.Make__c = 'Other Manufacturer';
            cs.Model__c = 'Other Model';
            cs.Available_for_Service__c=datetime.now()+2;
            lstCases.add(cs);
        }
        return lstCases;
    }

    public static List<Workorder> createWO( List<Case> lstCases, Id accId) {
        List<Workorder> lstWO = new List<Workorder>();
        for(Case caseobj1: lstCases) {
            workorder wo=new workorder();
            wo.Make__c='UNLISTED';
            wo.Model__c = 'ALL';
            wo.AssetId= caseobj1.AssetId;
            wo.CaseId = caseobj1.id;
            wo.Mileage_Measure__c = 'Kilometers';
            wo.Process_Step__c = 'Triage & Diagnosis';
            wo.Application__c = '130 - AUTOMOTIVE';
            wo.EditComplaint__c = 'Testing';
            wo.EditCause__c = 'Testing';
            wo.EditCorrection__c = 'Testing';
            wo.EditCoverage__c = 'Testing';
            wo.Mileage_Measure__c = 'Miles';
            wo.Type__c = 'Dealer';
            wo.Category1__c = 'Leak';
            wo.Warranty_Start_Date__c = Date.today();
            wo.Case = caseobj1;
            wo.sub_status__c = 'Troubleshooting Complete';
            wo.EVL_Customer__c ='ABCDEFGHIJKLMNOPQRSTUVWXYZIt is More than 30 chracters test';

            lstWO.add(wo);
        }
        return lstWO;
    }
    //Create List of Account
    public static List<Account> createAccounts(Integer numAccts) {
        List<Account> accts = new List<Account>();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            a.RecordTypeId = accRecId;
            accts.add(a);
        }
        insert accts;
        return accts;
    }
    
    //Create OperatingHours - single record
    public static OperatingHours createOperatingHour() {
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        return oh; 
    }
    
    //Create ServiceTerritory - single record
    public static ServiceTerritory createServiceTerritory() {
        ServiceTerritory serviceTerr = new ServiceTerritory();
        serviceTerr.Name = 'ServiceTerritory Mobile';
        serviceTerr.IsActive = true;
        serviceTerr.Location_Code__c = '1234-1234';
        serviceTerr.OperatingHoursId = FSL_TestDataUtility.createOperatingHour().Id;
        serviceTerr.FSL_Service_Territory_Code__c = '54973';
        serviceTerr.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serviceTerr.Territory__c = 'AUSTRALIA';
        insert serviceTerr;
        return serviceTerr;
    }
    
    //Create Asset - single record
    public static Asset createAsset() {
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.Type_PSN__c='Engines-79644334';
        insert asst;
        return asst;
    }
    
    //Create WOrkOrder - single record
    public static WOrkOrder createWorkOrder(double mileage, String mileageMesure) {
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        WorkOrder wo = new WorkOrder();
        wo.AccountId = FSL_TestDataUtility.createAccount().Id;
        wo.AssetId = FSL_TestDataUtility.createAsset().Id;
        wo.ServiceTerritoryId = FSL_TestDataUtility.createServiceTerritory().Id;
        wo.Available_for_Service__c = datetime.now()+3;
        wo.Status = 'Intake';        
        wo.Shop_Work_Order__c = 'test';
        wo.Process_Step__c = 'Intake';
        wo.RecordTypeId = recdtypeId; 
        if(mileage != null)
            wo.Mileage__c = mileage;
        if(mileageMesure != null)
            wo.Mileage_Measure__c = mileageMesure;
        wo.createdDate=system.now().addDays(-10);
        insert wo;
        return wo;
    }

    public static Service_Order_Extension__c createServiceOrderExtension(Id woId, Boolean ABRFlag, String transactionId){
        Service_Order_Extension__c soExtension = new Service_Order_Extension__c(Service_Order_Id__c=woId,
                                                                            FSL_ABRFlag__c=ABRFlag,
                                                                            FSL_TransactionID__c=transactionId);
        insert soExtension;
        return soExtension;
    }
    
    //2.0 start
    public static FSL_Failure__c createFailure(String failureId, String compCode, String sysCode, String modelName, Boolean doDML){
        
        FSL_Failure__c failure = new FSL_Failure__c();
        failure.Name = 'WUSS - Campaign 2113';
        failure.Failure_Id__c = failureId;
        failure.Component_Code__c = compCode;
        failure.System_Code__c = sysCode;
        failure.Service_Model_Name__c = modelName;
        
        if(doDML){
            insert failure;
        }
        return failure;
    }
	//2.0 end
	    
    //Create CSS_Job_Order object record
    public static CSS_Job_Order__c createJobOrder(boolean isInsert){
        
        String grpName = 'JQ'+'-'+'56270-56255';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        CSS_Job_Order__c SerRec = new CSS_Job_Order__c();
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Job_Order__c', QueueId=testQue.Id);
            insert tq;
            Date d = Date.Today();
            // System.debug('date');
            SerRec.DSID__c='12345';
            //SerRec.OwnerId = tq.Id;
            SerRec.DSID_Status__c='open';
            SerRec.ESN__c ='79464646';
            SerRec.Customer_Name__c='ABC';
            SerRec.Failure_Date__c =d;
            SerRec.Failure_Point__c=2.2;
            SerRec.Unit_Number__c='1234';
            SerRec.Service_Model__c='ESN';
            SerRec.Service_Model_N__c = 445566;
            SerRec.Make__c='test';
            SerRec.Model__c='test1';
            SerRec.VIN__c='1XKAD49X6CJ305490';
            SerRec.Customer_Name__c='ABC';
            SerRec.Warranty_Start_Date__c=d;
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
            
            if(isInsert){
                insert SerRec;
            }
        }
        return SerRec;
    }
    
    //Create Custom Setting record - CSS_Integration_Details__c
    public static CSS_Integration_Details__c createCSSIntegrationDetails() {
        CSS_Integration_Details__c CID = new CSS_Integration_Details__c();
        CID.Name = 'FSL_MOVEXMROMessages';
        CID.End_Point__c = 'www.google.com';
        insert CID;
        return CID;
    }
    
    public static CSS_JobForms__c createCSSJobForm() {
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        CSS_JobForms__c jobform = new CSS_JobForms__c();
        jobform.CreatedDate = system.now();
        jobform.JSA__c = 'JSATEST';
        jobform.Name = 'TEST_NAME';
        jobform.Service_Job__c = jo.id;
        jobform.ServiceJob__c = FSL_TestDataUtility.createWorkOrder(null, null).Id;
        jobform.LastModifiedDate = system.now(); 
        insert jobform;
        return jobform; 
    }
    
    //Create ERP_Message__c single record
    public static ERP_Message__c createERPMessage(String createMRO, String custCredit) {
        ERP_Message__c message = new ERP_Message__c();
        message.Service_Order__c = FSL_TestDataUtility.createWorkOrder(null, null).Id;
        if(createMRO != null)
            message.MRO_Messages__c = getMROMessageJSON();
        message.MRO_Messages_Received__c = true;
        if(custCredit != null)
            message.Customer_Credit_Message__c = getCustomerCreditMsgJSON();
        message.Credit_Message_Received__c=true;
        insert message;
        
        return message;
    }
    
    // Method to create User 
    public static User createTestUser(boolean isInsert){
        UserRole empRole = [Select Id From UserRole Where Name = 'DFSE-CUMMINS CENTRAL' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi1@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = empRole.id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi1@cummins.com', User_Location__c='123456');
        if(isInsert){
            try{
                insert objUser1;
            }catch(Exception e){
                system.debug('exception message>>>>>'+e.getMessage());
            }
            
        }
        
        return objUser1;
    }
    
    public Static String getClaimDetailsData() {
        return '';
    }
    
    public static List<CSS_JobEventTemporary__c> getClaimHistoryData() {
        
        List<CSS_JobEventTemporary__c> jobEventlstRef = new List<CSS_JobEventTemporary__c>();
        
        CSS_JobEventTemporary__c JET = new CSS_JobEventTemporary__c();
        JET.Type__c='ClaimHistory';
        JET.key__c='79788868'; 
        JET.Attribute1__c= '2014-12-19T00: 00: 00.000-06: 00'; 
        JET.Attribute3__c= 'J.B.HUNT';
        JET.Attribute2__c= '30133';
        JET.Attribute7__c= '33399246';
        JET.Attribute8__c= '04157-1683914-0';
        JET.Circuit_Description__c= 'EQPE';
        JET.Service_Model_Name__c= 'ISX15CM2350X101';
        JET.Attribute10__c='';
        JET.Attribute4__c= '1684';
        JET.Attribute6__c= 'Miles';
        JET.Attribute11__c= '2014-12-08T00: 00: 00.000-06: 00';
        JET.Attribute5__c='';
        JET.Attribute9__c= 'Paid';
        jobEventlstRef.add(JET);
        return jobEventlstRef;
    }
    
    //
    public static String getFaultCodeResponse() {
        return '{'+
            '    \"TransactionID\": \"A26F8F9B-9591-4955-B8DB-66EBDDA09A37\",'+
            '    \"ToolID\": \"Guidanz Web\",'+
            '    \"JobNumber\": \"00001613\",'+
            '    \"WorkgroupID\": \"ALBANY-EAST-ALBANY-02024\",'+
            '    \"UserID\": \"AB123\",'+
            '    \"FaultCodeList\": ['+
            '        {'+
            '            \"FaultCode\": 122,'+
            '            \"PCode\": \"\",'+
            '            \"SolutionCount\": 6,'+
            '            \"Solutions\": ['+
            '                {'+
            '                    \"SolutionID\": \"S00001235\",'+
            '                    \"SolutionTitle\": \"Check for primary fault codes\",'+
            '                    \"SolutionPosition\": 1,'+
            '                    \"SolutionPriority\": 9.60,'+
            '                    \"LanguageKey\": \"en\",'+
            '                    \"LinkedSolutionCount\": 0,'+
            '                    \"LinkedSolutions\": ['+
            '                        {}'+
            '                    ],'+
            '                    \"Components\": ['+
            '                    {   \"FailureID\": \"F30001060\",'+
        '                            \"ComponentName\": \"Electrical Connector\"'+
        '                        }]'+
            '                },'+
            '                {'+
            '                    \"SolutionID\": \"S00000457\",'+
            '                    \"SolutionTitle\": \"Intake manifold pressure sensor voltage check\",'+
            '                    \"SolutionPosition\": 2,'+
            '                    \"SolutionPriority\": 6.00,'+
            '                    \"LanguageKey\": \"en\",'+
            '                    \"LinkedSolutionCount\": 1,'+
            '                    \"LinkedSolutions\": [ { '+
            '                        \"SolutionTitle\": "Aftertreatment diesel exhaust fluid dosing valve is malfunctioning\",'+
            '                        \"SolutionPriority\": 0,'+
            '                        \"SolutionPosition\": 3.01,'+
            '                        \"SolutionID\": \"S00003040\",'+
            '                        \"LanguageKey\": \"en\",'+
            '                        \"Components\": [ {'+
            '                            \"FailureID\": \"F11000020\",'+
            '                            \"ComponentName\": \"Aftertreatment Diesel Exhaust Fluid Dosing Valve\"'+
            '                           }]'+
            '                    }]'+
            '                },'+
            '                {'+
            '                    \"SolutionID\": \"K00000103\",'+
            '                    \"SolutionTitle\": \"Engine exhaust back pressure regulator circuit pin to ground short\",'+
            '                    \"SolutionPosition\": 6,'+
            '                    \"SolutionPriority\": 1.00,'+
            '                    \"LanguageKey\": \"en\",'+
            '                    \"LinkedSolutionCount\": 0,'+
            '                    \"LinkedSolutions\": ['+
            '                        {}'+
            '                    ]'+
            '                }'+
            '            ]'+
            '        }'+
            '    ]'+
            '}';
    }
    
    //FSL_CL_CheckWarranty REST API Response Body String
    public static String checkWarrantyResponses() {
        return '{'+
            '    \"Header\": {'+
            '        \"Status\": \"Success\",'+
            '        \"ReturnCodeDescription\": \"\"'+
            '    },'+
            '    \"BasicCoverageResponseHeader\": {'+
            '        \"Response\": {'+
            '            \"ListOfCoverageDetails\": {'+
            '                \"CoverageDetails\": ['+
            '                    {'+
            '                        \"Status\": \"Expired\",'+
            '                        \"ListOfCoverageDedutibles\": {'+
            '                            \"CoverageDedutibles\": []'+
            '                        },'+
            '                        \"WarrantyManualURL\": \"\",'+
            '                        \"WarrantyEndDate\": \"12/8/2017\",'+
            '                        \"CoverageType\": \"NEW-New Engine Warranty\",'+
            '                        \"ProcedureNumber\": \"\",'+
            '                        \"ListOfCoverageComponentList\": {'+
            '                            \"CoverageComponentList\": ['+
            '                                {'+
            '                                    \"CoverageHours\": \"0\",'+
            '                                    \"CoverageMaxMonths\": \"24\",'+
            '                                    \"CoverageComponentTypeCode\": \"BASE\",'+
            '                                    \"MegawattHours\": \"0\",'+
            '                                    \"CoverageDefenitionType\": \"BASE\",'+
            '                                    \"CoverageMinMonths\": \"0\",'+
            '                                    \"CoverageMiles\": \"200000\"'+
            '                                },'+
            '                                {'+
            '                                    \"CoverageHours\": \"0\",'+
            '                                    \"CoverageMaxMonths\": \"36\",'+
            '                                    \"CoverageComponentTypeCode\": \"EXTENDED\",'+
            '                                    \"MegawattHours\": \"0\",'+
            '                                    \"CoverageDefenitionType\": \"EXTENDED\",'+
            '                                    \"CoverageMinMonths\": \"0\",'+
            '                                    \"CoverageMiles\": \"300000\"'+
            '                                },'+
            '                                {'+
            '                                    \"CoverageHours\": \"0\",'+
            '                                    \"CoverageMaxMonths\": \"24\",'+
            '                                    \"CoverageComponentTypeCode\": \"INJECTOR\",'+
            '                                    \"MegawattHours\": \"0\",'+
            '                                    \"CoverageDefenitionType\": \"BASE\",'+
            '                                    \"CoverageMinMonths\": \"0\",'+
            '                                    \"CoverageMiles\": \"125000\"'+
            '                                }'+
            '                            ]'+
            '                        }'+
            '                    }'+
            '                ]'+
            '            },'+
            '            \"ListOfExtendedCoverageDetails\": {'+
            '                \"ExtendedCoverageDetails\": ['+
            '                    {'+
            '                        \"Status\": \"Active\",'+
            '                        \"WarrantyManualURL\": \"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=\",'+
            '                        \"Months\": \"60\",'+
            '                        \"ListOfExtCoverageDedutibles\": {'+
            '                            \"ExtendedCoverageDedutibles\": []'+
            '                        },'+
            '                        \"CAPCoverageID\": \"EXC\",'+
            '                        \"ProgramID\": \"JP1\",'+
            '                        \"BeginMiles\": \"0\",'+
            '                        \"EndDate\": \"12/08/2019\",'+
            '                        \"StartDate\": \"12/08/2014\",'+
            '                        \"BeginHours\": \"0\",'+
            '                        \"EndMiles\": \"500000\",'+
            '                        \"CertificateNumber\": \"JP11000060\",'+
            '                        \"EndHours\": \"0\",'+
            '                        \"ProcedureNumber\": \"111-505-091\"'+
            '                    },'+
            '                    {'+
            '                        \"Status\": \"Active\",'+
            '                        \"WarrantyManualURL\": \"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=\",'+
            '                        \"Months\": \"60\",'+
            '                        \"ListOfExtCoverageDedutibles\": {'+
            '                            \"ExtendedCoverageDedutibles\": []'+
            '                        },'+
            '                        \"CAPCoverageID\": \"AT3\",'+
            '                        \"ProgramID\": \"AT3\",'+
            '                        \"BeginMiles\": \"0\",'+
            '                        \"EndDate\": \"12/08/2019\",'+
            '                        \"StartDate\": \"12/08/2014\",'+
            '                        \"BeginHours\": \"0\",'+
            '                        \"EndMiles\": \"500000\",'+
            '                        \"CertificateNumber\": \"AT31014253\",'+
            '                        \"EndHours\": \"0\",'+
            '                        \"ProcedureNumber\": \"111-505-126\"'+
            '                    }'+
            '                ]'+
            '            }'+
            '        }'+
            '    }'+
            '}';
    }
    //FSL_ReceiveCustomerInfo - REST API Request body String
    public static String getCustomerData() {
        return '{'+
            '\"Header\": {'+
            '   \"Status\": \"\",'+
            '   \"Sender\":       {'+
            '        \"ServiceName\": \"GetCustomerInfo\",'+
            '        \"SenderID\": \"Movex\"'+
            '     },'+
            '   \"Target\": \"CSS\",'+
            '   \"Location\": \" \"'+
            ' },'+
            '\"DataArea\": ['+
            ' {'+
            '  \"CustomerCode\":\"321\", '+
            '  \"LocationAddressline3\":\"VENDOR CUM001\",'+
            '  \"PhoneNumber\":\"03 9420 9946\",'+
            '  \"Country\":\"Australia\",'+
            '  \"CustomerName\":\"VS321 AUSTRALIA PTY LTD\",'+
            '  \"City\":\" \",'+
            '  \"LocationAddressline2\":\"LOCKED BAG 32016\",'+
            '  \"LocationAddressline1\":\"VENDOR CUM001\",'+
            '  \"AreaCode\":\" \",'+
            '  \"PaymentType\":\"Cheque Allocate\",'+
            '  \"State\":\"South Australia\",'+
            '  \"Postalcode2\":\"8003\",'+
            '  \"Postalcode1\":\" \",'+
            '  \"CreditLimit\":\"475000.00\",'+
            '  \"QuoteCustomer\":\" \",'+
            '  \"RequirePO\":\" \",'+
            '  \"AmountDue\":\" \",'+
            '  \"AvailableCredit\":\" \",'+
            '  \"LocationAddressline4\":\"VIC  8003\",'+
            '  \"County\":\"networkintegritypaya@visionstream.com.au\",'+
            '  \"PayerDetails\" : ['+
            '    {'+
            '      \"PayerContactName\":\" \",'+
            '     \"PayerAccountCode\":\" \"'+
            '  }'+
            '   ],'+
            '  \"LastUpdatedDate\":\"2019-03-29T13:40:00\",'+
            '  \"EventFlag\":\"ADD\",'+
            '  \"ERP_Status\" : \" \"'+
            ' },'+
            ' {'+
            '  \"CustomerCode\":\"123\", '+
            '  \"LocationAddressline3\":\"VENDOR CUM001\",'+
            '  \"PhoneNumber\":\"03 9420 9946\",'+
            '  \"Country\":\"Australia\",'+
            '  \"CustomerName\":\"VS123 AUSTRALIA PTY LTD\",'+
            '  \"City\":\" \",'+
            '  \"LocationAddressline2\":\"LOCKED BAG 32016\",'+
            '  \"LocationAddressline1\":\"VENDOR CUM001\",'+
            '  \"AreaCode\":\" \",'+
            '  \"PaymentType\":\"Cheque Allocate\",'+
            '  \"State\":\"South Australia\",'+
            '  \"Postalcode2\":\"8003\",'+
            '  \"Postalcode1\":\" \",'+
            '  \"CreditLimit\":\"475000.00\",'+
            '  \"QuoteCustomer\":\" \",'+
            '  \"RequirePO\":\" \",'+
            '  \"AmountDue\":\" \",'+
            '  \"AvailableCredit\":\" \",'+
            '  \"LocationAddressline4\":\"VIC  8003\",'+
            '  \"County\":\"networkintegritypaya@visionstream.com.au\",'+
            '  \"PayerDetails\" : ['+
            '    {'+
            '      \"PayerContactName\":\" \",'+
            '     \"PayerAccountCode\":\" \"'+
            '  }'+
            '   ],'+
            '  \"LastUpdatedDate\":\"2019-03-29T13:40:00\",'+
            '  \"EventFlag\":\"ADD\",'+
            '  \"ERP_Status\" : \" \"'+
            ' }'+
            ']'+
            '}';
    }
    
    //FSL_ReceiveCustomerContact - REST API RequestBody String
    public static String getCustomerContactData() {
        return '{'+
            '  \"Header\": {'+
            '    \"Status\": \" \",'+
            '    \"Sender\": {'+
            '      \"ServiceName\": \"GetContactInfo\",'+
            '      \"SenderID\": \"Movex\"'+
            '    },'+
            '    \"Target\": \"CSS\",'+
            '    \"Location\": \" \"'+
            '  },'+
            '  \"DataArea\": ['+
            '    {'+
            '      \"CustomerNumber\": \"1310000\",'+
            '      \"FirstName\": \"DARRA CASH SALE CUST GROUP \",'+
            '      \"MI\": \" \",'+
            '      \"LastName\": \" \",'+
            '      \"Salutation\": \" \",'+
            '      \"Position\": \" \",'+
            '      \"LocationAddressline1\": \"TEMPLATE CUSTOMERS STREET\",'+
            '      \"LocationAddressline2\": \"TEMPLATE CUSTOMERS SUBURB\",'+
            '      \"LocationAddressline3\": \"STATE QUEENLAND  \",'+
            '      \"City\": \"Cheque Allocate\",'+
            '      \"State\": \"South Australia\",'+
            '      \"PostalCode\": \"8003\",'+
            '      \"PostalCodeSuffix\": \" \",'+
            '      \"Country\": \"Australia\",'+
            '      \"PhoneAreaCode\": \" \",'+
            '      \"PhoneNumber\": \"03 9420 9946\",'+
            '      \"Ext\": \" \",'+
            '      \"FaxAreaCode\": \" \",'+
            '      \"FaxNumber\": \" \",'+
            '      \"Email\": \"networkintegritypaya@visionstream.com.au\",'+
            '      \"Comments\": \"\",'+
            '      \"ContactID\": \"13\",'+
            '      \"LocationAddressline4\": \"TEST ADDRESS 4  TEST 1111 \",'+
            '      \"LastUpdatedDate\": \"2019-05-10T05:23:41\",'+
            '      \"EventFlag\": \"ADD\"'+
            '    }'+
            '  ]'+
            '}';
    }
    
    public static String getCDAlertResponse() {
        return '{"Distinct_Fault_Code_Info":[{"response_Version":5.5,"engine_Serial_Number":32423432,"total_Distinct_Faults":3,"distinct_Fault_Code_Info":[{"fault_Code":1.0,"fault_Code_Description":5.0,"latest_Occurrence_Date_Time":"Pencil","total_Occurrence_Count":""}]}]}';
    }
    
    public static String getCustomerCreditMessage() {
        return '{"DataArea":{"CustomerNumber":"131SERV","CreditMessageDetails":[{"CreditMessage":"","CreditMessageCode":"N"},{"CreditMessage":"","CreditMessageCode":""}]},"Header":{"Sender":{"ServiceName":"GetCustomerCreditMessage","SenderID":"CSS","MessageID":"8bdaa801-bb20-4c9d-ab57-df13dc7e8c5a"},"Status":"SUCCESS","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"Request processed successfully","Location":{"LocationID":"05340-05351"}}}';
    }
    
    public static String getMROMessageString() {
        return '{"DataArea":{"Status":"SUCCESS","CustomerCode":2110054,"ReturnCodeDescription":"Request processed successfully","MessageDetails":[{"Priority":1,"TextDetails":[{"LnNo":1,"MessageText":"***Banking Details***"},{"LnNo":2,"MessageText":"Cummins South Pacific Pty Ltd"},{"LnNo":3,"MessageText":"Australia and New Zealand Banking Group Limited (ANZ)"},{"LnNo":4,"MessageText":"Level 4, 100 Queen Street, Melbourne, VIC 3000"},{"LnNo":5,"MessageText":"Account No: 836551902   BSB: 013 479"},{"LnNo":6,"MessageText":"Swift Code: ANZBAU3M"},{"LnNo":7,"MessageText":""},{"LnNo":8,"MessageText":"Please include in the payment reference the account"},{"LnNo":9,"MessageText":"number and invoice number being paid"}],"MessageID":16509},{"Priority":1,"TextDetails":[{"LnNo":1,"MessageText":"Lindsay Transport Agreed Pricing"},{"LnNo":2,"MessageText":"Retail Work - InShop only = $140.00 / Hour"},{"LnNo":3,"MessageText":"Agreement Expiry Date = 01-Aug-2019"},{"LnNo":4,"MessageText":""},{"LnNo":5,"MessageText":"NOTE: Normal retail labour rates apply to all Field Service"},{"LnNo":6,"MessageText":"Repairs - Adjust labour rate before invoicing."},{"LnNo":7,"MessageText":""},{"LnNo":8,"MessageText":"For agreement clarification details contact:"},{"LnNo":9,"MessageText":"Nathan Usher: 0408 396 526"}],"MessageID":16551},{"Priority":5,"TextDetails":[{"LnNo":1,"MessageText":"Warranty plus"},{"LnNo":2,"MessageText":""},{"LnNo":3,"MessageText":"4 years"},{"LnNo":4,"MessageText":"1200000km"},{"LnNo":5,"MessageText":"600000 fuel"},{"LnNo":6,"MessageText":"18000 hours"},{"LnNo":7,"MessageText":""},{"LnNo":8,"MessageText":"CA105622"},{"LnNo":9,"MessageText":""},{"LnNo":10,"MessageText":"inv 4209275"}],"MessageID":4306},{"Priority":5,"TextDetails":[{"LnNo":1,"MessageText":"CHANGE ENVIRO LEVY IN COS103/B"},{"LnNo":2,"MessageText":""},{"LnNo":3,"MessageText":"This engine serial number is in the Mid Range engine"},{"LnNo":4,"MessageText":"family and attracts a $15 Enviromental Levy fee for Retail"},{"LnNo":5,"MessageText":"invoice."},{"LnNo":6,"MessageText":""},{"LnNo":7,"MessageText":"Change the Enviro Levy to $15 in COS103/B"},{"LnNo":8,"MessageText":""},{"LnNo":9,"MessageText":"Use Panel Sequence YZ31 or select option 13 from COS100"},{"LnNo":10,"MessageText":"screen"}],"MessageID":4597},{"Priority":5,"TextDetails":[{"LnNo":1,"MessageText":"CHANGE ENVIRO LEVY IN COS103/B"},{"LnNo":2,"MessageText":""},{"LnNo":3,"MessageText":"This engine serial number is in the High Horse Power engine"},{"LnNo":4,"MessageText":"family and attracts a $45 Enviromental Levy fee for Retail"},{"LnNo":5,"MessageText":"invoice."},{"LnNo":6,"MessageText":""},{"LnNo":7,"MessageText":"Change the Enviro Levy to $45 in COS103/B"},{"LnNo":8,"MessageText":""},{"LnNo":9,"MessageText":"Use Panel Sequence YZ31 or select option 13 from COS100"},{"LnNo":10,"MessageText":"screen"}],"MessageID":4598},{"Priority":5,"TextDetails":[{"LnNo":1,"MessageText":"CHANGE ENVIRO LEVY IN COS103/B"},{"LnNo":2,"MessageText":""},{"LnNo":3,"MessageText":"This engine serial number is in the High Horse Power engine"},{"LnNo":4,"MessageText":"family and attracts a $45 Enviromental Levy fee for Retail"},{"LnNo":5,"MessageText":"invoice."},{"LnNo":6,"MessageText":""},{"LnNo":7,"MessageText":"Change the Enviro Levy to $45 in COS103/B"},{"LnNo":8,"MessageText":""},{"LnNo":9,"MessageText":"Use Panel Sequence YZ31 or select option 13 from COS100"},{"LnNo":10,"MessageText":"screen"}],"MessageID":4599},{"Priority":5,"TextDetails":[{"LnNo":1,"MessageText":"CHANGE ENVIRO LEVY IN COS103/B"},{"LnNo":2,"MessageText":""},{"LnNo":3,"MessageText":"This engine serial number is in the Mid Range engine"},{"LnNo":4,"MessageText":"family and attracts a $15 Enviromental Levy fee for Retail"},{"LnNo":5,"MessageText":"invoice."},{"LnNo":6,"MessageText":""},{"LnNo":7,"MessageText":"Change the Enviro Levy to $15 in COS103/B"},{"LnNo":8,"MessageText":""},{"LnNo":9,"MessageText":"Use Panel Sequence YZ31 or select option 13 from COS100"},{"LnNo":10,"MessageText":"screen"}],"MessageID":4600},{"Priority":5,"TextDetails":[{"LnNo":1,"MessageText":"CHANGE ENVIRO LEVY IN COS103/B"},{"LnNo":2,"MessageText":""},{"LnNo":3,"MessageText":"This engine serial number is in the Mid Range engine"},{"LnNo":4,"MessageText":"family and attracts a $15 Enviromental Levy fee for Retail"},{"LnNo":5,"MessageText":"invoice."},{"LnNo":6,"MessageText":""},{"LnNo":7,"MessageText":"Change the Enviro Levy to $15 in COS103/B"},{"LnNo":8,"MessageText":""},{"LnNo":9,"MessageText":"Use Panel Sequence YZ31 or select option 13 from COS100"},{"LnNo":10,"MessageText":"screen"}],"MessageID":4601},{"Priority":5,"TextDetails":{"LnNo":1,"MessageText":"Ring Nathan Usher for all major repairs on 0408 396 526"},"MessageID":5897},{"Priority":5,"TextDetails":[{"LnNo":1,"MessageText":"For all major repairs please advise National Account Manager"},{"LnNo":2,"MessageText":"Nathan Usher Ph 0408 396526"}],"MessageID":5899},{"Priority":5,"TextDetails":[{"LnNo":1,"MessageText":"ISF Engines in Foton vehicles will have a worldwide coverage"},{"LnNo":2,"MessageText":"certificate applied to align the engine with the vehicle"},{"LnNo":3,"MessageText":"coverage."},{"LnNo":4,"MessageText":""},{"LnNo":5,"MessageText":"For coverage detail go to http://wwec.cummins.com"},{"LnNo":6,"MessageText":"and enter the engine number."},{"LnNo":7,"MessageText":""},{"LnNo":8,"MessageText":"The certificate and program detail must be included in the"},{"LnNo":9,"MessageText":"warranty text for any covered repair beyond the ISF base"},{"LnNo":10,"MessageText":"engine coverage. Please also update the engine prospect with"},{"LnNo":11,"MessageText":"coverage certificate &amp; program details. If an engine does"},{"LnNo":12,"MessageText":"not have a coverage certificate please e-mail (TPD) with the"},{"LnNo":13,"MessageText":"engine detail to be escalated to BFCEC &amp; Foton."}],"MessageID":9199},{"Priority":5,"TextDetails":[{"LnNo":1,"MessageText":"ISF Engines in Foton vehicles will have a worldwide coverage"},{"LnNo":2,"MessageText":"certificate applied to align the engine with the vehicle"},{"LnNo":3,"MessageText":"coverage."},{"LnNo":4,"MessageText":""},{"LnNo":5,"MessageText":"For coverage detail go to http://wwec.cummins.com"},{"LnNo":6,"MessageText":"and enter the engine number."},{"LnNo":7,"MessageText":""},{"LnNo":8,"MessageText":"The certificate and program detail must be included in the"},{"LnNo":9,"MessageText":"warranty text for any covered repair beyond the ISF base"},{"LnNo":10,"MessageText":"engine coverage. Please also update the engine prospect with"},{"LnNo":11,"MessageText":"coverage certificate &amp; program details. If an engine does"},{"LnNo":12,"MessageText":"not have a coverage certificate please e-mail (TPD) with the"},{"LnNo":13,"MessageText":"engine detail to be escalated to BFCEC &amp; Foton."}],"MessageID":9200},{"Priority":5,"TextDetails":[{"LnNo":1,"MessageText":"Prior to commencing any works on ISF engines in Foton"},{"LnNo":2,"MessageText":"Application please contact:"},{"LnNo":3,"MessageText":""},{"LnNo":4,"MessageText":"Tim Williams"},{"LnNo":5,"MessageText":"National Service Manager"},{"LnNo":6,"MessageText":"FOTON TRUCKS AUSTRALIA"},{"LnNo":7,"MessageText":"862-874 Elizabeth St, Waterloo NSW 2017"},{"LnNo":8,"MessageText":"Locked Bag 5018, Alexandria NSW 2015"},{"LnNo":9,"MessageText":"Tel: +61 2 8577 8037"},{"LnNo":10,"MessageText":"Fax: +61 2 8577 8199"},{"LnNo":11,"MessageText":"Mob: +61 4 5887 7731"},{"LnNo":12,"MessageText":"Email: twilliams@ateco.com.au"},{"LnNo":13,"MessageText":"www.fotontrucks.com.au"}],"MessageID":9712}]},"Header":{"Sender":{"ServiceName":"GetMROMessages","SenderID":"CSS","MessageID":"3f52f7d0-bac0-496a-9990-d53706856208"},"Status":"","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"","Location":{"LocationID":"05340-05351"}}}';
    }
    
    public static String getCustomerCreditMsgJSON() {
        String json = '{\"DataArea\":{\"CustomerNumber\":\"1310000\",\"CreditMessageDetails\":[{\"CreditMessage\":\"\",\"CreditMessageCode\":\"N\"},{\"CreditMessage\":\"\",\"CreditMessageCode\":\"\"}]},\"Header\":{\"Sender\":{\"ServiceName\":\"GetMROMessages\",\"SenderID\":\"CSS\",\"MessageID\":\"ee2642dd-eea9-45d0-a8c1-797245e1e889\"},\"Status\":\"SUCCESS\",\"Target\":{\"TargetID\":\"MOVEX\"},\"ReturnCodeDescription\":\"Request processed successfully\",\"Location\":{\"LocationID\":\"05340-05351\"}}}';
        return json;
    }
    
    public static String getMROMessageJSON() {
        String json = '{'+
            '  \"DataArea\": {'+
            '    \"Status\": \"SUCCESS\",'+
            '    \"CustomerCode\": 3220141,'+
            '    \"ReturnCodeDescription\": \"Request processed successfully\",'+
            '    \"MessageDetails\": ['+
            '      {'+
            '        \"Priority\": 1,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"***Banking Details***\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"Cummins South Pacific Pty Ltd\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"Australia and New Zealand Banking Group Limited (ANZ)\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"Level 4, 100 Queen Street, Melbourne, VIC 3000\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"Account No: 836551902   BSB: 013 479\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"Swift Code: ANZBAU3M\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"Please include in the payment reference the account\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"number and invoice number being paid\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 16509'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"CHANGE ENVIRO LEVY IN COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"This engine serial number is in the Mid Range engine\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"family and attracts a $15 Enviromental Levy fee for Retail\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"invoice.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"Change the Enviro Levy to $15 in COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"Use Panel Sequence YZ31 or select option 13 from COS100\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"screen\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 4597'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"CHANGE ENVIRO LEVY IN COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"This engine serial number is in the High Horse Power engine\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"family and attracts a $45 Enviromental Levy fee for Retail\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"invoice.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"Change the Enviro Levy to $45 in COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"Use Panel Sequence YZ31 or select option 13 from COS100\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"screen\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 4598'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"CHANGE ENVIRO LEVY IN COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"This engine serial number is in the High Horse Power engine\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"family and attracts a $45 Enviromental Levy fee for Retail\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"invoice.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"Change the Enviro Levy to $45 in COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"Use Panel Sequence YZ31 or select option 13 from COS100\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"screen\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 4599'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"CHANGE ENVIRO LEVY IN COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"This engine serial number is in the Mid Range engine\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"family and attracts a $15 Enviromental Levy fee for Retail\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"invoice.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"Change the Enviro Levy to $15 in COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"Use Panel Sequence YZ31 or select option 13 from COS100\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"screen\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 4600'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"CHANGE ENVIRO LEVY IN COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"This engine serial number is in the Mid Range engine\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"family and attracts a $15 Enviromental Levy fee for Retail\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"invoice.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"Change the Enviro Levy to $15 in COS103/B\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"Use Panel Sequence YZ31 or select option 13 from COS100\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"screen\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 4601'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"ISF Engines in Foton vehicles will have a worldwide coverage\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"certificate applied to align the engine with the vehicle\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"coverage.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"For coverage detail go to http://wwec.cummins.com\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"and enter the engine number.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"The certificate and program detail must be included in the\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"warranty text for any covered repair beyond the ISF base\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"engine coverage. Please also update the engine prospect with\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 11,'+
            '            \"MessageText\": \"coverage certificate &amp; program details. If an engine does\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 12,'+
            '            \"MessageText\": \"not have a coverage certificate please e-mail (TPD) with the\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 13,'+
            '            \"MessageText\": \"engine detail to be escalated to BFCEC &amp; Foton.\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 9199'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"ISF Engines in Foton vehicles will have a worldwide coverage\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"certificate applied to align the engine with the vehicle\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"coverage.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"For coverage detail go to http://wwec.cummins.com\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"and enter the engine number.\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"The certificate and program detail must be included in the\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"warranty text for any covered repair beyond the ISF base\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"engine coverage. Please also update the engine prospect with\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 11,'+
            '            \"MessageText\": \"coverage certificate &amp; program details. If an engine does\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 12,'+
            '            \"MessageText\": \"not have a coverage certificate please e-mail (TPD) with the\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 13,'+
            '            \"MessageText\": \"engine detail to be escalated to BFCEC &amp; Foton.\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 9200'+
            '      },'+
            '      {'+
            '        \"Priority\": 5,'+
            '        \"TextDetails\": ['+
            '          {'+
            '            \"LnNo\": 1,'+
            '            \"MessageText\": \"Prior to commencing any works on ISF engines in Foton\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 2,'+
            '            \"MessageText\": \"Application please contact:\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 3,'+
            '            \"MessageText\": \"\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 4,'+
            '            \"MessageText\": \"Tim Williams\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 5,'+
            '            \"MessageText\": \"National Service Manager\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 6,'+
            '            \"MessageText\": \"FOTON TRUCKS AUSTRALIA\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 7,'+
            '            \"MessageText\": \"862-874 Elizabeth St, Waterloo NSW 2017\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 8,'+
            '            \"MessageText\": \"Locked Bag 5018, Alexandria NSW 2015\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 9,'+
            '            \"MessageText\": \"Tel: +61 2 8577 8037\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 10,'+
            '            \"MessageText\": \"Fax: +61 2 8577 8199\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 11,'+
            '            \"MessageText\": \"Mob: +61 4 5887 7731\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 12,'+
            '            \"MessageText\": \"Email: twilliams@ateco.com.au\"'+
            '          },'+
            '          {'+
            '            \"LnNo\": 13,'+
            '            \"MessageText\": \"www.fotontrucks.com.au\"'+
            '          }'+
            '        ],'+
            '        \"MessageID\": 9712'+
            '      }'+
            '    ]'+
            '  },'+
            '  \"Header\": {'+
            '    \"Sender\": {'+
            '      \"ServiceName\": \"GetMROMessages\",'+
            '      \"SenderID\": \"CSS\",'+
            '      \"MessageID\": \"c5d2e11a-653e-40f1-baf8-ddd125c3dd40\"'+
            '    },'+
            '    \"Status\": \"\",'+
            '    \"Target\": {'+
            '      \"TargetID\": \"MOVEX\"'+
            '    },'+
            '    \"ReturnCodeDescription\": \"\",'+
            '    \"Location\": {'+
            '      \"LocationID\": \"05340-05351\"'+
            '    }'+
            '  }'+
            '}';
        FSL_CL_MROMessageData obj = FSL_CL_MROMessageData.parse(json);
        System.debug('::: JSON Obj - '+obj);
        return json;
    }
    
    public static String getPickListOptions() {
        String jsonString = '{'+
            '  \"controllerValues\": {'+
            '    '+
            '  },'+
            '  \"defaultValue\": {'+
            '    \"attributes\": null,'+
            '    \"label\": \"Select One\",'+
            '    \"validFor\": ['+
            '      '+
            '    ],'+
            '    \"value\": \"Select One\"'+
            '  },'+
            '  \"url\": \"/services/data/v41.0/ui-api/object-info/CSS_JobForms__c/picklist-values/0121D000000Gb2BQAS/Task_Category__c\",'+
            '  \"values\": ['+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Select One\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Select One\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"ATS\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"ATS\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Auto – Fire Truck\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Auto – Fire Truck\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Auto -Other\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Auto -Other\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Auto-RV\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Auto-RV\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Auto-Truck- Bus\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Auto-Truck- Bus\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"CNG-LNG\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"CNG-LNG\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Crane\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Crane\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Engine/Vehicle Cleaning\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Engine/Vehicle Cleaning\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Engine- Assembly\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Engine- Assembly\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Engine-Disassembly\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Engine-Disassembly\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Fire Pump\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Fire Pump\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Gen set\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Gen set\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"HHP- Marine\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"HHP- Marine\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"HHP- Other\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"HHP- Other\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"HHP Rail\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"HHP Rail\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Ind- Agriculture\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Ind- Agriculture\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Ind- Constr- Logging\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Ind- Constr- Logging\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Ind-Other\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Ind-Other\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Leisure Boat\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Leisure Boat\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Loading/Unloading\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Loading/Unloading\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Load Test\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Load Test\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Marine - Non HHP\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Marine - Non HHP\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Mining\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Mining\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Offshore Oil Rig\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Offshore Oil Rig\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Oil-Gas HHP\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Oil-Gas HHP\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Other\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Other\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Other – Allied\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Other – Allied\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Paint\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Paint\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Parts Cleaning\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Parts Cleaning\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"PG-Consumer\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"PG-Consumer\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"PG-G Drive\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"PG-G Drive\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"PG-Other\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"PG-Other\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"PG-Rental\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"PG-Rental\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"PG-Switches-Switchgear\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"PG-Switches-Switchgear\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"PM\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"PM\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Propulsion\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Propulsion\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Repair\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Repair\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Start-Up\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Start-Up\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Test Cell\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Test Cell\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"Upfit\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"Upfit\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"PG-Comm Greater Than  200KW\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"PG-Comm Greater Than  200KW\"'+
            '    },'+
            '    {'+
            '      \"attributes\": null,'+
            '      \"label\": \"PG-Commercial Less Than 200KW\",'+
            '      \"validFor\": ['+
            '        '+
            '      ],'+
            '      \"value\": \"PG-Commercial Less Than 200KW\"'+
            '    }'+
            '  ]'+
            '}';
        
        return jsonString;
    }
}