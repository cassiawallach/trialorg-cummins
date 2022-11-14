@IsTest
public class IAM_CSS_J2AToken_SRT_Test{

static testMethod void testParse() {
    
    IAM_accesToken at=new IAM_accesToken();
    at.access_token='asdf';
    at.token_type='type';
    at.expires_in=20;
  at.refresh_token='yes';
  at.scope='yes';
  String myJSON = JSON.serialize(at);
    IAM_CSS_J2AToken_SRT.parse(myJSON);  
    
 }  
}