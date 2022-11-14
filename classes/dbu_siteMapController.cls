public class dbu_siteMapController 
{
    public class subCategoryWrapper
    {
        public subCategoryWrapper(){}
        @AuraEnabled public List<ccrz__E_Category__c> subCategoryList;   
    }
    @AuraEnabled(cacheable=true)  
    public static subCategoryWrapper fetchSitMmapPageSubCategoryDetails(String country)
    { 
        System.debug('country>>> ' + country);
        
        List<ccrz__E_Category__c> ccrzECategoryList = new List<ccrz__E_Category__c>();
        Set<ID> setSubCategoryID = new Set<ID>();
        List<ccrz__E_Category__c> ccrzECategorySubCategoryList = new List<ccrz__E_Category__c>();
           
        if(country == 'CA')
        {
            System.debug('Inside country CA >>> ');
            ccrzECategoryList = [SELECT Id,Name 
                                 FROM ccrz__E_Category__c 
                                 WHERE ccrz__ParentCategory__c = NULL AND Storefront__c='CSSNAStore' 
                                 ORDER BY ccrz__Sequence__c];           
        }
        else 
        {
            System.debug('Inside country US >>> ');
            ccrzECategoryList = [SELECT Id,Name 
                                 FROM ccrz__E_Category__c 
                                 WHERE Name!='Yamaha' AND ccrz__ParentCategory__c = NULL AND Storefront__c='CSSNAStore' 
                                 ORDER BY ccrz__Sequence__c];
        }
        System.debug('ccrzECategoryList=>'+ ccrzECategoryList.size());
        System.debug('ccrzECategoryList=>'+ ccrzECategoryList);
        
        for(ccrz__E_Category__c subCategory : ccrzECategoryList){            
				setSubCategoryID.add(subCategory.Id);
        } 
        System.debug('setSubCategoryID=>'+ setSubCategoryID);
        System.debug('setSubCategoryID.size()=>'+ setSubCategoryID.size());
        
        ccrzECategoryList = [SELECT Id,Name
                             FROM ccrz__E_Category__c 
                             WHERE ccrz__ParentCategory__c IN : setSubCategoryID AND Storefront__c='CSSNAStore'  
                             ORDER BY Name];
        
        System.debug('ccrzECategorySubCategoryList => '+ ccrzECategoryList.size());
        System.debug('ccrzECategorySubCategoryList => '+ ccrzECategoryList);
        subCategoryWrapper objsubCategoryWrapper = new subCategoryWrapper();
        objsubCategoryWrapper.subCategoryList = ccrzECategoryList;
        //System.debug('objsubCategoryWrapper => '+ objsubCategoryWrapper.size());
        System.debug('objsubCategoryWrapper => '+ objsubCategoryWrapper);
        return objsubCategoryWrapper; 
    } 
}