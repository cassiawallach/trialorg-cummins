@isTest
public class dbu_mostPopularPartsBatch_Test 
{
    static testMethod void test() 
    {
        List<ccrz__E_OrderItem__c> orderItemList = new List<ccrz__E_OrderItem__c>();
        List<ccrz__E_Product__c> productList = new List<ccrz__E_Product__c>(); 
        
        //ccrz__E_Product__c objProduct = new ccrz__E_Product__c();
        ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
        //Product
          ccrz__E_Product__c objProduct = new ccrz__E_Product__c(ccrz__SKU__c = '15458776',
                                                               Name = 'Connected Advisor',
                                                               ccrz__ShortDesc__c = 'testing',
                                                               ccrz__Quantityperunit__c = 3343,
                                                               ccrz__StartDate__c = system.today(),
                                                               ccrz__EndDate__c = system.today()+1,
        													   dbu_mostPopularParts__c = false,
                                                               dbu_Has_Core_Child__c = false,
                                                               Group_Name__c='Ecom');
        insert objProduct;
        
        ccrz__E_Product__c objProduct2 = new ccrz__E_Product__c(Name = 'Test',
                                                                ccrz__SKU__c = '15458777',
                                                                ccrz__ShortDesc__c = 'testing',
                                                                ccrz__Quantityperunit__c = 3343,
                                                                ccrz__StartDate__c = system.today(),
                                                                ccrz__EndDate__c = system.today()+1,
            												    dbu_mostPopularParts__c = false,
                                                                dbu_Has_Core_Child__c = false,
                                                                Group_Name__c='Ecom');
        insert objProduct2;
        //Order
        ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true);
        order.ccrz__OrderStatus__c='Cancellation Pending'; 
        Insert order;
        
        // OrderItem 
        orderItem.ccrz__Price__c = 500;
        orderItem.ccrz__Quantity__c = 55;
        orderItem.ccrz__SubAmount__c = 250;
        orderItem.ccrz__Order__c = order.id;
        //orderItem.Group_Name__c = 'Ecom';
        orderItem.ccrz__Product__c = objProduct.Id; 
         
        Insert orderItem;
        
        ccrz__E_OrderItem__c orderItem2 = new ccrz__E_OrderItem__c();
        orderItem2.ccrz__Price__c = 500;
        orderItem2.ccrz__Quantity__c = 75;
        orderItem2.ccrz__SubAmount__c = 250;
        //orderItem2.Group_Name__c = 'Ecom';
        orderItem2.ccrz__Order__c = order.id;
        orderItem2.ccrz__Product__c = objProduct2.Id;
        
        Insert orderItem2;
        
        
        // OrderItem
            //orderItem.ccrz__Product__c = objProduct.Id;
			//orderItem.ccrz__Quantity__c =  3;
        	//orderItem.ccrz__Order__c = 'a2V3J0000001FC4UAM'; 
			//orderItem.ccrz__Price__c = 	320.0;
			//orderItem.ccrz__SubAmount__c = 	640.0;
          //Insert orderItem; 
        /*
        for(Integer i=0;i<2;i++)
        {
            objProduct.Name = 'Cummins Rectangular Ring Seal 100099 ' + i;
            objProduct.ccrz__SKU__c = '100099CECO ' + i;
            //objProduct.ccrz__ProductStatus__c = 'Released';
            //objProduct.ccrz__Storefront__c = 'CSSNAStore';
            //objProduct.Group_Name__c = 'Ecom';
        	objProduct.dbu_mostPopularParts__c = false;
            //productList.add(objProduct);
        }  
        Insert	objProduct; 
		System.debug('objProduct>>>' + objProduct);
        
        for(Integer i = 0 ; i < 3; i++)
        {
            orderItem.ccrz__Product__c = objProduct.Id;
			orderItem.ccrz__Quantity__c =  i;
            orderItemList.add(orderItem);
        }
        System.debug('orderItemList>>>' + orderItemList);
        Insert orderItemList;
        */
        
        Test.startTest();
			dbu_mostPopularPartsBatch obj = new dbu_mostPopularPartsBatch();
			DataBase.executeBatch(obj); 
        Test.stopTest();
         
        //Verify orderItem updated
        //List<ccrz__E_OrderItem__c> accUpdatedList = [SELECT Id, Name FROM ccrz__E_OrderItem__c];
        //System.assert(accUpdatedList[0].Name.Contains('Updated'));
    }

}