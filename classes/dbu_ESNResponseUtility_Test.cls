@isTest
public class dbu_ESNResponseUtility_Test 
{
    public static testMethod void getPaypalPayment(){
          
        String jsosns = '[{"Name":"test"}]';
        Test.startTest();
        dbu_ESNResponseUtility.SaveESNSearchResponse(jsosns,'SFD4B66RDCGXD7211');
        dbu_ESNResponseUtility.SaveESNSearchResponse('{"Name":"test"}','SFD4B66RDCGXD7200');
        dbu_ESNResponseUtility.SaveSearchResponse('Test345','serachParam','US','UserIp');
        Test.stopTest();
    }
}
//UAT Deployment