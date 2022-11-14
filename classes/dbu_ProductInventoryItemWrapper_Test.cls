@isTest
public class dbu_ProductInventoryItemWrapper_Test {
    public static testMethod void testProdInvItem() {
        dbu_ProductInventoryItemWrapper prodInv = new dbu_ProductInventoryItemWrapper();
        prodInv.sfdcCurrencyISOCode = '';
        prodInv.availabilityMessage = '';
        prodInv.lowStock = false;
        prodInv.notifyStock=true;
        prodInv.productItem='';
        prodInv.qtyAvailable=1;
        prodInv.sfdcName = '';
        prodInv.status = '';
        system.debug('entering the test class method');
        
    }
}