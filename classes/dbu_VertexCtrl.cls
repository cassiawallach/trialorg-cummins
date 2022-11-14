public class dbu_VertexCtrl { 
    @AuraEnabled
    public static dbu_lstCartItemAndCartWrapper getVertexQuoteTax(Id cartId, dbu_Addresses  objAddress)
    {
        map<Integer, Id> mapProductNameToId = new map<Integer, Id>();
        map<Integer, Decimal> mapProductNameToDiscount = new map<Integer, Decimal>();
        //OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        boolean isCallFailed = false;
        List<ccrz__E_CartItem__c> lstCartLineItem = new List<ccrz__E_CartItem__c>();
        List<CC_Tax__c> oldTaxList=new List<CC_Tax__c>();
        Savepoint sp;
        ccrz__E_Cart__c objTosave = new ccrz__E_Cart__c();
        objTosave.Id = cartId;
        Decimal TotalTax;
        Set<id> cartitemId=new Set<id>();
        dbu_lstCartItemAndCartWrapper objlstCartItemAndCartWrapper = new dbu_lstCartItemAndCartWrapper();
        try{
            // Query Cart
            //ccrz__E_Cart__c objCart = [Select Id,Name,ccrz__SubtotalAmount__c,ccrz__TotalDiscount__c, ccrz__Account__c, ccrz__Account__r.Name,ccrz__Account__r.Type,ccrz__Account__r.BOLT_Account_Number__c,ccrz__Account__r.Customer_BMS_number__c,ccrz__Account__r.Bolt_BC_Code__c,ccrz__Account__r.IAM_Service_Provider_Code__c ,ccrz__Account__r.CMI_Cid__c, ccrz__Account__r.Vertex_Customer_Class_Code__c, ccrz__Account__r.CMI_Address2__c, ccrz__Account__r.CMI_Address3__c , ccrz__Account__r.BillingCity ,ccrz__Account__r.Billingstate ,ccrz__Account__r.BillingPostalCode ,ccrz__Account__r.BillingCountry, ccrz__Account__r.BillingStreet,ccrz__Account__r.ShippingStreet,ccrz__Account__r.shippingCity,ccrz__Account__r.ShippingState,ccrz__Account__r.shippingPostalCode,ccrz__Account__r.shippingCountry  from ccrz__E_Cart__c where Id=: CartId];
            ccrz__E_Cart__c objCart = [Select Id, ccrz__User__r.contact.account.FSL_ERP_Customer_Code__c, ccrz__User__r.contact.account.Customer_BMS_number__c, ccrz__User__r.contact.account.FSL_BMS_Instance__c, ccrz__ShipMethod__c,Name,ccrz__TotalQuantity__c,ccrz__ShipAmount__c,ccrz__SubtotalAmount__c,ccrz__TotalDiscount__c, ccrz__Account__c,ccrz__Account__r.id, ccrz__Account__r.FSL_ERP_Customer_Code__c, ccrz__Account__r.Customer_BMS_number__c, ccrz__Account__r.Name,ccrz__Account__r.Type,ccrz__Account__r.BillingCity ,ccrz__Account__r.Billingstate ,ccrz__Account__r.BillingPostalCode ,ccrz__Account__r.BillingCountry, ccrz__Account__r.BillingStreet,ccrz__Account__r.ShippingStreet,ccrz__Account__r.shippingCity,ccrz__Account__r.ShippingState,ccrz__Account__r.shippingPostalCode,ccrz__Account__r.shippingCountry,ccrz__Account__r.OwnerId,ccrz__ShipTo__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c, ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__PostalCode__c, ccrz__ShipTo__r.OwnerId,ccrz__BillTo__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__BillTo__r.ccrz__State__c,ccrz__BillTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__BillTo__r.OwnerId,dbu_Pick_Up_From_Store__c,dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c,dbu_Pick_Up_From_Store__r.ccrz__State__c,dbu_Pick_Up_From_Store__r.ccrz__City__c,dbu_Pick_Up_From_Store__r.ccrz__Country__c,dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c,dbu_Pick_Up_From_Store__r.OwnerId,ccrz__User__c from ccrz__E_Cart__c where Id=: CartId];
            lstCartLineItem = [Select Id, Name, Prorated_Subamount__c,Prorated_Coupon_Discount__c,Prorated_Price_AfterDiscount__c,ccrz__ParentCartItem__c,Vertex_tax__c,ccrz__ExtSKU__c, ccrz__UnitOfMeasure__c, ccrz__SubAmount__c, ccrz__DisplayProduct__r.ccrz__SKU__c, ccrz__Product__r.dbu_Product_Code__c ,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Name, ccrz__Product__r.ccrz__TaxRateId__c, ccrz__Product__r.Product_Class_Code__c, ccrz__Product__r.ccrz__Quantityperunit__c,ccrz__Product__r.ccrz__UnitOfMeasure__c,ccrz__Quantity__c, ccrz__AbsoluteDiscount__c,ccrz__Price__c from ccrz__E_CartItem__c where ccrz__Cart__c=: CartId and ccrz__Product__r.ccrz__Taxable__c = true];
            //lstCartLineItem = [Select Id, Name,ccrz__ParentCartItem__c,Prorated_Subamount__c ,Vertex_tax__c,ccrz__ExtSKU__c, ccrz__UnitOfMeasure__c, ccrz__SubAmount__c, ccrz__DisplayProduct__r.ccrz__SKU__c, ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Name,ccrz__Product__r.Product_Class_Code__c, ccrz__Quantity__c, ccrz__AbsoluteDiscount__c,ccrz__Price__c from ccrz__E_CartItem__c where ccrz__Cart__c=: CartId];
            System.debug('objCart=========================>\t'+objCart);
            dbu_Vertex_GeneralizedInputWrapper objReq = new dbu_Vertex_GeneralizedInputWrapper();
            objReq.DataArea = new dbu_Vertex_GeneralizedInputWrapper.DataArea();
            objReq.DataArea.Seller = new dbu_Vertex_GeneralizedInputWrapper.Seller();
            objReq.DataArea.Seller.Physical_Origin = new dbu_Vertex_GeneralizedInputWrapper.Physical_Origin();
            objReq.DataArea.Seller.AdministrativeOrigin = new dbu_Vertex_GeneralizedInputWrapper.Physical_Origin();
            objReq.DataArea.Customer = new dbu_Vertex_GeneralizedInputWrapper.Customer();
            objReq.DataArea.Customer.Destination_Addesss = new dbu_Vertex_GeneralizedInputWrapper.Physical_Origin();
            objReq.DataArea.Customer.Administrive_Destination = new dbu_Vertex_GeneralizedInputWrapper.Administrive_Destination();
            objReq.DataArea.ProductList = new List<dbu_Vertex_GeneralizedInputWrapper.ProductList>();
            
            objReq.isForQuote = true;
            objReq.recordId = objCart.Id;
            objReq.QuotationRequestDocumentNumber = objCart.Id;
            
            if(objCart.ccrz__User__r.contact.account.FSL_ERP_Customer_Code__c !=null && objCart.ccrz__User__r.contact.account.FSL_ERP_Customer_Code__c.split('-').contains('USA') == true)
            {
                objReq.DataArea.Customer.Customer_Code = objCart.ccrz__User__r.contact.account.FSL_ERP_Customer_Code__c.split('-')[0];
            }

            else if(objCart.ccrz__User__r.contact.account.FSL_ERP_Customer_Code__c ==null && objCart.ccrz__User__r.contact.account.FSL_BMS_Instance__c == 'USA')
            {
                objReq.DataArea.Customer.Customer_Code = objCart.ccrz__User__r.contact.account.Customer_BMS_number__c;
            }

            else if(objCart.ccrz__ShipTo__r.OwnerId != null)
            {
                objReq.DataArea.Customer.Customer_Code = objCart.ccrz__ShipTo__r.OwnerId;
            }
            else if(objCart.ccrz__BillTo__r.OwnerId != null)
            {
                objReq.DataArea.Customer.Customer_Code = objCart.ccrz__BillTo__r.OwnerId;
            }
            else
            {
                objReq.DataArea.Customer.Customer_Code = objCart.ccrz__Account__c;
            }
            
            if(objCart.dbu_Pick_Up_From_Store__c != null && String.isNotBlank(objCart.ccrz__ShipMethod__c) && (objCart.ccrz__ShipMethod__c == 'Pick Up' || objCart.ccrz__ShipMethod__c == 'Ramassage')){
                System.debug('objCart.dbu_Pick_Up_From_Store__c===============>\t'+objCart.dbu_Pick_Up_From_Store__c);
                System.debug('objCart.dbu_Pick_Up_From_Store__r.ccrz__State__c===============>\t'+objCart.dbu_Pick_Up_From_Store__r.ccrz__State__c);
                System.debug('objCart.dbu_Pick_Up_From_Store__r.ccrz__City__c===============>\t'+objCart.dbu_Pick_Up_From_Store__r.ccrz__City__c);
                System.debug('objCart.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c===============>\t'+objCart.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c);
                System.debug('objCart. dbu_Pick_Up_From_Store__r.ccrz__Country__c===============>\t'+objCart.dbu_Pick_Up_From_Store__r.ccrz__Country__c);
                objReq.DataArea.Customer.Destination_Addesss.AddressLine1 = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c);
                //objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(objCart.ccrz__Account__r.CMI_Address2__c);
                objReq.DataArea.Customer.Destination_Addesss.City = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__City__c) ;
                objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__State__c);
                objReq.DataArea.Customer.Destination_Addesss.Postal_Code = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c);
                objReq.DataArea.Customer.Destination_Addesss.Country = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__Country__c);
                
                objReq.DataArea.Customer.Administrive_Destination.AddressLine1 = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c);
                //objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(objCart.ccrz__Account__r.CMI_Address2__c);
                objReq.DataArea.Customer.Administrive_Destination.City = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__City__c) ;
                objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__State__c);
                objReq.DataArea.Customer.Administrive_Destination.Postal_Code = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c);
                objReq.DataArea.Customer.Administrive_Destination.Country = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__Country__c);
            }else if(objAddress != null){
                
                objReq.DataArea.Customer.Destination_Addesss.AddressLine1 = nullCheck(objAddress.shippingAddress.address1);
                objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(objAddress.shippingAddress.address2);
                objReq.DataArea.Customer.Destination_Addesss.City = nullCheck(objAddress.shippingAddress.city);
                objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(objAddress.shippingAddress.state);
                objReq.DataArea.Customer.Destination_Addesss.Postal_Code = nullCheck(objAddress.shippingAddress.postalCode);
                objReq.DataArea.Customer.Destination_Addesss.Country = nullCheck(objAddress.shippingAddress.country);
                
                objReq.DataArea.Customer.Administrive_Destination.AddressLine1 = nullCheck(objAddress.billingAddress.address1);
                objReq.DataArea.Customer.Administrive_Destination.AddressLine2 = nullCheck(objAddress.billingAddress.address2);
                objReq.DataArea.Customer.Administrive_Destination.City = nullCheck(objAddress.billingAddress.city);
                objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(objAddress.billingAddress.state);
                objReq.DataArea.Customer.Administrive_Destination.Postal_Code = nullCheck(objAddress.billingAddress.postalCode);
                objReq.DataArea.Customer.Administrive_Destination.Country = nullCheck(objAddress.billingAddress.country);
            }else if(objCart.ccrz__ShipTo__c != null){
                System.debug('objCart.ccrz__ShipTo__c===============>\t'+objCart.ccrz__ShipTo__c);
                System.debug('objCart.ccrz__ShipTo__r.ccrz__State__c===============>\t'+objCart.ccrz__ShipTo__r.ccrz__State__c);
                System.debug('objCart.ccrz__ShipTo__r.ccrz__City__c===============>\t'+objCart.ccrz__ShipTo__r.ccrz__City__c);
                System.debug('objCart.ccrz__ShipTo__r.ccrz__PostalCode__c===============>\t'+objCart.ccrz__ShipTo__r.ccrz__PostalCode__c);
                System.debug('objCart.ccrz__ShipTo__r.ccrz__Country__c===============>\t'+objCart.ccrz__ShipTo__r.ccrz__Country__c);
                objReq.DataArea.Customer.Destination_Addesss.AddressLine1 = nullCheck(objCart.ccrz__ShipTo__r.ccrz__AddressFirstline__c);
                //objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(objCart.ccrz__Account__r.CMI_Address2__c);
                objReq.DataArea.Customer.Destination_Addesss.City = nullCheck(objCart.ccrz__ShipTo__r.ccrz__City__c) ;
                objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(objCart.ccrz__ShipTo__r.ccrz__State__c);
                objReq.DataArea.Customer.Destination_Addesss.Postal_Code = nullCheck(objCart.ccrz__ShipTo__r.ccrz__PostalCode__c);
                objReq.DataArea.Customer.Destination_Addesss.Country = nullCheck(objCart.ccrz__ShipTo__r.ccrz__Country__c);
                
                objReq.DataArea.Customer.Administrive_Destination.AddressLine1 = nullCheck(objCart.ccrz__ShipTo__r.ccrz__AddressFirstline__c);
                //objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(objCart.ccrz__Account__r.CMI_Address2__c);
                objReq.DataArea.Customer.Administrive_Destination.City = nullCheck(objCart.ccrz__ShipTo__r.ccrz__City__c) ;
                objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(objCart.ccrz__ShipTo__r.ccrz__State__c);
                objReq.DataArea.Customer.Administrive_Destination.Postal_Code = nullCheck(objCart.ccrz__ShipTo__r.ccrz__PostalCode__c);
                objReq.DataArea.Customer.Administrive_Destination.Country = nullCheck(objCart.ccrz__ShipTo__r.ccrz__Country__c);
                
            }else if(objCart.ccrz__BillTo__c != null){
                                //CHG0103827
                                System.debug('objCart.dbu_Pick_Up_From_Store__c===============>\t'+objCart.dbu_Pick_Up_From_Store__c);
                                System.debug('objCart.dbu_Pick_Up_From_Store__r.ccrz__State__c===============>\t'+objCart.dbu_Pick_Up_From_Store__r.ccrz__State__c);
                                System.debug('objCart.dbu_Pick_Up_From_Store__r.ccrz__City__c===============>\t'+objCart.dbu_Pick_Up_From_Store__r.ccrz__City__c);
                                System.debug('objCart.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c===============>\t'+objCart.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c);
                                System.debug('objCart.dbu_Pick_Up_From_Store__r.ccrz__Country__c===============>\t'+objCart.dbu_Pick_Up_From_Store__r.ccrz__Country__c);
                                //Shriram:16 Feb 2021 objReq.DataArea.Customer.Destination_Addesss.AddressLine1 = nullCheck(objCart.ccrz__BillTo__r.ccrz__State__c);
                                objReq.DataArea.Customer.Destination_Addesss.AddressLine1 = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c);
                                //objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(objCart.ccrz__Account__r.CMI_Address2__c);
                                objReq.DataArea.Customer.Destination_Addesss.City = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__City__c) ;
                                objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__State__c);
                                objReq.DataArea.Customer.Destination_Addesss.Postal_Code = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c);
                                objReq.DataArea.Customer.Destination_Addesss.Country = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__Country__c);
                                
                                objReq.DataArea.Customer.Administrive_Destination.AddressLine1 = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c);
                                //objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(objCart.ccrz__Account__r.CMI_Address2__c);
                                objReq.DataArea.Customer.Administrive_Destination.City = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__City__c) ;
                                objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__State__c);
                                objReq.DataArea.Customer.Administrive_Destination.Postal_Code = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c);
                                objReq.DataArea.Customer.Administrive_Destination.Country = nullCheck(objCart.dbu_Pick_Up_From_Store__r.ccrz__Country__c);                
    }else
            {
                objReq.DataArea.Customer.Destination_Addesss.AddressLine1 = nullCheck(objCart.ccrz__Account__r.ShippingStreet);
                //objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(objCart.ccrz__Account__r.CMI_Address2__c);
                objReq.DataArea.Customer.Destination_Addesss.City = nullCheck(objCart.ccrz__Account__r.shippingCity) ;
                objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(objCart.ccrz__Account__r.ShippingState);
                objReq.DataArea.Customer.Destination_Addesss.Postal_Code = nullCheck(objCart.ccrz__Account__r.shippingPostalCode);
                objReq.DataArea.Customer.Destination_Addesss.Country = nullCheck(objCart.ccrz__Account__r.shippingCountry);
                
                objReq.DataArea.Customer.Administrive_Destination.AddressLine1 = nullCheck(objCart.ccrz__Account__r.BillingStreet);
                //objReq.DataArea.Customer.Administrive_Destination.AddressLine2 = nullCheck(objCart.ccrz__Account__r.CMI_Address2__c);
                objReq.DataArea.Customer.Administrive_Destination.City = nullCheck(objCart.ccrz__Account__r.BillingCity);
                objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(objCart.ccrz__Account__r.Billingstate);
                objReq.DataArea.Customer.Administrive_Destination.Postal_Code = nullCheck(objCart.ccrz__Account__r.BillingPostalCode);
                objReq.DataArea.Customer.Administrive_Destination.Country = nullCheck(objCart.ccrz__Account__r.BillingCountry);
            }
            Integer counter = 0;
            for(ccrz__E_CartItem__c objCartLine : lstCartLineItem)
            {
                counter++;
                if(objCartLine.ccrz__ParentCartItem__c==null){
                    dbu_Vertex_GeneralizedInputWrapper.ProductList objProductLineItem = new dbu_Vertex_GeneralizedInputWrapper.ProductList();
                    
                    mapProductNameToId.put(Integer.valueof(objCartLine.Name), objCartLine.Id);
                    //mapProductNameToDiscount.put(Integer.valueof(objCartLine.Name),objCartLine.Prorated_Coupon_Discount__c);
                    objProductLineItem.LineItemNumber = String.valueOf(Integer.valueof(objCartLine.Name));
                    /*Shriram 16th Feb 2021 if(objCartLine.ccrz__DisplayProduct__r.ccrz__SKU__c != null)
objProductLineItem.ProductCode = objCartLine.ccrz__DisplayProduct__r.ccrz__SKU__c;
else
objProductLineItem.ProductCode = '';*/
                    if(objCartLine.ccrz__Product__r.dbu_Product_Code__c != null)
                        objProductLineItem.ProductCode = objCartLine.ccrz__Product__r.dbu_Product_Code__c;
                    else
                        objProductLineItem.ProductCode = '';    
                    //objProductLineItem.ProductClassCode = objCartLine.ccrz__Product__r.Product_Class_Code__c;
                    objProductLineItem.ProductClassCode = objCartLine.ccrz__Product__r.ccrz__TaxRateId__c;
                    if(objCartLine.ccrz__Quantity__c != null)
                        objProductLineItem.Quantity = String.valueOf(objCartLine.ccrz__Quantity__c);
                    else
                        objProductLineItem.Quantity = '';
                    objProductLineItem.UnitOfMeasure = nullCheck(objCartLine.ccrz__Product__r.ccrz__UnitOfMeasure__c);
                    if(objCartLine.ccrz__Product__r.ccrz__Quantityperunit__c != null){
                        objProductLineItem.Quantityperunit = String.valueOf(objCartLine.ccrz__Product__r.ccrz__Quantityperunit__c);    
                    }
                    
                    if(objCartLine.ccrz__Price__c  > 0)
                    {
                        Decimal proratedSub_ToRound=objCartLine.ccrz__Price__c * objCartLine.ccrz__Quantity__c;
                        Decimal proratedCouponDiscount_ToRound = 0;
                        // if(objCartLine.Prorated_Coupon_Discount__c != null)
                        // 	proratedCouponDiscount_ToRound = objCartLine.Prorated_Coupon_Discount__c;
                        if(objCartLine.ccrz__AbsoluteDiscount__c == null || objCartLine.ccrz__AbsoluteDiscount__c == 0.00 ||objCartLine.ccrz__AbsoluteDiscount__c == 0 || objCartLine.ccrz__AbsoluteDiscount__c == 0.0){
                            objProductLineItem.UserDefinedDiscountCode = '';
                        }else{
                            proratedCouponDiscount_ToRound = objCartLine.ccrz__AbsoluteDiscount__c;
                            objProductLineItem.UserDefinedDiscountCode = 'Discount';
                        }
                        System.debug('proratedSub_ToRound=>\t'+proratedSub_ToRound);
                        System.debug('proratedCouponDiscount_ToRound=>\t'+proratedCouponDiscount_ToRound);
                        objProductLineItem.ExtendedPrice = String.valueOf(proratedSub_ToRound.setScale(2, RoundingMode.HALF_UP));
                        if(proratedCouponDiscount_ToRound != null){
                            objProductLineItem.DiscountAmount = String.valueOf(proratedCouponDiscount_ToRound.setScale(2, RoundingMode.HALF_UP));
                        }
                        System.debug('objProductLineItem.ExtendedPrice=>\t'+objProductLineItem.ExtendedPrice);
                        System.debug('objProductLineItem.DiscountAmount=>\t'+objProductLineItem.DiscountAmount);
                    }
                    else
                    {
                        objProductLineItem.ExtendedPrice = String.valueOf(0);
                        objProductLineItem.DiscountAmount = String.valueOf(0);
                    }
                    
                    if(objCart.ccrz__Account__r.Name != null )
                        objProductLineItem.CustomerName = objCart.ccrz__Account__r.Name.left(40);
                    else
                        objProductLineItem.CustomerName = '';
                    
                    //12thFeb21 objProductLineItem.BC = System.Label.OSM_Vertex_Flex_Field_Code_BC;
                    
                    objReq.DataArea.ProductList.add(objProductLineItem);
                    if(objCart.ccrz__TotalDiscount__c != null)
                        objReq.DataArea.DiscountAmount = String.valueOf(objCart.ccrz__TotalDiscount__c);
                    else
                        objReq.DataArea.DiscountAmount = String.valueOf(0);
                    
                }
                /*********************************New Logic on 17 Feb 2021 *******************************************/
                if(counter == lstCartLineItem.size()){
                    if(objCartLine.ccrz__ParentCartItem__c==null){
                        dbu_Vertex_GeneralizedInputWrapper.ProductList objProductLineItem = new dbu_Vertex_GeneralizedInputWrapper.ProductList();
                        //mapProductNameToId.put(Integer.valueof(objCartLine.Name), objCartLine.Id);
                        //mapProductNameToDiscount.put(Integer.valueof(objCartLine.Name),objCartLine.Prorated_Coupon_Discount__c);
                        objProductLineItem.LineItemNumber = '9999';
                        objProductLineItem.ProductCode = System.Label.dbu_Vertex_Product_Code;
                        objProductLineItem.ProductClassCode = System.Label.dbu_Vertex_DELIVERY_SHIPPING;
                        if(objCart.ccrz__TotalQuantity__c != null)
                            objProductLineItem.Quantity = String.valueOf(objCart.ccrz__TotalQuantity__c);
                        else
                            objProductLineItem.Quantity = '';
                        
                       
                        objProductLineItem.UserDefinedDiscountCode = '';
                        objProductLineItem.UnitOfMeasure = nullCheck(objCartLine.ccrz__Product__r.ccrz__UnitOfMeasure__c);
                        
                        if(objCart.ccrz__ShipAmount__c != null){
                            objProductLineItem.ExtendedPrice = String.valueOf(objCart.ccrz__ShipAmount__c);
                        }else{
                            objProductLineItem.ExtendedPrice = String.valueOf(0.00);
                        }
                        objProductLineItem.DiscountAmount = String.valueOf(0.00);
                        
                        if(objCart.ccrz__Account__r.Name != null )
                            objProductLineItem.CustomerName = objCart.ccrz__Account__r.Name.left(40);
                        else
                            objProductLineItem.CustomerName = '';
                        
                        //12thFeb21 objProductLineItem.BC = System.Label.OSM_Vertex_Flex_Field_Code_BC;
                        
                        objReq.DataArea.ProductList.add(objProductLineItem);
                    }
                }
                /***********************************************End of the new logic 17 Feb 2021 **************************/
            }
            System.debug('objReq in VrtxCtrl=>'+ JSON.serialize(objReq));
            dbu_Vertex_GeneralizedoutputWrapper objResponseWrp = dbu_Integration_Vertex.getTaxQuote(objReq);
            //sp = Database.setSavepoint();
            System.debug('$$$$$$$$$$$$$$ final tax : '+objResponseWrp);
            //log = objResponseWrp.log; 
            //if(!objResponseWrp.errorFlag)    
            // {
            totalTax = Decimal.ValueOf(objResponseWrp.DataArea.TotalTax);
            //updating cart line 
            List<CC_Tax__c> taxList =new List<CC_Tax__c>();
            List<ccrz__E_CartItem__c> lstToUpdateCartLineItem = new List<ccrz__E_CartItem__c>();
            System.debug('objResponseWrp.DataArea.ProductList___'+objResponseWrp.DataArea.ProductList);
            //INC2628005
            if(objResponseWrp == Null || objResponseWrp.status == 'Error'){
                objlstCartItemAndCartWrapper.taxStatus = 'Error';
                return objlstCartItemAndCartWrapper;
            }
            if(objResponseWrp != Null){
                Decimal prductCount = mapProductNameToId.size();
                for(dbu_Vertex_GeneralizedoutputWrapper.ProductList  objProduct : objResponseWrp.DataArea.ProductList){
                    if(objProduct.ProductClassCode == 'DELIVERY/SHIPPING'){
                        for(dbu_Vertex_GeneralizedoutputWrapper.Taxes tax:objProduct.Taxes){
                            if(tax.CalculatedTax != '0.0'){
                                for(String cartItemIdObj : mapProductNameToId.values()){
                                    CC_Tax__c taxObj=new CC_Tax__c();
                                    taxObj.CC_Cart_Item__c= cartItemIdObj;
                                    taxObj.TaxResult__c=tax.taxResult;
                                    taxObj.TaxType__c=tax.taxType;
                                    taxObj.ReasonCode__c=tax.reasonCode;
                                    if(tax.isService==null){
                                        taxObj.IsService__c=Boolean.ValueOf('false');
                                    }
                                    else{
                                        taxObj.IsService__c=Boolean.ValueOf(tax.isService);
                                    }
                                    taxObj.situs__c=tax.situs;
                                    taxObj.TaxCollectedFromParty__c=tax.taxCollectedFromParty;
                                    taxObj.TaxStructure__c=tax.taxStructure;
                                    taxObj.JurisdictionLevel__c=tax.jurisdictionLevel;
                                    taxObj.JurisdictionId__c=tax.jurisdictionId;
                                    taxObj.JurisdictionValue__c=tax.JurisdictionValue;
                                    Decimal calcTax = 0.0;
                                    
                                    if(tax.CalculatedTax != '0.0'){
                                        calcTax = Decimal.valueOf(tax.CalculatedTax)/prductCount;
                                    }
                                    taxObj.CalculatedTax__c = String.valueOf(calcTax);
                                    taxObj.EffectiveRate__c =tax.EffectiveRate ;
                                    taxObj.Taxable__c =tax.Taxable ;
                                    taxObj.NonTaxable__c =tax.NonTaxable ;
                                    taxObj.ImpositionId__c=tax.impositionId ;
                                    taxObj.ImpositionValue__c=tax.impositionValue ;
                                    taxObj.ImpositionTypeId__c =tax.impositionTypeId ;
                                    taxObj.ImpositionTypevalue__c=tax.ImpositionTypevalue ;
                                    taxObj.TaxRuleId__c=tax.TaxRuleId ;
                                    taxObj.dbu_Is_Shipping_Tax__c = true;
                                    //taxObj.Discount_Amount__c= newObjCartLineItem.Prorated_Coupon_Discount__c;
                                    taxList.add(taxObj);
                                    system.debug(' in 1st taxList  ' + taxList);
                                }
                            }
                        }
                    }
                }
            }
            
            for(dbu_Vertex_GeneralizedoutputWrapper.ProductList  objProduct : objResponseWrp.DataArea.ProductList)
            {
                if(mapProductNameToId.get(objProduct.LineItemNumber) != null){
                    ccrz__E_CartItem__c newObjCartLineItem = new ccrz__E_CartItem__c();                      
                    newObjCartLineItem.Id = mapProductNameToId.get(objProduct.LineItemNumber);
                    newObjCartLineItem.Vertex_tax__c = objProduct.LineItemTotalTax;
                    newObjCartLineItem.Prorated_Coupon_Discount__c=mapProductNameToDiscount.get(objProduct.LineItemNumber);
                    /* New changes related to Tax CartItem level */
                    if(objProduct.Taxes != null){
                        for(dbu_Vertex_GeneralizedoutputWrapper.Taxes tax:objProduct.Taxes){     
                            CC_Tax__c taxObj=new CC_Tax__c();
                            
                            taxObj.CC_Cart_Item__c=newObjCartLineItem.Id;
                            taxObj.TaxResult__c=tax.taxResult;
                            taxObj.TaxType__c=tax.taxType;
                            taxObj.ReasonCode__c=tax.reasonCode;
                            if(tax.isService==null){
                                taxObj.IsService__c=Boolean.ValueOf('false');
                            }
                            else{
                                taxObj.IsService__c=Boolean.ValueOf(tax.isService);
                            }
                            taxObj.situs__c=tax.situs;
                            taxObj.TaxCollectedFromParty__c=tax.taxCollectedFromParty;
                            taxObj.TaxStructure__c=tax.taxStructure;
                            taxObj.JurisdictionLevel__c=tax.jurisdictionLevel;
                            taxObj.JurisdictionId__c=tax.jurisdictionId;
                            taxObj.JurisdictionValue__c=tax.JurisdictionValue;
                            taxObj.CalculatedTax__c =tax.CalculatedTax;
                            taxObj.EffectiveRate__c =tax.EffectiveRate ;
                            taxObj.Taxable__c =tax.Taxable ;
                            taxObj.NonTaxable__c =tax.NonTaxable ;
                            taxObj.ImpositionId__c=tax.impositionId ;
                            taxObj.ImpositionValue__c=tax.impositionValue ;
                            taxObj.ImpositionTypeId__c =tax.impositionTypeId ;
                            taxObj.ImpositionTypevalue__c=tax.ImpositionTypevalue ;
                            taxObj.TaxRuleId__c=tax.TaxRuleId ;
                            taxObj.Discount_Amount__c= newObjCartLineItem.Prorated_Coupon_Discount__c;
                            taxList.add(taxObj);
                        }
                    }
                    
                    /* cart Item level tax calculation*/
                    lstToUpdateCartLineItem.add(newObjCartLineItem);
                }
            }
            System.Debug('123lstToUpdateCartLineItem=>'+lstToUpdateCartLineItem);
            try{
                //Uncomment :Shriramupdate lstToUpdateCartLineItem;
                //upsert lstToUpdateCartLineItem;
                objlstCartItemAndCartWrapper.lstCartItem = lstToUpdateCartLineItem;
                
            }catch(Exception ex){
                //CHG0084922
                dbu_Integration_Error_Log.createErrorLog(null,ex.getMessage()+'>>>'+ex.getLineNumber()+'>>>>'+ex.getStackTraceString(),'','','Vertex Exception','Exception');
                System.debug('Exception in vertexCtrl While Updating lstToUpdateCartLineItem Message ==>'+ex.getMessage()+'LineNumber=>\t'+ex.getLineNumber());
            }
            System.debug('Updated cart line items tax');
            //15th April changes
            for(CC_Tax__c taxCartItem:taxList){
                cartitemId.add(taxCartItem.CC_Cart_Item__c);
            }
            oldTaxList=[Select id,CC_Cart_Item__c from CC_Tax__c where CC_Cart_Item__c IN:cartitemId];
            
            
            if(oldTaxList!=null){                  
                Database.delete(oldTaxList);                     
            } 
            if(taxList!=null){ 
                
               // insert taxList;  
                //CHG0084922 start
            Database.SaveResult[] srList = Database.insert(taxList, true);
            boolean isSuccess = true;
            list<string> insertedtaxIDlist = new list<string>();
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted cart. cart ID: ' + sr.getId());
                    insertedtaxIDlist.add(sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('cart fields that affected this error: ' + err.getFields());
                        //CHG0084922 End
                dbu_Integration_Error_Log.createErrorLog(null,err.getMessage()+'>>>'+err.getStatusCode()+'>>>>'+err.getFields(),'','','Vertex Exception','Exception');
                    }
                }
            }
            }
            objTosave.ccrz__TaxAmount__c = totalTax; 
            try{
                //Uncomment :Shriram update objTosave;
                objlstCartItemAndCartWrapper.cart = objTosave;
            }catch(DMLException ex){
                 //CHG0084922
                dbu_Integration_Error_Log.createErrorLog(null,ex.getMessage()+'>>>'+ex.getLineNumber()+'>>>>'+ex.getStackTraceString(),'','','Vertex Exception','Exception');
                System.debug('Exception in vertexCtrl While Updating lstToUpdateCartLineItem Message ==>'+ex.getMessage()+'LineNumber=>\t'+ex.getLineNumber());
            }
            //update objTosave;
            System.debug('Updated cart tax');
            //}
        }catch(Exception ex){
            //CHG0084922
            dbu_Integration_Error_Log.createErrorLog(null,ex.getMessage()+'>>>'+ex.getLineNumber()+'>>>>'+ex.getStackTraceString(),'','','Vertex Exception','Exception');
            ////INC2628005
            objlstCartItemAndCartWrapper.taxStatus = 'Error';
            return objlstCartItemAndCartWrapper;
        }
        return objlstCartItemAndCartWrapper;
    }
    
    public static dbu_lstCartItemAndCartWrapper getVertexInvoiceTax(Id orderId)
    {
        dbu_lstCartItemAndCartWrapper response = new dbu_lstCartItemAndCartWrapper();
        return response;
    }
    public static String nullCheck(String strValue)
    {
        if(strValue != null)
            return strValue;
        else
            return '';
    }
}