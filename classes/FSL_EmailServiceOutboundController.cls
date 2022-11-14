/** Class Name  : FSL_EmailServiceOutboundController
*  Description  : This class used to sending the email messages
*  Created By   : Madhavi P  
*
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date                   Modification ID      Description 
    Gnyana                   7/14/2022                FBI-379            Modification for new release
    Disable Ref Id and transition to new email threading
*  ---------------------------------------------------------------------------------------------------------------------------------------
**/
public class FSL_EmailServiceOutboundController {
    
    
    @AuraEnabled 
    public static void sendMailMethod(String mMail,String ccMail ,String mSubject ,String mbody,string recid, List<Id> docIds, string ThreadId){
        system.debug('WOID======= '+recid+ '============== '+docIds);
        WorkOrder woRec = [SELECT Id, CaseId FROM WorkOrder WHERE Id=:recId];
        string subrec= '('+ recid +')';  
        list<Id> documentIds = new list<Id>();
        
        documentIds =  docIds;
        
        system.debug('documentIds==== '+documentIds);
        
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        
        
        List<String> sendTo = mMail.split(',');
        List<String> sendCC  = new List<String>();
        if(string.isNotBlank(ccMail)){
            sendCC = ccMail.split(',');
            mail.setccAddresses(sendCC); 
        }
        mail.setToAddresses(sendTo);        
        String addrUrl='replyemailtocontact@1xa8w2dg2mv8jwboee0zu8kf5yl5i45x4x2sy11h5871sme9vu.28-s3hgeay.ap6.apex.salesforce.com';
        mail.setOrgWideEmailAddressId(System.label.Service_Notifications_Org_Id);      
        mail.setSubject(mSubject );
        mail.setHtmlBody(mbody);   
        if(String.isNotBlank(woRec.CaseId)) {
        	mail.setWhatId(woRec.CaseId);    
        }
        
        try{
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            //List<Id> dfdsfs = new List<Id>();
            List<ContentVersion> versions = [SELECT ContentDocumentId,VersionData,FileExtension,FileType,Id,Title FROM ContentVersion where ContentDocumentId IN: docIds AND IsLatest = true];
            for (ContentVersion a : [SELECT id,ContentDocument.Title,ContentDocument.FileType,ContentDocument.FileExtension,
                                     ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.VersionData
                                     FROM ContentVersion WHERE ContentDocumentId  IN :documentIds AND IsLatest = true ])
            {
                
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(a.ContentDocument.Title+'.'+a.ContentDocument.FileExtension);
                String blobValue = EncodingUtil.base64Encode(a.ContentDocument.LatestPublishedVersion.VersionData);
                efa.setBody(EncodingUtil.base64Decode(blobValue));
                system.debug('Inside EFA++++++  '+a);
                fileAttachments.add(efa);
            }
            if(fileAttachments.size() > 0){
                mail.setFileAttachments(fileAttachments);
                system.debug(fileAttachments);
            }
        }
        catch (Exception e){
            system.debug('attach issue'+e.getMessage());
        }
        mails.add(mail); 
        WorkOrder wo = [SELECT id, Status,ContactId,Contact.Language_Preferences__c,Contact.Authorize_work_started__c,Contact.Troubleshooting_started__c, Contact.Service_Work_Completed__c,Contact.Equipment_available__c,Contact.Invoice_ready__c, Account.Language_Preference__c,
                        Account.Lang_Pref_Code__c,ESN__c,Asset.Name,Asset.Unit_Number__c,Asset.VIN__c,CaseId,Service_Team_Contact__c,
                        Service_Team_Contact__r.email, ServiceTerritory.Street,ServiceTerritory.city,ServiceTerritory.state,
                        ServiceTerritory.postalcode,ServiceTerritory.Phone__c,ServiceTerritory.Country, Unit_Type__c, 
                        Fault_Code_Communication_Trigger__c, Make__c, Model__c, Payer__c,Payer__r.ERP_System__c,
                        Payer__r.Language_Preference__c, Payer_ContactID__c,FSL_Additional_Email_Notifications__c,
                        Account.Troubleshooting_Started__c, Account.Authorize_Work_Started__c, Account.Service_Work_Completed__c, 
                        Account.Invoice_Ready__c, Account.Equipment_Available__c, CustomMessage__c,Communication_Type__c
                        FROM Workorder 
                        WHERE Id =: Id.valueOf(recid)];
        if(wo.Communication_Type__c != 'Custom Communication'){
            wo.Communication_Type__c = 'Custom Communication';
            update wo;
        }
        
        Messaging.sendEmail(mails);
        
        // versions
        
        //Creating Communication record
        Service_Order_Communication__c SOEmailMessage = new Service_Order_Communication__c();
        SOEmailMessage.Action__c = 'Email';
        SOEmailMessage.Service_Order__c = wo.Id;
        SOEmailMessage.Communication_Trigger_Name__c = '';
        if(string.isNotBlank(ccMail)){
            SOEmailMessage.Recipient__c  = mMail +','+ ccMail;
            SOEmailMessage.Target_Email_Address__c  = mMail +','+ ccMail;
        }
        else{
            SOEmailMessage.Recipient__c  = mMail;
            SOEmailMessage.Target_Email_Address__c  = mMail;
        }
        
        //SOEmailMessage.Address__c = addressForSms;
        SOEmailMessage.ERP__c = wo.Payer__r.ERP_System__c;
        SOEmailMessage.Event_Type__c = 'Service_Status_Change';//Need to check on the mapping
        SOEmailMessage.From_Address__c = label.Service_Notifications_Org_Id;
        SOEmailMessage.Make__c = wo.Make__c;
        SOEmailMessage.Model__c = wo.Model__c;
        SOEmailMessage.Phone_Number__c = wo.ServiceTerritory.Phone__c;
        SOEmailMessage.Product_Serial_Number__c = wo.Asset.Name;
        SOEmailMessage.VIN__c = wo.Asset.VIN__c;
        SOEmailMessage.Unit__c = wo.Asset.Unit_Number__c;
        SOEmailMessage.Service_Request__c = wo.CaseId;
        SOEmailMessage.Target_Email_Cc_Address__c = ccMail;
        SOEmailMessage.Sender_App_Name__c = 'Guidanz';
        SOEmailMessage.Status__c = 'Sent';
        SOEmailMessage.Custom_Message__c = mbody.stripHtmlTags();
        SOEmailMessage.Communication_Trigger_Name__c = 'Custom Email'; 
        Insert SOEmailMessage;
        list<ContentVersion> listContentVersion = [SELECT id,ContentDocument.Title,ContentDocument.FileType,ContentDocument.FileExtension,
                                                  ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.VersionData
                                                  FROM ContentVersion WHERE ContentDocumentId  IN :documentIds AND IsLatest = true]; //added As a part of FBI 393
        for (ContentVersion a : listContentVersion){ //added As a part of FBI 393
                                     ContentDocumentLink cdl = new ContentDocumentLink();
                                     cdl.ContentDocumentId = a.ContentDocumentId;
                                     cdl.LinkedEntityId = SOEmailMessage.Id; // workspaceId where user wants to publish the file.
                                     cdl.ShareType = 'I';
                                     cdl.Visibility = 'AllUsers'; 
                                     insert cdl;
                                 }
        
        // deleting the files records for the workorder object.
        try{
            List<ContentDocumentLink> deletelist =  [Select Id, ContentDocument.Description,LinkedEntityId  From ContentDocumentLink  Where LinkedEntityId =: Id.valueOf(recid) AND ContentDocumentId IN  : docIds ];
            system.debug('Inside query');
            
            if(deletelist.size() > 0){
                delete deletelist;
            }
        }
        catch (exception e){
            system.debug('Exception caused_____  '+e);
        }
        
        
        
    }
    
    @AuraEnabled 
    public static string getCaseThreadID (id ServiceOrderId){
        
        WorkOrder wo = [Select id, CaseId, case.Custom_Thread_Id__c from workorder where id = :ServiceOrderId];
        system.debug('REturned CaseID============= '+ServiceOrderId+ 'wo.CaseID ================== '+wo.case.Custom_Thread_Id__c);
        return wo.Case.Custom_Thread_Id__c;
    }
    
}