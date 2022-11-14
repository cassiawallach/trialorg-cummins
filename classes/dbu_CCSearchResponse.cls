public class dbu_CCSearchResponse {
	@AuraEnabled public List<dbu_CCAPISearchResponseWrapper> products;
    @AuraEnabled public List<String> Categories;
    @AuraEnabled public List<String> Brands;
    @AuraEnabled public Boolean isIdSearch;
    @AuraEnabled public dbu_CCVINProductInformation VINProductInfo;//Lahari change
    
    public dbu_CCSearchResponse(){//Lahari testclasschange
        
    }
}