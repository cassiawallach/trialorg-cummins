/**
 * @description       : Wrapper class for Address prediction.
 * @author            : Devaraj johnson B
 * @group             : 
 * @last modified on  : 05-05-2022
 * @last modified by  : Devaraj johnson B
**/
public class dbu_Addresses {

    public class Address {
        public String address1;
        public String address2;
        public String address3;
        public String city;
        public String state;
        public String country;
        public String postalCode;
    }

    public Address billingAddress;
    public Address shippingAddress;
    public boolean isAddressCleanFail;
    public String errorMsgOfAddressCleane;

    
    public static dbu_Addresses parse(String json) {
        return (dbu_Addresses) System.JSON.deserialize(json, dbu_Addresses.class);
    }
}