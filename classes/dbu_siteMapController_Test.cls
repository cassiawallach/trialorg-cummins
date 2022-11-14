@isTest
public class dbu_siteMapController_Test 
{
    static testMethod void testhomePageCategoryTileCtrl()
    {
        String countryca = 'CA';
        String countryus = 'US';
        Test.startTest();  
			dbu_siteMapController.fetchSitMmapPageSubCategoryDetails(countryca);
        	dbu_siteMapController.fetchSitMmapPageSubCategoryDetails(countryus);
        Test.stopTest(); 
    }

}