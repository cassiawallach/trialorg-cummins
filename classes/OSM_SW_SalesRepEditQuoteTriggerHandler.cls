/**********************************************************************
Name:  OSM_SW_SalesRepEditQuoteTriggerHandler
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to serve as a handler class to  OSM_SW_SalesRepEditQuoteTrigger                              
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR                      DATE              DETAIL                                
1.0 -    Adarsh Pidaparthy           4/13/2018     INITIAL DEVELOPMENT           


*****************************************************/

public class OSM_SW_SalesRepEditQuoteTriggerHandler {
    
    /*----------------------------------------------------------------------------------
1. onBeforeUpdate
Description:works on before update
Param: Rfqlist, oldrfqMap
Output: 
------------------------------------------------------------------------------------*/   
    
    public static void onBeforeUpdate(list<ccrz__E_RequestForQuote__c>rfqlist,Map<id,ccrz__E_RequestForQuote__c> oldrfqMap){
        String userType = '';
        if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
            userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
        } else{
            userType = OSM_SW_General_Util.USER_TYPE;
        }
        set<id> prodLst = new set <id>();
         for(ccrz__E_RequestForQuote__c rfq:rfqlist){
              prodLst.add(rfq.CC_Product__c);
         }
        
          List<CC_Quote_Limit__c> limitForProduct = [select id,product__c,Discounted_Price__c,Discounted_Percentage__c from  CC_Quote_Limit__c where product__c in: prodLst];
          //Map<id,CC_Quote_Limit__c> QuoteLimitMap = new Map<id,CC_Quote_Limit__c>();
          Map<String,Decimal> ProductToDiscountMap = new MAp<String,Decimal>();
          
          for(CC_Quote_Limit__c qlimit:limitForProduct)
          {
             ProductToDiscountMap.put(qlimit.product__c,qlimit.Discounted_Price__c)  ;
          }
          
