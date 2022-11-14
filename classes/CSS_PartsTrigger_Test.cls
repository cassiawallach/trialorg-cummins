@isTest
public class CSS_PartsTrigger_Test { 
    
    static testmethod void CSS_PartsTrigger_TestMethod1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, DefaultCurrencyIsoCode='CAD',CurrencyIsoCode='CAD',
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;
        
        system.runAs(newUser){
            CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Unit_Number__c = '123456';
            JO.Failure_Point__c = 1.5;
            JO.Failure_Point_Measure__c = 'qw';       
            JO.Customer_Name__c = 'CumminsTnD';
            JO.Status__c = 'Repair Complete';
            JO.ESN__c = 'test1234';
            jo.DSID_WorkGroup__c = '';
            JO.DSID_Creation_Timestamp__c = system.now();
            JO.DSID_Status__c = 'open';
            JO.ESN_Locked__c = true;
            JO.ESN_Insite__c = '79464646';
            JO.Application__c = 'test1234';
            JO.Failure_Point__c = 1234;
            JO.Failure_Point_Measure__c = 'test1234';
            JO.Make__c = 'BMC';
            JO.Equipment_ID__c = 'equip';
            JO.Model__c = 'MILITARY';
            JO.DSID__c = null;
            JO.Equipment_ID__c = 'test1234';
            JO.Service_Model__c = 'test1234';
            JO.Shop_Work_Order__c = 'test1234';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.AccessCode__c ='A';
            insert(JO);
            
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym.Job_Order__c=JO.id;
            sym.caption__c ='white smoke';
            sym.Option1__c  ='12213';
            sym.Job_Order__c  =Jo.id;
            sym.Option_type__c  ='qwewqe';
            sym.Guide_Question__c  ='1asdsad2213';
            sym.Type__c  ='SearchString';
            sym.Answers__c = 'FCCodeUI';
            sym.Caption__c = 'cap';
            sym.Sequence__c = 1.6;
            
            insert sym;
            
            CSS_Solutions__c sol=new CSS_Solutions__c();
            //  sol.caseIndexInResultSet__c='test';
            sol.Case_Name__c='test';
            sol.Name = 'sol';
            sol.Rank__c = 0;
            sol.Diagnostic_Response__c = null;
            sol.Repair_Response__c='test';
            sol.Symptom__c=sym.id;
            sol.Service_Job__c=JO.id;
            insert sol;
            
            CSS_Solution_Component__c srtComp = new CSS_Solution_Component__c();
            srtComp.Solutions__c = sol.id;
            srtComp.Quantity__c = 1;
            srtComp.Action__c='asdsad';
            srtComp.Service_Job__c =jo.id;
            srtComp.Selected_Component__c = true;
            insert srtComp;
            List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
            CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
            aud.Object_Name__c = 'CSS_Parts_Options__c';
            aud.Name = 'Claim Status Edit';
            aud.Action_Type__c = 'Event Add';
            aud.Field_Name__c = 'Catastrophic__c';
            aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
            aud.Dynamic_Message__c = true;
            insert aud;
            List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();
            Currency_Conversion__c ccc = new Currency_Conversion__c();
            ccc.Bolt_Conversion_Rate__c = 23.8;
            ccc.Bolt_To_Currency__c =userinfo.getDefaultCurrency();
            ccc.Bolt_Version__c = 23;
            insert ccc;
            Currency_Conversion__c ccc1 = new Currency_Conversion__c();
            ccc1.Bolt_Conversion_Rate__c = 23.8;
            ccc1.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
            ccc1.Bolt_Version__c = 23;
            insert ccc1;
            system.debug('ccc.Bolt_To_Currency__c'+ccc.Bolt_To_Currency__c);
            lstCurrencyDetails.add(ccc);
            lstCurrencyDetails.add(ccc1);
            Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
            CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
            parts1.selected_part__c = True;
            parts1.Service_Job__c=Jo.id;
            parts1.CSS_Claims__c=null;
            parts1.FailurepartId__c = srtComp.Id;
            parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            parts1.RecordTypeId=recTypeIdPart;
            parts1.Sell_Price__c=100.0;
            parts1.Fail_Code__c = 'THAS';
            insert parts1;  
            
            
            
            parts1.Fail_Code__c = 'THAC';
            update parts1;
        }
    }
    static testmethod void CSS_PartsTrigger_TestMethod2(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, DefaultCurrencyIsoCode='USD',CurrencyIsoCode='USD',
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;
        
        system.runAs(newUser){
            CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Unit_Number__c = '123456';
            JO.Failure_Point__c = 1.5;
            JO.Failure_Point_Measure__c = 'qw';       
            JO.Customer_Name__c = 'CumminsTnD';
            JO.Status__c = 'Repair Complete';
            JO.ESN__c = 'test1234';
            jo.DSID_WorkGroup__c = '';
            JO.DSID_Creation_Timestamp__c = system.now();
            JO.DSID_Status__c = 'open';
            JO.ESN_Locked__c = true;
            JO.ESN_Insite__c = '79464646';
            JO.Application__c = 'test1234';
            JO.Failure_Point__c = 1234;
            JO.Failure_Point_Measure__c = 'test1234';
            JO.Make__c = 'BMC';
            JO.Equipment_ID__c = 'equip';
            JO.Model__c = 'MILITARY';
            JO.DSID__c = null;
            JO.Equipment_ID__c = 'test1234';
            JO.Service_Model__c = 'test1234';
            JO.Shop_Work_Order__c = 'test1234';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.AccessCode__c ='A';
            insert(JO);
            
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym.Job_Order__c=JO.id;
            sym.caption__c ='white smoke';
            sym.Option1__c  ='12213';
            sym.Job_Order__c  =Jo.id;
            sym.Option_type__c  ='qwewqe';
            sym.Guide_Question__c  ='1asdsad2213';
            sym.Type__c  ='SearchString';
            sym.Answers__c = 'FCCodeUI';
            sym.Caption__c = 'cap';
            sym.Sequence__c = 1.6;
            
            insert sym;
            
            CSS_Solutions__c sol=new CSS_Solutions__c();
            //  sol.caseIndexInResultSet__c='test';
            sol.Case_Name__c='test';
            sol.Name = 'sol';
            sol.Rank__c = 0;
            sol.Diagnostic_Response__c = null;
            sol.Repair_Response__c='test';
            sol.Symptom__c=sym.id;
            sol.Service_Job__c=JO.id;
            insert sol;
            
            CSS_Solution_Component__c srtComp = new CSS_Solution_Component__c();
            srtComp.Solutions__c = sol.id;
            srtComp.Quantity__c = 1;
            srtComp.Action__c='asdsad';
            srtComp.Service_Job__c =jo.id;
            srtComp.Selected_Component__c = true;
            insert srtComp;
            List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
            CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
            aud.Object_Name__c = 'CSS_Parts_Options__c';
            aud.Name = 'Claim Status Edit';
            aud.Action_Type__c = 'Event Add';
            aud.Field_Name__c = 'Catastrophic__c';
            aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
            aud.Dynamic_Message__c = true;
            insert aud;
            List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();
            Currency_Conversion__c ccc = new Currency_Conversion__c();
            ccc.Bolt_Conversion_Rate__c = 23.8;
            ccc.Bolt_To_Currency__c =userinfo.getDefaultCurrency();
            ccc.Bolt_Version__c = 23;
            insert ccc;
            Currency_Conversion__c ccc1 = new Currency_Conversion__c();
            ccc1.Bolt_Conversion_Rate__c = 23.8;
            ccc1.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
            ccc1.Bolt_Version__c = 23;
            insert ccc1;
            system.debug('ccc.Bolt_To_Currency__c'+ccc.Bolt_To_Currency__c);
            lstCurrencyDetails.add(ccc);
            lstCurrencyDetails.add(ccc1);
            Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
            CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
            parts1.selected_part__c = True;
            parts1.Service_Job__c=Jo.id;
            parts1.CSS_Claims__c=null;
            parts1.FailurepartId__c = srtComp.Id;
            parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            parts1.RecordTypeId=recTypeIdPart;
            parts1.Sell_Price__c=100.0;
            parts1.Fail_Code__c = 'THAS';
            insert parts1;  
            
            
            
            parts1.Fail_Code__c = 'THAC';
            update parts1;
        }
    }
    static testmethod void CSS_PartsTrigger_TestMethod3(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, DefaultCurrencyIsoCode='CAD',CurrencyIsoCode='CAD',
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;
        
        system.runAs(newUser){
            CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Unit_Number__c = '123456';
            JO.Failure_Point__c = 1.5;
            JO.Failure_Point_Measure__c = 'qw';       
            JO.Customer_Name__c = 'CumminsTnD';
            JO.Status__c = 'Repair Complete';
            JO.ESN__c = 'test1234';
            jo.DSID_WorkGroup__c = '';
            JO.DSID_Creation_Timestamp__c = system.now();
            JO.DSID_Status__c = 'open';
            JO.ESN_Locked__c = true;
            JO.ESN_Insite__c = '79464646';
            JO.Application__c = 'test1234';
            JO.Failure_Point__c = 1234;
            JO.Failure_Point_Measure__c = 'test1234';
            JO.Make__c = 'BMC';
            JO.Equipment_ID__c = 'equip';
            JO.Model__c = 'MILITARY';
            JO.DSID__c = null;
            JO.Equipment_ID__c = 'test1234';
            JO.Service_Model__c = 'test1234';
            JO.Shop_Work_Order__c = 'test1234';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.AccessCode__c ='A';
            insert(JO);
            
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym.Job_Order__c=JO.id;
            sym.caption__c ='white smoke';
            sym.Option1__c  ='12213';
            sym.Job_Order__c  =Jo.id;
            sym.Option_type__c  ='qwewqe';
            sym.Guide_Question__c  ='1asdsad2213';
            sym.Type__c  ='SearchString';
            sym.Answers__c = 'FCCodeUI';
            sym.Caption__c = 'cap';
            sym.Sequence__c = 1.6;
            
            insert sym;
            
            CSS_Solutions__c sol=new CSS_Solutions__c();
            //  sol.caseIndexInResultSet__c='test';
            sol.Case_Name__c='test';
            sol.Name = 'sol';
            sol.Rank__c = 0;
            sol.Diagnostic_Response__c = null;
            sol.Repair_Response__c='test';
            sol.Symptom__c=sym.id;
            sol.Service_Job__c=JO.id;
            insert sol;
            
            CSS_Solution_Component__c srtComp = new CSS_Solution_Component__c();
            srtComp.Solutions__c = sol.id;
            srtComp.Quantity__c = 1;
            srtComp.Action__c='asdsad';
            srtComp.Service_Job__c =jo.id;
            srtComp.Selected_Component__c = true;
            insert srtComp;
            List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
            CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
            aud.Object_Name__c = 'CSS_Parts_Options__c';
            aud.Name = 'Claim Status Edit';
            aud.Action_Type__c = 'Event Add';
            aud.Field_Name__c = 'Catastrophic__c';
            aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
            aud.Dynamic_Message__c = true;
            insert aud;
            List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();
            Currency_Conversion__c ccc = new Currency_Conversion__c();
            ccc.Bolt_Conversion_Rate__c = 23.8;
            ccc.Bolt_To_Currency__c =userinfo.getDefaultCurrency();
            ccc.Bolt_Version__c = 23;
            insert ccc;
            Currency_Conversion__c ccc1 = new Currency_Conversion__c();
            ccc1.Bolt_Conversion_Rate__c = 23.8;
            ccc1.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
            ccc1.Bolt_Version__c = 23;
            insert ccc1;
            system.debug('ccc.Bolt_To_Currency__c'+ccc.Bolt_To_Currency__c);
            lstCurrencyDetails.add(ccc);
            lstCurrencyDetails.add(ccc1);
            Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
            CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
            parts1.selected_part__c = True;
            parts1.Service_Job__c=Jo.id;
            parts1.CSS_Claims__c=null;
            parts1.FailurepartId__c = srtComp.Id;
            parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            parts1.RecordTypeId=recTypeIdPart;
            parts1.Sell_Price__c=100.0;
            parts1.ExpenseTotal__c=10.0;
            parts1.Fail_Code__c = 'THAS';
            insert parts1;  
            
            
            
            parts1.Fail_Code__c = 'THAC';
            update parts1;
        }
    }
    static testmethod void CSS_PartsTrigger_TestMethod4(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, DefaultCurrencyIsoCode='USD',CurrencyIsoCode='USD',
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;
        
        system.runAs(newUser){
            CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Unit_Number__c = '123456';
            JO.Failure_Point__c = 1.5;
            JO.Failure_Point_Measure__c = 'qw';       
            JO.Customer_Name__c = 'CumminsTnD';
            JO.Status__c = 'Repair Complete';
            JO.ESN__c = 'test1234';
            jo.DSID_WorkGroup__c = '';
            JO.DSID_Creation_Timestamp__c = system.now();
            JO.DSID_Status__c = 'open';
            JO.ESN_Locked__c = true;
            JO.ESN_Insite__c = '79464646';
            JO.Application__c = 'test1234';
            JO.Failure_Point__c = 1234;
            JO.Failure_Point_Measure__c = 'test1234';
            JO.Make__c = 'BMC';
            JO.Equipment_ID__c = 'equip';
            JO.Model__c = 'MILITARY';
            JO.DSID__c = null;
            JO.Equipment_ID__c = 'test1234';
            JO.Service_Model__c = 'test1234';
            JO.Shop_Work_Order__c = 'test1234';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.AccessCode__c ='A';
            insert(JO);
            
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym.Job_Order__c=JO.id;
            sym.caption__c ='white smoke';
            sym.Option1__c  ='12213';
            sym.Job_Order__c  =Jo.id;
            sym.Option_type__c  ='qwewqe';
            sym.Guide_Question__c  ='1asdsad2213';
            sym.Type__c  ='SearchString';
            sym.Answers__c = 'FCCodeUI';
            sym.Caption__c = 'cap';
            sym.Sequence__c = 1.6;
            
            insert sym;
            
            CSS_Solutions__c sol=new CSS_Solutions__c();
            //  sol.caseIndexInResultSet__c='test';
            sol.Case_Name__c='test';
            sol.Name = 'sol';
            sol.Rank__c = 0;
            sol.Diagnostic_Response__c = null;
            sol.Repair_Response__c='test';
            sol.Symptom__c=sym.id;
            sol.Service_Job__c=JO.id;
            insert sol;
            
            CSS_Solution_Component__c srtComp = new CSS_Solution_Component__c();
            srtComp.Solutions__c = sol.id;
            srtComp.Quantity__c = 1;
            srtComp.Action__c='asdsad';
            srtComp.Service_Job__c =jo.id;
            srtComp.Selected_Component__c = true;
            insert srtComp;
            List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
            CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
            aud.Object_Name__c = 'CSS_Parts_Options__c';
            aud.Name = 'Claim Status Edit';
            aud.Action_Type__c = 'Event Add';
            aud.Field_Name__c = 'Catastrophic__c';
            aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
            aud.Dynamic_Message__c = true;
            insert aud;
            List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();
            Currency_Conversion__c ccc = new Currency_Conversion__c();
            ccc.Bolt_Conversion_Rate__c = 23.8;
            ccc.Bolt_To_Currency__c =userinfo.getDefaultCurrency();
            ccc.Bolt_Version__c = 23;
            insert ccc;
            Currency_Conversion__c ccc1 = new Currency_Conversion__c();
            ccc1.Bolt_Conversion_Rate__c = 23.8;
            ccc1.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
            ccc1.Bolt_Version__c = 23;
            insert ccc1;
            system.debug('ccc.Bolt_To_Currency__c'+ccc.Bolt_To_Currency__c);
            lstCurrencyDetails.add(ccc);
            lstCurrencyDetails.add(ccc1);
            Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
            CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
            parts1.selected_part__c = True;
            parts1.Service_Job__c=Jo.id;
            parts1.CSS_Claims__c=null;
            parts1.FailurepartId__c = srtComp.Id;
            parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            parts1.RecordTypeId=recTypeIdPart;
            parts1.Unit_Price_Local_Currency__c=10.0;
            parts1.Unit_Price__c='10.0';
            parts1.Sell_Price__c=100.0;
            parts1.Fail_Code__c = 'THAS';
            insert parts1;  
            
            
            
            parts1.Fail_Code__c = 'THAC';
            update parts1;
        }
    }
    
    static testmethod void CSS_PartsTrigger_TestMethodOC1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, DefaultCurrencyIsoCode='CAD',CurrencyIsoCode='CAD',
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;
        
        system.runAs(newUser){
            //system.runas(new User(Id=UserInfo.getUserId())){  */
            
            Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
            
            
            CSS_Claims__c claim = new CSS_Claims__c();
            claim.Account__c = acc.id;
            claim.Customer_Name__c='PrabhuTrucks';
            claim.Customer_Code__c='123';
            claim.Status__c='Draft';
            claim.Actual_Technician_Time__c=1.2;
            claim.Catastrophic__c = true;
            insert claim;
            
            CSS_SRT__c srt = new CSS_SRT__c();
            srt.SRT_Title__c='test';
            srt.SRT_Quantity__c=123;
            srt.SRT_Time__c=123;
            srt.SRT_Access_Code__c='test';
            srt.SRT_Category__c='';
            srt.CSS_Claims__c= claim.id;
            srt.Type__c='Field Action';
            srt.isPerformed__c =  true;
            srt.SRT_Category__c='';
            srt.srt_type__c='ATC';
            srt.SRT_ID__c = '00-10S-00';
            insert srt;
            
            
            
            CSS_Solution_Component__c sc = new CSS_Solution_Component__c();
            sc.Name = 'test';
            sc.CSS_Claims__c = claim.id;
            sc.Selected_Component__c=false;
            sc.Type__c = 'Diagnosis';
            insert sc;
            
            Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
            
            List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
            CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
            aud.Object_Name__c = 'CSS_Parts_Options__c';
            aud.Name = 'Claim Status Edit';
            aud.Action_Type__c = 'Event Add';
            aud.Field_Name__c = 'Catastrophic__c';
            aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
            aud.Dynamic_Message__c = true;
            insert aud;
            aud.Dynamic_Message__c = false;
            update aud;
            List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();
            Currency_Conversion__c ccc = new Currency_Conversion__c();
            ccc.Bolt_Conversion_Rate__c = 23.8;
            ccc.Bolt_To_Currency__c =userinfo.getDefaultCurrency();
            ccc.Bolt_Version__c = 23;
            insert ccc;
            Currency_Conversion__c ccc1 = new Currency_Conversion__c();
            ccc1.Bolt_Conversion_Rate__c = 23.8;
            ccc1.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
            ccc1.Bolt_Version__c = 23;
            insert ccc1;
            system.debug('ccc.Bolt_To_Currency__c'+ccc.Bolt_To_Currency__c);
            lstCurrencyDetails.add(ccc);
            lstCurrencyDetails.add(ccc1);
            // list<CSS_Parts_Options__c> partslist = new list<CSS_Parts_Options__c>();
            CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
            parts1.selected_part__c = True;
            parts1.CSS_Claims__c=claim.id;
            parts1.Unit_Price__c='10.0';       
            parts1.FailurepartId__c = sc.Id;
            parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            parts1.Fail_Code__c = 'THAS';
            parts1.ReturnToFactory__c = 'Y';
            parts1.ReturnWaiver__c = false;
            parts1.Parts_Type__c ='Custom';
            parts1.Exchange_Rate_Version__c=23;
            parts1.RecordTypeId = recTypeIdPart;
            parts1.Part_Assignment__c = 'Primary';
            parts1.ExpenseTotal__c=10.0;
            insert parts1;
            
            
            
            parts1.Fail_Code__c = 'THAC';
            update parts1;
            delete parts1;
            
        }  
    }
    static testmethod void CSS_PartsTrigger_TestMethodOC2(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, DefaultCurrencyIsoCode='CAD',CurrencyIsoCode='CAD',
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;
        
        system.runAs(newUser){
            //system.runas(new User(Id=UserInfo.getUserId())){  */
            
            Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
            CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Unit_Number__c = '123456';
            JO.Failure_Point__c = 1.5;
            JO.Failure_Point_Measure__c = 'qw';       
            JO.Customer_Name__c = 'CumminsTnD';
            JO.Status__c = 'Repair Complete';
            JO.ESN__c = 'test1234';
            jo.DSID_WorkGroup__c = '';
            JO.DSID_Creation_Timestamp__c = system.now();
            JO.DSID_Status__c = 'open';
            JO.ESN_Locked__c = true;
            JO.ESN_Insite__c = '79464646';
            JO.Application__c = 'test1234';
            JO.Failure_Point__c = 1234;
            JO.Failure_Point_Measure__c = 'test1234';
            JO.Make__c = 'BMC';
            JO.Equipment_ID__c = 'equip';
            JO.Model__c = 'MILITARY';
            JO.DSID__c = null;
            JO.Equipment_ID__c = 'test1234';
            JO.Service_Model__c = 'test1234';
            JO.Shop_Work_Order__c = 'test1234';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.AccessCode__c ='A';
            insert(JO);
            
            
            CSS_Claims__c claim = new CSS_Claims__c();
            claim.Account__c = acc.id;
            claim.Customer_Name__c='PrabhuTrucks';
            claim.CSS_Job__c=JO.id;
            claim.Dealer_Service_Job__c=JO.id;
            claim.Customer_Code__c='123';
            claim.Status__c='Draft';
            claim.Actual_Technician_Time__c=1.2;
            claim.Catastrophic__c = true;
            insert claim;
            
            CSS_SRT__c srt = new CSS_SRT__c();
            srt.SRT_Title__c='test';
            srt.SRT_Quantity__c=123;
            srt.SRT_Time__c=123;
            srt.SRT_Access_Code__c='test';
            srt.SRT_Category__c='';
            srt.CSS_Claims__c= claim.id;
            srt.Type__c='Field Action';
            srt.isPerformed__c =  true;
            srt.SRT_Category__c='';
            srt.srt_type__c='ATC';
            srt.SRT_ID__c = '00-10S-00';
            insert srt;
            
            
            
            CSS_Solution_Component__c sc = new CSS_Solution_Component__c();
            sc.Name = 'test';
            sc.CSS_Claims__c = claim.id;
            sc.Selected_Component__c=false;
            sc.Type__c = 'Diagnosis';
            insert sc;
            
            Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
            
            List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
            CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
            aud.Object_Name__c = 'CSS_Parts_Options__c';
            aud.Name = 'Claim Status Edit';
            aud.Action_Type__c = 'Event Add';
            aud.Field_Name__c = 'Catastrophic__c';
            aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
            aud.Dynamic_Message__c = true;
            insert aud;
            aud.Dynamic_Message__c = false;
            update aud;
            List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();
            Currency_Conversion__c ccc = new Currency_Conversion__c();
            ccc.Bolt_Conversion_Rate__c = 23.8;
            ccc.Bolt_To_Currency__c =userinfo.getDefaultCurrency();
            ccc.Bolt_Version__c = 23;
            insert ccc;
            Currency_Conversion__c ccc1 = new Currency_Conversion__c();
            ccc1.Bolt_Conversion_Rate__c = 23.8;
            ccc1.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
            ccc1.Bolt_Version__c = 23;
            insert ccc1;
            system.debug('ccc.Bolt_To_Currency__c'+ccc.Bolt_To_Currency__c);
            lstCurrencyDetails.add(ccc);
            lstCurrencyDetails.add(ccc1);
            // list<CSS_Parts_Options__c> partslist = new list<CSS_Parts_Options__c>();
            CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
            parts1.selected_part__c = True;
            parts1.CSS_Claims__c=claim.id;
            parts1.Unit_Price__c='10.0';       
            parts1.FailurepartId__c = sc.Id;
            parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            parts1.Fail_Code__c = 'THAS';
            parts1.ReturnToFactory__c = 'Y';
            parts1.ReturnWaiver__c = false;
            parts1.Parts_Type__c ='Custom';
            parts1.Exchange_Rate_Version__c=23;
            parts1.RecordTypeId = recTypeIdPart;
            parts1.Part_Assignment__c = 'Primary';
            parts1.ExpenseTotal__c=10.0;
            insert parts1;
            
            parts1.Fail_Code__c = 'THAC';
            update parts1;
            delete parts1;
            
        }  
    }
    static testmethod void CSS_PartsTrigger_TestMethodOC3(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, DefaultCurrencyIsoCode='USD',CurrencyIsoCode='USD',
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;
        
        system.runAs(newUser){
            //system.runas(new User(Id=UserInfo.getUserId())){  */
            
            Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
            CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Unit_Number__c = '123456';
            JO.Failure_Point__c = 1.5;
            JO.Failure_Point_Measure__c = 'qw';       
            JO.Customer_Name__c = 'CumminsTnD';
            JO.Status__c = 'Repair Complete';
            JO.ESN__c = 'test1234';
            jo.DSID_WorkGroup__c = '';
            JO.DSID_Creation_Timestamp__c = system.now();
            JO.DSID_Status__c = 'open';
            JO.ESN_Locked__c = true;
            JO.ESN_Insite__c = '79464646';
            JO.Application__c = 'test1234';
            JO.Failure_Point__c = 1234;
            JO.Failure_Point_Measure__c = 'test1234';
            JO.Make__c = 'BMC';
            JO.Equipment_ID__c = 'equip';
            JO.Model__c = 'MILITARY';
            JO.DSID__c = null;
            JO.Equipment_ID__c = 'test1234';
            JO.Service_Model__c = 'test1234';
            JO.Shop_Work_Order__c = 'test1234';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.AccessCode__c ='A';
            insert(JO);
            
            
            CSS_Claims__c claim = new CSS_Claims__c();
            claim.Account__c = acc.id;
            claim.Customer_Name__c='PrabhuTrucks';
            claim.CSS_Job__c=JO.id;
            claim.Dealer_Service_Job__c=JO.id;
            claim.Customer_Code__c='123';
            claim.Status__c='Draft';
            claim.Actual_Technician_Time__c=1.2;
            claim.Catastrophic__c = true;
            insert claim;
            
            CSS_SRT__c srt = new CSS_SRT__c();
            srt.SRT_Title__c='test';
            srt.SRT_Quantity__c=123;
            srt.SRT_Time__c=123;
            srt.SRT_Access_Code__c='test';
            srt.SRT_Category__c='';
            srt.CSS_Claims__c= claim.id;
            srt.Type__c='Field Action';
            srt.isPerformed__c =  true;
            srt.SRT_Category__c='';
            srt.srt_type__c='ATC';
            srt.SRT_ID__c = '00-10S-00';
            insert srt;
            
            
            
            CSS_Solution_Component__c sc = new CSS_Solution_Component__c();
            sc.Name = 'test';
            sc.CSS_Claims__c = claim.id;
            sc.Selected_Component__c=false;
            sc.Type__c = 'Diagnosis';
            insert sc;
            
            Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
            
            List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
            CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
            aud.Object_Name__c = 'CSS_Parts_Options__c';
            aud.Name = 'Claim Status Edit';
            aud.Action_Type__c = 'Event Add';
            aud.Field_Name__c = 'Catastrophic__c';
            aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
            aud.Dynamic_Message__c = true;
            insert aud;
            aud.Dynamic_Message__c = false;
            update aud;
            List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();
            Currency_Conversion__c ccc = new Currency_Conversion__c();
            ccc.Bolt_Conversion_Rate__c = 23.8;
            ccc.Bolt_To_Currency__c =userinfo.getDefaultCurrency();
            ccc.Bolt_Version__c = 23;
            insert ccc;
            Currency_Conversion__c ccc1 = new Currency_Conversion__c();
            ccc1.Bolt_Conversion_Rate__c = 23.8;
            ccc1.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
            ccc1.Bolt_Version__c = 23;
            insert ccc1;
            system.debug('ccc.Bolt_To_Currency__c'+ccc.Bolt_To_Currency__c);
            lstCurrencyDetails.add(ccc);
            lstCurrencyDetails.add(ccc1);
            // list<CSS_Parts_Options__c> partslist = new list<CSS_Parts_Options__c>();
            CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
            parts1.selected_part__c = True;
            parts1.CSS_Claims__c=claim.id;
            parts1.Unit_Price__c='10.0';       
            parts1.FailurepartId__c = sc.Id;
            parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            parts1.Fail_Code__c = 'THAS';
            parts1.ReturnToFactory__c = 'Y';
            parts1.ReturnWaiver__c = false;
            parts1.Parts_Type__c ='Custom';
            parts1.Exchange_Rate_Version__c=23;
            parts1.RecordTypeId = recTypeIdPart;
            parts1.Part_Assignment__c = 'Primary';
            parts1.ExpenseTotal__c=10.0;
            insert parts1;
            
            parts1.Fail_Code__c = 'THAC';
            update parts1;
            delete parts1;
            
        }  
    }
    
    static testmethod void CSS_PartsTrigger_TestMethodparts2(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, DefaultCurrencyIsoCode='CAD',CurrencyIsoCode='CAD',
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;
        
        system.runAs(newUser){
            //system.runas(new User(Id=UserInfo.getUserId())){  */
            
            Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
            CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Unit_Number__c = '123456';
            JO.Failure_Point__c = 1.5;
            JO.Failure_Point_Measure__c = 'qw';       
            JO.Customer_Name__c = 'CumminsTnD';
            JO.Status__c = 'Repair Complete';
            JO.ESN__c = 'test1234';
            jo.DSID_WorkGroup__c = '';
            JO.DSID_Creation_Timestamp__c = system.now();
            JO.DSID_Status__c = 'open';
            JO.ESN_Locked__c = true;
            JO.ESN_Insite__c = '79464646';
            JO.Application__c = 'test1234';
            JO.Failure_Point__c = 1234;
            JO.Failure_Point_Measure__c = 'test1234';
            JO.Make__c = 'BMC';
            JO.Equipment_ID__c = 'equip';
            JO.Model__c = 'MILITARY';
            JO.DSID__c = null;
            JO.Equipment_ID__c = 'test1234';
            JO.Service_Model__c = 'test1234';
            JO.Shop_Work_Order__c = 'test1234';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.AccessCode__c ='A';
            insert(JO);
            
            
            CSS_Claims__c claim = new CSS_Claims__c();
            claim.Account__c = acc.id;
            claim.Customer_Name__c='PrabhuTrucks';
            claim.CSS_Job__c=JO.id;
            claim.Dealer_Service_Job__c=JO.id;
            claim.Customer_Code__c='123';
            claim.Status__c='Draft';
            claim.Actual_Technician_Time__c=1.2;
            claim.Catastrophic__c = true;
            insert claim;
            
            CSS_SRT__c srt = new CSS_SRT__c();
            srt.SRT_Title__c='test';
            srt.SRT_Quantity__c=123;
            srt.SRT_Time__c=123;
            srt.SRT_Access_Code__c='test';
            srt.SRT_Category__c='';
            srt.CSS_Claims__c= claim.id;
            srt.Type__c='Field Action';
            srt.isPerformed__c =  true;
            srt.SRT_Category__c='';
            srt.srt_type__c='ATC';
            srt.SRT_ID__c = '00-10S-00';
            insert srt;
            
            
            
            CSS_Solution_Component__c sc = new CSS_Solution_Component__c();
            sc.Name = 'test';
            sc.CSS_Claims__c = claim.id;
            sc.Selected_Component__c=false;
            sc.Type__c = 'Diagnosis';
            insert sc;
            
            Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            
            List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
            CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
            aud.Object_Name__c = 'CSS_Parts_Options__c';
            aud.Name = 'Claim Status Edit';
            aud.Action_Type__c = 'Event Add';
            aud.Field_Name__c = 'Catastrophic__c';
            aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
            aud.Dynamic_Message__c = true;
            insert aud;
            aud.Dynamic_Message__c = false;
            update aud;
            List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();
            Currency_Conversion__c ccc = new Currency_Conversion__c();
            ccc.Bolt_Conversion_Rate__c = 23.8;
            ccc.Bolt_To_Currency__c =userinfo.getDefaultCurrency();
            ccc.Bolt_Version__c = 23;
            insert ccc;
            Currency_Conversion__c ccc1 = new Currency_Conversion__c();
            ccc1.Bolt_Conversion_Rate__c = 23.8;
            ccc1.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
            ccc1.Bolt_Version__c = 23;
            insert ccc1;
            system.debug('ccc.Bolt_To_Currency__c'+ccc.Bolt_To_Currency__c);
            lstCurrencyDetails.add(ccc);
            lstCurrencyDetails.add(ccc1);
            // list<CSS_Parts_Options__c> partslist = new list<CSS_Parts_Options__c>();
            CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
            parts1.selected_part__c = True;
            parts1.CSS_Claims__c=claim.id;
            parts1.Unit_Price__c='10.0';       
            parts1.FailurepartId__c = sc.Id;
            parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            parts1.Fail_Code__c = 'THAS';
            parts1.ReturnToFactory__c = 'Y';
            parts1.ReturnWaiver__c = false;
            parts1.Parts_Type__c ='Custom';
            parts1.Exchange_Rate_Version__c=23;
            parts1.RecordTypeId = recTypeIdPart;
            parts1.Part_Assignment__c = 'Primary';
            parts1.ExpenseTotal__c=10.0;
            insert parts1;
            
            parts1.Fail_Code__c = 'THAC';
            parts1.Unit_Price__c='20.0';
            update parts1;
            delete parts1;
            
        }  
    }  
    static testmethod void CSS_PartsTrigger_TestMethodTTML3(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, DefaultCurrencyIsoCode='USD',CurrencyIsoCode='USD',
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;
        
        system.runAs(newUser){
            //system.runas(new User(Id=UserInfo.getUserId())){  */
            
            Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
            CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Unit_Number__c = '123456';
            JO.Failure_Point__c = 1.5;
            JO.Failure_Point_Measure__c = 'qw';       
            JO.Customer_Name__c = 'CumminsTnD';
            JO.Status__c = 'Repair Complete';
            JO.ESN__c = 'test1234';
            jo.DSID_WorkGroup__c = '';
            JO.DSID_Creation_Timestamp__c = system.now();
            JO.DSID_Status__c = 'open';
            JO.ESN_Locked__c = true;
            JO.ESN_Insite__c = '79464646';
            JO.Application__c = 'test1234';
            JO.Failure_Point__c = 1234;
            JO.Failure_Point_Measure__c = 'test1234';
            JO.Make__c = 'BMC';
            JO.Equipment_ID__c = 'equip';
            JO.Model__c = 'MILITARY';
            JO.DSID__c = null;
            JO.Equipment_ID__c = 'test1234';
            JO.Service_Model__c = 'test1234';
            JO.Shop_Work_Order__c = 'test1234';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.AccessCode__c ='A';
            insert(JO);
            
            
            CSS_Claims__c claim = new CSS_Claims__c();
            claim.Account__c = acc.id;
            claim.Customer_Name__c='PrabhuTrucks';
            claim.CSS_Job__c=JO.id;
            claim.Dealer_Service_Job__c=JO.id;
            claim.Customer_Code__c='123';
            claim.Status__c='Draft';
            claim.Actual_Technician_Time__c=1.2;
            claim.Catastrophic__c = true;
            insert claim;
            
            CSS_SRT__c srt = new CSS_SRT__c();
            srt.SRT_Title__c='test';
            srt.SRT_Quantity__c=123;
            srt.SRT_Time__c=123;
            srt.SRT_Access_Code__c='test';
            srt.SRT_Category__c='';
            srt.CSS_Claims__c= claim.id;
            srt.Type__c='Field Action';
            srt.isPerformed__c =  true;
            srt.SRT_Category__c='';
            srt.srt_type__c='ATC';
            srt.SRT_ID__c = '00-10S-00';
            insert srt;
            
            
            
            CSS_Solution_Component__c sc = new CSS_Solution_Component__c();
            sc.Name = 'test';
            sc.CSS_Claims__c = claim.id;
            sc.Selected_Component__c=false;
            sc.Type__c = 'Diagnosis';
            insert sc;
            
            Id recTypeIdPart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
            
            List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
            CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
            aud.Object_Name__c = 'CSS_Parts_Options__c';
            aud.Name = 'Claim Status Edit';
            aud.Action_Type__c = 'Event Add';
            aud.Field_Name__c = 'Catastrophic__c';
            aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
            aud.Dynamic_Message__c = true;
            insert aud;
            aud.Dynamic_Message__c = false;
            update aud;
            List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();
            Currency_Conversion__c ccc = new Currency_Conversion__c();
            ccc.Bolt_Conversion_Rate__c = 23.8;
            ccc.Bolt_To_Currency__c =userinfo.getDefaultCurrency();
            ccc.Bolt_Version__c = 23;
            insert ccc;
            Currency_Conversion__c ccc1 = new Currency_Conversion__c();
            ccc1.Bolt_Conversion_Rate__c = 23.8;
            ccc1.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
            ccc1.Bolt_Version__c = 23;
            insert ccc1;
            system.debug('ccc.Bolt_To_Currency__c'+ccc.Bolt_To_Currency__c);
            lstCurrencyDetails.add(ccc);
            lstCurrencyDetails.add(ccc1);
            // list<CSS_Parts_Options__c> partslist = new list<CSS_Parts_Options__c>();
            CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
            parts1.selected_part__c = True;
            parts1.CSS_Claims__c=claim.id;
            parts1.Unit_Price__c='10.0';       
            parts1.FailurepartId__c = sc.Id;
            parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            parts1.Fail_Code__c = 'THAS';
            parts1.ReturnToFactory__c = 'Y';
            parts1.ReturnWaiver__c = false;
            parts1.Parts_Type__c ='Custom';
            parts1.Exchange_Rate_Version__c=23;
            parts1.RecordTypeId = recTypeIdPart;
            parts1.Part_Assignment__c = 'Primary';
            parts1.ExpenseTotal__c=10.0;
            insert parts1;
            
            parts1.Fail_Code__c = 'THAC';
            update parts1;
            delete parts1;
            
        }  
    }
    
}