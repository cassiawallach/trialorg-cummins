//Test Class for the class OSM_Subscription_DaysAlertbatch
/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Singaiah        22/04/2021      MAR-1618 Story
 2.0        Ashish G        11/24/2021      MP-387 Story
 3.0        Ronnie Mishra   12/16/2021      MP-140, Altered code to include email alerts for quaterly and monthly subscription lengths. 
 4.0        Sangeeta Rani   11/01/2022      Updated
5.0         swetha          16/03/2022      Updated
 */
@istest
public class OSM_Subscription_DaysAlertbatch_Test{
    @testSetup static void setup() {
        try{
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            String orgId = UserInfo.getOrganizationId();
            String dateString = String.valueof(Datetime.now().getTime());
            String uniqueName = orgId + dateString +'@test.com';
            User user = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName=uniqueName);
            insert user;
            Contact ObjContact = new Contact(FirstName='fname', LastName = 'lname', Email = 'email@gmail.com', Phone = '9743800309', IAM_Contact_Owner__c = UserInfo.getUserId(), Username__c = 'email@gmail.com.fulluat');
            insert ObjContact;
            
            List<Account>  lstacc = new List<Account>();
            Account acc = new Account();
            RecordType recid =[select id from recordType where name='wwsps' limit 1];  
            acc.RecordTypeId= recid.id;       
            acc.Name = 'Test Account';            
            acc.CMI_Account_Status__c = 'Active';
            acc.CMI_CDA_Status__c = 'New Customer Request';
            acc.CMI_Region__c = 'NORTH AMERICA';
            acc.CSS_Language__c = 'English';
            acc.BillingCountry = 'United States';
            acc.IAM_Service_Provider_Code__c = 'Service';
            lstacc.add(acc);
            insert lstacc;            
            
            
            List<ccrz__E_Order__c>  lstCCOrder = new List<ccrz__E_Order__c>();
            ccrz__E_Order__c  objCCOrder = new ccrz__E_Order__c();               
            objCCOrder.ccrz__Account__c = acc.ID;
            objCCOrder.ccrz__User__c = user.Id;
            objCCOrder.OSM_SW_Should_mail_Send__c = true;
            objCCOrder.OSM_SW_Is_InterCompany_Order__c = false;
            objCCOrder.ccrz__OrderStatus__c='Order Submitted'; 
            objCCOrder.Send_SSOEM_Customer_Email__c = true; 
            objCCOrder.Purchased_By_User_Type__c = Label.OSM_SSOEM_Reseller;
            objCCOrder.ccrz__Contact__c = ObjContact.Id;
            objCCOrder.OSMSecondaryEmail__c = 'test@test.com';
            lstCCOrder.add(objCCOrder);
            ccrz__E_Order__c  objCCOrder2 = objCCOrder.clone();
            objCCOrder2.Purchased_By_User_Type__c = Label.OSM_SSOEM_Admin_UserType;
            objCCOrder2.OSMSecondaryEmail__c = 'test@test.com';
            objCCOrder2.Send_SSOEM_Customer_Email__c = true;
            objCCOrder2.ccrz__User__c = user.Id;
            objCCOrder2.ccrz__Contact__c = ObjContact.Id;
            lstCCOrder.add(objCCOrder2);
            ccrz__E_Order__c  objCCOrder3 = objCCOrder.clone();
            objCCOrder3.Purchased_By_User_Type__c = Label.OSM_SSOEM_Admin_UserType;
            objCCOrder3.OSMSecondaryEmail__c = 'test@test.com';
            objCCOrder3.Send_SSOEM_Customer_Email__c = true;
            objCCOrder3.ccrz__User__c = user.Id;
            objCCOrder3.ccrz__Contact__c = ObjContact.Id;
            lstCCOrder.add(objCCOrder3);
            insert lstCCOrder;
            
            ccrz__E_Product__c objCCProduct = new ccrz__E_Product__c(name = 'Test', ccrz__SKU__c = '1234', ccrz__Quantityperunit__c = 1.000000, ccrz__StartDate__c = Date.parse('5/14/2020'), ccrz__EndDate__c = Date.parse('12/31/2099'));  
            insert objCCProduct;
            
            ccrz__E_SubProdTerm__c sptObj = new ccrz__E_SubProdTerm__c();
            sptObj.ccrz__CCProduct__c = objCCProduct.Id;
            sptObj.ccrz__EffectiveEnd__c = System.now().addDays(-28);
            sptObj.ccrz__EffectiveStart__c = System.now().addDays(-365);
            sptObj.ccrz__DisplayName__c = '1 Month';
            insert sptObj;
            
            ccrz__E_SubProdTerm__c sptObj2 = new ccrz__E_SubProdTerm__c();
            sptObj2.ccrz__CCProduct__c = objCCProduct.Id;
            sptObj2.ccrz__EffectiveEnd__c = System.now().addDays(-28);
            sptObj2.ccrz__EffectiveStart__c = System.now().addDays(-365);
            sptObj2.ccrz__DisplayName__c = '1 Quarter';
            insert sptObj2;
            
            ccrz__E_SubProdTerm__c sptObj3 = new ccrz__E_SubProdTerm__c();
            sptObj3.ccrz__CCProduct__c = objCCProduct.Id;
            sptObj3.ccrz__EffectiveEnd__c = System.now().addDays(-28);
            sptObj3.ccrz__EffectiveStart__c = System.now().addDays(-365);
            sptObj3.ccrz__DisplayName__c = '1 Year';
            insert sptObj3;
            
            
            List<ccrz__E_Subscription__c> lstobjE_Subscription = new List<ccrz__E_Subscription__c>();
            ccrz__E_Subscription__c objE_Subscription = new ccrz__E_Subscription__c();            
            objE_Subscription.OSM_Display_Product__c = objCCProduct.id;
            objE_Subscription.ccrz__SubscriptionProduct__c = objCCProduct.Id;
            objE_Subscription.ccrz__CCOrder__c = lstCCOrder[0].Id;
            objE_Subscription.ccrz__SubscriptionStartDate__c = System.today()- Integer.valueof('10'); 
            objE_Subscription.OSM_Subscription_End_Date__c = system.now().addDays(-7);
            objE_Subscription.ccrz__SubscriptionStatus__c = 'Active' ;
            objE_Subscription.Contact__c = ObjContact.Id;
            objE_Subscription.ccrz__Sequence__c = 1234567;
            objE_Subscription.ccrz__Storefront__c = 'SoftwareStore'  ;
            objE_Subscription.ccrz__Quantity__c = 10;
            objE_Subscription.ccrz__Account__c = acc.ID;
            objE_Subscription.ccrz__Sequence__c = 500;   
            objE_Subscription.ccrz__SPT__c = sptObj.Id;
            objE_Subscription.ccrz__CCOrder__c = lstCCOrder[0].Id;
            lstobjE_Subscription.add(objE_Subscription);
            
            ccrz__E_Subscription__c objE_Subscription2 = objE_Subscription.clone();
            objE_Subscription2.ccrz__SPT__c = sptObj2.Id;
            objE_Subscription2.OSM_Subscription_End_Date__c = system.now().addDays(-30);
            objE_Subscription2.ccrz__CCOrder__c = lstCCOrder[1].Id;
            lstobjE_Subscription.add(objE_Subscription2);
            
            ccrz__E_Subscription__c objE_Subscription3 = objE_Subscription.clone();
            objE_Subscription3.ccrz__SPT__c = sptObj3.Id;
            objE_Subscription3.OSM_Subscription_End_Date__c = system.now().addDays(-30);
            objE_Subscription3.ccrz__CCOrder__c = lstCCOrder[2].Id;
            lstobjE_Subscription.add(objE_Subscription3);
            
            
            
            
            insert lstobjE_Subscription; 
            
        }catch(Exception ex){
            System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
        }  
        
    }
    
    
    static testmethod void OSM_Subscription_DaysAlertbatch(){
        try{
            
             Database.BatchableContext BC;
            OSM_Subscription_DaysAlertbatch obj = new OSM_Subscription_DaysAlertbatch();
            Id batchId = Database.executeBatch(obj,1);
            System.assert(batchId != null);
            Test.startTest();  
            List<ccrz__E_Subscription__c> scope = [Select id,ccrz__CCOrder__r.ccrz__Contact__c,ccrz__CCOrder__r.OSMSecondaryEmail__c,ccrz__CCOrder__r.ccrz__User__c,OSM_Display_Product__r.name,
                                         ccrz__SubscriptionStartDate__c,ccrz__SubscriptionStatus__c,OwnerId,Contact__c,ccrz__CCOrder__r.ccrz__Contact__r.Email,
                                         OSM_Subscription_End_Date__c,ccrz__CCOrder__r.Should_Show_Price__c,ccrz__CCOrder__r.ccrz__User__r.Email,ccrz__Account__c,ccrz__SPT__c,ccrz__SubscriptionProduct__c,  
                                         ccrz__CCOrder__r.isOnBehalf__c,ccrz__CCOrder__r.Send_SSOEM_Customer_Email__c,ccrz__CCOrder__r.Purchased_By_User_Type__c,ccrz__SPT__r.ccrz__DisplayName__c,
                                         ccrz__CCOrder__r.createdById,ccrz__CCOrder__r.OSM_Headquarter_Email__c,ccrz__CCOrder__r.ccrz__Account__r.BillingCountry,ccrz__CCOrder__r.ccrz__Account__r.Name,ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c
                                         from ccrz__E_Subscription__c 
                                         where OSM_Subscription_End_Date__c!=null and ccrz__SubscriptionStatus__c=:'Active' 
                                         and ( ( OSM_Subscription_End_Date__c >=: system.now().addDays(-7)) OR 
                                              (OSM_Subscription_End_Date__c >=: system.now().addDays(-30)))];
               
            obj.start(BC);
            obj.execute(BC, scope);
            obj.finish(BC);
            Test.stopTest();

        }catch(Exception ex){
            System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
        }
        
 
    }
}