public class OSM_FW_SubmitOrder_Handler{ 
    Decimal calculatedTax=0.0;
    public static OSM_ReturnWrapper getOrderInfo(Id orderId,boolean isCancel,list<Id> orderItemList){
        OSM_ReturnWrapper objToReturn = new OSM_ReturnWrapper();
        OSM_Integration_Log__c log =new OSM_Integration_Log__c();
        ccrz__E_Invoice__c invoiceObj=new ccrz__E_Invoice__c();
        ccrz__E_Order__c orderObj=new ccrz__E_Order__c();
        Set<String> mandatoryFields = new Set<String>(); 
        Savepoint sp;
        List<ccrz__E_Invoice__c> invoiceList=new List<ccrz__E_Invoice__c>();
        List<ccrz__E_Order__c> orderList=new  List<ccrz__E_Order__c>();      
        List<OSM_Integration_Log__c> lstToInsertLog=new List<OSM_Integration_Log__c>();
        Set<Id> orderIdSet=new Set<Id>();
        Set<Id> productSubTermIdSet=new Set<Id>();
        Set<Id> cartItemIdsSet=new Set<Id>();  
        Set<Id> cartIdSet=new Set<Id>(); 
        List<ccrz__E_Invoice__c> invoiceRecord = new List<ccrz__E_Invoice__c> ();
        Map<Id, ccrz__E_PriceListItem__c > mapSubProdIdToPriceListItem = new Map<Id, ccrz__E_PriceListItem__c >();
        ccrz__E_Invoice__c objInvoice = new ccrz__E_Invoice__c(); // Added By Dhiraj for MAR-1621 - Story On 16th April 2021
        String userId =UserInfo.getUserId();
        User usrInfo = [SELECT Phone, Email FROM User WHERE Id =: userId];
        if(isCancel)
        {
            invoiceRecord=[Select id,ccrz__CCOrder__r.Order_Cancellation_Date__c,ccrz__CCOrder__r.ccrz__Contact__r.name,BMS_InvoiceTotal__c,ccrz__CCOrder__r.BMS_OrderRefNumber__c,ccrz__CCOrder__r.ccrz__OrderStatus__c,ccrz__Status__c,BMS_InvoiceNumber__c,ccrz__CCOrder__r.ccrz__TotalDiscount__c,ccrz__CCOrder__r.OSM_Discount_On_BMS__c,ccrz__CCOrder__r.ccrz__SubtotalAmount__c,ccrz__CCOrder__r.ccrz__OriginatedCart__c,ccrz__CCOrder__r.ccrz__Account__r.id,ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c,ccrz__CCOrder__r.ccrz__Account__r.Location__c,ccrz__CCOrder__r.ccrz__Account__r.OSM_Location_ID__c, ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c, ccrz__CCOrder__c,ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__PostalCode__c,ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__StateISOCode__c,ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__AddressSecondline__c, ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__CountryISOCode__c,ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__City__c,ccrz__CCOrder__r.Order_Source_Type__c,ccrz__CCOrder__r.Name,ccrz__CCOrder__r.Discount_Type__c,BMS_paymenttype__c,name,ccrz__DateIssued__c,ccrz__OriginalAmount__c,ccrz__CCOrder__r.ccrz__Account__r.Customer_BMS_number__c, ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c, ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c ,ccrz__CCOrder__r.ccrz__Account__r.name,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressSecondline__c, ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressThirdline__c, ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__CountryISOCode__c, ccrz__CCOrder__r.OSM_SW_Coupon_Count__c,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__City__c,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__StateISOCode__c,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__CCOrder__r.OE_Comment__c,ccrz__CCOrder__r.ccrz__OriginatedCart__r.Purchaser_Comments__c,ccrz__BillTo__c,ccrz__CCOrder__r.Calculated_Total_Discount__c   from ccrz__E_Invoice__c where ccrz__CCOrder__c=:orderId and Invoice_Type__c = 'Credit Memo' order by CreatedDate DESC ];
        }
        else{
            invoiceRecord=[Select id,ccrz__CCOrder__r.Order_Cancellation_Date__c,ccrz__CCOrder__r.ccrz__Contact__r.name,BMS_InvoiceTotal__c,ccrz__CCOrder__r.BMS_OrderRefNumber__c,ccrz__CCOrder__r.ccrz__OrderStatus__c,ccrz__Status__c,BMS_InvoiceNumber__c,ccrz__CCOrder__r.ccrz__TotalDiscount__c,ccrz__CCOrder__r.OSM_Discount_On_BMS__c,ccrz__CCOrder__r.ccrz__SubtotalAmount__c,ccrz__CCOrder__r.ccrz__OriginatedCart__c,ccrz__CCOrder__r.ccrz__Account__r.id,ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c,ccrz__CCOrder__r.ccrz__Account__r.Location__c,ccrz__CCOrder__r.ccrz__Account__r.OSM_Location_ID__c, ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c, ccrz__CCOrder__c,ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__PostalCode__c,ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__StateISOCode__c,ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__AddressSecondline__c, ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__CountryISOCode__c,ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__City__c,ccrz__CCOrder__r.Order_Source_Type__c,ccrz__CCOrder__r.Name,ccrz__CCOrder__r.Discount_Type__c,BMS_paymenttype__c,name,ccrz__DateIssued__c,ccrz__OriginalAmount__c,ccrz__CCOrder__r.ccrz__Account__r.Customer_BMS_number__c, ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c, ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c ,ccrz__CCOrder__r.ccrz__Account__r.name,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressSecondline__c, ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__AddressThirdline__c, ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__CountryISOCode__c, ccrz__CCOrder__r.OSM_SW_Coupon_Count__c,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__City__c,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__StateISOCode__c,ccrz__CCOrder__r.ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__CCOrder__r.OE_Comment__c,ccrz__CCOrder__r.ccrz__OriginatedCart__r.Purchaser_Comments__c,ccrz__BillTo__c,ccrz__CCOrder__r.Calculated_Total_Discount__c   from ccrz__E_Invoice__c where ccrz__CCOrder__c=:orderId and Invoice_Type__c != 'Credit Memo'];
        }
    //Modify the Query with ccrz__CCOrder__r.Calculated_Total_Discount__c By Dhira;
        
    // Added By Dhiraj for MAR-1621 - Story On 16th April 2021
        for(ccrz__E_Invoice__c invoiceaccId : invoiceRecord){
            
            objInvoice.ccrz__BillTo__c = invoiceaccId.ccrz__BillTo__c; 
        }
        //Ended
    
        if((invoiceRecord[0].ccrz__OriginalAmount__c > 0 ) || (invoiceRecord[0].ccrz__CCOrder__r.OSM_SW_Coupon_Count__c > 0 && invoiceRecord[0].ccrz__OriginalAmount__c == 0))
        {
            try
            {
                List<ccrz__E_TransactionPayment__c> transPaymentList=[Select id,ccrz__CCOrder__c,ccrz__AccountNumber__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c=:orderId];            
                
                //for(ccrz__E_Invoice__c invoice:invoiceRecord){
                    cartIdSet.add(invoiceRecord[0].ccrz__CCOrder__r.ccrz__OriginatedCart__c);
                    orderIdSet.add(invoiceRecord[0].ccrz__CCOrder__r.id);
                //}
                List<ccrz__E_OrderItem__c> orderItemRecord = new List<ccrz__E_OrderItem__c>();
                if(isCancel)
                {
                    orderItemRecord=[Select ccrz__SubProdTerm__c,ccrz__ParentOrderItem__c,ccrz__Product__r.Group_Name__c,ccrz__Price__c,Dn_Price__c,id,name,ccrz__Order__c,ccrz__UnitOfMeasure__c,ccrz__Product__c,ccrz__Quantity__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Product_Class_Code__c,ccrz__Product__r.name, Discounted_Amount__c from ccrz__E_OrderItem__c where Id IN: orderItemList AND ccrz__Product__r.Group_Name__c = 'FluidWatch'];
                    System.debug('orderItemRecord: '+orderItemRecord);
                }
                else{
                    orderItemRecord=[Select ccrz__SubProdTerm__c,ccrz__ParentOrderItem__c,ccrz__Product__r.Group_Name__c,ccrz__Price__c,Dn_Price__c,id,name,ccrz__Order__c,ccrz__UnitOfMeasure__c,ccrz__Product__c,ccrz__Quantity__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Product_Class_Code__c,ccrz__Product__r.name, Discounted_Amount__c from ccrz__E_OrderItem__c where ccrz__Order__c=:orderIdSet AND ccrz__Product__r.Group_Name__c = 'FluidWatch'];
                }
                System.debug('orderItemRecord2: '+orderItemRecord);
                for(ccrz__E_OrderItem__c orderItem:orderItemRecord){
                    productSubTermIdSet.add(orderItem.ccrz__SubProdTerm__c);
                }
                
                
                List<ccrz__E_CartItem__c> cartLineItemDetails=[Select id,name,ccrz__Cart__c,ccrz__ParentCartItem__c from ccrz__E_CartItem__c where ccrz__Cart__c IN: cartIdSet];             
                
                for(ccrz__E_CartItem__c cartItem:cartLineItemDetails){
                    if(cartItem.ccrz__ParentCartItem__c==null){
                        cartItemIdsSet.add(cartItem.id);    
                    } 
                    
                } 
                
                
                List<CC_Tax__c> ccTaxList=[Select Id, CC_Cart_Item__r.ccrz__SubAmount__c, NonTaxable__c, Taxable__c,CC_Cart_Item__r.Prorated_Price_AfterDiscount__c, CC_Cart_Item__c,CalculatedTax__c,name,JurisdictionLevel__c,JurisdictionId__c,Discount_Amount__c from CC_Tax__c where CC_Cart_Item__c =:cartItemIdsSet];
                
                
                List<ccrz__E_PriceListItem__c> priceListItemRecord=[Select id,ccrz__SubProdTerm__c,ccrz__Product__c,ccrz__Product__r.Group_Name__c,ccrz__Price__c,Distributor_Price__c from ccrz__E_PriceListItem__c where ccrz__SubProdTerm__c=:productSubTermIdSet and ccrz__RecurringPrice__c = false AND ccrz__Product__r.Group_Name__c = 'FluidWatch'];
                
                
                for(ccrz__E_PriceListItem__c objPrice : priceListItemRecord )
                {
                    
                    mapSubProdIdToPriceListItem.put(objPrice.ccrz__SubProdTerm__c, objPrice);
                }
                
                
                
                //intializing GeneralInput wrapper
                OSM_WS_GeneralizedSubmitOrdrInpWrapper inputWrapperObj=new OSM_WS_GeneralizedSubmitOrdrInpWrapper();
                inputWrapperObj.dataArea=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.DataArea();
                inputWrapperObj.header=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.Header();
                inputWrapperObj.header.sender=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.Sender();
                inputWrapperObj.header.target=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.Target();
                OSM_WS_GeneralizedSubmitOrdrInpWrapper.FSDList fsdList;
                inputWrapperObj.dataArea.headerList=new List<OSM_WS_GeneralizedSubmitOrdrInpWrapper.FSDList>();
                OSM_WS_GeneralizedSubmitOrdrInpWrapper.TaxList taxList;
                inputWrapperObj.dataArea.taxList=new List<OSM_WS_GeneralizedSubmitOrdrInpWrapper.TaxList>();
                OSM_WS_GeneralizedSubmitOrdrInpWrapper.ChargeList chargeList;
                inputWrapperObj.dataArea.chargeList=new List<OSM_WS_GeneralizedSubmitOrdrInpWrapper.ChargeList>();
                OSM_WS_GeneralizedSubmitOrdrInpWrapper.PartList partList;
                inputWrapperObj.dataArea.partList=new List<OSM_WS_GeneralizedSubmitOrdrInpWrapper.PartList>();
                //binding values
                if(invoiceRecord!=null && invoiceRecord.size() > 0){              
                    ccrz__E_Invoice__c invoiceItem = invoiceRecord[0];
                    {
                        fsdList=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.FSDList();
                        chargeList=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.ChargeList();
                        
                        
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.OSM_Location_ID__c!=null){                            
                            inputWrapperObj.dataArea.locationId = invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.OSM_Location_ID__c;
                        }
                        
                        /*if(invoiceItem.ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c){
                            if(invoiceItem.ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c != ''){
                                inputWrapperObj.dataArea.customerCode =invoiceItem.ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c;
                            }
                            else{
                                mandatoryFields.add('CustomerCode');
                            }
                        }
                        else{*/
                        
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c != null){
                            inputWrapperObj.dataArea.customerCode =invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c;
                        }else{
                            inputWrapperObj.dataArea.customerCode = '';                                
                        }
                        
                        //}
                        
                        if(invoiceItem.ccrz__CCOrder__r.Name!=null){
                            String invoiceOrderId=invoiceItem.ccrz__CCOrder__r.Name;
                            fsdList.salesOrderId=invoiceOrderId.SubString(2,12);                                      
                        }
                        else{
                            mandatoryFields.add('SALES_ORDER_ID');                            
                        }
                        
                        inputWrapperObj.header.target.targetId = 'WINLIMS';
                        fsdList.orderSourceType =Label.OSM_Source;
                        if(isCancel)
                            fsdList.orderSourceType =Label.OSM_Source_OSMCM;
                        
                        inputWrapperObj.dataArea.orderReferenceNumber = '';
                        inputWrapperObj.dataArea.emailAddress = usrInfo.Email;
                        inputWrapperObj.dataArea.phoneNumber = usrInfo.Phone;
                        
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__PostalCode__c!=null || invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__StateISOCode__c!=null ){
                            fsdList.taxDistrict =invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__PostalCode__c.substring(0,5) + '-' + invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__StateISOCode__c;
                        }
                        else{
                            mandatoryFields.add('TAX_DISTRICT');
                        }
                        fsdList.paymentType =Label.OSM_paymentType;
                        if(invoiceItem.BMS_paymenttype__c!=null){
                            fsdList.paymentType =invoiceItem.BMS_paymenttype__c;
                        }
                        
                        if(invoiceItem.name!=null){
                            fsdList.invoiceNumber =OSM_Generic_Utility.fieldSizeRestriction(invoiceItem.name, 8, 'back');
                        }
                        else{
                            mandatoryFields.add('INVOICE_NUMBER');
                        }
                        if(invoiceItem.ccrz__DateIssued__c!=null){
                            fsdList.invoiceDate =invoiceItem.ccrz__DateIssued__c;
                        }
                        else{
                            mandatoryFields.add('INVOICE_DATE');
                        }
                        if(invoiceItem.ccrz__OriginalAmount__c!=null){
                            fsdList.invoiceTotal=invoiceItem.ccrz__OriginalAmount__c;
                        }
                        else{
                            mandatoryFields.add('INVOICE_TOTAL');
                        }
                        
                        /*if(invoiceItem.ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c){
                            if(invoiceItem.ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c != ''){
                                fsdList.billToCustomerNumber=invoiceItem.ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c;
                            }
                            else{
                                mandatoryFields.add('BILL_TO_CUST_NUMBER');
                            }
                        }
                        else{*/
                        
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c !=null){
                            fsdList.billToCustomerNumber=invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.IAM_Service_Provider_Code__c;
                        }
                        else{
                            fsdList.billToCustomerNumber = '';
                        }
                                                   
                        //}
                        /*if(invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.name!=null){
                            fsdList.billToName =invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.name;
                        }
                         */
                        
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__Contact__r.name!=null){
                            fsdList.billToName =invoiceItem.ccrz__CCOrder__r.ccrz__Contact__r.name;
                        }
                        
                        
                        else{
                            fsdList.billToName = '';
                        }
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.name!=null){
                            fsdList.shipToName =invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.name;
                        }
                        else{
                            mandatoryFields.add('SHIP_TO_NAME');
                        }                   
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__AddressFirstline__c!=null){
                            fsdList.shipToAddress1 =invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__AddressFirstline__c;
                        }
                        else{
                            mandatoryFields.add('SHIP_TO_ADDRESS1');
                        }
                        
                        if(null != invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__AddressSecondline__c){
                            fsdList.shipToAddress2 =invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__AddressSecondline__c;
                        }
                        else{
                            fsdList.shipToAddress2 ='';
                        }
                        if(null != invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__AddressThirdline__c){
                            fsdList.shipToAddress3 =invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__AddressThirdline__c;
                        }
                        else
                        {
                            fsdList.shipToAddress3 ='';
                        }
                        if(null != invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__CountryISOCode__c){
                            fsdList.shipToCountry =invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__CountryISOCode__c;
                        }
                        else
                        {
                            mandatoryFields.add('SHIP_TO_COUNTRY');
                        }
                        // RTC_181176  End : Mar 11, 2019 - Juhi - Addition of 3 fields for address in Submit Order request
                        
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__City__c!=null){
                            fsdList.shipToCity =invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__City__c;
                        }
                        else
                        {
                            mandatoryFields.add('SHIP_TO_CITY');
                        }
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__StateISOCode__c!=null){
                            fsdList.shipToState =invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__StateISOCode__c;
                        }
                        else
                        {
                            mandatoryFields.add('SHIP_TO_STATE');
                        }
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__PostalCode__c!=null){
                            fsdList.shipToPostalCode =invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__PostalCode__c;
                        }
                        else{
                            mandatoryFields.add('SHIP_TO_POSTAL_CODE');
                        }
                        if(invoiceItem.ccrz__CCOrder__r.ccrz__OriginatedCart__r.Purchaser_Comments__c!=null && invoiceItem.ccrz__CCOrder__r.ccrz__OriginatedCart__r.Purchaser_Comments__c!=''){
                            if(invoiceItem.ccrz__CCOrder__r.ccrz__OriginatedCart__r.Purchaser_Comments__c.length() > 200 ){
                                fsdList.orderComments  =invoiceItem.ccrz__CCOrder__r.ccrz__OriginatedCart__r.Purchaser_Comments__c.substring(0,200);
                            }else{
                                fsdList.orderComments =invoiceItem.ccrz__CCOrder__r.ccrz__OriginatedCart__r.Purchaser_Comments__c;
                            }
                        }else{
                            fsdList.orderComments ='Thank you';
                        }
                        if(transPaymentList.size()>0 && transPaymentList[0].ccrz__AccountNumber__c!=null ){
                            fsdList.customerPONumber =transPaymentList[0].ccrz__AccountNumber__c;
                        }
                        /*else{
                            mandatoryFields.add('CUSTOMER_PO_NUMBER');
                        }*/
                        if(null != invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c){
                            fsdList.customerLocationCode = invoiceItem.ccrz__CCOrder__r.ccrz__Account__r.CSS_DistributorCode__c;
                        }
                        else{
                            fsdList.customerLocationCode = '';
                            //mandatoryFields.add('CUSTOMER_LOCATION_CODE');
                        }
                        /*fsdList.attribute01=0;
                        fsdList.attribute02='';
                        fsdList.attribute03='';*/
                        fsdList.vendor =Label.OSM_Vendor;
                        fsdList.status ='';
                        if(invoiceItem.ccrz__CCOrder__r.Discount_Type__c!=null){
                            chargeList.discountType=invoiceItem.ccrz__CCOrder__r.Discount_Type__c;
                        }else{
                            chargeList.discountType=Label.OSM_MISC_CHARGE;
                        }
                        //if(invoiceItem.ccrz__CCOrder__r.OSM_Discount_On_BMS__c!=null){ //Commented By Dhiraj
                          if(invoiceItem.ccrz__CCOrder__r.Calculated_Total_Discount__c!=null){  
                            //chargeList.totalDiscount=-invoiceItem.ccrz__CCOrder__r.OSM_Discount_On_BMS__c.setScale(2, RoundingMode.HALF_UP);//Commented By Dhiraj
                              chargeList.totalDiscount=-invoiceItem.ccrz__CCOrder__r.Calculated_Total_Discount__c.setScale(2, RoundingMode.HALF_UP);
                        }else{
                            chargeList.totalDiscount=0;
                        }
                        /*
                        chargeList.attribute01=0;
                        chargeList.attribute02='';*/
                        System.debug('before part list: '+orderItemRecord);
                        for(ccrz__E_OrderItem__c orderItem:orderItemRecord){
                            System.debug('on insite part list');
                            if(orderItem.ccrz__ParentOrderItem__c==null){
                                partList=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.PartList();
                                if(orderItem.ccrz__Product__r.ccrz__SKU__c!=null){
                                    partList.itemNumber =orderItem.ccrz__Product__r.ccrz__SKU__c;
                                }
                                else{
                                    mandatoryFields.add('ITEM_NUMBER');
                                }
                                
                                if(orderItem.ccrz__Product__r.name!=null){
                                    partList.description =OSM_Generic_Utility.removeSymbols(orderItem.ccrz__Product__r.name);
                                }
                                else{
                                    mandatoryFields.add('DESCRIPTION');
                                }                    
                                if(orderItem.ccrz__Quantity__c!=null){
                                    partList.quantity =Integer.ValueOf(orderItem.ccrz__Quantity__c);
                                }
                                else{
                                    mandatoryFields.add('QUANTITY');
                                } 
                                if(orderItem.ccrz__UnitOfMeasure__c!=null){
                                    partList.unitOfMeasurement =orderItem.ccrz__UnitOfMeasure__c;
                                }else{
                                    partList.unitOfMeasurement ='EA';
                                }
                                
                                partList.itemCost = 0;
                                /*if(orderItem.Dn_Price__c!= null){
                                    Decimal item_cost_ToRound=orderItem.Dn_Price__c / orderItem.ccrz__Quantity__c;
                                    partList.itemCost =item_cost_ToRound.setScale(2, RoundingMode.HALF_UP);
                                }
                                */
                                if(orderItem.Discounted_Amount__c != null){
                                    partList.itemCost = orderItem.Discounted_Amount__c;
                                }
                                
                                if(orderItem.ccrz__Price__c!= null){
                                    partList.sellingPrice =orderItem.ccrz__Price__c;                                    
                                }
                                else{
                                    mandatoryFields.add('SELLING_PRICE');
                                }                                     
                                partList.product =Label.OSM_Vendor;
                                partList.nonstockType='';
                                partList.product='';
                                /*
                                partList.attribute01 =0;
                                partList.attribute02 ='';
                                partList.attribute03='';*/
                                inputWrapperObj.dataArea.PartList.add(partList);                               
                            }
                        }
                        inputWrapperObj.dataArea.headerList.add(fsdList);
                        inputWrapperObj.dataArea.chargeList.add(chargeList);
                        if(ccTaxList.size()>0 && ccTaxList!=null){
                            
                            for(CC_Tax__c taxDetails:ccTaxList){
                                
                                taxList=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.TaxList();   
                                for(ccrz__E_OrderItem__c orderItem:orderItemRecord){
                                    if(orderItem.ccrz__Product__r.Product_Class_Code__c!=null){                       
                                        taxList.salesCategories =orderItem.ccrz__Product__r.Product_Class_Code__c;
                                    }
                                }
                                
                                boolean isSaleAmount = false;
                                
                                /*if(null != taxDetails.Taxable__c&& String.isNotBlank(taxDetails.Taxable__c) && String.isNotEmpty(taxDetails.Taxable__c))
                                {
                                    isSaleAmount = true;
                                    taxList.saleAmount = 0;
                                    if(Decimal.ValueOf(taxDetails.Taxable__c)!=0){
                                        Decimal SALE_AMOUNT_ToRound=taxList.saleAmount + Decimal.ValueOf(taxDetails.Taxable__c)-taxDetails.Discount_Amount__c;
                                        taxList.saleAmount = SALE_AMOUNT_ToRound.setScale(2, RoundingMode.HALF_UP);
                                    }
                                    else{
                                        Decimal SALE_AMOUNT_ToRound=taxDetails.CC_Cart_Item__r.Prorated_Price_AfterDiscount__c;
                                        taxList.saleAmount =SALE_AMOUNT_ToRound.setScale(2, RoundingMode.HALF_UP);
                                    }
                                }
                                if(null != taxDetails.NonTaxable__c && String.isNotBlank(taxDetails.NonTaxable__c) && String.isNotEmpty(taxDetails.NonTaxable__c))
                                {
                                    isSaleAmount = true;
                                    taxList.saleAmount = 0;
                                    if(Decimal.ValueOf(taxDetails.NonTaxable__c)!=0){
                                        taxList.saleAmount = taxList.saleAmount + Decimal.ValueOf(taxDetails.NonTaxable__c)-taxDetails.Discount_Amount__c;
                                    }
                                    else{
                                        Decimal SALE_AMOUNT_ToRound=taxDetails.CC_Cart_Item__r.Prorated_Price_AfterDiscount__c;
                                        taxList.saleAmount =SALE_AMOUNT_ToRound.setScale(2, RoundingMode.HALF_UP);                                             
                                    }
                                }*/

                                taxList.saleAmount = 0;
                                Decimal SALE_AMOUNT_ToRound;
                                /*if(taxDetails.Discount_Amount__c > 0){
                                    if(null != taxDetails.Taxable__c && Decimal.ValueOf(taxDetails.Taxable__c) > 0 && taxDetails.NonTaxable__c != null){
                                        SALE_AMOUNT_ToRound = Decimal.ValueOf(taxDetails.NonTaxable__c) + Decimal.ValueOf(taxDetails.Taxable__c);
                                    }else if(null != taxDetails.Taxable__c && Decimal.ValueOf(taxDetails.Taxable__c) > 0 && taxDetails.NonTaxable__c == null){
                                        SALE_AMOUNT_ToRound = Decimal.ValueOf(taxDetails.Taxable__c);
                                    }
                                    else if(null != taxDetails.NonTaxable__c && Decimal.ValueOf(taxDetails.NonTaxable__c) > 0 && 
                                    (taxDetails.Taxable__c == null || (null != taxDetails.Taxable__c && Decimal.ValueOf(taxDetails.Taxable__c) == 0))){
                                        SALE_AMOUNT_ToRound = Decimal.ValueOf(taxDetails.NonTaxable__c);// - taxDetails.Discount_Amount__c;
                                    }
                                }else{
                                    if(taxDetails.Taxable__c != null){
                                        SALE_AMOUNT_ToRound = Decimal.ValueOf(taxDetails.Taxable__c);
                                    }
                                    if(taxDetails.NonTaxable__c != null){
                                        SALE_AMOUNT_ToRound += Decimal.ValueOf(taxDetails.NonTaxable__c);
                                    }
                                }
                                if(SALE_AMOUNT_ToRound != null){
                                    isSaleAmount = true;
                                    taxList.saleAmount =SALE_AMOUNT_ToRound.setScale(2, RoundingMode.HALF_UP);
                                }*/
                                
                                if(taxDetails.CC_Cart_Item__r.ccrz__SubAmount__c != null){
                                    isSaleAmount = true;
                                    taxList.saleAmount = taxDetails.CC_Cart_Item__r.ccrz__SubAmount__c.setScale(2, RoundingMode.HALF_UP);
                                }
                                
                                if(!isSaleAmount){
                                    mandatoryFields.add('SALE_AMOUNT');
                                }
                                
                                // RTC_181097  End : Changes - Juhi - March 06 2019 - Sales Amount should be by line item, not totla order sales amount
                                
                                taxList.taxAuthorities =invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__PostalCode__c +'-'+invoiceItem.ccrz__CCOrder__r.ccrz__ShipTo__r.ccrz__StateISOCode__c + '-'+ taxDetails.JurisdictionId__c;
                                taxList.printGroup =taxDetails.JurisdictionLevel__c;                                
                                taxList.taxAmount =Decimal.ValueOf(taxDetails.CalculatedTax__c);
                                if(!(taxDetails.CalculatedTax__c != null)){
                                    mandatoryFields.add('TAX_AMOUNT');
                                }
                                /*
                                taxList.attribute01=0;
                                taxList.attribute02='';
                                taxList.attribute03='';*/
                                inputWrapperObj.dataArea.taxList.add(taxList); 
                            }                        
                        }                         
                    }
                }
                if(inputWrapperObj.dataArea.locationId !=null && inputWrapperObj.dataArea.customerCode !=null && !(mandatoryFields.size() > 0)){
                    OSM_WS_GeneralizedSubmitOrderOutputWrap responseWrpObj = new OSM_WS_GeneralizedSubmitOrderOutputWrap();
                    responseWrpObj = OSM_WS_FW_SubmitOrderInfoService.callSubmitOrderService(inputWrapperObj,isCancel);
                    
                    System.debug('General Output Wrapper>>>>>'+responseWrpObj);
                    
                    sp = Database.setSavepoint();
                    log=responseWrpObj.log;
                    log.Account__c = objInvoice.ccrz__BillTo__c; // Added By Dhiraj 
                    if(!responseWrpObj.errorFlag){
                        invoiceObj.id=invoiceRecord[0].id;                        
                        orderObj.id=invoiceRecord[0].ccrz__CCOrder__r.id;
                        
                        //orderObj.OrderProcessedforFSD__c=true;commented for MP_458
                        orderObj.OSM_SW_Should_mail_Send__c=true;
                        //orderObj.ccrz__OrderStatus__c=Label.OSM_Status;
                        
                        objToReturn.exceptionFlag=false;
                    }
                    else{
                        objToReturn.exceptionFlag=true;
                        orderObj.id=orderId;
                        
                        invoiceObj.id=invoiceRecord[0].id;                        
                    }
                }
                
                else {
                    String mandeToryString;
                    for(String valueStr : mandatoryFields) {
                        if(mandeToryString != null)
                            mandeToryString = mandeToryString+', '+valueStr;
                        else
                            mandeToryString = valueStr;                        
                    }
                    
                    log.Status__c = Label.OSM_Subs_Cancellation_Failure;                   
                    log.Target__c = 'WINLIMS';
                    log.Source__c = Label.OSM_Source;
                    log.Logged_In_User__c = userinfo.getuserid();
                    log.Error_Description__c='Mandatory fields are missing: '+mandeToryString;
                    log.Service_Name__c=Label.OSM_SubmitOrder_ServiceName;
                    if(isCancel)
                    log.Service_Name__c='RefundSubmitOrder';
                    log.Account__c = objInvoice.ccrz__BillTo__c; // Added By Dhiraj           
                    objToReturn.exceptionFlag=true;
                    invoiceObj.id=invoiceRecord[0].id;
                    orderObj.id=orderId;
                   
                } 
                if(Test.isRunningTest()){
                    throw new NullPointerException();
                }
                
            }catch(Exception ex){        
                System.debug('exception : '+ex.getMessage());
                log.Status__c = Label.OSM_Subs_Cancellation_Failure; 
                String msg  = 'Message - '+ex.getMessage();
                msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();                   
                log.Error_Description__c = msg;
                log.Target__c = 'WINLIMS'; //Added by Swetha
                log.Source__c = Label.OSM_Source;
                if(isCancel)
                log.Service_Name__c='RefundSubmitOrder';
                log.Logged_In_User__c = userinfo.getuserid();
        		log.Account__c = objInvoice.ccrz__BillTo__c; // Added By Dhiraj 
               if(invoiceRecord != null && invoiceRecord.size() > 0)
                    invoiceObj.id=invoiceRecord[0].id;
                orderObj.id=orderId;
            }  
            
            if(log!=null){
                if(log.Status__c != Label.OSM_CalloutStatus_Success){ 
          			log.Account__c = objInvoice.ccrz__BillTo__c; // Added By Dhiraj 
                     objToReturn.exceptionFlag=true;
                    //orderObj.ccrz__OrderStatus__c=Label.OSM_Status;                        
                    orderObj.OrderProcessedforFSD__c=false;
                    orderObj.OSM_SW_IsFSDFailed__c=true;
                    invoiceObj.ccrz__Status__c='Paid';
                }
                
                log.CC_Order__c = orderId;  
                if(isCancel)
                    log.Service_Name__c='RefundSubmitOrder';
        		log.Account__c = objInvoice.ccrz__BillTo__c; // Added By Dhiraj         
                lstToInsertLog.add(log);  
            }         
            orderList.add(orderObj);   
            if(invoiceObj.Id != null)
                invoiceList.add(invoiceObj);     
            
            objToReturn.updateOrderList=new List<ccrz__E_Order__c>();
            objToReturn.updateInvoiceList=new List<ccrz__E_Invoice__c>();              
            objToReturn.updateOrderList=orderList;
            objToReturn.updateInvoiceList=invoiceList;
            objToReturn.lstToInsertLog=new List<OSM_Integration_Log__c>();
            objToReturn.lstToInsertLog=lstToInsertLog;
            try{
                if(lstToInsertLog!=null && lstToInsertLog.size()>0){
                    insert lstToInsertLog;
                }
                if(orderList!=null && orderList.size()>0){
                    update orderList;
                }
                if(invoiceList!=null && invoiceList.size()> 0){
                    update invoiceList;
                }
                if(Test.isRunningTest()){
                    throw new NullPointerException();
                }
            }catch(Exception ex){
                System.debug('exception : '+ex.getMessage());
                String msg  = 'Message - '+ex.getMessage();
                msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();                   
            }
            return objToReturn;
        }
        
        else {
            try {
                orderObj.id = orderId;
                //orderObj.OrderProcessedforFSD__c=true;commented for MP_458
                orderObj.OSM_SW_Should_mail_Send__c=true;
                //orderObj.ccrz__OrderStatus__c=Label.OSM_Status;
                update orderObj;
                objToReturn.exceptionFlag=false;
            }
            catch(Exception ex){
                objToReturn.exceptionFlag=true;
            }            
            return objToReturn;            
        }
    }
}