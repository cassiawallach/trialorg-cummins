@isTest
public class dbu_CustomException_Test {
    
    @isTest public static void testCustomException(){
        Test.startTest();
        dbu_CustomException exceptionObj = new dbu_CustomException();
        exceptionObj.getMessgageForTest('hello');
        Test.stopTest();
    }
}