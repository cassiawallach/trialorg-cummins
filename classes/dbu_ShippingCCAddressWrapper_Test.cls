@isTest
public class dbu_ShippingCCAddressWrapper_Test {
    public static testMethod void testShippingItem() {
        dbu_ShippingCCAddressWrapper shippingData = new dbu_ShippingCCAddressWrapper();
        shippingData.firstName = 'test name';
                        shippingData.lastName = 'test lastname';
                        shippingData.dbuDefaultAddress = true;
                        shippingData.addressFirstline = 'add1';
                        shippingData.addressSecondline='add2';
                        shippingData.city='new york city';
                        shippingData.state='ny';
                        shippingData.postalCode='12345';
                        shippingData.country='U.S.A';
                        shippingData.shippingComments = 'Shipping Comments';
                        shippingData.sfid ='';
                        shippingData.companyName = '';
                        shippingData.email='';
                        shippingData.homePhone='';
    }

}