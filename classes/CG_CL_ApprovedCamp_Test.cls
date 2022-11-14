@isTest
public class CG_CL_ApprovedCamp_Test {
    static testMethod void test(){
      /*  
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Agassi';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'Ridhima test 123';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        //JO.lo = 10;
        //JO.Shop_s_Work_Order__c = 120;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.Service_Model__c = 'Test one';
        Jo.OwnerId = u.Id;
        JO.Notes__c = 'notessss';
        jo.Account__c=acc.id;
        insert(JO);
        system.debug('------Testing---' +JO);
        
        system.runAs(u){
            id UserId = u.Id;
            system.debug('UserId:' +UserId);
            css_utility.getUserAttributes(UserId);
            css_utility.getLanguage(u.LanguageLocaleKey);
            
        }    
        CG_BL_Intake.getSiebelQSOLCampaigns(JO.id, JO.ESN__c,u.LanguageLocaleKey ,JO.Service_Model__c, JO.Failure_Date__c);
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        List<CSS_Solution_Component__c> lstcamp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Status__c = 'Approved';
        solComp.Complete_Indicator__c = True;
        solcomp.Multiple_Times__c = True;
        insert solComp;
        lstcamp.add(solComp);
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.Component_Id__c ='F0051000';
        solComp1.Service_Job__c = Jo.id;
        solComp1.Action__c = '';
        solComp1.Type__c = 'Campaign';
        solComp1.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp1.CampaignPartsPercentage__c = '20';
        solcomp1.Performed_Review__c = True;
        solcomp1.Status__c = 'Approved';
        solComp1.Complete_Indicator__c = True;
        solcomp1.Multiple_Times__c = True;
        insert solComp1;
        lstcamp.add(solComp1);
        system.debug('--Sol comp--' +solComp);
        
        List<css_srt__c> srtList = new list<css_srt__c>();
        css_srt__c srtobj = new css_srt__c();
        srtobj.Type__c='Admin';
        srtobj.FailCode__c='Turbocharger';
        srtobj.Job_Order__c=Jo.id;
        insert srtobj;
        srtList.add(srtobj);
        
        css_srt__c srtobj1 = new css_srt__c();
        srtobj1.Type__c='Admin';
        //srtobj1.FailCode__c='Turbocharger';
        srtobj1.Job_Order__c=Jo.id;
        insert srtobj1;
        srtList.add(srtobj1);
        
        
        id partsrecodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();    
        List<CSS_Parts_Options__c> partsList = new List<CSS_Parts_Options__c>();
        
        CSS_Parts_Options__c partobj = new CSS_Parts_Options__c();
        partobj.Fail_Code__c='turbocharger';
        partobj.Service_Job__c=Jo.id;
        partobj.parts_type__c='custom';
        partobj.RecordTypeId = partsrecodid;
        insert partobj;
        partsList.add(partobj);
        
        CSS_Parts_Options__c partobj1 = new CSS_Parts_Options__c();
       // partobj1.Fail_Code__c='';
        partobj1.Service_Job__c=Jo.id;
        partobj1.parts_type__c='custom';
        partobj1.RecordTypeId = partsrecodid;
        insert partobj1;
        partsList.add(partobj1);
        
        Note note = new Note();
        note.Title = 'CAMPCOMMENTS';
        note.ParentId = JO.Id;  
        note.Body = 'Bold';
        insert note;
        
        CSS_accountLanguage__c acclang = new CSS_accountLanguage__C(); 
        acclang.Name = 'en_US';
        acclang.CSS_userLanguage__c = 'English';
        acclang.CSS_QsolLanguage__c = 'en';
        acclang.CSS_EDSLanguage__c = 'en';
        insert acclang;
        
        CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
        ctt.Type__c = 'ATC';
        ctt.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt.Doc_Num__c = 'ATC1623';
        ctt.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt.Performed__c = false;
        ctt.Performed_Review__c = true;
        ctt.Reviewed__c = false;
        ctt.Job_Order__c = JO.Id;
        ctt.ESN__c = JO.ESN__c;
        insert ctt;
        
        system.debug('----Ctttte--' +ctt);
        
        CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
        ctt1.Type__c = 'TSB';
        ctt1.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt1.Doc_Num__c = 'ATC1623';
        ctt1.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt1.Performed__c = false;
        ctt1.Performed_Review__c = true;
        ctt1.Reviewed__c = false;
        ctt1.Job_Order__c = JO.Id;
        ctt1.ESN__c = JO.ESN__c;
        insert ctt1;
        
        system.debug('---ctttest--' +ctt1);
        CSS_CampTsbTrp__c ctt2 = new CSS_CampTsbTrp__c();
        ctt2.Type__c = 'TRP';
        ctt2.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt2.Doc_Num__c = 'ATC1623';
        ctt2.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt2.Performed__c = false;
        ctt2.Performed_Review__c = true;
        ctt2.Reviewed__c = false;
        ctt2.Job_Order__c = JO.Id;
        ctt2.ESN__c = JO.ESN__c;
        insert ctt2;
        CSS_CampTsbTrp__c ctt3 = new CSS_CampTsbTrp__c();
        ctt3.Type__c = 'CAM';
        ctt3.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt3.Doc_Num__c = 'ATC1623';
        ctt3.doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt3.Performed__c = false;
        ctt3.Performed_Review__c = true;
        ctt3.Reviewed__c = false;
        ctt3.Job_Order__c = JO.Id;
        ctt3.ESN__c = JO.ESN__c;
        insert ctt3;
        
        Test.startTest();
        
        map<string,CSS_CampTsbTrp__c> qsolCTTPMap = new map<string,CSS_CampTsbTrp__c>();
        qsolCTTPMap.put(ctt3.Doc_Num__c, ctt3);
        ApexPages.CurrentPage().getParameters().put('Id', JO.id);
        CG_CL_ApprovedCamp campapprv = new CG_CL_ApprovedCamp();
        CG_CL_IntakeRJ ccirj = new CG_CL_IntakeRJ();
        ccirj.Wid = ApexPages.currentPage().getParameters().put('id',JO.id);
        ccirj.comm = 'hello';
        ccirj.qsolCTTP = [select Type__c,URL__c,  Doc_Num__c, Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where Job_Order__c= :JO.Id AND Type__c !='TSB'  order by Type__c LIMIT 1000];
        campapprv.mainContrRJ = ccirj;
        campapprv.solCompCTTP = lstcamp;
        
        campapprv.getALLRecords_old();
        campapprv.getALLRecords();
        campapprv.saveCheckBoxComp_New();
        campapprv.showFieldActionPopup();*/
         Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Agassi';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'Ridhima test 123';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        //JO.lo = 10;
        //JO.Shop_s_Work_Order__c = 120;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.Service_Model__c = 'Test one';
        Jo.OwnerId = u.Id;
        JO.Notes__c = 'notessss';
        jo.Account__c=acc.id;
        insert(JO);
        system.debug('------Testing---' +JO);
        
        system.runAs(u){
            id UserId = u.Id;
            system.debug('UserId:' +UserId);
            css_utility.getUserAttributes(UserId);
            css_utility.getLanguage(u.LanguageLocaleKey);
            
        }    
        CG_BL_Intake.getSiebelQSOLCampaigns(JO.id, JO.ESN__c,u.LanguageLocaleKey ,JO.Service_Model__c, JO.Failure_Date__c);
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        List<CSS_Solution_Component__c> lstcamp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Status__c = 'Approved';
        solComp.Complete_Indicator__c = True;
        solcomp.Multiple_Times__c = True;
        insert solComp;
        lstcamp.add(solComp);
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.Component_Id__c ='F0051000';
        solComp1.Service_Job__c = Jo.id;
        solComp1.Action__c = '';
        solComp1.Type__c = 'Campaign';
        solComp1.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp1.CampaignPartsPercentage__c = '20';
        solcomp1.Performed_Review__c = True;
        solcomp1.Status__c = 'Approved';
        solComp1.Complete_Indicator__c = True;
        solcomp1.Multiple_Times__c = True;
        insert solComp1;
        lstcamp.add(solComp1);
        
        CSS_Solution_Component__c solComp11 = new CSS_Solution_Component__c();
        solComp11.Component_Id__c ='F0051000';
        solComp11.Service_Job__c = Jo.id;
        solComp11.Action__c = '';
        solComp11.Type__c = 'Campaign';
        solComp11.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp11.CampaignPartsPercentage__c = '20';
        solcomp11.Performed_Review__c = false;
        solcomp11.Status__c = 'Approved';
        solComp11.Complete_Indicator__c = True;
        solcomp11.Multiple_Times__c = True;
        insert solComp11;
        lstcamp.add(solComp11);
        system.debug('--Sol comp--' +solComp);
        
        List<css_srt__c> srtList = new list<css_srt__c>();
        css_srt__c srtobj = new css_srt__c();
        srtobj.Type__c='Admin';
        srtobj.FailCode__c='Turbocharger';
        srtobj.Job_Order__c=Jo.id;
        insert srtobj;
        srtList.add(srtobj);
        
        css_srt__c srtobj1 = new css_srt__c();
        srtobj1.Type__c='Admin';
        //srtobj1.FailCode__c='Turbocharger';
        srtobj1.Job_Order__c=Jo.id;
        insert srtobj1;
        srtList.add(srtobj1);
        
        
        id partsrecodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();    
        List<CSS_Parts_Options__c> partsList = new List<CSS_Parts_Options__c>();
        
        CSS_Parts_Options__c partobj = new CSS_Parts_Options__c();
        partobj.Fail_Code__c='turbocharger';
        partobj.Service_Job__c=Jo.id;
        partobj.parts_type__c='custom';
        partobj.RecordTypeId = partsrecodid;
        partobj.Account_Code__c='harger';
        insert partobj;
        partsList.add(partobj);
        
        CSS_Parts_Options__c partobj1 = new CSS_Parts_Options__c();
       // partobj1.Fail_Code__c='';
        partobj1.Service_Job__c=Jo.id;
        partobj1.parts_type__c='custom';
        partobj1.RecordTypeId = partsrecodid;
        insert partobj1;
        partsList.add(partobj1);
        
        Note note = new Note();
        note.Title = 'CAMPCOMMENTS';
        note.ParentId = JO.Id;  
        note.Body = 'Bold';
        insert note;
        
        CSS_accountLanguage__c acclang = new CSS_accountLanguage__C(); 
        acclang.Name = 'en_US';
        acclang.CSS_userLanguage__c = 'English';
        acclang.CSS_QsolLanguage__c = 'en';
        acclang.CSS_EDSLanguage__c = 'en';
        insert acclang;
        
        CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
        ctt.Type__c = 'ATC';
        ctt.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt.Doc_Num__c = 'ATC1623';
        ctt.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt.Performed__c = false;
        ctt.Performed_Review__c = true;
        ctt.Reviewed__c = false;
        ctt.Job_Order__c = JO.Id;
        ctt.ESN__c = JO.ESN__c;
        insert ctt;
        
        system.debug('----Ctttte--' +ctt);
        
        CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
        ctt1.Type__c = 'TSB';
        ctt1.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt1.Doc_Num__c = 'ATC1623';
        ctt1.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt1.Performed__c = false;
        ctt1.Performed_Review__c = true;
        ctt1.Reviewed__c = false;
        ctt1.Job_Order__c = JO.Id;
        ctt1.ESN__c = JO.ESN__c;
        insert ctt1;
        
        system.debug('---ctttest--' +ctt1);
        CSS_CampTsbTrp__c ctt2 = new CSS_CampTsbTrp__c();
        ctt2.Type__c = 'TRP';
        ctt2.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt2.Doc_Num__c = 'ATC1623';
        ctt2.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt2.Performed__c = false;
        ctt2.Performed_Review__c = true;
        ctt2.Reviewed__c = false;
        ctt2.Job_Order__c = JO.Id;
        ctt2.ESN__c = JO.ESN__c;
        insert ctt2;
        CSS_CampTsbTrp__c ctt3 = new CSS_CampTsbTrp__c();
        ctt3.Type__c = 'CAM';
        ctt3.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt3.Doc_Num__c = 'ATC1623';
        ctt3.doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt3.Performed__c = false;
        ctt3.Performed_Review__c = true;
        ctt3.Reviewed__c = false;
        ctt3.Job_Order__c = JO.Id;
        ctt3.ESN__c = JO.ESN__c;
        insert ctt3;
        
        Test.startTest();
        
        map<string,CSS_CampTsbTrp__c> qsolCTTPMap = new map<string,CSS_CampTsbTrp__c>();
        qsolCTTPMap.put(ctt3.Doc_Num__c, ctt3);
        ApexPages.CurrentPage().getParameters().put('Id', JO.id);
        CG_CL_ApprovedCamp campapprv = new CG_CL_ApprovedCamp();
        CG_CL_IntakeRJ ccirj = new CG_CL_IntakeRJ();
        ccirj.Wid = ApexPages.currentPage().getParameters().put('id',JO.id);
        ccirj.comm = 'hello';
        ccirj.qsolCTTP = [select Type__c,URL__c,  Doc_Num__c, Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where Job_Order__c= :JO.Id AND Type__c !='TSB'  order by Type__c LIMIT 1000];
        campapprv.mainContrRJ = ccirj;
        campapprv.solCompCTTP = lstcamp;
        
        campapprv.getALLRecords_old();
        campapprv.getALLRecords();
        campapprv.saveCheckBoxComp_New();
        campapprv.showFieldActionPopup();
        campapprv.saveCheckBoxComp();
        Test.stopTest();
    }
}