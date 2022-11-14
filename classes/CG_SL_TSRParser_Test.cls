@isTest
public class CG_SL_TSRParser_Test {
    static TestMethod void TestSLTSRPasrser() {
        CG_SL_TSRParser CGTSR = new CG_SL_TSRParser();
        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User u = new User(Alias = 'kal10000', Email='standarduser1001@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='kal12',FirstName='kal', LanguageLocaleKey='en_US',Phone='8888888', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '562701-562551',UserRoleId = empRole.id);
      insert(u);
      System.runAs(u) {  
         
        Test.startTest();
                CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
          CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =JO.Id; 
            //fauCodRef.Fault_Code__c=2182; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
          fauCodRef.FaultCodeR2__c='3539';
            fauCodRef.Status__c='A';
        insert fauCodRef;
        List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
        fauCodRefList.add(fauCodRef);
           CSS_SymptomQA__c symp = new CSS_SymptomQA__c();
        symp.name = 'smoke';
        symp.Caption__c = 'smoke';
        symp.Type__c = 'SearchString';
        symp.Job_Order__c = JO.id;
        insert symp;
          List<CSS_SymptomQA__c> symp1 = new List<CSS_SymptomQA__c>();
          symp1.add(symp);
        
          
      CG_SL_TSRParser.prepareFaultCodeList(fauCodRefList);
          List<String> LstFC = CG_SL_TSRParser.prepareFaultCodeStatusList(fauCodRefList);
          string sym = CG_SL_TSRParser.prepareSymptomList(symp1);
          CG_TSRReqJSONParser reqjson = new CG_TSRReqJSONParser();
        reqjson = CG_SL_TSRParser.prepareReqWrapper(u,JO,fauCodRefList,symp1,'','Cummins CARE Level 1','106','HMLD');
          
          //return reqJson;
            //CG_SL_TSR.TSRWebservice(u,JO,fauCodRefList,symp1,String TechId,String CustomerSupportLevel,String ComplaintCode,String EscalationGroup)
  		Test.stopTest();
      }
    }

}