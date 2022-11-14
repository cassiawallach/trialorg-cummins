@isTest
public class dbu_billingCCAddressWrapper_Test {
    public static testMethod void testBillingItem() {
        dbu_billingCCAddressWrapper billingData = new dbu_billingCCAddressWrapper();
        billingData.firstName = 'test name';
        billingData.lastName = 'test lastname';
        billingData.dbuDefaultAddress = true;
        billingData.addressFirstline = 'add1';
        billingData.addressSecondline='add2';
        billingData.city='new york city';
        billingData.state='ny';
        billingData.postalCode='12345';
        billingData.country='U.S.A';
        billingData.billingComments = 'Shipping Comments';
        billingData.sfid ='';
        billingData.companyName = '';
        billingData.email='';
        billingData.homePhone='';
    }
    
}