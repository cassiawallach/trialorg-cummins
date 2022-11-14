@IsTest
public class dbu_ESNValidationResponse_Test {


    
    static testMethod void testParse() {
        
        dbu_ESNValidationResponse obj = dbu_ESNValidationResponse.parse('{"compatible":true}');
        System.assert(obj != null);
    }

}