/************************************************************
Name:  OSM_Email_ProductLine_Ctrl
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Email Template data handler class 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Sharma         25/07/2018     INITIAL DEVELOPMENT          
1.1 -	Charlynn/Suresh		25/07/2022		Changes for LL-25 to display Number of Bundles

*************************************************************/

global class OSM_Email_ProductLine_Ctrl {
    
    global string ordercompanyName {get;set;}
    global string reissuedProdName{get;set;}
    global String DateRevoked{get;set;}
    global Id incalSubIds {get;set;}
    global Id OrderIds {get;}
    global Boolean branchCustomer {get;set;}
    global String headQuaterName{get;set;}
    global String headQuaterEmail{get;set;}
    global Boolean shouldShowPrice {get;set;}
    global Boolean isInSubscription {get;set;}
    global String mailType {get;set;}
    global String AccountName{get;set;}
    global String AccountNo{get;set;}
    global Boolean isGoms{get;set;}
    global Boolean orderitemsubmitted  {get;set;}
    global Boolean OtherorderitemCancelled  {get;set;}
    global Boolean FluidWatchorderitemCancelled {get;set;}
    global ccrz__E_OrderItem__c orderitem {get;set;}
    // global string activationkey {get;set;}
    global Boolean activationKeyErrorMessage {get;set;}
    global List<ccrz__E_ProductMedia__c> mediaList {get;set;}
    global String monthName {get;set;}
    global String expiredmonthName {get;set;}
    global boolean hasLicenseProduct{get;set;}
    global boolean isBMSPDFReceived{get;set;}
    global DateTime d {get;set;}
    global List<OerderLineItemDetail> lstLineItemWrapper{get;set;}
    //Subscription 
    global String subsriptionIds {get;set;}
    global String requestQuoteIds {get;set;}
    global String invoiceIds {get;set;}
    global string osmIntegerationId {get;set;}
    //global set<String> invoiceIds {get;set;}
    global ccrz__E_Order__c order {get;set;}
    global OSM_Integration_Log__c osmIntegrationLog{get;set;}
    //global string serviceName {get;set;}
    List<OerderLineItemDetail> lstsubLineItems{get;set;}
    List<ccrz__E_Subscription__c> subList ;
    List<OerderLineItemDetail> SubscriptionList {get;set;}
    List<OerderLineItemDetail> RequestQuoteList{get;set;}
    List<OerderLineItemDetail> invoiceItemList{get;set;}
    //List<OerderLineItemDetail> osmIntegrationLog{get;set;}
    //   List<String> activationKeysList=new List<String>();
    global List <ccrz__E_Order__c> ordList {get;set;}
    //Map<id,List<String>> orderlicenseActivationKeyMap;
    Map<id,List<OSM_Order_Item_License__c>> orderlicenseActivationKeyMap;
    global List<OSM_Order_Item_License__c> orderItemLicenseList{get;set;}
    global decimal TotalPrice {get;set;}
    global decimal TotalDiscount {get;set;}
    global decimal TotalSubtotal {get;set;} 
    global decimal TotalTax {get;set;} 
    global decimal GrandTotal {get;set;} 
    // Added for MAR-710
    global boolean isPriceShowPermission {get; set;}
    global string accIdChkPerMtx {get; set;}
    global Boolean assignuserlink {get; set;}
    global Boolean showTaxverbiage {get; set;}
    global Boolean displayAddress{get;set;}//Added by Swetha
    //@Dhivyananthan - LL-12 & LL-15 - To show Purchase Order number on mail - 22/07/2022
    global Boolean displayPONumber{get;set;}
    global string poNumber {get; set;}

    global OSM_Email_ProductLine_Ctrl() {
        lstLineItemWrapper = new List<OerderLineItemDetail>();
        lstsubLineItems = new List<OerderLineItemDetail>(); 
        SubscriptionList  =new List<OerderLineItemDetail>();
        RequestQuoteList = new List<OerderLineItemDetail>();
        branchCustomer=false;
        hasLicenseProduct=false;
        isBMSPDFReceived = false;
        isPriceShowPermission = false;
        assignuserlink=true;
        showTaxverbiage=true;
        displayAddress=false;//added by swetha
        displayPONumber = false;//@Dhivyananthan - LL-12 & LL-15 - To show Purchase Order number on mail - 22/07/2022
    }
    
    global void setOrderIds(String orderId){
        System.debug('----Inside OSM_Email_ProductLine_Ctrl setOrderIds-----'+orderId);
        if(orderId!=null && orderId!='')
        { 
            List<ccrz__E_Order__c> orderList = [select id,ccrz__Account__r.name,ccrz__Account__r.IAM_Service_Provider_Code__c,OSM_SW_Purchase_By__c,OSM_Headquarter_Email__c,ccrz__BuyerEmail__c,Should_Show_Price__c,Original_Order_Subtotal__c,OSM_Discount_On_BMS__c,OSM_Discount_On_BOLT__c,OSM_Order_Status_Copy__c,Successful_Tool_Insatanc_Activation_Keys__c,ccrz__TotalAmount__c,ccrz__OrderStatus__c,name, Successful_Activation_Keys__c, Max_Activation_Keys__c,ActivationKeyAvailable__c,ccrz__Account__r.CSS_DistributorCode__c,ccrz__Account__r.BillingCountry,ccrz__Account__r.Customer_BMS_number__c from ccrz__E_Order__c where id =: orderId ];
            List<ccrz__E_OrderItem__c> ListOrderItem= [select id,Is_Revoked_Keys__c,ccrz__OrderItemStatus__c,Group_Name__c,ccrz__Order__c from ccrz__E_OrderItem__c where ccrz__Order__c =:orderId];
            //@Dhivyananthan - LL-12 & LL-15 - To show Purchase Order number on mail - 22/07/2022
            //@Navas- LL-56 & LL-57 - To show Purchase Order number on mail - 03/08/2022
            if (orderList.size() > 0) 
            {
                list <ccrz__E_Invoice__c> invoiceList =  [select id,BMS_PONumber__c from ccrz__E_Invoice__c where ccrz__CCOrder__c =:orderList[0].Id and BMS_PONumber__c != null and OSM_SW_IsIntercompanyInvoice__c = true  limit 1];
                if(invoiceList.size() > 0){
                    displayPONumber = true;
                    poNumber = invoiceList[0].BMS_PONumber__c;
                }
                else{
                    List < ccrz__E_TransactionPayment__c > objTransactionPayment  = [Select ccrz__AccountNumber__c, ccrz__AccountType__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c =:orderList[0].Id and  ccrz__AccountType__c ='po'];
                    if(objTransactionPayment.size() > 0)
                    {
                        displayPONumber = true;
                        poNumber = objTransactionPayment[0].ccrz__AccountNumber__c;  
                    }
                }  
            }
            d = datetime.now()+2; 
            monthName = d.format('dd MMMMM yyyy');
            if(orderList.size()>0){
                order = orderList[0];
                //Added by Swetha Start
                if(order.ccrz__Account__r.CSS_DistributorCode__c == '04959' && order.ccrz__Account__r.Customer_BMS_number__c!=null){
               		displayAddress = true; 
            	}
                //Ended by Swetha 
                orderitem = ListOrderItem[0];
                if(order.ccrz__OrderStatus__c=='Order Submitted')
                {
                    mailType = 'OrderSubmitted';
                    AccountName=order.ccrz__Account__r.name;
                    AccountNo=order.ccrz__Account__r.IAM_Service_Provider_Code__c;
                    handleOrderSubmitEmail(orderId);
                    /*      if(order.Max_Activation_Keys__c != order.Successful_Activation_Keys__c)
{
activationKeyErrorMessage = true;
}*/
                }
                else if(order.ccrz__OrderStatus__c=='Cancelled')
                {
                    mailType = 'OrderCancelled';
                    handleCancelOrderEmail(orderId);
                }
                else if(order.ccrz__OrderStatus__c=='Partially Cancelled')
                {
                    mailType = 'Partially Cancelled';
                    handleCancelOrderEmail(orderId);
                }
                //Added below if-else for 789
                if(order.ccrz__Account__r.BillingCountry != null && order.ccrz__Account__r.BillingCountry != '' && !Label.OSM_North_America_Country.contains(order.ccrz__Account__r.BillingCountry) && order.ccrz__Account__r.CSS_DistributorCode__c != null && order.ccrz__Account__r.CSS_DistributorCode__c != '' && !label.OSM_PO_Distributor_List.contains(order.ccrz__Account__r.CSS_DistributorCode__c))
                {
                    isGoms = true;
                }
                else
                {
                    isGoms = false;
                }
                
                for(ccrz__E_OrderItem__c orditem : ListOrderItem){
                    if(((orditem.Group_Name__c == 'DA')||(orditem.Group_Name__c == 'SES')&& (orditem.ccrz__OrderItemStatus__c=='Order Submitted'))||Test.isRunningTest()){
                        
                        orderitemsubmitted = true;
                        
                    }
                    if(((orditem.Group_Name__c == 'DA')||(orditem.Group_Name__c == 'SES')&& (orditem.ccrz__OrderItemStatus__c=='Cancelled'))||Test.isRunningTest()){
                        
                        OtherorderitemCancelled = true; 
                        
                    }
                    if(((orditem.Group_Name__c == 'FluidWatch')&& (orditem.ccrz__OrderItemStatus__c=='Cancelled'))||Test.isRunningTest()){
                        
                        FluidWatchorderitemCancelled = true;
                        
                    }
                    
                }
                
            }
            
        }
    }
    
    global ccrz__E_Order__c getOrder(){
        
        return order;
    }
    
    global void handleOrderSubmitEmail(String orderId)
    {
        fetchOrderInfo(orderId);
        
    }
    
    global void handleCancelOrderEmail(String orderId)
    {
        
        fetchOrderInfo(orderId);
        
    }
    
    
    public void fetchOrderInfo(String orderId)
    {
        set<String> productIds = new Set<String>();
        set<String>addOnProuct = new set<string>();
        list<ccrz__E_OrderItem__c> OrderItemList = new list<ccrz__E_OrderItem__c>();
        
        try{
            OrderItemList = [select id,isRenew__c,OSM_Renew_Subscription_End_Date__c,Date_Revoke__c,Vertex_Tax__c,Tool_Instance_Key__c,
                             ccrz__DisplayProduct__r.Group_Name__c,OMS_Product__c,ccrz__Order__r.ccrz__Account__r.Name,ccrz__Order__r.ccrz__Account__r.type, 
                             ccrz__Order__r.ActivationKeyAvailable__c,ccrz__Order__r.Company_Address__c, 
                             ccrz__Order__r.Max_Activation_Keys__c,ccrz__Order__r.Successful_Tool_Insatanc_Activation_Keys__c,
                             OMS_Activation_Key_Mail__c, ccrz__DisplayProduct__r.ccrz__SKU__c,ccrz__Order__r.ccrz__BuyerPhone__c,
                             ccrz__Order__r.ccrz__BuyerEmail__c,ccrz__Order__r.CreatedBy.name,ccrz__Order__r.ccrz__BuyerCompanyName__c,
                             ccrz__SubProdTerm__r.ccrz__DisplayName__c,OMS_Activation_Key__c,ccrz__ProductType__c,ccrz__DisplayProduct__c,
                             ccrz__OriginalQuantity__c,ccrz__DisplayProduct__r.ccrz__ShortDesc__c,ccrz__DisplayProduct__r.name, 
                             ccrz__DisplayProduct__r.LicenseName__c, ccrz__DisplayProduct__r.ProductGroup__c, ccrz__Product__r.name,
                             ccrz__Quantity__c,ccrz__Price__c,ccrz__ItemTotal__c,ccrz__ExtSKU__c,ccrz__Order__c,ccrz__Order__r.name,
                             ccrz__Coupon__r.name,ccrz__Coupon__r.ccrz__CouponCode__c,OSM_SW_Coupon_Applied__c,
                             ccrz__Order__r.Distributor_HQ_District__c, ccrz__Order__r.OSM_Headquarter_Email__c,
                             ccrz__Product_Name__c,ccrz__ParentOrderItem__c,OSM_SW_Product_Link__c,ccrz__Order__r.Is_BMS_PDF_Received__c,
                             //Label.OSM_Distributor_Admin_UserType
                             ccrz__Order__r.ccrz__Account__c, // Added for MAR-710
                              Number_of_Bundles__c,OSM_SW_Product_Link__r.Name, // @Suresh -LL-25 - To retrieve number of bundles value for Fleet count,Zap-it,Zap-it Oem products - 25/07/2022
                             ccrz__Order__r.Purchased_By_User_Type__c, ccrz__Order__r.isOnBehalf__c,ccrz__Order__r.Should_Show_Price__c,
                             Billing_Frequency__c,Discounted_Amount__c,Original_Price_without_Discount__c,Is_Revoked_Keys__c,Is_Reissued_Keys__c from ccrz__E_OrderItem__c where ccrz__Order__c =:orderId AND OrderItemConfirmationMailSent__c = false];
            Set<Id> orderItemIdSet=new Set<Id>();
            Set<Id> parentId = new Set<Id>();
            Map<string,list<IncludedProduct>> includedmap = new Map<string,list<IncludedProduct>>();
            for(ccrz__E_OrderItem__c orditem : OrderItemList){
                productIds.add(orditem.ccrz__DisplayProduct__c);
                orderItemIdSet.add(orditem.id);
                accIdChkPerMtx = orditem.ccrz__Order__r.ccrz__Account__c;
                if(orditem.ccrz__Order__r.Purchased_By_User_Type__c==Label.OSM_Fleet_Admin_UserType ||orditem.ccrz__Order__r.Purchased_By_User_Type__c==Label.OSM_Storefront_Admin_UserType)
                 assignuserlink=false; 
                if(orditem.ccrz__Order__r.Purchased_By_User_Type__c==Label.OSM_Distributor_Admin_UserType && (orditem.ccrz__Order__r.ccrz__Account__r.type=='Distributor Account' || orditem.ccrz__Order__r.ccrz__Account__r.type=='Distributor Branch Account'|| !orditem.ccrz__Order__r.isOnBehalf__c))
                 showTaxverbiage=true;//changes for MP-574 
                if(orditem.ccrz__ParentOrderItem__c!=Null){
                    IncludedProduct includeditem = new IncludedProduct();
                    includeditem.productQuantiy = orditem.ccrz__Quantity__c;
                    includeditem.productname = orditem.ccrz__Product_Name__c;
                    includeditem.Producttype = orditem.ccrz__ProductType__c;
                    if(includeditem.productQuantiy>998){
                        if(orditem.ccrz__Product_Name__c.contains('INSITE')){
                            includeditem.Productdisplay='License'; 
                        }else{
                            includeditem.Productdisplay='Unlimited users';  
                        }
                    }else{
                        if(orditem.ccrz__Product_Name__c.contains('INSITE')){
                            includeditem.Productdisplay= string.valueOf(includeditem.productQuantiy)+' License'; 
                        }else{
                            includeditem.Productdisplay=string.valueOf(includeditem.productQuantiy)+' Users';  
                        }      
                    }
                    if(includedmap.containskey(orditem.ccrz__ParentOrderItem__c)){
                        list<IncludedProduct> oldrecs = includedmap.get(orditem.ccrz__ParentOrderItem__c);
                        oldrecs.add(includeditem);
                        includedmap.put(orditem.ccrz__ParentOrderItem__c,oldrecs);
                    }else{
                        includedmap.put(orditem.ccrz__ParentOrderItem__c, new list<IncludedProduct>{includeditem}); 
                    }  
                }
                
            }
            System.debug('orderItemIdSet_____'+orderItemIdSet);
            orderItemLicenseList =[select id,Activation_Key__c,CC_Order_Item__c,type__c from OSM_Order_Item_License__c where CC_Order_Item__c=:orderItemIdSet];
            System.debug('orderItemLicenseList _____'+orderItemLicenseList);
            orderlicenseActivationKeyMap=new Map<id,List<OSM_Order_Item_License__c>>();
            List<String> activationKeysList;
            
            for(OSM_Order_Item_License__c orderLicense:orderItemLicenseList ){
                if(orderlicenseActivationKeyMap.containsKey(orderLicense.CC_Order_Item__c))
                {
                    List<OSM_Order_Item_License__c> orderItemLicList=orderlicenseActivationKeyMap.get(orderLicense.CC_Order_Item__c);
                    orderItemLicList.add(orderLicense);
                    orderlicenseActivationKeyMap.put(orderLicense.CC_Order_Item__c,orderItemLicList);
                }
                else
                {
                    List<OSM_Order_Item_License__c> orderItemLicList=new List<OSM_Order_Item_License__c>();
                    orderItemLicList.add(orderLicense);
                    orderlicenseActivationKeyMap.put(orderLicense.CC_Order_Item__c,orderItemLicList);
                }
                
                
                System.debug('orderlicenseActivationKeyMap++++++'+orderlicenseActivationKeyMap);
            }
            for(ccrz__E_OrderItem__c parentorderitem :[select id,OSM_Renew_Subscription_End_Date__c,Date_Revoke__c,Tool_Instance_Key__c,OMS_Product__c,ccrz__Order__r.ccrz__Account__r.Name, ccrz__Order__r.Company_Address__c, ccrz__Order__r.Max_Activation_Keys__c,ccrz__Order__r.Successful_Tool_Insatanc_Activation_Keys__c,OMS_Activation_Key_Mail__c, ccrz__DisplayProduct__r.ccrz__SKU__c,ccrz__Order__r.ccrz__BuyerPhone__c,ccrz__Order__r.ccrz__BuyerEmail__c,ccrz__Order__r.CreatedBy.name,ccrz__Order__r.ccrz__BuyerCompanyName__c,ccrz__SubProdTerm__r.ccrz__DisplayName__c,Vertex_Tax__c,OMS_Activation_Key__c,ccrz__ProductType__c,ccrz__DisplayProduct__c,ccrz__OriginalQuantity__c,ccrz__DisplayProduct__r.ccrz__ShortDesc__c,ccrz__DisplayProduct__r.name, ccrz__DisplayProduct__r.LicenseName__c, ccrz__DisplayProduct__r.ProductGroup__c, ccrz__Product__r.name,ccrz__Quantity__c,ccrz__Price__c,ccrz__ItemTotal__c,ccrz__ExtSKU__c,ccrz__Order__c,ccrz__Order__r.name,ccrz__Product__c,Billing_Frequency__c from ccrz__E_OrderItem__c where ccrz__Product__c IN:productIds]){
                addOnProuct.add(parentorderitem.ccrz__Product__c);
            }
            
            List<ccrz__E_ProductMedia__c> mediaList  = [select id,ccrz__MediaType__c, ccrz__Product__c,(SELECT Id, Name, ParentId FROM Attachments) from ccrz__E_ProductMedia__c where ccrz__Product__c IN: productIds and ccrz__MediaType__c = 'Product Image Thumbnail'];
            TotalPrice=TotalDiscount=TotalSubtotal=TotalTax=GrandTotal=0;
            
            for(ccrz__E_OrderItem__c orditem : OrderItemList){
                //skus.add(orditem.ccrz__DisplayProduct__r.ccrz__SKU__c);
                
                if((Label.SES_OMSCreateOrder_SubscriptionProduct_List.ContainsIgnoreCase(orditem.ccrz__DisplayProduct__r.ccrz__SKU__c) )){
                    hasLicenseProduct = true;
                }
                // Mar-1565 Start
                if(orditem.ccrz__Order__r.Is_BMS_PDF_Received__c == False){
                    system.debug('isBMSPDFReceived--->'+isBMSPDFReceived);
                    isBMSPDFReceived = True;
                    
                }
                //Mar-1565 End
                OerderLineItemDetail lineItem = new OerderLineItemDetail();
                lineItem.Quantity = Integer.valueOf(orditem.ccrz__OriginalQuantity__c);
                lineItem.ordername  = orditem.ccrz__Order__r.name;
                lineItem.orderItemType = orditem.ccrz__ProductType__c;
                // lineItem.activationKey = orditem.OMS_Activation_Key__c;
                lineItem.DateRevoked=orditem.Date_Revoke__c;
                lineItem.renewedSubscEndDate = '';
                if(orditem.OSM_Renew_Subscription_End_Date__c != null)
                    lineItem.renewedSubscEndDate = 'Renewed until '+orditem.OSM_Renew_Subscription_End_Date__c.Day()+' '+OSM_SW_ProductDetailCommonUtility.getMonth(orditem.OSM_Renew_Subscription_End_Date__c.Month())+' '+orditem.OSM_Renew_Subscription_End_Date__c.Year(); 
                
                lineItem.activationKeyMailSent = orditem.OMS_Activation_Key_Mail__c;
                lineItem.email = orditem.ccrz__Order__r.ccrz__BuyerEmail__c;
                lineItem.ordercompanyName = orditem.ccrz__Order__r.ccrz__Account__r.Name;
                lineItem.orderCompanyAddress = orditem.ccrz__Order__r.Company_Address__c;
                lineItem.phoneNumber = orditem.ccrz__Order__r.ccrz__BuyerPhone__c;
                lineItem.ordercreatedBy = orditem.ccrz__Order__r.CreatedBy.name;
                lineItem.orderItemSPTterm =  orditem.ccrz__SubProdTerm__r.ccrz__DisplayName__c;
                lineItem.name = orditem.ccrz__DisplayProduct__r.name;
                reissuedProdName=orditem.ccrz__DisplayProduct__r.name;
                lineItem.price = orditem.ccrz__Price__c;
                if(orditem.Vertex_Tax__c != null){
                    lineItem.Total = orditem.ccrz__ItemTotal__c + orditem.Vertex_Tax__c;
                }
                else{
                    lineItem.Total = orditem.ccrz__ItemTotal__c;
                }
                lineItem.originalTotal = orditem.Original_Price_without_Discount__c;
                lineItem.tax = orditem.Vertex_Tax__c;
                lineItem.shortDec = orditem.ccrz__DisplayProduct__r.ccrz__ShortDesc__c;
                lineItem.SKU=orditem.ccrz__DisplayProduct__r.ccrz__SKU__c;
                lineItem.MaxActivationKeys=orditem.ccrz__Order__r.Max_Activation_Keys__c;
                lineItem.SuccessfulToolInsatancActivationKeys=orditem.ccrz__Order__r.Successful_Tool_Insatanc_Activation_Keys__c;
                lineItem.OMSProduct=orditem.OMS_Product__c;
                
                lineItem.ToolInstanceKey=orditem.Tool_Instance_Key__c;
                lineItem.groupName=orditem.ccrz__DisplayProduct__r.Group_Name__c;
                lineItem.BillingFrequency=orditem.Billing_Frequency__c;
                lineItem.CouponApplied=orditem.OSM_SW_Coupon_Applied__c;
                decimal value=lineItem.Quantity*orditem.ccrz__Price__c;
                lineItem.ReissueCount=Integer.valueof(orditem.Is_Reissued_Keys__c);
                lineItem.RevokeCount=Integer.valueOf(orditem.Is_Revoked_Keys__c);
                TotalPrice+=value;
                if(lineItem.CouponApplied){
                    lineItem.CouponCode=orditem.ccrz__Coupon__r.ccrz__CouponCode__c;
                    //lineItem.DiscountTotal=value-lineItem.Total;
                    lineItem.DiscountTotal= orditem.Discounted_Amount__c;
                    
                    TotalDiscount=TotalDiscount+lineItem.DiscountTotal;
                }
                TotalSubtotal+=orditem.ccrz__ItemTotal__c;
                if(lineItem.tax != null){
                    TotalTax=TotalTax+lineItem.tax;
                }
                else{
                    TotalTax=TotalTax;
                }
                GrandTotal+= lineItem.Total;
                
                if(orderlicenseActivationKeyMap.get(orditem.id)!=null){
                    activationKeyErrorMessage = false;
                    for(OSM_Order_Item_License__c orderItemLic:orderlicenseActivationKeyMap.get(orditem.id))
                    {
                        if(orderItemLic.Type__c=='Functional')
                        {
                            lineItem.FunActivationKey = orderItemLic.Activation_Key__c; 
                        }
                        if(orderItemLic.Type__c=='Basic')
                        {
                            lineItem.BasicActivationKey = orderItemLic.Activation_Key__c; 
                        }
                    }
                    
                }
                else{
                    if(Label.OMS_ProductList.contains(orditem.ccrz__DisplayProduct__r.ccrz__SKU__c) && !orditem.isRenew__c)
                    {
                        activationKeyErrorMessage = true;
                    }
                } 
                lineItem.licenseName = orditem.ccrz__DisplayProduct__r.LicenseName__c;
                lineItem.productGroup = orditem.ccrz__DisplayProduct__r.ProductGroup__c;
                if(addOnProuct.contains(orditem.ccrz__DisplayProduct__c)){
                    lineItem.name = orditem.ccrz__Product__r.name;
                }      
                for(ccrz__E_ProductMedia__c media : mediaList){
                    if(orditem.ccrz__DisplayProduct__c == media.ccrz__Product__c){     
                        for(attachment a:media.attachments) {
                            lineItem.uri = a.id;
                            lineItem.imageUrl = label.OSM_DEV_URL+'/servlet/servlet.FileDownload?file='+a.id;
                        }
                    }
                }
                
                //Code Added by for MAR-19
                lineItem.shouldIncludePrice = true;
                shouldShowPrice = true;
                lineItem.isDistributorPurchased = false;
                system.debug('branchCustomer-->>'+branchCustomer);
                if( ( (orditem.ccrz__Order__r.isOnBehalf__c && Label.OSM_Distributor_Admin_UserType ==orditem.ccrz__Order__r.Purchased_By_User_Type__c ) || Label.OSM_SSOEM_Admin_UserType ==orditem.ccrz__Order__r.Purchased_By_User_Type__c) && branchCustomer){
                    lineItem.shouldIncludePrice = orditem.ccrz__Order__r.Should_Show_Price__c;
                    shouldShowPrice = orditem.ccrz__Order__r.Should_Show_Price__c;
                    lineItem.isDistributorPurchased = true;
                    headQuaterName = orditem.ccrz__Order__r.Distributor_HQ_District__c;
                } 
                if(orditem.ccrz__DisplayProduct__c != null){
                    if(orditem.ccrz__ProductType__c=='Bundle' && orditem.ccrz__Product_Name__c.containsAny('Cummins Guidanz™ Service Package')){
                        lineItem.Showincludedlink=true;
                    }
                    
                    
                }
                if(includedmap.containskey(orderItem.id)){
                    lineItem.lstIncludedProduct=includedmap.get(orderItem.id);
                    //orderItem.product.includeditems=includedmap.get(orderItem.product.orderitemid); 
                }
                //Start- @Suresh -LL-25 - Logic to assign value of number of bundles for each order item and make showNumberOfBundles value to true to show value in order email confirmation page 25/07/2022
               List<String> OSM_ShowNumberofBundlesChkValues = String.isBlank(label.OSM_ShowNumberofBundlesValue) ? new List<String>() : (List<String>) label.OSM_ShowNumberofBundlesValue.split(',');
                   	lineItem.showNumberOfBundles = false;
                	lineItem.numberOfBundles = Integer.valueOf(ordItem.Number_of_Bundles__c);
                            for(String valChk: OSM_ShowNumberofBundlesChkValues) {	
                                if(ordItem.OSM_SW_Product_Link__r.Name.equalsIgnoreCase(valChk)) {	
                                    lineItem.showNumberOfBundles=true;	
                                }	
                            }	
                //End -@Suresh -LL-25
                lstsubLineItems.add(lineItem);
                system.debug('List>>>>'+ lstsubLineItems);
                
                
                
            }
            
        }catch(exception ex){
            system.debug(ex+'===>'+ex.getLineNumber());
        }
        //return lstLineItems;
        
        
    }
    
    //Get Subscriptions and related order and product and product media
    global List<OerderLineItemDetail> getIncalSubscriptionList(){
        system.debug('getIncalSubscriptionList====>'+incalSubIds);
        //private void fetchSubscriptionInfo(string subsriptionId){
        List<ccrz__E_Subscription__c> SubscriptionList = new List<ccrz__E_Subscription__c>();
        set<String> productIds = new Set<String>();
        set<String>addOnProuct = new set<string>();
        // List<OerderLineItemDetail> lstsubLineItems = new  List<OerderLineItemDetail>();
        try{
            SubscriptionList =  [select id,OSM_Subscription_End_Date__c,ccrz__SPT__r.Billing_Display_Name__c,
                                 OSM_Free_Trial__c,OSM_Display_Product__c,OSM_Display_Product__r.name,
                                 OSM_Display_Product__r.ccrz__SKU__c,OSM_Display_Product__r.ccrz__ShortDesc__c,
                                 ccrz__CCOrder__c,ccrz__CCOrder__r.name,ccrz__Quantity__c,
                                 ccrz__SubscriptionProduct__c,ccrz__SubscriptionProduct__r.name,
                                 ccrz__SubscriptionStatus__c,ccrz__SubscriptionProduct__r.ccrz__ShortDesc__c,
                                 ccrz__SubscriptionProduct__r.ccrz__SKU__c, ccrz__CCOrderItem__r.ccrz__Quantity__c,
                                 ccrz__CCOrderItem__r.ccrz__Price__c,ccrz__CCOrderItem__r.ccrz__ItemTotal__c,
                                 ccrz__CCOrderItem__r.Vertex_Tax__c,
                                 ccrz__CCOrderItem__r.ccrz__DisplayProduct__r.ccrz__ShortDesc__c,
                                 ccrz__CCOrderItem__r.ccrz__DisplayProduct__r.ccrz__SKU__c,
                                 ccrz__CCOrderItem__r.ccrz__DisplayProduct__r.name,
                                 ccrz__CCOrderItem__r.Date_Revoke__c,
                                 ccrz__CCOrderItem__r.ccrz__Order__r.ccrz__Account__r.Name
                                 
                                 from ccrz__E_Subscription__c 
                                 where ccrz__CCOrderItem__c =:incalSubIds 
                                 limit 1];
            
            system.debug('@@@@@@'+SubscriptionList);
            
            
            for(ccrz__E_Subscription__c sub : SubscriptionList){
                productIds.add(sub.OSM_Display_Product__c);
                
            }
            
            List<ccrz__E_ProductMedia__c> mediaList  = [select id,ccrz__MediaType__c, ccrz__Product__c,(SELECT Id, Name, ParentId FROM Attachments) from ccrz__E_ProductMedia__c where ccrz__Product__c IN: productIds and ccrz__MediaType__c = 'Product Image Thumbnail'];
            for(ccrz__E_Subscription__c sub :SubscriptionList){
                DateTime systemDate =  System.Now();
                mailType = 'OrderSubmitted';
                OerderLineItemDetail lineItem = new OerderLineItemDetail();
                lineItem.Quantity = Integer.valueOf(sub.ccrz__CCOrderItem__r.ccrz__Quantity__c);
                lineItem.ordercompanyName = sub.ccrz__CCOrderItem__r.ccrz__Order__r.ccrz__Account__r.Name;                  
                lineItem.name = sub.ccrz__CCOrderItem__r.ccrz__DisplayProduct__r.name;
                lineItem.price = sub.ccrz__CCOrderItem__r.ccrz__Price__c;
                lineItem.DateRevoked = sub.ccrz__CCOrderItem__r.Date_Revoke__c;
                ordercompanyName = sub.ccrz__CCOrderItem__r.ccrz__Order__r.ccrz__Account__r.Name; 
                DateRevoked = ''+ Date.today().Day()+' '+OSM_SW_ProductDetailCommonUtility.getMonth(Date.today().Month())+' '+Date.today().Year();
                if(sub.ccrz__CCOrderItem__r.Date_Revoke__c != null){
                    DateRevoked = ''+ sub.ccrz__CCOrderItem__r.Date_Revoke__c.Day()+' '+OSM_SW_ProductDetailCommonUtility.getMonth(sub.ccrz__CCOrderItem__r.Date_Revoke__c.Month())+' '+sub.ccrz__CCOrderItem__r.Date_Revoke__c.Year();
                }
                if(sub.ccrz__CCOrderItem__r.Vertex_Tax__c != null){
                    lineItem.Total = sub.ccrz__CCOrderItem__r.ccrz__ItemTotal__c + sub.ccrz__CCOrderItem__r.Vertex_Tax__c;
                }else{
                    lineItem.Total = sub.ccrz__CCOrderItem__r.ccrz__ItemTotal__c;
                }
                lineItem.tax = sub.ccrz__CCOrderItem__r.Vertex_Tax__c;
                lineItem.shortDec = sub.ccrz__CCOrderItem__r.ccrz__DisplayProduct__r.ccrz__ShortDesc__c;
                lineItem.SKU=sub.ccrz__CCOrderItem__r.ccrz__DisplayProduct__r.ccrz__SKU__c;      
                lineItem.URLSubsciption = label.OSM_FreeTrial_PurchaseSubscription_link +sub.OSM_Display_Product__r.ccrz__SKU__c;
                if(addOnProuct.contains(sub.OSM_Display_Product__c)){
                    lineItem.Name = sub.ccrz__SubscriptionProduct__r.name;
                    lineItem.URLSubsciption = label.OSM_FreeTrial_PurchaseSubscription_link +sub.ccrz__SubscriptionProduct__r.ccrz__SKU__c;
                }
                for(ccrz__E_ProductMedia__c media : mediaList){     
                    if(sub.OSM_Display_Product__c == media.ccrz__Product__c){ 
                        for(attachment a:media.attachments) {
                            lineItem.uri = a.id;
                            lineItem.imageUrl = label.OSM_DEV_URL+'/servlet/servlet.FileDownload?file='+a.id;
                        } 
                    }
                }
                
                lstsubLineItems.add(lineItem);
            }
            
            system.debug('$$$$$$$'+lstsubLineItems);
        }catch(exception ex){system.debug(ex+'===>'+ex.getLineNumber());}
        return lstsubLineItems;
    }
    
    //Get Subscriptions and related order and product and product media
    global List<OerderLineItemDetail> getSubscriptionList(){
        
        //private void fetchSubscriptionInfo(string subsriptionId){
        List<ccrz__E_Subscription__c> SubscriptionList = new List<ccrz__E_Subscription__c>();
        set<String> productIds = new Set<String>();
        set<String>addOnProuct = new set<string>();
        // List<OerderLineItemDetail> lstsubLineItems = new  List<OerderLineItemDetail>();
        try{
            SubscriptionList =  [select id,OSM_Subscription_End_Date__c,ccrz__SPT__r.Billing_Display_Name__c,ccrz__SPT__r.ccrz__DisplayName__c,
                                 OSM_Free_Trial__c,OSM_Display_Product__c,OSM_Display_Product__r.name,
                                 OSM_Display_Product__r.ccrz__SKU__c,OSM_Display_Product__r.ccrz__ShortDesc__c,
                                 ccrz__CCOrder__c,ccrz__CCOrder__r.name,ccrz__Quantity__c,
                                 ccrz__SubscriptionProduct__c,ccrz__SubscriptionProduct__r.name,
                                 ccrz__SubscriptionStatus__c,ccrz__SubscriptionProduct__r.ccrz__ShortDesc__c,
                                 ccrz__SubscriptionProduct__r.ccrz__SKU__c,ccrz__CCOrderItem__r.ccrz__Quantity__c,
                                 ccrz__CCOrder__r.Should_Show_Price__c,ccrz__CCOrder__r.Distributor_HQ_District__c,
                                 ccrz__CCOrder__r.isOnBehalf__c,ccrz__CCOrder__r.Purchased_By_User_Type__c,ccrz__Account__r.Name,
                                 ccrz__CCOrder__r.OSM_Headquarter_Email__c,ccrz__CCOrder__r.OSM_SW_Purchase_By__c,ccrz__RecurringPrice__c,ccrz__RecurringPriceSubAmt__c
                                 from ccrz__E_Subscription__c 
                                 where id =:subsriptionIds 
                                 and ccrz__Quantity__c >=0 
                                 and (ccrz__SubscriptionStatus__c = 'Active' 
                                      OR ccrz__SubscriptionStatus__c ='Expired' 
                                      OR ccrz__SubscriptionStatus__c='Revoked')
                                 limit 1];//ccrz__SPT__r.ccrz__DisplayName__c Added by swetha for MP-655
            
            system.debug('@@@@@@'+SubscriptionList);
            
            
            for(ccrz__E_Subscription__c sub : SubscriptionList){
                productIds.add(sub.OSM_Display_Product__c);
            }
            
            for(ccrz__E_Subscription__c sub : SubscriptionList){
                if( ( (sub.ccrz__CCOrder__r.isOnBehalf__c && Label.OSM_Distributor_Admin_UserType ==
                       sub.ccrz__CCOrder__r.Purchased_By_User_Type__c ) || 
                     Label.OSM_SSOEM_Admin_UserType ==
                     sub.ccrz__CCOrder__r.Purchased_By_User_Type__c) && branchCustomer){
                         shouldShowPrice = sub.ccrz__CCOrder__r.Should_Show_Price__c;
                         //lineItem.isDistributorPurchased = true;
                         headQuaterName = sub.ccrz__CCOrder__r.Distributor_HQ_District__c;
                         headQuaterEmail = sub.ccrz__CCOrder__r.OSM_Headquarter_Email__c;
                     }
            }    
            
            for(ccrz__E_Subscription__c parentSubscription :  [select id,OSM_Subscription_End_Date__c,ccrz__SPT__r.Billing_Display_Name__c,OSM_Free_Trial__c,OSM_Display_Product__c,OSM_Display_Product__r.name,OSM_Display_Product__r.ccrz__SKU__c,OSM_Display_Product__r.ccrz__ShortDesc__c,ccrz__CCOrder__c,ccrz__CCOrder__r.name,ccrz__Quantity__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionProduct__r.name,ccrz__SubscriptionStatus__c,ccrz__SubscriptionProduct__r.ccrz__ShortDesc__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c from ccrz__E_Subscription__c where ccrz__SubscriptionProduct__c IN:productIds and ccrz__Quantity__c >=0 and (ccrz__SubscriptionStatus__c = 'Active' OR ccrz__SubscriptionStatus__c ='Expired' OR ccrz__SubscriptionStatus__c='Revoked')limit 1]){
                addOnProuct.add(parentSubscription.ccrz__SubscriptionProduct__c);
            }
            
            system.debug('!!!!addOnProuct'+addOnProuct);
            
            List<ccrz__E_ProductMedia__c> mediaList  = [select id,ccrz__MediaType__c, ccrz__Product__c,(SELECT Id, Name, ParentId FROM Attachments) from ccrz__E_ProductMedia__c where ccrz__Product__c IN: productIds and ccrz__MediaType__c = 'Product Image Thumbnail'];
            for(ccrz__E_Subscription__c sub :SubscriptionList){
                DateTime systemDate =  System.Now();
                OerderLineItemDetail lineItem = new OerderLineItemDetail();
                lineItem.Quantity = Integer.valueOf(sub.ccrz__CCOrderItem__r.ccrz__Quantity__c);
                
                lineItem.Name = sub.OSM_Display_Product__r.name;
                lineItem.billingPeriod = sub.ccrz__SPT__r.Billing_Display_Name__c;
                lineItem.subscriptionLength = sub.ccrz__SPT__r.ccrz__DisplayName__c; //Code Added by Raju:11/02/2021 for MP-265.
                lineItem.status = sub.ccrz__SubscriptionStatus__c;
                lineItem.freetrial = sub.OSM_Free_Trial__c;
                lineItem.SubexpiredDate = sub.OSM_Subscription_End_Date__c;
                lineItem.contactName = sub.ccrz__CCOrder__r.OSM_SW_Purchase_By__c;
                lineItem.email = sub.ccrz__CCOrder__r.OSM_Headquarter_Email__c;
                lineItem.ordercompanyName = sub.ccrz__Account__r.Name;
                lineItem.mySubscriptionURL = label.OSM_MySubscription_Link;
                lineItem.totaldays = systemDate.date().daysBetween(lineItem.SubexpiredDate.date());
                lineItem.URLSubsciption = label.OSM_FreeTrial_PurchaseSubscription_link +sub.OSM_Display_Product__r.ccrz__SKU__c;
                if(addOnProuct.contains(sub.OSM_Display_Product__c)){
                    lineItem.Name = sub.ccrz__SubscriptionProduct__r.name;
                    lineItem.URLSubsciption = label.OSM_FreeTrial_PurchaseSubscription_link +sub.ccrz__SubscriptionProduct__r.ccrz__SKU__c;
                }
                for(ccrz__E_ProductMedia__c media : mediaList){     
                    if(sub.OSM_Display_Product__c == media.ccrz__Product__c){ 
                        for(attachment a:media.attachments) {
                            lineItem.uri = a.id;
                            lineItem.imageUrl = label.OSM_DEV_URL+'/servlet/servlet.FileDownload?file='+a.id;
                        } 
                    }
                }
                
                lstsubLineItems.add(lineItem);
            }
            
            system.debug('$$$$$$$'+lstsubLineItems);
        }catch(exception ex){system.debug(ex+'===>'+ex.getLineNumber());}
        return lstsubLineItems;
    }
    
    //Get request for quote and related product
    global List<OerderLineItemDetail> getRequestQuoteList(){
        List<ccrz__E_RequestForQuote__c> RequestQuoteList = new List<ccrz__E_RequestForQuote__c>();
        
        set<String> productIds = new Set<String>();
        try{
            RequestQuoteList =  [select id,Expired_Date__c,CompanyName__c,OSM_CommunityUser__c,Available_Subscription__c,OSM_Discounted_Total_Price__c,Discounted_Per_Billing_Frequency_Price__c,Amount_Per_Billing_Period__c,OSM_Sales_Admin__c,Status__c,ccrz__Contact__c,ccrz__Account__c,Display_Product__c,Display_Product__r.name,Display_Product__r.ccrz__ShortDesc__c,Quantity__c,Billing_Period__c,Subscription_Length__c,Product_Plan__c from ccrz__E_RequestForQuote__c where id =:requestQuoteIds limit 1];
            system.debug('@@@@@@'+RequestQuoteList);
            for(ccrz__E_RequestForQuote__c quote : RequestQuoteList){
                productIds.add(quote.Display_Product__c);
            }
            List<ccrz__E_ProductMedia__c> mediaList  = [select id,ccrz__MediaType__c, ccrz__Product__c,(SELECT Id, Name, ParentId FROM Attachments) from ccrz__E_ProductMedia__c where ccrz__Product__c IN: productIds and ccrz__MediaType__c = 'Product Image Thumbnail'];
            for(ccrz__E_RequestForQuote__c quote :RequestQuoteList){
                OerderLineItemDetail lineItem = new OerderLineItemDetail();
                lineItem.Quantity = Integer.valueOf(quote.Quantity__c);
                lineItem.Name = quote.Display_Product__r.name;
                lineItem.shortDec = quote.Display_Product__r.ccrz__ShortDesc__c;
                lineItem.status = quote.Status__c; 
                lineItem.expiredDate = quote.Expired_Date__c;
                lineItem.subLength = quote.Subscription_Length__c;
                lineItem.billingPeriod = quote.Billing_Period__c;
                for(ccrz__E_ProductMedia__c media : mediaList){     
                    if(quote.Display_Product__c == media.ccrz__Product__c){ 
                        for(attachment a:media.attachments) {
                            lineItem.uri = a.id;
                            lineItem.imageUrl = label.OSM_DEV_URL+'/servlet/servlet.FileDownload?file='+a.id;
                        } 
                    }
                }
                
                lstsubLineItems.add(lineItem);
            }
            
            system.debug('$$$$$$$'+lstsubLineItems);
        }catch(exception ex){system.debug(ex+'===>'+ex.getLineNumber());}
        return lstsubLineItems;
    } 
    
    //Get Invoice
    global List<OerderLineItemDetail> getinvoiceItemList(){
        List<ccrz__E_InvoiceItem__c> invoiceItemList = new List<ccrz__E_InvoiceItem__c >();
        //if(!Test.isRunningTest()){
        OSM_Integration_Log__c osmIntegrationLog =  [Select id,Service_Name__c,Status__c,Target__c,Invoice__c from OSM_Integration_Log__c where Status__c='Failure' and id=:osmIntegerationId limit 1];
        //   [Select id,Service_Name__c,Status__c,Target__c,Invoice__c from OSM_Integration_Log__c];
        system.debug('#####'+osmIntegrationLog);
        //}
        set<String> productIds = new Set<String>();
        try{
            
            //for(OSM_Integration_Log__c log : osmIntegrationLog){
            invoiceIds = osmIntegrationLog.Invoice__c;
            //serviceName = osmIntegrationLog.Service_Name__c;
            system.debug('@@@@@@@invoiceIds'+invoiceIds);
            //}
            invoiceItemList =  [select id,ccrz__Invoice__r.IntercompanyCalled__c,ccrz__CCOrder__r.name,ccrz__Invoice__r.OSM_SW_IsIntercompanyInvoice__c,ccrz__Invoice__r.ccrz__CCOrder__c,ccrz__CCOrderItem__c,ccrz__CCOrderItem__r.ccrz__Quantity__c,ccrz__CCOrderItem__r.isRenew__c, ccrz__CCOrderItem__r.ccrz__Price__c,ccrz__CCOrderItem__r.ccrz__ItemTotal__c,ccrz__CCOrderItem__r.ccrz__DisplayProduct__c,ccrz__Invoice__c,ccrz__CCOrderItem__r.ccrz__DisplayProduct__r.ccrz__ShortDesc__c,ccrz__CCOrderItem__r.ccrz__DisplayProduct__r.name from ccrz__E_InvoiceItem__c where ccrz__Invoice__c =:invoiceIds limit 1];
            system.debug('@@@@@@'+invoiceItemList);
            
            for(ccrz__E_InvoiceItem__c invItem : invoiceItemList){
                productIds.add(invItem.ccrz__CCOrderItem__r.ccrz__DisplayProduct__c);
            }
            List<ccrz__E_ProductMedia__c> mediaList  = [select id,ccrz__MediaType__c, ccrz__Product__c,(SELECT Id, Name, ParentId FROM Attachments) from ccrz__E_ProductMedia__c where ccrz__Product__c IN: productIds and ccrz__MediaType__c = 'Product Image Thumbnail'];
            for(ccrz__E_InvoiceItem__c invItem :invoiceItemList){
                OerderLineItemDetail lineItem = new OerderLineItemDetail();
                lineItem.intercompanyInv = invItem.ccrz__Invoice__r.OSM_SW_IsIntercompanyInvoice__c;
                lineItem.invoice = invItem.ccrz__Invoice__r.IntercompanyCalled__c;
                lineItem.orderNumber = invItem.ccrz__CCOrder__r.name;
                lineItem.Quantity = Integer.valueOf(invItem.ccrz__CCOrderItem__r.ccrz__Quantity__c);
                lineItem.isRenew = invItem.ccrz__CCOrderItem__r.isRenew__c;
                
                lineItem.Name = invItem.ccrz__CCOrderItem__r.ccrz__DisplayProduct__r.name;
                lineItem.shortDec = invItem.ccrz__CCOrderItem__r.ccrz__DisplayProduct__r.ccrz__ShortDesc__c;
                lineItem.Total = invItem.ccrz__CCOrderItem__r.ccrz__ItemTotal__c;
                lineItem.Price = invItem.ccrz__CCOrderItem__r.ccrz__Price__c;
                // lineItem.status = quote.Status__c; 
                // lineItem.expiredDate = quote.Expired_Date__c;
                //lineItem.subLength = quote.Subscription_Length__c;
                // lineItem.billingPeriod = quote.Billing_Period__c;
                for(ccrz__E_ProductMedia__c media : mediaList){     
                    if(invItem.ccrz__CCOrderItem__r.ccrz__DisplayProduct__c == media.ccrz__Product__c){ 
                        for(attachment a:media.attachments) {
                            lineItem.uri = a.id;
                            lineItem.imageUrl = label.OSM_DEV_URL+'/servlet/servlet.FileDownload?file='+a.id;
                        } 
                    }
                }
                
                lstsubLineItems.add(lineItem);
            }
            
            system.debug('$$$$$$$'+lstsubLineItems);
        }catch(exception ex){system.debug(ex+'===>'+ex.getLineNumber());}
        return lstsubLineItems;
    } 
    
    
    // get Order subscription and related product and product media
    global List<OerderLineItemDetail> getOrderSubsList ()
    {
        OSM_Account_Permission_Matrix__c accPerMatrx = OSM_SW_PermissionMatrixDao.getPermissionsFromAccount(accIdChkPerMtx);
        if(accPerMatrx != null){
            isPriceShowPermission = accPerMatrx.Show_price_for_branch_accounts__c;
        }
        return lstsubLineItems;
    }
    //*****End******
    
    global OerderLineItemDetail orderLineItem {get;set;}
    
    global Class OerderLineItemDetail{
        global string name { get; set; }
        global string renewedSubscEndDate{get;set;}
        global boolean isRenew{get;set;}
        global string ordername { get; set; }
        global string orderItemType { get; set; }
        global string orderItemSPTterm { get; set; }
        global string ordercompanyName {get;set;}
        global string orderCompanyAddress {get;set;}
        global string ordercreatedBy {get;set;}
        global string email {get;set;}
        global string contactName {get;set;}
        global string phoneNumber {get;set;}
        global string status { get; set; }
        global boolean freetrial { get; set; }
        global string uri { get; set; }
        global string imageUrl { get; set; }
        global string expiredmonthName { get; set; }
        //global object productDescription { get; set; }
        global Decimal Quantity{get;set;}
        global string shortDec{get;set;}
        global String activationKey{get;set;}
        // global List<string> activationKey{get;set;}
        global Boolean activationKeyMailSent{get;set;}
        global Decimal Price {get;set;}
        global Decimal Total{get;set;}
        global Decimal originalTotal{get;set;}
        global Decimal tax{get;set;}
        global string subLength {get;set;}
        global string billingPeriod {get;set;}
        global string subscriptionLength {get;set;}
        global dateTime expiredDate {get;set;}
        global dateTime SubexpiredDate {get;set;}
        global string URLSubsciption {get;set;} 
        global string mySubscriptionURL{get;set;}
        global integer totaldays {get;set;}
        global string orderNumber {get;set;}
        global boolean intercompanyInv { get; set; }
        global boolean invoice { get; set; }
        global String licenseName { get; set; }
        global String productGroup { get; set; }
        global string SKU {get;set;}
        global Decimal MaxActivationKeys{get;set;}
        global Decimal SuccessfulToolInsatancActivationKeys{get;set;}
        global Boolean OMSProduct{get;set;}
        global String ToolInstanceKey{get;set;}
        global String groupName{get;set;}
        global String BillingFrequency{get;set;}
        global String FunActivationKey{get;set;}
        global String BasicActivationKey{get;set;}
        global String CouponCode{get;set;}
        global Boolean CouponApplied{get;set;}
        global Decimal  DiscountTotal{get;set;}
        global Integer ReissueCount{get;set;}
        global Integer RevokeCount{get;set;}
        global OerderLineItemDetail(){
            isRenew = false;
            CouponApplied=false;
            lstIncludedProduct = new List<IncludedProduct>();
            Showincludedlink =false;
            showNumberOfBundles=false;
        }
        global Boolean shouldSendEmailtoBranch{get;set;}
        global Boolean shouldIncludePrice{get;set;}
        global Boolean isDistributorPurchased{get;set;}
        global Boolean isOnBehalfOf{get;set;}
        global dateTime DateRevoked{get;set;}
        // @Suresh LL-25 - Start - Added two variables for storing number of bundles and to show the same value in order confirmation email
       global Decimal numberOfBundles { get; set; }  
        global Boolean showNumberOfBundles { get; set; } 
        //@Suresh LL-25 - End
        global String Producttype;
        global Boolean Showincludedlink {get;set;}
        global List<IncludedProduct> lstIncludedProduct {get;set;}
    }
    global class IncludedProduct{
        global String productname{get;set;}
        global String Producttype{get;set;}
        global String Productdisplay{get;set;}
        global decimal productQuantiy{get;set;}
    }
}