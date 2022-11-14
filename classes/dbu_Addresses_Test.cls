@isTest
public class dbu_Addresses_Test {
        public static testMethod void testAddress() {
            dbu_Addresses.Address dataAddress= new dbu_Addresses.Address();
            dataAddress.address1 = 'charles street';
            dataAddress.address1 = 'third lane';
            dataAddress.address3 = '';
            dataAddress.city = 'Tiago';
            dataAddress.country = 'Unites States Of America';
            dataAddress.postalCode = '12345';
            dataAddress.state='New York';
            
		dbu_Addresses addressData = new  dbu_Addresses();
            addressData.billingAddress= dataAddress;
            addressData.errorMsgOfAddressCleane='';
            addressData.shippingAddress= dataAddress;
            addressData.isAddressCleanFail = false;
            string json = JSON.serialize(addressData);
            
            Test.startTest();
            dbu_Addresses.parse(json);
            Test.stopTest();
        }
}