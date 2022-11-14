//Added comment for deployment sept 2022
@isTest
public class FSL_EmailServiceOutboundController_Test {
    
    public static testmethod void sendTextCommMethod1(){
        Id conRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.RecordTypeId = conRecId;
        insert acc;
        WorkOrder wo = new WorkOrder();
        wo.Payer__c = acc.id;
        test.startTest();
        insert wo;
        test.stopTest();
        Service_Order_Communication__c soc = new Service_Order_Communication__c();
        soc.Action__c = 'sms';
        soc.Service_Order__c = wo.id;
        soc.Communication_Trigger_Name__c = 'Troubleshooting Started';
        soc.Unit__c = 'CONVENTIONAL';
        soc.VIN__c = '7EN778584';
        soc.Target_Email_Address__c = 'prabhakar.ragula@cummins.com';
        soc.Language__c = 'EN';
        soc.Target_Phone_Number__c = '1234567898';
        soc.Product_Serial_Number__c = '79661008';
        soc.Address__c = 'San Antonio ,Texas';
        soc.Event_Type__c = 'Service_Status_Change';
        soc.Communication_SMS_Status__c= Boolean.valueOf('false');

        insert soc;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        inte.Name = 'FSL_TextNotification';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'FSL_TextNotification';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        inte.Method_Type__c = 'GET';
        insert inte;
        FSL_TextNotificationRespJSON textResp = new FSL_TextNotificationRespJSON();
        
        List<id>socids = new List<id>();
        Set<id>socidsSet = new Set<id>();
        socids.add(soc.id);
        socidsSet.add(soc.id);
        
        //FSL_SendServiceOrderTextCommunication.sendSOTextCommunication(socids);
        List<id>soid = new List<id>();
        soid.add(wo.id);
        
       //Creating the Content Version data
        ContentVersion contentVersion = new ContentVersion(
                    Title          = 'test',
                    PathOnClient   = 'test.snote',
                    VersionData    = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
            insert contentVersion;
			
 		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
   		list<id> docids = new list<id>();
		docids.add(documents[0].Id);     
		//create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = wo.Id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl;

        FSL_EmailServiceOutboundController.sendMailMethod('test@cummins.com', 'test@cummins.com', 'Test Subject', 'EmailBody', wo.Id, docids , 'ref:_00D3C5Um._5003C5TKNx:ref');
        FSL_EmailServiceOutboundController.getCaseThreadID(wo.Id);

	}
}