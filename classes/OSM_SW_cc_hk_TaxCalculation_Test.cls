@istest
public class OSM_SW_cc_hk_TaxCalculation_Test{
static testMethod void testMethid(){

TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
                                transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        
        System.debug('transecRes: '+transecRes);

OSM_SW_Addresses.Address addres = new OSM_SW_Addresses.Address ();
OSM_SW_Addresses ad = new OSM_SW_Addresses(); 
addres.address1 = 'address1';
addres.address2 = 'address2';
addres.city = 'city';
addres.state = 'US';
addres.country = 'India';
addres.postalCode = '4343343';

ad.billingAddress =addres;
ad.shippingAddress = addres;
ccrz.cc_bean_MockContactAddress cd = new ccrz.cc_bean_MockContactAddress();
ccrz.cc_hk_TaxCalculation vv = new ccrz.cc_hk_TaxCalculation();
Map<String,object> abc = new Map<String,object>();
abc.put(ccrz.cc_hk_TaxCalculation.PARAM_SHIPADDR,cd);
abc.put(transecRes.cart.id,cd);
OSM_SW_cc_hk_TaxCalculation bh = new OSM_SW_cc_hk_TaxCalculation();
//vv.PARAM_CARTID = transecRes.cart.id;
try{
bh.getTaxAmount(abc); 
}catch(Exception e){}
}
}