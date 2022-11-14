@isTest
public class IAM_CST_Authentication_Test
{
@Istest
    static void test1()
    { 
      
        
        
         Test.startTest(); 
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         IAM_CST_Authentication.getBearer('IAM_CST_User');
         Test.stopTest();
         
         
    }
}