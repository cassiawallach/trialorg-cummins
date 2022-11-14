@IsTest
public class Test_ABO_OTPService
{
    static testmethod void testSendMail()
    {
        ABO_OTPGeneration otpgen = new ABO_OTPGeneration();
        //otpgen.web_generateOTP('vamsi2002@gmail.com');
    }
    static testmethod void testSendSMS(){
        ABO_SeibelWebservice.SendSMS('1234567890','Your Validation Code is 123456');
        Test.setMock(WebServiceMock.class, new SMSWebServiceMockImpl());
    }
}