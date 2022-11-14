//Test class for OSM_SendOrderConfirmationNotification
/*
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Singaiah       05/05/2022      Test Class for OSM_SendOrderConfirmationNotification
Updated by swetha
 */
@isTest
public class OSM_SendOrderConfirmation_Test{

    
   public static testMethod void createTestData(){
      Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1].Id;
        //User Record
        Double randomNumber = math.random();
        User user1 = TestingUtils.createUser('testinUser' + randomNumber, SYS_ADMIN_PROFILE_ID, true);
        // Account record fetch
        List<ccrz__E_AccountGroup__c> accntGroup = TestingUtils.createAccountGroup(1, 'TestingProdUtilAccountGrp', 'Best Price', true);
        List<Account> accountList=new List<Account>();
        List<Account> acnt = TestingUtils.createAccount(1, 'TestingProdUtilAccount', accntGroup[0].id, user1.id, false);
        for(Account acc:acnt){
        acc.CSS_DistributorCode__c = '02860';
        accountList.add(acc);
        }
        insert accountList; 
         // Custom Setting Insert       
         IAMDistributorCodeGroupEmail__c customSetting=new  IAMDistributorCodeGroupEmail__c();
         customSetting.Group_Email__c='test@cummins.com';
         customSetting.Distributor_Code__c=accountList[0].CSS_DistributorCode__c;
         customSetting.Name=accountList[0].CSS_DistributorCode__c;
         insert customSetting;

        //conatct record
        List < Contact > contacts = TestingUtils.createContact(1, accountList[0].id, user1.id, true);
        //CC Order
                
        List<ccrz__E_Order__c> orderList=new List<ccrz__E_Order__c>();
        
        ccrz__E_Order__c o1 = new ccrz__E_Order__c();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = accountList[0].Id;
        o1.OrderProcessedforFSD__c = true;
        o1.IsInterCompanyProcessSuccess__c = false;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        o1.Purchased_By_User_Type__c='Distributor Admin';
        o1.SendOrderDetailMail__c=true;
        o1.ccrz__OrderStatus__c='Order Submitted';
        o1.OrderConfirmationMailSent__c = false;
        insert o1;
        
        orderList.add(o1);
        
        List<ccrz__E_Product__c> listProd = TestingUtils.createEProduct(2, 'guidenz', 'Released', 1,'5678902-OHT11','SES',true);
        
        //insert spt
        List<ccrz__E_SubProdTerm__c> spt=TestingUtils.createSubProdTerm(1, 'Cummins Guidanz Service Package- 1 month One Time', listProd[0].id,'*', true);
        
        //CC OrderItem
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o1.id;
        oi1.ccrz__Product__c = listProd[0].id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = listProd[0].id;
        oi1.Dn_Price__c = 1000;
        oi1.Is_FW_OrderItem__c=false;
        oi1.OSM_SW_Is_Included_Product__c=true;
        insert oi1;
        
        ccrz__E_OrderItem__c oi11 = new ccrz__E_OrderItem__c();
        oi11.ccrz__Price__c = 500;
        oi11.ccrz__OriginalItemPrice__c = 400;
        oi11.ccrz__Quantity__c = 1;
        oi11.ccrz__SubAmount__c = 123;
        oi11.ccrz__Order__c = o1.id;
        oi11.ccrz__Product__c = listProd[0].id;
        oi11.ccrz__Subscription_Auto_Renewal__c = true;
        oi11.ccrz__DisplayProduct__c = listProd[0].id;
        oi11.Original_Sales_Order_Item__c = oi1.id;
        oi11.ccrz__SubProdTerm__c = spt[0].id;
        oi11.Dn_Price__c = 1000;
        insert oi11;

        List<ccrz__E_PriceList__c> priceList = TestingUtils.createPriceList(1, 'Test Price List', 'SoftwareStore', true, 'USD', true);

        //Create Price List Item
        List<ccrz__E_PriceListItem__c> lstPriceListItem = TestingUtils.createPriceListItem(1,spt[0].Id, priceList, listProd, true);

        Map < Id, ccrz__E_PriceListItem__c > mapSubProdIdToPriceListItem = new Map < Id, ccrz__E_PriceListItem__c > ();
        mapSubProdIdToPriceListItem.put(lstPriceListItem[0].ccrz__SubProdTerm__c, lstPriceListItem[0]);
    
         Test.startTest();
         OSM_SendOrderConfirmationNotification.sendConfirmatonEmailsMethod(orderList);
         System.assertNotEquals(null,listProd,'The Product not inserted.');
         System.assertEquals('Order Submitted', orderList[0].ccrz__OrderStatus__c);
         System.assertNotEquals(null, contacts[0].email, 'Contact email is empty');
         Test.stopTest();
     

    }
    
}