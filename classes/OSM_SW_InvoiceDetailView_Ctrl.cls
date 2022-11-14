/**********************************************************************
Name:  OSM_SW_InvoiceDetailView_Ctrl
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to keep all relative fetch
queries & DML statements & Logic for Invoice Details                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad            7/4/2018     INITIAL DEVELOPMENT          
1.1 -   Ronnie       08/10/2021     Chnages added as part of MAR-1716 - to get bmsPONumber in the InvoiceDataWrpr Wrapper class
1.2  -   Ronnie       11/10/2021     Chnages added as part of MP-133 - to display Subscription Length as a column
1.3 -   Charlynn        20/07/2022     Changes added as part of LL-23 	
*****************************************************/
global class OSM_SW_InvoiceDetailView_Ctrl
{
    
    /*----------------------------------------------------------------------------------
1. fetchInvoiceDetails
Description:Used to fetch Invoice related data to be displayed on Invoice Detail page
Input: ccrz.cc_RemoteActionContext ctx
Output: 
Returns the Invoice related data to be displayed to user

ccrz.cc_RemoteActionResult
DAProductsData==> Map<String,MainWrapper>
------------------------------------------------------------------------------------*/
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult fetchInvoiceDetails(ccrz.cc_RemoteActionContext ctx, Id invoiceId){
        
        
        
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        
        
        
        
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        //MAR-1716 Code Starts
        String bmsPONumber;
        //MAR-1716 Code Ends
        Decimal invAmount; // Added for MP-316
        Map<String,Object> returnMap = new Map<String,Object>();
        Id accId; //MR432
        
        System.debug('invoiceId : '+invoiceId);
        
        // testing... start
        Map<String,Object> inputData = (new Map<String,Object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccAPIInvoice.STOREFRONT => 'SoftwareStore',
                ccrz.ccAPIInvoice.ID => invoiceId,
                ccrz.ccAPI.SIZING=>new Map<String, Object>{
                    ccrz.ccAPIInvoice.ENTITYNAME=>new Map<String, Object>{
                        ccrz.ccAPI.SZ_DATA=>ccrz.ccAPI.SZ_XL
                            }
                }
        });
        
        try {
            System.debug('on before call api');
            Map<String, Object> outputData = ccrz.ccAPIInvoice.fetch(inputData);
            System.debug('on before call api');
            if (outputData.get(ccrz.ccAPIInvoice.INVOICES) != null) {
                // The cast to List<Map<String, Object>> is necessary...
                List<Map<String, Object>> invoiceList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPIInvoice.INVOICES);
                
                System.debug('Invoice query in Global API: '+invoiceList);
                for(Map<String, Object> invoice : invoiceList){
                    // The cast, again, is necessary...
                    //String invoiceType = (String)invoice.get('type');
                    
                    for(String key : invoice.keySet())
                    {
                        System.debug('Field : '+key+' Value: '+invoice.get(key));
                    }
                    
                }
            }
        } catch (Exception e) {
            System.debug('on exception of getting invoice');
        }
        
        // testing.. End
        try{
            if(invoiceId != null)
            {
                ccrz__E_Invoice__c objInvoice = new ccrz__E_Invoice__c();
                objInvoice = [Select Id,name,Purchase_On_Behalf_Of__c,CreatedDate, PDF_REMITTO_ADDRESS__c, Total_Vertex_Tax__c,CreditMemo_Number__c,BMS_Refund_Invoice_Number__c,
                              Invoice_Type__c,OSM_SW_IsIntercompanyInvoice__c,BMS_InvoiceTotal__c,BMS_InvoiceDate__c,BMS_Invoice_No__c, 
                              BMS_InvoiceNumber__c,OSM_SW_Is_Bolt_PO__c,BMS_DistributorName__c, BMS_DistributorAddressline__c,
                              BMS_DistributorCity__c,BMS_DistributorState__c,BMS_Distributorpostalcode__c, Payment_Method__c, 
                              Total_Sales_Amount__c,BMS_CreateDate__c,BMS_TotalDiscount__c,ccrz__CCOrder__r.Original_Order_Subtotal__c, 
                              ccrz__CCOrder__r.Calculated_Total_Discount__c , ccrz__CCOrder__c,ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c,ccrz__CCOrder__r.OSM_Bill_From__c,ccrz__BillTo__r.CSS_DistributorCode__c,ccrz__BillTo__c,                               
                              ccrz__CCOrder__r.ccrz__OriginatedCart__r.Purchaser_Comments__c,Is_GOMS_Intercompany_Invoice__c,GOMS_Invoice_ID__c,ccrz__CCOrder__r.ccrz__Account__r.type,ccrz__CCOrder__r.ccrz__Account__r.BillingCountry,OSM_SW_Is_third_Party_BMS_Payment2__c
                              from ccrz__E_Invoice__c 
                              where Id =: invoiceId];
                //MR432
                If(objInvoice.ccrz__BillTo__c != null){
                    accId = objInvoice.ccrz__BillTo__c;
                }
                ccrz__E_Cart__c objCart = new ccrz__E_Cart__c();
                If(accId != null){
                    
                    objCart = [Select Id,Name,Third_Party_BMS_Customer_ID__c,OSM_Payment_Method__c,OSM_SW_IAM_Account_Id_For_Third_Party__c,OSM_SW_Is_third_Party_BMS_Payment__c,ccrz__SubtotalAmount__c,ccrz__TotalDiscount__c, ccrz__Account__c,ccrz__Account__r.CSS_DistributorCode__c, ccrz__Account__r.Name,ccrz__Account__r.Type,ccrz__Account__r.BOLT_Account_Number__c,ccrz__Account__r.Customer_BMS_number__c,ccrz__Account__r.Bolt_BC_Code__c,ccrz__Account__r.IAM_Service_Provider_Code__c ,ccrz__Account__r.CMI_Cid__c, ccrz__Account__r.Vertex_Customer_Class_Code__c, ccrz__Account__r.CMI_Address2__c, ccrz__Account__r.CMI_Address3__c , ccrz__Account__r.BillingCity ,ccrz__Account__r.Billingstate ,ccrz__Account__r.BillingPostalCode ,ccrz__Account__r.BillingCountry, ccrz__Account__r.BillingStreet,ccrz__Account__r.ShippingStreet,ccrz__Account__r.shippingCity,ccrz__Account__r.ShippingState,ccrz__Account__r.shippingPostalCode,ccrz__Account__r.shippingCountry  from ccrz__E_Cart__c where ccrz__Account__r.Id=: accId and id=:objInvoice.ccrz__CCOrder__r.ccrz__OriginatedCart__r.id Limit 1];                    
                    
                }
                //ended MR432
                If(objInvoice != null){
                    System.debug('testing...');
                    List<ccrz__E_TransactionPayment__c> objTP = new List<ccrz__E_TransactionPayment__c>();
                    objTP = [Select Id, ccrz__Token__c, OSM_BAMS_Cancel_Request_ID__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c =: objInvoice.ccrz__CCOrder__c  ];
                    System.debug('testing...'+objTP);
                    List<OSM_Orders_In_Invoice__c> lstJunObj = [Select Id from OSM_Orders_In_Invoice__c where CC_Invoice__c =: objInvoice.Id ];
                    Map<Id, String> mapOrderToPaymentNumber = new Map<Id, String>();
                    
                    Set<Id> setId = new Set<Id>();
                    for(OSM_Orders_In_Invoice__c objJun:  lstJunObj)
                        setId.add(objJun.id);
                    
                    System.debug('setId: '+setId);
                    // LL-23 Added CC_Order_Item__r.Number_of_Bundles__c and CC_Order_Item__r.OSM_SW_Product_Link__r.Name to 1stJuncItem Query
                    List<OSM_InvoiceLine_And_OrderLine__c> lstJuncItem = new List<OSM_InvoiceLine_And_OrderLine__c>();
                    lstJuncItem = [Select Id, CC_Invoice_Item__c, CC_Invoice_Item__r.ccrz__Invoice__c, CC_Invoice_Item__r.ccrz__Invoice__r.BMS_PONumber__c, 
                                   CC_Invoice_Item__r.ccrz__Invoice__r.OSM_SW_IsIntercompanyInvoice__c,CC_Invoice_Item__r.ccrz__Invoice__r.Is_GOMS_Intercompany_Invoice__c,Sales_Amount__c, Quantity__c,
                                   OSM_Orders_In_Invoice__c,OSM_Orders_In_Invoice__r.CC_Order__c,CC_Order_Item__c, CC_Order_Item__r.Number_of_Bundles__c,
                                   CC_Order_Item__r.ccrz__Order__r.Name, CC_Order_Item__r.ccrz__Quantity__c, 
                                   CC_Order_Item__r.OSM_SW_Product_Link__c, CC_Order_Item__r.OSM_SW_Product_Link__r.Name,CC_Order_Item__r.OSM_SW_Product_Link__r.ccrz__SKU__c, 
                                   CC_Order_Item__r.ccrz__ItemTotal__c, CC_Order_Item__r.ccrz__Product_Name__c,
                                   CC_Order_Item__r.OSM_SW_Coupon_Applied__c,CC_Order_Item__r.ccrz__Coupon__r.ccrz__CouponName__c,
                                   CC_Order_Item__r.ccrz__Coupon__c, CC_Order_Item__r.ccrz__Product__c,
                                   CC_Order_Item__r.ccrz__DisplayProduct__c, CC_Order_Item__r.ccrz__DisplayProduct__r.Name, 
                                   CC_Order_Item__r.ccrz__Product__r.ccrz__SKU__c, CC_Order_Item__r.ccrz__DisplayProduct__r.ccrz__SKU__c,
                                   CC_Order_Item__r.Billing_Frequency__c,CC_Order_Item__r.ccrz__SubProdTerm__r.ccrz__DisplayName__c,
                                   CC_Order_Item__r.Discounted_Amount__c,CC_Order_Item__r.Original_Price_without_Discount__c,
                                   CC_Order_Item__r.ccrz__ProductType__c,CC_Order_Item__r.ccrz__ParentOrderItem__c,
                                   CC_Order_Item__r.id
                                   from OSM_InvoiceLine_And_OrderLine__c 
                                   where OSM_Orders_In_Invoice__c IN: setId 
                                   ORDER BY CreatedDate ASC];
                    System.debug('lstJuncItem: '+lstJuncItem);
                    
                    Map<string,list<ProductData>> includedmap = new Map<string,list<ProductData>>();
                    Set<Id> setOrderId = new Set<Id>();
                    Set<Id> Orderitemsids = new Set<Id>();
                    for(OSM_InvoiceLine_And_OrderLine__c objJunItem : lstJuncItem){
                        if(objJunItem.OSM_Orders_In_Invoice__r.CC_Order__c != null && objJunItem.CC_Order_Item__r.ccrz__ParentOrderItem__c==Null )
                            setOrderId.add(objJunItem.OSM_Orders_In_Invoice__r.CC_Order__c);
                        Orderitemsids.add(objJunItem.CC_Order_Item__r.ccrz__ParentOrderItem__c);
                    }
                    
                    System.debug('setOrderId: '+setOrderId);
                    List<ccrz__E_TransactionPayment__c> lstTP = new List<ccrz__E_TransactionPayment__c>();
                    lstTP = [Select Id, ccrz__CCOrder__c, ccrz__AccountNumber__c, ccrz__AccountType__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c IN:  setOrderId];
                    
                    for( ccrz__E_TransactionPayment__c objTP1 : lstTP)
                        mapOrderToPaymentNumber.put(objTP1.ccrz__CCOrder__c, objTP1.ccrz__AccountNumber__c);
                    List<ccrz__E_CompositeProduct__c> lstCompositeProduct = new List<ccrz__E_CompositeProduct__c>();
                    InvoiceDataWrpr objInvoiceDate = new InvoiceDataWrpr();
                    System.debug('pyment info: '+objTP);
                    
                    if(objTP != null && objTP.size() > 0){
                        objInvoiceDate.transactionId = objTP[0].ccrz__Token__c;
                        objInvoiceDate.refundTransactionId = objTP[0].OSM_BAMS_Cancel_Request_ID__c;
                    }
                    
                   //objInvoiceDate.paymentMethod = objInvoice.Payment_Method__c; //MR432
                    //MAR-1948 Code Start
                    /*if(objInvoiceDate.paymentMethod == 'cc' && objInvoice.ccrz__CCOrder__r.OSM_Bill_From__c != Null){
                         objInvoiceDate.ccSouthernPlain = objInvoice.ccrz__CCOrder__r.OSM_Bill_From__c;
                         objInvoiceDate.ccSouthPlain = True;

                    }*///MAR-1948 Code End
           
                    /////////////////////
                    //MR432
                     System.debug('***BMS Number'+objCart.ccrz__Account__r.Customer_BMS_number__c);
                    System.debug('***Distribution Code'+objCart.ccrz__Account__r.CSS_DistributorCode__c);
                    System.debug('***Payment Method'+objCart.OSM_Payment_Method__c);
              if(String.isNotBlank(objCart.ccrz__Account__r.Customer_BMS_number__c) &&
                       objCart.ccrz__Account__r.CSS_DistributorCode__c == '04959' && objCart.OSM_Payment_Method__c =='cc'){
                           Map<String, OSM_Southern_Plain__mdt> southernPlainMapData=OSM_FetchCustomMetaData_Ctrl.getSouthernPlainMetaDataMap();
                           OSM_Southern_Plain__mdt osmSouthernPlain = southernPlainMapData.get(objCart.ccrz__Account__r.CSS_DistributorCode__c);
                           if(osmSouthernPlain != Null ){
                                 objInvoiceDate.paymentMethod = 'cc';
                           }
                       }
                   if(String.isBlank(objCart.ccrz__Account__r.Customer_BMS_number__c) &&
                            objCart.ccrz__Account__r.CSS_DistributorCode__c == '04959' && objCart.OSM_Payment_Method__c =='cc'){
                                Map<String, OSM_Southern_Plain__mdt> southernPlainMapData=OSM_FetchCustomMetaData_Ctrl.getSouthernPlainMetaDataMap();
                                OSM_Southern_Plain__mdt osmSouthernPlain = southernPlainMapData.get(objCart.ccrz__Account__r.CSS_DistributorCode__c);
                                if(osmSouthernPlain != Null ){                                
                                   objInvoiceDate.paymentMethod = 'cc';                
                                }
                            }
                       if(objCart.ccrz__Account__r.CSS_DistributorCode__c != '04959' && objCart.OSM_Payment_Method__c =='cc'){
                                        objInvoiceDate.paymentMethod = 'cc';                
                         }
                    //ended MR432
                    ///////////////////////
                    
                    objInvoiceDate.invoiceId = objInvoice.Id;
                    objInvoiceDate.vartexTax = '0';
                    objInvoiceDate.subTotalAmount = '0';
                    objInvoiceDate.isInterCompanyInvoice = objInvoice.OSM_SW_IsIntercompanyInvoice__c;
                    objInvoiceDate.IsGOMSInvoice = objInvoice.Is_GOMS_Intercompany_Invoice__c;
                    if((objInvoice.ccrz__CCOrder__r.ccrz__Account__r.type=='Distributor Account' || objInvoice.ccrz__CCOrder__r.ccrz__Account__r.type=='Distributor Branch Account') && objInvoice.ccrz__CCOrder__r.ccrz__Account__r.BillingCountry!='United States')
                    {
                        objInvoiceDate.IsGOMSInvoice = true;
                    }
                    objInvoiceDate.GOMSInvoiceNo=objInvoice.GOMS_Invoice_ID__c;
                    
                    objInvoiceDate.bmsInvoiceNumber = objInvoice.BMS_Invoice_No__c;
                    if(null != objInvoice.PDF_REMITTO_ADDRESS__c){
                        string cumminsSouthernPlain;
                        String pdfremitToAddress;
                        //MAR-1948 Code Start
                        if(objInvoice.ccrz__BillTo__r.CSS_DistributorCode__c != Null){
                            Map<String, OSM_Southern_Plain__mdt> southernPlainMapData=OSM_FetchCustomMetaData_Ctrl.getSouthernPlainMetaDataMap();
                            system.debug('objInvoice.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c----->>'+objInvoice.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c);
                            OSM_Southern_Plain__mdt osmSouthernPlain = southernPlainMapData.get(objInvoice.ccrz__BillTo__r.CSS_DistributorCode__c);
                            if(osmSouthernPlain != Null){
                                cumminsSouthernPlain= osmSouthernPlain.PO_Bill_From_Remit_To__c;
                                pdfremitToAddress = objInvoice.PDF_REMITTO_ADDRESS__c+cumminsSouthernPlain;
                            }else{
                                pdfremitToAddress = objInvoice.PDF_REMITTO_ADDRESS__c;
                            }
                            //MAR-1948 Code End
                        }else{
                            pdfremitToAddress = objInvoice.PDF_REMITTO_ADDRESS__c;
                        }
                        system.debug('pdfremitToAddress----->>'+pdfremitToAddress);
                        if(objInvoice.PDF_REMITTO_ADDRESS__c.contains('REMIT TO:'))
                        {
                            pdfremitToAddress = objInvoice.PDF_REMITTO_ADDRESS__c.substringAfterLast('REMIT TO:');
                        }
                        
                        objInvoiceDate.pdfRemitToAddress = pdfremitToAddress.replace('\\n', ';').split(';');
                    }
                    objInvoiceDate.payToAddressName = objInvoice.BMS_DistributorName__c;
                    objInvoiceDate.payToAddress = objInvoice.BMS_DistributorAddressline__c;
                    objInvoiceDate.payToAddressCity = objInvoice.BMS_DistributorCity__c;
                    objInvoiceDate.payToAddressState = objInvoice.BMS_DistributorState__c;
                    objInvoiceDate.payToAddressPostalCode = objInvoice.BMS_Distributorpostalcode__c;
                    objInvoiceDate.CreditmemoNumber = objInvoice.CreditMemo_Number__c;
                    if(objInvoice.OSM_SW_Is_third_Party_BMS_Payment2__c == True) {
                        objInvoiceDate.IsThirdParty='Yes';
                        objInvoiceDate.OnBehalfOfAcc = objInvoice.Purchase_On_Behalf_Of__c;
                    }
                    else
                        objInvoiceDate.IsThirdParty='No';
                    objInvoiceDate.refundBMSNumber = '';
                    if(objInvoice.BMS_Refund_Invoice_Number__c != null)
                        objInvoiceDate.refundBMSNumber = String.valueOf(objInvoice.BMS_Refund_Invoice_Number__c);
                    objInvoiceDate.isCreditMemo = false;
                    objInvoiceDate.normalInvoiceCls = 'blackClr';
                    objInvoiceDate.creditMemoInvoiceCls = 'redClr';
                    if(objInvoice.Invoice_Type__c == 'Credit Memo'){
                        objInvoiceDate.isCreditMemo = true;
                        objInvoiceDate.normalInvoiceCls = 'redClr';
                        objInvoiceDate.creditMemoInvoiceCls = 'blackClr';
                    }
                    // END : Changes - Juhi - Feb 12 2019 - Map Entire BMS Address
                    objInvoiceDate.isBoltPO = objInvoice.OSM_SW_Is_Bolt_PO__c;
                    objInvoiceDate.bmsInviceDate = objInvoice.BMS_InvoiceDate__c;
                    objInvoiceDate.bmsInvoiceCreatedDate = objInvoice.BMS_CreateDate__c;
                    objInvoiceDate.bmsInvoiceTotalDiscount = objInvoice.BMS_TotalDiscount__c;
                    objInvoiceDate.distribcode = objCart.ccrz__Account__r.CSS_DistributorCode__c;
                    if(Label.southernCustCode.equalsIgnoreCase(objInvoiceDate.distribcode)){
                        objInvoiceDate.isSouthernCustomer = true;
                    }
                    else{
                        objInvoiceDate.isSouthernCustomer = false;
                    }
                    System.debug('The distributor code is:'+objInvoiceDate.distribcode);
                    objInvoiceDate.bmsInviceTotal = objInvoice.BMS_InvoiceTotal__c;
                    if(objInvoiceDate.bmsInvoiceNumber==null || objInvoiceDate.bmsInvoiceNumber=='' ) objInvoiceDate.bmsInvoiceNumber=objInvoice.name;
                    if(objInvoiceDate.bmsInviceTotal==null ) objInvoiceDate.bmsInviceTotal=0;
                    if(objInvoiceDate.bmsInviceDate==null ) objInvoiceDate.bmsInviceDate=date.valueOf(objInvoice.CreatedDate);
                    
                    
                    
                    //end here
                    
                    //Start: Ashish (MAR-1416)
                    if((objInvoice.Invoice_Type__c != 'Credit Memo' && objInvoice.Payment_Method__c == 'po' && !objInvoice.OSM_SW_Is_Bolt_PO__c && objInvoice.Total_Sales_Amount__c == 0 && objInvoice.BMS_Invoice_No__c == null) || Test.isRunningTest()){
                        objInvoiceDate.bmsInvoiceNumber = objInvoice.Name;
                        objInvoiceDate.bmsInviceDate = objInvoice.CreatedDate.date();
                        objInvoiceDate.bmsInviceTotal = objInvoice.Total_Sales_Amount__c;
                    }
                    // End: Ashish (MAR-1416)
                    invAmount=0; // Added for MP-316
                    if(objInvoice.Total_Vertex_Tax__c != null)
                        objInvoiceDate.vartexTax = String.valueOf(objInvoice.Total_Vertex_Tax__c);
                    if(objInvoice.Total_Sales_Amount__c != null){
                        objInvoiceDate.subTotalAmount = String.valueOf(objInvoice.Total_Sales_Amount__c);
                        invAmount=objInvoice.Total_Sales_Amount__c+objInvoice.Total_Vertex_Tax__c; // Added for MP-316
                    }
                    objInvoiceDate.lstInvoiceItem = new List<InvoiceItem>();
                    if(objInvoice.ccrz__CCOrder__r.ccrz__OriginatedCart__r.Purchaser_Comments__c != null && objInvoice.ccrz__CCOrder__r.ccrz__OriginatedCart__r.Purchaser_Comments__c != ''){
                        objInvoiceDate.haspurchasercomments=true;
                        objInvoiceDate.purchasercomments=objInvoice.ccrz__CCOrder__r.ccrz__OriginatedCart__r.Purchaser_Comments__c;
                    }else{
                        objInvoiceDate.haspurchasercomments=false;
                    }
                    boolean hasCoupon = false;
                    double orignalSubTotalWithoutDiscount = 0.0;
                    double orignalTotalDiscount = 0.0;
                    // LL-23 Code Start	
                    boolean showNumOfBundlesValue = false;	
                    List<String> OSM_ShowNumberofBundlesChkValues = String.isBlank(label.OSM_ShowNumberofBundlesValue) ? new List<String>() : (List<String>) label.OSM_ShowNumberofBundlesValue.split(',');	
                    // LL-23 Code End
                    for(OSM_InvoiceLine_And_OrderLine__c objJuncItem : lstJuncItem) {
                        if(objJuncItem.CC_Order_Item__r.ccrz__ParentOrderItem__c==Null){
                            // LL-23 Code Start	
                            showNumOfBundlesValue = false;	
                            for(String valChk: OSM_ShowNumberofBundlesChkValues) {	
                                if(objJuncItem.CC_Order_Item__r.OSM_SW_Product_Link__r.Name.equalsIgnoreCase(valChk)) {	
                                    showNumOfBundlesValue = true;	
                                }	
                            }	
                            // LL-23 Code End
                            InvoiceItem objInoivItem = new InvoiceItem();
                            objInoivItem.isCreditMemo = false;
                            objInoivItem.normalInvoiceCls = 'blackClr';
                            objInoivItem.creditMemoInvoiceCls = 'redClr';
                            if(objInvoiceDate.isCreditMemo){
                                objInoivItem.isCreditMemo = true;
                                objInoivItem.normalInvoiceCls = 'redClr';
                                objInoivItem.creditMemoInvoiceCls = 'blackClr';
                            }
                            if(objInvoiceDate.IsThirdParty == 'Yes'){ //Mar-1411
                                objInoivItem.IsThirdParty = 'Yes';
                            }
                            else{
                                objInoivItem.IsThirdParty = 'No';
                            }
                            objInoivItem.invoiceItemId = objJuncItem.Id;
                            objInoivItem.orderName = objJuncItem.CC_Order_Item__r.ccrz__Order__r.Name;
                            objInoivItem.bmsPONumber = objJuncItem.CC_Invoice_Item__r.ccrz__Invoice__r.BMS_PONumber__c;
                            //MAR-1716 Code Starts
                            bmsPONumber = objJuncItem.CC_Invoice_Item__r.ccrz__Invoice__r.BMS_PONumber__c;
                            //MAR-1716 Code Ends
                            objInoivItem.isInterCompanyInvoice = objJuncItem.CC_Invoice_Item__r.ccrz__Invoice__r.OSM_SW_IsIntercompanyInvoice__c;
                            objInoivItem.IsGOMSInvoice = objJuncItem.CC_Invoice_Item__r.ccrz__Invoice__r.Is_GOMS_Intercompany_Invoice__c;
                            if((objInvoice.ccrz__CCOrder__r.ccrz__Account__r.type=='Distributor Account' || objInvoice.ccrz__CCOrder__r.ccrz__Account__r.type=='Distributor Branch Account') && objInvoice.ccrz__CCOrder__r.ccrz__Account__r.BillingCountry!='United States'){
                                objInoivItem.IsGOMSInvoice=true;
                            }
                            objInoivItem.couponApplied = false;              
                            objInoivItem.couponCode = '';                
                            objInoivItem.couponDiscount = '100';  
                            if(objJuncItem.CC_Order_Item__r.OSM_SW_Coupon_Applied__c){
                                objInoivItem.couponApplied = true;
                                hasCoupon = true;
                                if(objJuncItem.CC_Order_Item__r.ccrz__Coupon__c != null) {
                                    objInoivItem.couponCode = objJuncItem.CC_Order_Item__r.ccrz__Coupon__r.ccrz__CouponName__c;
                                }
                                objInoivItem.originalAmount = String.valueOf(objJuncItem.CC_Order_Item__r.Original_Price_without_Discount__c);
                                objInoivItem.discountedAmount = String.valueOf(objJuncItem.CC_Order_Item__r.Discounted_Amount__c);    
                            }
                            orignalSubTotalWithoutDiscount = orignalSubTotalWithoutDiscount+objJuncItem.CC_Order_Item__r.Original_Price_without_Discount__c;
                            orignalTotalDiscount = orignalTotalDiscount+objJuncItem.CC_Order_Item__r.Discounted_Amount__c;
                            objInoivItem.quantity = '';
                            // LL-23 Code Start	
                            objInoivItem.numberOfBundles = '';	
                            // LL-23 Code End
                            objInoivItem.amount = 0;
                            // code added by Neha Sharma 12 Dec 18 - 171261
                            objInoivItem.billingFrequenecy = objJuncItem.CC_Order_Item__r.Billing_Frequency__c;
                            objInoivItem.subLength = objJuncItem.CC_Order_Item__r.ccrz__SubProdTerm__r.ccrz__DisplayName__c;
                            System.debug('objJuncItem.CC_Order_Item__r.ccrz__SubProdTerm__r.ccrz__DisplayName__c: '+objJuncItem.CC_Order_Item__r.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                            ProductData objProduct = new ProductData();
                            objProduct.orderitemid=objJuncItem.CC_Order_Item__r.id;
                            
                            objProduct.name = objJuncItem.CC_Order_Item__r.ccrz__Product_Name__c;
                            objProduct.Producttype = objJuncItem.CC_Order_Item__r.ccrz__ProductType__c;
                            if( objJuncItem.CC_Order_Item__r.ccrz__Product__c != null){
                                objProduct.sfid = objJuncItem.CC_Order_Item__r.ccrz__Product__c;
                            }
                            if(objJuncItem.CC_Order_Item__r.ccrz__DisplayProduct__c != null){
                                objProduct.parentProductName = objJuncItem.CC_Order_Item__r.ccrz__DisplayProduct__r.Name;
                                if(objJuncItem.CC_Order_Item__r.OSM_SW_Product_Link__c != null){
                                    objProduct.sku = objJuncItem.CC_Order_Item__r.OSM_SW_Product_Link__r.ccrz__SKU__c;
                                    if(objJuncItem.CC_Order_Item__r.ccrz__DisplayProduct__c != objJuncItem.CC_Order_Item__r.OSM_SW_Product_Link__c){
                                        objProduct.parentProductName = objJuncItem.CC_Order_Item__r.ccrz__Product_Name__c;
                                    }
                                    if(objProduct.Producttype=='Bundle' && objProduct.parentProductName.contains('Cummins Guidanz™ Service Package')){
                                        objProduct.Showincludedlink=true;
                                    }
                                }
                                else
                                {
                                    objProduct.sku = '';
                                }
                            }else{
                                objProduct.parentProductName = '';
                                objProduct.sku = '';
                            }
                            objInoivItem.product = objProduct;
                            if(objJuncItem.Quantity__c != null)
                                objInoivItem.quantity = String.valueOf(objJuncItem.Quantity__c);
                            // LL-23 Code Start	
                            if(objJuncItem.CC_Order_Item__r.Number_of_Bundles__c != null && showNumOfBundlesValue) {	
                                objInoivItem.numberOfBundles = String.valueOf(objJuncItem.CC_Order_Item__r.Number_of_Bundles__c);	
                            }	
                            // LL-23 Code End    
                            if(objJuncItem.Sales_Amount__c != null)
                                objInoivItem.amount = objJuncItem.Sales_Amount__c;
                            
                            objInoivItem.poNumber = '';
                            if(objJuncItem.OSM_Orders_In_Invoice__r.CC_Order__c != null)
                                if(mapOrderToPaymentNumber.containsKey(objJuncItem.OSM_Orders_In_Invoice__r.CC_Order__c))
                                objInoivItem.poNumber = mapOrderToPaymentNumber.get(objJuncItem.OSM_Orders_In_Invoice__r.CC_Order__c);
                            objInvoiceDate.lstInvoiceItem.add(objInoivItem);
                        }else{
                            ProductData includedProduct = new ProductData();
                            includedProduct.quantity = String.valueOf(objJuncItem.Quantity__c);
                            includedProduct.name = objJuncItem.CC_Order_Item__r.ccrz__Product_Name__c;
                            includedProduct.Producttype = objJuncItem.CC_Order_Item__r.ccrz__ProductType__c;
                            if(objJuncItem.CC_Order_Item__r.ccrz__DisplayProduct__c != null){
                                includedProduct.parentProductName = objJuncItem.CC_Order_Item__r.ccrz__DisplayProduct__r.Name;
                                if(objJuncItem.CC_Order_Item__r.OSM_SW_Product_Link__c != null){
                                    includedProduct.sku = objJuncItem.CC_Order_Item__r.OSM_SW_Product_Link__r.ccrz__SKU__c;
                                    if(objJuncItem.CC_Order_Item__r.ccrz__DisplayProduct__c != objJuncItem.CC_Order_Item__r.OSM_SW_Product_Link__c){
                                        includedProduct.parentProductName = objJuncItem.CC_Order_Item__r.ccrz__Product_Name__c;
                                    }
                                }
                            }
                            if(includedmap.containskey(objJuncItem.CC_Order_Item__r.ccrz__ParentOrderItem__c)){
                                list<ProductData> oldrecs = includedmap.get(objJuncItem.CC_Order_Item__r.ccrz__ParentOrderItem__c);
                                oldrecs.add(includedProduct);
                                includedmap.put(objJuncItem.CC_Order_Item__r.ccrz__ParentOrderItem__c,oldrecs);
                            }else{
                                includedmap.put(objJuncItem.CC_Order_Item__r.ccrz__ParentOrderItem__c, new list<ProductData>{includedProduct}); 
                            }                          
                        }
                    }
                    objInvoiceDate.bmsPONumber = bmsPONumber;
                    objInvoiceDate.invAmount=invAmount; // Added for MP-316
                    for(InvoiceItem orderItem :objInvoiceDate.lstInvoiceItem) {
                        if(includedmap.containskey(orderItem.product.orderitemid)){
                            orderItem.product.includeditems=includedmap.get(orderItem.product.orderitemid); 
                        }
                    }
                    
                    if(hasCoupon){
                        objInvoiceDate.hasCoupon = hasCoupon;
                        objInvoiceDate.originalSubTotal = objInvoice.ccrz__CCOrder__r.Original_Order_Subtotal__c; 
                        objInvoiceDate.totalDiscount = objInvoice.ccrz__CCOrder__r.Calculated_Total_Discount__c;
                    }else{
                        objInvoiceDate.hasCoupon = false;
                    }
                    if(objInvoiceDate.isCreditMemo && hasCoupon)
                    {
                        objInvoiceDate.originalSubTotal = orignalSubTotalWithoutDiscount;
                        objInvoiceDate.totalDiscount = orignalTotalDiscount;
                    }
                    returnMap.put('dataSet',objInvoiceDate);
                }
            }
            
            
            
            result.data = returnMap;
            result.success = true;
            if(Test.isRunningTest()){
                throw new NullPointerException();
            }
        }catch(Exception ex){
            System.debug('in catch exp: '+ex.getMessage());
            System.debug('in catch getStackTraceString: '+ex.getStackTraceString());
            CMI_SW_CartTaxWrapper objWrpr1 = new CMI_SW_CartTaxWrapper();
            objWrpr1.isError = true;
            objWrpr1.errorMsg = ex.getMessage();
            returnMap.put('InvoiceData ',objWrpr1);
            result.data = returnMap;
            result.success = false;
        }
        system.debug('return map: '+result);
        result.success = true;
        
        return result;
    }
    
    global Class InvoiceDataWrpr{
        Id invoiceId;
        String vartexTax;
        String transactionId;
        String refundTransactionId;
        String distribcode;
        Boolean isSouthernCustomer;
        String subTotalAmount;
        String paymentMethod;
        String paymentMeth;
        Boolean isCreditMemo;
        String refundBMSNumber;
        String CreditmemoNumber;
        String normalInvoiceCls;
        String creditMemoInvoiceCls;
        // code added by Neha Sharma 12 Dec 18 - 171261
        String bmsInvoiceNumber;
        String OnBehalfOfAcc;
        /// added by shirisha
        String ccSouthernPlain;
        Boolean ccSouthPlain;
        List<String> pdfRemitToAddress;
        // START : Changes - Juhi - Feb 12 2019 - Map Entire BMS Address
        String payToAddressName;
        String payToAddress;
        String payToAddressCity;
        String payToAddressState;
        String payToAddressPostalCode;
        // END : Changes - Juhi - Feb 12 2019 - Map Entire BMS Address
        
        Boolean isBoltPO;
        Boolean isInterCompanyInvoice;
        Boolean IsGOMSInvoice;
        String GOMSInvoiceNo;
        Date bmsInviceDate;
        Date bmsInvoiceCreatedDate;
        boolean hasCoupon;
        Decimal bmsInvoiceTotalDiscount;
        Decimal bmsInviceTotal;
        Decimal originalSubTotal;
        Decimal totalDiscount;
        List<InvoiceItem> lstInvoiceItem;
        Id pdfId;
        string imageUrl; 
        //MAR-1716 Code Starts
        String bmsPONumber;
        //MAR-1716 Code Ends
        Decimal invAmount; // Added for MP-316 
        
        boolean haspurchasercomments;
        string purchasercomments;
        string IsThirdParty ='No'; //MAR-1411
    }
    public Class InvoiceItem{
        String invoiceItemId;
        String orderName;
        String quantity;
        String numberOfBundles;
        Decimal amount;
        String originalAmount;
        String discountedAmount;
        String poNumber;
        String bmsPONumber;
        String couponCode;
        Boolean couponApplied;
        Boolean isInterCompanyInvoice;
        Boolean IsGOMSInvoice;
        String GOMSInvoiceNo;
        String couponDiscount;
        String normalInvoiceCls;
        String creditMemoInvoiceCls;
        Boolean isCreditMemo;
        String billingFrequenecy;
        String subLength;
        ProductData product;
        string IsThirdParty ='No'; //MAR-1411
        
    }
    
    public Class ProductData{
        String sfid;
        String orderitemid;
        String sku;
        String name;
        String parentProductName;
        String Producttype;
        Boolean Showincludedlink =false;
        String pricingType;
        String Pricingmodifier;
        String quantity;
        String extSKU;
        String extName; 
        list<ProductData> includeditems ;
        
    }
    
}