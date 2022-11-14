/**********************************************************************
Name:CG_SL_ANVL_Test
Copyright © 2011  Cummins
======================================================================
======================================================================
Purpose:Test class for CG_SL_ANVL
This class is used to call ANVL system using the prepared request JSON 
through parser.
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                           
1.0 - Venkat Gantasala    11/29/2018       Initial Development
***********************************************************************/
@isTest
public class CG_SL_ANVL_Test {
    public static testmethod void Method1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='wenchin@chinnoy.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id,FederationIdentifier = 'test',
                          TimeZoneSidKey='America/Los_Angeles', UserName='wenchin@chinnoy.com',User_Location__c = '03742-03742');
        insert u;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(false);
        JO.Additional_Tech1__c = u.Id;
        JO.Assigned_To__c = u.Id;
        JO.Additional_Tech1__c = u.Id;
        JO.Additional_Tech2__c = u.Id;
        JO.Additional_Tech3__c = u.Id;
        JO.Additional_Tech4__c = u.Id;
        JO.Additional_Tech5__c = u.Id;
        JO.Additional_Tech6__c = u.Id;
        JO.Additional_Tech7__c = u.Id;
        JO.Additional_Tech8__c = u.Id;
        JO.Additional_Tech9__c = u.Id;
        insert JO;
                  CSS_Job_Order__c workJob = [SELECT Id, Name, Shop_Work_Order__c,Account__r.CG_ANVL_Enabled__c,Assigned_to__r.FederationIdentifier,
                     Category_Desc__c,Complaint_Type_Desc__c, ESN__c,Service_Model__c,Account__r.IAM_Service_Provider_Code__c,ApplicationCode__c, 
                     Application_Desc__c, Repair_Location__c,Customer_Name__c,Customer_Code__c, Assigned_to__c, Additional_Tech1__c,
                     Additional_Tech1__r.FederationIdentifier, Additional_Tech2__c,Additional_Tech2__r.FederationIdentifier, 
                     Additional_Tech3__c,Additional_Tech3__r.FederationIdentifier, Additional_Tech4__c,Additional_Tech4__r.FederationIdentifier,
                     Additional_Tech5__c,Additional_Tech5__r.FederationIdentifier, Additional_Tech6__c,Additional_Tech6__r.FederationIdentifier, 
                     Additional_Tech7__c,Additional_Tech7__r.FederationIdentifier, Additional_Tech8__c,Additional_Tech8__r.FederationIdentifier, 
                     Additional_Tech9__c,Additional_Tech9__r.FederationIdentifier, CreatedDate,Account__r.Name,LastModifiedDate 
                     FROM CSS_Job_Order__c LIMIT 1];
        CG_SL_ANVL ANVL = new CG_SL_ANVL();
        CG_IP_OAGWrapper CGTSR = new CG_IP_OAGWrapper();
        Test.startTest();
       	CGTSR.jsonReqBody = '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"CG_ANVLService","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        CGTSR.methodType = 'POST';
        CGTSR.timeOut = 1;
		CGTSR.serviceName = 'Test';
        CG_SL_ANVL.ANVLWebservice(workJob);
        CG_SL_ANVLParser parser =new CG_SL_ANVLParser();
        CG_SL_ANVLParser.prepareReqWrapper(workJob);
        Test.stopTest();
    }
    public static testmethod void Method2(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='wenchin@chinnoy.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id,FederationIdentifier = 'test',
                          TimeZoneSidKey='America/Los_Angeles', UserName='wenchin@chinnoy.com',User_Location__c = '03742-03742');
        insert u;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(false);
        JO.Additional_Tech1__c = u.Id;
        JO.Assigned_To__c = u.Id;
        JO.Additional_Tech1__c = u.Id;
        JO.Additional_Tech2__c = u.Id;
        JO.Additional_Tech3__c = u.Id;
        JO.Additional_Tech4__c = u.Id;
        JO.Additional_Tech5__c = u.Id;
        JO.Additional_Tech6__c = u.Id;
        JO.Additional_Tech7__c = u.Id;
        JO.Additional_Tech8__c = u.Id;
        JO.Additional_Tech9__c = u.Id;
        insert JO;
        CG_SL_ANVL ANVL = new CG_SL_ANVL();
        CG_IP_OAGWrapper CGTSR = new CG_IP_OAGWrapper();
        Test.startTest();
       	CGTSR.jsonReqBody = '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"CG_ANVLService","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        CGTSR.methodType = 'POST';
        CGTSR.timeOut = 1;
		CGTSR.serviceName = 'Test';
        CG_SL_ANVL.ANVLWebservice(JO);
        CG_SL_ANVLParser parser =new CG_SL_ANVLParser();
        CG_SL_ANVLParser.prepareReqWrapper(JO);
        Test.stopTest();
    }
}