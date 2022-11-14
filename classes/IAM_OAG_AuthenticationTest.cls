@isTest
public class IAM_OAG_AuthenticationTest
{
@Istest
    static void test1()
    { 
        String name = 'IAM_LDAP_oAuth';
        String appName = 'IAM_LDAP_oAuth';
        Boolean isActive = true;
        String endpoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/ldaputil';
        String key = 'thAQWe/AIgUevs8IGTdk4Ddx50z3F9xiqm2Hl/QMu/MuVcRJFcWzFgYxxXvpN2LZEs43hkxTJ3t67B0nx7a1qg==';
        String username = 'Z7xm9X6ImVl6ND7zTJ2j/jScb740y2NP/TOoSV9vC+U=';
        String passcode = 'Il3eUr1gk32ejCbujtRoFDgyeVhp+MdwlVe5n/L2Tlk3uQejsj9shK0YOC5Dy/k5HFxa4Ac6EexF+dRmHCEl8Q==';
        String authEnv = 'OAGoAuth';
        String logging = 'LDAPUtil';
        String methodType = 'POST';
        Integer timeout = 120000;
        String grantType='Yes';
        
        IAM_TestData.createCSSIntegrationDetails(name,  appName,  authEnv,  endpoint, 
         grantType,  isActive,  key,  logging,  methodType,  passcode, timeout,  username);
         Test.startTest(); 
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         IAM_OAG_Authentication.getBearer(appName);
         Test.stopTest();
         IAM_RandomNumber.getRandom();
         
    }
    
@Istest
    static void test2()
    { 
        String name = 'IAM_LDAP_oAuth';
        String appName = 'IAM_LDAP_oAuth';
        Boolean isActive = true;
        String endpoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/ldaputil';
        String key = 'thAQWe/AIgUevs8IGTdk4Ddx50z3F9xiqm2Hl/QMu/MuVcRJFcWzFgYxxXvpN2LZEs43hkxTJ3t67B0nx7a1qg==';
        String username = 'Z7xm9X6ImVl6ND7zTJ2j/jScb740y2NP/TOoSV9vC+U=';
        String passcode = 'Il3eUr1gk32ejCbujtRoFDgyeVhp+MdwlVe5n/L2Tlk3uQejsj9shK0YOC5Dy/k5HFxa4Ac6EexF+dRmHCEl8Q==';
        String authEnv = 'OAGoAuth';
        String logging = 'LDAPUtil';
        String methodType = 'POST';
        Integer timeout = 120000;
        String grantType='Yes';
        
        IAM_TestData.createCSSIntegrationDetails(name,  appName,  authEnv,  endpoint, 
         grantType,  isActive,  key,  logging,  methodType,  passcode, timeout,  username);
         
         Test.startTest();        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         IAM_OAG_LDAP_Authentication.getToken();
         Test.stopTest();
     }
     
     @Istest
    static void test3()
    { 
        String name = 'IAM_LDAP_oAuth';
        String appName = 'IAM_LDAP_oAuth';
        Boolean isActive = true;
        String endpoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/ldaputil';
        String key = 'thAQWe/AIgUevs8IGTdk4Ddx50z3F9xiqm2Hl/QMu/MuVcRJFcWzFgYxxXvpN2LZEs43hkxTJ3t67B0nx7a1qg==';
        String username = 'Z7xm9X6ImVl6ND7zTJ2j/jScb740y2NP/TOoSV9vC+U=';
        String passcode = 'Il3eUr1gk32ejCbujtRoFDgyeVhp+MdwlVe5n/L2Tlk3uQejsj9shK0YOC5Dy/k5HFxa4Ac6EexF+dRmHCEl8Q==';
        String authEnv = 'OAGoAuth';
        String logging = 'LDAPUtil';
        String methodType = 'POST';
        Integer timeout = 120000;
        String grantType='Yes';
        
        IAM_TestData.createCSSIntegrationDetails(name,  appName,  authEnv,  endpoint, 
         grantType,  isActive,  key,  logging,  methodType,  passcode, timeout,  username);
         
         String userName1='uname';
         String password='password';
         Test.startTest();        
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         IAM_Reclaim_LDAP_CallOut.authentication(userName1,password);
         Test.stopTest();
         
         
    }
    
   @Istest
    static void test4()
    { 
    String un='username';
    String pw='password';
    String domain='cs3';
    Test.startTest();        
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    IAM_SOAP_Logout.sendLoginRequest(un,pw,domain);
    Test.stopTest();
    }
}