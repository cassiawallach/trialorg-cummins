//Adding comment for deployment -- Akansha MV_688 8/25/2022

@isTest
public class FSLMakeModelBatch_Test {
    
    public static testmethod void launchinsitetest() {
        
        Test.setMock(HttpCalloutMock.class, new FSLMakeModelToken());
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        
        Test.setMock(HttpCalloutMock.class, new FSLMakeModeMockToken_Test());
        // Test.setMock(HttpCalloutMock.class, new FSLFaultCodeTokenMock());
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/makemodel';
        conDetails.Key__c = '271bf3f9be404e4b9a3a85559a2cecb3';
        conDetails.Name = 'MakeModel';
        conDetails.ApplicationName__c = 'MakeModel';
        conDetails.Passcode__c = 'ocj8yiMYSDH39gPJpEZTNQo9cCXdgOW5olQ2s1Y3siA=';
        conDetails.Username__c= 'ad72439255944e85b9ebb0fc19c2fabe';
        conDetails.IsActive__c = true;
        insert conDetails;
        
        list<FSL_MakeModel_Stage__c> lstFsl = new list<FSL_MakeModel_Stage__c >();
        FSL_MakeModel_Stage__c objMakeModelstg = new FSL_MakeModel_Stage__c();
        objMakeModelstg.ModelSeries__c = 'test';
        objMakeModelstg.PSN__c = 'test';
        objMakeModelstg.Manufacturer__c = 'test';
        objMakeModelstg.Type_PSN__c = 'Engines-545';
        lstFsl.add(objMakeModelstg);
        insert lstFsl;
        
        SchedulableContext sc = null;
        FSLMakeModelSC tsc = new FSLMakeModelSC();
        tsc.execute(sc);
        FSL_MakeModelResWrap.cls_MakeModel br = new FSL_MakeModelResWrap.cls_MakeModel();
        br.Status = 'Error';
        //br.PSN = '76022087';
        br.Message ='zero';
        //br.Type ='TRP';
        FSL_MakeModelRequestWrapper.cls_MakeModel ar = new FSL_MakeModelRequestWrapper.cls_MakeModel();
        ar.Type = 'Engines';
        ar.ModelSeries = 'GAZELLE';
        ar.PSN = '76022086';
        ar.Manufacturer = 'GAZ';
        ar.ProductApplicationCode ='10';
        
        //FSL_MakeModelRequestWrapper.DataArea dt = new FSL_MakeModelRequestWrapper.DataArea();
        
        try {
            FSLMakeModelBatch MakeModelBatch = new FSLMakeModelBatch ();
            Database.executebatch(MakeModelBatch, 10);
        }
        catch(exception e) {
            
        }
    }
    
    public static testmethod void testwrap() {
        
        //FSL_MakeModelResWrap testwrap = new FSL_MakeModelResWrap();
        FSL_MakeModelResWrap.parse('{"DataArea": {"CustomerCode": 2110054,"CSSJobID": "00002863","ContactID": 0},"Header": {"Sender": {"ServiceName": "CreateUpdateContact","SenderID": "CSS","MessageID": "7c997f48-27b0-4c1c-aa8b-e1ed3d1b3b50"},"Status": "ERROR","Target": {"TargetID": "MOVEX"},"ReturnCodeDescription": "Combination of Contact Name, Phone# & Email already exist.","Location": {"LocationID": "05340-73633"}}}');
    }
    
    public static testmethod void testrequestwrap() {
        
        //FSL_MakeModelResWrap testwrap = new FSL_MakeModelResWrap();
        FSL_MakeModelRequestWrapper.parse('{"DataArea": {"CustomerCode": 2110054,"CSSJobID": "00002863","ContactID": 0},"Header": {"Sender": {"ServiceName": "CreateUpdateContact","SenderID": "CSS","MessageID": "7c997f48-27b0-4c1c-aa8b-e1ed3d1b3b50"},"Status": "ERROR","Target": {"TargetID": "MOVEX"},"ReturnCodeDescription": "Combination of Contact Name, Phone# & Email already exist.","Location": {"LocationID": "05340-73633"}}}');
        FSL_MakeModelToken fsltoken = new FSL_MakeModelToken();
        fsltoken.expires_on ='Test';
        fsltoken.not_before ='Test';
        fsltoken.ext_expires_in ='Test';
        fsltoken.resource ='Test';
        fsltoken.expires_in ='Test';
        fsltoken.token_type ='Test';
    }
}