@isTest
public class OSM_SW_Addresses_Test{    
    static testmethod void testParse(){
             String json ='{"address1":"test","address2":"test","city":"Delhi","state":"Delhi","country":"India","postalCode":"110092"}';     
        OSM_SW_Addresses obj = OSM_SW_Addresses.parse(json);
         System.assert(obj != null);
    }
}