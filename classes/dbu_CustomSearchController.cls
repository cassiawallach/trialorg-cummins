public with sharing class dbu_CustomSearchController {
    /**
     * Author : Mounika T 
     * Created on 7th July 2020
     * Description : This class will do all the product related custom search operation
     */
    public dbu_CustomSearchController() {}
     @AuraEnabled(cacheable=true)
     public static list<ccrz__E_Product__c> getProductList(string searchKey) {
        // create product list to store search result 
        list<ccrz__E_Product__c> lstproduct = new list<ccrz__E_Product__c>();
        try{
            string sTempSearchKey = '%' + searchKey + '%';
            // query profuct records
            for(ccrz__E_Product__c prod : [select id, name,Group_Name__c, dbu_Image_Src__c, ccrz__AverageRating__c,ccrz__Quantityperunit__c
            ,(select id,ccrz__Price__c from ccrz__E_PriceListItems__r)From ccrz__E_Product__c
                                 WHERE Group_Name__c='Ecom' And name LIKE : sTempSearchKey limit 10]){
                lstproduct.add(prod);
            }
            //If there are no records found with searchKey then, throw aura exception with a message
            if(lstproduct.size() == 0){
                throw new AuraHandledException('No Record Found..'); 
            }
        }catch (Exception ex){
            System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
        }
        return lstproduct;
    }

}