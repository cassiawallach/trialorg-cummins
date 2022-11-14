@isTest
public with sharing class dbu_availCurrentPromotions_Test {
    
    @isTest
    static void getAllPromotionProductsTest(){
        String urlm = 'USD';
        Test.startTest();
        dbu_availCurrentPromotions.getAllPromotionProducts(urlm);
        Test.stopTest();

        
    }
}