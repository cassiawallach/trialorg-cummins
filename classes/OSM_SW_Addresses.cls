public class OSM_SW_Addresses {

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

    
    public static OSM_SW_Addresses parse(String json) {
        return (OSM_SW_Addresses) System.JSON.deserialize(json, OSM_SW_Addresses.class);
    }
}