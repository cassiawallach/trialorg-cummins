//updated by sangeeta on 7th feb 2022
@isTest
public class OSM_FW_Order_Item_Cancelation_Alert_Test{
  static testMethod void method1(){
  
  
  ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c();
            accGrp.Name = 'US/CAN_EBU_SIR_ACCGRP';
            insert accGrp ;
       
       
        Account portalAccount2 = new Account();
            portalAccount2.Name = 'TestAccount2';
            portalAccount2.OwnerId = UserInfo.getUserId();
            portalAccount2.OSM_Preferred_Billing_Frequency_Lock__c=false;
            portalAccount2.BMS_Customer_ID__c='1234';
            portalAccount2.OSM_Preferred_Payment_Method__c='cc';
            portalAccount2.OSM_Preferred_Payment_IsBolt_PO__c=false;
            portalAccount2.ccrz__E_AccountGroup__c=accGrp.id;
         insert portalAccount2;
  
  
        Contact contact1 = new Contact();
            contact1.FirstName = 'Test';
            contact1.Lastname = 'McTesty';
            contact1.IAM_Contact_Status__c='Pending';
            contact1.Username__c = 'testUserName9980@gmail.com';
            contact1.AccountId = portalAccount2.Id;
            contact1.Email ='test@test.com';
            insert contact1; 
            
            
            
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Connected Advisor';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        insert prod;
        
        List<ccrz__E_Order__c> ordList = new List<ccrz__E_Order__c>();
        ccrz__E_Order__c ord = new ccrz__E_Order__c();
        //ord.ccrz__TotalAmount__c = 20;
        ord.ccrz__OrderStatus__c = 'Order Submitted' ;
        //ord.Partial_Cancellation__c = 3;
        ord.ByPassFlow__c = true;
        ord.ccrz__User__c=UserInfo.getUserId();
        ord.ccrz__Contact__c=contact1.id;
        ordList.add(ord);
        insert ordList;
        
        List<ccrz__E_OrderItem__c> ordItemLst = new List<ccrz__E_OrderItem__c>();
        ccrz__E_OrderItem__c orditem = new ccrz__E_OrderItem__c();
        orditem.ccrz__Quantity__c = 1;
        orditem.ccrz__DisplayProduct__c  = prod.id;
        orditem.ccrz__Price__c = 30;
        orditem.ccrz__SubAmount__c = 50;
        orditem.ccrz__AdjustmentAmount__c =100;
        
        ordItem.OSM_SW_Coupon_Applied__c=true;
        orditem.Vertex_Tax__c = 2;
        orditem.ccrz__OrderItemStatus__c ='Cancelled';
        orditem.Date_Revoke__c = date.today();
        orditem.ccrz__Product__c = prod.id;
        //orditem.ccrz__ItemTotal__c = 2;
        orditem.ccrz__Order__c  = ordList[0].Id;
        orditem.ccrz__OrderLineType__c ='Major';
        
        ordItemLst.add(orditem);
        insert ordItemLst;
        
        
        /*EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'name';
        validEmailTemplate.DeveloperName = 'unique_name_addSomethingSpecialHere';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();
        
        insert validEmailTemplate; */
        
        
        List<Id> orderIds =new List<Id>();
        orderIds.add(ord.id);
        
        Test.startTest();
        
      
        //List<Account> accforassertList = [SELECT Id,ccrz__E_AccountGroup__r.Name,ccrz__E_AccountGroup__c FROM Account LIMIT 50];
        OSM_FW_Order_Item_Cancelation_Alert.OSM_FW_Order_Item_Cancelation_Alert_Send_Mail(orderIds);
        
        Test.stopTest();
  
  }
  
   static testMethod void method2(){
        ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c();
            accGrp.Name = 'US/CAN_EBU_SIR_ACCGRP';
            insert accGrp ;
       
       
        Account portalAccount2 = new Account();
            portalAccount2.Name = 'TestAccount2';
            portalAccount2.OwnerId = UserInfo.getUserId();
            portalAccount2.OSM_Preferred_Billing_Frequency_Lock__c=false;
            portalAccount2.BMS_Customer_ID__c='1234';
            portalAccount2.OSM_Preferred_Payment_Method__c='cc';
            portalAccount2.OSM_Preferred_Payment_IsBolt_PO__c=false;
            portalAccount2.ccrz__E_AccountGroup__c=accGrp.id;
         insert portalAccount2;
  
  
        Contact contact1 = new Contact();
            contact1.FirstName = 'Test';
            contact1.Lastname = 'McTesty';
            contact1.IAM_Contact_Status__c='Pending';
            contact1.Username__c = 'testUserName9980@gmail.com';
            contact1.AccountId = portalAccount2.Id;
            contact1.Email ='test@test.com';
            insert contact1; 
            
            
            
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Connected Advisor';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        insert prod;
        
        List<ccrz__E_Order__c> ordList = new List<ccrz__E_Order__c>();
        ccrz__E_Order__c ord = new ccrz__E_Order__c();
        //ord.ccrz__TotalAmount__c = 20;
        ord.ccrz__OrderStatus__c = 'Order Submitted' ;
        //ord.Partial_Cancellation__c = 3;
        ord.ByPassFlow__c = true;
        ord.ccrz__User__c=UserInfo.getUserId();
        ord.ccrz__Contact__c=contact1.id;
        ord.Purchased_By_User_Type__c = Label.OSM_SSOEM_Admin_UserType;
        ordList.add(ord);
        insert ordList;
        
        List<ccrz__E_OrderItem__c> ordItemLst = new List<ccrz__E_OrderItem__c>();
        ccrz__E_OrderItem__c orditem = new ccrz__E_OrderItem__c();
        orditem.ccrz__Quantity__c = 1;
        orditem.ccrz__DisplayProduct__c  = prod.id;
        orditem.ccrz__Price__c = 30;
        orditem.ccrz__SubAmount__c = 50;
        orditem.ccrz__AdjustmentAmount__c =100;
        
        ordItem.OSM_SW_Coupon_Applied__c=true;
        orditem.Vertex_Tax__c = 2;
        orditem.ccrz__OrderItemStatus__c ='Cancelled';
        orditem.Date_Revoke__c = date.today();
        orditem.ccrz__Product__c = prod.id;
        //orditem.ccrz__ItemTotal__c = 2;
        orditem.ccrz__Order__c  = ordList[0].Id;
        orditem.ccrz__OrderLineType__c ='Major';
        
        ordItemLst.add(orditem);
        insert ordItemLst;
        
        
        /*EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'name';
        validEmailTemplate.DeveloperName = 'unique_name_addSomethingSpecialHere';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();
        
        insert validEmailTemplate; */
        
        
        List<Id> orderIds =new List<Id>();
        orderIds.add(ord.id);
        
        Test.startTest();
        
      
        //List<Account> accforassertList = [SELECT Id,ccrz__E_AccountGroup__r.Name,ccrz__E_AccountGroup__c FROM Account LIMIT 50];
        OSM_FW_Order_Item_Cancelation_Alert.OSM_FW_Order_Item_Cancelation_Alert_Send_Mail(orderIds);
        
        Test.stopTest(); 
                    
    }


}