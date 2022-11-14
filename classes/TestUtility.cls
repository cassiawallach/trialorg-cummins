@isTest
public with sharing class TestUtility {
    public TestUtility() {

    }
// Started by Naga Anusha Devi Malepati,8/18/22,SFHA Sonarqube Quality validation(duplicate lines) NIN-500
    public static Account createTestAccount( String Name, Id accRecId){
        Account acc = new Account();
        acc.name=name;
        acc.recordTypeId = accRecId;
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.IAM_Service_Provider_Code__c = '56255';
        acc.Type = 'Customer'; 
        acc.CSS_DBCode__c = '33333';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
         
        
        insert acc;        
        return acc;
    }
    
    public static Asset createTestAsset(Account acc,String typePSN){
         Asset  ast = new Asset();
        ast.Account = acc; 
        ast.Service_Model__c = 'ISL9 CM2350 L101';
        ast.Unit_Number__c = '1234';
        ast.Make__c = 'KENWORTH'; 
        ast.Model__c = 'T800';
        ast.Name = '79963830';
        ast.Unit_Type__c = 'EQ8349';
        ast.VIN__c = '1NKDX4TX6JJ180253';
        ast.Type_PSN__c = typePSN;
        ast.Application_Description__c = 'AUTOMOTIVE';
        ast.Application_Code__c = '130';
        ast.Engine_Family__c    ='56'; 
        ast.Type__c = 'Engines';
        insert ast;
        return ast;
    }
    
    
    public static Case createTestCase(Id acc,Id ast){
        Case  cs = new Case();
        cs.Status = 'Intake';
        cs.AccountId = acc;
        cs.AssetId = ast;
        cs.Priority = 'Medium';
        
        insert cs; 
        return cs;
    }
    
    public static WorkOrder createTestWorkOrder(Account acc,id DealerRTID,Asset ast,Case cs){
        workorder wo1 = new workorder();
        wo1.Account = acc;
        wo1.RecordTypeId = DealerRTID;
        wo1.Process_Step__c = 'Repair';
        wo1.Asset = ast;
        wo1.Application__c = '130 - AUTOMOTIVE';
       
        wo1.EditComplaint__c = 'Testing';
        wo1.EditCause__c = 'Testing';
        wo1.EditCorrection__c = 'Testing';
        wo1.EditCoverage__c = 'Testing';
        wo1.Type__c = 'Dealer';
        wo1.Case = cs;
        wo1.sub_status__c = 'Troubleshooting Complete';
        wo1.EVL_Customer__c ='ABCDEFGHIJKLMNOPQRSTUVWXYZIt is More than 30 chracters test';
        insert wo1;
        return wo1;
    }
    
    public static CSS_List_Of_Values__c createCSSListValue(String pickVal1,String pickVal2, String pickVal3,String type, String code){
        CSS_List_Of_Values__c css = new CSS_List_Of_Values__c();
        css.Name='test'+math.random();
        css.Picklist_Values_1__c= pickVal1;
        css.Picklist_Values_2__c= pickVal2;
        css.Picklist_Values_3__c= pickVal3;
        css.Type__c=type;
        css.Code__c=code;
        Insert css; 
        return css;
    }
    
    public static CSS_Integration_Details__c createIntegrationDetails(){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='RSWClaim';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='RSWClaim';
        conDetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/information';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='UCAWpwjTAyl9GA07EtVfLE7ZRneHQbe9tFdQr3Scppo=';
        conDetails.Passcode__c='xfgYI9ubUYW1DHPjNJc1D46rhF7KFaYTDXTKB7IHweTwtHB2a3pOLEzY9fzjEWfVtHba+M8T7lk6BE5CvumgPA==';
        conDetails.Username__c='4AX7rk2oT4dNFvlO4NkqAhab+2T05ZVujysERwTX+I8ZCVZW5YStPHB8DyYk8G07M8aHo6uYsZeBYRX73F4ciQ==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';        
        insert conDetails;
        return conDetails;
    }
    // Ended by Naga Anusha Devi Malepati,8/18/22,SFHA Sonarqube Quality validation(duplicate lines) NIN-500
    
    //Changes made by Adam for NIN-469
    public static CSS_Job_Order__c createJobOrder(String newUser, String status){
        CSS_Job_Order__c cjo = new CSS_Job_Order__c();
        cjo.Customer_Name__c = 'Wonder Trucks';
        cjo.Assigned_To__c=newUser;
        cjo.Additional_Tech1__c=newUser;
        cjo.Additional_Tech2__c=newUser;
        cjo.Status__c=status;
        cjo.DSID__c='DSBDT2274';
        cjo.unit_number__c='12345';
        cjo.createdDate=system.now().addDays(-109);
        cjo.Shop_Work_Order__c='abcd';
        cjo.ESN__c='79704393';
        cjo.DSID_UpdateTimestamp__c=System.now();
        cjo.INSITE_UpdateTimeStamp__c=System.now();
        cjo.Mileage__c=9.9;
        cjo.Service_Model__c = 'werwe';
        cjo.Category__c = 'Leak';
        cjo.Complaint_Type__c = 'Air Leak';
        
        return cjo;
    }
    
    public static CSS_Job_Order__c newJobOrder(){
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.createdDate=dateTime.now();
        JO.ESN__c = '79704393';
        JO.Customer_Name__c='test';
        JO.Shop_Work_Order__c='uiafh';
        JO.Mileage__c=123;
        JO.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        JO.Category_Desc__c = 'Fuel - Oil - Coolant';
        JO.Status__c = 'closed';
        JO.Service_Model__c = 'model';
        
        return JO;
        
    }
    
    public static CSS_Fault_Code__c newFaultCodeObj(string woID, string cjoID){
        CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
        fcObj.Name = 'test';
        fcObj.Primary_Fault_Code__c = 6;
        fcObj.Service_Order__c = woId;
        fcObj.isPole__c = true;
        fcObj.PoleMessage__c = true;
        fcObj.Service_Order__c=woId;
        fcObj.Sequence__c = 3;
        fcObj.Mod__c = 'test';
        fcObj.Job_Order__c = cjoId;
        fcObj.Fault_Code_Type__c ='New';
        fcObj.Related_Fault_Code__c = 'abc';
        fcObj.Number_of_Solutions__c = '60';
        fcObj.CreatedDate = system.now().addDays(-109);
        
        return fcObj;
    }
    
    public static CSS_Fault_Code__c newFaultCodeObj2(string woID, string cjoID){
        CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
        fcObj.Name = 'test';
        fcObj.Primary_Fault_Code__c = 6;
        fcObj.Job_Order__c = cjoID;
        fcObj.Service_Order__c = woID;
        fcObj.isPole__c = true;
        fcObj.Service_Order__c = woID;
        fcObj.Job_Order__c = cjoID;
        fcObj.PoleMessage__c = true;
        fcObj.Sequence__c = 3;
        fcObj.Mod__c = 'test';
        fcObj.Fault_Code_Type__c ='New';
        fcObj.Related_Fault_Code__c = 'abc';
        fcObj.Number_of_Solutions__c = '60';
        fcObj.CreatedDate = system.now().addDays(-109);
        
        return fcObj;
    }
    
    public static CSS_Fault_Code__c FcObj(String woID, String woID1){
        CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
        fcObj.Name = 'test';
        fcObj.Primary_Fault_Code__c = 6;
        fcObj.Service_Order__c = woID1;
        fcObj.isPole__c = true;
        fcObj.Service_Order__c = woID;
        fcObj.PoleMessage__c = true;
        fcObj.Sequence__c = 3;
        fcObj.Mod__c = 'test';
        fcObj.Fault_Code_Type__c ='New';
        fcObj.Related_Fault_Code__c = 'abc';
        fcObj.Number_of_Solutions__c = '60';
        fcObj.CreatedDate = system.now().addDays(-29);
        
        return fcObj;
    }
    
    public static CSS_Fault_Code__c FcObj2(String woID){
        CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
        fcObj.Name = 'test';
        fcObj.Primary_Fault_Code__c = 6;
        fcObj.isPole__c = true;
        fcObj.Service_Order__c = woID;
        fcObj.PoleMessage__c = true;
        fcObj.Sequence__c = 3;
        fcObj.Mod__c = 'test';
        fcObj.Fault_Code_Type__c ='New';
        fcObj.Related_Fault_Code__c = 'abc';
        fcObj.Number_of_Solutions__c = '60';
        fcObj.CreatedDate = system.now().addDays(-29);
        
        return fcObj;
    }
    public static CSS_SymptomQA__c newSym (String cjoID){
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=cjoID;
        sym.Name = 'Black Smoke';
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c ='1asdsad2213';
        sym.Type__c  ='SearchString';
        sym.createdDate=system.now().addDays(-109);
        
        return sym;
    }
    
    public static CSS_SymptomQA__c newSymWithWO(String woID){
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Service_Order__c=woID;
        sym.Name = 'Black Smoke';
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='1asdsad2213';
        sym.Type__c  ='SearchString';
        sym.createdDate=system.now().addDays(-29);
        
        return sym;
    }
    
    public static CSS_Solutions__c newSol(String woID){
        CSS_Solutions__c sol=new CSS_Solutions__c();
        sol.Case_Name__c='test';
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair not performed.';
        sol.Repair_Notes__c='Test';
        sol.FSL_Service_Job__c=woId;
        sol.createdDate=system.now().addDays(-109);
        
        return sol;
    }
    
    public static CSS_Solutions__c newSol2(String woID, String fcobjID){
        CSS_Solutions__c sol=new CSS_Solutions__c();
        sol.Case_Name__c='test';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.Repair_Notes__c='test';
        sol.FaultCode__c = fcObjID;
        sol.FSL_Service_Job__c=woID;
        sol.createdDate=system.now().addDays(-29);
        
        return sol;
    }
    
    public static CSS_Solutions__c newSol3(String symID, String woID, string fcObjID, String cjoID){
        CSS_Solutions__c sol=new CSS_Solutions__c();
        sol.Case_Name__c='test';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.Repair_Notes__c = 'test';
        sol.Symptom__c=symID;
        sol.Service_Job__c=cjoID;
        sol.FSL_Service_Job__c = woID;
        sol.FaultCode__c=fcObjID;
        sol.createdDate=system.now().addDays(-29);
        
        return sol;
    }
    
    public static CSS_Solutions__c newSol4(String woID, String symID){
        CSS_Solutions__c sol=new CSS_Solutions__c();
        sol.Case_Name__c='test';
        sol.Symptom__c = symID;
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair not performed.';//'Repair Successful.';
        sol.Repair_Notes__c='test';
        sol.FSL_Service_Job__c=woID;
        sol.createdDate=system.now().addDays(-29);
        
        return sol;
    }
    
    public static CSS_Solution_Component__c newSolComp(String solID, String woID){
        CSS_Solution_Component__c solCmp = new CSS_Solution_Component__c();
        solCmp.Solutions__c = solID;
        solCmp.Name = 'Turbo';
        solCmp.Component_Code__c = 'AV';
        solCmp.System_Code__c = 'FH';
        solCmp.Performed_Review__c = true;
        solCmp.FSL_FA_Service_Order__c = woID;
        solCmp.FSL_Service_Job__c = woID;
        solCmp.FSL_Account_Code__c = 'New Parts Warranty - 62';
        
        return solCmp;
    }
    
    public static CSS_Solution_Component__c newSolComp2(String woID, String solID){
        CSS_Solution_Component__c solCmp = new CSS_Solution_Component__c();
        solCmp.Solutions__c = solID;
        solCmp.Name = 'Turbo';
        solCmp.Component_Code__c = 'AV';
        solCmp.System_Code__c = 'FH';
        solCmp.Performed_Review__c = true;
        solCmp.FSL_FA_Service_Order__c = woID;
        solCmp.FSL_Service_Job__c = woID;
        solCmp.FSL_Account_Code__c = 'New Parts Warranty - 62';
        solCmp.Type__c = 'cam';
        solCmp.Campaign_Description__c = 'xyz';
        solCmp.FSL_Link__c ='www.test.com' ;
        
        return solCmp;
    }
    
    public static FSL_SRT__c newSrtVar (String woID, String solServiceJob){
        FSL_SRT__c srtVar = new FSL_SRT__c();
        srtVar.Service_Order__c = woID;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test'+Math.random();
        srtVar.Type__c = 'typ';
        srtVar.Repair_SRTs__c = solServiceJob;
        srtVar.isPerformed__c =True;
        
        return srtVar;
    }
    
    public static FSL_SRT__c newSrtVar2(string woID){
        FSL_SRT__c srtVar = new FSL_SRT__c();
        srtVar.Service_Order__c = woID;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test'+Math.random();
        srtVar.Type__c = 'typ';
        srtVar.isPerformed__c =True;
        srtVar.Repair_SRTs__c =woID;
        
        return srtVar;
    }
    
    public static FSL_SRT__c newSrtVar3(String woID, String solID, String solServJob){
        FSL_SRT__c srtVar = new FSL_SRT__c();
        srtVar.Solution_Number__c = solID;
        srtVar.Service_Order__c = woID;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test'+Math.random();
        srtVar.Type__c = 'typ';
        srtVar.isPerformed__c =True;
        srtVar.Repair_SRTs__c =solServJob;
        
        return srtVar;            
    }
    
    public static CSS_JobEventTemporary__c newJobEvent(){
        Set<String> setArray = new Set<String> {'MI', 'KM', 'HR1'};
        List<String> attributeArray = new List<String>(); 
        attributeArray.addAll(setArray);
        Double randomNumber = Math.random(); 
        Integer arrayLength = attributeArray.size(); 
        Integer randomIndex = (randomNumber *(arrayLength-1)).intValue(); 
        
        CSS_JobEventTemporary__c je=new CSS_JobEventTemporary__c();
        Double varNum = ((math.random()+1)*12);
        je.key__c='79704393';
        je.Attribute1__c = 'Att' + varNum;
        je.Attribute2__c = 'Att' + varNum;
        je.Attribute3__c = 'Att' + varNum;
        je.Attribute4__c = 'Att' + varNum;
        je.Attribute5__c = 'Att' + varNum;
        je.Attribute6__c = 'Att' + varNum;
        je.Attribute7__c = 'Att' + varNum;
        je.Attribute8__c = 'Att' + varNum;
        je.Attribute9__c = attributeArray[randomIndex];
        je.Attribute14__c = '91821';
        je.Attribute13__c = system.now().addDays(-110);
        
        return je;
    }
    public static Contact createNewCon(String accID, Id conRecId){
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='9895634567';
        con.Email='av456@cummins.com';
        con.AccountId=accID;
        insert con;
        return con;
    }
    
    public static Case createTestCasewithContact(Id acc,Id asst, Id con){
        Case  cs = new Case();
        cs.AccountId = acc;
        cs.Description='test symptoms';
        cs.AssetId = asst;
        cs.ContactId = con;
        cs.Priority = 'Medium';
        
        insert cs; 
        return cs;
    }
    
    public static WorkOrder createNewWorkOrder(Id st, Id acc, Id con, Id asst){
        Double varNumMiles = ((math.random()+1)*75000);
        Double varNumHours = ((math.random()+1)*200);
        WorkOrder wo = new WorkOrder();
        wo.ServiceTerritoryId=sT;
        wo.AccountId=acc;
        wo.ContactId=con;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=asst;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.SelectedSolution__c='abc';
        wo.Process_Step__c = 'Repair';
        wo.Category1__c = 'Leak';
        wo.Complaint_Type1__c='Air Leak';
        wo.Shop_Work_Order__c = 'test';
        wo.Mileage__c = varNumMiles;
        wo.CSS_Hours__c = varNumHours;
        wo.Mileage_Measure__c = 'MILES';
        wo.Service_Model__c = 'New';
        return wo;
    }
    
    public static CSS_Integration_Details__c newConDetails(){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/gettoken';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'OAGOAuth';
        
        return conDetails;
    }
    
    public static CSS_Integration_Details__c newConDetails2(){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.name= 'FSL_MoveX_ServiceHistory';
        conDetails.End_Point__c= 'https://test.Com/getServiceHistory';
        conDetails.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
        conDetails.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
        conDetails.IsActive__c = true;
        conDetails.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
        
        return conDetails;
    }
    
    public static FSL_Labor_Multiplier__c newLaborMulti(String name){
        FSL_Labor_Multiplier__c lm = new FSL_Labor_Multiplier__c();
        lm.Name = name;
        insert lm;
        return lm;
        
    }
    
    public static Asset createNewAssetWithLabor(Id accID, ID lmID){
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.Labor_Multiplier__c = lmID;
        asst.AccountId=accID;
        asst.Safety_Requirement__c=True;
        asst.Type__c='Engines';
        asst.Type_PSN__c='Engines-79644334';
        asst.Application_Code__c='234';
        asst.Individual__c ='';
        insert asst;
        return asst;
    }
    
    public static Case createNewCase(Id accID, Id conID, Id asstID, Id stID, Id bhsID){
        case cs=new case();
        cs.AccountId=accID;
        cs.ContactId=conID;
        cs.AssetId=asstID;
        cs.Description='test symptoms';
        cs.Service_Territory__c=stID;
        cs.BusinessHoursId=bhsID;
        insert cs;
        return cs;
    }
    
    public static WorkType newWorkType(){
        WorkType wt=new WorkType();
        wt.Name='Test work type';
        wt.EstimatedDuration=60.00;
        insert wt;
        return wt;
    }
    
    public static WorkOrder createNewWorkOrderWithWT(Id accID, Id conID, Id asstID, Id stID, Id wtID){
        WorkOrder wo = new WorkOrder();
        wo.ServiceTerritoryId=stID;
        wo.AccountId=accID;
        wo.ContactId=conID;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=asstID;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.SelectedSolution__c='abc';
        wo.createdDate=system.now().addDays(-109);
        wo.Process_Step__c = 'Repair';
        wo.Status = 'Repair';
        wo.CSS_Hours__c =  1000;
        wo.Category1__c = 'Leak';
        wo.Complaint_Type1__c='Air Leak';
        wo.Mileage__c = 234569.29;
        wo.CSS_Hours__c = 202;
        wo.Mileage_Measure__c = 'MILES';
        wo.WorkTypeId= wtID;
        
        return wo;
    }
    
    public static WorkOrder createNewWorkOrderWithWT2(Id accID, Id conID, Id asstID, Id stID, Id wtID){
        WorkOrder wo = new WorkOrder();
        wo.ServiceTerritoryId=stID;
        wo.AccountId=accID;
        wo.ContactId=conID;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=asstID;
        wo.Category1__c = 'Leak';
        wo.Complaint_Type1__c='Air Leak';
        wo.Available_for_Service__c=datetime.now()+3;
        wo.SelectedSolution__c='abc';
        wo.Process_Step__c = 'Repair';
        wo.Shop_Work_Order__c = 'test';
        wo.Mileage__c = 2232.21;
        wo.CSS_Hours__c = 202;
        wo.Mileage_Measure__c = 'MILES';
        wo.Service_Model__c = 'New';
        wo.WorkTypeId= wtID;
        
        return wo;
    }
    
    public static ServiceResource createServiceResource(Id newUser, String name, Boolean active, Boolean techUser){
        ServiceResource sr=new ServiceResource();
        sr.Name= name;
        sr.IsActive=active;
        sr.RelatedRecordId=newUser;
        sr.ResourceType='T';
        sr.Is_a_Tech__c=techUser;
        
        insert sr;
        return sr;
    }
//ended changes by Adam

    public static WorkType createWorktype(String worktypeName, Double estDuration, String durationType){

        WorkType testWorkType = new WorkType(Name = worktypeName,
                                            EstimatedDuration = estDuration,
                                            DurationType = durationType);

        insert testWorkType;                            
        return testWorkType;

    }


    public static OperatingHours createOperatingHours(String ohName){

        OperatingHours testOperatingHours = new OperatingHours(Name = ohName);
        testOperatingHours.Name = ohName;
        testOperatingHours.TimeZone = 'America/Chicago';
        
        insert testOperatingHours;
        return testOperatingHours;

    }

    public static OperatingHours createOperatingHours(String ohName, String tz){

        OperatingHours testOperatingHours = new OperatingHours(Name = ohName, 
                                                               TimeZone = tz);
        
        insert testOperatingHours;
        return testOperatingHours;

    }


    public static ServiceTerritory createServiceTerritory(String territoryName,Boolean active, String opHoursId){

        ServiceTerritory testServiceTerritory = new ServiceTerritory(Name = territoryName,
                                                                     IsActive = active,
                                                                     OperatingHoursId = opHoursId, 
                                                                     Location_Code__c	='03250-02851',Region__c = 'AUSTRALIA/ NEW ZEALAND', Territory__c = 'AUSTRALIA',
                                                                     FSL_Service_Territory_Code__c='02851');

        insert testServiceTerritory;
        return testServiceTerritory;

    }


    public static ServiceResource createServiceResource(String resourceName, Boolean active, String relatedRecord, String resourceType){

        ServiceResource testServiceResource = new ServiceResource(Name = resourceName,
                                                                  IsActive = active,
                                                                  relatedRecordId = relatedRecord,
                                                                  ResourceType = resourceType);

        insert testServiceResource;
        return testServiceResource;

    }


    public static ServiceTerritoryMember createServiceTerritoryMember(String resourceId, String territoryId, Datetime startDate){

        ServiceTerritoryMember testStm = new ServiceTerritoryMember(ServiceResourceid = resourceId,
                                                                    ServiceTerritoryId = territoryId,
                                                                    EffectiveStartDate = startDate);

        insert testStm;
        return testStm;

    }

    public static Map<String,SObject> createSingleTestResource(){

        String objectName = '';
        Map<String, SObject> testResourceObjectMap = new Map<String, SObject>();
        String userId = UserInfo.getUserId();
        String testName = 'test' + String.valueOf(Crypto.getRandomInteger());

        WorkType testWorkType = createWorkType(testName, 1, 'hours');
        objectName = 'WorkType';
        testResourceObjectMap.put(objectName, testWorkType);

        OperatingHours testOh = createOperatingHours(testName);
        objectName = 'OperatingHours';
        testResourceObjectMap.put(objectName, testOh);

        ServiceTerritory testTerritory = createServiceTerritory(testName, true, testOh.Id);
        objectName = 'ServiceTerritory';
        testResourceObjectMap.put(objectName, testTerritory);

        ServiceResource testResource = createServiceResource(testName, true, userId, 'T');
        objectName = 'ServiceResource';
        testResourceObjectMap.put(objectName, testResource);

        ServiceTerritoryMember testSTM = createServiceTerritoryMember(testResource.Id, testTerritory.Id, datetime.now());
        objectName = 'ServiceTerritoryMember';     
        testResourceObjectMap.put(objectName, testSTM);
        return testResourceObjectMap;

    }


    public static Map<String,SObject> createSingleTestResource(String userId){

        String objectName = '';
        Map<String, SObject> testResourceObjectMap = new Map<String, SObject>();
        String testName = 'test' + String.valueOf(Crypto.getRandomInteger());

        WorkType testWorkType = createWorkType(testName, 1, 'hours');
        objectName = 'WorkType';
        testResourceObjectMap.put(objectName, testWorkType);

        OperatingHours testOh = createOperatingHours(testName);
        objectName = 'OperatingHours';
        testResourceObjectMap.put(objectName, testOh);

        ServiceTerritory testTerritory = createServiceTerritory(testName, true, testOh.Id);
        objectName = 'ServiceTerritory';
        testResourceObjectMap.put(objectName, testTerritory);

        ServiceResource testResource = createServiceResource(testName, true, userId, 'T');
        objectName = 'ServiceResource';
        testResourceObjectMap.put(objectName, testResource);

        ServiceTerritoryMember testSTM = createServiceTerritoryMember(testResource.Id, testTerritory.Id, datetime.now());
        objectName = 'ServiceTerritoryMember';        
        testResourceObjectMap.put(objectName, testSTM);

        return testResourceObjectMap;

    }


    public static WorkOrder createWorkOrder(){

        WorkOrder testWorkOrder = new WorkOrder();
        insert testWorkOrder;
        return testWorkOrder;

    }


    public static WorkOrder createWorkOrder(String subject, String workTypeId, String serviceTerritoryId){

        WorkOrder testWorkOrder = new WorkOrder(Subject = subject,
                                                WorkTypeId = workTypeId,
                                                ServiceTerritoryId = serviceTerritoryId);

        insert testWorkOrder;
        return testWorkOrder;

    }


    public static ServiceAppointment createServiceAppointment(String mrServiceResourceID, String parentRecordId, Datetime earlyStart, Datetime dueDate, Datetime schedStart, Datetime schedEnd){

        ServiceAppointment testServiceAppointment = new ServiceAppointment(MR_Service_Resource__c = mrServiceResourceID,
                                                                           ParentRecordId = parentRecordId,
                                                                           EarliestStartTime = earlyStart,
                                                                           DueDate = dueDate,
                                                                           SchedStartTime = schedStart,
                                                                           SchedEndTime = schedEnd);
        
        insert testServiceAppointment;
        return testServiceAppointment;

    }


    public static ServiceAppointment createServiceAppointment(String mrServiceResourceID, String parentRecordId, Datetime earlyStart, Datetime dueDate, Datetime schedStart, Datetime schedEnd, String status){

        ServiceAppointment testServiceAppointment = new ServiceAppointment(MR_Service_Resource__c = mrServiceResourceID,
                                                                           ParentRecordId = parentRecordId,
                                                                           EarliestStartTime = earlyStart,
                                                                           DueDate = dueDate,
                                                                           SchedStartTime = schedStart,
                                                                           SchedEndTime = schedEnd,
                                                                           Status = status);
        
        insert testServiceAppointment;
        return testServiceAppointment;

    }


    public static ServiceAppointment createServiceAppointment(String mrServiceResourceID, String parentRecordId, Datetime earlyStart, Datetime dueDate, Datetime schedStart, Datetime schedEnd, String status, String territoryId){

        ServiceAppointment testServiceAppointment = new ServiceAppointment(MR_Service_Resource__c = mrServiceResourceID,
                                                                           ParentRecordId = parentRecordId,
                                                                           EarliestStartTime = earlyStart,
                                                                           DueDate = dueDate,
                                                                           SchedStartTime = schedStart,
                                                                           SchedEndTime = schedEnd,
                                                                           Status = status,
                                                                           ServiceTerritoryId = territoryId);
        
        insert testServiceAppointment;
        return testServiceAppointment;

    }


    public static ResourceAbsence createResourceAbsence(String resourceId, Datetime startDate, Datetime endDate){

        final Id NONAVAILABILITY_RECORDTYPE = Schema.SObjectType.ResourceAbsence.getRecordTypeInfosByName().get('Non Availability').getRecordTypeId();
        ResourceAbsence testAbsence = new ResourceAbsence(ResourceId = resourceId,
                                                           Start = startDate,
                                                           End = endDate,
                                                           RecordTypeId = NONAVAILABILITY_RECORDTYPE);

        insert testAbsence;
        return testAbsence;

    }


    public static AssignedResource createAssignedResource(String serviceAppointmentId, String serviceResourceId){

        AssignedResource testAssignedResource = new AssignedResource(ServiceResourceId = serviceResourceId, 
                                                                     ServiceAppointmentId = serviceAppointmentId);

        insert testAssignedResource;
        return testAssignedResource;

    }


    public static List<User> createUser(Integer numberOfUsersToCreate){

        List<User> testUserList = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        Integer i = 0;

        while(i < numberOfUsersToCreate){

            User u = new User(Alias = 'standt' + i, 
                          Email='standarduser' + i + '@example.com', 
                          EmailEncodingKey='UTF-8', 
                          LastName='Testing', 
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', 
                          ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', 
                          UserName='standarduser' + i + '@MRDTReassignTechs.com');

            testUserList.add(u);

            i++;

        }

        insert testUserList;
        return testUserList;

    }


    public static ServiceResourceSkill createServiceResourceSkill(String serviceResourceId){

        Skill testSkill = [SELECT Id FROM Skill LIMIT 1];

        ServiceResourceSkill resourceSkill = new ServiceResourceSkill(ServiceResourceId = serviceResourceId, SkillId = testSkill.Id, EffectiveStartDate = Datetime.now().addDays(-10));
        insert resourceSkill;
        return resourceSkill;

    }


}