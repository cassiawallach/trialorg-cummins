@isTest
public class CG_ANVL_ResWrapper_Test {
    static testMethod void CG_ANVL_ResWrapperMethod(){
        string Json ='{"id":"12","timestamp":"2018-05-10T10:25:22.210Z","anvlId":"deef-feed-feeb-1234","updatedAt":"2018-06-24T09:15:21.100Z"}';  
        
        CG_ANVL_ResWrapper obj1= CG_ANVL_ResWrapper.parse(Json);
        System.assert(obj1!= null);
    }
}