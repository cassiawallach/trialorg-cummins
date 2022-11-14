@isTest
public class CG_SL_Campaigns_Test {

    static testMethod void TryMethod(){
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        Test.StartTest();
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        inte.Name = 'GetCampaign';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'GetCampaign';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        inte.Method_Type__c = 'GET';
        insert inte;
        CSS_getConnnectionDetails.getConnection('GetCampaign');
        CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
        CG_IP_OAGWrapper ipwrap = new CG_IP_OAGWrapper();
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        OPWrap = CG_SL_Campaigns.callGetCampaignsWS('33186363', '24-AUG-16', 'NORTH AMERICA', '100 ','CSS', 'GetCampaign','UniqueID', 'CSSWarranty');
        /*ipwrap.methodType = 'GET';
        ipwrap.serviceName = 'GetCampaign';
        ipwrap.endPoint = 'test';*/
        Test.StopTest();
    }
    
    static testmethod void exceptionMethod(){
        Test.startTest();
        try{
        CG_OP_OAGWrapper oag5=CG_SL_Campaigns.callGetCampaignsWS(null,null,null,null,null,null,null,null);
           oag5.exceptionFlag =true;
        }catch(Exception e){
         
        }
        Test.stopTest();
    }
}