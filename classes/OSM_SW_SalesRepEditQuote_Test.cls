@isTest
public class OSM_SW_SalesRepEditQuote_Test {

            static testMethod void OSM_SW_SalesRepEditQuoteTriggerHandler1_Test(){
            List<ccrz__E_RequestForQuote__c> quoteList;
            
            //creating the test data
            TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
            TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
            //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);
            
            User usr = [Select id from User where Id = :UserInfo.getUserId()];
            System.RunAs(usr)
            { 
            List<ccrz__E_Product__c> eProductList=testCompletedTransactionSetUpRes1.objSetupDate.componentList;
            //List<ccrz__E_SubProdTerm__c> eSubProdTermList=testCompletedTransactionSetUpRes1.objSetupDate.subProdTermList;
                      
            //objRequestForQuote.CC_SubProdTerm__c = eSubProdTermList[0].Id;
            quoteList=new List<ccrz__E_RequestForQuote__c>();
            ccrz__E_RequestForQuote__c objRequestForQuote1 = new ccrz__E_RequestForQuote__c();
            objRequestForQuote1.Cost_Subscription__c = 2000;
            objRequestForQuote1.Status__c = 'Requested';
            objRequestForQuote1.CC_Product__c = eProductList[0].Id;
            objRequestForQuote1.Product_Plan__c = 'Base';
            objRequestForQuote1.Quantity__c = 2;
            //objRequestForQuote.Display_Product__c = eProductList[0].Id;
            objRequestForQuote1.ccrz__Amount__c = 500;
            objRequestForQuote1.ccrz__Storefront__c = 'SoftwareStore';
            objRequestForQuote1.ccrz__Description__c = 'Testing...';
            //objRequestForQuote1.Discounted_Price__c = 200;
            //objRequestForQuote1.Discounted_Percentage__c = 20;
            objRequestForQuote1.Final_Price__c = 200;
            //objRequestForQuote1.Status__c = 'Rejected';
            //objRequestForQuote1.Operation__c = 'Rejected';

            insert objRequestForQuote1;
            
            ccrz__E_RequestForQuote__c objRequestForQuote2 = new ccrz__E_RequestForQuote__c();
            objRequestForQuote2.Cost_Subscription__c = 2000;
            objRequestForQuote2.Status__c = 'Requested';
            objRequestForQuote2.Operation__c = 'Requested';
            objRequestForQuote2.CC_Product__c = eProductList[0].Id;
            objRequestForQuote2.Product_Plan__c = 'Base';
            objRequestForQuote2.Quantity__c = 2;
            //objRequestForQuote.Display_Product__c = eProductList[0].Id;
            objRequestForQuote2.ccrz__Amount__c = 500;
            objRequestForQuote2.ccrz__Storefront__c = 'SoftwareStore';
            objRequestForQuote2.ccrz__Description__c = 'Testing...';
            objRequestForQuote2.Discounted_Price__c = 400;
            //objRequestForQuote2.Discounted_Percentage__c = 40;
            objRequestForQuote2.Final_Price__c = 200;
            objRequestForQuote2.Sales_User_Comments__c='testing1';
            insert objRequestForQuote2;
            
            ccrz__E_RequestForQuote__c objRequestForQuote3 = new ccrz__E_RequestForQuote__c();
            objRequestForQuote3.Cost_Subscription__c = 2000;
            objRequestForQuote3.Status__c = 'Requested';
            objRequestForQuote3.Operation__c = 'Requested';
            objRequestForQuote3.CC_Product__c = eProductList[0].Id;
            objRequestForQuote3.Product_Plan__c = 'Base';
            objRequestForQuote3.Quantity__c = 2;
            //objRequestForQuote.Display_Product__c = eProductList[0].Id;
            objRequestForQuote3.ccrz__Amount__c = 500;
            objRequestForQuote3.ccrz__Storefront__c = 'SoftwareStore';
            objRequestForQuote3.ccrz__Description__c = 'Testing...';
            objRequestForQuote3.Discounted_Price__c = 50;
            //objRequestForQuote3.Discounted_Percentage__c = 50;
            objRequestForQuote3.Final_Price__c = 200;
            insert objRequestForQuote3;
            
            ccrz__E_RequestForQuote__c objRequestForQuote4 = new ccrz__E_RequestForQuote__c();
            objRequestForQuote4.Cost_Subscription__c = 2000;
            objRequestForQuote4.Status__c = 'Requested';
            objRequestForQuote4.Operation__c = 'Requested';
            objRequestForQuote4.CC_Product__c = eProductList[0].Id;
            objRequestForQuote4.Product_Plan__c = 'Base';
            objRequestForQuote4.Quantity__c = 2;
            //objRequestForQuote.Display_Product__c = eProductList[0].Id;
            objRequestForQuote4.ccrz__Amount__c = 500;
            objRequestForQuote4.ccrz__Storefront__c = 'SoftwareStore';
            objRequestForQuote4.ccrz__Description__c = 'Testing...';
            //objRequestForQuote4.Discounted_Price__c = 50;
            objRequestForQuote4.Discounted_Percentage__c = 50;
            objRequestForQuote4.Final_Price__c = 200;
            objRequestForQuote4.Sales_User_Comments__c='testing31';
            insert objRequestForQuote4;
            
            ccrz__E_RequestForQuote__c objRequestForQuote5 = new ccrz__E_RequestForQuote__c();
            objRequestForQuote5.Cost_Subscription__c = 2000;
            objRequestForQuote5.Status__c = 'Requested';
            objRequestForQuote5.Operation__c = 'Requested';
            objRequestForQuote5.CC_Product__c = eProductList[0].Id;
            objRequestForQuote5.Product_Plan__c = 'Base';
            objRequestForQuote5.Quantity__c = 2;
            //objRequestForQuote.Display_Product__c = eProductList[0].Id;
            objRequestForQuote5.ccrz__Amount__c = 500;
            objRequestForQuote5.ccrz__Storefront__c = 'SoftwareStore';
            objRequestForQuote5.ccrz__Description__c = 'Testing...';
            //objRequestForQuote5.Discounted_Price__c = 50;
            objRequestForQuote5.Discounted_Percentage__c = 50;
            objRequestForQuote5.Final_Price__c = 200;
            insert objRequestForQuote5;
            
             ccrz__E_RequestForQuote__c objRequestForQuote6 = new ccrz__E_RequestForQuote__c();
            objRequestForQuote6.Cost_Subscription__c = 2000;
            objRequestForQuote6.CC_Product__c = eProductList[0].Id;
            objRequestForQuote6.Product_Plan__c = 'Base';
            objRequestForQuote6.Quantity__c = 2;
            //objRequestForQuote.Display_Product__c = eProductList[0].Id;
            objRequestForQuote6.ccrz__Amount__c = 500;
            objRequestForQuote6.ccrz__Storefront__c = 'SoftwareStore';
            objRequestForQuote6.ccrz__Description__c = 'Testing...';
            objRequestForQuote6.Discounted_Price__c = 50;
            //objRequestForQuote6.Discounted_Percentage__c = 50;
            objRequestForQuote6.Final_Price__c = 200;
            insert objRequestForQuote6;




           

            quoteList.add(objRequestForQuote1);
            
            CC_Quote_Limit__c quoteLimit1=new CC_Quote_Limit__c();
            quoteLimit1.Discounted_Price__c=500;
            quoteLimit1.product__c=eProductList[0].Id;
            //quoteLimit1.Discounted_Percentage__c=5;
            insert quoteLimit1;
            
            CC_Quote_Limit__c quoteLimit2=new CC_Quote_Limit__c();
            quoteLimit2.Discounted_Price__c=500;
            //quoteLimit2.product__c=eProductList[0].Id;
            //quoteLimit2.Discounted_Percentage__c=5;
            insert quoteLimit2;
            
                test.startTest();
                //calling logic
                    List<ccrz__E_RequestForQuote__c> quote1=[select id,Quantity__c from ccrz__E_RequestForQuote__c where id=:objRequestForQuote1.id];
                    quote1[0].Status__c='In Progress';
                    quote1[0].Operation__c='Cancel';
                    quote1[0].Discounted_Percentage__c = 5;
                    //quote1[0].Discounted_Price__c = 300;
                    update quote1[0];
                    
                    
                    List<ccrz__E_RequestForQuote__c> quote2=[select id,Quantity__c from ccrz__E_RequestForQuote__c where id=:objRequestForQuote2.id];
                    quote2[0].Status__c='Accepted';
                    quote2[0].Operation__c='Accepted';
                    //quote2[0].Discounted_Percentage__c = 5;
                    //quote2[0].Discounted_Price__c = 300;
                    //quote2[0].Sales_User_Comments__c='testing2';
                    update quote2[0];
                    
                    List<ccrz__E_RequestForQuote__c> quote3=[select id,Quantity__c from ccrz__E_RequestForQuote__c where id=:objRequestForQuote3.id];
                    quote3[0].Status__c='Rejected';
                    quote3[0].Operation__c='Rejected';
                    //quote3[0].Discounted_Percentage__c = 5;
                    quote3[0].Discounted_Price__c = 300;

                    update quote3[0];
                    
                    List<ccrz__E_RequestForQuote__c> quote4=[select id,Quantity__c from ccrz__E_RequestForQuote__c where id=:objRequestForQuote4.id];
                    quote4[0].Status__c='InActive';
                    quote4[0].Operation__c='InActive';
                    //quote4[0].Sales_User_Comments__c='testing3';
                    update quote4[0];
                    
                    List<ccrz__E_RequestForQuote__c> quote5=[select id,Quantity__c from ccrz__E_RequestForQuote__c where id=:objRequestForQuote5.id];
                    quote5[0].Status__c='Expired';
                    quote5[0].Operation__c='Send';
                    //quote5[0].Discounted_Percentage__c = 5;
                    //quote5[0].Discounted_Price__c = 300;

                    update quote5[0];

                    List<ccrz__E_RequestForQuote__c> quote6=[select id,Quantity__c from ccrz__E_RequestForQuote__c where id=:objRequestForQuote6.id];
                    quote6[0].Status__c='In Progress';
                    quote6[0].Operation__c='Send';
                    //quote6[0].Discounted_Percentage__c = 5;
                    //quote6[0].Discounted_Price__c = 300;
                    update quote6[0]; 

                
                //covering after update method
                Map<id,ccrz__E_RequestForQuote__c> quoteMap=new Map<id,ccrz__E_RequestForQuote__c>();
                quoteMap.put(quote1[0].id,quote1[0]);
                
                //OSM_SW_SalesRepEditQuoteTriggerHandler.onAfterUpdate(quoteList,quoteMap);
                test.stopTest();
                
              }
            }  
        
