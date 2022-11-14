@isTest
public class dbu_orderBillingAddress_Test {
    static testMethod void billingAddress(){
        dbu_orderBillingAddress wrapperData = new dbu_orderBillingAddress();
        wrapperData.addressFirstline = 'charles street';
        wrapperData.addressSecondline = '';
        wrapperData.city = 'SR city';
        wrapperData.country = 'Canada';
        wrapperData.email='test@hor.com';
        wrapperData.firstName='james';
        wrapperData.homePhone='12345';
        wrapperData.lastName='cook';
        wrapperData.sfdcName='';
    }
}