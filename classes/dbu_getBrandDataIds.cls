public without sharing class dbu_getBrandDataIds {
	
	@AuraEnabled
    public static string getBrandId(string BrandName){
        
        system.debug('BrandName > ' + BrandName);
        string IdtoReturn;
        if(BrandName != null && BrandName != '' && BrandName != 'undefined'){
        	Brands__c currentBrandData = [select id from Brands__c where Name =: BrandName];
            system.debug('currentBrandData > ' + currentBrandData);
            IdtoReturn = currentBrandData.id;
            system.debug('IdtoReturn > ' + IdtoReturn);
        }
         
        
        return IdtoReturn;
    }
}