 static testMethod void OSM_SW_SalesRepEditQuoteTriggerHandler1_Test1(){
            List<ccrz__E_RequestForQuote__c> quoteList;
            
            //creating the test data
            TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
            TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
            //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);
            
            User usr = [Select id from User where Id = :UserInfo.getUserId()];
            System.RunAs(usr)
            { 
            List<ccrz__E_Product__c> eProductList=testCompletedTransactionSetUpRes1.objSetupDate.componentList;
            //List<ccrz__E_SubProdTerm__c> eSubProdTermList=testCompletedTransactionSetUpRes1.objSetupDate.subProdTermList;
                      
            //objRequestForQuote.CC_SubProdTerm__c = eSubProdTermList[0].Id;
            
             ccrz__E_RequestForQuote__c objRequestForQuote6 = new ccrz__E_RequestForQuote__c();
            objRequestForQuote6.Cost_Subscription__c = 40;
            objRequestForQuote6.Status__c = 'Requested';
            objRequestForQuote6.CC_Product__c = eProductList[0].Id;
            objRequestForQuote6.Product_Plan__c = 'Base';
            objRequestForQuote6.Quantity__c = 1;
            //objRequestForQuote.Display_Product__c = eProductList[0].Id;
            objRequestForQuote6.ccrz__Amount__c = 40;
            objRequestForQuote6.ccrz__Storefront__c = 'SoftwareStore';
            objRequestForQuote6.ccrz__Description__c = 'Testing...';
            //objRequestForQuote6.Discounted_Price__c = 50;
            //objRequestForQuote6.Discounted_Percentage__c = 50;
            
            //objRequestForQuote6.Final_Price__c = 200;
            insert objRequestForQuote6;

                test.startTest();
                    
                    List<ccrz__E_RequestForQuote__c> quote6=[select id,Quantity__c from ccrz__E_RequestForQuote__c where id=:objRequestForQuote6.id];
                    //quote6[0].Status__c='In Progress';
                    //quote6[0].Operation__c='Send';
                    //quote6[0].Discounted_Percentage__c = 2;
                    quote6[0].Discounted_Price__c = 39.20;
                    update quote6[0]; 

                
                //covering after update method
                Map<id,ccrz__E_RequestForQuote__c> quoteMap=new Map<id,ccrz__E_RequestForQuote__c>();
                quoteMap.put(quote6[0].id,quote6[0]);
                
                //OSM_SW_SalesRepEditQuoteTriggerHandler.onAfterUpdate(quoteList,quoteMap);
                test.stopTest();
                
              }
            }   
  