        for(ccrz__E_RequestForQuote__c rfq:rfqlist){
            Decimal discountpriceLimit;
            ccrz__E_RequestForQuote__c oldrfq = oldrfqMap.get(rfq.Id);
            Decimal oldDiscountedPercentage = oldrfq.Discounted_Percentage__c != null ? oldrfq.Discounted_Percentage__c.setScale(2):oldrfq.Discounted_Percentage__c;
            Decimal oldDiscountedPrice = oldrfq.Discounted_Price__c != null ? oldrfq.Discounted_Price__c.setScale(2):oldrfq.Discounted_Price__c;
            
            Decimal newDiscountedPercentage = rfq.Discounted_Percentage__c != null ? rfq.Discounted_Percentage__c.setScale(2):rfq.Discounted_Percentage__c;
            
            //oldDiscountedPercentage = oldDiscountedPercentage != 0 ? oldDiscountedPercentage.setScale(2):oldDiscountedPercentage; 
            Decimal newDiscountedPrice = rfq.Discounted_Price__c != null ? rfq.Discounted_Price__c.setScale(2):rfq.Discounted_Price__c;
             
            
            if((rfq.Status__c == label.InprogressQuoteRfq )&& (rfq.Operation__c == 'Send'))
            {
                 rfq.Status__c = label.SentQuoteRfq;
                 rfq.Operation__c = '';
                if(userType == Label.OSM_Sales_Admin_UserType){
                    rfq.Quote_Sent_By__c = UserInfo.getUserId();
                }
            }
            
            if(((newDiscountedPercentage != oldDiscountedPercentage && newDiscountedPercentage == null) || (newDiscountedPrice != oldDiscountedPrice && newDiscountedPrice == null)) && (rfq.Status__c != label.RequestedQuoteRfq || rfq.Status__c != label.InActiveQuoteRfq)){
                rfq.addError('Discount Price or Discount Percentage cannot be null');
            }
             
            if((rfq.Status__c == label.RequestedQuoteRfq || rfq.Status__c == label.InprogressQuoteRfq || rfq.Status__c == label.RejectedQuoteRfq || rfq.Status__c == label.ExpiredQuoteRfq ) 
                    && ( newDiscountedPercentage != oldDiscountedPercentage) 
                    &&  (newDiscountedPrice != oldDiscountedPrice))
            {
                
                    rfq.addError('Both Discount Price and Discount Percentage cannot be edited at a same time1');
                
            }
             if(userType == Label.OSM_Sales_Admin_UserType && (rfq.Status__c == label.RequestedQuoteRfq || rfq.Status__c == label.InprogressQuoteRfq || rfq.Status__c == label.RejectedQuoteRfq || rfq.Status__c == label.ExpiredQuoteRfq ) 
                    && ( newDiscountedPercentage != oldDiscountedPercentage) 
                    &&  (newDiscountedPrice != oldDiscountedPrice)){
                    
             }
            if((rfq.Status__c == label.RejectedQuoteRfq)&&(rfq.Operation__c == 'Rejected' )){
                rfq.Status__c = label.RejectedQuoteRfq;
                rfq.Operation__c = '';
            }
             
            if((rfq.Status__c == label.InActiveQuoteRfq)&&(rfq.Operation__c == 'InActive' )){
                rfq.Status__c = label.InActiveQuoteRfq;
                rfq.Operation__c = '';
            } 
            
            if((rfq.Status__c == label.AcceptedQuoteRfq)&&(rfq.Operation__c == 'Accepted')){
                rfq.Status__c = label.AcceptedQuoteRfq; 
                rfq.Operation__c = '';
             }
            
            if((rfq.Status__c == label.InActiveQuoteRfq) &&  (newDiscountedPercentage != oldDiscountedPercentage || newDiscountedPrice != oldDiscountedPrice || rfq.Sales_User_Comments__c  != oldrfq.Sales_User_Comments__c)){
                rfq.addError('This action cannot be performed');
            }
            
            if((rfq.Status__c == label.AcceptedQuoteRfq || rfq.Status__c == label.SentQuoteRfq) &&  (newDiscountedPercentage != oldDiscountedPercentage || newDiscountedPrice != oldDiscountedPrice || rfq.Sales_User_Comments__c   != oldrfq.Sales_User_Comments__c)){
                rfq.addError('This action cannot be performed');
            }
            
        
            
            if(rfq.Status__c == label.InprogressQuoteRfq && rfq.Operation__c == 'Cancel'){
                rfq.Status__c = label.RequestedQuoteRfq;
                rfq.Operation__c = '';
                newDiscountedPercentage = null;
                newDiscountedPrice = null;
            }
            
            if((rfq.Status__c == label.InprogressQuoteRfq )&& (rfq.Operation__c == 'Send'))
            {
                 rfq.Status__c = label.SentQuoteRfq;
                      rfq.Operation__c = '';
                if(userType == Label.OSM_Sales_Admin_UserType){
                    rfq.Quote_Sent_By__c = UserInfo.getUserId();
                }
                if(rfq.Cost_Subscription__c < newDiscountedPrice)
                {
                     rfq.addError('Discounted Price cannot be same or greater than Actual Price');
                }
                
                 if(newDiscountedPrice <0 || newDiscountedPercentage <0)
                {
                     rfq.addError('Discounted Price or Percentage cannot be negative');
                }
               
            }
            
                 
            if((rfq.Status__c == label.RejectedQuoteRfq )&&(rfq.Operation__c == 'Rejected')&&(newDiscountedPercentage != oldDiscountedPercentage || newDiscountedPrice != oldDiscountedPrice )){
                rfq.Status__c = label.InProgressQuoteRfq;
            }
              
            
            if((rfq.Status__c == label.ExpiredQuoteRfq )&& rfq.Operation__c == 'Send'){
                rfq.Status__c = label.SentQuoteRfq;
                rfq.Operation__c = '';
            }
            
            if(newDiscountedPercentage == null && newDiscountedPrice == null && rfq.Status__c != label.RequestedQuoteRfq && rfq.Status__c != label.InActiveQuoteRfq){
                rfq.addError('Discount Price or Discount Percentage cannot be null');
            }
            
            if((rfq.Status__c == label.RequestedQuoteRfq || rfq.Status__c == label.InprogressQuoteRfq || rfq.Status__c == label.RejectedQuoteRfq || rfq.Status__c == label.ExpiredQuoteRfq ) 
                    && ( newDiscountedPercentage != oldDiscountedPercentage) 
                    &&  (newDiscountedPrice != oldDiscountedPrice) && rfq.Operation__c == 'Send')
            {
                
                    rfq.addError('Both Discount Price and Discount Percentage cannot be edited at a same time');
                
            }
        }
    }
    
    /* not used so commented now
    public static void onAfterUpdate(list<ccrz__E_RequestForQuote__c>rfqlist,Map<id,ccrz__E_RequestForQuote__c> oldrfqMap){
        String userType = '';
        if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
            userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
        } else{
            userType = OSM_SW_General_Util.USER_TYPE;
        }
        set<id> prodLst = new set <id>();
         for(ccrz__E_RequestForQuote__c rfq:rfqlist){
              prodLst.add(rfq.CC_Product__c);
         } 
        
          List<CC_Quote_Limit__c> limitForProduct = [select id,product__c,Discounted_Price__c, Discounted_Percentage__c from  CC_Quote_Limit__c where product__c in: prodLst];
          //Map<id,CC_Quote_Limit__c> QuoteLimitMap = new Map<id,CC_Quote_Limit__c>();
          Map<String,Decimal> ProductToDiscountMap = new MAp<String,Decimal>();
        Map<String,Decimal> ProductToDiscountPercentageMap = new MAp<String,Decimal>();
          
          for(CC_Quote_Limit__c qlimit:limitForProduct)
          {
              if(qlimit.Discounted_Price__c > 0){
                ProductToDiscountMap.put(qlimit.product__c,qlimit.Discounted_Price__c);
              }
              if(qlimit.Discounted_Percentage__c > 0){
                 ProductToDiscountPercentageMap.put(qlimit.product__c,qlimit.Discounted_Percentage__c);
              }
          }
          
        for(ccrz__E_RequestForQuote__c rfq:rfqlist){
            Decimal discountpriceLimit = null;
            Decimal discountpercentLimit = null;
            ccrz__E_RequestForQuote__c oldrfq = oldrfqMap.get(rfq.Id);
            
            Decimal oldDiscountedPercentage = oldrfq.Discounted_Percentage__c != null ? oldrfq.Discounted_Percentage__c.setScale(2):oldrfq.Discounted_Percentage__c;
            Decimal oldDiscountedPrice = oldrfq.Discounted_Price__c != null ? oldrfq.Discounted_Price__c.setScale(2):oldrfq.Discounted_Price__c;
            
            Decimal newDiscountedPercentage = rfq.Discounted_Percentage__c != null ? rfq.Discounted_Percentage__c.setScale(2):rfq.Discounted_Percentage__c;
            
            //oldDiscountedPercentage = oldDiscountedPercentage != 0 ? oldDiscountedPercentage.setScale(2):oldDiscountedPercentage; 
            Decimal newDiscountedPrice = rfq.Discounted_Price__c != null ? rfq.Discounted_Price__c.setScale(2):rfq.Discounted_Price__c;
            
            if(((newDiscountedPercentage <0 || newDiscountedPrice <0)&& rfq.Status__c != label.InActiveQuoteRfq && userType != Label.OSM_Sales_Admin_UserType)
              ||((newDiscountedPercentage < 0 || newDiscountedPrice < 0)&& rfq.Status__c != label.InActiveQuoteRfq && userType == Label.OSM_Sales_Admin_UserType)){
                rfq.addError('Discount Price or Discount Percentage cannot be negative or zero'); 
            }  
            
            if(newDiscountedPrice!=null && newDiscountedPrice != oldDiscountedPrice && userType != Label.OSM_Sales_Admin_UserType)
            {
                 if(ProductToDiscountMap.containskey(rfq.CC_Product__c) && ProductToDiscountMap.get(rfq.CC_Product__c) != null)
                 {
                      discountpriceLimit=  ProductToDiscountMap.get(rfq.CC_Product__c);
                      //CC_Quote_Limit__c discountpriceLimit =  QuoteLimitMap.get(prodId);
                      
                 }
                
                
                if(discountpriceLimit != null && newDiscountedPrice !=null && (rfq.Cost_Subscription__c-newDiscountedPrice ) > discountpriceLimit)
                   
                   {
                // || (discountpercentLimit != null && newDiscountedPercentage !=null && (rfq.Cost_Subscription__c-newDiscountedPercentage ) > discountpercentLimit)){
                 
                 rfq.addError('You have exceeded the discount limit inside price check');  
                }
                 
                else
                {
                     if(rfq.Status__c == label.RequestedQuoteRfq || rfq.Status__c == label.InprogressQuoteRfq || rfq.Status__c == label.RejectedQuoteRfq || rfq.Status__c == label.ExpiredQuoteRfq)
                    {
                
                       if(rfq.Cost_Subscription__c > newDiscountedPrice && rfq.Cost_Subscription__c != newDiscountedPrice)
                    {
                        rfq.Status__c = label.InprogressQuoteRfq;
                        rfq.Discounted_Percentage__c = (100 - ((rfq.Cost_Subscription__c - newDiscountedPrice)/ rfq.Cost_Subscription__c)*100);
                        if(newDiscountedPercentage < 0)
                    {
                        rfq.addError('Discounted Percentage Cannot be zero');
                        
                    }
                    }
                    
                     else
                   {
                        rfq.addError('Discounted Price cannot be same or greater than Actual Price');
                   }
                    }
                
            }
            }
            
        if(newDiscountedPercentage!=null && newDiscountedPercentage != oldDiscountedPercentage && userType != Label.OSM_Sales_Admin_UserType)
            {
                 if(ProductToDiscountPercentageMap.containskey(rfq.CC_Product__c) && ProductToDiscountPercentageMap.get(rfq.CC_Product__c) != null)
                 {
                      discountpercentLimit=  ProductToDiscountPercentageMap.get(rfq.CC_Product__c);
                      //CC_Quote_Limit__c discountpriceLimit =  QuoteLimitMap.get(prodId);
                     if(newDiscountedPercentage > discountpercentLimit){
                         rfq.addError('You have exceeded the discount limit inside discount percentage check');  
                     }
                      
                 }
                
                
                 if(newDiscountedPercentage != null && newDiscountedPercentage < 100)
                {
                rfq.Discounted_Price__c = rfq.Cost_Subscription__c - (rfq.Cost_Subscription__c * (newDiscountedPercentage / 100) );
                    newDiscountedPrice = rfq.Discounted_Price__c;
                rfq.Status__c = label.InprogressQuoteRfq;
                 if(ProductToDiscountMap.containskey(rfq.CC_Product__c))
                 {
                      discountpriceLimit =  ProductToDiscountMap.get(rfq.CC_Product__c);
                     // CC_Quote_Limit__c discountpriceLimit =  ProductToDiscountMAp.get(prodId);
                 }
                if(newDiscountedPrice != null && (rfq.Cost_Subscription__c-newDiscountedPrice ) > discountpriceLimit)
                 {
                     rfq.addError('You have exceeded the discount limit1');  
                 }
                 else{
                      if(rfq.Status__c == label.RequestedQuoteRfq || rfq.Status__c ==  label.InprogressQuoteRfq || rfq.Status__c == label.RejectedQuoteRfq || rfq.Status__c == label.ExpiredQuoteRfq)
                   {
                    //if(rfq.Cost_Subscription__c > newDiscountedPrice && rfq.Cost_Subscription__c != newDiscountedPrice)
                    if(rfq.Cost_Subscription__c > newDiscountedPrice)
                    {
                    rfq.Status__c = label.InprogressQuoteRfq;
                    rfq.Discounted_Price__c = rfq.Cost_Subscription__c - (rfq.Cost_Subscription__c * (newDiscountedPercentage / 100) );
                    if(newDiscountedPrice < 0.05)
                    {
                        rfq.addError('Discounted Price Cannot be zero or negative.');
                        
                    }
                   }
                  else
                  {  if(newDiscountedPrice != null && rfq.Cost_Subscription__c < newDiscountedPrice && userType != Label.OSM_Sales_Admin_UserType){
                        rfq.addError('Discounted Price cannot be same or greater than Actual Price');
                    }
                    }
                     
                 }
                 
            }
            }
            else{
                
                 rfq.adderror('Discount % cannot be equal or more than 100%');
            }
            }else{
                if(newDiscountedPrice>=100){
                    //rfq.adderror('Discount % cannot be equal or more than 100%');
                }
            }
         
            if((newDiscountedPrice!=null && newDiscountedPrice < 0 )|| (newDiscountedPercentage!=null && newDiscountedPercentage <0 ))
            {
                rfq.addError('Discount cannot be negative');  
            
            }
            
            if((newDiscountedPrice!=null && newDiscountedPrice >=0 && userType == Label.OSM_Sales_Admin_UserType )|| (newDiscountedPercentage!=null && newDiscountedPercentage >=0 && userType == Label.OSM_Sales_Admin_UserType))
            {  if(newDiscountedPercentage != oldDiscountedPercentage){
                    rfq.Discounted_Price__c = rfq.Cost_Subscription__c - (rfq.Cost_Subscription__c * (newDiscountedPercentage / 100) );
                    rfq.Status__c = label.InprogressQuoteRfq;
                }
             
             if(newDiscountedPrice!=null && newDiscountedPrice != oldDiscountedPrice){
                 rfq.Discounted_Percentage__c = (100 - ((rfq.Cost_Subscription__c - newDiscountedPrice)/ rfq.Cost_Subscription__c)*100);
                 rfq.Status__c = label.InprogressQuoteRfq;
             }
            }
            
            if(rfq.Discounted_Percentage__c>100){
                    rfq.adderror('Discount % cannot be equal or more than 100%');
                }
            
            if(rfq.Discounted_Price__c<0){
                    rfq.adderror('Discount price cannot be zero or negative');
                }
          } 
    }
    */
    
    public static void priceAndDiscountCalculation(list<ccrz__E_RequestForQuote__c>rfqlist,Map<id,ccrz__E_RequestForQuote__c> oldrfqMap){
    String userType = '';
        if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
            userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
        } else{
            userType = OSM_SW_General_Util.USER_TYPE;
        }
        
        //get Product's quote percentage and price Limit Data 
        set<id> prodIds = new set <id>();
         for(ccrz__E_RequestForQuote__c rfq:rfqlist){
              prodIds.add(rfq.CC_Product__c);
         }
        Map<String,CC_Quote_Limit__c> productQuoteLimitMap = new Map<String,CC_Quote_Limit__c>();
        for(CC_Quote_Limit__c quoteLimit : [select id,product__c,Discounted_Price__c,Discounted_Percentage__c from  CC_Quote_Limit__c where product__c IN: prodIds]){
            productQuoteLimitMap.put(quoteLimit.product__c, quoteLimit);
        }
        for(ccrz__E_RequestForQuote__c newDataRFQ : rfqlist){
            CC_Quote_Limit__c quoteLimitData = new CC_Quote_Limit__c();
            Boolean hasQuoteLimit = false;
            if(productQuoteLimitMap.get(newDataRFQ.CC_Product__c)!= null){
                quoteLimitData = productQuoteLimitMap.get(newDataRFQ.CC_Product__c);
                hasQuoteLimit = true;
              }
            
            ccrz__E_RequestForQuote__c previousDataRFQ = oldrfqMap.get(newDataRFQ.Id);
            Decimal oldDiscountedPercentage = previousDataRFQ.Discounted_Percentage__c != null ? previousDataRFQ.Discounted_Percentage__c.setScale(2):previousDataRFQ.Discounted_Percentage__c;
            Decimal oldDiscountedPrice = previousDataRFQ.Discounted_Price__c != null ? previousDataRFQ.Discounted_Price__c.setScale(2):previousDataRFQ.Discounted_Price__c;
            Decimal newDiscountedPercentage = newDataRFQ.Discounted_Percentage__c != null ? newDataRFQ.Discounted_Percentage__c.setScale(2):newDataRFQ.Discounted_Percentage__c;
            Decimal newDiscountedPrice = newDataRFQ.Discounted_Price__c != null ? newDataRFQ.Discounted_Price__c.setScale(2):newDataRFQ.Discounted_Price__c;
            Boolean priceChanged = (newDiscountedPrice != oldDiscountedPrice);
            Boolean percentageChanged = (newDiscountedPercentage != oldDiscountedPercentage);
            Decimal calculatedPrice = 0;
            Decimal calculatedPercentage = 0;
            if(percentageChanged && newDiscountedPercentage != null){
                //calculatedPrice = newDataRFQ.Cost_Subscription__c - (newDataRFQ.Cost_Subscription__c * (newDiscountedPercentage / 100) );
                calculatedPrice = (newDataRFQ.Cost_Subscription__c * (newDiscountedPercentage / 100) );
            }
            
             if(priceChanged && newDiscountedPrice != null){
                //calculatedPercentage = (100 - ((newDataRFQ.Cost_Subscription__c - newDiscountedPrice)/ newDataRFQ.Cost_Subscription__c)*100);
                //calculatedPercentage = (100 - ((newDiscountedPrice)/ newDataRFQ.Cost_Subscription__c)*100);
                calculatedPercentage = ((newDiscountedPrice)/ newDataRFQ.Cost_Subscription__c)*100;
            }
            
            //Set Quote Send by 
            
            if((newDataRFQ.Status__c == label.InprogressQuoteRfq) && (newDataRFQ.Operation__c == 'Send'))
                {
                    newDataRFQ.Status__c = label.SentQuoteRfq;
                    newDataRFQ.Operation__c = '';
                    if(userType == Label.OSM_Sales_Admin_UserType){
                        newDataRFQ.Quote_Sent_By__c = UserInfo.getUserId();
                    }
                }
            
            // Negative Value Check
            if((newDiscountedPrice!=null && priceChanged && newDiscountedPrice < 0 )|| (newDiscountedPercentage!=null && percentageChanged && newDiscountedPercentage <0 )){
                newDataRFQ.addError('Discount cannot be negative');  
            }
            
            //Discounted Price Check 
            if(newDiscountedPrice != null && priceChanged && newDataRFQ.Cost_Subscription__c < newDiscountedPrice){
                newDataRFQ.addError('Discounted Price cannot be same or greater than Actual Price');
            }
            
            //Discounted Percentage Check 
            if(newDiscountedPercentage != null && percentageChanged && newDiscountedPercentage > 100){
                newDataRFQ.addError('Discount % cannot be equal or more than 100%');
            }
             
            //Validation for Non Sales Admin User
            if(String.isBlank(userType) || userType != Label.OSM_Sales_Admin_UserType){
                //newDataRFQ.addError(userType+' 5 '+Label.OSM_Sales_Admin_UserType);
                boolean hasError = false; 
                // If discounted Price has given 
                if(newDiscountedPrice != null && priceChanged && newDiscountedPrice < newDataRFQ.Cost_Subscription__c){
                    // If Quote Limit has Price value
                    if(hasQuoteLimit && quoteLimitData.Discounted_Price__c != null && newDiscountedPrice > quoteLimitData.Discounted_Price__c && quoteLimitData.Discounted_Price__c >0){
                        newDataRFQ.addError('You have exceeded the discount limit');//+newDiscountedPrice+'--'+quoteLimitData.Discounted_Price__c);
                        hasError = true;
                    }
                    
                    // If Quote Limit has Percentage value
                    if(hasQuoteLimit && quoteLimitData.Discounted_Percentage__c != null && quoteLimitData.Discounted_Percentage__c>0){
                        
                        if(calculatedPercentage > quoteLimitData.Discounted_Percentage__c){
                             hasError = true;
                            newDataRFQ.addError('You have exceeded the discount limit');
                        }
                    }
                    
                }
                
                // if discounted Percentage has given
                if(newDiscountedPercentage != null && percentageChanged){
                    // If Quote Limit has Price value
                    if(hasQuoteLimit && quoteLimitData.Discounted_Price__c != null && quoteLimitData.Discounted_Price__c>0){
                        if(calculatedPrice > quoteLimitData.Discounted_Price__c){
                             hasError = true;
                            newDataRFQ.addError('You have exceeded the discount limit');
                        }
                    }
                    
                    // If Quote Limit has Percentage value
                    if(hasQuoteLimit && quoteLimitData.Discounted_Percentage__c != null && quoteLimitData.Discounted_Percentage__c>0){
                        if(newDiscountedPercentage > quoteLimitData.Discounted_Percentage__c){
                            newDataRFQ.addError('You have exceeded the discount limit');
                             hasError = true;
                        }
                    }
                    
                    if(hasError){
                        newDataRFQ.addError('You have exceeded the discount limit');
                    }
                    
                }
            }
            
            if(percentageChanged && newDiscountedPercentage != null && newDiscountedPercentage != oldDiscountedPercentage){
                    //newDataRFQ.Discounted_Price__c = newDataRFQ.Cost_Subscription__c - (newDataRFQ.Cost_Subscription__c * (newDiscountedPercentage / 100) );
                    newDataRFQ.Discounted_Price__c = (newDataRFQ.Cost_Subscription__c * (newDiscountedPercentage / 100) );
                        newDataRFQ.Status__c = label.InprogressQuoteRfq;
                }
             
             if(priceChanged && newDiscountedPrice!=null && newDiscountedPrice != oldDiscountedPrice){
                 //newDataRFQ.Discounted_Percentage__c = (100 - ((newDataRFQ.Cost_Subscription__c - newDiscountedPrice)/ newDataRFQ.Cost_Subscription__c)*100);
                 newDataRFQ.Discounted_Percentage__c = (((newDiscountedPrice)/ newDataRFQ.Cost_Subscription__c)*100);
                 //newDataRFQ.Discounted_Percentage__c = (100 - ((newDiscountedPrice)/ newDataRFQ.Cost_Subscription__c)*100);
                 newDataRFQ.Status__c = label.InprogressQuoteRfq;
             }
            //newDataRFQ.addError(userType+' 2 '+Label.OSM_Sales_Admin_UserType);
            //newDataRFQ.addError(hasError + ' calculatedPrice -->'+calculatedPrice+'  calculatedPercentage--->'+calculatedPercentage+' quoteLimitData--->'+quoteLimitData); 
        }        
        
        
    }
}