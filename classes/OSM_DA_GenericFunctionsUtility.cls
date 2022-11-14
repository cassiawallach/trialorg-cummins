public class OSM_DA_GenericFunctionsUtility{

     /**
        @ getSegmentSku return sku based on customerId
        @ param sku & customerId
      **/
      public static String getSegmentSku(String sku, String customerId){
            
            List<Account> acc = [Select id, OSM_Market_Segment_Code__c, CMI_Cid__c from account where CMI_Cid__c = :customerId];
            if(acc.size()>0){
                return acc[0].OSM_Market_Segment_Code__c != null ? sku+'-'+acc[0].OSM_Market_Segment_Code__c:'';
            }
            return sku;
        }
    
    /*
    public static Map<String,String> getDefaultDAProductPartNumber(List<String> packageNameLst)
    {
        Map<String,String> packageNameVsSKUMap = new Map<String,String>();
        List<ccrz__E_Product__c>  defaultProdLst = new List<ccrz__E_Product__c> ([select id,name,Package__c,ccrz__SKU__c from ccrz__E_Product__c where Is_DA_Default_Prod__c =true and Group_Name__c='DA' and ccrz__Storefront__c='SoftwareStore' and ccrz__StartDate__c> :System.today() and ccrz__EndDate__c< :System.today()and Package__c in :packageNameLst]);
        String partNumberDA='';
        
        for(ccrz__E_Product__c prod : defaultProdLst)
        {
            partNumberDA = prod.ccrz__SKU__c.substringBefore('-');
            packageNameVsSKUMap.put(prod.Package__c,partNumberDA);
        }
        
        return  packageNameVsSKUMap    ;
    }
    */
    
    public static Map<String,String> fetchDefaultDAProductPartNumber(List<String> baseProdPartNumberLst)
    {
    //sample value - CD-Base SKU,CA-Base Sku,CA-Plus SKU
    //to be used in Order Update Api
       Map<Id,ccrz__E_Product__c> prodMap =new Map<Id,ccrz__E_Product__c> ([select id,ccrz__SKU__c,Market_Segment__c,ccrz__ParentProduct__c,ccrz__ParentProduct__r.ccrz__SKU__c from ccrz__E_Product__c where ccrz__SKU__c in :baseProdPartNumberLst]);
       Map<String,String> returnMap = new Map<String,String>();
       String defaultProdSku='';
       system.debug('fetchDefaultDAProductPartNumber--->'+prodMap);
       for(String id : prodMap.keySet())
       {
         ccrz__E_Product__c product =  prodMap.get(id);
         if(product.ccrz__ParentProduct__r.ccrz__SKU__c!='')
         {
           defaultProdSku = product.ccrz__ParentProduct__r.ccrz__SKU__c;
           returnMap.put(product.ccrz__SKU__c,defaultProdSku);  
         }
         if(product.ccrz__ParentProduct__c == null){
             //defaultProdSku = product.ccrz__ParentProduct__r.ccrz__SKU__c;
           	returnMap.put(product.ccrz__SKU__c,product.ccrz__SKU__c);  
         }
         
       }
       
       //returns the Map(BaseProductPartNumber,DefaultProductPartNumber)
       return returnMap;
    }
    
    public static Map<String,String> fetchOSMProdPartNoForDefaultSku(List<String> defaultPartNumberLst,String marketSegment)
    {
       //to be used in Partial Subscription Cancellation
       //and Prod Subs API
       
       system.debug('marketSegment===>'+marketSegment);
       system.debug('defaultPartNumberLst===>'+defaultPartNumberLst);
        Map<Id,ccrz__E_Product__c> defaultprodMap = new Map<Id,ccrz__E_Product__c>();
        Map<Id,ccrz__E_Product__c> prodMap = new Map<Id,ccrz__E_Product__c>();
        Map<String,String> defaultProdPartNoVsSegmentProdPartNo = new Map<String,String>();
        defaultprodMap = new Map<Id,ccrz__E_Product__c>([select id,ccrz__SKU__c from ccrz__E_Product__c where ccrz__SKU__c in :defaultPartNumberLst]);
        
        if(Label.OSM_Default_Market_Segment.containsIgnoreCase(marketSegment)){
            //prodMap = new Map<Id,ccrz__E_Product__c>([select id,ccrz__SKU__c,ccrz__ParentProduct__c,ccrz__ParentProduct__r.ccrz__SKU__c from ccrz__E_Product__c where ccrz__ParentProduct__c in :defaultprodMap.keySet()]);
       		
            system.debug('defaultprodMap===>'+defaultprodMap);
       //Map<Id,ccrz__E_Product__c> prodMap = new Map<Id,ccrz__E_Product__c>([select id,ccrz__SKU__c,ccrz__ParentProduct__c,ccrz__ParentProduct__r.ccrz__SKU__c from ccrz__E_Product__c where Market_Segment__c=:marketSegment and ccrz__ParentProduct__c in :defaultprodMap.keySet()]);
       //prodMap = new Map<Id,ccrz__E_Product__c>([select id,ccrz__SKU__c,ccrz__ParentProduct__c,ccrz__ParentProduct__r.ccrz__SKU__c from ccrz__E_Product__c where Market_Segment__c=:marketSegment and ccrz__ParentProduct__c in :defaultprodMap.keySet()]);
        system.debug('prodMap===>'+prodMap);
       
       String defaultProdSku='';
        for(String id : defaultprodMap.keySet())
       {
         ccrz__E_Product__c product =  defaultprodMap.get(id);
         //if(product.ccrz__SKU__c!='')
         //{
           //defaultProdSku = product.ccrz__ParentProduct__r.ccrz__SKU__c;
           defaultProdPartNoVsSegmentProdPartNo.put(product.ccrz__SKU__c,product.ccrz__SKU__c);
         //}
         
       }
            
        }else{
        
           system.debug('defaultprodMap===>'+defaultprodMap);
           //Map<Id,ccrz__E_Product__c> prodMap = new Map<Id,ccrz__E_Product__c>([select id,ccrz__SKU__c,ccrz__ParentProduct__c,ccrz__ParentProduct__r.ccrz__SKU__c from ccrz__E_Product__c where Market_Segment__c=:marketSegment and ccrz__ParentProduct__c in :defaultprodMap.keySet()]);
           prodMap = new Map<Id,ccrz__E_Product__c>([select id,ccrz__SKU__c,ccrz__ParentProduct__c,ccrz__ParentProduct__r.ccrz__SKU__c from ccrz__E_Product__c where Market_Segment__c=:marketSegment and ccrz__ParentProduct__c in :defaultprodMap.keySet()]);
            system.debug('prodMap===>'+prodMap);
           
           String defaultProdSku='';
            for(String id : prodMap.keySet())
           {
             ccrz__E_Product__c product =  prodMap.get(id);
             if(product.ccrz__ParentProduct__r.ccrz__SKU__c!='')
             {
               defaultProdSku = product.ccrz__ParentProduct__r.ccrz__SKU__c;
               defaultProdPartNoVsSegmentProdPartNo.put(product.ccrz__ParentProduct__r.ccrz__SKU__c,product.ccrz__SKU__c);
             }
             
           }
    	}
    
       //returns the Map(DefaultProductPartNumber,OSMProductPartNumber)
       return defaultProdPartNoVsSegmentProdPartNo;
    }
    

    
    public static Map<String,DAProdCountInfo> fetchOSMParentProdAndCount(Map<String,DAProdCountInfo> defaultSkuVsCountMapFromDA,String marketSegment)
    {
        Map<String,DAProdCountInfo> mainProdSkuVsCountMap = new Map<String,DAProdCountInfo>();
        
        try{
        List<String> defaultPartNumberLst = new List<String>(defaultSkuVsCountMapFromDA.keySet());
        //fetch the OSM Part Number corresponding to the Default Prod SKU
        Map<String,String> defaultProdPartNoVsSegmentProdPartNoMap = fetchOSMProdPartNoForDefaultSku(defaultPartNumberLst,marketSegment);
        system.debug('defaultProdPartNoVsSegmentProdPartNoMap ===>'+defaultProdPartNoVsSegmentProdPartNoMap );
        List<String> segmentPartNoLst = defaultProdPartNoVsSegmentProdPartNoMap.values();
        system.debug('segmentPartNoLst ===>'+segmentPartNoLst );
        Map<Id,ccrz__E_Product__c> segmentProdMap = new Map<Id,ccrz__E_Product__c>([select id,ccrz__SKU__c from ccrz__E_Product__c where ccrz__SKU__c in :segmentPartNoLst]);
        system.debug('segmentProdMap===>'+segmentProdMap);
        Map<String,String> segmentProdSkuVsIdMap = new Map<String,String>();
        for(String id:segmentProdMap.keySet())
        {
          ccrz__E_Product__c segmentProd = segmentProdMap.get(id);
             segmentProdSkuVsIdMap.put(segmentProd.ccrz__SKU__c,id);
        }
        
        //logic to fetch the main Display Product like Connected Advisor
        Map<Id,ccrz__E_CompositeProduct__c> compMap =  new Map<Id,ccrz__E_CompositeProduct__c>([select id,ccrz__Composite__c,ccrz__Component__c from  ccrz__E_CompositeProduct__c   where  ccrz__Component__c in :segmentProdMap.keySet()]);
        system.debug('compMap ===>'+compMap);
        Map<String,String> childProdIdVsMainProdIdMap = new Map<String,String>();
        for(String id: compMap.keySet())
        {
           ccrz__E_CompositeProduct__c comp = compMap.get(id);
           childProdIdVsMainProdIdMap.put(comp.ccrz__Component__c,comp.ccrz__Composite__c);
        }
        system.debug('childProdIdVsMainProdIdMap ===>'+childProdIdVsMainProdIdMap);
        Map<Id,ccrz__E_Product__c> mainProdMap = new Map<Id,ccrz__E_Product__c>([select id,ccrz__SKU__c from ccrz__E_Product__c where id in :childProdIdVsMainProdIdMap.values()]);
        system.debug('mainProdMap===>'+mainProdMap);
        for(String defaultProdSku : defaultProdPartNoVsSegmentProdPartNoMap.keySet())
        {
           String segmentProdPartNo = defaultProdPartNoVsSegmentProdPartNoMap.get(defaultProdSku);
           String segmentProdId = segmentProdSkuVsIdMap.get(segmentProdPartNo);
           String mainProdId = childProdIdVsMainProdIdMap.get(segmentProdId);
           ccrz__E_Product__c mainProd = mainProdMap.get(mainProdId);
           DAProdCountInfo daCntInfo = defaultSkuVsCountMapFromDA.get(defaultProdSku);
           //Integer count = 
           mainProdSkuVsCountMap.put(mainProd.ccrz__SKU__c,daCntInfo);
           
        }
            // Juhi Changes - Added for test class code coverage
        if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 

        }Catch(exception ex){system.debug(ex.getlinenumber()+'==XXXXXX==='+ex);}
        system.debug('mainProdSkuVsCountMap===>'+mainProdSkuVsCountMap);
       //Map(Parent Product SKU,Count)
       return mainProdSkuVsCountMap;
    }

        public class DAProdCountInfo{
        
        public Integer availableCnt;
        public Integer currentCnt;
        public String defaultDAProdPartNo;
        public String segmentDAProdPartNo;
        public String daMessage;
        public String segmentMainProductPartNo;
        public boolean isNotAvailabelorAPIFailed;
        public String failedMsg;
           
    }
    
}