  static testMethod void testCheckOneNotNull(){
            List<ccrz__E_RequestForQuote__c> quoteList;
            
            //creating the test data
            TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
            TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
            //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);
            
            List<ccrz__E_Product__c> eProductList=testCompletedTransactionSetUpRes1.objSetupDate.componentList;
            //List<ccrz__E_SubProdTerm__c> eSubProdTermList=testCompletedTransactionSetUpRes1.objSetupDate.subProdTermList;
                      
            //objRequestForQuote.CC_SubProdTerm__c = eSubProdTermList[0].Id;
            
             ccrz__E_RequestForQuote__c objRequestForQuote6 = new ccrz__E_RequestForQuote__c();
            objRequestForQuote6.Cost_Subscription__c = 40;
            objRequestForQuote6.Status__c = 'Requested';
            objRequestForQuote6.CC_Product__c = eProductList[0].Id;
            objRequestForQuote6.Product_Plan__c = 'Base';
            objRequestForQuote6.Quantity__c = 1;
            //objRequestForQuote.Display_Product__c = eProductList[0].Id;
            objRequestForQuote6.ccrz__Amount__c = 40;
            objRequestForQuote6.ccrz__Storefront__c = 'SoftwareStore';
            objRequestForQuote6.ccrz__Description__c = 'Testing...';
            //objRequestForQuote6.Discounted_Price__c = 50;
            //objRequestForQuote6.Discounted_Percentage__c = 50;
            
            //objRequestForQuote6.Final_Price__c = 200;
            insert objRequestForQuote6;

                test.startTest();
                    
                    List<ccrz__E_RequestForQuote__c> quote6=[select id,Quantity__c from ccrz__E_RequestForQuote__c where id=:objRequestForQuote6.id];
                    //quote6[0].Status__c='In Progress';
                    //quote6[0].Operation__c='Send';
                    quote6[0].Discounted_Percentage__c = 2;
                    //quote6[0].Discounted_Price__c = 39.20;
                    update quote6[0]; 
                     try{
              OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET = true;
         OSM_SW_General_Util.USER_TYPE = Label.OSM_Sales_Admin_UserType;
               quote6[0].Discounted_Percentage__c = 10;
               update quote6[0]; 
          }Catch(Exception ex){
              
          }
      
         try{
              OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET = true;
         OSM_SW_General_Util.USER_TYPE = Label.OSM_Sales_Admin_UserType;
               quote6[0].Discounted_Price__c = 10;
               update quote6[0]; 
          }Catch(Exception ex){
              
          }
                  test.stopTest();
                
             }   
    
