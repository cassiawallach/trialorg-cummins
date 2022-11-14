@IsTest(SeeAllData=false)
public class CSS_IntegrationAdminControllerTest {
    //Rajashekar N     10/09/2020          No Code Change; Adding for Apex Class Coverage

    public static TestMethod void testValidScen_Test(){
        CSS_IntegrationAdminController controller = new CSS_IntegrationAdminController();
        
        list<CSS_Integration_Details__c> recs= new list<CSS_Integration_Details__c>();
        CSS_Integration_Details__c condetails = new CSS_Integration_Details__c();
        condetails.name='OAGOAuth';
        condetails.ApplicationName__c='OAGOAuth';
        condetails.AuthEnv__c='OAGOAuth';
        condetails.End_Point__c='https://services-dev-oauth.cummins.com/api/oauth/token/css/getinfo';
        condetails.grant_type__c='Refresh_full';
        condetails.IsActive__c=true;
        condetails.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails.Logging__c='BOTH';
        condetails.Method_Type__c='POST';
        condetails.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails.Timeout__c=120;
        condetails.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';
        recs.add(condetails);
        CSS_Integration_Details__c condetails1 = new CSS_Integration_Details__c();
        condetails1.name='Mule Send data';
        condetails1.ApplicationName__c='Mule Soft';
        condetails1.AuthEnv__c='ad724392-5594-4e85-b9eb-b0fc19c2fabe';
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
        insert recs; 
        
        controller.newRecord();
        controller.record.ApplicationName__c = 'Test App 1';
        controller.record.End_Point__c = 'Sample End Point';
        controller.record.IsActive__c = true;
        controller.record.Key__c = 'Auth Key';
        controller.record.Passcode__c = 'Test App Passcode';
        controller.record.Username__c = 'Test App UserName';
        controller.saveRecord();
        controller.selectedValue = controller.record.Id;
        controller.getValues();
        controller.editRecord();
        controller.record.Key__c = 'Updated Auth Key';
        controller.record.Passcode__c = 'Updated Test App Passcode';
        controller.record.Username__c = 'Updated Test App UserName';   
        controller.saveRecord();
        controller.cancelSave();
        controller.selectedValue = '--Select--';
        controller.getValues();
        controller.selectedValue = controller.record.Id;
        controller.deleteRecord();
        // to cover exceptions
        controller.record = null;
        controller.editRecord(); 
        controller.saveRecord();
        controller.deleteRecord();
    }
}