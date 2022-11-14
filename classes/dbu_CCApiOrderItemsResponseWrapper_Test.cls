/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-22-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public  class dbu_CCApiOrderItemsResponseWrapper_Test {
    public static testMethod void testAddress() {
    dbu_CCApiOrderItemsResponseWrapper ccAPIOrderItem = new dbu_CCApiOrderItemsResponseWrapper();
    List<dbu_ProductMediaWrapper> lisProdWrp = new List<dbu_ProductMediaWrapper>();
    ccAPIOrderItem.EProductMediasS =lisProdWrp;
    }
}