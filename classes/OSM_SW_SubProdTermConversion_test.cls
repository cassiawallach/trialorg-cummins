@isTest
Public class OSM_SW_SubProdTermConversion_test{
 static testMethod void tetsMethod1(){
 
 test.StartTest();
 OSM_SW_SubProdTermConversion cont = new OSM_SW_SubProdTermConversion();
 cont.multiplier ('Weekly');
 decimal d1 = OSM_SW_SubProdTermConversion.getMultilier('Monthly','OneTime');
 decimal d2 = OSM_SW_SubProdTermConversion.getRFQMultilier('Monthly','OneTime');
 decimal d3 =  OSM_SW_SubProdTermConversion.calculatePriceForSelectedSubs(12.0,'OneTime');
 
 Test.stopTest();
 
 }
}