      static testMethod void testCheckBothNull(){
            List<ccrz__E_RequestForQuote__c> quoteList;
            
            //creating the test data
            TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
            TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
            //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);
            
            List<ccrz__E_Product__c> eProductList=testCompletedTransactionSetUpRes1.objSetupDate.componentList;
            //List<ccrz__E_SubProdTerm__c> eSubProdTermList=testCompletedTransactionSetUpRes1.objSetupDate.subProdTermList;
                      
            //objRequestForQuote.CC_SubProdTerm__c = eSubProdTermList[0].Id;
            
             ccrz__E_RequestForQuote__c objRequestForQuote6 = new ccrz__E_RequestForQuote__c();
            objRequestForQuote6.Cost_Subscription__c = 40;
            objRequestForQuote6.Status__c = 'Requested';
            objRequestForQuote6.CC_Product__c = eProductList[0].Id;
            objRequestForQuote6.Product_Plan__c = 'Base';
            objRequestForQuote6.Quantity__c = 1;
            //objRequestForQuote.Display_Product__c = eProductList[0].Id;
            objRequestForQuote6.ccrz__Amount__c = 40;
            objRequestForQuote6.ccrz__Storefront__c = 'SoftwareStore';
            objRequestForQuote6.ccrz__Description__c = 'Testing...';
            //objRequestForQuote6.Discounted_Price__c = 50;
            //objRequestForQuote6.Discounted_Percentage__c = 50;
            
            //objRequestForQuote6.Final_Price__c = 200;
            insert objRequestForQuote6;

                test.startTest();
                    
                    List<ccrz__E_RequestForQuote__c> quote6=[select id,Quantity__c from ccrz__E_RequestForQuote__c where id=:objRequestForQuote6.id];
                    //quote6[0].Status__c='In Progress';
                    //quote6[0].Operation__c='Send';
                    quote6[0].Discounted_Percentage__c = 10;
                    quote6[0].Discounted_Price__c = 11;
          try{
                    update quote6[0]; 
          }catch(Exception ex){
              
          }
                 
          try{
              OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET = true;
         OSM_SW_General_Util.USER_TYPE = Label.OSM_Sales_Admin_UserType;
               quote6[0].Discounted_Percentage__c = 10;
               update quote6[0]; 
          }Catch(Exception ex){
              
          }
                test.stopTest();
                
             }
    
