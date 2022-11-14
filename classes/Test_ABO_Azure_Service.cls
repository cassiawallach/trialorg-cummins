@istest
public class Test_ABO_Azure_Service
{
    static testmethod void Test_ABO_Azure_Service()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpAzure_Service());
        ABO_Azure_Service az = new ABO_Azure_Service();
        az.getCountries();
        az.getStates('India');
        az.getDistricts('India','Andhra Pradesh');
        az.getCity('India','Andhra Pradesh','Guntur');
    }
}