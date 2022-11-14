/*
* Class to take data from the HAPI Price Loads Custom Object and load it into Cloud Craze Objects with required relations
* 
* @author : Juhi Krishnamurthy
* @created date : November 08, 2018 
* 
*/

public class HAPI_PriceLoader 
{
    public static String testCase = '';
    
    public static void loadPricingData(HAPI_Price_Load__c  hapiPriceLoad)
    {
        try
        {
            System.debug('START - HAPI_PriceLoader : loadPricingData');
            
            // Maps Set Up------------------------------------------
            
            // Product Map -> Product Sku : Product
            Map<String, ccrz__E_Product__c> productMap = new Map<String, ccrz__E_Product__c>();
            Map<String,ID> productSKUMap = new Map<String,ID>();
            
            for(ccrz__E_Product__c product : HAPI_DataLoad_Queries.getProducts())
            {
                productMap.put(product.ccrz__SKU__c, product);
                productSKUMap.put(product.ccrz__SKU__c, product.ID);
            }
            
            // CC Account Group Map
            Map<String, ID> accountGroupMap = new Map<String, ID>();
            for(ccrz__E_AccountGroup__c accountGroup : HAPI_DataLoad_Queries.getAllExistingAccountGroups())
            {
                accountGroupMap.put(accountGroup.Name, accountGroup.ID);
            }
            
            // CC Pricelist Map
            Map<String, ID> priceListMap = new Map<String, ID>();
            for(ccrz__E_PriceList__c priceList : HAPI_DataLoad_Queries.getAllExistingPriceLists())
            {
                priceListMap.put(priceList.Name , priceList.ID);
            }
            
            // CC Account Group Pricelist Junction Map
            Map<String, ccrz__E_AccountGroupPriceList__c> accountGroupPriceListJunctionMap = new Map<String, ccrz__E_AccountGroupPriceList__c>();
            for(ccrz__E_AccountGroupPriceList__c accountGroupPriceListJunction : HAPI_DataLoad_Queries.getAllExistingAccountGroupPriceListJunctions())
            {
                accountGroupPriceListJunctionMap.put(accountGroupPriceListJunction.ccrz__AccountGroup__c + '-' + accountGroupPriceListJunction.ccrz__Pricelist__c, accountGroupPriceListJunction);
            }
            
            // CC Pricelist Item Map
            Map<String, ccrz__E_PriceListItem__c> priceListItemMap = new Map<String, ccrz__E_PriceListItem__c>();
            for(ccrz__E_PriceListItem__c priceListItem : HAPI_DataLoad_Queries.getAllExistingPriceListItems())
            {
                priceListItemMap.put(priceListItem.ccrz__Product__c + '-' + priceListItem.ccrz__Pricelist__c, priceListItem);
            }
            
            // fetch ccrz_SubProdTerm__c custom setting list values to be used while inserting subProductTerm
            List<ccrz_SubProdTerm__c> customSettingSubProdTermList = ccrz_SubProdTerm__c.getall().values();
            
            Map<String, ccrz_SubProdTerm__c> customSettingSubProdTermMap = new Map<String, ccrz_SubProdTerm__c>();
            
            for(ccrz_SubProdTerm__c customSettingSubProdTerm : customSettingSubProdTermList)
            {
                customSettingSubProdTermMap.put(customSettingSubProdTerm.Display_Name__c + '-' + customSettingSubProdTerm.Billing_Display_Name__c,customSettingSubProdTerm);
            }
            
            //End of Maps Set Up--------------------------------------
            
            List<ccrz__E_SubProdTerm__c> existingSubProdTermsList = HAPI_DataLoad_Queries.getAllExistingSubProdTerms();
            List<ccrz__E_PriceListItem__c> existingPriceListItemsList = HAPI_DataLoad_Queries.getAllExistingPriceListItems();
            
            Boolean insertionError = false;
            String insertionMessage = '';
            Savepoint accountGroupAndPriceListPoint = Database.setSavepoint();
            
            hapiPriceLoad.Error_Message__c = '';
            hapiPriceLoad.Message__c = '';
            
            if(null != hapiPriceLoad && null != hapiPriceLoad.Product_SKU__c 
               && !String.isEmpty(hapiPriceLoad.Product_SKU__c))
            {
                if(null != productMap.get(hapiPriceLoad.Product_SKU__c))
                {
                    if(checkRequiredFields(hapiPriceLoad))
                    {
                        // check if account group exists - else create
                        if(null == accountGroupMap.get(hapiPriceLoad.Account_Group_Name__c))
                        {
                            ccrz__E_AccountGroup__c accountGroup = new ccrz__E_AccountGroup__c();
                            accountGroup.Name = hapiPriceLoad.Account_Group_Name__c;
                            accountGroup.ccrz__PriceListSelectionMethod__c = hapiPriceLoad.Price_Selection_Method__c;
                            
                            try
                            {
                                insert accountGroup;
                                accountGroupMap.put(accountGroup.Name, accountGroup.ID);
                                insertionMessage = insertionMessage + '\n Account Group : ' + accountGroup.Name + ' created.';
                                
                                if(Test.isRunningTest() && testCase == 'accountGroupException')
                                {
                                    throw new NullPointerException();
                                }
                            }
                            catch(Exception e)
                            {
                                System.debug('Could not insert Account Group : ' + hapiPriceLoad.Account_Group_Name__c);
                                hapiPriceLoad.Error_Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoad.Error_Message__c) + 
                                    '\n Could not insert Account Group : ' + hapiPriceLoad.Account_Group_Name__c;
                                insertionError = true;
                                Database.rollback(accountGroupAndPriceListPoint);
                            }
                        }
                        
                        if(null != accountGroupMap.get(hapiPriceLoad.Account_Group_Name__c))
                        {
                            // check if Price list exists - else create
                            if(null == priceListMap.get(hapiPriceLoad.PriceList_Name__c))
                            {
                                // LATER : Maybe add storefront
                                ccrz__E_PriceList__c priceList = new ccrz__E_PriceList__c();
                                priceList.Name = hapiPriceLoad.PriceList_Name__c;
                                priceList.ccrz__CurrencyISOCode__c = hapiPriceLoad.Currency__c;
                                priceList.ccrz__Storefront__c = 'SoftwareStore';
                                
                                try
                                {
                                    insert priceList;
                                    priceListMap.put(priceList.Name, priceList.ID);
                                    insertionMessage = insertionMessage + '\n PriceList : ' + priceList.Name + ' created.';
                                    
                                    if(Test.isRunningTest() && testCase == 'pricelistException')
                                    {
                                        throw new NullPointerException();
                                    }
                                }
                                catch(Exception e)
                                {
                                    System.debug('Could not insert Price List : ' + hapiPriceLoad.PriceList_Name__c);
                                    hapiPriceLoad.Error_Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoad.Error_Message__c) + 
                                        '\n Could not insert Price List : ' + hapiPriceLoad.PriceList_Name__c;
                                    insertionError = true;
                                    Database.rollback(accountGroupAndPriceListPoint);
                                }
                            }
                        }
                        
                        if(null != accountGroupMap.get(hapiPriceLoad.Account_Group_Name__c) 
                           && null != priceListMap.get(hapiPriceLoad.PriceList_Name__c))
                        {
                            // check if the account grp price list junction exists - else create
                            if(null == accountGroupPriceListJunctionMap.get(accountGroupMap.get(hapiPriceLoad.Account_Group_Name__c)
                                                                            + '-' + priceListMap.get(hapiPriceLoad.PriceList_Name__c)))
                            {
                                ccrz__E_AccountGroupPriceList__c accountGroupPriceListJunction = new ccrz__E_AccountGroupPriceList__c();
                                accountGroupPriceListJunction.ccrz__AccountGroup__c = accountGroupMap.get(hapiPriceLoad.Account_Group_Name__c);
                                accountGroupPriceListJunction.ccrz__Pricelist__c = priceListMap.get(hapiPriceLoad.PriceList_Name__c);
                                accountGroupPriceListJunction.ccrz__Enable__c = true;
                                accountGroupPriceListJunction.ccrz__StartDate__c = system.today().addDays(-10);//HAPI_DataLoad_CommonUtility.getStartDate();
                                accountGroupPriceListJunction.ccrz__EndDate__c = HAPI_DataLoad_CommonUtility.getEndDate();
                                
                                try
                                {
                                    insert accountGroupPriceListJunction;
                                    accountGroupPriceListJunctionMap.put(accountGroupMap.get(hapiPriceLoad.Account_Group_Name__c)
                                                                         + '-' + priceListMap.get(hapiPriceLoad.PriceList_Name__c), accountGroupPriceListJunction);
                                    
                                    insertionMessage = insertionMessage + '\n Junction between : Account group : ' + hapiPriceLoad.Account_Group_Name__c 
                                        + 'and PriceList : ' + hapiPriceLoad.PriceList_Name__c + ' created.';
                                    
                                    if(Test.isRunningTest() && testCase == 'accountgrp_pricelistException')
                                    {
                                        throw new NullPointerException();
                                    }
                                }
                                catch(Exception e)
                                {    
                                    System.debug('Could not insert the Account Group Price List junction record');
                                    hapiPriceLoad.Error_Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoad.Error_Message__c) + 
                                        '\n Could not create the Account Group Price List junction record for : ' + hapiPriceLoad.Account_Group_Name__c + '-' + hapiPriceLoad.PriceList_Name__c;
                                    insertionError = true;
                                    Database.rollback(accountGroupAndPriceListPoint);
                                }
                            }
                            // LATER : make sure it is enabled
                        }
                        
                        if(null != accountGroupMap.get(hapiPriceLoad.Account_Group_Name__c) 
                           && null != priceListMap.get(hapiPriceLoad.PriceList_Name__c) 
                           && null != accountGroupPriceListJunctionMap.get(accountGroupMap.get(hapiPriceLoad.Account_Group_Name__c)
                                                                           + '-' + priceListMap.get(hapiPriceLoad.PriceList_Name__c)))
                        {
                            if(! hapiPriceLoad.Subscription_Product__c)
                            {
                                ccrz__E_PriceListItem__c priceListItem = null;
                                
                                // check if pricelist item with given pricelist exists - if yes - update - else create
                                if(null == priceListItemMap.get(productMap.get(hapiPriceLoad.Product_SKU__c).ID 
                                                                + '-' + priceListMap.get(hapiPriceLoad.PriceList_Name__c)))
                                {
                                    priceListItem = new ccrz__E_PriceListItem__c();
                                    priceListItem.ccrz__StartDate__c = system.today().addDays(-10);
                                    priceListItem.ccrz__Product__c = productMap.get(hapiPriceLoad.Product_SKU__c).ID;
                                    priceListItem.ccrz__Pricelist__c = priceListMap.get(hapiPriceLoad.PriceList_Name__c);
                                    priceListItem.ccrz__Price__c = Double.valueOf(hapiPriceLoad.Price__c);
                                    priceListItem.Distributor_Price__c = Double.valueOf(hapiPriceLoad.Distributor_Price__c);
                                }
                                else
                                {
                                    priceListItem = priceListItemMap.get(productMap.get(hapiPriceLoad.Product_SKU__c).ID 
                                                                         + '-' + priceListMap.get(hapiPriceLoad.PriceList_Name__c));
                                    priceListItem.ccrz__StartDate__c = system.today().addDays(-10);
                                    priceListItem.ccrz__Price__c = Double.valueOf(hapiPriceLoad.Price__c);
                                    priceListItem.Distributor_Price__c = Double.valueOf(hapiPriceLoad.Distributor_Price__c);
                                }
                                
                                try
                                {
                                    upsert priceListItem;
                                    
                                    if(Test.isRunningTest() && testCase == 'pricelistItemException')
                                    {
                                        throw new NullPointerException();
                                    }
                                }
                                catch(Exception e)
                                {
                                    System.debug('Could not insert/update the Pricelist Item');
                                    hapiPriceLoad.Error_Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoad.Error_Message__c) + 
                                        '\n Could not Pricelist Item : ';
                                    insertionError = true;
                                    Database.rollback(accountGroupAndPriceListPoint);
                                }
                            }
                            else
                            {
                                HAPI_PriceLoad_Wrapper hapiPriceLoadWrapper = new HAPI_PriceLoad_Wrapper();
                                
                                // create the price list items for the subprod term combo
                                hapiPriceLoadWrapper = createPriceRelatedLists(hapiPriceLoadWrapper, hapiPriceLoad, productSKUMap.get(hapiPriceLoad.Product_SKU__c), 
                                                                               productMap.get(hapiPriceLoad.Product_SKU__c).Name, customSettingSubProdTermMap, 
                                                                               priceListMap.get(hapiPriceLoad.PriceList_Name__c), 
                                                                               existingSubProdTermsList, existingPriceListItemsList);
                                
                                hapiPriceLoad.Error_Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoad.Error_Message__c) 
                                    + HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoadWrapper.errorMessage) ;
                                
                                hapiPriceLoad.Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoad.Message__c) 
                                    + HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoadWrapper.message) ;
                            }
                        }
                    }
                    else
                    {
                        hapiPriceLoad.Error_Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoad.Error_Message__c) 
                            + '\n Required Fields Missing';
                    }
                }
                else
                {
                    hapiPriceLoad.Error_Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoad.Error_Message__c) 
                        + '\n Product SKU incorrect. Product does not exist';
                }
            }
            else
            {
                hapiPriceLoad.Error_Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoad.Error_Message__c) 
                    + '\n Product SKU can not be NULL/EMPTY';
            }
            
            if(!insertionError)
            {
                hapiPriceLoad.Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoad.Message__c) 
                    + insertionMessage;
            }
            System.debug('above if ');
            // if no error message....all went good...it was loaded properly
            if(null == hapiPriceLoad.Error_Message__c || String.isEmpty(hapiPriceLoad.Error_Message__c))
            {
                hapiPriceLoad.Data_Fully_Uploaded__c = true;
                System.debug('above if ');
            }
            else
            {
                hapiPriceLoad.Data_Partially_Uploaded__c = true;
                System.debug('above else ');
            }
            
            update hapiPriceLoad;
            
            System.debug('END - HAPI_PriceLoader : loadPricingData');
        }
        catch(Exception e)
        {
            // Any exception occuring in the load
            System.debug('EXCEPTION : Ocurred when loading Pricing Data');
            // Any exception occuring in the load
            String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();
            
            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
            
            log.Error_Description__c = errorMsg;
            
            log.Service_Name__c = 'HAPI Price Load';
            
            log.Status__c = 'Failed';
            
            insert log;
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    }
    
    // creation of relation for CC SubProdTerms , CC PriceList, CC PriceList Items
    public static HAPI_PriceLoad_Wrapper createPriceRelatedLists(HAPI_PriceLoad_Wrapper hapiPriceLoadWrapper, HAPI_Price_Load__c hapiPriceLoad, 
                                                                 ID productID, String productName,  
                                                                 Map<String, ccrz_SubProdTerm__c> customSettingSubProdTermMap, 
                                                                 ID priceListID, List<ccrz__E_SubProdTerm__c> existingSubProdTermsList, 
                                                                 List<ccrz__E_PriceListItem__c> existingPriceListItemsList)
    {
        Savepoint subProdTermSavePoint = Database.setSavepoint();
        
        try
        {
            hapiPriceLoadWrapper.pricingDataStatus = HAPI_DataLoad_CommonUtility.SUCCESS;
            hapiPriceLoadWrapper.priceListItemList = new List<ccrz__E_PriceListItem__c>();
            
            Map<String, ccrz__E_SubProdTerm__c> productSpecificSubProdTermMap = new Map<String, ccrz__E_SubProdTerm__c>();
            String paramHapiSubProdTermName=hapiPriceLoad.Product_SKU__c+'-'+hapiPriceLoad.PriceList_Name__c+'-'+hapiPriceLoad.Subscription_Length__c+'-'+hapiPriceLoad.Billing_Frequency__c;
            for(ccrz__E_SubProdTerm__c subProdTerm : existingSubProdTermsList)
            {
                if(subProdTerm.HAPI_SubProdTerm_Name__c != '' && !string.isBlank(subProdTerm.HAPI_SubProdTerm_Name__c)){
                    
                    
                    if(productID == subProdTerm.ccrz__CCProduct__c  && subProdTerm.HAPI_SubProdTerm_Name__c.containsIgnoreCase(hapiPriceLoad.PriceList_Name__c))
                    {
                        // productSpecificSubProdTermMap.put(
                        //   subProdTerm.PriceListID__c + '-' + subProdTerm.ccrz__DisplayName__c + '-' + subProdTerm.Billing_Display_Name__c, subProdTerm);
                        productSpecificSubProdTermMap.put(subProdTerm.HAPI_SubProdTerm_Name__c, subProdTerm);
                    }
                }
            }
            
            // map of product specific subProdTerm ID + Recurring/non Recurring - priceList
            Map<String, ccrz__E_PriceListItem__c> productSpecificSubProdTermPriceListItemMap = new Map<String, ccrz__E_PriceListItem__c>();
            Boolean emptyProductSpecificPriceListItem = false;
            
            Map<ID, Boolean> emptyProductSpecificPriceListItemMap = new Map<ID, Boolean>();
            //String paramHapiSubProdTermName=hapiPriceLoad.Product_SKU__c+'-'+hapiPriceLoad.PriceList_Name__c+'-'+hapiPriceLoad.Subscription_Length__c+'-'+hapiPriceLoad.Billing_Frequency__c;
            for(ccrz__E_PriceListItem__c priceListItem : existingPriceListItemsList)
            {
                if(productID == priceListItem.ccrz__Product__c)
                {
                    if(null != priceListItem.ccrz__SubProdTerm__c)
                    {
                        if(priceListItem.ccrz__RecurringPrice__c) // recurring
                        {
                            // Changes : Dec 04 -> subprodterm + pricelist + recurring
                            productSpecificSubProdTermPriceListItemMap.put(priceListItem.ccrz__SubProdTerm__r.HAPI_SubProdTerm_Name__c + 'Recurring', priceListItem);
                        }
                        else // not recurring
                        {
                            productSpecificSubProdTermPriceListItemMap.put(priceListItem.ccrz__SubProdTerm__r.HAPI_SubProdTerm_Name__c + 'Non-Recurring', priceListItem);
                        }
                    }
                    else
                    {
                        // Changes : empty pricelist item for each pricelist the product belongs to
                        emptyProductSpecificPriceListItemMap.put(priceListItem.ccrz__Pricelist__c, true);
                    }
                }
            }
            
            system.debug('emptyProductSpecificPriceListItemMap==>'+emptyProductSpecificPriceListItemMap);
            system.debug('productSpecificSubProdTermPriceListItemMap==>'+productSpecificSubProdTermPriceListItemMap);
            
            if(null == emptyProductSpecificPriceListItemMap.get(priceListID))
            {
                ccrz__E_PriceListItem__c emptyPriceListItem = createPriceListItem(productID, null, Double.valueOf('0.00'), Double.valueOf('0.00'), priceListID, false);
                
                if(null != emptyPriceListItem)
                {
                    hapiPriceLoadWrapper.priceListItemList.add(emptyPriceListItem);
                }
                else
                {
                    // error in creating the empty priceList
                    hapiPriceLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoadWrapper.errorMessage) 
                        + '\n Error in creating the empty price list';
                }
            }
            // else an Empty pricelist item already exists for this product
            
            if(hapiPriceLoad.Subscription_Product__c)
            {
                if(null != hapiPriceLoad.Subscription_Length__c && null != hapiPriceLoad.Billing_Frequency__c)
                {
                    String displayName = hapiPriceLoad.Subscription_Length__c;
                    String billingDisplayName = hapiPriceLoad.Billing_Frequency__c;
                    Double price = hapiPriceLoad.Price__c;
                    Double distributorPrice = hapiPriceLoad.Distributor_Price__c;
                    
                    if(null != customSettingSubProdTermMap.get(displayName + '-' + billingDisplayName))
                    {
                        // map the customsetting details to a new subprod term
                        // subProdTerm does not exist for this combo
                        if(null == productSpecificSubProdTermMap.get(paramHapiSubProdTermName))
                        {
                            ccrz__E_SubProdTerm__c subProdTerm = null;
                            try
                            {
                                // create the subProdTerm with the custom setting template
                                subProdTerm = map_CustomSettingSubProdTerm_To_SubProdTerm(hapiPriceLoad,customSettingSubProdTermMap.get(displayName + '-' + billingDisplayName), productID, productName, priceListID);
                                upsert subProdTerm;
                                
                                if(Test.isRunningTest() && testCase == 'subProdTermException')
                                {
                                    throw new NullPointerException();
                                }
                            }
                            catch(Exception e)
                            {
                                System.debug('Error in creating SubProdTerm with combo : ' + displayName + '-' + billingDisplayName);
                                System.debug(e.getStackTraceString());
                            }
                            // create the priceListItem
                            if (null != subProdTerm)
                            {
                                ccrz__E_PriceListItem__c priceListItemNonRecurring = createPriceListItem(productID, subProdTerm.ID, price, distributorPrice, priceListID, false);
                                ccrz__E_PriceListItem__c priceListItemRecurring = createPriceListItem(productID, subProdTerm.ID, price, distributorPrice, priceListID, true);
                                
                                if(null != priceListItemNonRecurring && null != priceListItemRecurring )
                                {
                                    hapiPriceLoadWrapper.priceListItemList.add(priceListItemNonRecurring);
                                    hapiPriceLoadWrapper.priceListItemList.add(priceListItemRecurring);
                                }
                                else
                                {
                                    // error in creating priceListItem...dont create the subProdTerm as well
                                    hapiPriceLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoadWrapper.errorMessage) 
                                        + '\n Error in creating priceListItem. Hence SubProdTerm with combo : ' + displayName + '-' + billingDisplayName + 'was not created';
                                }
                            }
                            else
                            {
                                // error in creating subProdTerm ...dont create the pricelist items as well
                                hapiPriceLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoadWrapper.errorMessage) + 'Error in creating SubProdTerm with combo : ' + displayName + '-' + billingDisplayName;
                            }
                        }
                        else
                        {
                            // subProdTerm exists for this combo...check if corresponding pricelists exist...if not..create
                            //String paramHapiSubProdTermName=hapiPriceLoad.Product_SKU__c+'-'+hapiPriceLoad.PriceList_Name__c+'-'+hapiPriceLoad.Subscription_Length__c+'-'+hapiPriceLoad.Billing_Frequency__c;
                            if(null == productSpecificSubProdTermPriceListItemMap.get(paramHapiSubProdTermName + 'Recurring'))
                            {
                                ccrz__E_PriceListItem__c priceListItemRecurring = createPriceListItem(
                                    productID, productSpecificSubProdTermMap.get(paramHapiSubProdTermName).ID, price, distributorPrice, priceListID, true);
                                
                                if(null != priceListItemRecurring)
                                {
                                    hapiPriceLoadWrapper.priceListItemList.add(priceListItemRecurring);
                                }
                            }
                            else
                            {
                                // the recurring price item exists...but update the price value
                                ccrz__E_PriceListItem__c priceListItemRecurring = productSpecificSubProdTermPriceListItemMap.get(paramHapiSubProdTermName + 'Recurring');
                                
                                try
                                {
                                    priceListItemRecurring.ccrz__Price__c = Decimal.valueOf(price);
                                    priceListItemRecurring.Distributor_Price__c = Decimal.valueOf(distributorPrice);
                                    hapiPriceLoadWrapper.priceListItemList.add(priceListItemRecurring);
                                    
                                    if(Test.isRunningTest() && testCase == 'recurringPriceListItemException')
                                    {
                                        throw new NullPointerException();
                                    }
                                }
                                catch(Exception e)
                                {
                                    System.debug('Error in the format of the price');
                                    hapiPriceLoadWrapper.errorMessage = ''+e+'==='+e.getLineNumber(); /*HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoadWrapper.errorMessage) 
+ '\n Due to Error in format of Price, could not update Recurring PriceList Item in SubProdTerm Combo : ' + displayName + '-' + billingDisplayName;*/
                                }
                            }
                            
                            if(null == productSpecificSubProdTermPriceListItemMap.get(paramHapiSubProdTermName+ 'Non-Recurring'))
                            {
                                ccrz__E_PriceListItem__c priceListItemNonRecurring = createPriceListItem(
                                    productID, productSpecificSubProdTermMap.get(paramHapiSubProdTermName).ID, price, distributorPrice, priceListID, false);
                                
                                if(null != priceListItemNonRecurring)
                                {
                                    hapiPriceLoadWrapper.priceListItemList.add(priceListItemNonRecurring);
                                }
                            }
                            else
                            {
                                // the recurring price item exists...but update the price value
                                ccrz__E_PriceListItem__c priceListItemRecurring = productSpecificSubProdTermPriceListItemMap.get(paramHapiSubProdTermName + 'Non-Recurring');
                                
                                try
                                {
                                    priceListItemRecurring.ccrz__Price__c = Decimal.valueOf(price);
                                    priceListItemRecurring.Distributor_Price__c = Decimal.valueOf(distributorPrice);
                                    hapiPriceLoadWrapper.priceListItemList.add(priceListItemRecurring);
                                    
                                    if(Test.isRunningTest() && testCase == 'nonrecurringPriceListItemException')
                                    {
                                        throw new NullPointerException();
                                    }
                                }
                                catch(Exception e)
                                {
                                    System.debug('Error in the format of the price');
                                    hapiPriceLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoadWrapper.errorMessage) 
                                        + '\n Due to Error in format of Price, could not update Non-Recurring PriceList Item in SubProdTerm Combo : ' + displayName + '-' + billingDisplayName;
                                }
                            }
                        }
                    }
                    else
                    {
                        // this block is ignored....go on to next
                        hapiPriceLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoadWrapper.errorMessage) 
                            + '\n Invalid combo of the display name and billing display name';
                    }
                }
                else
                {
                    hapiPriceLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoadWrapper.errorMessage) 
                        + '\n Subscription length and Billing Frequency required if it is a Subscription Product';
                }
            }
            // else no disabling / deletion here
            
            // once we get all priceListItems for all subProdTerm...try inserting
            // if exception...roll back to the point before any subprodterm creation
            if(null != hapiPriceLoadWrapper.priceListItemList && hapiPriceLoadWrapper.priceListItemList.size()>0)
            {
                try
                {
                    upsert hapiPriceLoadWrapper.priceListItemList;
                    
                    if(Test.isRunningTest() && testCase == 'allPriceListItemException')
                    {
                        throw new NullPointerException();
                    }
                }
                catch(Exception e)
                {
                    hapiPriceLoadWrapper.pricingDataStatus = HAPI_DataLoad_CommonUtility.FAILURE;
                    hapiPriceLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoadWrapper.errorMessage) 
                        + '\n Error in inserting the priceList Items for this product. SubProdterms are also rolled back here';
                    System.debug('Error in inserting the pricelists Product : ' + productName);
                    System.debug(e.getStackTraceString());
                    
                    Database.rollback(subProdTermSavePoint);
                }
            }
            
            if(Test.isRunningTest() && testCase == 'generalException')
            {
                throw new NullPointerException();
            }
        }
        catch(Exception e)
        {
            hapiPriceLoadWrapper.pricingDataStatus = HAPI_DataLoad_CommonUtility.FAILURE;
            system.debug('message '+e.getMessage()+' '+e.getLineNumber());
            /*hapiPriceLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiPriceLoadWrapper.errorMessage) 
+ '\n Error in inserting the priceList Items for this product. SubProdterms are also rolled back';*/
            hapiPriceLoadWrapper.errorMessage = String.valueOf(e).substring(0, 254);
            System.debug('Exception occurred ' + e);
            System.debug(e.getStackTraceString());
            
            Database.rollback(subProdTermSavePoint);
        }
        
        return hapiPriceLoadWrapper;
    }
    
    public static ccrz__E_PriceListItem__c createPriceListItem(ID productID, ID subProdTermID, Double price, Double distributorPrice, ID priceListID, Boolean isRecurringPrice)
    {
        ccrz__E_PriceListItem__c priceListItem = new ccrz__E_PriceListItem__c();
        priceListItem.ccrz__StartDate__c = system.today().addDays(-10);
        priceListItem.ccrz__Product__c = productID;
        priceListItem.ccrz__Pricelist__c = priceListID;
        priceListItem.ccrz__RecurringPrice__c = isRecurringPrice;
        
        if(null != subProdTermID)
        {
            priceListItem.ccrz__SubProdTerm__c = subProdTermID;
        }
        // else trying to create the empty pricelist value
        
        try
        {
            priceListItem.ccrz__Price__c = Decimal.valueOf(price);
            priceListItem.Distributor_Price__c = Decimal.valueOf(distributorPrice);
            
        }
        catch(Exception e)
        {
            // Error in the format of the price
            return null;
        }
        
        return priceListItem;
    }
    
    public static ccrz__E_SubProdTerm__c map_CustomSettingSubProdTerm_To_SubProdTerm(HAPI_Price_Load__c  hapiPriceLoad, ccrz_SubProdTerm__c customSettingSubProdTerm, ID productID, String productName, ID priceListID)
    {
        try
        {
            ccrz__E_SubProdTerm__c subProdTerm = new ccrz__E_SubProdTerm__c();
            String paramHapiSubProdTermName=hapiPriceLoad.Product_SKU__c+'-'+hapiPriceLoad.PriceList_Name__c+'-'+hapiPriceLoad.Subscription_Length__c+'-'+hapiPriceLoad.Billing_Frequency__c;
            
            subProdTerm.HAPI_SubProdTerm_Name__c = paramHapiSubProdTermName;
            subProdTerm.ccrz__CCProduct__c = productID;
            subProdTerm.Name = productName + '-' + ' ' + customSettingSubProdTerm.Display_Name__c + ' ' + customSettingSubProdTerm.Billing_Display_Name__c;
            subProdTerm.ccrz__EffectiveEnd__c =  customSettingSubProdTerm.Effective_End__c;
            subProdTerm.ccrz__EffectiveStart__c = customSettingSubProdTerm.Effective_Start__c;
            subProdTerm.Operation__c = '*';
            subProdTerm.ccrz__DisplayName__c = customSettingSubProdTerm.Display_Name__c; 
            subProdTerm.ccrz__DisplayNameRT__c = customSettingSubProdTerm.DisplayNameR__c;
            subProdTerm.ccrz__OrderDisplayName__c = customSettingSubProdTerm.OrderDisplayName__c;
            subProdTerm.ccrz__OrderDisplayNameRT__c = customSettingSubProdTerm.OrderDisplayNameRT__c;
            subProdTerm.ccrz__EmailDisplayNameRT__c = customSettingSubProdTerm.EmailDisplayNameRT__c;
            subProdTerm.ccrz__Enabled__c = customSettingSubProdTerm.Enabled__c;
            subProdTerm.ccrz__IgnoreInstallmentFrequencyFields__c = customSettingSubProdTerm.IgnoreInstallmentFrequencyFields__c;
            subProdTerm.ccrz__InstallmentCount__c = customSettingSubProdTerm.InstallmentCount__c;
            subProdTerm.ccrz__InstallmentFrequencyUOM__c = customSettingSubProdTerm.InstallmentFrequencyUOM__c;
            subProdTerm.ccrz__InstallmentFrequency__c = customSettingSubProdTerm.InstallmentFrequency__c;
            // subProdTerm.ccrz__Name__c = customSettingSubProdTerm.Name__c;
            subProdTerm.ccrz__OrderCount__c = customSettingSubProdTerm.Order_Count__c;
            subProdTerm.ccrz__OrderFrequency__c = customSettingSubProdTerm.OrderFrequency__c;
            subProdTerm.ccrz__OrderFrequencyUOM__c = customSettingSubProdTerm.OrderFrequencyUOM__c;
            subProdTerm.ccrz__Sequence__c = customSettingSubProdTerm.Sequence__c;
            subProdTerm.ccrz__Storefront__c = customSettingSubProdTerm.Storefront__c;
            subProdTerm.Billing_Display_Name__c = customSettingSubProdTerm.Billing_Display_Name__c;
            subProdTerm.PriceListID__c = String.valueOf(priceListID);
            
            return subProdTerm;
        }
        catch(Exception e)
        {
            // Error in creation of SubProdTerm
            return null;
        }
    }
    
    public static Boolean checkRequiredFields(HAPI_Price_Load__c hapiPriceLoad)
    {
        if(null != hapiPriceLoad && null != hapiPriceLoad.Product_SKU__c 
           && null != hapiPriceLoad.Account_Group_Name__c && null != hapiPriceLoad.Currency__c 
           && null != hapiPriceLoad.Price__c && null != hapiPriceLoad.PriceList_Name__c 
           && null != hapiPriceLoad.Price_Selection_Method__c)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}