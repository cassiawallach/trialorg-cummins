@isTest
public class CG_PartsOptionsUpdateBatch_Test{
    static testMethod void CSS_GetMakeModelBatch_Test() {
        List<CSS_Parts_Options__c> paList = new List<CSS_Parts_Options__c>();
        
          Id partrecordTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName()
                  .get('Parts').getRecordTypeId();
        
          css_claims__c claims1= new css_claims__C();
            claims1.Customer_Code__c='123';
            claims1.Customer_Name__c='TestUser';
        insert claims1;
        
        CSS_Parts_Options__c paOne = new CSS_Parts_Options__c();
        //paOne.Exchange_Rate__c = 1;
        paOne.Unit_Price_Local_Currency__c = 23 ;
        paOne.Sell_Price__c = 2;
        paOne.Amount_Local_Currency__c = 21 ;
        paOne.Amount__c = 29;
        paOne.Exchange_Rate_Version__c = 6;
        paOne.Currency_Type__c = 'USD';
        paOne.Unit_Price__c = '2';
        paOne.ExpenseTotal__c = 5;
        paOne.RecordTypeId = partrecordTypeId;
        paOne.CSS_Claims__c = claims1.Id;
        
        paList.add(paOne);
        
           CSS_Parts_Options__c paThree = new CSS_Parts_Options__c();
        //paOne.Exchange_Rate__c = 1;
        paThree.Unit_Price_Local_Currency__c = 23 ;
        paThree.Sell_Price__c = 2;
        paThree.Amount_Local_Currency__c = 21 ;
        paThree.Amount__c = 29;
        paThree.Exchange_Rate_Version__c = 6;
        paThree.Currency_Type__c = 'USD';
        paThree.Unit_Price__c = '2';
        paThree.ExpenseTotal__c = 5;
        paThree.RecordTypeId = partrecordTypeId;
        //paOne.CSS_Claims__c = claims1.Id;
        paList.add(paThree);
        Id otherClaimsrecordTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName()
                  .get('OtherClaimables').getRecordTypeId();
        
        CSS_Parts_Options__c paTwo = new CSS_Parts_Options__c();
        //paTwo.Exchange_Rate__c = 1;
        paTwo.Unit_Price_Local_Currency__c = 23 ;
        paTwo.Sell_Price__c = 2;
        paTwo.Amount_Local_Currency__c = 21 ;
        paTwo.Amount__c = 29;
        paTwo.Exchange_Rate_Version__c = 6;
        paTwo.Currency_Type__c = 'USD';
        paTwo.Unit_Price__c = '2';
        paTwo.ExpenseTotal__c = 5;
        paTwo.RecordTypeId = otherClaimsrecordTypeId;
         paTwo.CSS_Claims__c = claims1.Id;
        paList.add(paTwo);
        
        CSS_Parts_Options__c paFour = new CSS_Parts_Options__c();
        //paTwo.Exchange_Rate__c = 1;
        paFour.Unit_Price_Local_Currency__c = 23 ;
        paFour.Sell_Price__c = 2;
        paFour.Amount_Local_Currency__c = 21 ;
        paFour.Amount__c = 29;
        paFour.Exchange_Rate_Version__c = 6;
        paFour.Currency_Type__c = 'USD';
        paFour.Unit_Price__c = '2';
        paFour.ExpenseTotal__c = 5;
        paFour.RecordTypeId = otherClaimsrecordTypeId;
         //paTwo.CSS_Claims__c = claims1.Id;
        paList.add(paFour);
        
        Id ttMLrecordTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName()
                  .get('TTML').getRecordTypeId();
                  
         CSS_Parts_Options__c paFive = new CSS_Parts_Options__c();
       // paThree.Exchange_Rate__c = 1;
        paFive.Unit_Price_Local_Currency__c = 23 ;
        paFive.Sell_Price__c = 2;
        paFive.Amount_Local_Currency__c = 21 ;
        paFive.Amount__c = 29;
        paFive.Exchange_Rate_Version__c = 6;
        paFive.Currency_Type__c = 'USD';
        paFive.Unit_Price__c = '2';
        paFive.ExpenseTotal__c = 5;
        paFive.RecordTypeId = ttMLrecordTypeId ;
        paFive.CSS_Claims__c  = claims1.Id;
        paList.add(paFive);  
        
        insert paList;
        
        Test.startTest();
        CG_PartsOptionsUpdateBatch obj = new CG_PartsOptionsUpdateBatch();
        Database.executeBatch(obj);
        Test.stopTest();       
                  
        
     }
 }