       static testMethod void testCheckChange(){
            List<ccrz__E_RequestForQuote__c> quoteList;
            
            //creating the test data
            TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
            TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
            //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);
            
            List<ccrz__E_Product__c> eProductList=testCompletedTransactionSetUpRes1.objSetupDate.componentList;
            //List<ccrz__E_SubProdTerm__c> eSubProdTermList=testCompletedTransactionSetUpRes1.objSetupDate.subProdTermList;
                      
            //objRequestForQuote.CC_SubProdTerm__c = eSubProdTermList[0].Id;
            
             ccrz__E_RequestForQuote__c objRequestForQuote6 = new ccrz__E_RequestForQuote__c();
            objRequestForQuote6.Cost_Subscription__c = 40;
            objRequestForQuote6.Status__c = 'Requested';
            objRequestForQuote6.CC_Product__c = eProductList[0].Id;
            objRequestForQuote6.Product_Plan__c = 'Base';
            objRequestForQuote6.Quantity__c = 1;
            //objRequestForQuote.Display_Product__c = eProductList[0].Id;
            objRequestForQuote6.ccrz__Amount__c = 40;
            objRequestForQuote6.ccrz__Storefront__c = 'SoftwareStore';
            objRequestForQuote6.ccrz__Description__c = 'Testing...';
            //objRequestForQuote6.Discounted_Price__c = 50;
            //objRequestForQuote6.Discounted_Percentage__c = 50;
            
            //objRequestForQuote6.Final_Price__c = 200;
            insert objRequestForQuote6;

                test.startTest();
                    
                    List<ccrz__E_RequestForQuote__c> quote6=[select id,Quantity__c from ccrz__E_RequestForQuote__c where id=:objRequestForQuote6.id];
                    //quote6[0].Status__c='In Progress';
                    //quote6[0].Operation__c='Send';
                    quote6[0].Discounted_Percentage__c = null;
                    quote6[0].Discounted_Price__c = null;
          try{
                    update quote6[0]; 
          }catch(Exception ex){
              
          }
              test.stopTest();
                
             }
    
