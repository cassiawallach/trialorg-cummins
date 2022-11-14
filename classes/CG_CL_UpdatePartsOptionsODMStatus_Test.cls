@isTest
public class CG_CL_UpdatePartsOptionsODMStatus_Test {
 static testMethod void TestMethodJobParts()
    {
      test.startTest();
        list<id> idlist = new list<id>();
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.Make__c = 'test1234';
        JO.Model__c = 'test1234';
        JO.DSID__c = 'test1234';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        JO.Failure_Date__c=date.today();
        JO.ESN__c = '79464646';
    
        insert(JO);
        idlist.add(JO.id);
        List<CSS_Solutions__c>solu = new List<CSS_Solutions__c>();
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Service_Job__c=JO.Id;
        solRef.Solution_title__c='TestData';
        //solRef.Account_Code__c ='A';
        insert solRef;
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,JO.Id,solRef.Id);
        solComRef.Pay_Code__c = 'A';
        insert solComRef;
       map<id,list<CSS_Parts_Options__c>> mapSolCompToParts=new map<id,list<CSS_Parts_Options__c>>();
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'BMS Parts');
         CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.Service_Job__c = JO.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Service_Job__c = JO.id;
        po.Account_Code__c = ''; 
        po.Solutions__c=solRef.id;
        po.FailurepartId__c =solComRef.Id; 
        po.ODM_Status__c = 'Warn';
        po.ODM_Status_Message__c='test';
        
        po.RecordTypeId = recTypeIdpart;
        insert po;
        lstpo.add(po);
        
        CG_CL_UpdatePartsOptionsODMStatus.updatePartsODMStatus(idlist);
        test.stopTest();
       
        
}
    static testMethod void TestMethodJobParts1()
    {
      test.startTest();
        list<id> idlist = new list<id>();
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.Make__c = 'test1234';
        JO.Model__c = 'test1234';
        JO.DSID__c = 'test1234';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        JO.Failure_Date__c=date.today();
        JO.ESN__c = '79464646';
    
        insert(JO);
        idlist.add(JO.id);
     //   list<id> idlist = new list<id>();
         CSS_Claims__c  autoclaimsRec= new CSS_Claims__c();
        autoclaimsRec.CSS_Job__c=null;
        insert autoclaimsRec;
        
       
   // idlist.add(autoclaimsRec.id);
        List<CSS_Solutions__c>solu = new List<CSS_Solutions__c>();
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Service_Job__c=JO.Id;
        solRef.Solution_title__c='TestData';
        //solRef.Account_Code__c ='A';
        insert solRef;
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,JO.Id,solRef.Id);
        solComRef.Pay_Code__c = 'A';
        insert solComRef;
       map<id,list<CSS_Parts_Options__c>> mapSolCompToParts=new map<id,list<CSS_Parts_Options__c>>();
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'Parts');
         CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.Service_Job__c = JO.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='Select one';
        po.Parts_Type__c ='Custom';
        po.Service_Job__c = JO.id;
        po.Account_Code__c ='61'; 
        po.Solutions__c=solRef.id;
        po.FailurepartId__c =solComRef.Id; 
        po.ODM_Status__c = 'Warn';
        po.RecordTypeId = recTypeIdpart;
        insert po;
        lstpo.add(po);
        
        CG_CL_UpdatePartsOptionsODMStatus.updatePartsODMStatus(idlist);
        test.stopTest();
       
        
}
    
   
    static testMethod void TestMethodautoClaim()
    {
        test.startTest();
        Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap = new Map<string, list<CSS_Parts_Options__c>>(); 
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.Make__c = 'test1234';
        JO.Model__c = 'test1234';
        JO.DSID__c = 'test1234';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        JO.Failure_Date__c=date.today();
        JO.ESN__c = '79464646';
    
        insert(JO);
        
    list<id> idlist = new list<id>();
         CSS_Claims__c  autoclaimsRec= new CSS_Claims__c();
        autoclaimsRec.CSS_Job__c=JO.id;
        insert autoclaimsRec;
        
       
    idlist.add(autoclaimsRec.id);
    
     List<CSS_Solutions__c> solu = new List<CSS_Solutions__c>();
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Service_Job__c=JO.Id;
        solRef.Solution_title__c='TestData';
        solu.add(solRef);
        insert solu;
        
        list<CSS_Solution_Component__c> solComRef = new list<CSS_Solution_Component__c>();
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.Service_Job__c=JO.id;
        solcomp.Name='Testing';
        solcomp.type__c = 'ABC';
        solcomp.Solutions__c=solRef.Id;
        solComRef.add(solcomp);
        insert solComRef;
        //idlist.add(ManclaimsRec.id);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'BMS Parts');
        CSS_Parts_Options__c autoclaimPO =new CSS_Parts_Options__c();
        autoclaimPO.Notes__c='123';
        autoclaimPO.RecordTypeId = recTypeIdpart;
        //autoclaimPO.Service_Job__c = JO.id;
        autoclaimPO.OEM__c ='123';
        autoclaimPO.Quantity__c =1;
        autoclaimPO.Selected_part__c =true;
        autoclaimPO.Part_Name__c ='123';
        autoclaimPO.Service_partnumber__c ='123';
        autoclaimPO.Parts_Type__c ='Custom';
        autoclaimPO.css_claims__c = autoclaimsRec.id;
        autoclaimPO.Account_Code__c ='A'; 
        autoclaimPO.ODM_Status__c = 'WARN';
        lstpo.add(autoclaimPO);
        //insert lstpo;
        CSS_Parts_Options__c autoclaimPO1 =new CSS_Parts_Options__c();
        autoclaimPO1.Notes__c='123';
        autoclaimPO1.RecordTypeId = recTypeIdpart;
        //autoclaimPO1.Service_Job__c = JO.id;
       //autoclaimPO1.CSS_Claims__c = idlist.id;
        autoclaimPO1.OEM__c ='123';
        autoclaimPO1.Quantity__c =1;
        autoclaimPO1.Selected_part__c =true;
        autoclaimPO1.Part_Name__c ='123';
        autoclaimPO1.Service_partnumber__c ='123';
        autoclaimPO1.Parts_Type__c ='Custom';
        autoclaimPO1.css_claims__c = autoclaimsRec.id;
        autoclaimPO1.Account_Code__c ='35'; 
        autoclaimPO1.ODM_Status__c = 'WARN';
        lstpo.add(autoclaimPO1);
        
        
        insert lstpo;
        POAccountCodeMap.put('123+A',lstpo);
     CG_CL_UpdatePartsOptionsODMStatus.updatePartsODMStatus(idlist);
        test.stopTest();
}
    static testMethod void TestMethodManClaim4(){
        list<id> idlist = new list<id>();
        CSS_Claims__c  autoclaimsRec= new CSS_Claims__c();
        autoclaimsRec.CSS_Job__c=null;
        insert autoclaimsRec;
        idlist.add(autoclaimsRec.id);
        List<CSS_Solution_Component__c> listsocomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = new CSS_Solution_Component__c();
        solComRef.CSS_Claims__c = autoclaimsRec.id;
        solComRef.Pay_Code__c = 'A';
        insert solComRef;
       listsocomp.add(solComRef); 
                 Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'BMS Parts');
        CSS_Parts_Options__c autoclaimPO1 =new CSS_Parts_Options__c();
        autoclaimPO1.Notes__c='123';
        autoclaimPO1.RecordTypeId = recTypeIdpart;
        //autoclaimPO1.Service_Job__c = JO.id;
      
        autoclaimPO1.OEM__c ='123';
        autoclaimPO1.Quantity__c =1;
        autoclaimPO1.Selected_part__c =true;
        autoclaimPO1.Part_Name__c ='123';
        autoclaimPO1.Service_partnumber__c ='123';
        autoclaimPO1.Parts_Type__c ='Custom';
        autoclaimPO1.css_claims__c = autoclaimsRec.id;
        autoclaimPO1.Account_Code__c ='35'; 
        autoclaimPO1.ODM_Status__c = 'WARN';
        insert autoclaimPO1;

        CG_CL_UpdatePartsOptionsODMStatus.updatePartsODMStatus(idlist);
        
    } 
    static testMethod void TestMethodManClaim5(){
        list<id> idlist = new list<id>();
        CSS_Claims__c  autoclaimsRec= new CSS_Claims__c();
        autoclaimsRec.CSS_Job__c=null;
        insert autoclaimsRec;
        idlist.add(autoclaimsRec.id);
       /* List<CSS_Solution_Component__c> listsocomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = new CSS_Solution_Component__c();
        solComRef.CSS_Claims__c = autoclaimsRec.id;
        solComRef.Pay_Code__c = 'A';
        insert solComRef;
       listsocomp.add(solComRef); */
                 Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'Parts');
        CSS_Parts_Options__c autoclaimPO1 =new CSS_Parts_Options__c();
        autoclaimPO1.Notes__c = '123';
        autoclaimPO1.RecordTypeId = recTypeIdpart;
        //autoclaimPO1.Service_Job__c = JO.id;
      
        autoclaimPO1.OEM__c ='123';
        autoclaimPO1.Quantity__c =1;
        autoclaimPO1.Selected_part__c =true;
        autoclaimPO1.Part_Name__c ='123';
        autoclaimPO1.Service_partnumber__c ='123';
        autoclaimPO1.Parts_Type__c ='Custom';
        autoclaimPO1.css_claims__c = autoclaimsRec.id;
        autoclaimPO1.Account_Code__c ='35'; 
        autoclaimPO1.ODM_Status__c = 'WARN';
        insert autoclaimPO1;

        CG_CL_UpdatePartsOptionsODMStatus.updatePartsODMStatus(idlist);
        
    } 
   /* static testMethod void TestMethodManClaim6(){
        
         Account a = new Account(Name='Test Account Name', CSS_DistributorCode__c='56270',IAM_Service_Provider_Code__c = '56270',Type = 'Customer',CMI_Account_Status__c = 'Active');
        insert a;
        
        Contact contactToInsert = new Contact();
        contactToInsert.FirstName = 'Test';
        contactToInsert.AccountId = a.id;
        contactToInsert.Lastname = 'Contact';
        contactToInsert.CMI_Contact_Type__c = 'Secondary';
        contactToInsert.IAM_Cummins_login_ID__c='ContactTest@truck.com';
        contactToInsert.IAM_Contact_Status__c = 'Active';
        contactToInsert.Email = 'akanksha.p@gmail.com';
        contactToInsert.Phone='000-000-0000';   
        insert contactToInsert;
         
        Id profId = [SELECT id FROM profile where Name = 'CSS_Dealer_Advanced'].Id;
      
         //Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Advanced']; 
        User u = new User(Alias = 'test', Email='test888@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing21', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profId, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser21@testorg.com',ContactId=contactToInsert.id);
       // insert u;
        
        id UserId = u.Id;
        system.debug('UserId:' +u.Profile.Name);
        css_utility.getOrgType(UserId);
       
        System.runAs(u){
            list<id> idlist = new list<id>();
            List<CSS_Claims__c> cs = new List<CSS_Claims__c>();
        CSS_Claims__c  autoclaimsRec= new CSS_Claims__c();
        autoclaimsRec.CSS_Job__c=null;
        //autoclaimsRec.ODM_Status__c = 'warn';    
        autoclaimsRec.Information_Only_Claim__c = true;
        insert autoclaimsRec;
        cs.add(autoclaimsRec);
        idlist.add(autoclaimsRec.id);
       /* List<CSS_Solution_Component__c> listsocomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComRef = new CSS_Solution_Component__c();
        solComRef.CSS_Claims__c = autoclaimsRec.id;
        solComRef.Pay_Code__c = 'A';
        insert solComRef;
       listsocomp.add(solComRef); 
                 Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'Parts');
        CSS_Parts_Options__c autoclaimPO1 =new CSS_Parts_Options__c();
        autoclaimPO1.Notes__c='123';
        //autoclaimPO1.RecordTypeId = recTypeIdpart;
        //autoclaimPO1.Service_Job__c = JO.id;
      
        autoclaimPO1.OEM__c ='123';
        autoclaimPO1.Quantity__c =1;
       // autoclaimPO1.Selected_part__c =true;
        autoclaimPO1.Part_Name__c ='123';
        autoclaimPO1.Service_partnumber__c ='123';
        autoclaimPO1.Parts_Type__c ='Custom';
        autoclaimPO1.css_claims__c = autoclaimsRec.id;
        autoclaimPO1.Account_Code__c ='35'; 
        autoclaimPO1.ODM_Status__c = 'WARN';
        insert autoclaimPO1;

        CG_CL_UpdatePartsOptionsODMStatus.updatePartsODMStatus(idlist);
        
    } 
    }*/
   static testMethod void TestMethodManClaim9(){
        test.startTest();
        list<id> idlist = new list<id>();
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.Make__c = 'test1234';
        JO.Model__c = 'test1234';
        JO.DSID__c = 'test1234';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        JO.Failure_Date__c=date.today();
        JO.ESN__c = '79464646';
    
        insert(JO);
        idlist.add(JO.id);
        List<CSS_Solutions__c>solu = new List<CSS_Solutions__c>();
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Service_Job__c=JO.Id;
        solRef.Solution_title__c='TestData';
        //solRef.Account_Code__c ='A';
        insert solRef;
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,JO.Id,solRef.Id);
        solComRef.Pay_Code__c = 'A';
        insert solComRef;
       map<id,list<CSS_Parts_Options__c>> mapSolCompToParts=new map<id,list<CSS_Parts_Options__c>>();
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'BMS Parts');
         CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.Service_Job__c = JO.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Service_Job__c = JO.id;
        po.Account_Code__c ='61'; 
        po.Solutions__c=solRef.id;
        po.FailurepartId__c =solComRef.Id; 
        po.ODM_Status__c = 'Warn';
        po.ODM_Status_Message__c='test';
        
        //po.RecordTypeId = recTypeIdpart;
        insert po;
        lstpo.add(po);
        
        CG_CL_UpdatePartsOptionsODMStatus.updatePartsODMStatus(idlist);
        test.stopTest();
       
        
    } 
   

  static testMethod void TestMethodautoClaim1()
    {
        test.startTest();
        Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap = new Map<string, list<CSS_Parts_Options__c>>(); 
       
    list<id> idlist = new list<id>();
    list<CSS_Claims__c> claimlist = new list<CSS_Claims__c>();
         CSS_Claims__c  autoclaimsRec= new CSS_Claims__c();
        autoclaimsRec.Information_Only_Claim__c=true;
    claimlist.add(autoclaimsRec);
    insert claimlist;
        
       
    idlist.add(autoclaimsRec.id);
        //idlist.add(ManclaimsRec.id);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'BMS Parts');
    
        CSS_Parts_Options__c autoclaimPO1 =new CSS_Parts_Options__c();
         autoclaimPO1.ODM_Status__c = 'WARN';
         autoclaimPO1.ODM_Status_Message__c = '123';
        autoclaimPO1.Notes__c='123';
        autoclaimPO1.RecordTypeId = recTypeIdpart;
        //autoclaimPO1.Service_Job__c = JO.id;
       //autoclaimPO1.CSS_Claims__c = idlist.id;
        autoclaimPO1.OEM__c ='123';
        autoclaimPO1.Quantity__c =1;
        autoclaimPO1.Selected_part__c =true;
        autoclaimPO1.Part_Name__c ='123';
        autoclaimPO1.Service_partnumber__c ='123';
        autoclaimPO1.Parts_Type__c ='Custom';
        autoclaimPO1.css_claims__c = autoclaimsRec.id;
        autoclaimPO1.Account_Code__c ='35'; 
       
        lstpo.add(autoclaimPO1);
        
        
        insert lstpo;
        POAccountCodeMap.put('123+A',lstpo);
     CG_CL_UpdatePartsOptionsODMStatus.updatePartsODMStatus(idlist);
        test.stopTest();
}

}