@isTest
public class CG_SL_ANVLParser_Test {
    public static testMethod void CG_SL_ANVLParser_Method(){
       test.startTest();
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '02650-97895',FederationIdentifier='GQ546');
            insert u;
        system.runAs(u){
            CSS_Job_Order__c jobRec = CSS_TestData.createJobOrder(false);
                    jobRec.Assigned_to__c=u.id;
                    jobRec.Additional_Tech1__c=u.id;
                    jobRec.Additional_Tech2__c=u.id;
                    jobRec.Additional_Tech3__c=u.id;
                    jobRec.Additional_Tech4__c=u.id;
                    jobRec.Additional_Tech5__c=u.id;
                    jobRec.Additional_Tech6__c=u.id;
                    jobRec.Additional_Tech7__c=u.id;
                    jobRec.Additional_Tech8__c=u.id;
                    jobRec.Additional_Tech9__c=u.id;
             insert jobRec;
            CSS_Job_Order__c workJob = [SELECT Id, Name, Shop_Work_Order__c,Account__r.CG_ANVL_Enabled__c,Assigned_to__r.FederationIdentifier,
                     Category_Desc__c,Complaint_Type_Desc__c, ESN__c,Service_Model__c,Account__r.IAM_Service_Provider_Code__c,ApplicationCode__c, 
                     Application_Desc__c, Repair_Location__c,Customer_Name__c,Customer_Code__c, Assigned_to__c, Additional_Tech1__c,
                     Additional_Tech1__r.FederationIdentifier, Additional_Tech2__c,Additional_Tech2__r.FederationIdentifier, 
                     Additional_Tech3__c,Additional_Tech3__r.FederationIdentifier, Additional_Tech4__c,Additional_Tech4__r.FederationIdentifier,
                     Additional_Tech5__c,Additional_Tech5__r.FederationIdentifier, Additional_Tech6__c,Additional_Tech6__r.FederationIdentifier, 
                     Additional_Tech7__c,Additional_Tech7__r.FederationIdentifier, Additional_Tech8__c,Additional_Tech8__r.FederationIdentifier, 
                     Additional_Tech9__c,Additional_Tech9__r.FederationIdentifier, CreatedDate,Account__r.Name,LastModifiedDate 
                     FROM CSS_Job_Order__c LIMIT 1];
       
            CG_SL_ANVLParser slAnvlRec = new CG_SL_ANVLParser();
                  CG_SL_ANVLParser.assignedUsers(workJob);
                  CG_SL_ANVLParser.prepareReqWrapper(workJob);
                  CG_SL_ANVLParser.prepareCategoryComplaintTypeString(workJob);
        }
       test.StopTest();
    }
}