     static testMethod void testCheckChangeAdmin(){
         OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET = true;
         OSM_SW_General_Util.USER_TYPE = Label.OSM_Sales_Admin_UserType;
            List<ccrz__E_RequestForQuote__c> quoteList;
            
            //creating the test data
            TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
            TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
            //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);
            
            List<ccrz__E_Product__c> eProductList=testCompletedTransactionSetUpRes1.objSetupDate.componentList;
            //List<ccrz__E_SubProdTerm__c> eSubProdTermList=testCompletedTransactionSetUpRes1.objSetupDate.subProdTermList;
                      
            //objRequestForQuote.CC_SubProdTerm__c = eSubProdTermList[0].Id;
            
             ccrz__E_RequestForQuote__c objRequestForQuote6 = new ccrz__E_RequestForQuote__c();
            objRequestForQuote6.Cost_Subscription__c = 40;
            objRequestForQuote6.Status__c = 'Requested';
            objRequestForQuote6.CC_Product__c = eProductList[0].Id;
            objRequestForQuote6.Product_Plan__c = 'Base';
            objRequestForQuote6.Quantity__c = 1;
            //objRequestForQuote.Display_Product__c = eProductList[0].Id;
            objRequestForQuote6.ccrz__Amount__c = 40;
            objRequestForQuote6.ccrz__Storefront__c = 'SoftwareStore';
            objRequestForQuote6.ccrz__Description__c = 'Testing...';
            //objRequestForQuote6.Discounted_Price__c = 50;
            //objRequestForQuote6.Discounted_Percentage__c = 50;
            
            //objRequestForQuote6.Final_Price__c = 200;
            insert objRequestForQuote6;

                test.startTest();
                    
                    List<ccrz__E_RequestForQuote__c> quote6=[select id,Quantity__c from ccrz__E_RequestForQuote__c where id=:objRequestForQuote6.id];
                    //quote6[0].Status__c='In Progress';
                    //quote6[0].Operation__c='Send';
                    quote6[0].Discounted_Percentage__c = 12;
                    //quote6[0].Discounted_Price__c = null;
          try{
                    update quote6[0]; 
              
              quote6[0].Operation__c='Send';
              quote6[0].Status__c = label.InprogressQuoteRfq;
              update quote6[0]; 
              
               quote6[0].Discounted_Percentage__c = 12;
         quote6[0].Status__c = label.InActiveQuoteRfq;
         update quote6[0];
         
         quote6[0].Status__c = label.AcceptedQuoteRfq;
         update quote6[0];
         
              quote6[0].Discounted_Percentage__c = null;
         update quote6[0];
              
          }catch(Exception ex){}
        
              test.stopTest();
                
             }
             
              static testMethod void testCheckChangeAdmin1(){
         OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET = true;
         OSM_SW_General_Util.USER_TYPE = Label.OSM_Sales_Admin_UserType;
            List<ccrz__E_RequestForQuote__c> quoteList;
            
            //creating the test data
            TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
            TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
            //TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);
            
            List<ccrz__E_Product__c> eProductList=testCompletedTransactionSetUpRes1.objSetupDate.componentList;
            //List<ccrz__E_SubProdTerm__c> eSubProdTermList=testCompletedTransactionSetUpRes1.objSetupDate.subProdTermList;
                      
            //objRequestForQuote.CC_SubProdTerm__c = eSubProdTermList[0].Id;
            
             ccrz__E_RequestForQuote__c objRequestForQuote6 = new ccrz__E_RequestForQuote__c();
            objRequestForQuote6.Cost_Subscription__c = 40;
            objRequestForQuote6.Status__c = 'Requested';
            objRequestForQuote6.CC_Product__c = eProductList[0].Id;
            objRequestForQuote6.Product_Plan__c = 'Base';
            objRequestForQuote6.Quantity__c = 1;
            //objRequestForQuote.Display_Product__c = eProductList[0].Id;
            objRequestForQuote6.ccrz__Amount__c = 40;
            objRequestForQuote6.ccrz__Storefront__c = 'SoftwareStore';
            objRequestForQuote6.ccrz__Description__c = 'Testing...';
            //objRequestForQuote6.Discounted_Price__c = 50;
            //objRequestForQuote6.Discounted_Percentage__c = 50;
            
            //objRequestForQuote6.Final_Price__c = 200;
            insert objRequestForQuote6;

                test.startTest();
                    
                    List<ccrz__E_RequestForQuote__c> quote6=[select id,Quantity__c from ccrz__E_RequestForQuote__c where id=:objRequestForQuote6.id];
                    //quote6[0].Status__c='In Progress';
                    //quote6[0].Operation__c='Send';
                    quote6[0].Discounted_Percentage__c = 12;
                    //quote6[0].Discounted_Price__c = null;
          try{
                    update quote6[0]; 
              
              quote6[0].Operation__c='Send';
              quote6[0].Status__c = label.InprogressQuoteRfq;
              update quote6[0]; 
              
               quote6[0].Discounted_Percentage__c = 12;
         quote6[0].Status__c = label.InprogressQuoteRfq;
         update quote6[0];
         
         quote6[0].Status__c = label.SentQuoteRfq;
         update quote6[0];
         
              quote6[0].Discounted_Percentage__c = null;
         update quote6[0];
              
          }catch(Exception ex){}
        
              test.stopTest();
                
             }
}