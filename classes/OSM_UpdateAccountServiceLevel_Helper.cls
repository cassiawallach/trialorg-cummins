public class OSM_UpdateAccountServiceLevel_Helper 
{
    public static void updateAllAccountServiceLevelsManually()
    {
        Set<ID> accountIDSet = new Set<ID>();
        
        List<CSS_Accreditation__c> accreditationList = [Select ID, Service_Level__c, Account__c, Product_Details__c from CSS_Accreditation__c where Account__c != null];
        for(CSS_Accreditation__c accr : accreditationList)
        {
            accountIDSet.add(accr.Account__c);
        } 
        
        if(null != accountIDSet && accountIDSet.size() > 0)
        {
            OSM_UpdateAccountServiceLevel_Helper.updateAccountServiceLevel(accountIDSet);
        }
    }
    
    public static void updateAccountServiceLevel(Set<ID> accountIDSet)
    {
        Map<ID, Boolean> accountFullServiceMap = new Map<ID, Boolean>();
        Map<ID, Boolean> accountHHPMap = new Map<ID, Boolean>();
        
        if(null != accountIDSet && accountIDSet.size() > 0)
        {
            List<CSS_Accreditation__c> accreditationList = [Select ID, Service_Level__c, Account__c, Product_Details__c from CSS_Accreditation__c where Account__c in :accountIDSet];
            
            if(null != accreditationList && accreditationList.size() > 0)
            {
                for(CSS_Accreditation__c accr : accreditationList)
                {
                    if(null != accr.Account__c)
                    {
                        // this is for OSM Service Level i.e Deal_FS or Deal_Maint
                        if(null == accountFullServiceMap.get(accr.Account__c))
                        {
                            accountFullServiceMap.put(accr.Account__c, false);
                            system.debug('accountFullServiceMap===='+accountFullServiceMap);
                        }
                        
                        if(null != accr.Service_Level__c && Label.OSM_Account_FullServiceLevels.contains(accr.Service_Level__c))
                        {
                            accountFullServiceMap.put(accr.Account__c, true);
                            
                        }
                        system.debug('accountFullServiceMap22222===='+accountFullServiceMap+'accr.Service_Level__c==='+accr.Service_Level__c);
                        // this is for HHP(High Horse Power) true or false
                        if(null == accountHHPMap.get(accr.Account__c))
                        {
                            accountHHPMap.put(accr.Account__c, false);
                        }
                        
                        if(null != accr.Product_Details__c && String.isNotEmpty(accr.Product_Details__c)) 
                        {
                            String productDetailsJson = '{"productDetailList":' + accr.Product_Details__c + '}';
                            
                            ProductDetails productDetails = (ProductDetails) System.JSON.deserialize(productDetailsJson, ProductDetails.class);
                            
                            if(null != productDetails 
                               && null != productDetails.productDetailList && productDetails.productDetailList.size() > 0)
                            {
                                String productRange = productDetails.productDetailList[0].PRODUCT_RANGE;
                                
                                if(Label.OSM_Account_HHPLevels.contains(productRange))
                                {
                                    accountHHPMap.put(accr.Account__c, true);
                                }
                            }
                        }
                    }
                }
            }
            
            List<Account> accountList = [Select ID, OSM_Service_Level__c, OSM_HHP_Dealer__c,ServiceLevel__c,EngineRangeDesc__c From Account where ID in :accountIDSet];
            
            for(Account acc : accountList)
            {
           /*   if(accountFullServiceMap.get(acc.ID)) Mar-1236
                {
                    acc.OSM_Service_Level__c = Label.OSM_FullService;
                }
                else
                {
                    acc.OSM_Service_Level__c = Label.OSM_LiteRepair;
                } */
                
                if(accountFullServiceMap.get(acc.ID)) 
                {
                    acc.ServiceLevel__c = Label.OSM_FullService;
                }
                else
                {
                    acc.ServiceLevel__c = '';
                }
             
           /*   if(accountHHPMap.get(acc.ID)) Mar-1236
                {
                    acc.OSM_HHP_Dealer__c = true;
                }
                else
                {
                    acc.OSM_HHP_Dealer__c = false;
                } */
                
                if(accountHHPMap.get(acc.ID)) 
                {
                    acc.EngineRangeDesc__c = 'HHP';
                }
                else
                {
                    acc.EngineRangeDesc__c = '';
                }
            }
            
            update accountList;
        }
    }
    
    public class ProductDetails
    {
        public List<ProductDetail> productDetailList;
    }
    
    public class ProductDetail
    {
        public String PRODUCT_TYPE;
        public String PRODUCT_RANGE;
        public String MARKET_APPLICATION;
    }
}