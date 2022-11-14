@isTest
public class CG_CL_CovLimitExceedValidation_Test {
    
    public static Testmethod void CovMethod1(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        
        insert acc;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Advanced'];
        
        Contact objContact = new Contact(FirstName='testCon1' ,LastName ='testCon',AccountId = acc.Id ,IAM_Cummins_login_ID__c = 'test@cummins.com');
        insert objContact; 
        
        
        
        User u = new User(Alias = 'standt', Email='standarduser2@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser2@testorg.com',User_Location__c = '02650-97895',ContactId=objContact.id);
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='02650-97895');
        insert userLocation;
        
        system.debug('u****'+u.id);
        
        css_header_nav__c cssHeaderObject = new css_header_nav__c();
        cssHeaderObject.Name = 'Test Setting';
        cssHeaderObject.RSWButtonEnable__c = true;
        cssHeaderObject.SetupOwnerId=u.Id;
        insert cssHeaderObject;
        
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'CAP';
        jET.Attribute3__c = '70';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'CAP';
        jET1.Attribute3__c = '70';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        insert jETList;
        
        system.runAs(u){
            CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Customer_Name__c = 'CumminsTnD';
            JO.ESN__c = '79464646';
            JO.Mileage_Measure__c='19';
            JO.Failure_Date__c=system.today();
            JO.Qsol_Engine_Family_Code__c='IN';
            JO.Service_Model__c='Fire truck';
            insert JO;
            
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
            testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            //testclaimsRec.CSS_Job__c = JO.id;
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'RdB@nomail.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.Account__c=acc.Id;
            insert testclaimsRec;
            
            List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solcomps = new CSS_Solution_Component__c();
            solcomps.Component_Id__c = 'F19000540';
            solcomps.Selected_Component__c = true;
            solcomps.Service_Job__c = jo.Id;
            solcomps.System_Code__c = 'EQ';
            solcomps.Component_Code__c = 'PE';
            solcomps.Failure_Mode__c = 'HB';
            solcomps.AccountCode__c = '70';
            solcomps.Fail_Code_Editable__c= 'THAC';
            solcomps.AccountCodeType__c = 'EMISSION WARRANTY';
            solcomps.AccountCodeEdit__c = 'EMISSION WARRANTY 70';
            solcomps.CoveredTravelBaseFareAmt__c='100';
            solcomps.CoveredLaborHrs__c = '5';
            solcomps.CoveredPartsQty__c = '1';
            solcomps.CoveredOCAmount__c = '1';
            solcompsList.add(solcomps);
            
            CSS_Solution_Component__c solcomps1 = new CSS_Solution_Component__c();
            solcomps1.Component_Id__c = 'F19000541';
            solcomps1.Selected_Component__c = true;
            solcomps1.Fail_Code_Editable__c= 'THAC';
            solcomps1.Service_Job__c = jo.Id;
            solcomps1.System_Code__c = 'EQ';
            solcomps1.Component_Code__c = 'PE';
            solcomps1.Failure_Mode__c = 'HB';
            solcomps1.AccountCode__c = '70';
            solcomps1.AccountCodeType__c = 'EMISSION WARRANTY';
            solcomps1.AccountCodeEdit__c = 'EMISSION WARRANTY 70';
            solcomps1.CoveredTravelBaseFareAmt__c='100';
            solcomps1.CoveredLaborHrs__c = '5';
            solcomps1.CoveredPartsQty__c = '1';
            solcomps1.CoveredOCAmount__c = '1';
            solcompsList.add(solcomps1);
            
            insert solcompsList;
            
            css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
            //id recordpartid = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
            id recordpartid = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
            List<CSS_Parts_Options__c> ocplist1; 
            List<CSS_Parts_Options__c> ocplist = new List<CSS_Parts_Options__c>();
            List<CSS_Parts_Options__c> paList = new List<CSS_Parts_Options__c>();
            CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
            pa.Option_Number__c = 'O-111';
            pa.Service_Job__c = jo.Id;
            pa.selected_part__c = true;
            pa.FailurepartId__c = solcompsList[0].Id;
            pa.Part_Assignment__c = 'Primary';
            pa.Solutions__c=sol.Id;
            pa.ODM_Status__c='warn';
            pa.ODM_Status_Message__c='Test1;test2;test3';
            pa.ODM_Status_Code__c='500';
            pa.Type__c='Commercial-Travel';
            pa.Item__c='Ties';
            pa.Account_Code__c ='EMISSION WARRANTY 70';
            pa.Quantity__c = 9.0;
            pa.RecordTypeId=recordpartid;
            pa.ExpenseTotal__c =1000;
            pa.Amount__c=500;
            paList.add(pa);
            
            CSS_Parts_Options__c pa1 = new CSS_Parts_Options__c();
            pa1.Option_Number__c = 'O-111';
            pa1.Service_Job__c = jo.Id;
            pa1.selected_part__c = true;
            pa1.FailurepartId__c = solcompsList[0].Id;
            pa1.Part_Assignment__c = 'Primary';
            pa1.Solutions__c=sol.Id;
            pa1.ODM_Status__c='warn';
            pa1.ODM_Status_Message__c='Test1;test2;test3';
            pa1.ODM_Status_Code__c='500';
            pa1.Type__c='Non Commercial-Travel';
            pa1.Item__c='Ties';
            pa1.Account_Code__c ='EMISSION WARRANTY 70';
            pa1.RecordTypeId=recordpartid;
            pa1.ExpenseTotal__c =500;
            pa1.Amount__c=500;
            pa1.Mileage__c=500;
            pa1.Quantity__c=10;
            paList.add(pa1);
            
            CSS_Parts_Options__c pa2 = new CSS_Parts_Options__c();
            pa2.Option_Number__c = 'O-111';
            pa2.Service_Job__c = jo.Id;
            pa2.selected_part__c = true;
            pa2.FailurepartId__c = solcompsList[0].Id;
            pa2.Part_Assignment__c = 'Primary';
            pa2.Solutions__c=sol.Id;
            pa2.ODM_Status__c='warn';
            pa2.ODM_Status_Message__c='Test1;test2;test3';
            pa2.ODM_Status_Code__c='500';
            pa2.Type__c='Meals';
            pa2.Item__c='Ties';
            pa2.Account_Code__c ='EMISSION WARRANTY 70';
            pa2.Quantity__c = 3.0;
            pa2.RecordTypeId=recordpartid;
            pa2.ExpenseTotal__c =500;
            pa2.Amount__c=500;
            pa2.Mileage__c=500;
            paList.add(pa2);
            
            CSS_Parts_Options__c pa3 = new CSS_Parts_Options__c();
            pa3.Option_Number__c = 'O-1112';
            pa3.Service_Job__c = jo.Id;
            pa3.selected_part__c = true;
            pa3.FailurepartId__c = solcompsList[0].Id;
            pa3.Part_Assignment__c = 'Primary';
            pa3.Solutions__c=sol.Id;
            pa3.ODM_Status__c='warn';
            pa3.ODM_Status_Message__c='Test1;test2;test3';
            pa3.ODM_Status_Code__c='500';
            pa3.Type__c='Commercial-Travel';
            pa3.Item__c='Ties';
            pa3.Account_Code__c ='EMISSION WARRANTY 70';
            pa3.Quantity__c = 9.0;
            pa3.RecordTypeId=recTypeIdpartTemp;
            pa3.ExpenseTotal__c =1000;
            pa3.Amount__c=500;
            paList.add(pa3);
            
            insert paList;
            
            List<CSS_SRT__c> srtLst = new List<CSS_SRT__c>();
            CSS_SRT__c srt = new CSS_SRT__c();
            srt.Account_Code__c='PARTS WARRANTY - DEFECT FROM STOCK 35';
            srt.FailCode__c='THAC';
            srt.Type__c='99time';
            srt.CSS_Claims__c=testclaimsRec.Id;
            srt.Extended_Hours__c = 20;
            //srt.Job_Order__c = JO.id;
            srt.isPerformed__c = true;
            srt.Account_Code_Description__c = 'PARTS WARRANTY - DEFECT FROM STOCK 35'; //wenchin
            
            srtLst.add(srt);
            insert srtLst;
            
            
            
            
            CG_CL_CoverageLimitExceedValidation covlimExVal = new CG_CL_CoverageLimitExceedValidation();
            Set<String> covLimExceed = new Set<String>();
            
            covLimExceed=covlimExVal.covLimitValidation(JO.id, null, paList, paList);
            List<Boolean> boolList = new List<Boolean>();
            boolList=covlimExVal.checkFailuresCovered(testclaimsRec.id, true);
            covlimExVal.covLimitValidationSRT(JO.id,testclaimsRec.id);
            covLimExceed=covlimExVal.covLimitValidation(JO.id, null, paList, null);
            covLimExceed=covlimExVal.covLimitValidation(JO.id, null, null, null);
            covLimExceed=covlimExVal.covLimitValidation(JO.id, null, null, ocplist);
            covLimExceed=covlimExVal.covLimitValidation(JO.id, null, null, ocplist1);
            covLimExceed=covlimExVal.covLimitValidation(JO.id, null, paList, ocplist1);
            covlimExVal.covLimitfailcodeValidation(JO.id,null);
            covlimExVal.covLimitfailcodeJobValidation(JO.id,null);
            
           
        }
        
        
    } 
     public static Testmethod void CovMethod61(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        
        insert acc;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Advanced'];
        
        Contact objContact = new Contact(LastName ='testCon',AccountId = acc.Id ,IAM_Cummins_login_ID__c = 'test@cummins.com' ,FirstName='testCon1');
        insert objContact; 
        
        
        
        User u = new User(Alias = 'standt', Email='standarduser2@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser2@testorg.com',User_Location__c = '02650-97895',ContactId=objContact.id);
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='02650-97895');
        insert userLocation;
        
        system.debug('u****'+u.id);
        
        
        
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'NEW';
        jET.Attribute3__c = '62';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'NEW';
        jET1.Attribute3__c = '';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        insert jETList;
        
        system.runAs(u){
            CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Customer_Name__c = 'CumminsTnD';
            JO.ESN__c = '79464646';
            JO.Mileage_Measure__c='19';
            JO.Failure_Date__c=system.today();
            JO.Qsol_Engine_Family_Code__c='IN';
            JO.Service_Model__c='Fire truck';
            insert JO;
            
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
            testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            //testclaimsRec.CSS_Job__c = JO.id;
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'RdB@nomail.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.Account__c=acc.Id;
            insert testclaimsRec;
            
                        
            css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
            //id recordpartid = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
            id recordpartid = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
            List<CSS_Parts_Options__c> ocplist1; 
            List<CSS_Parts_Options__c> ocplist = new List<CSS_Parts_Options__c>();
            css_header_nav__c cssHeaderObject = new css_header_nav__c();
            cssHeaderObject.Name = 'Test Setting';
            cssHeaderObject.RSWButtonEnable__c = true;
            
            insert cssHeaderObject;
            
           
             List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solcomps = new CSS_Solution_Component__c();
            solcomps.Component_Id__c = 'F19000540';
            solcomps.Selected_Component__c = true;
            solcomps.Service_Job__c = jo.Id;
            solcomps.System_Code__c = 'EQ';
            solcomps.Component_Code__c = 'PE';
            solcomps.Failure_Mode__c = 'HB';
            solcomps.AccountCode__c = '70';
            solcomps.Fail_Code_Editable__c= 'THAC';
            solcomps.AccountCodeType__c = 'EMISSION WARRANTY';
            solcomps.AccountCodeEdit__c = 'EMISSION WARRANTY 70';
            solcomps.CoveredTravelBaseFareAmt__c='100';
            solcomps.CoveredLaborHrs__c = '5';
            solcomps.CoveredPartsQty__c = '1';
            solcomps.CoveredOCAmount__c = '1';
            solcompsList.add(solcomps);
            
            CSS_Solution_Component__c solcomps1 = new CSS_Solution_Component__c();
            solcomps1.Component_Id__c = 'F19000541';
            solcomps1.Selected_Component__c = true;
            solcomps1.Fail_Code_Editable__c= 'THAC';
            solcomps1.Service_Job__c = jo.Id;
            solcomps1.System_Code__c = 'EQ';
            solcomps1.Component_Code__c = 'PE';
            solcomps1.Failure_Mode__c = 'HB';
            solcomps1.AccountCode__c = '70';
            solcomps1.AccountCodeType__c = 'EMISSION WARRANTY';
            solcomps1.AccountCodeEdit__c = 'EMISSION WARRANTY 70';
            solcomps1.CoveredTravelBaseFareAmt__c='100';
            solcomps1.CoveredLaborHrs__c = '5';
            solcomps1.CoveredPartsQty__c = '1';
            solcomps1.CoveredOCAmount__c = '1';
            solcompsList.add(solcomps1);
            
            insert solcompsList;

             List<CSS_SRT__c> srtLst = new List<CSS_SRT__c>();
            CSS_SRT__c srt = new CSS_SRT__c();
            srt.Account_Code__c='NEW PARTS WARRANTY 62'; //EMISSION WARRANTY 70-NPW
            srt.FailCode__c='TH-AC';
            //srt.Job_Order__c=JO.id;
            srt.Type__c='99time';
            srt.CSS_Claims__c=testclaimsRec.Id;
            srt.Extended_Hours__c = 20;
            srt.isPerformed__c = true;
            srt.Account_Code_Description__c = 'NEW PARTS WARRANTY 62'; //wenchin// 
            
            srtLst.add(srt);
            insert srtLst;
            
            
            CG_CL_CoverageLimitExceedValidation covlimExVal = new CG_CL_CoverageLimitExceedValidation();
            Set<String> covLimExceed = new Set<String>();
            
            List<Boolean> boolList = new List<Boolean>();
            boolList=covlimExVal.checkFailuresCovered(testclaimsRec.id, true);
            covlimExVal.covLimitValidationSRT(null,testclaimsRec.id);
           
            covLimExceed=covlimExVal.covLimitValidation(JO.id, null, null, null);
            covLimExceed=covlimExVal.covLimitValidation(JO.id, null, null, ocplist);
            covLimExceed=covlimExVal.covLimitValidation(JO.id, null, null, ocplist1);
            
             Map<String,String> accCodeCovTypeMap = new Map<String,String>();
        	accCodeCovTypeMap.put('62','NPW');
        	covlimExVal.accCodeCovTypeMap=accCodeCovTypeMap;
            string covtype1 = 'NPW'; //Anvesh added 
            system.debug(' JO ' + JO);
             covlimExVal.covLimitfailcodeJobValidation(JO.id,null);
            
            covlimExVal.covLimitfailcodeValidation(JO.id,null);
            
           
            
             covlimExVal.covLimitfailcodeJobValidation(JO.id,testclaimsRec.id);
             covlimExVal.covLimitfailcodeJobValidation(null,testclaimsRec.id);            
            
            
           
        }
        
        
    } 
    public static Testmethod void Covererrortypes(){
           List<string> errors = new List<string>();
           errors.add('Commercial-Travel&THAC$NON');
           errors.add('Non Commercial-Travel&THAC$NON');
           errors.add('Non Commercial-Travel&THAC$NON#');
           errors.add('Non Commercial-Travel&THAC#');
           errors.add('Mealslod&THAC$NON');
           errors.add('Mealslod&THAC');
           errors.add('Towing&THAC$NON');
           errors.add('Towing&THAC');
           CG_CL_CoverageLimitExceedValidation.validationerrortypes(errors);
    }
    
    public static Testmethod void CovMethod2(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        
        insert acc;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Advanced'];
        
        Contact objContact = new Contact(LastName ='testCon',AccountId = acc.Id ,IAM_Cummins_login_ID__c = 'test@cummins.com' ,FirstName='testCon1');
        insert objContact; 
        
        
        
        User u = new User(Alias = 'standt', Email='standarduser2@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser2@testorg.com',User_Location__c = '02650-97895',ContactId=objContact.id);
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='02650-97895');
        insert userLocation;
        
        system.debug('u****'+u.id);
        
        css_header_nav__c cssHeaderObject = new css_header_nav__c();
        cssHeaderObject.Name = 'Test Setting';
        cssHeaderObject.RSWButtonEnable__c = true;
        cssHeaderObject.SetupOwnerId=u.Id;
        insert cssHeaderObject;
        
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'CAP';
        jET.Attribute3__c = '70';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'CAP';
        jET1.Attribute3__c = '70';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        insert jETList;
        
        system.runAs(u){
            CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Customer_Name__c = 'CumminsTnD';
            JO.ESN__c = '79464646';
            JO.Mileage_Measure__c='19';
            JO.Failure_Date__c=system.today();
            JO.Qsol_Engine_Family_Code__c='IN';
            JO.Service_Model__c='Fire truck';
            insert JO;
            
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
            testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            //testclaimsRec.CSS_Job__c = JO.id;
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'RdB@nomail.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.Account__c=acc.Id;
            insert testclaimsRec;
            
            List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solcomps = new CSS_Solution_Component__c();
            solcomps.Component_Id__c = 'F19000540';
            solcomps.Selected_Component__c = true;
            solcomps.Service_Job__c = jo.Id;
            solcomps.System_Code__c = 'EQ';
            solcomps.Component_Code__c = 'PE';
            solcomps.Failure_Mode__c = 'HB';
            solcomps.AccountCode__c = '70';
            solcomps.Fail_Code_Editable__c= 'THAC';
            solcomps.AccountCodeType__c = 'EMISSION WARRANTY';
            solcomps.AccountCodeEdit__c = 'EMISSION WARRANTY 70';
            solcomps.CoveredTravelBaseFareAmt__c='100';
            solcomps.CoveredLaborHrs__c = '5';
            solcomps.CoveredOCAmount__c = '1';
            solcompsList.add(solcomps);
            
            CSS_Solution_Component__c solcomps1 = new CSS_Solution_Component__c();
            solcomps1.Component_Id__c = 'F19000541';
            solcomps1.Selected_Component__c = true;
            solcomps1.Fail_Code_Editable__c= 'THAC';
            solcomps1.Service_Job__c = jo.Id;
            solcomps1.System_Code__c = 'EQ';
            solcomps1.Component_Code__c = 'PE';
            solcomps1.Failure_Mode__c = 'HB';
            solcomps1.AccountCode__c = '70';
            solcomps1.AccountCodeType__c = 'EMISSION WARRANTY';
            solcomps1.AccountCodeEdit__c = 'EMISSION WARRANTY 70';
            solcomps1.CoveredTravelBaseFareAmt__c='100';
            solcomps1.CoveredLaborHrs__c = '5';
            solcomps1.CoveredOCAmount__c = '1';
            solcompsList.add(solcomps1);
            
            insert solcompsList;
            
            css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
            //id recordpartid = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
            id recordpartid = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
            List<CSS_Parts_Options__c> paList = new List<CSS_Parts_Options__c>();
            CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
            pa.Option_Number__c = 'O-111';
            pa.Fail_Code__c = 'tst-wenchin';
            pa.Service_Job__c = jo.Id;
            pa.selected_part__c = true;
            pa.FailurepartId__c = solcompsList[0].Id;
            pa.Part_Assignment__c = 'Primary';
            pa.Solutions__c=sol.Id;
            pa.ODM_Status__c='warn';
            pa.ODM_Status_Message__c='Test1;test2;test3';
            pa.ODM_Status_Code__c='500';
            pa.Type__c='Commercial-Travel';
            pa.Item__c='Ties';
            pa.Account_Code__c ='EMISSION WARRANTY 70';
            pa.Quantity__c = 9.0;
            pa.RecordTypeId=recordpartid;
            pa.ExpenseTotal__c =1000;
            paList.add(pa);
            
            CSS_Parts_Options__c pa1 = new CSS_Parts_Options__c();
            pa1.Option_Number__c = 'O-111';
            pa1.Service_Job__c = jo.Id;
            pa1.Fail_Code__c = 'tst-wenchin';
            pa1.selected_part__c = true;
            pa1.FailurepartId__c = solcompsList[0].Id;
            pa1.Part_Assignment__c = 'Primary';
            pa1.Solutions__c=sol.Id;
            pa1.ODM_Status__c='warn';
            pa1.ODM_Status_Message__c='Test1;test2;test3';
            pa1.ODM_Status_Code__c='500';
            pa1.Type__c='Non Commercial-Travel';
            pa1.Item__c='Ties';
            pa1.Account_Code__c ='EMISSION WARRANTY 70';
            pa1.RecordTypeId=recordpartid;
            pa1.ExpenseTotal__c =500;
            pa1.Mileage__c=500;
            pa1.Quantity__c=10;
            paList.add(pa1);
            
            CSS_Parts_Options__c pa2 = new CSS_Parts_Options__c();
            pa2.Option_Number__c = 'O-111';
            pa2.Service_Job__c = jo.Id;
            pa2.selected_part__c = true;
            pa2.FailurepartId__c = solcompsList[0].Id;
            pa2.Part_Assignment__c = 'Primary';
            pa2.Fail_Code__c = 'tst-wenchin';
            pa2.Solutions__c=sol.Id;
            pa2.ODM_Status__c='warn';
            pa2.ODM_Status_Message__c='Test1;test2;test3';
            pa2.ODM_Status_Code__c='500';
            pa2.Type__c='Meals';
            pa2.Item__c='Ties';
            pa2.Account_Code__c ='EMISSION WARRANTY 70';
            pa2.Quantity__c = 3.0;
            pa2.RecordTypeId=recordpartid;
            pa2.ExpenseTotal__c =500;
            pa2.Mileage__c=500;
            paList.add(pa2);
            
            CSS_Parts_Options__c pa3 = new CSS_Parts_Options__c();
            pa3.Option_Number__c = 'O-1112';
            pa3.Service_Job__c = jo.Id;
            pa3.Fail_Code__c = 'tst-wenchin';
            pa3.selected_part__c = true;
            pa3.FailurepartId__c = solcompsList[0].Id;
            pa3.Part_Assignment__c = 'Primary';
            pa3.Solutions__c=sol.Id;
            pa3.ODM_Status__c='warn';
            pa3.ODM_Status_Message__c='Test1;test2;test3';
            pa3.ODM_Status_Code__c='500';
            pa3.Type__c='Commercial-Travel';
            pa3.Item__c='Ties';
            pa3.Account_Code__c ='EMISSION WARRANTY 70';
            pa3.Quantity__c = 9.0;
            pa3.RecordTypeId=recTypeIdpartTemp;
            pa3.ExpenseTotal__c =1000;
            paList.add(pa3);
            
            insert paList;
            
            List<CSS_SRT__c> srtLst = new List<CSS_SRT__c>();
            CSS_SRT__c srt = new CSS_SRT__c();
            srt.Account_Code__c='PARTS WARRANTY - DEFECT FROM STOCK 35';
            srt.FailCode__c='THAC';
            srt.Type__c='Repair';
            srt.CSS_Claims__c=testclaimsRec.Id;
            srt.Extended_Hours__c = 20;
            
            srtLst.add(srt);
            insert srtLst;
            
            
            CG_CL_CoverageLimitExceedValidation covlimExVal = new CG_CL_CoverageLimitExceedValidation();
            Set<String> covLimExceed = new Set<String>();
            system.debug('JO.id***'+JO.id);
            covLimExceed=covlimExVal.covLimitValidation(JO.id, null, paList, paList);
            List<Boolean> boolList = new List<Boolean>();
            boolList=covlimExVal.checkFailuresCovered(testclaimsRec.id, true);
            covlimExVal.covLimitValidationSRT(JO.id,null);
            
            covLimExceed=covlimExVal.covLimitValidation(JO.id, null, paList, null);
            covLimExceed=covlimExVal.covLimitValidation(JO.id, null, null, null);
            // covlimExVal.covLimitfailcodeValidation(JO.id,null);
            List<String> CovLimMsg = new List<String>();
            //CovLimMsg = covlimExVal.covLimitValidationMsg(solcompsList,paList,srtLst);
        }
        
        
    }
    
    public static Testmethod void CovMethod3(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        
        insert acc;
        
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO; 
        
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'CAP';
        jET.Attribute3__c = '50';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        CSS_JobEventTemporary__c jET2 = new CSS_JobEventTemporary__c();
        jET2.Attribute1__c = 'NPW';
        jET2.Attribute3__c = '60';
        jET2.Attribute4__c = 'DSBDV5789';
        jET2.Key__c = 'AccountCodes';
        jETList.add(jET2);
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'NPW';
        jET1.Attribute3__c = '70';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        CSS_JobEventTemporary__c jET11 = new CSS_JobEventTemporary__c();
        jET11.Attribute1__c = 'CAP';
        jET11.Attribute3__c = '70';
        jET11.Attribute4__c = 'DSBDV5788';
        jET11.Key__c = 'AccountCodes';
        jETList.add(jET11);
        insert jETList;
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        //testclaimsRec.CSS_Job__c = JO.id;
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'RdB@nomail.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.Account__c=acc.Id;
        insert testclaimsRec;
        
        List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomps = new CSS_Solution_Component__c();
        solcomps.Component_Id__c = 'F19000540';
        solcomps.Selected_Component__c = true;
        solcomps.System_Code__c='FH';
        solcomps.Service_Job__c=jo.id;
        solcomps.Component_Code__c='AS';
        solcomps.CSS_Claims__c = testclaimsRec.Id;
        solcomps.System_Code__c = 'EQ';
        solcomps.Component_Code__c = 'PE';
        solcomps.Failure_Mode__c = 'HB';
        solcomps.AccountCode__c = '70';
        solcomps.AccountCodeType__c = 'EMISSION WARRANTY';
        solcomps.AccountCodeEdit__c = 'EMISSION WARRANTY 70';
        solcomps.CoveredTravelBaseFareAmt__c='100';
        solcomps.CoveredPartsQty__c='10';
        solcomps.CoveredOCAmount__c='10';
        solcomps.CoveredLaborHrs__c='123523';
        solcompsList.add(solcomps);        
        
        CSS_Solution_Component__c solcomps1 = new CSS_Solution_Component__c();
        solcomps1.Component_Id__c = 'F19000540';
        solcomps1.Selected_Component__c = true;
        solcomps1.System_Code__c='FH';
        solcomps1.Component_Code__c='AS';
        solcomps1.CSS_Claims__c = testclaimsRec.Id;
        solcomps1.System_Code__c = 'EQ';
        solcomps1.Component_Code__c = 'PE';
        solcomps1.Failure_Mode__c = 'HB';
        solcomps1.AccountCode__c = '50';
        solcomps1.AccountCodeType__c = 'EMISSION WARRANTY';
        solcomps1.AccountCodeEdit__c = 'EMISSION WARRANTY 50';
        solcomps1.CoveredTravelBaseFareAmt__c='100';
        solcomps1.CoveredPartsQty__c=null;
        solcomps1.Type__c='test1';
        solcomps1.CoveredOCAmount__c='7';
        solcomps1.CoveredLaborHrs__c='134235';
        solcomps1.CoveredTravelLabor__c='0';
        solcomps1.CoveredTravelMiles__c='0';
       solcomps1.CoveredTowingMiles__c='100';
        solcomps1.CoveredMealsLodgingAmt__c='100';
        solcomps1.CampaignTravelPercentage__c='100';
        solcomps1.CampaignTowingPercentage__c='100';
        solcompsList.add(solcomps1);
        insert solcompsList;
        
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        //id recordpartid = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        id recordpartid = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        List<CSS_Parts_Options__c> paList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solcompsList[0].Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='Test1;test2;test3';
        pa.ODM_Status_Code__c='500';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.Account_Code__c ='EMISSION WARRANTY 70';
        pa.Quantity__c = 120;
        pa.RecordTypeId=recordpartid;
        pa.ExpenseTotal__c =1000;
        pa.Fail_Code__c='Turbocharger Actuator-THAC';
        paList.add(pa);
        CSS_Parts_Options__c pa5 = new CSS_Parts_Options__c();
        pa5.Option_Number__c = 'O-111';
        pa5.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa5.FailurepartId__c = solcompsList[0].Id;
        pa5.Part_Assignment__c = 'Primary';
        pa5.Solutions__c=sol.Id;
        pa5.ODM_Status__c='warn';
        pa5.ODM_Status_Message__c='Test1;test2;test3';
        pa5.ODM_Status_Code__c='500';
        pa5.Type__c='Commercial-Travel';
        pa5.Item__c='Ties';
        pa5.Account_Code__c ='EMISSION WARRANTY 70';
        pa5.Quantity__c = 120;
        pa5.RecordTypeId=recordpartid;
        pa5.ExpenseTotal__c =1000;
        pa5.Fail_Code__c='Turbocharger Actuator-EQPE';
        paList.add(pa5);
        CSS_Parts_Options__c pa1 = new CSS_Parts_Options__c();
        pa1.Option_Number__c = 'O-111';
        pa1.Service_Job__c = jo.Id;
        pa1.selected_part__c = true;
        pa1.HoursTravelled__c = 5;
        pa1.FailurepartId__c = solcompsList[1].Id;
        pa1.Part_Assignment__c = 'Primary';
        pa1.Solutions__c=sol.Id;
        pa1.ODM_Status__c='warn';
        pa1.ODM_Status_Message__c='Test1;test2;test3';
        pa1.ODM_Status_Code__c='500';
        pa1.Type__c='Non Commercial-Travel';
        pa1.Item__c='Ties';
        pa1.Account_Code__c ='EMISSION WARRANTY 50';
        pa1.RecordTypeId=recordpartid;
        pa1.ExpenseTotal__c =500;
        pa1.Mileage__c=500;
        pa1.Quantity__c=120;
        pa1.Fail_Code__c='Turbocharger Actuator-THAC';
        paList.add(pa1);
        
        CSS_Parts_Options__c pa2 = new CSS_Parts_Options__c();
        pa2.Option_Number__c = 'O-111';
        pa2.Service_Job__c = jo.Id;
        pa2.HoursTravelled__c = 5;
        pa2.selected_part__c = true;
        pa2.FailurepartId__c = solcompsList[0].Id;
        pa2.Part_Assignment__c = 'Primary';
        pa2.Solutions__c=sol.Id;
        pa2.ODM_Status__c='warn';
        pa2.ODM_Status_Message__c='Test1;test2;test3';
        pa2.ODM_Status_Code__c='500';
        pa2.Type__c='Meals';
        pa2.Item__c='Ties';
        pa2.Account_Code__c ='EMISSION WARRANTY 70';
        pa2.Quantity__c = 3.0;
        pa2.RecordTypeId=recTypeIdpartTemp;
        pa2.ExpenseTotal__c =500;
        pa2.Mileage__c=500;
        pa2.Fail_Code__c='Fuel Pump-FHAS';
        paList.add(pa2);
        
        CSS_Parts_Options__c pa3 = new CSS_Parts_Options__c();
        pa3.Option_Number__c = 'O-1112';
        pa3.Service_Job__c = jo.Id;
        pa3.HoursTravelled__c = 5;
        pa3.selected_part__c = true;
        pa3.FailurepartId__c = solcompsList[1].Id;
        pa3.Part_Assignment__c = 'Primary';
        pa3.Solutions__c=sol.Id;
        pa3.ODM_Status__c='warn';
        pa3.ODM_Status_Message__c='Test1;test2;test3';
        pa3.ODM_Status_Code__c='500';
        pa3.Type__c='Commercial-Travel';
        pa3.Item__c='Ties';
        pa3.Account_Code__c ='EMISSION WARRANTY 50';
        pa3.Quantity__c = 100;
        pa3.RecordTypeId=recTypeIdpartTemp;
        pa3.ExpenseTotal__c =1000;
        pa3.Fail_Code__c='Fuel Pump-FHAS';
        paList.add(pa3);
        
        insert paList;
        
        List<CSS_SRT__c> srtLst = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Account_Code__c='EMISSION WARRANTY 70';
        srt.FailCode__c='THAC';
        srt.Type__c='Repair';
        srt.CSS_Claims__c=testclaimsRec.Id;
        srt.isPerformed__c=true;
        srt.Extended_Hours__c=10;
        srtLst.add(srt);
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Account_Code__c='EMISSION WARRANTY 70';
        srt1.FailCode__c='THAC';
        srt1.Type__c='Repair';
        srt1.CSS_Claims__c=testclaimsRec.Id;
        srt1.isPerformed__c=true;
        srt1.Extended_Hours__c=10;
        srtLst.add(srt1);
        insert srtLst;
        List<CSS_Solution_Component__c>slst = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c singleSolComp = new CSS_Solution_Component__c();
        singleSolComp.id = solcompsList[0].id;
        singleSolComp.CoverageLimitExceedMsg__c = 'error';
        singleSolComp.CoverageLimitExceedMsg_Status__c = 'error';
        slst.add(singleSolComp);
        upsert slst;
        
        CG_CL_CoverageLimitExceedValidation covlimExVal = new CG_CL_CoverageLimitExceedValidation();
        Set<String> covLimExceed = new Set<String>();
        // covLimExceed=covlimExVal.covLimitValidation(null, testclaimsRec.Id, paList, null);
        List<Boolean> boolList = new List<Boolean>();
        boolList=covlimExVal.checkFailuresCovered(testclaimsRec.id, true);
        covlimExVal.covLimitValidationSRT(null,testclaimsRec.Id);
        // covlimExVal.covLimitfailcodeValidation(null,testclaimsRec.Id);
        // covLimExceed=covlimExVal.covLimitValidation(JO.id, testclaimsRec.Id, paList, paList);
        
        //CovLimMsg = covlimExVal.covLimitValidationMsg(solcompsList,paList,srtLst);
        Map<String,String> accCodeCovTypeMap = new Map<String,String>();
        accCodeCovTypeMap.put('70','COV');
        covlimExVal.accCodeCovTypeMap=accCodeCovTypeMap;
        covlimExVal.covLimitValidationSRT(null,testclaimsRec.Id);
        
    }
    
    public static Testmethod void CovMethod4(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        
        insert acc;
        
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO; 
        
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'CAP';
        jET.Attribute3__c = '50';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        CSS_JobEventTemporary__c jET2 = new CSS_JobEventTemporary__c();
        jET2.Attribute1__c = 'NPW';
        jET2.Attribute3__c = '60';
        jET2.Attribute4__c = 'DSBDV5789';
        jET2.Key__c = 'AccountCodes';
        jETList.add(jET2);
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'NPW';
        jET1.Attribute3__c = '70';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        CSS_JobEventTemporary__c jET11 = new CSS_JobEventTemporary__c();
        jET11.Attribute1__c = 'CAP';
        jET11.Attribute3__c = '70';
        jET11.Attribute4__c = 'DSBDV5788';
        jET11.Key__c = 'AccountCodes';
        jETList.add(jET11);
        insert jETList;
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        //testclaimsRec.CSS_Job__c = JO.id;
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'RdB@nomail.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.Account__c=acc.Id;
        insert testclaimsRec;
        
        List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomps = new CSS_Solution_Component__c();
        solcomps.Component_Id__c = 'F19000540';
        solcomps.Selected_Component__c = true;
        solcomps.System_Code__c='FH';
        solcomps.Service_Job__c=jo.id;
        solcomps.Component_Code__c='AS';
        solcomps.CSS_Claims__c = testclaimsRec.Id;
        solcomps.System_Code__c = 'EQ';
        solcomps.Component_Code__c = 'PE';
        solcomps.Failure_Mode__c = 'HB';
        solcomps.AccountCode__c = '70';
        solcomps.AccountCodeType__c = 'EMISSION WARRANTY';
        solcomps.AccountCodeEdit__c = 'EMISSION WARRANTY 70';
        solcomps.CoveredTravelBaseFareAmt__c='100';
        solcomps.CoveredPartsQty__c='10';
        solcomps.CoveredOCAmount__c='10';
        solcomps.CoveredLaborHrs__c='1';
        solcompsList.add(solcomps);        
        
        CSS_Solution_Component__c solcomps1 = new CSS_Solution_Component__c();
        solcomps1.Component_Id__c = 'F19000540';
        solcomps1.Selected_Component__c = true;
        solcomps1.System_Code__c='FH';
        solcomps1.Component_Code__c='AS';
        solcomps1.CSS_Claims__c = testclaimsRec.Id;
        solcomps1.System_Code__c = 'EQ';
        solcomps1.Component_Code__c = 'PE';
        solcomps1.Failure_Mode__c = 'HB';
        solcomps1.AccountCode__c = '50';
        solcomps1.AccountCodeType__c = 'EMISSION WARRANTY';
        solcomps1.AccountCodeEdit__c = 'EMISSION WARRANTY 50';
        solcomps1.CoveredTravelBaseFareAmt__c='100';
        solcomps1.CoveredPartsQty__c='10';
        solcomps1.CoveredOCAmount__c='7';
        solcomps1.CoveredLaborHrs__c='1';
        solcompsList.add(solcomps1);
        insert solcompsList;
        
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        //id recordpartid = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        id recordpartid = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        List<CSS_Parts_Options__c> paList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solcompsList[0].Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='Test1;test2;test3';
        pa.ODM_Status_Code__c='500';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.Account_Code__c ='EMISSION WARRANTY 70';
        pa.Quantity__c = 120;
        pa.RecordTypeId=recordpartid;
        pa.ExpenseTotal__c =1000;
        pa.Fail_Code__c='Turbocharger Actuator-THAC';
        paList.add(pa);
        CSS_Parts_Options__c pa5 = new CSS_Parts_Options__c();
        pa5.Option_Number__c = 'O-111';
        pa5.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa5.FailurepartId__c = solcompsList[0].Id;
        pa5.Part_Assignment__c = 'Primary';
        pa5.Solutions__c=sol.Id;
        pa5.ODM_Status__c='warn';
        pa5.ODM_Status_Message__c='Test1;test2;test3';
        pa5.ODM_Status_Code__c='500';
        pa5.Type__c='Commercial-Travel';
        pa5.Item__c='Ties';
        pa5.Account_Code__c ='EMISSION WARRANTY 70';
        pa5.Quantity__c = 120;
        pa5.RecordTypeId=recordpartid;
        pa5.ExpenseTotal__c =1000;
        pa5.Fail_Code__c='Turbocharger Actuator-EQPE';
        paList.add(pa5);
        CSS_Parts_Options__c pa1 = new CSS_Parts_Options__c();
        pa1.Option_Number__c = 'O-111';
        pa1.Service_Job__c = jo.Id;
        pa1.selected_part__c = true;
        pa1.HoursTravelled__c = 5;
        pa1.FailurepartId__c = solcompsList[1].Id;
        pa1.Part_Assignment__c = 'Primary';
        pa1.Solutions__c=sol.Id;
        pa1.ODM_Status__c='warn';
        pa1.ODM_Status_Message__c='Test1;test2;test3';
        pa1.ODM_Status_Code__c='500';
        pa1.Type__c='Non Commercial-Travel';
        pa1.Item__c='Ties';
        pa1.Account_Code__c ='EMISSION WARRANTY 50';
        pa1.RecordTypeId=recordpartid;
        pa1.ExpenseTotal__c =500;
        pa1.Mileage__c=500;
        pa1.Quantity__c=120;
        pa1.Fail_Code__c='Turbocharger Actuator-THAC';
        paList.add(pa1);
        
        CSS_Parts_Options__c pa2 = new CSS_Parts_Options__c();
        pa2.Option_Number__c = 'O-111';
        pa2.Service_Job__c = jo.Id;
        pa2.HoursTravelled__c = 5;
        pa2.selected_part__c = true;
        pa2.FailurepartId__c = solcompsList[0].Id;
        pa2.Part_Assignment__c = 'Primary';
        pa2.Solutions__c=sol.Id;
        pa2.ODM_Status__c='warn';
        pa2.ODM_Status_Message__c='Test1;test2;test3';
        pa2.ODM_Status_Code__c='500';
        pa2.Type__c='Meals';
        pa2.Item__c='Ties';
        pa2.Account_Code__c ='EMISSION WARRANTY 70';
        pa2.Quantity__c = 3.0;
        pa2.RecordTypeId=recTypeIdpartTemp;
        pa2.ExpenseTotal__c =500;
        pa2.Mileage__c=500;
        pa2.Fail_Code__c='Fuel Pump-FHAS';
        paList.add(pa2);
        
        CSS_Parts_Options__c pa3 = new CSS_Parts_Options__c();
        pa3.Option_Number__c = 'O-1112';
        pa3.Service_Job__c = jo.Id;
        pa3.HoursTravelled__c = 5;
        pa3.selected_part__c = true;
        pa3.FailurepartId__c = solcompsList[1].Id;
        pa3.Part_Assignment__c = 'Primary';
        pa3.Solutions__c=sol.Id;
        pa3.ODM_Status__c='warn';
        pa3.ODM_Status_Message__c='Test1;test2;test3';
        pa3.ODM_Status_Code__c='500';
        pa3.Type__c='Commercial-Travel';
        pa3.Item__c='Ties';
        pa3.Account_Code__c ='EMISSION WARRANTY 50';
        pa3.Quantity__c = 100;
        pa3.RecordTypeId=recTypeIdpartTemp;
        pa3.ExpenseTotal__c =1000;
        pa3.Fail_Code__c='Fuel Pump-FHAS';
        paList.add(pa3);
        
        insert paList;
        
        List<CSS_SRT__c> srtLst = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Account_Code__c='EMISSION WARRANTY 70';
        srt.FailCode__c='THAC';
        srt.Type__c='Repair';
        srt.CSS_Claims__c=testclaimsRec.Id;
        srt.isPerformed__c=true;
        srt.Extended_Hours__c=10;
        srtLst.add(srt);
        insert srtLst;
        List<CSS_Solution_Component__c>slst = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c singleSolComp = new CSS_Solution_Component__c();
        singleSolComp.id = solcompsList[0].id;
        singleSolComp.CoverageLimitExceedMsg__c = 'error';
        singleSolComp.CoverageLimitExceedMsg_Status__c = 'error';
        slst.add(singleSolComp);
        upsert slst;
        
        CG_CL_CoverageLimitExceedValidation covlimExVal = new CG_CL_CoverageLimitExceedValidation();
        Set<String> covLimExceed = new Set<String>();
        // covLimExceed=covlimExVal.covLimitValidation(null, testclaimsRec.Id, paList, null);
        List<Boolean> boolList = new List<Boolean>();
        boolList=covlimExVal.checkFailuresCovered(testclaimsRec.id, true);
        covlimExVal.covLimitValidationSRT(null,testclaimsRec.Id);
        // covlimExVal.covLimitfailcodeValidation(null,testclaimsRec.Id);
        // covLimExceed=covlimExVal.covLimitValidation(JO.id, testclaimsRec.Id, paList, paList);
        
        //CovLimMsg = covlimExVal.covLimitValidationMsg(solcompsList,paList,srtLst);
        Map<String,String> accCodeCovTypeMap = new Map<String,String>();
        accCodeCovTypeMap.put('70','COV');
        covlimExVal.accCodeCovTypeMap=accCodeCovTypeMap;
        covlimExVal.covLimitValidationSRT(null,testclaimsRec.Id);
        
    }
    
    public static Testmethod void CovMethod5(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        
        insert acc;
        
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO; 
        
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'NPW';
        jET.Attribute2__c = 'PARTS WARRANTY - DEFECT FROM STOCK';
        jET.Attribute3__c = '35';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'NPW';
        jET1.Attribute2__c = 'PARTS WARRANTY - DEFECT FROM STOCK';
        jET1.Attribute3__c = '35';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        insert jETList;
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        //testclaimsRec.CSS_Job__c = JO.id;
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'RdB@nomail.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.Account__c=acc.Id;
        insert testclaimsRec;
        
        List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomps = new CSS_Solution_Component__c();
        solcomps.Component_Id__c = 'F19000540';
        solcomps.Selected_Component__c = true;
        solcomps.CSS_Claims__c = testclaimsRec.Id;
        solcomps.System_Code__c = 'TH';
        solcomps.Fail_Code_Editable__c='THAC';
        //solcomps.Fail_Code__c='THAC';
        solcomps.Component_Code__c = 'AC';
        solcomps.Failure_Mode__c = 'HB';
        //solcomps.AccountCode__c = '35';
        //solcomps.AccountCodeType__c = 'EMISSION WARRANTY';
        solcomps.AccountCodeEdit__c = 'PARTS WARRANTY - DEFECT FROM STOCK 35';
        solcomps.CoveredTravelBaseFareAmt__c='100';
        solcomps.CoveredPartsQty__c='100';
        solcomps.CoveredOCAmount__c='100';
        solcomps.CoveredLaborHrs__c='5';
        solcompsList.add(solcomps);        
        
        CSS_Solution_Component__c solcomps1 = new CSS_Solution_Component__c();
        solcomps1.Component_Id__c = 'F19000540';
        solcomps1.Selected_Component__c = true;
        solcomps1.CSS_Claims__c = testclaimsRec.Id;
        solcomps1.System_Code__c = 'TH';
        solcomps1.Component_Code__c = 'AC';
        solcomps1.Failure_Mode__c = 'HB';
        //solcomps1.AccountCode__c = '35';
        //solcomps1.AccountCodeType__c = 'PARTS WARRANTY - DEFECT FROM STOCK';
        solcomps1.AccountCodeEdit__c = 'PARTS WARRANTY - DEFECT FROM STOCK 35';
        solcomps1.CoveredTravelBaseFareAmt__c='100';
        solcomps1.CoveredPartsQty__c='100';
        solcomps1.CoveredOCAmount__c='100';
        solcomps1.CoveredLaborHrs__c='5';
        solcomps1.Fail_Code_Editable__c='THAC';
        //solcomps1.Fail_Code__c='THAC';
        solcompsList.add(solcomps1);  
        CSS_Solution_Component__c comp1 = new CSS_Solution_Component__c();
        comp1.Component_Id__c = 'F19000540';
        comp1.Selected_Component__c = true;
        comp1.CSS_Claims__c = testclaimsRec.Id;
        comp1.System_Code__c = 'TH';
        comp1.Fail_Code_Editable__c='THAC';
        //comp1.Fail_Code__c='THAC';
        comp1.Component_Code__c = 'AC';
        comp1.Failure_Mode__c = 'HB';
        //comp1.AccountCode__c = '35';
        //comp1.AccountCodeType__c = 'EMISSION WARRANTY';
        comp1.AccountCodeEdit__c = 'PARTS WARRANTY - DEFECT FROM STOCK 35';
        comp1.CoveredTravelBaseFareAmt__c='0';
        comp1.CoveredPartsQty__c='0.0';
        comp1.CampaignPartsPercentage__c='0.0';
        comp1.CoveredTravelMiles__c='0';
        comp1.CoveredTowingMiles__c='0.0';
        comp1.CoveredMealsLodgingAmt__c='0';
        comp1.CampaignTravelPercentage__c='0';
        comp1.CoveredOCAmount__c='0';
        comp1.CoveredLaborHrs__c='0';
        comp1.CampaignLaborPercentage__c='0';
        solcompsList.add(comp1);   
        insert solcompsList;
        List<CSS_JobEventTemporary__c> jETListt = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jETyu = new CSS_JobEventTemporary__c();
        jETyu.Attribute1__c = 'CAP';
        jETyu.Attribute3__c = '70';
        jETyu.Attribute4__c = 'DSBDV5789';
        jETyu.Key__c = 'AccountCodes';
        jETListt.add(jETyu);
        
        CSS_JobEventTemporary__c jET18 = new CSS_JobEventTemporary__c();
        jET18.Attribute1__c = 'CAP';
        jET18.Attribute3__c = '70';
        jET18.Attribute4__c = 'DSBDV5788';
        jET18.Key__c = 'AccountCodes';
        jETListt.add(jET18);
        insert jETListt;
        
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        //id recordpartid = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        id recordpartid = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        List<CSS_Parts_Options__c> paList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solcompsList[0].Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='Test1;test2;test3';
        pa.ODM_Status_Code__c='500';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.Account_Code__c ='PARTS WARRANTY - DEFECT FROM STOCK 35';
        pa.Quantity__c = 10;
        pa.RecordTypeId=recordpartid;
        pa.ExpenseTotal__c =1000;
        pa.Fail_Code__c='Turbocharger Actuator-THAC';
        paList.add(pa);
        
        CSS_Parts_Options__c pa1 = new CSS_Parts_Options__c();
        pa1.Option_Number__c = 'O-111';
        pa1.Service_Job__c = jo.Id;
        pa1.selected_part__c = true;
        pa1.FailurepartId__c = solcompsList[1].Id;
        pa1.Part_Assignment__c = 'Primary';
        pa1.Solutions__c=sol.Id;
        pa1.ODM_Status__c='warn';
        pa1.ODM_Status_Message__c='Test1;test2;test3';
        pa1.ODM_Status_Code__c='500';
        pa1.Type__c='Non Commercial-Travel';
        pa1.Item__c='Ties';
        pa1.Account_Code__c ='PARTS WARRANTY - DEFECT FROM STOCK 35';
        pa1.RecordTypeId=recordpartid;
        pa1.ExpenseTotal__c =500;
        pa1.Mileage__c=500;
        pa1.Quantity__c=10;
        pa1.Fail_Code__c='Turbocharger Actuator-THAC';
        paList.add(pa1);
        
        CSS_Parts_Options__c pa2 = new CSS_Parts_Options__c();
        pa2.Option_Number__c = 'O-111';
        pa2.Service_Job__c = jo.Id;
        pa2.selected_part__c = true;
        pa2.FailurepartId__c = solcompsList[0].Id;
        pa2.Part_Assignment__c = 'Primary';
        pa2.Solutions__c=sol.Id;
        pa2.ODM_Status__c='warn';
        pa2.ODM_Status_Message__c='Test1;test2;test3';
        pa2.ODM_Status_Code__c='500';
        pa2.Type__c='Meals';
        pa2.Item__c='Ties';
        pa2.Account_Code__c ='PARTS WARRANTY - DEFECT FROM STOCK 35';
        pa2.Quantity__c = 3.0;
        pa2.RecordTypeId=recTypeIdpartTemp;
        pa2.ExpenseTotal__c =500;
        pa2.Mileage__c=500;
        pa2.Fail_Code__c='Fuel Pump-FHAS';
        paList.add(pa2);
        
        CSS_Parts_Options__c pa3 = new CSS_Parts_Options__c();
        pa3.Option_Number__c = 'O-1112';
        pa3.Service_Job__c = jo.Id;
        pa3.selected_part__c = true;
        pa3.FailurepartId__c = solcompsList[1].Id;
        pa3.Part_Assignment__c = 'Primary';
        pa3.Solutions__c=sol.Id;
        pa3.ODM_Status__c='warn';
        pa3.ODM_Status_Message__c='Test1;test2;test3';
        pa3.ODM_Status_Code__c='500';
        pa3.Type__c='Commercial-Travel';
        pa3.Item__c='Ties';
        pa3.Account_Code__c ='PARTS WARRANTY - DEFECT FROM STOCK 35';
        pa3.Quantity__c = 10;
        pa3.RecordTypeId=recTypeIdpartTemp;
        pa3.ExpenseTotal__c =1000;
        pa3.Fail_Code__c='Fuel Pump-FHAS';
        paList.add(pa3);
        
        insert paList;
        
        /*List<CSS_SRT__c> srtLst = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Account_Code__c='PARTS WARRANTY - DEFECT FROM STOCK 35';
        srt.Account_Code_Description__c = 'PARTS WARRANTY - DEFECT FROM STOCK';
        srt.FailCode__c='TH-AC-AC';
        srt.Type__c='99time';//'Repair';
        srt.CSS_Claims__c=testclaimsRec.Id;
        srt.Component_Id__c = solcompsList[0].Id;
        srt.isPerformed__c=true;
        srt.Extended_Hours__c=20;
        
        srtLst.add(srt);
        insert srtLst;*/
        
        CG_CL_CoverageLimitExceedValidation covlimExVal = new CG_CL_CoverageLimitExceedValidation();
        Set<String> covLimExceed = new Set<String>();
        covLimExceed=covlimExVal.covLimitValidation(null, testclaimsRec.Id, paList, paList);
        List<Boolean> boolList = new List<Boolean>();
        boolList=covlimExVal.checkFailuresCovered(testclaimsRec.id, true);
        covlimExVal.covLimitValidationSRT(null,testclaimsRec.Id);
        covlimExVal.covLimitfailcodeValidation(null,testclaimsRec.Id);
        covlimExVal.covLimitfailcodeJobValidation(JO.id,null);
        List<String> CovLimMsg = new List<String>();
        //srt.Extended_Hours__c=null;
        covlimExVal.covLimitfailcodeValidation(null,testclaimsRec.Id);
        
        covLimExceed=covlimExVal.covLimitValidation(JO.id, null, paList, paList);
        covLimExceed=covlimExVal.covLimitValidation(JO.id, testclaimsRec.Id, null, paList);
        
        // CovLimMsg = covlimExVal.covLimitValidationMsg(solcompsList,paList,srtLst);
        
    }
     
    
    public static Testmethod void CovMethod51(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        
        insert acc;
        
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO; 
        
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'NPW';
        jET.Attribute2__c = 'PARTS WARRANTY - DEFECT FROM STOCK';
        jET.Attribute3__c = '35';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'NPW';
        jET1.Attribute2__c = 'PARTS WARRANTY - DEFECT FROM STOCK';
        jET1.Attribute3__c = '35';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        insert jETList;
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        //testclaimsRec.CSS_Job__c = JO.id;
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'RdB@nomail.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.Account__c=acc.Id;
        insert testclaimsRec;
        
        List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();  
        CSS_Solution_Component__c comp1 = new CSS_Solution_Component__c();
        comp1.Component_Id__c = 'F19000540';
        comp1.Selected_Component__c = true;
        comp1.CSS_Claims__c = testclaimsRec.Id;
        comp1.System_Code__c = 'TH';
        comp1.Fail_Code_Editable__c='THAC';
        //comp1.Fail_Code__c='THAC';
        comp1.Component_Code__c = 'AC';
        comp1.Failure_Mode__c = 'HB';
        //comp1.AccountCode__c = '35';
        //comp1.AccountCodeType__c = 'EMISSION WARRANTY';
        comp1.AccountCodeEdit__c = 'PARTS WARRANTY - DEFECT FROM STOCK 35';
        comp1.CoveredTravelBaseFareAmt__c='0';
        comp1.CoveredPartsQty__c='0.0';
        comp1.CampaignPartsPercentage__c='0.0';
        comp1.CoveredTravelMiles__c='0';
        comp1.CoveredTowingMiles__c='0.0';
        comp1.CoveredMealsLodgingAmt__c='0';
        comp1.CampaignTravelPercentage__c='0';
        comp1.CampaignTowingPercentage__c='0';
        comp1.CoveredOCAmount__c='0';
        comp1.CampaignOCPercentage__c='0';
        comp1.CoveredLaborHrs__c=null;
        comp1.CampaignLaborPercentage__c='0';
        comp1.Type__c='Diag';
        CSS_Solution_Component__c comp2 = new CSS_Solution_Component__c();
        comp2.Component_Id__c = 'F19000540';
        comp2.Selected_Component__c = true;
        comp2.CSS_Claims__c = testclaimsRec.Id;
        comp2.System_Code__c = 'TH';
        comp2.Fail_Code_Editable__c='THAC';
        //comp1.Fail_Code__c='THAC';
        comp2.Component_Code__c = 'AC';
        comp2.Failure_Mode__c = 'HB';
        //comp1.AccountCode__c = '35';
        //comp1.AccountCodeType__c = 'EMISSION WARRANTY';
        comp2.AccountCodeEdit__c = 'PARTS WARRANTY - DEFECT FROM STOCK 35';
        comp2.CoveredTravelBaseFareAmt__c='0';
        comp2.CoveredPartsQty__c='0.0';
        comp2.CampaignPartsPercentage__c='0.0';
        comp2.CoveredTravelMiles__c='0';
        comp2.CoveredTowingMiles__c='0.0';
        comp2.CoveredMealsLodgingAmt__c='0';
        comp2.CampaignTravelPercentage__c='0';
        comp2.CampaignTowingPercentage__c='10';
        comp2.CoveredOCAmount__c='0';
        comp2.CampaignOCPercentage__c='10';
        comp2.CoveredLaborHrs__c='0';
        comp2.CampaignLaborPercentage__c='0';
        comp2.Type__c='Diag';
        solcompsList.add(comp1); 
        solcompsList.add(comp2);
        insert solcompsList;
        List<CSS_JobEventTemporary__c> jETListt = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jETyu = new CSS_JobEventTemporary__c();
        jETyu.Attribute1__c = 'CAP';
        jETyu.Attribute3__c = '70';
        jETyu.Attribute4__c = 'DSBDV5789';
        jETyu.Key__c = 'AccountCodes';
        jETListt.add(jETyu);
        
        CSS_JobEventTemporary__c jET18 = new CSS_JobEventTemporary__c();
        jET18.Attribute1__c = 'CAP';
        jET18.Attribute3__c = '70';
        jET18.Attribute4__c = 'DSBDV5788';
        jET18.Key__c = 'AccountCodes';
        jETListt.add(jET18);
        insert jETListt;
        
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        //id recordpartid = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        id recordpartid = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        List<CSS_Parts_Options__c> paList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solcompsList[0].Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='Test1;test2;test3';
        pa.ODM_Status_Code__c='500';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.Account_Code__c ='PARTS WARRANTY - DEFECT FROM STOCK 35';
        pa.Quantity__c = 10;
        pa.RecordTypeId=recordpartid;
        pa.ExpenseTotal__c =1000;
        pa.Fail_Code__c='Turbocharger Actuator-THAC';
        paList.add(pa);
        
        CSS_Parts_Options__c pa1 = new CSS_Parts_Options__c();
        pa1.Option_Number__c = 'O-111';
        pa1.Service_Job__c = jo.Id;
        pa1.selected_part__c = true;
        pa1.FailurepartId__c = solcompsList[0].Id;
        pa1.Part_Assignment__c = 'Primary';
        pa1.Solutions__c=sol.Id;
        pa1.ODM_Status__c='warn';
        pa1.ODM_Status_Message__c='Test1;test2;test3';
        pa1.ODM_Status_Code__c='500';
        pa1.Type__c='Non Commercial-Travel';
        pa1.Item__c='Ties';
        pa1.Account_Code__c ='PARTS WARRANTY - DEFECT FROM STOCK 35';
        pa1.RecordTypeId=recordpartid;
        pa1.ExpenseTotal__c =500;
        pa1.Mileage__c=500;
        pa1.Quantity__c=10;
        pa1.Fail_Code__c='Turbocharger Actuator-THAC';
        paList.add(pa1);
        
        CSS_Parts_Options__c pa2 = new CSS_Parts_Options__c();
        pa2.Option_Number__c = 'O-111';
        pa2.Service_Job__c = jo.Id;
        pa2.selected_part__c = true;
        pa2.FailurepartId__c = solcompsList[0].Id;
        pa2.Part_Assignment__c = 'Primary';
        pa2.Solutions__c=sol.Id;
        pa2.ODM_Status__c='warn';
        pa2.ODM_Status_Message__c='Test1;test2;test3';
        pa2.ODM_Status_Code__c='500';
        pa2.Type__c='Meals';
        pa2.Item__c='Ties';
        pa2.Account_Code__c ='PARTS WARRANTY - DEFECT FROM STOCK 35';
        pa2.Quantity__c = 3.0;
        pa2.RecordTypeId=recTypeIdpartTemp;
        pa2.ExpenseTotal__c =500;
        pa2.Mileage__c=500;
        pa2.Fail_Code__c='Fuel Pump-FHAS';
        paList.add(pa2);
        
        CSS_Parts_Options__c pa3 = new CSS_Parts_Options__c();
        pa3.Option_Number__c = 'O-1112';
        pa3.Service_Job__c = jo.Id;
        pa3.selected_part__c = true;
        pa3.FailurepartId__c = solcompsList[0].Id;
        pa3.Part_Assignment__c = 'Primary';
        pa3.Solutions__c=sol.Id;
        pa3.ODM_Status__c='warn';
        pa3.ODM_Status_Message__c='Test1;test2;test3';
        pa3.ODM_Status_Code__c='500';
        pa3.Type__c='Commercial-Travel';
        pa3.Item__c='Ties';
        pa3.Account_Code__c ='PARTS WARRANTY - DEFECT FROM STOCK 35';
        pa3.Quantity__c = 10;
        pa3.RecordTypeId=recTypeIdpartTemp;
        pa3.ExpenseTotal__c =1000;
        pa3.Fail_Code__c='Fuel Pump-FHAS';
        paList.add(pa3);
        
        insert paList;
        
        List<CSS_SRT__c> srtLst = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Account_Code__c='PARTS WARRANTY - DEFECT FROM STOCK 35';
        srt.Account_Code_Description__c = 'PARTS WARRANTY - DEFECT FROM STOCK';
        srt.FailCode__c='THAC';
        srt.Type__c='Repair';
        srt.CSS_Claims__c=testclaimsRec.Id;
        srt.Component_Id__c = solcompsList[0].Id;
        srt.isPerformed__c=true;
        srt.Extended_Hours__c=20;
        
        srtLst.add(srt);
        insert srtLst;
        
        CG_CL_CoverageLimitExceedValidation covlimExVal = new CG_CL_CoverageLimitExceedValidation();
        Set<String> covLimExceed = new Set<String>();
        covLimExceed=covlimExVal.covLimitValidation(null, testclaimsRec.Id, paList, paList);
        List<Boolean> boolList = new List<Boolean>();
        boolList=covlimExVal.checkFailuresCovered(testclaimsRec.id, true);
        covlimExVal.covLimitValidationSRT(null,testclaimsRec.Id);
        covlimExVal.covLimitfailcodeValidation(null,testclaimsRec.Id);
        covlimExVal.covLimitfailcodeJobValidation(JO.id,null);
        
        List<String> CovLimMsg = new List<String>();
        srt.Extended_Hours__c=null;
        covlimExVal.covLimitfailcodeValidation(null,testclaimsRec.Id);
        covlimExVal.covLimitfailcodeJobValidation(JO.id,null);
        
        covLimExceed=covlimExVal.covLimitValidation(JO.id, null, paList, paList);
        
    }
    public static Testmethod void CovMethod512(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        
        insert acc;
        
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO; 
        
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'NPW';
        jET.Attribute2__c = 'PARTS WARRANTY - DEFECT FROM STOCK';
        jET.Attribute3__c = '35';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'NPW';
        jET1.Attribute2__c = 'PARTS WARRANTY - DEFECT FROM STOCK';
        jET1.Attribute3__c = '35';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        insert jETList;
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        //testclaimsRec.CSS_Job__c = JO.id;
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'RdB@nomail.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.Account__c=acc.Id;
        insert testclaimsRec;
        list<CSS_Solution_Component__c> solcompsList = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c comp2 = new CSS_Solution_Component__c();
        comp2.Component_Id__c = 'F191010105410';
        comp2.Selected_Component__c = true;
        comp2.CSS_Claims__c = testclaimsRec.Id;
        comp2.System_Code__c = 'TH';
        comp2.Fail_Code_Editable__c='THAC';
        //comp2.Fail_Code__c='THAC';
        comp2.Component_Code__c = 'AC';
        comp2.Failure_Mode__c = 'HB';
        //comp2.AccountCode__c = '35';
        //comp2.AccountCodeType__c = 'EMISSION WARRANTY';
        comp2.AccountCodeEdit__c = 'PARTS WARRANTY - DEFECT FROM STOCK 35';
        comp2.CoveredTravelBaseFareAmt__c='10';
        comp2.CoveredPartsQty__c='10';
        comp2.CampaignPartsPercentage__c='10.10';
        comp2.CoveredTravelMiles__c='10';
        comp2.CoveredTowingMiles__c='10';
        comp2.CoveredMealsLodgingAmt__c='10';
        comp2.CampaignTravelPercentage__c='10';
        comp2.CoveredOCAmount__c='10';
        comp2.CoveredLaborHrs__c='10';
        comp2.CampaignLaborPercentage__c='10';
        
        solcompsList.add(comp2);  
        List<CSS_JobEventTemporary__c> jETListt = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jETyu = new CSS_JobEventTemporary__c();
        jETyu.Attribute1__c = 'CAP';
        jETyu.Attribute3__c = '70';
        jETyu.Attribute4__c = 'DSBDV5789';
        jETyu.Key__c = 'AccountCodes';
        jETListt.add(jETyu);
        
        CSS_JobEventTemporary__c jET18 = new CSS_JobEventTemporary__c();
        jET18.Attribute1__c = 'CAP';
        jET18.Attribute3__c = '70';
        jET18.Attribute4__c = 'DSBDV5788';
        jET18.Key__c = 'AccountCodes';
        jETListt.add(jET18);
        insert jETListt;
        
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        //id recordpartid = schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        id recordpartid = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        List<CSS_Parts_Options__c> paList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solcompsList[0].Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='Test1;test2;test3';
        pa.ODM_Status_Code__c='500';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.Account_Code__c ='PARTS WARRANTY - DEFECT FROM STOCK 35';
        pa.Quantity__c = 10;
        pa.RecordTypeId=recordpartid;
        pa.ExpenseTotal__c =1000;
        pa.Fail_Code__c='Turbocharger Actuator-THAC';
        paList.add(pa);
        
        CSS_Parts_Options__c pa1 = new CSS_Parts_Options__c();
        pa1.Option_Number__c = 'O-111';
        pa1.Service_Job__c = jo.Id;
        pa1.selected_part__c = true;
        pa1.FailurepartId__c = solcompsList[0].Id;
        pa1.Part_Assignment__c = 'Primary';
        pa1.Solutions__c=sol.Id;
        pa1.ODM_Status__c='warn';
        pa1.ODM_Status_Message__c='Test1;test2;test3';
        pa1.ODM_Status_Code__c='500';
        pa1.Type__c='Non Commercial-Travel';
        pa1.Item__c='Ties';
        pa1.Account_Code__c ='PARTS WARRANTY - DEFECT FROM STOCK 35';
        pa1.RecordTypeId=recordpartid;
        pa1.ExpenseTotal__c =500;
        pa1.Mileage__c=500;
        pa1.Quantity__c=10;
        pa1.Fail_Code__c='Turbocharger Actuator-THAC';
        paList.add(pa1);
        
        CSS_Parts_Options__c pa2 = new CSS_Parts_Options__c();
        pa2.Option_Number__c = 'O-111';
        pa2.Service_Job__c = jo.Id;
        pa2.selected_part__c = true;
        pa2.FailurepartId__c = solcompsList[0].Id;
        pa2.Part_Assignment__c = 'Primary';
        pa2.Solutions__c=sol.Id;
        pa2.ODM_Status__c='warn';
        pa2.ODM_Status_Message__c='Test1;test2;test3';
        pa2.ODM_Status_Code__c='500';
        pa2.Type__c='Meals';
        pa2.Item__c='Ties';
        pa2.Account_Code__c ='PARTS WARRANTY - DEFECT FROM STOCK 35';
        pa2.Quantity__c = 3.0;
        pa2.RecordTypeId=recTypeIdpartTemp;
        pa2.ExpenseTotal__c =500;
        pa2.Mileage__c=500;
        pa2.Fail_Code__c='Fuel Pump-FHAS';
        paList.add(pa2);
        
        CSS_Parts_Options__c pa3 = new CSS_Parts_Options__c();
        pa3.Option_Number__c = 'O-1112';
        pa3.Service_Job__c = jo.Id;
        pa3.selected_part__c = true;
        pa3.FailurepartId__c = solcompsList[0].Id;
        pa3.Part_Assignment__c = 'Primary';
        pa3.Solutions__c=sol.Id;
        pa3.ODM_Status__c='warn';
        pa3.ODM_Status_Message__c='Test1;test2;test3';
        pa3.ODM_Status_Code__c='500';
        pa3.Type__c='Commercial-Travel';
        pa3.Item__c='Ties';
        pa3.Account_Code__c ='PARTS WARRANTY - DEFECT FROM STOCK 35';
        pa3.Quantity__c = 10;
        pa3.RecordTypeId=recTypeIdpartTemp;
        pa3.ExpenseTotal__c =1000;
        pa3.Fail_Code__c='Fuel Pump-FHAS';
        paList.add(pa3);
        
        insert paList;
        
        List<CSS_SRT__c> srtLst = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Account_Code__c='PARTS WARRANTY - DEFECT FROM STOCK 35';
        srt.Account_Code_Description__c = 'PARTS WARRANTY - DEFECT FROM STOCK';
        srt.FailCode__c='THAC';
        srt.Type__c='Repair';
        srt.CSS_Claims__c=testclaimsRec.Id;
        srt.Component_Id__c = solcompsList[0].Id;
        srt.isPerformed__c=true;
        srt.Extended_Hours__c=20;
        
        srtLst.add(srt);
        insert srtLst;
        
        CG_CL_CoverageLimitExceedValidation covlimExVal = new CG_CL_CoverageLimitExceedValidation();
        Set<String> covLimExceed = new Set<String>();
        covLimExceed=covlimExVal.covLimitValidation(null, testclaimsRec.Id, paList, paList);
        List<Boolean> boolList = new List<Boolean>();
        boolList=covlimExVal.checkFailuresCovered(testclaimsRec.id, true);
        covlimExVal.covLimitValidationSRT(null,testclaimsRec.Id);
        covlimExVal.covLimitfailcodeValidation(null,testclaimsRec.Id);
        covlimExVal.covLimitfailcodeJobValidation(JO.id,null);
        List<String> CovLimMsg = new List<String>();
        srt.Extended_Hours__c=null;
        covlimExVal.covLimitfailcodeValidation(null,testclaimsRec.Id);
        covlimExVal.covLimitfailcodeJobValidation(JO.id,null);
        
        covLimExceed=covlimExVal.covLimitValidation(JO.id, null, paList, paList);
        covLimExceed=covlimExVal.covLimitValidation(JO.id, null, paList, null);
        covLimExceed=covlimExVal.covLimitValidation(JO.id, testclaimsRec.id, null, null);
    }
    public static testmethod void CovMethod6(){
        css_claims__c claims1= new css_claims__C();
        claims1.Customer_Code__c='123';
        claims1.Customer_Name__c='TestUser';
        claims1.Multi_PSN_Claim__c=true;
        claims1.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "100000", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "EMS-Emissions Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        claims1.Status__c='';
        claims1.Complaint_Type_Desc__c = 'nkm';
        claims1.Complaint_Type2_Desc__c = 'nkm';
        claims1.Complaint_Type3_Desc__c = 'nkm';
        claims1.Complaint_Type4_Desc__c = 'nkm';
        claims1.Complaint_Type5_Desc__c = 'nkm';
        claims1.EditCause__c = 'sfsdf';
        claims1.EditCorrection__c = 'dsfsdf';
        claims1.EditComplaint__c = 'sfasr';
        insert claims1;
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'CAP';
        jET.Attribute3__c = '70';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'NPW';
        jET1.Attribute3__c = '50';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        insert jETList;
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO; 
        
        List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomps = new CSS_Solution_Component__c();
        solcomps.Component_Id__c = 'F19000540';
        solcomps.Selected_Component__c = true;
        solcomps.CSS_Claims__c = claims1.Id;
        solcomps.System_Code__c = 'EQ';
        solcomps.Component_Code__c = 'PE';
        solcomps.Failure_Mode__c = 'HB';
        solcomps.AccountCode__c = '70';
        solcomps.AccountCodeType__c = 'EMISSION WARRANTY';
        solcomps.AccountCodeEdit__c = 'EMISSION WARRANTY 70';
        solcomps.CoveredTravelBaseFareAmt__c='100';
        solcomps.CoveredTravelMiles__c='100';
        solcomps.CoveredMealsLodgingAmt__c='100';
        solcomps.CoveredTravelLabor__c='1';
        solcomps.CoveredTowingMiles__c = '10';
        solcompsList.add(solcomps);
        insert solcompsList;
        
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        id recordpartid = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        List<CSS_Parts_Options__c> paList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.CSS_Claims__c = claims1.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solcompsList[0].Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.HoursTravelled__c = 5;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='Test1;test2;test3';
        pa.ODM_Status_Code__c='500';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.Account_Code__c ='EMISSION WARRANTY 70';
        pa.Fail_Code__c='t-EQPE';
        pa.RecordTypeId=recordpartid;
        pa.ExpenseTotal__c =1000;
        paList.add(pa);
        
       CSS_Parts_Options__c pa5 = new CSS_Parts_Options__c();
        pa5.Option_Number__c = 'O-111';
        pa5.CSS_Claims__c = claims1.Id;
        pa5.selected_part__c = true;
        pa5.FailurepartId__c = solcompsList[0].Id;
        pa5.Part_Assignment__c = 'Primary';
        pa5.Solutions__c=sol.Id;
        pa5.HoursTravelled__c = 5;
        pa5.ODM_Status__c='warn';
        pa5.ODM_Status_Message__c='Test1;test2;test3';
        pa5.ODM_Status_Code__c='500';
        pa5.Type__c='Lodging';
        pa5.Item__c='Ties';
        pa5.Account_Code__c ='EMISSION WARRANTY 70';
        pa5.Fail_Code__c='t-EQPE';
        pa5.RecordTypeId=recordpartid;
        pa5.ExpenseTotal__c =1000;
        paList.add(pa5);
        
        CSS_Parts_Options__c pa1 = new CSS_Parts_Options__c();
        pa1.Option_Number__c = 'O-111';
        pa1.CSS_Claims__c = claims1.Id;
        pa1.selected_part__c = true;
        pa1.FailurepartId__c = solcompsList[0].Id;
        pa1.Part_Assignment__c = 'Primary';
        pa1.Solutions__c=sol.Id;
        pa1.ODM_Status__c='warn';
        pa1.HoursTravelled__c = 5;
        pa1.ODM_Status_Message__c='Test1;test2;test3';
        pa1.ODM_Status_Code__c='500';
        pa1.Type__c='Non Commercial-Travel';
        pa1.Item__c='Ties';
        pa1.Account_Code__c ='EMISSION WARRANTY 70';
        pa1.Fail_Code__c='t-EQPE';
        pa1.RecordTypeId=recordpartid;
        pa1.ExpenseTotal__c =500;
        pa1.Mileage__c=500;
        paList.add(pa1);
        
        CSS_Parts_Options__c pa2 = new CSS_Parts_Options__c();
        pa2.Option_Number__c = 'O-111';
        pa2.CSS_Claims__c = claims1.Id;
        pa2.selected_part__c = true;
        pa2.FailurepartId__c = solcompsList[0].Id;
        pa2.Part_Assignment__c = 'Primary';
        pa2.Solutions__c=sol.Id;
        pa2.ODM_Status__c='warn';
        pa2.ODM_Status_Message__c='Test1;test2;test3';
        pa2.ODM_Status_Code__c='500';
        pa2.Type__c='Meals';
        pa2.Item__c='Ties';
        pa2.HoursTravelled__c = 5;
        pa2.Account_Code__c ='EMISSION WARRANTY 70';
        pa2.Fail_Code__c='t-EQPE';
        pa2.RecordTypeId=recordpartid;
        pa2.ExpenseTotal__c =500;
        pa2.Mileage__c=500;
        paList.add(pa2);
        
        CSS_Parts_Options__c pa3 = new CSS_Parts_Options__c();
        pa3.Option_Number__c = 'O-1112';
        pa3.CSS_Claims__c = claims1.Id;
        pa3.selected_part__c = true;
        pa3.FailurepartId__c = solcompsList[0].Id;
        pa3.Part_Assignment__c = 'Primary';
        pa3.Solutions__c=sol.Id;
        pa3.HoursTravelled__c = 5;
        pa3.ODM_Status__c='warn';
        pa3.ODM_Status_Message__c='Test1;test2;test3';
        pa3.ODM_Status_Code__c='500';
        pa3.Type__c='Commercial-Travel';
        pa3.Item__c='Ties';
        pa3.Account_Code__c ='EMISSION WARRANTY 70';
        pa3.Fail_Code__c='t-EQPE';
        pa3.RecordTypeId=recordpartid;
        pa3.ExpenseTotal__c =1000;
        paList.add(pa3);
        
        insert paList;
        CSS_Parts_Options__c pa4 = new CSS_Parts_Options__c();
        pa4.Option_Number__c = 'O-1112';
        pa4.CSS_Claims__c = claims1.Id;
        pa4.selected_part__c = true;
        pa4.FailurepartId__c = solcompsList[0].Id;
        pa4.Part_Assignment__c = 'Primary';
        pa4.Solutions__c=sol.Id;
        pa4.HoursTravelled__c = 5;
        pa4.ODM_Status__c='warn';
        pa4.ODM_Status_Message__c='Test1;test2;test3';
        pa4.ODM_Status_Code__c='500';
        pa4.Type__c='Towing';
        pa4.Item__c='Ties';
        pa4.Account_Code__c ='EMISSION WARRANTY 70';
        pa4.Fail_Code__c='t-EQPE';
        pa4.RecordTypeId=recordpartid;
        pa4.ExpenseTotal__c =1000;
        insert pa4;
        paList.add(pa4);
        CG_CL_CoverageLimitExceedValidation covlimExVal = new CG_CL_CoverageLimitExceedValidation();
        map<string,map<string,string>> covLimTTML = new map<string,map<string,string>>();
        covLimTTML=covlimExVal.covLimitValidation_TTML(claims1.id,paList);
        List<String> covLimTTML1 = new List<String>();
        covLimTTML1=covlimExVal.covLimitValidationTTML(null,claims1.id,paList,true);
        Set<String> covLimTTML2 = new Set<String>();
        List<String> covLimTTML3 = new List<String>();
        covLimTTML3.add('Commercial-Travel&Test');
        covLimTTML2=CG_CL_CoverageLimitExceedValidation.validationerrortypes(covLimTTML3);
        Map<String, Decimal> towingMap = new Map<String, Decimal>();
        towingMap.put(pa4.Type__c+'&'+pa4.Account_Code__c.trim(),10);
        covLimTTML1=covlimExVal.covLimitValidationTTML(null,claims1.id,paList,true);
        Map<String, String> accCodeCovTypeMap = new Map<String, String>();
        string covtype;
        pa4.Account_Code__c ='NEW PARTS WARRANTY 62';
        accCodeCovTypeMap.put('62', 'NPW');
        covtype = accCodeCovTypeMap.get(pa4.Account_Code__c);
        pa4.Account_Code__c ='NEW PARTS WARRANTY 62';
        map<string,string> parterror = new  map<string,string>();
        towingMap.put(pa4.Type__c+'&'+pa4.Account_Code__c.trim(),10);
        parterror.put('Towing',label.CSS_Towing_Amount_claimed_exceeds_the_coverage_limit_for_the_Fail_Code+'@'+'THAS' +' '+Label.CSS_CoverageLimitExceedMsg_PW2 +' ' +'62');
        covLimTTML1=covlimExVal.covLimitValidationTTML(null,claims1.id,paList,true);
        //pa4.FailurepartId__c = solcompsList[0].Id;
        towingMap.put(pa3.Type__c+'&'+pa4.Account_Code__c.trim(),1000000);
        solcompsList[0].CoveredTowingMiles__c = '1000000';
        covLimTTML1=covlimExVal.covLimitValidationTTML(null,claims1.id,paList,true);
        List<Boolean> boolList = new List<Boolean>();
        boolList=covlimExVal.checkFailuresCovered(claims1.id, true);
    }
    
    public static testmethod void CovMethod7(){        
        CG_CL_CoverageLimitExceedValidation covlimExVal = new CG_CL_CoverageLimitExceedValidation();
        List<String> covLimTTML3 = new List<String>();
        covLimTTML3.add('Test$Commercial-Travel&Test');
        set<string> covLimTTML = new set<string>();
        covLimTTML=CG_CL_CoverageLimitExceedValidation.validationerrortypes(covLimTTML3);
    }
    
    public static testmethod void CovMethod8(){        
        CG_CL_CoverageLimitExceedValidation covlimExVal = new CG_CL_CoverageLimitExceedValidation();
        List<String> covLimTTML3 = new List<String>();
        covLimTTML3.add('Test$Non Commercial-Travel&Test');
        set<string> covLimTTML = new set<string>();
        covLimTTML=CG_CL_CoverageLimitExceedValidation.validationerrortypes(covLimTTML3);
    }
    
    public static testmethod void CovMethod9(){        
        CG_CL_CoverageLimitExceedValidation covlimExVal = new CG_CL_CoverageLimitExceedValidation();
        List<String> covLimTTML3 = new List<String>();
        covLimTTML3.add('Non Commercial-Travel&Test');
        set<string> covLimTTML = new set<string>();
        covLimTTML=CG_CL_CoverageLimitExceedValidation.validationerrortypes(covLimTTML3);
    }
    
    public static testmethod void CovMethod10(){
        css_claims__c claims1= new css_claims__C();
        claims1.Customer_Code__c='123';
        claims1.Customer_Name__c='TestUser';
        claims1.Multi_PSN_Claim__c=true;
        claims1.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "100000", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "EMS-Emissions Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
        claims1.Status__c='';
        claims1.Complaint_Type_Desc__c = 'nkm';
        claims1.Complaint_Type2_Desc__c = 'nkm';
        claims1.Complaint_Type3_Desc__c = 'nkm';
        claims1.Complaint_Type4_Desc__c = 'nkm';
        claims1.Complaint_Type5_Desc__c = 'nkm';
        claims1.EditCause__c = 'sfsdf';
        claims1.EditCorrection__c = 'dsfsdf';
        claims1.EditComplaint__c = 'sfasr';
        insert claims1;
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'CAP';
        jET.Attribute3__c = '70';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        
        CSS_JobEventTemporary__c jET1 = new CSS_JobEventTemporary__c();
        jET1.Attribute1__c = 'NPW';
        jET1.Attribute3__c = '50';
        jET1.Attribute4__c = 'DSBDV5788';
        jET1.Key__c = 'AccountCodes';
        jETList.add(jET1);
        insert jETList;
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO; 
        
        List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomps = new CSS_Solution_Component__c();
        solcomps.Component_Id__c = 'F19000540';
        solcomps.Selected_Component__c = true;
        solcomps.CSS_Claims__c = claims1.Id;
        solcomps.System_Code__c = 'EQ';
        solcomps.Component_Code__c = 'PE';
        solcomps.Failure_Mode__c = 'HB';
        solcomps.AccountCode__c = '67';
        solcomps.AccountCodeType__c = 'NEW PRODUCT WARRANTY';
        solcomps.AccountCodeEdit__c = 'NEW PRODUCT WARRANTY 67';
        solcomps.CoveredTravelBaseFareAmt__c='100';
        solcomps.CoveredTravelMiles__c='100';
        solcomps.CoveredMealsLodgingAmt__c='100';
        solcomps.CoveredTravelLabor__c='1';
        solcomps.CoveredTowingMiles__c = '100000';
        solcompsList.add(solcomps);
        insert solcompsList;
        
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        id recordpartid = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        List<CSS_Parts_Options__c> paList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.CSS_Claims__c = claims1.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solcompsList[0].Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.HoursTravelled__c = 5;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='Test1;test2;test3';
        pa.ODM_Status_Code__c='500';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.Account_Code__c ='EMISSION WARRANTY 70';
        pa.Fail_Code__c='we-pq-';
        pa.RecordTypeId=recordpartid;
        pa.ExpenseTotal__c =1000;
        paList.add(pa);
        
        CSS_Parts_Options__c pa1 = new CSS_Parts_Options__c();
        pa1.Option_Number__c = 'O-111';
        pa1.CSS_Claims__c = claims1.Id;
        pa1.selected_part__c = true;
        pa1.FailurepartId__c = solcompsList[0].Id;
        pa1.Part_Assignment__c = 'Primary';
        pa1.Solutions__c=sol.Id;
        pa1.ODM_Status__c='warn';
        pa1.HoursTravelled__c = 5;
        pa1.ODM_Status_Message__c='Test1;test2;test3';
        pa1.ODM_Status_Code__c='500';
        pa1.Type__c='Non Commercial-Travel';
        pa1.Item__c='Ties';
        pa1.Account_Code__c ='EMISSION WARRANTY 70';
        pa1.Fail_Code__c='we-pq-';
        pa1.RecordTypeId=recordpartid;
        pa1.ExpenseTotal__c =500;
        pa1.Mileage__c=500;
        paList.add(pa1);
        
        CSS_Parts_Options__c pa2 = new CSS_Parts_Options__c();
        pa2.Option_Number__c = 'O-111';
        pa2.CSS_Claims__c = claims1.Id;
        pa2.selected_part__c = true;
        pa2.FailurepartId__c = solcompsList[0].Id;
        pa2.Part_Assignment__c = 'Primary';
        pa2.Solutions__c=sol.Id;
        pa2.ODM_Status__c='warn';
        pa2.ODM_Status_Message__c='Test1;test2;test3';
        pa2.ODM_Status_Code__c='500';
        pa2.Type__c='Meals';
        pa2.Item__c='Ties';
        pa2.HoursTravelled__c = 5;
        pa2.Account_Code__c ='EMISSION WARRANTY 70';
        pa2.Fail_Code__c='we-pq-';
        pa2.RecordTypeId=recordpartid;
        pa2.ExpenseTotal__c =500;
        pa2.Mileage__c=500;
        paList.add(pa2);
        
        CSS_Parts_Options__c pa3 = new CSS_Parts_Options__c();
        pa3.Option_Number__c = 'O-1112';
        pa3.CSS_Claims__c = claims1.Id;
        pa3.selected_part__c = true;
        pa3.FailurepartId__c = solcompsList[0].Id;
        pa3.Part_Assignment__c = 'Primary';
        pa3.Solutions__c=sol.Id;
        pa3.HoursTravelled__c = 5;
        pa3.ODM_Status__c='warn';
        pa3.ODM_Status_Message__c='Test1;test2;test3';
        pa3.ODM_Status_Code__c='500';
        pa3.Type__c='test1';//'Commercial-Travel';
        pa3.Item__c='Ties';
        pa3.Account_Code__c ='EMISSION WARRANTY 70';
        pa3.Fail_Code__c='we-pq-';
        pa3.RecordTypeId=recordpartid;
        pa3.ExpenseTotal__c =1000;
        paList.add(pa3);
        
        insert paList;
        CSS_Parts_Options__c pa4 = new CSS_Parts_Options__c();
        pa4.Option_Number__c = 'O-1112';
        pa4.CSS_Claims__c = claims1.Id;
        pa4.selected_part__c = true;
        pa4.FailurepartId__c = solcompsList[0].Id;
        pa4.Part_Assignment__c = 'Primary';
        pa4.Solutions__c=sol.Id;
        pa4.HoursTravelled__c = 5;
        pa4.ODM_Status__c='warn';
        pa4.ODM_Status_Message__c='Test1;test2;test3';
        pa4.ODM_Status_Code__c='500';
        pa4.Type__c='Towing';
        pa4.Item__c='Ties';
        pa4.Account_Code__c ='EMISSION WARRANTY 70';
        pa4.Fail_Code__c='we-pq-';
        pa4.RecordTypeId=recordpartid;
        pa4.ExpenseTotal__c =1000;
        insert pa4;
        paList.add(pa4);
        CG_CL_CoverageLimitExceedValidation covlimExVal = new CG_CL_CoverageLimitExceedValidation();
        map<string,map<string,string>> covLimTTML = new map<string,map<string,string>>();
        covLimTTML=covlimExVal.covLimitValidation_TTML(claims1.id,paList);
        List<String> covLimTTML1 = new List<String>();
        //covLimTTML1=covlimExVal.covLimitValidationTTML(null,claims1.id,paList,true);
        Set<String> covLimTTML2 = new Set<String>();
        List<String> covLimTTML3 = new List<String>();
        covLimTTML3.add('Commercial-Travel&Test');
        covLimTTML2=CG_CL_CoverageLimitExceedValidation.validationerrortypes(covLimTTML3);
        Map<String, Decimal> towingMap = new Map<String, Decimal>();
        towingMap.put(pa4.Type__c+'&'+pa4.Account_Code__c.trim(),10);
        //covLimTTML1=covlimExVal.covLimitValidationTTML(null,claims1.id,paList,true);
        Map<String, String> accCodeCovTypeMap = new Map<String, String>();
        string covtype;
        pa4.Account_Code__c ='NEW PARTS WARRANTY 62';
        accCodeCovTypeMap.put('62', 'NPW');
        covtype = accCodeCovTypeMap.get(pa4.Account_Code__c);
        pa4.Account_Code__c ='NEW PARTS WARRANTY 62';
        map<string,string> parterror = new  map<string,string>();
        towingMap.put(pa4.Type__c+'&'+pa4.Account_Code__c.trim(),10);
        parterror.put('Towing',label.CSS_Towing_Amount_claimed_exceeds_the_coverage_limit_for_the_Fail_Code+'@'+'THAS' +' '+Label.CSS_CoverageLimitExceedMsg_PW2 +' ' +'62');
        //covLimTTML1=covlimExVal.covLimitValidationTTML(null,claims1.id,paList,true);
        //pa4.FailurepartId__c = solcompsList[0].Id;
        towingMap.put(pa3.Type__c+'&'+pa4.Account_Code__c.trim(),1000000);
        solcompsList[0].CoveredTowingMiles__c = '1000000';
        covLimTTML1=covlimExVal.covLimitValidationTTML(null,claims1.id,paList,true);
        
        
    }
    
    public static testmethod void testMEthodforcovLimitValidation1(){
        
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO;
        
        CSS_Claims__c claimsRec = new CSS_Claims__c();
        claimsRec.Customer_Name__c='TestCustomer';
        claimsRec.Customer_Code__c = '1234';
        claimsRec.Contact_Last_Name__c = 'T';
        claimsRec.Address__c = 'T';
        claimsRec.CSS_Job__c = JO.id;
        claimsRec.Customer_Contact_Phone__c = null;
        claimsRec.Email_Address__c = 'RdB@nomail.com';
        claimsRec.Status__c = 'Draft';
        insert claimsRec;
        
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'NPW';
        jET.Attribute2__c  = 'NEW PARTS WARRANTY';
        jET.Attribute3__c = '62';
        jET.Attribute5__c = 'Y';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        insert jETList;
        
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        
        List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomps = new CSS_Solution_Component__c();
        solcomps.Component_Id__c = 'F19000540';
        solcomps.Selected_Component__c = true;
        solcomps.Service_Job__c = jo.Id;
        //solcomps.CSS_Claims__c=claimsRec.id;
        solcomps.System_Code__c = 'TH-';
        solcomps.Component_Code__c = 'A-C';
        solcomps.Failure_Mode__c = 'BT-';
        solcomps.AccountCodeEdit__c='TH-AC';
       
        solcomps.AccountCode__c = 'NEW- PARTS- WARRANTY- 62';
        solcomps.Type__c = 'NPW';//null;
        solcomps.CoveredPartsQty__c = '8';
        solcomps.CoveredOCAmount__c = '8';
        solcomps.CoveredTravelLabor__c='10';
        solcomps.CoveredTravelMiles__c='10';
        solcomps.CoveredMealsLodgingAmt__c='10';
        solcompsList.add(solcomps);
         CSS_Solution_Component__c solcomps1 = new CSS_Solution_Component__c();
        solcomps1.Component_Id__c = 'F19000540';
        solcomps1.Selected_Component__c = true;
        solcomps1.Service_Job__c = jo.Id;
        //solcomps.CSS_Claims__c=claimsRec.id;
        solcomps1.System_Code__c = 'TH';
        solcomps1.Component_Code__c = 'AC';
        solcomps1.Failure_Mode__c = 'BT-';
        solcomps1.AccountCodeEdit__c='TH-AC';
       //	solcomps1.AccountCodeType__c ='';
        solcomps1.AccountCode__c = 'NEW PARTS WARRANTY 62';
        solcomps1.Type__c = 'NPW';//null;
        solcomps1.CoveredPartsQty__c = '8';
        solcomps1.CoveredOCAmount__c = '8';
        solcomps1.CoveredTravelLabor__c='10';
        solcomps1.CoveredTravelMiles__c='10';
        solcomps1.CoveredMealsLodgingAmt__c='10';
        solcompsList.add(solcomps1);
        insert solcompsList;
        
        id recordpartid = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        
        List<CSS_Parts_Options__c> paList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solcompsList[0].Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='Test1;test2;test3';
        pa.ODM_Status_Code__c='500';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.Account_Code__c ='NEW PARTS WARRANTY 621';
        pa.Fail_Code__c='Turbocharger Actuator-THAC';
        pa.Quantity__c = 9.0;
        pa.RecordTypeId=recordpartid;
        pa.ExpenseTotal__c =1000;
        pa.Amount__c=500;
        paList.add(pa);
        
        CSS_Parts_Options__c pa1 = new CSS_Parts_Options__c();
        pa1.Option_Number__c = 'O-111';
        pa1.Service_Job__c = jo.Id;
        pa1.selected_part__c = true;
        pa1.FailurepartId__c = solcompsList[0].Id;
        pa1.Part_Assignment__c = 'Primary';
        pa1.Solutions__c=sol.Id;
        pa1.ODM_Status__c='warn';
        pa1.ODM_Status_Message__c='Test1;test2;test3';
        pa1.ODM_Status_Code__c='500';
        pa1.Type__c='Lodging';
        pa1.Item__c='Ties';
        pa1.Account_Code__c ='NEW PARTS WARRANTY 62';
        pa1.Fail_Code__c='Turbocharger Actuator-THAC';
        pa1.Quantity__c = 10.0;
        pa1.RecordTypeId=recordpartid;
        pa1.ExpenseTotal__c =1000;
        pa1.Amount__c=500;
         pa1.HoursTravelled__c =1000;
        pa1.Mileage__c=500;
        paList.add(pa1);
        
        
        CSS_Parts_Options__c pa3 = new CSS_Parts_Options__c();
        pa3.Option_Number__c = 'O-1112';
        pa3.Service_Job__c = jo.Id;
        pa3.selected_part__c = true;
        pa3.FailurepartId__c = solcompsList[0].Id;
        pa3.Part_Assignment__c = 'Primary';
        pa3.Solutions__c=sol.Id;
        pa3.ODM_Status__c='warn';
        pa3.ODM_Status_Message__c='Test1;test2;test3';
        pa3.ODM_Status_Code__c='500';
        pa3.Type__c='Meals';
        pa3.Item__c='Ties';
        pa3.Account_Code__c ='NEW PARTS WARRANTY 62';
        pa3.Fail_Code__c='Turbocharger Actuator-THAC';
        pa3.Quantity__c = 10.0;
        pa3.RecordTypeId=recTypeIdpartTemp;
        pa3.ExpenseTotal__c =1000;
        pa3.Amount__c=500;
          pa3.HoursTravelled__c =1000;
        pa3.Mileage__c=500;
        paList.add(pa3);
        
        CSS_Parts_Options__c pa31 = new CSS_Parts_Options__c();
        pa31.Option_Number__c = 'O-1112';
        pa31.Service_Job__c = jo.Id;
        pa31.selected_part__c = true;
        pa31.FailurepartId__c = solcompsList[0].Id;
        pa31.Part_Assignment__c = 'Primary';
        pa31.Solutions__c=sol.Id;
        pa31.ODM_Status__c='warn';
        pa31.ODM_Status_Message__c='Test1;test2;test3';
        pa31.ODM_Status_Code__c='500';
        pa31.Type__c='Non Commercial-Travel';
        pa31.Item__c='Ties';
        pa31.Account_Code__c ='NEW PARTS WARRANTY 62';
        pa31.Fail_Code__c='t-THAC';
        pa31.Quantity__c = 10.0;
        pa31.RecordTypeId=recTypeIdpartTemp;
        pa31.ExpenseTotal__c =1000;
        pa31.Amount__c=500;
        pa31.HoursTravelled__c =1000;
        pa31.Mileage__c=500;
        paList.add(pa31);
        
        insert paList;
        
        
        Test.startTest();
        CG_CL_CoverageLimitExceedValidation CL = new CG_CL_CoverageLimitExceedValidation();
        system.debug('testing');
        CL.covLimitValidation(JO.id,claimsRec.id,null, null);
        CL.covLimitValidation(JO.id,claimsRec.id,null, paList);
        CL.covLimitValidationSRT(JO.id,claimsRec.id);
        CL.covLimitfailcodeValidation(JO.id,claimsRec.id);
        CL.covLimitfailcodeJobValidation(JO.id,null);
         CL.covLimitValidationJob(JO.id,paList);
        CL.covLimitValidationJob(JO.id,null);
        CL.CoverageLimitValidation_TTML(jo.id,paList);
         
        Test.stopTest();
    }
    
    public static testmethod void testMEthodforcovLimitValidation2(){
        
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO;
        
        CSS_Claims__c claimsRec = new CSS_Claims__c();
        claimsRec.Customer_Name__c='TestCustomer';
        claimsRec.Customer_Code__c = '1234';
        claimsRec.Contact_Last_Name__c = 'T';
        claimsRec.Address__c = 'T';
        claimsRec.CSS_Job__c = JO.id;
        claimsRec.Customer_Contact_Phone__c = null;
        claimsRec.Email_Address__c = 'RdB@nomail.com';
        claimsRec.Status__c = 'Draft';
        insert claimsRec;
        
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'NPW';
        jET.Attribute2__c  = 'NEW PARTS WARRANTY';
        jET.Attribute3__c = '62';
        jET.Attribute5__c = 'Y';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        insert jETList;
        
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        
        List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomps = new CSS_Solution_Component__c();
        solcomps.Component_Id__c = 'F19000540';
        solcomps.Selected_Component__c = true;
        solcomps.Service_Job__c = jo.Id;
        solcomps.System_Code__c = 'TH';
        solcomps.Component_Code__c = 'AC';
        solcomps.Failure_Mode__c = 'BT';
        solcomps.AccountCode__c = 'NEW PARTS WARRANTY 62';
        solcomps.Type__c = null;
        solcomps.CoveredPartsQty__c = '8';
        solcomps.CoveredOCAmount__c = '8';
        solcompsList.add(solcomps);
        insert solcompsList;
        
        id recordpartid = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        
        List<CSS_Parts_Options__c> paList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solcompsList[0].Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='Test1;test2;test3';
        pa.ODM_Status_Code__c='500';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.Account_Code__c ='NEW PARTS WARRANTY 62';
        pa.Fail_Code__c='Turbocharger Actuator-THAC';
        pa.Quantity__c = 8.0;
        pa.RecordTypeId=recordpartid;
        pa.ExpenseTotal__c =1000;
        pa.Amount__c=500;
        paList.add(pa);
        
        
        
        CSS_Parts_Options__c pa3 = new CSS_Parts_Options__c();
        pa3.Option_Number__c = 'O-1112';
        pa3.Service_Job__c = jo.Id;
        pa3.selected_part__c = true;
        pa3.FailurepartId__c = solcompsList[0].Id;
        pa3.Part_Assignment__c = 'Primary';
        pa3.Solutions__c=sol.Id;
        pa3.ODM_Status__c='warn';
        pa3.ODM_Status_Message__c='Test1;test2;test3';
        pa3.ODM_Status_Code__c='500';
        pa3.Type__c='Commercial-Travel';
        pa3.Item__c='Ties';
        pa3.Account_Code__c ='NEW PARTS WARRANTY 62';
        pa3.Fail_Code__c='Turbocharger Actuator-THAC';
        pa3.Quantity__c = 8.0;
        pa3.RecordTypeId=recTypeIdpartTemp;
        pa3.ExpenseTotal__c =1000;
        pa3.Amount__c=500;
        paList.add(pa3);
        
        insert paList;
        
        
        Test.startTest();
        CG_CL_CoverageLimitExceedValidation CL = new CG_CL_CoverageLimitExceedValidation();
        system.debug('testing');
        CL.covLimitValidation(JO.id,claimsRec.id,null, null);
        CL.covLimitValidation(JO.id,claimsRec.id,null, paList);
        CL.covLimitValidationSRT(JO.id,claimsRec.id);
        CL.covLimitfailcodeValidation(JO.id,claimsRec.id);
        CL.covLimitfailcodeJobValidation(JO.id,null);
        Test.stopTest();
    }
    
    public static testmethod void testMEthodforcovLimitValidation3(){
        
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO;
        
        CSS_Claims__c claimsRec = new CSS_Claims__c();
        claimsRec.Customer_Name__c='TestCustomer';
        claimsRec.Customer_Code__c = '1234';
        claimsRec.Contact_Last_Name__c = 'T';
        claimsRec.Address__c = 'T';
        claimsRec.CSS_Job__c = JO.id;
        claimsRec.Customer_Contact_Phone__c = null;
        claimsRec.Email_Address__c = 'RdB@nomail.com';
        claimsRec.Status__c = 'Draft';
        insert claimsRec;
        
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'NPW';
        jET.Attribute2__c  = 'NEW PARTS WARRANTY';
        jET.Attribute3__c = '62';
        jET.Attribute5__c = 'Y';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        insert jETList;
        
        css_solutions__c sol = css_testdata.createSolutions(true, jo.Id);
        
        List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomps = new CSS_Solution_Component__c();
        solcomps.Component_Id__c = 'F19000540';
        solcomps.Selected_Component__c = true;
        solcomps.Service_Job__c = jo.Id;
        solcomps.System_Code__c = 'TH';
        solcomps.Component_Code__c = 'AC';
        solcomps.Failure_Mode__c = 'BT';
        solcomps.AccountCode__c = 'NEW PARTS WARRANTY 62';
        solcomps.Type__c = null;
        solcomps.CoveredPartsQty__c = '8';
        solcomps.CoveredOCAmount__c = '8';
        solcompsList.add(solcomps);
        insert solcompsList;
        
        id recordpartid = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        
        List<CSS_Parts_Options__c> paList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
        pa.Option_Number__c = 'O-111';
        pa.Service_Job__c = jo.Id;
        pa.selected_part__c = true;
        pa.FailurepartId__c = solcompsList[0].Id;
        pa.Part_Assignment__c = 'Primary';
        pa.Solutions__c=sol.Id;
        pa.ODM_Status__c='warn';
        pa.ODM_Status_Message__c='Test1;test2;test3';
        pa.ODM_Status_Code__c='500';
        pa.Type__c='Commercial-Travel';
        pa.Item__c='Ties';
        pa.Account_Code__c ='NEW PARTS WARRANTY 62';
        pa.Fail_Code__c='Turbocharger Actuator-THAC';
        pa.Quantity__c = 7.0;
        pa.RecordTypeId=recordpartid;
        pa.ExpenseTotal__c =1000;
        pa.Amount__c=500;
        paList.add(pa);
        
        Test.startTest();
        CG_CL_CoverageLimitExceedValidation CL = new CG_CL_CoverageLimitExceedValidation();
        system.debug('testing');
        CL.covLimitValidation(JO.id,claimsRec.id,null, null);
        CL.covLimitValidation(JO.id,claimsRec.id,null, paList);
        CL.covLimitValidationSRT(JO.id,claimsRec.id);
        CL.covLimitfailcodeValidation(JO.id,claimsRec.id);
         CL.covLimitfailcodeJobValidation(JO.id,null);
        
        Test.stopTest();
    }
    
    public static testmethod void AA(){
        
        List<String> covLimTTML = new List<String>();
        covLimTTML.add('Commercial-Travel & Coverage type exceed');
        //covLimTTML.add('Non Commercial-Travel & Coverage type exceed ');
        
        Test.startTest();
        CG_CL_CoverageLimitExceedValidation CL = new CG_CL_CoverageLimitExceedValidation(); 
        system.debug('mri');
        CG_CL_CoverageLimitExceedValidation.validationerrortypes(covLimTTML);
        Test.stopTest();
    } 
    
    public static Testmethod void Cov(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO; 
        
        
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.Customer_Name__c='TestCustomer';
        testclaimsRec.Customer_Code__c = '1234';
        testclaimsRec.Contact_Last_Name__c = 'T';
        testclaimsRec.Address__c = 'T';
        //testclaimsRec.CSS_Job__c = JO.id;
        testclaimsRec.Customer_Contact_Phone__c = null;
        testclaimsRec.Email_Address__c = 'RdB@nomail.com';
        testclaimsRec.Status__c = 'Draft';
        testclaimsRec.Account__c=acc.Id;
        insert testclaimsRec;
        
        List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
        
        CSS_Solution_Component__c comp1 = new CSS_Solution_Component__c();
        comp1.Type__c =  'Campaign';
        comp1.Component_Id__c = 'F19000540';
        comp1.Selected_Component__c = true;
        comp1.CSS_Claims__c = testclaimsRec.Id;
        comp1.System_Code__c = 'TH';
        comp1.Fail_Code_Editable__c='THAC';
        comp1.Component_Code__c = 'AC';
        comp1.Failure_Mode__c = 'HB';
        comp1.AccountCodeEdit__c = 'PARTS WARRANTY - DEFECT FROM STOCK 35';
        comp1.CoveredTravelBaseFareAmt__c='0';
        comp1.CoveredPartsQty__c='0.0';
        comp1.CampaignPartsPercentage__c='';
        comp1.CoveredTravelMiles__c='0';
        comp1.CoveredTowingMiles__c='0.0';
        comp1.CoveredMealsLodgingAmt__c='0';
        comp1.CampaignTravelPercentage__c='0';
        comp1.CoveredOCAmount__c='0';
        comp1.CoveredLaborHrs__c='0';
        comp1.CampaignTravelPercentage__c='10';
        comp1.CampaignTowingPercentage__c = '10';
        comp1.CampaignOCPercentage__c = '10';
        comp1.CampaignLaborPercentage__c='10';
        solcompsList.add(comp1);   
        
        CSS_Solution_Component__c comp2 = new CSS_Solution_Component__c();
        comp2.Type__c =  'Campaign';
        comp2.Component_Id__c = 'F19000540';
        comp2.Selected_Component__c = true;
        comp2.CSS_Claims__c = testclaimsRec.Id;
        comp2.System_Code__c = 'TH';
        comp2.Fail_Code_Editable__c='THAC';
        comp2.Component_Code__c = 'AC';
        comp2.Failure_Mode__c = 'HB';
        comp2.AccountCodeEdit__c = 'PARTS WARRANTY - DEFECT FROM STOCK 35';
        comp2.CoveredTravelBaseFareAmt__c='0';
        comp2.CoveredPartsQty__c='0.0';
        comp2.CampaignPartsPercentage__c='20';
        comp2.CoveredTravelMiles__c='0';
        comp2.CoveredTowingMiles__c='0.0';
        comp2.CoveredMealsLodgingAmt__c='0';
        comp2.CampaignTravelPercentage__c='0';
        comp2.CoveredOCAmount__c='0';
        comp2.CoveredLaborHrs__c='0';
        comp2.CampaignLaborPercentage__c='0';
        solcompsList.add(comp2);   
        insert solcompsList;
        
    
        id recordpartid = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        
        css_header_nav__c cssHeaderObject = new css_header_nav__c();
        cssHeaderObject.Name = 'Test Setting';
        cssHeaderObject.RSWButtonEnable__c = true;
        
        insert cssHeaderObject;
        
        List<CSS_SRT__c> srtLst = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Account_Code__c='EMISSION WARRANTY 70';
        srt.FailCode__c='THAC';
        srt.Type__c='99time';
        srt.CSS_Claims__c=testclaimsRec.Id;
        srt.isPerformed__c=true;
        srt.Extended_Hours__c=10;
        srtLst.add(srt);
        
        CG_CL_CoverageLimitExceedValidation covlimExVal = new CG_CL_CoverageLimitExceedValidation();
        Set<String> covLimExceed = new Set<String>();
        covLimExceed=covlimExVal.covLimitValidation(JO.id, null, null, null);
        List<Boolean> boolList = new List<Boolean>();
        boolList=covlimExVal.checkFailuresCovered(testclaimsRec.id, true);
        covlimExVal.covLimitValidationSRT(null,testclaimsRec.Id);
        covlimExVal.covLimitfailcodeValidation(null,testclaimsRec.Id);
        covlimExVal.covLimitfailcodeJobValidation(Jo.id,null);
        List<String> CovLimMsg = new List<String>();
        covlimExVal.covLimitfailcodeValidation(null,testclaimsRec.Id);
        covlimExVal.covLimitfailcodeJobValidation(Jo.id,null);
    }
    
}