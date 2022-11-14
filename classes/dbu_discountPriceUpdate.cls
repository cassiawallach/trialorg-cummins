/**

* @description : Test class for dbu_discountPriceUpdate.cls

* @author : Yash Sethi

* @group :

* @last modified on : 06-21-2022

* @last modified by : Yash Sethi

**/


public class dbu_discountPriceUpdate 
{
    
    //this method is to update discount percent and final price in price list item
	public static void updateDiscountPrice(List<ccrz__E_PriceListItem__c> newpriceListItem, Map<id, ccrz__E_PriceListItem__c>oldItemMap)
    {
        map<string, string> mMap = new map<string, string>();
        set<string> prodIdSet = new set<string>();
        map<string, string> productCurrencyMap = new map<string, string>();

        List<ccrz__E_PriceListItem__c> itemList = new List<ccrz__E_PriceListItem__c>();

        Map<Id,ccrz__E_PriceList__c> priceListIdStoreMap = new Map<Id,ccrz__E_PriceList__c>([Select Id,Name,ccrz__Storefront__c, ccrz__CurrencyISOCode__c 
                                                                from ccrz__E_PriceList__c 
                                                                where ccrz__Storefront__c = 'CSSNAStore']);

        for(ccrz__E_PriceListItem__c plI :newpriceListItem){

            if(priceListIdStoreMap.containsKey(plI.ccrz__Pricelist__c)){
                itemList.add(plI);
                productCurrencyMap.put(plI.ccrz__Product__c,priceListIdStoreMap.get(plI.ccrz__Pricelist__c).ccrz__CurrencyISOCode__c);

                if(Trigger.isUpdate){
                if(plI.dbu_Discount_Percent__c !=  oldItemMap.get(plI.Id).dbu_Discount_Percent__c || 
                    plI.ccrz__Price__c !=  oldItemMap.get(plI.Id).ccrz__Price__c || 
                    plI.dbu_Original_Price__c !=  oldItemMap.get(plI.Id).dbu_Original_Price__c)
                {
                    prodIdSet.add(plI.ccrz__Product__c);
                }
                }
                else if (Trigger.isInsert){
                    if(plI.dbu_Discount_Percent__c != null || 
                        plI.ccrz__Price__c !=  null || 
                        plI.dbu_Original_Price__c != null)
                    {
                        prodIdSet.add(plI.ccrz__Product__c);
                    }
                }
            }
        }

        map<string, string> corePriceUSDMap = dbu_ProductCtrl.fetchcorepricebyproductid(prodIdSet, 'USD');
        map<string, string> corePriceCADMap = dbu_ProductCtrl.fetchcorepricebyproductid(prodIdSet, 'CAD');
       

        
        for(ccrz__E_PriceListItem__c item : itemList)
        {
            decimal corePrice = 0;
            if(productCurrencyMap.get(item.ccrz__Product__c) == 'USD')
            {
                if(corePriceUSDMap.get(item.ccrz__Product__c) != null)
                {
                    corePrice = decimal.valueof(corePriceUSDMap.get(item.ccrz__Product__c));
                }
            }

            else if(productCurrencyMap.get(item.ccrz__Product__c) == 'CAD')
            {
                if(corePriceCADMap.get(item.ccrz__Product__c) != null)
                {
                    corePrice = decimal.valueof(corePriceCADMap.get(item.ccrz__Product__c));
                }
            }

            if(item.ccrz__Price__c != Null)
            {
                //system.debug('step 3' + item.dbu_Discount_Percent__c + ' --- '+ oldItemMap.get(item.id).dbu_Discount_Percent__c);
                if(trigger.isUpdate)
                {
                    if(item.dbu_Discount_Percent__c != oldItemMap.get(item.id).dbu_Discount_Percent__c)
                    {
                        if(item.dbu_Discount_Percent__c == null)
                        {
                            item.dbu_Discount_Percent__c = null;  
                            item.dbu_Core_Discount_Percent__c = null;
                            //Start CECI-1027
                            item.ccrz__Price__c=(item.dbu_Original_Price__c).setScale(2);
                            //END CECI-1027 
                        }
                        else
                        {
                            system.debug('step 4');
                            if(item.dbu_Original_Price__c == null)
                            {
                                //Start CECI-1027
                                item.dbu_Original_Price__c = ((item.ccrz__Price__c*100)*(1/item.dbu_Discount_Percent__c)).setScale(2);
                                //END CECI-1027 
                            }
                            else
                            {
                                system.debug('step 5');
                                item.ccrz__Price__c = (item.dbu_Original_Price__c - ((item.dbu_Original_Price__c*item.dbu_Discount_Percent__c)/100)).setScale(2);
                                
                            }
                            
                        }
                    }
                
                    if(item.ccrz__Price__c != oldItemMap.get(item.id).ccrz__Price__c)
                    {
                        if(item.dbu_Discount_Percent__c == null && item.dbu_Original_Price__c == null )
                        {
                            item.dbu_Discount_Percent__c = null;
                            item.dbu_Core_Discount_Percent__c = null;
                            item.dbu_Original_Price__c = null;
                            
                        }
                        else if(item.dbu_Discount_Percent__c != null && item.dbu_Original_Price__c == null)
                        {
                            item.dbu_Original_Price__c = ((item.ccrz__Price__c*100)*(1/item.dbu_Discount_Percent__c)).setScale(2);
                            
                        }
                        //Start CECI-1027
                        else if(item.ccrz__Price__c==0.0 && item.dbu_Original_Price__c != null )
                        {
                            item.dbu_Discount_Percent__c =100; 
                            item.dbu_Core_Discount_Percent__c = ((((item.dbu_Original_Price__c + corePrice) - (item.ccrz__Price__c + corePrice))*100)/(item.dbu_Original_Price__c + corePrice)).round(System.RoundingMode.HALF_EVEN);
                        }
                        //END CECI-1027
                        else
                        {
                            item.dbu_Discount_Percent__c = (((item.dbu_Original_Price__c - item.ccrz__Price__c)*100)/item.dbu_Original_Price__c).round(System.RoundingMode.HALF_EVEN);
                            item.dbu_Core_Discount_Percent__c = ((((item.dbu_Original_Price__c + corePrice) - (item.ccrz__Price__c + corePrice))*100)/(item.dbu_Original_Price__c + corePrice)).round(System.RoundingMode.HALF_EVEN);
                        }
                    }
                
    
                    if(item.dbu_Original_Price__c != oldItemMap.get(item.id).dbu_Original_Price__c)
                    {
                        if(item.dbu_Original_Price__c == null ||item.dbu_Original_Price__c==0.0)
                        {
                            item.dbu_Original_Price__c = null;
                            item.dbu_Discount_Percent__c = null;
                            item.dbu_Core_Discount_Percent__c = null;
                        
                        }
                        else
                        {
                            item.dbu_Discount_Percent__c = (((item.dbu_Original_Price__c - item.ccrz__Price__c)*100)/item.dbu_Original_Price__c).round(System.RoundingMode.HALF_EVEN);
                            item.dbu_Core_Discount_Percent__c = ((((item.dbu_Original_Price__c + corePrice) - (item.ccrz__Price__c + corePrice))*100)/(item.dbu_Original_Price__c + corePrice)).round(System.RoundingMode.HALF_EVEN);
                        }
                    }
                }

                else if(trigger.isInsert)
                {
                    if(item.dbu_Original_Price__c != null)
                    {
                        item.dbu_Discount_Percent__c = (((item.dbu_Original_Price__c - item.ccrz__Price__c)*100)/item.dbu_Original_Price__c).round(System.RoundingMode.HALF_EVEN);
                        item.dbu_Core_Discount_Percent__c = ((((item.dbu_Original_Price__c + corePrice) - (item.ccrz__Price__c + corePrice))*100)/(item.dbu_Original_Price__c + corePrice)).round(System.RoundingMode.HALF_EVEN);
                        
                    }

                    else if(item.dbu_Discount_Percent__c != null)
                    {
                        item.dbu_Original_Price__c = ((item.ccrz__Price__c*100)*(1/item.dbu_Discount_Percent__c)).setScale(2);
                    }
                }
            }
            else
            {
                item.addError('Price can not be null');
            }
                
        }
    }
}