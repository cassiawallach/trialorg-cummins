@isTest

private class IAM_AuthenticationMessageTest{
    @isTest
    static void testmethod01(){
    string jsonstring = '{"id":"01t4B000000XrvhQAC","name":"abc123","DateRange":{"startDate":"2020-02-17","endDate":"2020-02-26"}}';
    IAM_AuthenticationMessage message = new IAM_AuthenticationMessage();
    IAM_AuthenticationMessage.parse(jsonstring);
    
    }

}