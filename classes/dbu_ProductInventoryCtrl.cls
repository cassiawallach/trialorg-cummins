public class dbu_ProductInventoryCtrl {
    public static void getInvStatus(List<ccrz__E_ProductInventoryItem__c> newTrigger){
        Set<ID> prodSet = new Set<ID>();
        List<ccrz__E_Product__c> prdList = new List<ccrz__E_Product__c>();
        List<ccrz__E_Product__c> prdListData = new List<ccrz__E_Product__c>();
        
        Boolean PRODIVSTATUS;
        ID prdID;
        List<ccrz__E_ProductInventoryItem__c> prodInvItem = new List<ccrz__E_ProductInventoryItem__c>();
        if(newTrigger != null){
            for(ccrz__E_ProductInventoryItem__c prdInvRec : newTrigger){
                system.debug('entering the for loop>>' +prdInvRec.ccrz__ProductItem__c);
                if(prdInvRec.Id != null && prdInvRec.ccrz__ProductItem__c != null){
                    system.debug('entering in for loop>>');
                    prodSet.add(prdInvRec.ccrz__ProductItem__c);
                    prdID = prdInvRec.ccrz__ProductItem__c;
                    system.debug('prodSet>>' +prodSet);
                    
                }
            }
        }
        if(prodSet != null){
            prodInvItem =[Select id,ccrz__Status__c,ccrz__ProductItem__c from ccrz__E_ProductInventoryItem__c 
                          WHERE ccrz__ProductItem__c IN :prodSet AND ccrz__ProductItem__r.Group_Name__c = 'Ecom'];
            system.debug('prodInvItem>>' +prodInvItem);
            
            if(prodInvItem != null){
                for(ccrz__E_ProductInventoryItem__c invLineItems: prodInvItem){
                    system.debug('invLineItems>>' +invLineItems);
                    
                    if(invLineItems.ccrz__Status__c == 'In Stock'){
                        PRODIVSTATUS = true;
                        system.debug('PRODIVSTATUS' +PRODIVSTATUS);
                        break;
                    }else{
                        PRODIVSTATUS = false;
                        system.debug('in else part' +PRODIVSTATUS);
                        
                    }
                }
                system.debug('after for part' +PRODIVSTATUS);
                prdListData = [Select id,dbu_Product_Status__c from ccrz__E_Product__c
                               where id =:prodSet];
                for(ccrz__E_Product__c prdObj:prdListData){
                    system.debug('prdObj' +prdObj);
                    if(PRODIVSTATUS == true){
                    prdObj.dbu_Product_Status__c = 'In Stock';
                    }else if(PRODIVSTATUS == false){
                        prdObj.dbu_Product_Status__c = 'Out of Stock';
                        
                    }
                    prdList.add(prdObj);
                }
                if(prdList.size()>0){
                    system.debug('prdList' +prdList);
                    update prdList;
                }
                
            }
            
        }
    }
    
    public static void updateInvCheckOnProduct(List<ccrz__E_Product__c>triggerNew,Map<Id,ccrz__E_Product__c>oldMap){
        List<ccrz__E_Product__c>updateProdList = new List<ccrz__E_Product__c>();
        List<ccrz__E_Product__c>prodList = new List<ccrz__E_Product__c>();
        Set<Id>prodIdSet = new Set<Id>();
        
        if(triggerNew != null){
            for(ccrz__E_Product__c newPRodList : triggerNew){
                system.debug('newPRodList' +newPRodList.dbu_Product_Status__c);
                system.debug('oldmap id' +oldMap.get(newPRodList.id).dbu_Product_Status__c);
                if(oldMap.get(newPRodList.id).dbu_Product_Status__c != '' && newPRodList.dbu_Product_Status__c != ''
                  && oldMap.get(newPRodList.id).dbu_Product_Status__c == 'Out of Stock' && newPRodList.dbu_Product_Status__c == 'In Stock'
                   && newPRodList.dbu_Inventory_Status_Check__c == false){
                       prodIdSet.add(newPRodList.id);
                   }
            }
            if(prodIdSet != null){
                prodList = [Select id,dbu_Inventory_Status_Check__c,dbu_Product_Status__c
                           FROM ccrz__E_Product__c WHERE id IN :prodIdSet];
                system.debug('prodList' +prodList);
                if(prodList != null){
                    for(ccrz__E_Product__c newPrdRec: prodList){
                        if(!newPrdRec.dbu_Inventory_Status_Check__c){
                           system.debug('newPrdRec.dbu_Inventory_Status_Check__c' +newPrdRec.dbu_Inventory_Status_Check__c);

                            newPrdRec.dbu_Inventory_Status_Check__c = true;
                           system.debug('newPrdRec.dbu_Inventory_Status_Check__c111' +newPrdRec.dbu_Inventory_Status_Check__c);

                            updateProdList.add(newPrdRec);
                        }
                    }
                    if(updateProdList.size()>0 &&updateProdList != null){
                        update updateProdList;
                    }
                }
            }
            
        }
    }
}