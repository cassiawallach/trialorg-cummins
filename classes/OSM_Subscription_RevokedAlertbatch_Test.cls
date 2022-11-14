//Test Class for the class OSM_Subscription_RevokedAlertbatch
/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Singaiah        22/04/2021      MAR-1618 Story
 */
@istest
public class OSM_Subscription_RevokedAlertbatch_Test {
    /** 
     * @author    Shri Ram Dubey
     *  Added as part of Defect MAR=1518 By Nandigam Sasi
     */
    @testSetup static void setup() {
        try{
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            String orgId = UserInfo.getOrganizationId();
            String dateString = String.valueof(Datetime.now().getTime());
            String uniqueName = orgId + dateString +'@test.com';
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName=uniqueName);
            insert u;

             List<Account>  lstacc = new List<Account>();
                Account acc = new Account();
                RecordType recid =[select id from recordType where name='wwsps' limit 1];  
                acc.RecordTypeId= recid.id;       
                acc.Name = 'Test Account';
                acc.CMI_Account_Status__c = 'Active';
                acc.CMI_CDA_Status__c = 'New Customer Request';
                acc.CMI_Region__c = 'NORTH AMERICA';
                acc.CSS_Language__c = 'English';
                acc.BillingCountry='United States';
                lstacc.add(acc);
                insert lstacc;
                
            Contact ObjContact = new Contact(FirstName='fname', LastName = 'lname', Email = 'email@gmail.com', Phone = '9743800309', IAM_Contact_Owner__c = UserInfo.getUserId(), Username__c = 'email@gmail.com.fulluat');//UserInfo.getUserName()); 
            insert ObjContact;
            List<ccrz__E_Order__c>  lstCCOrder = new List<ccrz__E_Order__c>();
                ccrz__E_Order__c  objCCOrder = new ccrz__E_Order__c();               
                objCCOrder.ccrz__Account__c = acc.ID;
                objCCOrder.OSM_SW_Should_mail_Send__c = true;
                objCCOrder.OSM_SW_Is_InterCompany_Order__c = false;
                objCCOrder.ccrz__OrderStatus__c='Order Submitted'; 
                objCCOrder.Send_SSOEM_Customer_Email__c = true;                 
              lstCCOrder.add(objCCOrder);
              ccrz__E_Order__c  objCCOrder2 = objCCOrder.clone();
              objCCOrder2.Purchased_By_User_Type__c = Label.OSM_SSOEM_Admin_UserType;
              lstCCOrder.add(objCCOrder2);
                insert lstCCOrder;
                
                
                ccrz__E_Product__c objCCProduct = new ccrz__E_Product__c(name = 'Test', Group_Name__c = 'SES', ccrz__SKU__c = '1234', ccrz__Quantityperunit__c = 1.000000, ccrz__StartDate__c = Date.parse('5/14/2020'), ccrz__EndDate__c = Date.parse('12/31/2099'));                
                insert objCCProduct;
                
                ccrz__E_OrderItem__c objE_OrderItem = new  ccrz__E_OrderItem__c(ccrz__Product__c = objCCProduct.Id, Revocation_Status__c = 'Revoked', ccrz__Order__c = lstCCOrder[0].Id, ccrz__Price__c = 123, ccrz__Quantity__c = 4, ccrz__SubAmount__c = 21);
                insert objE_OrderItem;
                
                List<ccrz__E_Subscription__c> lstobjE_Subscription = new List<ccrz__E_Subscription__c>();
                ccrz__E_Subscription__c objE_Subscription = new ccrz__E_Subscription__c();
                
                objE_Subscription.OSM_Display_Product__c = objCCProduct.id;
                objE_Subscription.ccrz__SubscriptionProduct__c = objCCProduct.Id;
                objE_Subscription.ccrz__CCOrder__c = lstCCOrder[0].Id;
                objE_Subscription.ccrz__SubscriptionStartDate__c = Date.parse('5/12/2020');
                objE_Subscription.OSM_Subscription_End_Date__c = system.now();
                objE_Subscription.ccrz__SubscriptionStatus__c = 'Expired' ;
                objE_Subscription.Contact__c = ObjContact.Id;
                objE_Subscription.ccrz__Sequence__c = 1234567;
                objE_Subscription.ccrz__Storefront__c = 'Test'  ;
                objE_Subscription.ccrz__CCOrderItem__c = objE_OrderItem.Id ;
                lstobjE_Subscription.add(objE_Subscription);
                ccrz__E_Subscription__c objE_Subscription2 = objE_Subscription.clone();
                lstobjE_Subscription.add(objE_Subscription2);
                objE_Subscription.ccrz__CCOrder__c = lstCCOrder[1].Id;
                insert lstobjE_Subscription;
                System.assert(objE_Subscription.Id != null);
            //}
        }catch(Exception ex){
            System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
        }  
                    
    }
    
    
    static testmethod void OSM_Subscription_ExpiredAlertbatch(){
        try{
            Test.startTest();
            OSM_Subscription_RevokedAlertbatch objOSM_Subscription_RevokedAlertbatch = new OSM_Subscription_RevokedAlertbatch();
            Id batchId = Database.executeBatch(objOSM_Subscription_RevokedAlertbatch );
            System.assert(batchId != null);
            Test.stopTest();

        }catch(Exception ex){
            System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
        }
        
    }
}