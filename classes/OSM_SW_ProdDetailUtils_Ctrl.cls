/**********************************************************************
Name:  OSM_SW_ProdDetailUtils_Ctrl
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to keep all relative fetch
queries for Product Detail                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Vineet            3/12/2018     INITIAL DEVELOPMEN    
 Update 
 Reupdate
 Reupdate


*****************************************************/

public without sharing class OSM_SW_ProdDetailUtils_Ctrl {

    /*----------------------------------------------------------------------------------
    1. getCcrzEProductSpecs
    Description:Used to fetch ProductSpec item of Product
    Param: productids
    Output: 
    Returns the ProductSpec items
    ------------------------------------------------------------------------------------*/
    public static List < ccrz__E_ProductSpec__c > getCcrzEProductSpecs(List < String > prodIds) {
     return [Select Id, ccrz__Product__c, ccrz__Product__r.Name, ccrz__Spec__c, ccrz__Spec__r.imageText__c, ccrz__SpecValue__c, 
                    ccrz__Spec__r.Name, ccrz__Spec__r.ccrz__Sequence__c 
                from ccrz__E_ProductSpec__c 
                where ccrz__Product__c IN: prodIds];
    }
    
    /*----------------------------------------------------------------------------------
    1. getCcrzCompositProducts
    Description:Used to fetch CompositeProduct based on component
    Param: products Ids
    Output: 
    Returns the CompositeProducts
    
    ------------------------------------------------------------------------------------*/
    public static List < ccrz__E_CompositeProduct__c > getCcrzCompositProducts(List < String > prodIds) {
     List < ccrz__E_CompositeProduct__c > eCompositeProducts = [SELECT ccrz__Component__r.Product_Supporting_Text__c,ccrz__Component__r.Name,ccrz__Component__r.isIAMProvisioningRequired__c,ccrz__Component__r.QSOLType__c , ccrz__Composite__r.ccrz__SKU__c, ccrz__Component__r.ccrz__SKU__c,ccrz__Composite__r.Package__c,ccrz__Category__c, ccrz__Component__c, ccrz__CompositeProductId__c, 
                                                                        ccrz__Composite__c, ccrz__DescriptionRT__c, ccrz__Description__c, ccrz__ExtendedPrice__c, ccrz__Optional__c, ccrz__Component__r.ccrz__ProductType__c,
                                                                        Unit_of_Measure__c, ccrz__Parent__c, ccrz__ProductGroup__c, ccrz__Quantity__c, Unit__c, ccrz__Sequence__c, CreatedById, CreatedDate, Id, 
                                                                        Fluid_Volume_required__c, IsDeleted, LastActivityDate, LastModifiedById, LastModifiedDate, Name, OwnerId, SystemModstamp 
                                                                FROM ccrz__E_CompositeProduct__c 
                                                                where ccrz__Composite__c IN: prodIds order by ccrz__Component__r.Name desc];
     return eCompositeProducts;
    }
    
    /*----------------------------------------------------------------------------------
    1. getEProduct
    Description:Used to get Product detail based on sku 
    Param: sku
    Output: 
    Returns Product detail
    ------------------------------------------------------------------------------------*/
    public static List < ccrz__E_Product__c > getEProduct(String sku) {
     List < ccrz__E_Product__c > eProduct = [SELECT ccrz__SKU__c, Id,Name, ccrz__ProductType__c, Group_Name__c 
                                                FROM ccrz__E_Product__c 
                                                where ccrz__SKU__c = : sku];
     return eProduct;
    }
    
    /*----------------------------------------------------------------------------------
    1. getEProductOnId
    Description:Used to get Product detail based on Id 
    Param: sku
    Output: 
    Returns Product detail
    ------------------------------------------------------------------------------------*/
    public static List < ccrz__E_Product__c > getEProductOnId(String prodId) {
     List < ccrz__E_Product__c > eProduct = [SELECT ccrz__SKU__c,Name,Stand_Alone_Product__c,ccrz__LongDesc__c, Id, ccrz__ProductType__c, Group_Name__c,
                                                (SELECT ccrz__Price__c FROM ccrz__E_PriceListItems__r)  
                                                FROM ccrz__E_Product__c 
                                                where id = : prodId];
     return eProduct;
    }
    
    /*----------------------------------------------------------------------------------
    1. getSubProdTermsMap
    Description:Used to get subProdTerm detail based on subProdTermIds 
    Param: subProdTermIds
    Output: 
    Returns SubProdTerms Map
    ------------------------------------------------------------------------------------*/
    public static Map < Id, ccrz__E_SubProdTerm__c > getSubProdTermsMap(List < string > subProdTermIds) {
     Map < Id, ccrz__E_SubProdTerm__c > subProdMap = new Map < Id, ccrz__E_SubProdTerm__c >(
                                                            [Select Id, Subs_Cost_Multiplier__c,ccrz__InstallmentFrequency__c,OSM_Bill_Freq__c,ccrz__OrderFrequency__c, ccrz__InstallmentCount__c, Billing_Display_Name__c, ccrz__CCProduct__r.ccrz__SKU__c,BillingFrequency_Sequence__c, Subs_Length_Sequence__c, Subs_Year_Multipler__c, ccrz__Enabled__c, 
                                                                    ccrz__InstallmentFrequencyUOM__c, Operation__c, FrequncyNumber__c, ccrz__DisplayName__c, ccrz__CCProduct__c 
                                                                from ccrz__E_SubProdTerm__c 
                                                                where Id IN : subProdTermIds ]);
     return subProdMap;
    }
    
      
        
    /*----------------------------------------------------------------------------------
    1. getSubProdTermsMap
    Description:Used to get subProdTerm detail based on subProdTermIds 
    Param: subProdTermIds
    Output: 
    Returns SubProdTerms Map
    ------------------------------------------------------------------------------------*/
    public static Map < Id, ccrz__E_SubProdTerm__c > getSubProdTermsMap(List < string > subProdTermIds, String store) {
     Map < Id, ccrz__E_SubProdTerm__c > subProdMap = new Map < Id, ccrz__E_SubProdTerm__c >(
                                                            [Select Id, Subs_Cost_Multiplier__c,ccrz__InstallmentFrequency__c,OSM_Bill_Freq__c,ccrz__OrderFrequency__c, ccrz__InstallmentCount__c, Billing_Display_Name__c, ccrz__CCProduct__r.ccrz__SKU__c,BillingFrequency_Sequence__c, Subs_Length_Sequence__c, Subs_Year_Multipler__c, ccrz__Enabled__c, 
                                                                    ccrz__InstallmentFrequencyUOM__c, Operation__c, FrequncyNumber__c, ccrz__DisplayName__c, ccrz__CCProduct__c 
                                                                from ccrz__E_SubProdTerm__c 
                                                                where Id IN : subProdTermIds 
                                                                and ccrz__Storefront__c =: store]);
     return subProdMap;
    }
        
    /*----------------------------------------------------------------------------------
    Description:Used to get subProdTerm detail based on ProdId 
    Param: subProdTermIds
    Output: 
    Returns SubProdTerms Map
    ------------------------------------------------------------------------------------*/
    public static Map < Id, ccrz__E_SubProdTerm__c > getSubProdTermsMap(string prodId) {
     Map < Id, ccrz__E_SubProdTerm__c > subProdMap = new Map < Id, ccrz__E_SubProdTerm__c >(
                                                        [Select Id, Subs_Cost_Multiplier__c,ccrz__InstallmentFrequency__c,OSM_Bill_Freq__c,ccrz__OrderFrequency__c,ccrz__InstallmentCount__c, Billing_Display_Name__c, ccrz__CCProduct__r.ccrz__SKU__c, Subs_Year_Multipler__c, BillingFrequency_Sequence__c, Subs_Length_Sequence__c,ccrz__Enabled__c, 
                                                                ccrz__InstallmentFrequencyUOM__c, Operation__c, FrequncyNumber__c, ccrz__DisplayName__c, ccrz__CCProduct__c 
                                                        from ccrz__E_SubProdTerm__c 
                                                        where ccrz__CCProduct__c = : prodId]);
     return subProdMap;
    }
    
    /*----------------------------------------------------------------------------------
    1. getSubProdTerms
    Description:Used to get subProdTerm detail based on prodIds 
    Param: prodIds
    Output: 
    Returns SubProdTerms List
    ------------------------------------------------------------------------------------*/
    public static list < ccrz__E_SubProdTerm__c > getSubProdTerms(List < string > prodIds) {
     list < ccrz__E_SubProdTerm__c > subProdTerms = [Select Id, Subs_Cost_Multiplier__c,ccrz__InstallmentFrequency__c, OSM_Bill_Freq__c,ccrz__OrderFrequency__c,ccrz__InstallmentCount__c,Billing_Display_Name__c, ccrz__CCProduct__r.ccrz__SKU__c, BillingFrequency_Sequence__c, Subs_Length_Sequence__c,Subs_Year_Multipler__c, ccrz__Enabled__c, 
                                                            ccrz__InstallmentFrequencyUOM__c, Operation__c, FrequncyNumber__c, ccrz__DisplayName__c, ccrz__CCProduct__c 
                                                    from ccrz__E_SubProdTerm__c 
                                                    where ccrz__CCProduct__c = : prodIds];
     return subProdTerms;
    }
    
    /*----------------------------------------------------------------------------------
    1. getCartItems
    Description:Used to get Cart Item detail
    Param: String cartId, String prodSku, Decimal price
    Output: 
    Returns CartItems List
    ------------------------------------------------------------------------------------*/
    public static list < ccrz__E_CartItem__c > getCartItems(String cartId, String prodSku, Decimal price) {
     list < ccrz__E_CartItem__c > cartItems = [Select Id, Custom_Proration_Price__c, withCoTerm__c,Name, ccrz__RecurringPrice__c, ccrz__RecurringPriceSubAmt__c, ccrz__OriginalQuantity__c, Prorated_Price__c,ccrz__Price__c, ccrz__Quantity__c, ccrz__SubProdTerm__c from ccrz__E_CartItem__c where ccrz__Cart__r.ccrz__EncryptedId__c = : cartId and ccrz__Product__r.ccrz__SKU__c = : prodSku and ccrz__Price__c = : price];
     return cartItems;
    }
    
    /*----------------------------------------------------------------------------------
    1. getCartItems
    Description:Used to get Cart Item detail 
    Param: String cartId, String prodSku
    Output: 
    Returns CartItems List
    ------------------------------------------------------------------------------------*/
  //added field OSM_Renewed_Sub_Id__c in query for MP-573
    public static list < ccrz__E_CartItem__c > getCartItems(String cartId, String prodSku) {
     list < ccrz__E_CartItem__c > cartItems = [Select Id, Custom_Proration_Price__c, Name, withCoTerm__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__c,ccrz__RecurringPrice__c,ccrz__RecurringPriceSubAmt__c, Prorated_Price__c, ccrz__Price__c, ccrz__OriginalQuantity__c, ccrz__Quantity__c, 
                                                        ccrz__SubProdTerm__c,ccrz__Product__r.Name //swetha: added product name, ccrz__RequestDate__c & ccrz__DisplayName__c for MP-430 & MP-531
                                                     ,OSM_Renewed_Sub_Id__c 
                                                from ccrz__E_CartItem__c 
                                                where ccrz__Cart__r.ccrz__EncryptedId__c = : cartId 
                                                        and ccrz__Product__r.ccrz__SKU__c = : prodSku];
     return cartItems;
    }
    
    /*----------------------------------------------------------------------------------
    1. getCartItems
    Description:Used to get Cart Item detail 
    Param: String cartId, String prodSku
    Output: 
    Returns CartItems List
    ------------------------------------------------------------------------------------*/
  //added field OSM_Renewed_Sub_Id__c in query for MP-573
    public static list < ccrz__E_CartItem__c > getCartItems(String cartId, Set<String> prodIds) {
     list < ccrz__E_CartItem__c > cartItems = [Select Id, Custom_Proration_Price__c, Name, withCoTerm__c,ccrz__RecurringPrice__c, isRenew__c, ccrz__Product__c, ccrz__RecurringPriceSubAmt__c, ccrz__OriginalQuantity__c, ccrz__Quantity__c, Prorated_Price__c, ccrz__Price__c,
                                                        ccrz__SubProdTerm__c, ccrz__Product__r.Name,Subscription_Expiry_Date__c //swetha: added product name & ccrz__RequestDate__c for MP-430 & MP-531
                                                        ,OSM_Renewed_Sub_Id__c 
                                                from ccrz__E_CartItem__c 
                                                where ccrz__Cart__r.ccrz__EncryptedId__c = : cartId 
                                                        and ccrz__Product__c IN: prodIds];
     return cartItems;
    }
        
    /*----------------------------------------------------------------------------------
    1. getRelatedProd
    Description:Used to get Related Products detail 
    Param: String prodId, String relPrdType
    Output: 
    Returns tRelatedProd List
    ------------------------------------------------------------------------------------*/
    public static list < ccrz__E_RelatedProduct__c > getRelatedProd(String prodId, String relPrdType) {
     list < ccrz__E_RelatedProduct__c > relatedProdls = [SELECT ccrz__Enabled__c, ccrz__EndDate__c, ccrz__RelatedProductGroup__c, ccrz__RelatedProductId__c, ccrz__RelatedProductType__c, 
                                                                ccrz__RelatedProduct__c, ccrz__RelationshipDescription__c, ccrz__Sequence__c, ccrz__ShortDesc__c, ccrz__StartDate__c, Id, Name 
                                                        FROM ccrz__E_RelatedProduct__c 
                                                        where ccrz__Product__c = : prodId];
     return relatedProdls;
    }
    
     
     public static User getUserDetail(String userId){
     
         List<User> users = [Select Profile.UserLicense.Name,ContactId,Name,Contact.FirstName,Contact.LastName,Contact.Phone, Contact.Email, Contact.AccountId,Contact.Account.Name, Contact.Account.CMI_Cid__c,Contact.Account.BillingAddress, IAM_UID__c from User where Id =:userId];
         if(users.size()==1)
            return users[0];
            return new User();
         }
         
      // ccrz.cc_CallContext.currContact.Id
        public static User getUserDetailbyContact(String contactId){
     
         List<User> users = [Select ContactId,FirstName, Lastname, Contact.FirstName,Contact.LastName,Contact.Phone, Contact.Email, Contact.AccountId,Contact.Account.Name, Contact.Account.CMI_Cid__c,Contact.Account.BillingAddress, IAM_UID__c from User where ContactId =:contactId];
         if(users.size()==1)
            return users[0];
            return new User();
         }
    
         public static Contact getContactByUserIdforAdmin(String userId){
            List<Contact> contacts = [SELECT Id,Email,AccountId,Account.CMI_Cid__c,FirstName,LastName,Phone FROM Contact WHERE IAM_Contact_Owner__c =: userId];
            if(contacts.size()==1)
                return contacts[0];
            return new Contact();
         }
    
        
       public static ccrz__E_Subscription__c getActiveSubscription(String productId, String strStore, String userId){
       
           List<ccrz__E_Subscription__c> activeSubs = [SELECT 
                                                            Monthly_Price__c,Quarterly_Price__c,PerDayDnPrice__c,Yearly_Price__c,OneTime_Price__c,   ccrz__Account__c,OSM_Display_Product__c,ccrz__AutoRenew__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__CurrencyISOCode__c,ccrz__EffectiveAccountID__c,
                                                             ccrz__IgnoreInstallmentFrequencyFields__c,ccrz__InstallmentAddress__c,ccrz__InstallmentCountRemaining__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,
                                                             ccrz__InstallmentStatus__c,ccrz__LastRecurringFailure__c,ccrz__OrderAddress__c,ccrz__OrderCountRemaining__c,ccrz__OrderLastDate__c,ccrz__OrderNextDate__c,ccrz__OrderStatus__c,
                                                             ccrz__ParentSubscription__c,ccrz__Quantity__c,ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__Sequence__c,ccrz__SPTInstallmentCount__c,ccrz__SPTInstallmentFrequencyUOM__c,
                                                             ccrz__SPTInstallmentFrequency__c,ccrz__SPTOrderCount__c,ccrz__SPTOrderFrequencyUOM__c,ccrz__SPTOrderFrequency__c,ccrz__SPTRecurringPricePercentage__c,ccrz__SPTUpfrontPricePercentage__c,
                                                             ccrz__SPT__c,ccrz__StoredPayment__c,ccrz__Storefront__c,ccrz__SubscriptionId__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionStatus__c,ccrz__User__c,Id,Name,OwnerId 
                                                        FROM ccrz__E_Subscription__c
                                                        where ccrz__SubscriptionProduct__c =: productId
                                                                and ccrz__SubscriptionStatus__c =: Label.OSM_Active_Subscription
                                                                and ccrz__Storefront__c =: strStore
                                                                and ccrz__User__c =:  userId];
       
               if(activeSubs.size() ==1)
               return activeSubs[0];
               return new ccrz__E_Subscription__c();
       }
       
       public static  ccrz__E_RequestForQuote__c getUsersQuote(String UserId,String store,Set<String> prodIds, String strStatus){
       
                 List<ccrz__E_RequestForQuote__c >RFQlst  = [Select Id, Name, Cost_Subscription__c, Billing_Period__c, CC_SubProdTerm__c, Discounted_Price__c, CC_Product__c, Status__c,ccrz__Storefront__c, OSM_CommunityUser__c
                                                             from ccrz__E_RequestForQuote__c 
                                                             where (OSM_CommunityUser__c =: UserId or createdById =: UserId)
                                                             and CC_Product__c IN: prodIds
                                                             and Status__c =: strStatus 
                                                             and ccrz__Storefront__c =: store order by createdDate desc];
                   if(RFQlst.size() > 0)
               return RFQlst[0];
               return new ccrz__E_RequestForQuote__c();
       }
         
      
        public static  ccrz__E_RequestForQuote__c getAccountProductQuote(String accountId,String store,Set<String> prodIds, Set<String> strStatus){
       
                 List<ccrz__E_RequestForQuote__c >RFQlst  = getAccountProductsQuotes(accountId,store,prodIds,strStatus);
                   if(RFQlst.size() > 0) 
               return RFQlst[0];
               return new ccrz__E_RequestForQuote__c();
       }
        
     public static  List<ccrz__E_RequestForQuote__c> getAccountProductsQuotes(String accountId,String store,Set<String> prodIds, Set<String> strStatus){
         
         return  [Select Id, Name, Cost_Subscription__c, Billing_Period__c, Accept_or_Reject_Date__c, CC_SubProdTerm__c, Discounted_Price__c, CC_Product__c, Status__c,ccrz__Storefront__c, OSM_CommunityUser__c
                                                             from ccrz__E_RequestForQuote__c 
                                                             where ccrz__Account__c =: accountId
                                                             and CC_Product__c IN: prodIds
                                                             and Status__c IN: strStatus 
                                                             and ccrz__Storefront__c =: store order by createdDate desc];
         
     }
        
        
        public static  List<ccrz__E_RequestForQuote__c> getAccountsQuote(Set<String> accountId,Set<String> strStatus, Set<String> Owners){
       
                 List<ccrz__E_RequestForQuote__c >RFQlst  = [Select Id, Name, OwnerId, Cost_Subscription__c, OSM_Sales_Admin__c, Billing_Period__c, Accept_or_Reject_Date__c, CC_SubProdTerm__c, Discounted_Price__c, CC_Product__c, Status__c,ccrz__Storefront__c, OSM_CommunityUser__c
                                                             from ccrz__E_RequestForQuote__c 
                                                             where ccrz__Account__c IN: accountId
                                                             and OwnerId IN: Owners
                                                             and Status__c IN: strStatus 
                                                             ];
                system.debug('RFQlst----------->'+RFQlst);
               return RFQlst; 
       }
        
        public static  List<ccrz__E_RequestForQuote__c> getAccountProductQuotes(String accountId,String store,Set<String> prodIds, Set<String> strStatus){
       
                 List<ccrz__E_RequestForQuote__c >RFQlst  = [Select Id, Name, Cost_Subscription__c, Billing_Period__c, Accept_or_Reject_Date__c, CC_SubProdTerm__c, Discounted_Price__c, CC_Product__c, Status__c,ccrz__Storefront__c, OSM_CommunityUser__c
                                                             from ccrz__E_RequestForQuote__c 
                                                             where ccrz__Account__c =: accountId
                                                             and CC_Product__c IN: prodIds
                                                             and Status__c IN: strStatus 
                                                              and ccrz__Storefront__c =: store order by createdDate desc];
                   return RFQlst;
       }
       
       public static  ccrz__E_RequestForQuote__c getUsersQuote(String UserId,String store,Set<String> prodIds){
       
                 List<ccrz__E_RequestForQuote__c >RFQlst  = [Select Id, Name, Cost_Subscription__c, Billing_Period__c, CC_SubProdTerm__c, Discounted_Price__c, CC_Product__c, Status__c,ccrz__Storefront__c, OSM_CommunityUser__c
                                                             from ccrz__E_RequestForQuote__c 
                                                             where (OSM_CommunityUser__c =: UserId or createdById =: UserId)
                                                             and CC_Product__c IN: prodIds
                                                             and ccrz__Storefront__c =: store order by createdDate desc];
                   if(RFQlst.size() > 0)
               return RFQlst[0];
               return new ccrz__E_RequestForQuote__c();
       }
       
       
       public static ccrz__E_Cart__c getUsersCart(String encId){
    
        list<ccrz__E_Cart__c> carts = [select Id, ccrz__EncryptedId__c from ccrz__E_Cart__c  where ccrz__EncryptedId__c =: encId];
        if(carts.size()>0){
            return carts[0];
        }
        return new ccrz__E_Cart__c();
    }
     
        public static ccrz__E_CartItem__c getUsersCartItem(String enCartId, String parentProdId, Set<String> childProdId, String store, String contactId){
    
        list<ccrz__E_CartItem__c> carts = [SELECT Actual_Tax__c,Billing_Frequency__c,ccrz__SubProdTerm__r.ccrz__DisplayName__c ,ccrz__AbsoluteDiscount__c,ccrz__AdjustmentAmount__c,ccrz__AvailabilityMessage__c,
                                               ccrz__CartItemGroup__c,ccrz__CartItemId__c,ccrz__cartItemType__c,ccrz__Cart__c,ccrz__Category__c,ccrz__Comments__c,
                                               ccrz__Coupon__c,ccrz__DisplayProduct__c,ccrz__ExtName__c,ccrz__ExtSKU__c,ccrz__Is_Subscription_Selected__c,
                                               ccrz__ItemLabel__c,ccrz__ItemStatus__c,ccrz__ItemTotal__c,ccrz__OriginalItemPrice__c,ccrz__OriginalQuantity__c,
                                               ccrz__ParentCartItem__c,ccrz__ParentProduct__c,ccrz__PercentDiscount__c,ccrz__Price__c,ccrz__PricingModifierTypes__c,
                                               ccrz__PricingType__c,ccrz__PrimaryAttr__c,ccrz__ProductType__c,ccrz__Product__c,ccrz__Quantity__c,
                                               ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__RequestDate__c,ccrz__SecondaryAttr__c,
                                               ccrz__SelectedAttr__c,ccrz__Seller__c,ccrz__StoreID__c,ccrz__SubAmount__c,ccrz__SubProdTerm__c,
                                               ccrz__Subscription_Duration__c,ccrz__Subscription_Frequency__c,ccrz__TertiaryAttr__c,
                                               ccrz__UnitOfMeasure__c,Vertex_tax__c,ccrz__SubProdTerm__r.OSM_Bill_Freq__c,OSM_Primary_Cart_Item__c
                                       FROM ccrz__E_CartItem__c 
                                       where ccrz__DisplayProduct__c =: parentProdId
                                            and ccrz__Product__c IN:childProdId 
                                            and ccrz__Cart__r.ccrz__EncryptedId__c =:enCartId
                                            and ccrz__StoreID__c =: store
                                          and ccrz__Cart__r.ccrz__CartStatus__c =:'Open'
                                          and ccrz__Cart__r.ccrz__CartType__c =: 'Cart'
                                          and ccrz__Cart__r.ccrz__ActiveCart__c =:true
                                          and ccrz__Cart__r.ccrz__Contact__c =: contactId
                                          ];
        if(carts.size()>0){
            return carts[0];
        }
        return new ccrz__E_CartItem__c();
    }
        
        /**
        **
        **/
        public static List<ccrz__E_CartItem__c> getUsersCartItemListExceptCurrentProduct(Set<String> childProdId, String store, String accountId){
     
        list<ccrz__E_CartItem__c> carts = [SELECT Actual_Tax__c,Billing_Frequency__c,ccrz__SubProdTerm__r.ccrz__DisplayName__c ,ccrz__AbsoluteDiscount__c,ccrz__AdjustmentAmount__c,ccrz__AvailabilityMessage__c,
                                               ccrz__CartItemGroup__c,ccrz__CartItemId__c,ccrz__cartItemType__c,ccrz__Cart__c,ccrz__Category__c,ccrz__Comments__c,
                                               ccrz__Coupon__c,ccrz__DisplayProduct__c,ccrz__ExtName__c,ccrz__ExtSKU__c,ccrz__Is_Subscription_Selected__c,
                                               ccrz__ItemLabel__c,ccrz__ItemStatus__c,ccrz__ItemTotal__c,ccrz__OriginalItemPrice__c,ccrz__OriginalQuantity__c,
                                               ccrz__ParentCartItem__c,ccrz__ParentProduct__c,ccrz__PercentDiscount__c,ccrz__Price__c,ccrz__PricingModifierTypes__c,
                                               ccrz__PricingType__c,ccrz__PrimaryAttr__c,ccrz__ProductType__c,ccrz__Product__c,ccrz__Quantity__c,
                                               ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__RequestDate__c,ccrz__SecondaryAttr__c,
                                               ccrz__SelectedAttr__c,ccrz__Seller__c,ccrz__StoreID__c,ccrz__SubAmount__c,ccrz__SubProdTerm__c,
                                               ccrz__Subscription_Duration__c,ccrz__Subscription_Frequency__c,ccrz__TertiaryAttr__c,
                                               ccrz__UnitOfMeasure__c,Vertex_tax__c, ccrz__SubProdTerm__r.OSM_Bill_Freq__c 
                                       FROM ccrz__E_CartItem__c 
                                       where
                                           ccrz__Product__c NOT IN:childProdId 
                                           and ccrz__StoreID__c =: store
                                          and ccrz__Cart__r.ccrz__CartStatus__c =:'Open'
                                          and ccrz__Cart__r.ccrz__CartType__c =: 'Cart'
                                          and ccrz__Cart__r.ccrz__ActiveCart__c =:true
                                          and ccrz__Cart__r.ccrz__Account__c =: accountId
                                          and OSM_Primary_Cart_Item__c =: true 
                                          ];
    
        return carts;
    }
        
        
      /**
        **
        **/
        public static List<ccrz__E_CartItem__c> getUsersCartItemListExceptCurrentProduct(String store, String accountId){
     
        list<ccrz__E_CartItem__c> carts = [SELECT Actual_Tax__c,Billing_Frequency__c,ccrz__SubProdTerm__r.ccrz__DisplayName__c ,ccrz__AbsoluteDiscount__c,ccrz__AdjustmentAmount__c,ccrz__AvailabilityMessage__c,
                                               ccrz__CartItemGroup__c,ccrz__CartItemId__c,ccrz__cartItemType__c,ccrz__Cart__c,ccrz__Category__c,ccrz__Comments__c,
                                               ccrz__Coupon__c,ccrz__DisplayProduct__c,ccrz__ExtName__c,ccrz__ExtSKU__c,ccrz__Is_Subscription_Selected__c,
                                               ccrz__ItemLabel__c,ccrz__ItemStatus__c,ccrz__ItemTotal__c,ccrz__OriginalItemPrice__c,ccrz__OriginalQuantity__c,
                                               ccrz__ParentCartItem__c,ccrz__ParentProduct__c,ccrz__PercentDiscount__c,ccrz__Price__c,ccrz__PricingModifierTypes__c,
                                               ccrz__PricingType__c,ccrz__PrimaryAttr__c,ccrz__ProductType__c,ccrz__Product__c,ccrz__Quantity__c,
                                               ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__RequestDate__c,ccrz__SecondaryAttr__c,
                                               ccrz__SelectedAttr__c,ccrz__Seller__c,ccrz__StoreID__c,ccrz__SubAmount__c,ccrz__SubProdTerm__c,
                                               ccrz__Subscription_Duration__c,ccrz__Subscription_Frequency__c,ccrz__TertiaryAttr__c,
                                               ccrz__UnitOfMeasure__c,Vertex_tax__c, ccrz__SubProdTerm__r.OSM_Bill_Freq__c 
                                       FROM ccrz__E_CartItem__c 
                                       where
                                          ccrz__StoreID__c =: store
                                          and ccrz__Cart__r.ccrz__CartStatus__c =:'Open'
                                          and ccrz__Cart__r.ccrz__CartType__c =: 'Cart'
                                          and ccrz__Cart__r.ccrz__ActiveCart__c =:true
                                          and ccrz__Cart__r.ccrz__Account__c =: accountId
                                          and OSM_Primary_Cart_Item__c =: true 
                                          ];
    
        return carts;
    }
        
        
        /**
         **  getAccount to return account with preferred billing frequency.
         ** @param AccountId
        **/
        public static Account getAccount(String AccountId){
                List<Account> accounts = [Select AccountNumber,BMS_Customer_ID__c,BOLT_Account_Number__c,AccountSource,AnnualRevenue,BillingAddress,BillingCity,BillingCountry,
                                          BillingGeocodeAccuracy,BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStreet,
                                          ccrz__CustomField1__c,ccrz__CustomField2__c,ccrz__E_AccountGroup__c,
                                          ccrz__PreventAddrBookSave__c,ccrz__PreventNewAddrCheckout__c,ccrz__PreventNewBillAddrCO__c,ccrz__SourceSystem__c,Is_Training_Account__c,Is_Internal_Account__c,Is_OEM_Acount__c,
                                          ccrz__TaxExemptAccount__c,ccrz__UsedByCloudcraze__c,Description,Id,Is_Active_Subscription_Exists__c,
                                          LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Location__c,MasterRecordId,
                                          Name,Next_Invoice_Generation_Date__c,NumberOfEmployees,OSM_Market_Segment_Code__c,
                                          OSM_Preferred_Billing_Frequency_Lock__c,OSM_Preferred_Billing_Frequency__c,OSM_Preferred_Payment_Method__c,
                                          ShippingAddress,ShippingCity,ShippingCountry,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,
                                          ShippingPostalCode,ShippingState,ShippingStreet, Type, OSM_HHP_Dealer__c,EngineRangeDesc__c, DTNA__c, 
                                          Vertex_Customer_Class_Code__c,Website, IAM_Cummins_Support_User__r.ManagerId,CHANNEL_OF_DISTRIBUTION__c,GroupemailID__c,CSS_DistributorCode__c,CMI_Account_Status__c,Business_Unit__c,OSM_Service_Level__c,ServiceLevel__c,ccrz__E_AccountGroup__r.Name  //Mar-1236
                                      from Account where Id =: AccountId limit 1];
                if(accounts.size()>0){
                    return accounts[0];
                }
            return new Account();
        }
         
        /**
         **  getAccount to return account with preferred billing frequency.
         ** @param AccountId
        **/
        public static Map<Id, Account> getAccountsMap(Set<String> AccountIds){
                return new Map<Id, Account>([Select Id,OSM_Preferred_Billing_Frequency__c, OSM_Preferred_Billing_Frequency_Lock__c, OSM_Preferred_Payment_Method__c, OSM_Market_Segment_Code__c from Account where Id IN: AccountIds]);
        }
        
        
        /**
         **  getAccountCartItem to return List of Account's cart Items.
         ** @param AccountId
        **/
        public static List<ccrz__E_CartItem__c> getAccountCartItem(String store, String accountId){
        System.debug('in method getAccountCartItem : store : '+store);
        System.debug('in method getAccountCartItem : accountId : '+accountId);
        list<ccrz__E_CartItem__c> cartItems = [SELECT Actual_Tax__c,Billing_Frequency__c,ccrz__SubProdTerm__r.ccrz__DisplayName__c ,ccrz__AbsoluteDiscount__c,ccrz__AdjustmentAmount__c,ccrz__AvailabilityMessage__c,
                                               ccrz__CartItemGroup__c,ccrz__CartItemId__c,ccrz__cartItemType__c,ccrz__Cart__c,ccrz__Category__c,ccrz__Comments__c,
                                               ccrz__Coupon__c,ccrz__DisplayProduct__c,ccrz__ExtName__c,ccrz__ExtSKU__c,ccrz__Is_Subscription_Selected__c,
                                               ccrz__ItemLabel__c,ccrz__ItemStatus__c,ccrz__ItemTotal__c,ccrz__OriginalItemPrice__c,ccrz__OriginalQuantity__c,
                                               ccrz__ParentCartItem__c,ccrz__ParentProduct__c,ccrz__PercentDiscount__c,ccrz__Price__c,ccrz__PricingModifierTypes__c,
                                               ccrz__PricingType__c,ccrz__PrimaryAttr__c,ccrz__ProductType__c,ccrz__Product__c,ccrz__Quantity__c,
                                               ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__RequestDate__c,ccrz__SecondaryAttr__c,
                                               ccrz__SelectedAttr__c,ccrz__Seller__c,ccrz__StoreID__c,ccrz__SubAmount__c,ccrz__SubProdTerm__c,
                                               ccrz__Subscription_Duration__c,ccrz__Subscription_Frequency__c,ccrz__TertiaryAttr__c,
                                               ccrz__UnitOfMeasure__c,Vertex_tax__c, ccrz__SubProdTerm__r.OSM_Bill_Freq__c 
                                       FROM ccrz__E_CartItem__c 
                                       where ccrz__StoreID__c =: store
                                          and ccrz__Cart__r.ccrz__CartStatus__c =:'Open'
                                          and ccrz__Cart__r.ccrz__CartType__c =: 'Cart'
                                          and ccrz__Cart__r.ccrz__ActiveCart__c =:true
                                          and ccrz__Product__r.Group_Name__c =: 'DA'     
                                          and ccrz__Cart__r.ccrz__Account__c =: accountId order by createddate desc
                                              ];
                                              
            System.debug('cartItems.size() : '+cartItems.size());
            if(cartItems.size()>0){
                return cartItems;
            }
            return new List<ccrz__E_CartItem__c>();
        }
        
     /**
         **  getAccountCartItem to return List of Account's cart Items.
         ** @param AccountId
        **/
        public static List<ccrz__E_CartItem__c> getAccountCartItem(Set<String> accountIds, Set<String> storeIds, Set<String> cartItemIds){
    
        list<ccrz__E_CartItem__c> cartItems = [SELECT Actual_Tax__c,ccrz__Cart__r.ccrz__Account__c,Billing_Frequency__c,ccrz__SubProdTerm__r.ccrz__DisplayName__c ,ccrz__AbsoluteDiscount__c,ccrz__AdjustmentAmount__c,ccrz__AvailabilityMessage__c,
                                               ccrz__CartItemGroup__c,ccrz__CartItemId__c,ccrz__cartItemType__c,ccrz__Cart__c,ccrz__Category__c,ccrz__Comments__c,
                                               ccrz__Coupon__c,ccrz__DisplayProduct__c,ccrz__ExtName__c,ccrz__ExtSKU__c,ccrz__Is_Subscription_Selected__c,
                                               ccrz__ItemLabel__c,ccrz__ItemStatus__c,ccrz__ItemTotal__c,ccrz__OriginalItemPrice__c,ccrz__OriginalQuantity__c,
                                               ccrz__ParentCartItem__c,ccrz__ParentProduct__c,ccrz__PercentDiscount__c,ccrz__Price__c,ccrz__PricingModifierTypes__c,
                                               ccrz__PricingType__c,ccrz__PrimaryAttr__c,ccrz__ProductType__c,ccrz__Product__c,ccrz__Quantity__c,
                                               ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__RequestDate__c,ccrz__SecondaryAttr__c,
                                               ccrz__SelectedAttr__c,ccrz__Seller__c,ccrz__StoreID__c,ccrz__SubAmount__c,ccrz__SubProdTerm__c,
                                               ccrz__Subscription_Duration__c,ccrz__Subscription_Frequency__c,ccrz__TertiaryAttr__c,
                                               ccrz__UnitOfMeasure__c,Vertex_tax__c, ccrz__SubProdTerm__r.OSM_Bill_Freq__c 
                                       FROM ccrz__E_CartItem__c 
                                       where  Id NOT IN: cartItemIds
                                          and ccrz__Cart__r.ccrz__CartStatus__c =:'Open'
                                          and ccrz__StoreID__c IN: storeIds
                                          and ccrz__Cart__r.ccrz__CartType__c =: 'Cart'
                                          and ccrz__Cart__r.ccrz__ActiveCart__c =:true
                                          and ccrz__Cart__r.ccrz__Account__c IN: accountIds order by createddate desc
                                              ];
            if(cartItems.size()>0){
                return cartItems;
            }
            return new List<ccrz__E_CartItem__c>();
        }
      
        /**
        ** getAccountSubscription
        **/ 
        public static List<ccrz__E_Subscription__c> getAccountSubscription(String accountId,String storefront){
            List<ccrz__E_Subscription__c> accountsubscriptions = 
                [
                    SELECT ccrz__Account__c,ccrz__SubscriptionProduct__r.QSOL_Power_Generation__c,ccrz__SubscriptionProduct__r.Group_Name__c, ccrz__SubscriptionProduct__r.Name,ccrz__AutoRenew__c,OneTime_Dn_Price__c,Quarterly_Dn_Price__c,Monthly_Dn_Price__c,Yearly_Dn_Price__c,OneTimePerDayPrice__c,PerDayDnPrice__c,Monthly_Price__c,Quarterly_Price__c,Yearly_Price__c,OneTime_Price__c,OSM_Display_Product__c,Purchase_Date__c,Next_Invoice_Generation_Date__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__CurrencyISOCode__c,
                            ccrz__EffectiveAccountID__c,ccrz__IgnoreInstallmentFrequencyFields__c,ccrz__InstallmentAddress__c,
                            ccrz__InstallmentCountRemaining__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,
                            ccrz__InstallmentStatus__c,ccrz__LastRecurringFailure__c,ccrz__OrderAddress__c,ccrz__OrderCountRemaining__c,
                            ccrz__OrderLastDate__c,ccrz__OrderNextDate__c,ccrz__OrderStatus__c,ccrz__ParentSubscription__c,ccrz__Quantity__c,
                            ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__Sequence__c,ccrz__SPTInstallmentCount__c,
                            ccrz__SPTInstallmentFrequencyUOM__c,ccrz__SPTInstallmentFrequency__c,ccrz__SPTOrderCount__c,ccrz__SPTOrderFrequencyUOM__c,
                            ccrz__SPTOrderFrequency__c,ccrz__SPTRecurringPricePercentage__c,ccrz__SPTUpfrontPricePercentage__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,
                            ccrz__StoredPayment__c,ccrz__Storefront__c,ccrz__SubscriptionId__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,
                            ccrz__SubscriptionStatus__c,ccrz__User__c,OSM_Free_Trial__c,OSM_Subscription_End_Date__c,OSM_SW_Free_Trial_Extended_Count__c,
                            OSM_SW_Free_Trial_ModifiedBy__c,OwnerId,ccrz__SPT__r.ccrz__DisplayName__c,Last_Installment_Generated__c,ccrz__SPT__r.ccrz__OrderFrequency__c
                    FROM ccrz__E_Subscription__c
                    where ccrz__Account__c =: accountId
                        and ccrz__Storefront__c =: storefront
                        and OSM_Subscription_End_Date__c >: System.today()
                        and OSM_Free_Trial__c = false
                        and ccrz__SubscriptionStatus__c =: 'Active'
                        and OSM_SW_Is_without_Coterm__c = false
                        //and Last_Installment_Generated__c =: false
                        order by createddate asc];
            return accountsubscriptions;
        }
        
        /**
        ** getAccountSubscription
        **/ 
        /*public static List<ccrz__E_Subscription__c> getAccountFreeTrialSubscription(String accountId,String storefront){
            List<ccrz__E_Subscription__c> accountsubscriptions = 
                [
                    SELECT ccrz__Account__c,ccrz__AutoRenew__c,Monthly_Price__c,PerDayDnPrice__c,Quarterly_Price__c,PerDayDnPrice__c,Yearly_Price__c,OneTime_Price__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__CurrencyISOCode__c,
                            ccrz__EffectiveAccountID__c,ccrz__IgnoreInstallmentFrequencyFields__c,ccrz__InstallmentAddress__c,
                            ccrz__InstallmentCountRemaining__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,
                            ccrz__InstallmentStatus__c,ccrz__LastRecurringFailure__c,ccrz__OrderAddress__c,ccrz__OrderCountRemaining__c,
                            ccrz__OrderLastDate__c,ccrz__OrderNextDate__c,ccrz__OrderStatus__c,ccrz__ParentSubscription__c,ccrz__Quantity__c,
                            ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__Sequence__c,ccrz__SPTInstallmentCount__c,
                            ccrz__SPTInstallmentFrequencyUOM__c,ccrz__SPTInstallmentFrequency__c,ccrz__SPTOrderCount__c,ccrz__SPTOrderFrequencyUOM__c,
                            ccrz__SPTOrderFrequency__c,ccrz__SPTRecurringPricePercentage__c,ccrz__SPTUpfrontPricePercentage__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,
                            ccrz__StoredPayment__c,ccrz__Storefront__c,ccrz__SubscriptionId__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,
                            ccrz__SubscriptionStatus__c,ccrz__User__c,OSM_Free_Trial__c,OSM_Subscription_End_Date__c,OSM_SW_Free_Trial_Extended_Count__c,
                            OSM_SW_Free_Trial_ModifiedBy__c,OwnerId,ccrz__SPT__r.ccrz__DisplayName__c,Last_Installment_Generated__c,ccrz__SPT__r.ccrz__OrderFrequency__c
                    FROM ccrz__E_Subscription__c
                    where ccrz__Account__c =: accountId
                        and ccrz__Storefront__c =: storefront
                        and OSM_Subscription_End_Date__c >: System.today()
                        and OSM_Free_Trial__c = true
                        and ccrz__SubscriptionStatus__c =: 'Active'
                        order by createddate desc];
            return accountsubscriptions;
        }*/
        
        /**
        ** getAccountSubscription
        **/ 
        public static List<ccrz__E_Subscription__c> getAccountSubscriptionWithoutOneTime(String accountId,String storefront){
            List<ccrz__E_Subscription__c> accountsubscriptions = 
                [
                    SELECT ccrz__Account__c,OSM_Display_Product__c,ccrz__AutoRenew__c,PerDayDnPrice__c,Next_Invoice_Generation_Date__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__CurrencyISOCode__c,Monthly_Price__c,Quarterly_Price__c,Yearly_Price__c,OneTime_Price__c,
                            ccrz__EffectiveAccountID__c,ccrz__IgnoreInstallmentFrequencyFields__c,ccrz__InstallmentAddress__c,
                            ccrz__InstallmentCountRemaining__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,
                            ccrz__InstallmentStatus__c,ccrz__LastRecurringFailure__c,ccrz__OrderAddress__c,ccrz__OrderCountRemaining__c,
                            ccrz__OrderLastDate__c,ccrz__OrderNextDate__c,ccrz__OrderStatus__c,ccrz__ParentSubscription__c,ccrz__Quantity__c,
                            ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__Sequence__c,ccrz__SPTInstallmentCount__c,
                            ccrz__SPTInstallmentFrequencyUOM__c,ccrz__SPTInstallmentFrequency__c,ccrz__SPTOrderCount__c,ccrz__SPTOrderFrequencyUOM__c,
                            ccrz__SPTOrderFrequency__c,ccrz__SPTRecurringPricePercentage__c,ccrz__SPTUpfrontPricePercentage__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,
                            ccrz__StoredPayment__c,ccrz__Storefront__c,ccrz__SubscriptionId__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,
                            ccrz__SubscriptionStatus__c,ccrz__User__c,OSM_Free_Trial__c,OSM_Subscription_End_Date__c,OSM_SW_Free_Trial_Extended_Count__c,
                            OSM_SW_Free_Trial_ModifiedBy__c,OwnerId,ccrz__SPT__r.ccrz__DisplayName__c,Last_Installment_Generated__c
                    FROM ccrz__E_Subscription__c
                    where ccrz__Account__c =: accountId
                        and ccrz__Storefront__c =: storefront
                        and OSM_Subscription_End_Date__c >: System.today()
                        and OSM_Free_Trial__c = false
                        and ccrz__Quantity__c > 0
                        and ccrz__SubscriptionStatus__c =: 'Active'
                        and Last_Installment_Paid__c =: false
                        and ccrz__SPT__r.Billing_Display_Name__c != 'One Time'
                        order by createddate desc];
            return accountsubscriptions;
        }
        /**
        ** getAccountSubscription
        **/ 
        public static List<ccrz__E_Subscription__c> getAccountSubscriptionWithoutOneTime(Set<String> accountId,Set<String> storefront){
            List<ccrz__E_Subscription__c> accountsubscriptions = 
                [
                    SELECT ccrz__Account__c,OSM_Display_Product__c,Monthly_Price__c,PerDayDnPrice__c,Quarterly_Price__c,Yearly_Price__c,OneTime_Price__c, ccrz__AutoRenew__c,Next_Invoice_Generation_Date__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__CurrencyISOCode__c,
                            ccrz__EffectiveAccountID__c,ccrz__IgnoreInstallmentFrequencyFields__c,ccrz__InstallmentAddress__c,
                            ccrz__InstallmentCountRemaining__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,
                            ccrz__InstallmentStatus__c,ccrz__LastRecurringFailure__c,ccrz__OrderAddress__c,ccrz__OrderCountRemaining__c,
                            ccrz__OrderLastDate__c,ccrz__OrderNextDate__c,ccrz__OrderStatus__c,ccrz__ParentSubscription__c,ccrz__Quantity__c,
                            ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__Sequence__c,ccrz__SPTInstallmentCount__c,
                            ccrz__SPTInstallmentFrequencyUOM__c,ccrz__SPTInstallmentFrequency__c,ccrz__SPTOrderCount__c,ccrz__SPTOrderFrequencyUOM__c,
                            ccrz__SPTOrderFrequency__c,ccrz__SPTRecurringPricePercentage__c,ccrz__SPTUpfrontPricePercentage__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,
                            ccrz__StoredPayment__c,ccrz__Storefront__c,ccrz__SubscriptionId__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,
                            ccrz__SubscriptionStatus__c,ccrz__User__c,OSM_Free_Trial__c,OSM_Subscription_End_Date__c,OSM_SW_Free_Trial_Extended_Count__c,
                            OSM_SW_Free_Trial_ModifiedBy__c,OwnerId,ccrz__SPT__r.ccrz__DisplayName__c,Last_Installment_Generated__c
                    FROM ccrz__E_Subscription__c
                    where ccrz__Account__c IN: accountId
                        and ccrz__Storefront__c IN: storefront
                        and OSM_Subscription_End_Date__c >: System.today()
                        and OSM_Free_Trial__c = false
                        and ccrz__Quantity__c > 0
                        and ccrz__SubscriptionStatus__c =: 'Active'
                        and Last_Installment_Paid__c =: false
                        and ccrz__SPT__r.Billing_Display_Name__c != 'One Time'
                        order by createddate desc];
            return accountsubscriptions;
        }
        
        /**
        ** getAccountSubscription
        **/ 
        public static List<ccrz__E_Subscription__c> getAccountSubscription(String accountId, Set<String> productIds, String storefront){
            List<ccrz__E_Subscription__c> accountsubscriptions = 
                [
                    SELECT ccrz__Account__c,OSM_Display_Product__c,PerDayDnPrice__c,OneTime_Dn_Price__c,Quarterly_Dn_Price__c,Monthly_Dn_Price__c,Yearly_Dn_Price__c,ccrz__AutoRenew__c,Next_Invoice_Generation_Date__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__CurrencyISOCode__c,Monthly_Price__c,Quarterly_Price__c,Yearly_Price__c,OneTime_Price__c,
                            ccrz__EffectiveAccountID__c,ccrz__IgnoreInstallmentFrequencyFields__c,ccrz__InstallmentAddress__c,
                            ccrz__InstallmentCountRemaining__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,
                            ccrz__InstallmentStatus__c,ccrz__LastRecurringFailure__c,ccrz__OrderAddress__c,ccrz__OrderCountRemaining__c,
                            ccrz__OrderLastDate__c,ccrz__OrderNextDate__c,ccrz__OrderStatus__c,ccrz__ParentSubscription__c,ccrz__Quantity__c,
                            ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__Sequence__c,ccrz__SPTInstallmentCount__c,
                            ccrz__SPTInstallmentFrequencyUOM__c,ccrz__SPTInstallmentFrequency__c,ccrz__SPTOrderCount__c,ccrz__SPTOrderFrequencyUOM__c,
                            ccrz__SPTOrderFrequency__c,ccrz__SPTRecurringPricePercentage__c,ccrz__SPTUpfrontPricePercentage__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,
                            ccrz__StoredPayment__c,ccrz__Storefront__c,ccrz__SubscriptionId__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,
                            ccrz__SubscriptionStatus__c,ccrz__User__c,OSM_Free_Trial__c,OSM_Subscription_End_Date__c,OSM_SW_Free_Trial_Extended_Count__c,
                            OSM_SW_Free_Trial_ModifiedBy__c,OwnerId,ccrz__SPT__r.ccrz__DisplayName__c,Last_Installment_Generated__c
                    FROM ccrz__E_Subscription__c
                    where ccrz__Account__c =: accountId
                        and ccrz__Storefront__c =: storefront
                        and OSM_Subscription_End_Date__c >: System.today()
                        and OSM_Free_Trial__c = false
                        and ccrz__SubscriptionStatus__c =: 'Active'
                        and Last_Installment_Generated__c =: false
                        and OSM_SW_Is_without_Coterm__c = false
                        and ccrz__SubscriptionProduct__c IN: productIds order by createddate desc];
            return accountsubscriptions;
        }
        
        
        /**
        ** getAccountSubscription
        **/ 
        public static List<ccrz__E_Subscription__c> getAccountProductFreeTrialSubscription(String accountId, Set<String> productIds, String storefront){
            List<ccrz__E_Subscription__c> accountsubscriptions = 
                [
                    SELECT ccrz__Account__c,ccrz__Account__r.OSM_Preferred_Payment_Method__c,OneTime_Dn_Price__c,Quarterly_Dn_Price__c,Monthly_Dn_Price__c,Yearly_Dn_Price__c,PerDayDnPrice__c,OSM_Display_Product__c,ccrz__AutoRenew__c,Next_Invoice_Generation_Date__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__CurrencyISOCode__c,Monthly_Price__c,Quarterly_Price__c,Yearly_Price__c,OneTime_Price__c,
                            ccrz__EffectiveAccountID__c,ccrz__IgnoreInstallmentFrequencyFields__c,ccrz__InstallmentAddress__c,
                            ccrz__InstallmentCountRemaining__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,
                            ccrz__InstallmentStatus__c,ccrz__LastRecurringFailure__c,ccrz__OrderAddress__c,ccrz__OrderCountRemaining__c,
                            ccrz__OrderLastDate__c,ccrz__OrderNextDate__c,ccrz__OrderStatus__c,ccrz__ParentSubscription__c,ccrz__Quantity__c,
                            ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__Sequence__c,ccrz__SPTInstallmentCount__c,
                            ccrz__SPTInstallmentFrequencyUOM__c,ccrz__SPTInstallmentFrequency__c,ccrz__SPTOrderCount__c,ccrz__SPTOrderFrequencyUOM__c,
                            ccrz__SPTOrderFrequency__c,ccrz__SPTRecurringPricePercentage__c,ccrz__SPTUpfrontPricePercentage__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,
                            ccrz__StoredPayment__c,ccrz__Storefront__c,ccrz__SubscriptionId__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,
                            ccrz__SubscriptionStatus__c,ccrz__User__c,OSM_Free_Trial__c,OSM_Subscription_End_Date__c,OSM_SW_Free_Trial_Extended_Count__c,
                            OSM_SW_Free_Trial_ModifiedBy__c,OwnerId,ccrz__SPT__r.ccrz__DisplayName__c,Last_Installment_Generated__c
                    FROM ccrz__E_Subscription__c
                    where ccrz__Account__c =: accountId
                        and ccrz__Storefront__c =: storefront
                        and OSM_Free_Trial__c = true
                        and OSM_Subscription_End_Date__c >: System.today()
                        and ccrz__SubscriptionStatus__c =: 'Active'
                        and ccrz__SubscriptionProduct__c IN: productIds order by createddate desc];
            return accountsubscriptions;
        }
     
        /**
        ** getAccountSubscription
        **/ 
        public static List<ccrz__E_Subscription__c> getAccountProductSubsWithFreeTrial(String accountId, Set<String> productIds, String storefront){
            List<ccrz__E_Subscription__c> accountsubscriptions = 
                [
                    SELECT Subsequent_Next_Invoice_Due_Dt__c,OSM_SW_Is_without_Coterm__c,ccrz__Account__r.ccrz__E_AccountGroup__c,OneTime_Dn_Price__c,Quarterly_Dn_Price__c,Monthly_Dn_Price__c,Yearly_Dn_Price__c,PerDayDnPrice__c,OneTimePerDayPrice__c,Purchase_Date__c,Subsequent_Next_Invoice_Generation_Dt__c,
                           Monthly_Price__c,Quarterly_Price__c,Yearly_Price__c,OneTime_Price__c, ccrz__Account__c,OSM_Display_Product__r.Name,OSM_Display_Product__c,Recurring_Invoice_Start_Date__c,ccrz__Account__r.OSM_Preferred_Payment_Method__c,ccrz__AutoRenew__c,Next_Invoice_Generation_Date__c,ccrz__CCOrderItem__r.ccrz__Price__c,ccrz__CCOrderItem__r.ccrz__DisplayProduct__c,
                            ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__CCOrderItem__r.ccrz__Quantity__c,ccrz__Comments__c,ccrz__CurrencyISOCode__c,
                            ccrz__EffectiveAccountID__c,ccrz__IgnoreInstallmentFrequencyFields__c,ccrz__InstallmentAddress__c,
                            ccrz__InstallmentCountRemaining__c,ccrz__InstallmentLastDate__c,ccrz__InstallmentNextDate__c,
                            ccrz__InstallmentStatus__c,ccrz__LastRecurringFailure__c,ccrz__OrderAddress__c,ccrz__OrderCountRemaining__c,
                            ccrz__OrderLastDate__c,ccrz__OrderNextDate__c,ccrz__OrderStatus__c,ccrz__ParentSubscription__c,ccrz__Quantity__c,
                            ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__Sequence__c,ccrz__SPTInstallmentCount__c,
                            ccrz__SPTInstallmentFrequencyUOM__c,ccrz__SPTInstallmentFrequency__c,ccrz__SPTOrderCount__c,ccrz__SPTOrderFrequencyUOM__c,
                            ccrz__SPTOrderFrequency__c,ccrz__SPTRecurringPricePercentage__c,ccrz__SPTUpfrontPricePercentage__c,ccrz__SPT__c,ccrz__SPT__r.Billing_Display_Name__c,
                            ccrz__StoredPayment__c,ccrz__Storefront__c,ccrz__SubscriptionId__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,
                            ccrz__SubscriptionStatus__c,ccrz__User__c,OSM_Free_Trial__c,OSM_Subscription_End_Date__c,OSM_SW_Free_Trial_Extended_Count__c,
                            OSM_SW_Free_Trial_ModifiedBy__c,CreatedDate,OwnerId,ccrz__SPT__r.ccrz__OrderFrequency__c,ccrz__SPT__r.ccrz__DisplayName__c,Last_Installment_Generated__c
                    FROM ccrz__E_Subscription__c
                    where ccrz__Account__c =: accountId
                        and ccrz__Storefront__c =: storefront
                        and OSM_Subscription_End_Date__c >: System.today()
                        and ccrz__SubscriptionStatus__c =: 'Active'
                        and OSM_SW_Is_without_Coterm__c = false
                        and ccrz__SubscriptionStartDate__c <=: DateTime.now()
                    order by OSM_Free_Trial__c asc];
            return accountsubscriptions;
        }
        
    /**
    ** 
    **/
        Public static List<ccrz__E_Subscription__c> getSubscriptions(List<Id> Ids){
            
           return [ SELECT Monthly_Price__c,Quarterly_Price__c,OneTime_Dn_Price__c,Quarterly_Dn_Price__c,Monthly_Dn_Price__c,Yearly_Dn_Price__c,PerDayDnPrice__c,Yearly_Price__c,OneTime_Price__c,     
                    ccrz__Account__c,OneTimePerDayPrice__c,OSM_Display_Product__c,Recurring_Invoice_Start_Date__c,ccrz__Account__r.OSM_Preferred_Payment_Method__c, ccrz__AutoRenew__c,Subsequent_Next_Invoice_Generation_Dt__c,ccrz__CCOrderItem__r.ccrz__DisplayProduct__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__CurrencyISOCode__c,ccrz__EffectiveAccountID__c,
                    ccrz__IgnoreInstallmentFrequencyFields__c,ccrz__InstallmentAddress__c,ccrz__InstallmentCountRemaining__c,ccrz__InstallmentLastDate__c,OSM_SW_Is_without_Coterm__c,
                    ccrz__InstallmentNextDate__c,ccrz__InstallmentStatus__c,ccrz__LastRecurringFailure__c,ccrz__OrderAddress__c,ccrz__OrderCountRemaining__c,
                    ccrz__OrderLastDate__c,ccrz__OrderNextDate__c,ccrz__OrderStatus__c,ccrz__ParentSubscription__c,ccrz__Quantity__c,ccrz__RecurringPriceSubAmt__c,
                    ccrz__RecurringPrice__c,ccrz__Sequence__c,ccrz__SPTInstallmentCount__c,ccrz__SPTInstallmentFrequencyUOM__c,ccrz__SPTInstallmentFrequency__c,
                    ccrz__SPTOrderCount__c,ccrz__SPTOrderFrequencyUOM__c,ccrz__SPTOrderFrequency__c,ccrz__SPTRecurringPricePercentage__c,ccrz__SPTUpfrontPricePercentage__c,
                    ccrz__SPT__c,ccrz__StoredPayment__c,ccrz__Storefront__c,ccrz__SubscriptionId__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionStatus__c,
                    ccrz__User__c,CreatedById,CreatedDate,Id,Name,Next_Invoice_Generation_Date__c,OSM_Free_Trial__c,OSM_Subscription_Cancellation_Date__c,OSM_Subscription_End_Date__c,
                    OSM_SW_Free_Trial_Extended_Count__c,OSM_SW_Free_Trial_ModifiedBy__c,ccrz__SPT__r.Billing_Display_Name__c, ccrz__CCOrderItem__r.ccrz__Price__c,
                   Current_Invoice_Generation_Date__c, Current_Invoice_Due_Date__c,Latest_Invoice__c,ccrz__CCOrderItem__r.ccrz__Quantity__c,
                   Purchase_Date__c,Subsequent_Next_Invoice_Due_Dt__c,Last_Installment_Generated__c,ccrz__SPT__r.ccrz__OrderFrequency__c
                FROM 
                    ccrz__E_Subscription__c 
                Where Id IN: Ids];
                   /*(Id IN: Ids
                        OR ccrz__CCOrder__c IN: Ids
                        OR ccrz__CCOrderItem__c IN: Ids) and ccrz__CCOrder__c != null and ccrz__CCOrderItem__c != null];*/
        }
       
    
    /**
    ** 
    **/
        Public static List<ccrz__E_Subscription__c> getSubscriptionsOnOrderItems(List<Id> Ids){
            
           return [ SELECT      Monthly_Price__c,Quarterly_Price__c,ccrz__SPT__r.ccrz__DisplayName__c,OneTime_Dn_Price__c,Quarterly_Dn_Price__c,Monthly_Dn_Price__c,Yearly_Dn_Price__c,PerDayDnPrice__c,Yearly_Price__c,OneTime_Price__c,
                    ccrz__Account__c,ccrz__AutoRenew__c,Subsequent_Next_Invoice_Generation_Dt__c,ccrz__CCOrderItem__r.ccrz__DisplayProduct__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__CurrencyISOCode__c,ccrz__EffectiveAccountID__c,
                    ccrz__IgnoreInstallmentFrequencyFields__c,ccrz__InstallmentAddress__c,ccrz__InstallmentCountRemaining__c,ccrz__InstallmentLastDate__c,OSM_SW_Is_without_Coterm__c,
                    ccrz__InstallmentNextDate__c,ccrz__InstallmentStatus__c,ccrz__LastRecurringFailure__c,ccrz__OrderAddress__c,ccrz__OrderCountRemaining__c,
                    ccrz__OrderLastDate__c,ccrz__OrderNextDate__c,ccrz__OrderStatus__c,ccrz__ParentSubscription__c,ccrz__Quantity__c,ccrz__RecurringPriceSubAmt__c,
                    ccrz__RecurringPrice__c,ccrz__Sequence__c,ccrz__SPTInstallmentCount__c,ccrz__SPTInstallmentFrequencyUOM__c,ccrz__SPTInstallmentFrequency__c,
                    ccrz__SPTOrderCount__c,ccrz__SPTOrderFrequencyUOM__c,ccrz__SPTOrderFrequency__c,ccrz__SPTRecurringPricePercentage__c,ccrz__SPTUpfrontPricePercentage__c,
                    ccrz__SPT__c,ccrz__StoredPayment__c,ccrz__Storefront__c,ccrz__SubscriptionId__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionStatus__c,
                    ccrz__User__c,CreatedById,CreatedDate,Id,Name,Next_Invoice_Generation_Date__c,OSM_Free_Trial__c,OSM_Subscription_Cancellation_Date__c,OSM_Subscription_End_Date__c,
                    OSM_SW_Free_Trial_Extended_Count__c,OSM_SW_Free_Trial_ModifiedBy__c,ccrz__SPT__r.Billing_Display_Name__c, ccrz__CCOrderItem__r.ccrz__Price__c,
                   Current_Invoice_Generation_Date__c, Current_Invoice_Due_Date__c,Latest_Invoice__c,ccrz__CCOrderItem__r.ccrz__Quantity__c,
                   Purchase_Date__c,Subsequent_Next_Invoice_Due_Dt__c,ccrz__CCOrderItem__r.ccrz__DisplayProduct__r.ccrz__SKU__c,Last_Installment_Generated__c,ccrz__SPT__r.ccrz__OrderFrequency__c
                FROM 
                    ccrz__E_Subscription__c 
                Where ccrz__CCOrderItem__c IN: Ids];
        }
        
       Public static List<ccrz__E_Subscription__c> getSubscriptionRecords(List<Id> Ids){
            
           return [ SELECT      Monthly_Price__c,ccrz__SPT__r.ccrz__DisplayName__c,ccrz__CCOrderItem__r.ccrz__Product__r.Name,
                            OSM_SW_Product_Link__c, ccrz__SubscriptionProduct__r.ccrz__SKU__c, Quarterly_Price__c,OneTime_Dn_Price__c,Quarterly_Dn_Price__c,Monthly_Dn_Price__c,Yearly_Dn_Price__c,PerDayDnPrice__c,Yearly_Price__c,OneTime_Price__c,
                    ccrz__Account__c,ccrz__AutoRenew__c,Subsequent_Next_Invoice_Generation_Dt__c,ccrz__CCOrderItem__r.ccrz__DisplayProduct__c,ccrz__CCOrderItem__c,ccrz__CCOrder__c,ccrz__Comments__c,ccrz__CurrencyISOCode__c,ccrz__EffectiveAccountID__c,
                    ccrz__IgnoreInstallmentFrequencyFields__c,ccrz__InstallmentAddress__c,ccrz__InstallmentCountRemaining__c,ccrz__InstallmentLastDate__c,ccrz__Account__r.ccrz__E_AccountGroup__c,
                    ccrz__InstallmentNextDate__c,ccrz__InstallmentStatus__c,ccrz__LastRecurringFailure__c,ccrz__OrderAddress__c,ccrz__OrderCountRemaining__c,
                    ccrz__OrderLastDate__c,ccrz__OrderNextDate__c,ccrz__OrderStatus__c,ccrz__ParentSubscription__c,ccrz__Quantity__c,ccrz__RecurringPriceSubAmt__c,
                    ccrz__RecurringPrice__c,ccrz__Sequence__c,ccrz__SPTInstallmentCount__c,ccrz__SPTInstallmentFrequencyUOM__c,ccrz__SPTInstallmentFrequency__c,
                    ccrz__SPTOrderCount__c,ccrz__SPTOrderFrequencyUOM__c,ccrz__SPTOrderFrequency__c,ccrz__SPTRecurringPricePercentage__c,ccrz__SPTUpfrontPricePercentage__c,
                    ccrz__SPT__c,ccrz__StoredPayment__c,ccrz__Storefront__c,ccrz__SubscriptionId__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,ccrz__SubscriptionStatus__c,
                    ccrz__User__c,CreatedById,CreatedDate,Id,Name,Next_Invoice_Generation_Date__c,OSM_Free_Trial__c,OSM_Subscription_Cancellation_Date__c,OSM_Subscription_End_Date__c,
                    OSM_SW_Free_Trial_Extended_Count__c,OSM_SW_Free_Trial_ModifiedBy__c,ccrz__SPT__r.Billing_Display_Name__c, ccrz__CCOrderItem__r.ccrz__Price__c,
                   Current_Invoice_Generation_Date__c, Current_Invoice_Due_Date__c,Latest_Invoice__c,ccrz__CCOrderItem__r.ccrz__Quantity__c,
                   Purchase_Date__c,Subsequent_Next_Invoice_Due_Dt__c,ccrz__CCOrderItem__r.ccrz__DisplayProduct__r.ccrz__SKU__c,Last_Installment_Generated__c,ccrz__SPT__r.ccrz__OrderFrequency__c
                FROM 
                    ccrz__E_Subscription__c 
                Where Id IN: Ids];
        } 
    /**
    ** getTransaction detail to update Payment Type on Account
    **/
        public static List<ccrz__E_TransactionPayment__c> getAccountPaymentTransactionDetails(String accountId){
            
            List<ccrz__E_TransactionPayment__c> accountPaymentTransactionDetails = [Select Id, ccrz__AccountType__c,ccrz__Account__c from ccrz__E_TransactionPayment__c 
                                                                                    where ccrz__Account__c =: accountId order by createdDate desc];
            return accountPaymentTransactionDetails;
        }
    
      
    /**  
    ** getTransaction detail to update Payment Type on Account
    **/
        public static List<ccrz__E_TransactionPayment__c> getOrderPaymentTransactionDetails(Set<String> OrderIds){
            
            List<ccrz__E_TransactionPayment__c> accountPaymentTransactionDetails = [Select Id, ccrz__AccountType__c,ccrz__CCOrder__c, ccrz__Account__c, Bolt_AR_Call_Status__c, Bolt_JE_Call_Status__c, Bolt_Credit_Memo_Call_Status__c, Bolt_JE_Reversal_Call_Status__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c IN: OrderIds order by createdDate desc];
            //List<ccrz__E_TransactionPayment__c> accountPaymentTransactionDetails = [Select Id, ccrz__AccountType__c,ccrz__CCOrder__c, ccrz__Account__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c IN: OrderIds order by createdDate desc];
            return accountPaymentTransactionDetails;
        }
        
      
          
      /**  
    ** getTransaction Order Items 
    **/
        public static List<ccrz__E_OrderItem__c> getOrderItems(List<String> OrderItemIds){
            
           /* List<ccrz__E_OrderItem__c> OrderItems = [Select Id, Vertex_Tax__c, ccrz__Quantity__c from ccrz__E_OrderItem__c 
                                                                                    where Id IN: OrderItemIds order by createdDate desc];*/
             List<ccrz__E_OrderItem__c> OrderItems = [Select Id, ccrz__Order__r.ccrz__OriginatedCart__c,Number_of_Bundles__c, Number_of_Counts__c, ccrz__StoreId__c, ccrz__Product__c,ccrz__Product__r.ccrz__SKU__c, ccrz__SubAmount__c, ccrz__SubProdTerm__c, ccrz__DisplayProduct__c,ccrz__DisplayProduct__r.Name,ccrz__DisplayProduct__r.ccrz__SKU__c, ccrz__Price__c, ccrz__Quantity__c from ccrz__E_OrderItem__c 
                                                                                    where Id IN: OrderItemIds order by createdDate desc];
            return OrderItems;  
        }
        
        /**
         **
         */
        
       /**
        ** 
        **/
        
        public static List<ccrz__E_RelatedProduct__c> getAddOnProducts(Set<String> productsIds){
            
            return [SELECT ccrz__Enabled__c,ccrz__EndDate__c,ccrz__Product__c,ccrz__RelatedProductGroup__c,ccrz__RelatedProductId__c,
                            ccrz__RelatedProductType__c,ccrz__RelatedProduct__c,ccrz__RelatedProduct__r.Product_Supporting_Text__c,ccrz__RelatedProduct__r.ccrz__ShortDesc__c,ccrz__RelatedProduct__r.Name,ccrz__RelatedProduct__r.ccrz__SKU__c, ccrz__RelationshipDescription__c,ccrz__Sequence__c,
                            ccrz__ShortDesc__c,ccrz__StartDate__c, Id 
                    FROM    ccrz__E_RelatedProduct__c 
                    where   ccrz__RelatedProductType__c = 'Accessories' 
                            and     ccrz__Product__c IN : productsIds and ccrz__EndDate__c >=: System.today() order by ccrz__Sequence__c asc];
        } 
        
        public static List<ccrz__E_RelatedProduct__c> getRelatedProducts(List<String> productsIds){
            
            return [SELECT ccrz__Enabled__c,ccrz__EndDate__c,ccrz__Product__r.Name, ccrz__Product__c,ccrz__RelatedProductGroup__c,ccrz__RelatedProductId__c,
                            ccrz__RelatedProductType__c,ccrz__RelatedProduct__c,ccrz__RelatedProduct__r.Product_Supporting_Text__c,ccrz__RelatedProduct__r.ccrz__ShortDesc__c,ccrz__RelatedProduct__r.Name,ccrz__RelatedProduct__r.ccrz__SKU__c, ccrz__RelationshipDescription__c,ccrz__Sequence__c,
                            ccrz__ShortDesc__c,ccrz__StartDate__c, Id 
                    FROM    ccrz__E_RelatedProduct__c 
                    where   ccrz__RelatedProductType__c =: 'Related' 
                            and     ccrz__Product__c IN: productsIds
                            and (NOT ccrz__Product__r.Name  like '%INCAL%')
                            and ccrz__RelatedProduct__r.Group_Name__c =: 'SES'
                            and ccrz__RelatedProduct__r.Stand_Alone_Product__c !=: 'Non-Subscription'
                            and ccrz__Product__r.Stand_Alone_Product__c !=: 'Non-Subscription'
                            and ccrz__EndDate__c >= TODAY order by ccrz__Sequence__c asc];
        }
        
        
    public static  List<ccrz__E_PriceListItem__c> getProductRecurringPrices(Set<String>subProdTermIds, Set<String> stores){
            
           return [SELECT ccrz__Price__c,ccrz__Product__c,Distributor_Price__c,ccrz__SubProdTerm__r.ccrz__DisplayName__c,ccrz__SubProdTerm__r.ccrz__Storefront__c,ccrz__SubProdTerm__r.Billing_Display_Name__c,
                    ccrz__SubProdTerm__r.name, ccrz__RecurringPrice__c,ccrz__SubProdTerm__c 
             FROM ccrz__E_PriceListItem__c 
             where ccrz__RecurringPrice__c=true
            and ccrz__SubProdTerm__r.ccrz__Storefront__c IN:stores
            and ccrz__SubProdTerm__c IN:subProdTermIds
            ];
        }   
        
        
    // Changes added by Karthik for MP-714
    public static List<ccrz__E_Product__c> getProductAndRelatedProductInfo(Set<string> productIds) {
        return [SELECT id,(SELECT id,ccrz__RelatedProduct__c,ccrz__RelatedProduct__r.Name,ccrz__RelatedProductId__c,ccrz__RelatedProduct__r.ccrz__SKU__c FROM ccrz__E_RelatedProducts__r) 
                FROM ccrz__E_Product__c 
                WHERE id=:productIds
                AND ccrz__ProductType__c='Bundle'
                ];
        }
    //End of changes
    }