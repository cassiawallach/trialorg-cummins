global with sharing class dbu_EXTEND_ccServiceWishListItem extends ccrz.ccServiceWishListItem{
    global virtual override Map<String, Object> getFieldsMap(Map<String,Object> inputData){
        inputData = super.getFieldsMap(inputData);
        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);
        objectFields += ',DBU_SaveForLater__c';    
        return new Map<String,Object>{ccrz.ccService.OBJECTFIELDS => objectFields};        
     }
    
    global virtual override Map<String, Object> getFilterMap(Map<String, Object> inputData) {
        Map<String, Object> RetMap = super.getFilterMap(inputData);
        
        if(inputData.get('DBU_SAVEFORLATER') != null){
            
            string checkWLorSFL = (string)inputData.get('DBU_SAVEFORLATER');
            if(checkWLorSFL == 'WishList'){
                 
                 RetMap.put('ISWISHLIST','AND DBU_SaveForLater__c ='+ '\''+ checkWLorSFL + '\'');
                
            }else if(checkWLorSFL == 'Save For Later'){
                
                RetMap.put('ISSAVEFORLATER','AND DBU_SaveForLater__c ='+'\''+ checkWLorSFL + '\'');
            }            
        }
        
        return RetMap;
    }
}