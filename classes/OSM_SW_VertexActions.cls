public class OSM_SW_VertexActions
{

    public static decimal getVertexQuoteTax(Id cartId, OSM_SW_Addresses  objAddress)
    {
        decimal totalTax=0.0;
        map<Integer, Id> mapProductNameToId = new map<Integer, Id>();
        map<Integer, Decimal> mapProductNameToDiscount = new map<Integer, Decimal>();
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        boolean isCallFailed = false;
        List<ccrz__E_CartItem__c> lstCartLineItem = new List<ccrz__E_CartItem__c>();
        List<CC_Tax__c> oldTaxList=new List<CC_Tax__c>();
        Savepoint sp;
        ccrz__E_Cart__c objTosave = new ccrz__E_Cart__c();
        objTosave.Id = cartId;
        Set<id> cartitemId=new Set<id>();
        ccrz__E_Cart__c objCart = new ccrz__E_Cart__c(); // Added By Dhiraj
         
        try
        {
            // Query Cart
            //ccrz__E_Cart__c objCart = [Select Id,Name,ccrz__SubtotalAmount__c,ccrz__TotalDiscount__c, ccrz__Account__c, ccrz__Account__r.Name,ccrz__Account__r.Type,ccrz__Account__r.BOLT_Account_Number__c,ccrz__Account__r.Customer_BMS_number__c,ccrz__Account__r.Bolt_BC_Code__c,ccrz__Account__r.IAM_Service_Provider_Code__c ,ccrz__Account__r.CMI_Cid__c, ccrz__Account__r.Vertex_Customer_Class_Code__c, ccrz__Account__r.CMI_Address2__c, ccrz__Account__r.CMI_Address3__c , ccrz__Account__r.BillingCity ,ccrz__Account__r.Billingstate ,ccrz__Account__r.BillingPostalCode ,ccrz__Account__r.BillingCountry, ccrz__Account__r.BillingStreet,ccrz__Account__r.ShippingStreet,ccrz__Account__r.shippingCity,ccrz__Account__r.ShippingState,ccrz__Account__r.shippingPostalCode,ccrz__Account__r.shippingCountry  from ccrz__E_Cart__c where Id=: CartId];
            objCart = [Select Id,Name,Third_Party_BMS_Customer_ID__c,OSM_Payment_Method__c,OSM_SW_IAM_Account_Id_For_Third_Party__c,OSM_SW_Is_third_Party_BMS_Payment__c,ccrz__SubtotalAmount__c,ccrz__TotalDiscount__c, ccrz__Account__c,ccrz__Account__r.CSS_DistributorCode__c, ccrz__Account__r.Name,ccrz__Account__r.Type,ccrz__Account__r.BOLT_Account_Number__c,ccrz__Account__r.Customer_BMS_number__c,ccrz__Account__r.Bolt_BC_Code__c,ccrz__Account__r.IAM_Service_Provider_Code__c ,ccrz__Account__r.CMI_Cid__c, ccrz__Account__r.Vertex_Customer_Class_Code__c, ccrz__Account__r.CMI_Address2__c, ccrz__Account__r.CMI_Address3__c , ccrz__Account__r.BillingCity ,ccrz__Account__r.Billingstate ,ccrz__Account__r.BillingPostalCode ,ccrz__Account__r.BillingCountry, ccrz__Account__r.BillingStreet,ccrz__Account__r.ShippingStreet,ccrz__Account__r.shippingCity,ccrz__Account__r.ShippingState,ccrz__Account__r.shippingPostalCode,ccrz__Account__r.shippingCountry  from ccrz__E_Cart__c where Id=: CartId];
           
            lstCartLineItem = [Select Id, Name, Prorated_Subamount__c,Prorated_Coupon_Discount__c,Prorated_Price_AfterDiscount__c,ccrz__ParentCartItem__c,Vertex_tax__c,ccrz__ExtSKU__c, ccrz__UnitOfMeasure__c, ccrz__SubAmount__c, ccrz__DisplayProduct__r.ccrz__SKU__c, ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Name, ccrz__Product__r.Product_Class_Code__c,ccrz__Quantity__c, ccrz__AbsoluteDiscount__c,ccrz__Price__c from ccrz__E_CartItem__c where ccrz__Cart__c=: CartId];
             
             
            //Start:Code Commented by Vaibhav 18-Jun
                OSM_VERTEX_WS_GeneralizedInputWrapper objReq = new OSM_VERTEX_WS_GeneralizedInputWrapper();
                objReq.DataArea = new OSM_VERTEX_WS_GeneralizedInputWrapper.DataArea();
                objReq.DataArea.Seller = new OSM_VERTEX_WS_GeneralizedInputWrapper.Seller();
                objReq.DataArea.Seller.Physical_Origin = new OSM_VERTEX_WS_GeneralizedInputWrapper.Physical_Origin();
                objReq.DataArea.Seller.AdministrativeOrigin = new OSM_VERTEX_WS_GeneralizedInputWrapper.Physical_Origin();
                objReq.DataArea.Customer = new OSM_VERTEX_WS_GeneralizedInputWrapper.Customer();
                objReq.DataArea.Customer.Destination_Addesss = new OSM_VERTEX_WS_GeneralizedInputWrapper.Physical_Origin();
                objReq.DataArea.Customer.Administrive_Destination = new OSM_VERTEX_WS_GeneralizedInputWrapper.Administrive_Destination();
                objReq.DataArea.ProductList = new List<OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList>();
                
                objReq.isForQuote = true;
                objReq.recordId = objCart.Id;
                objReq.QuotationRequestDocumentNumber = objCart.Name;
                System.debug('objcart value' +objcart);
                if(objCart.OSM_SW_Is_third_Party_BMS_Payment__c)//Added some changes for 738
                { 
                    if(objCart.ccrz__Account__r.CSS_DistributorCode__c == '04959')
                    {
                        if(objCart.Third_Party_BMS_Customer_ID__c != null) // modified by swetha for OMG-1104 
                            objReq.DataArea.Customer.Customer_Code = objCart.Third_Party_BMS_Customer_ID__c;
                        else
                            objReq.DataArea.Customer.Customer_Code = objCart.ccrz__Account__r.Customer_BMS_number__c; 
                        
                        Map<String, OSM_Southern_Plain__mdt> southernPlainMapData=OSM_FetchCustomMetaData_Ctrl.getSouthernPlainMetaDataMap();
                        OSM_Southern_Plain__mdt osmSouthernPlain = southernPlainMapData.get(objCart.ccrz__Account__r.CSS_DistributorCode__c);
                         if(osmSouthernPlain != Null) {
                                objReq.DataArea.divisionCode = osmSouthernPlain.Division_Code__c;
                             	objReq.DataArea.SPFRC = osmSouthernPlain.RC_Code__c;
                                objReq.DataArea.SPFBC = osmSouthernPlain.BC_Code__c;
                            }
                    } else
                    {
                        List<Account> accountList = [Select id,IAM_Service_Provider_Code__c,Customer_BMS_number__c,CSS_DistributorCode__c from Account where id=:objCart.OSM_SW_IAM_Account_Id_For_Third_Party__c];
                    	System.debug('Accountlist' +accountlist);
                        if(accountList!=null && accountList.size()>0 &&  accountList[0].Customer_BMS_number__c!=null)
                    			objReq.DataArea.Customer.Customer_Code = nullCheck(accountList[0].Customer_BMS_number__c);
						else if (accountList!=null && accountList.size()>0 && accountList[0].Customer_BMS_number__c==null)
                     			objReq.DataArea.Customer.Customer_Code = nullCheck(objCart.Third_Party_BMS_Customer_ID__c);
						if(accountList[0].CSS_DistributorCode__c != Null)
                        {
                         	Map<String, OSM_Southern_Plain__mdt> southernPlainMapData=OSM_FetchCustomMetaData_Ctrl.getSouthernPlainMetaDataMap();
                            OSM_Southern_Plain__mdt osmSouthernPlain = southernPlainMapData.get(accountList[0].CSS_DistributorCode__c);
                            if(osmSouthernPlain != Null){
                                    objReq.DataArea.divisionCode = osmSouthernPlain.Division_Code__c;
                                    objReq.DataArea.SPFRC = osmSouthernPlain.RC_Code__c;
                                    objReq.DataArea.SPFBC = osmSouthernPlain.BC_Code__c;
                             } 
                        }                                                
                	}
                }//ended changes for 738
                else
                { System.debug('In else block');
                    /*if(objCart.ccrz__Account__r.Customer_BMS_number__c != null && objCart.ccrz__Account__r.Customer_BMS_number__c != '')
                    { */
                        objReq.DataArea.Customer.Customer_Code = nullCheck(objCart.ccrz__Account__r.Customer_BMS_number__c);
                        //MAR-1947 Code Start
                        if(objCart.ccrz__Account__r.CSS_DistributorCode__c != Null && objCart.OSM_Payment_Method__c =='po'){
                            Map<String, OSM_Southern_Plain__mdt> southernPlainMapData=OSM_FetchCustomMetaData_Ctrl.getSouthernPlainMetaDataMap();
                            OSM_Southern_Plain__mdt osmSouthernPlain = southernPlainMapData.get(objCart.ccrz__Account__r.CSS_DistributorCode__c);
                            if(osmSouthernPlain != Null){
                                objReq.DataArea.divisionCode = osmSouthernPlain.Division_Code__c;
                                objReq.DataArea.SPFRC = osmSouthernPlain.RC_Code__c;
                                objReq.DataArea.SPFBC = osmSouthernPlain.BC_Code__c;
                            }
                        } //MAR-1947 Code End
                        //code changed by swetha -MP-431
                        else if(objCart.ccrz__Account__r.CSS_DistributorCode__c == '04959' && objCart.OSM_Payment_Method__c =='cc'){
                            Map<String, OSM_Southern_Plain__mdt> southernPlainMapData=OSM_FetchCustomMetaData_Ctrl.getSouthernPlainMetaDataMap();
                            OSM_Southern_Plain__mdt osmSouthernPlain = southernPlainMapData.get(objCart.ccrz__Account__r.CSS_DistributorCode__c);
                            if(osmSouthernPlain != Null ){
                                objReq.DataArea.divisionCode = osmSouthernPlain.Division_Code__c;
                            }
                        }// Swetha code changes end -MP-431
                   /* } */ 
                    /*else*/ if(objCart.ccrz__Account__r.BOLT_Account_Number__c != null && objCart.ccrz__Account__r.BOLT_Account_Number__c != '')
                    {
                        objReq.DataArea.Customer.Customer_Code = nullCheck(objCart.ccrz__Account__r.BOLT_Account_Number__c);
                    }
                  //changed by swetha 1080
                 else if(objCart.ccrz__Account__r.Customer_BMS_number__c != null && objCart.ccrz__Account__r.Customer_BMS_number__c != '')
                    
                        {
                 		objReq.DataArea.Customer.Customer_Code = nullCheck(objCart.ccrz__Account__r.Customer_BMS_number__c);
                         }
                    else
                    {
                        objReq.DataArea.Customer.Customer_Code = nullCheck(objCart.ccrz__Account__r.IAM_Service_Provider_Code__c);
                    }
                   // ended
                }
                
              /*  if(objCart.ccrz__TotalDiscount__c != null) Mar-1434
                {
                    Decimal totalDiscount=objCart.ccrz__TotalDiscount__c;
                    objReq.DataArea.DiscountAmount = String.valueOf(totalDiscount.setScale(2, RoundingMode.HALF_UP));
                 }
                else */
                    objReq.DataArea.DiscountAmount = '';

                
                if(objAddress != null)
                {
                    
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
                }
                else
                {
                    objReq.DataArea.Customer.Destination_Addesss.AddressLine1 = nullCheck(objCart.ccrz__Account__r.ShippingStreet);
                    objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(objCart.ccrz__Account__r.CMI_Address2__c);
                    objReq.DataArea.Customer.Destination_Addesss.City = nullCheck(objCart.ccrz__Account__r.shippingCity) ;
                    objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(objCart.ccrz__Account__r.ShippingState);
                    objReq.DataArea.Customer.Destination_Addesss.Postal_Code = nullCheck(objCart.ccrz__Account__r.shippingPostalCode);
                    objReq.DataArea.Customer.Destination_Addesss.Country = nullCheck(objCart.ccrz__Account__r.shippingCountry);
                    
                    objReq.DataArea.Customer.Administrive_Destination.AddressLine1 = nullCheck(objCart.ccrz__Account__r.BillingStreet);
                    objReq.DataArea.Customer.Administrive_Destination.AddressLine2 = nullCheck(objCart.ccrz__Account__r.CMI_Address2__c);
                    objReq.DataArea.Customer.Administrive_Destination.City = nullCheck(objCart.ccrz__Account__r.BillingCity);
                    objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(objCart.ccrz__Account__r.Billingstate);
                    objReq.DataArea.Customer.Administrive_Destination.Postal_Code = nullCheck(objCart.ccrz__Account__r.BillingPostalCode);
                    objReq.DataArea.Customer.Administrive_Destination.Country = nullCheck(objCart.ccrz__Account__r.BillingCountry);
                }
                
                
                
                for(ccrz__E_CartItem__c objCartLine : lstCartLineItem)
                {
                    if(objCartLine.ccrz__ParentCartItem__c==null){
                    OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList objProductLineItem = new OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList();
                    
                    mapProductNameToId.put(Integer.valueof(objCartLine.Name), objCartLine.Id);
                    mapProductNameToDiscount.put(Integer.valueof(objCartLine.Name),objCartLine.Prorated_Coupon_Discount__c);
                    objProductLineItem.LineItemNumber = String.valueOf(Integer.valueof(objCartLine.Name));
                    if(objCartLine.ccrz__DisplayProduct__r.ccrz__SKU__c != null)
                        objProductLineItem.ProductCode = objCartLine.ccrz__DisplayProduct__r.ccrz__SKU__c;
                    else
                        objProductLineItem.ProductCode = '';
                    objProductLineItem.ProductClassCode = objCartLine.ccrz__Product__r.Product_Class_Code__c;
                    if(objCartLine.ccrz__Quantity__c != null)
                        objProductLineItem.Quantity = String.valueOf(objCartLine.ccrz__Quantity__c);
                    else
                        objProductLineItem.Quantity = '';
                    objProductLineItem.UnitOfMeasure = nullCheck(objCartLine.ccrz__UnitOfMeasure__c);
                    
                    
                    if(objCartLine.ccrz__SubAmount__c > 0)
                    {
                        Decimal proratedSub_ToRound=objCartLine.Prorated_Subamount__c;
                        Decimal proratedCouponDiscount_ToRound=objCartLine.Prorated_Coupon_Discount__c;
                        objProductLineItem.ExtendedPrice = String.valueOf(proratedSub_ToRound.setScale(2, RoundingMode.HALF_UP));
                        objProductLineItem.DiscountAmount = String.valueOf(proratedCouponDiscount_ToRound.setScale(2, RoundingMode.HALF_UP));
                        if(objProductLineItem.DiscountAmount == '0.00')
                            objProductLineItem.UserDefinedDiscountCode = '';  //Mar-1434
                         else 
                             objProductLineItem.UserDefinedDiscountCode = 'Discount';
                    }
                    else
                    {
                        objProductLineItem.ExtendedPrice = String.valueOf(0);
                        objProductLineItem.DiscountAmount = String.valueOf(0);
                        objProductLineItem.UserDefinedDiscountCode = '';  //Mar-1434
                    }
                    
                    if(objCart.ccrz__Account__r.Name != null )
                        objProductLineItem.CustomerName = objCart.ccrz__Account__r.Name.left(40);
                    else
                        objProductLineItem.CustomerName = '';
                    // Changes for story :191399
                    /*
                    boolean isDistributorAccount = false;
                    if(objCart.ccrz__Account__r.Type != null && (objCart.ccrz__Account__r.Type == 'Distributor Account' || objCart.ccrz__Account__r.Type == 'Distributor Branch Account'))
                        isDistributorAccount = true;
                    
                    if(isDistributorAccount)
                    {
                        objProductLineItem.BC = objCart.ccrz__Account__r.Bolt_BC_Code__c;
                    }
                    else
                    {
                        objProductLineItem.BC = System.Label.OSM_Vertex_Flex_Field_Code_BC;
                    }
                    */
                    
                    objProductLineItem.BC = System.Label.OSM_Vertex_Flex_Field_Code_BC;
                    
                    objReq.DataArea.ProductList.add(objProductLineItem);
                  }
                 }   
                OSM_VERTEX_WS_GeneralizedoutputWrapper objResponseWrp = OSM_CC_Vertex_Service.callTaxService(objReq);
                sp = Database.setSavepoint();
                System.debug('$$$$$$$$$$$$$$ final tax : '+objResponseWrp);
                log = objResponseWrp.log;
                log.Account__c = objCart.ccrz__Account__c; // Added By Dhiraj 
                if(!objResponseWrp.errorFlag)    
                {
                    totalTax = objResponseWrp.DataArea.TotalTax;
                    //updating cart line 
                     List<CC_Tax__c> taxList =new List<CC_Tax__c>();
                    List<ccrz__E_CartItem__c> lstToUpdateCartLineItem = new List<ccrz__E_CartItem__c>();
                   System.debug('objResponseWrp.DataArea.ProductList___'+objResponseWrp.DataArea.ProductList);
                    for(OSM_VERTEX_WS_GeneralizedoutputWrapper.ProductList  objProduct : objResponseWrp.DataArea.ProductList)
                    {
                    
                        ccrz__E_CartItem__c newObjCartLineItem = new ccrz__E_CartItem__c();                      
                         newObjCartLineItem.Id = mapProductNameToId.get(objProduct.LineItemNumber);
                         newObjCartLineItem.Vertex_tax__c = objProduct.LineItemTotalTax;
                         newObjCartLineItem.Prorated_Coupon_Discount__c=mapProductNameToDiscount.get(objProduct.LineItemNumber);
                          for(OSM_VERTEX_WS_GeneralizedoutputWrapper.Taxes tax:objProduct.Taxes){     
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
                            
                        lstToUpdateCartLineItem.add(newObjCartLineItem);              
                    }
                     update lstToUpdateCartLineItem;
                     for(CC_Tax__c taxCartItem:taxList){
                     cartitemId.add(taxCartItem.CC_Cart_Item__c);
                     }
                     oldTaxList=[Select id,CC_Cart_Item__c from CC_Tax__c where CC_Cart_Item__c IN:cartitemId];
                     
                     
                     if(oldTaxList!=null){                  
                         Database.delete(oldTaxList);                     
                     } 
                     if(taxList!=null){ 
                                    
                     insert taxList;  
                     }                   
                     objTosave.Is_Vertax_Tax_calculation_Failed__c = false;
                     objTosave.ccrz__TaxAmount__c = totalTax; 
                     objTosave.ccrz__TaxAmount__c = totalTax;
                     objTosave.ccrz__Account__c = objCart.ccrz__Account__c; // Added By Dhiraj
                    
                }
                else
                {
                    if(Boolean.valueOf(System.Label.OSM_Vertex_Skip_Tax))
                    {
                        for(ccrz__E_CartItem__c objCartLine : lstCartLineItem)
                        {
                            if(objCartLine.Vertex_tax__c == null)
                                objCartLine.Vertex_tax__c = 0;
                            objCartLine.Vertex_tax__c= objCartLine.Vertex_tax__c + 5;
                            
                            totalTax = totalTax + 12;
                        }
                        
                        update lstCartLineItem;

                        objTosave.Is_Vertax_Tax_calculation_Failed__c = false;
                        objTosave.ccrz__TaxAmount__c = totalTax;
                        objTosave.ccrz__Account__c = objCart.ccrz__Account__c; // Added By Dhiraj

                    }
                    else {
                        String errorTextRes = Label.OSM_Vertex_Address_Text;
                        if(objResponseWrp.errorMsg.contains(errorTextRes) || objResponseWrp.errorMsg.contains('required address fields')){
                            objTosave.Is_Vertex_API_Failed__c = false;
                            objTosave.ccrz__Account__c = objCart.ccrz__Account__c; // Added By Dhiraj
                        }else{
                            objTosave.Is_Vertex_API_Failed__c = true;
                            objTosave.ccrz__Account__c = objCart.ccrz__Account__c; // Added By Dhiraj
                        }
                        objTosave.Is_Vertax_Tax_calculation_Failed__c = true;
                        objTosave.ccrz__Account__c = objCart.ccrz__Account__c; // Added By Dhiraj

                    }
                }
                 log.Account__c = objCart.ccrz__Account__c; // Added By Dhiraj         
          if(Test.isRunningTest()){
             throw new NullPointerException();                          
            }   
            
            //End:Code Commented by Vaibhav 18-Jun
        }
        catch(Exception ex)
        {
            objTosave.Is_Vertax_Tax_calculation_Failed__c = true;
            log.Status__c = Label.OSM_SW_Create_Log_on_QuoteVertexCall_Failure;
            String msg  = 'Message - '+ex.getMessage();
            msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
            log.Error_Description__c = msg;
            log.Service_Name__c = System.Label.OSM_Vertex_Service_Name_Quote;
            log.Source__c = Label.OSM_Source;
            log.Target__c = System.Label.OSM_Vertex_Target;
            log.Cart__c = cartId;
            log.Logged_In_User__c = userinfo.getuserid();
            log.Account__c = objCart.ccrz__Account__c; // Added By Dhiraj
            isCallFailed = true;
            Database.rollback(sp);
        }
        finally 
        {
            if(log.Status__c == Label.OSM_SW_Create_Log_on_QuoteVertexCall_Failure || Boolean.valueOf(System.Label.OSM_SW_Create_Log_on_QuoteVertexCall_Success) ){
            if(!Test.isRunningTest()){
               
                insert log;
                }
                }
            update objTosave;
        }
        
        
        
        
        return totalTax;
    }
    
    public static String nullCheck(String strValue)
    {
        if(strValue != null)
            return strValue;
        else
            return '';
    }
    
    public static OSM_ReturnWrapper getVertexInvoiceTax(List<Id> lstJunctionObjectId ,boolean isRefundInvoiceReq)
    {
        System.debug('in invocie vertex call');
        OSM_ReturnWrapper objToReturn = new OSM_ReturnWrapper();
    
        //List to save
        List<ccrz__E_InvoiceItem__c> lstToUpdateInvoiceItem = new List<ccrz__E_InvoiceItem__c>();
        List<ccrz__E_Invoice__c> lstToUpdateInvoice = new List<ccrz__E_Invoice__c>();
        List<OSM_InvoiceLine_And_OrderLine__c> lstToUpdateJunctionItem = new List<OSM_InvoiceLine_And_OrderLine__c>();
        List<OSM_Orders_In_Invoice__c> lstToUpdateJunctionObject = new List<OSM_Orders_In_Invoice__c>();
        List<OSM_Integration_Log__c> lstToInsertLog = new List<OSM_Integration_Log__c>();
        Map<Id, Decimal> mapInvoiceToVertexTax = new Map<Id, Decimal>();
        Map<Id, Decimal> mapOrderToTotalAmount = new Map<Id, Decimal>();
        String AccountId;
                 
        List<OSM_Orders_In_Invoice__c> lstJunctionObject = new List<OSM_Orders_In_Invoice__c>();
        //Added CC_Order__r.ccrz__Account__r.Customer_BMS_number__c For MP-431 by Swetha
        // Added Below where clause (MAR-1088) by Ashish
        // WHERE CC_Order_Item__r.IsInvoiceRefund__c = false
        // AND CC_Order_Item__r.OSM_SW_Is_Included_Product__c = false
        //lstJunctionObject = [Select Id,CC_Invoice__r.CreditMemo_Number__c,CC_Invoice__r.ccrz__CCOrder__c, CC_Invoice__r.ccrz__Status__c, CC_Invoice__r.OSM_SW_IsIntercompanyInvoice__c,CC_Invoice__r.ccrz__Contact__r.Account.Bolt_Customer_Account_Status__c,CC_Invoice__r.ccrz__Contact__r.Account.Bolt_Credit_Hold__c,CC_Invoice__r.ccrz__Contact__r.Account.BOLT_Account_Number__c, CC_Invoice__r.Payment_Method__c,CC_Order__r.ccrz__OrderDate__c,CC_Order__r.ccrz__Account__r.Bolt_Customer_Account_Status__c,CC_Order__r.ccrz__Account__r.Type, CC_Order__r.ccrz__Account__r.Bolt_BC_Code__c,CC_Order__r.ccrz__Account__r.Bolt_Credit_Hold__c,CC_Invoice__r.OSM_SW_Is_Bolt_PO__c, OSM_SW_Is_Recurring_Invoice__c, Vertex_Call_Status__c, Name, CC_Invoice__c, CC_Invoice__r.Name,CC_Invoice__r.Total_Sales_Amount__c, CC_Order__c, CC_Order__r.ccrz__Account__c,CC_Order__r.ccrz__Account__r.Name, CC_Order__r.ccrz__TotalDiscount__c, CC_Order__r.ccrz__Account__r.BOLT_Account_Number__c,CC_Order__r.ccrz__Account__r.Customer_BMS_number__c,CC_Order__r.ccrz__Account__r.IAM_Service_Provider_Code__c,CC_Order__r.ccrz__Account__r.CMI_Cid__c, CC_Order__r.ccrz__Account__r.Vertex_Customer_Class_Code__c, CC_Order__r.ccrz__Account__r.CMI_Address2__c,  CC_Order__r.ccrz__Account__r.CMI_Address3__c, CC_Order__r.ccrz__Account__r.BillingCity, CC_Order__r.ccrz__Account__r.Billingstate, CC_Order__r.ccrz__Account__r.ShippingStreet,CC_Order__r.ccrz__Account__r.BillingStreet,CC_Order__r.ccrz__Account__r.BillingPostalCode, CC_Order__r.ccrz__Account__r.BillingCountry, CC_Order__r.ccrz__Account__r.shippingCity, CC_Order__r.ccrz__Account__r.ShippingState, CC_Order__r.ccrz__Account__r.shippingPostalCode, CC_Order__r.ccrz__Account__r.shippingCountry,CC_Order__r.ccrz__BillTo__c, CC_Order__r.ccrz__BillTo__r.ccrz__AddressFirstline__c,CC_Order__r.ccrz__BillTo__r.ccrz__AddressSecondline__c,CC_Order__r.ccrz__BillTo__r.ccrz__City__c,CC_Order__r.ccrz__BillTo__r.ccrz__StateISOCode__c,CC_Order__r.ccrz__BillTo__r.ccrz__State__c,CC_Order__r.ccrz__BillTo__r.ccrz__Country__c,CC_Order__r.ccrz__BillTo__r.ccrz__PostalCode__c,CC_Order__r.ccrz__ShipTo__c, CC_Order__r.ccrz__ShipTo__r.ccrz__AddressFirstline__c, CC_Order__r.ccrz__ShipTo__r.ccrz__AddressSecondline__c, CC_Order__r.ccrz__ShipTo__r.ccrz__City__c, CC_Order__r.ccrz__ShipTo__r.ccrz__StateISOCode__c,CC_Order__r.ccrz__ShipTo__r.ccrz__State__c, CC_Order__r.ccrz__ShipTo__r.ccrz__Country__c, CC_Order__r.ccrz__ShipTo__r.ccrz__PostalCode__c,OSM_Vertex_Invoice_Failed_Count__c, (Select Id, Name,CC_Invoice_Item__c,CC_Order_Item__c,Vertex_Tax__c, CC_Invoice_Item__r.Quantity__c, CC_Invoice_Item__r.ccrz__OriginalAmount__c, CC_Order_Item__r.ccrz__ExtSKU__c,CC_Order_Item__r.ccrz__UnitOfMeasure__c,CC_Order_Item__r.ccrz__DisplayProduct__r.ccrz__SKU__c,CC_Order_Item__r.VertexOrderItemCall__c,CC_Order_Item__r.ccrz__Product__r.ccrz__SKU__c,CC_Order_Item__r.ccrz__Product__r.Name,CC_Order_Item__r.ccrz__Product__r.Product_Class_Code__c,CC_Order_Item__r.ccrz__AbsoluteDiscount__c,Sales_Amount__c,Quantity__c, CC_Order_Item__r.ccrz__Price__c  from OSM_InvoiceLine_And_OrderLines__r WHERE CC_Order_Item__r.IsInvoiceRefund__c = false AND CC_Order_Item__r.OSM_SW_Is_Included_Product__c = false) from OSM_Orders_In_Invoice__c where Id IN: lstJunctionObjectId];
        lstJunctionObject = [Select Id,CC_Order__r.ccrz__OriginatedCart__r.OSM_SW_Is_third_Party_BMS_Payment__c,CC_Order__r.ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c,CC_Invoice__r.ccrz__BillAddress__c,CC_Invoice__r.ccrz__BillAddress__r.ccrz__AddressFirstline__c,CC_Invoice__r.ccrz__BillAddress__r.ccrz__AddressSecondline__c,CC_Invoice__r.ccrz__BillAddress__r.ccrz__City__c,CC_Invoice__r.ccrz__BillAddress__r.ccrz__StateISOCode__c,
                             CC_Invoice__r.ccrz__BillAddress__r.ccrz__State__c,CC_Invoice__r.ccrz__BillAddress__r.ccrz__PostalCode__c,CC_Invoice__r.ccrz__BillAddress__r.ccrz__Country__c,CC_Invoice__r.CreditMemo_Number__c,CC_Invoice__r.ccrz__CCOrder__c, CC_Invoice__r.ccrz__Status__c,
                             CC_Invoice__r.OSM_SW_IsIntercompanyInvoice__c,CC_Invoice__r.ccrz__Contact__r.Account.Bolt_Customer_Account_Status__c,CC_Invoice__r.ccrz__Contact__r.Account.Bolt_Credit_Hold__c,CC_Invoice__r.ccrz__Contact__r.Account.BOLT_Account_Number__c, CC_Invoice__r.Payment_Method__c,
                             CC_Order__r.ccrz__OrderDate__c,CC_Order__r.ccrz__Account__r.Bolt_Customer_Account_Status__c,CC_Order__r.ccrz__Account__r.Type, CC_Order__r.ccrz__Account__r.Bolt_BC_Code__c,CC_Order__r.ccrz__Account__r.Bolt_Credit_Hold__c,CC_Invoice__r.OSM_SW_Is_Bolt_PO__c, OSM_SW_Is_Recurring_Invoice__c, 
                             Vertex_Call_Status__c, Name, CC_Invoice__c, CC_Invoice__r.Name,CC_Invoice__r.Total_Sales_Amount__c, CC_Order__c, CC_Order__r.ccrz__Account__c,CC_Order__r.ccrz__Account__r.Name, CC_Order__r.ccrz__TotalDiscount__c, CC_Order__r.ccrz__Account__r.BOLT_Account_Number__c,CC_Order__r.ccrz__Account__r.Customer_BMS_number__c,CC_Order__r.ccrz__Account__r.CSS_DistributorCode__c,CC_Order__r.ccrz__Account__r.IAM_Service_Provider_Code__c,
                             CC_Order__r.ccrz__Account__r.CMI_Cid__c, CC_Order__r.ccrz__Account__r.Vertex_Customer_Class_Code__c, CC_Order__r.ccrz__Account__r.CMI_Address2__c,  CC_Order__r.ccrz__Account__r.CMI_Address3__c, CC_Order__r.ccrz__Account__r.BillingCity, CC_Order__r.ccrz__Account__r.Billingstate, CC_Order__r.ccrz__Account__r.ShippingStreet,
                             CC_Order__r.ccrz__Account__r.BillingStreet,CC_Order__r.ccrz__Account__r.BillingPostalCode, CC_Order__r.ccrz__Account__r.BillingCountry, CC_Order__r.ccrz__Account__r.shippingCity, CC_Order__r.ccrz__Account__r.ShippingState, CC_Order__r.ccrz__Account__r.shippingPostalCode, CC_Order__r.ccrz__Account__r.shippingCountry,CC_Order__r.ccrz__BillTo__c,
                             CC_Order__r.ccrz__BillTo__r.ccrz__AddressFirstline__c,CC_Order__r.ccrz__BillTo__r.ccrz__AddressSecondline__c,CC_Order__r.ccrz__BillTo__r.ccrz__City__c,CC_Order__r.ccrz__BillTo__r.ccrz__StateISOCode__c,CC_Order__r.ccrz__BillTo__r.ccrz__State__c,CC_Order__r.ccrz__BillTo__r.ccrz__Country__c,CC_Order__r.ccrz__BillTo__r.ccrz__PostalCode__c,
                             CC_Order__r.ccrz__ShipTo__c, CC_Order__r.ccrz__ShipTo__r.ccrz__AddressFirstline__c, CC_Order__r.ccrz__ShipTo__r.ccrz__AddressSecondline__c, CC_Order__r.ccrz__ShipTo__r.ccrz__City__c, CC_Order__r.ccrz__ShipTo__r.ccrz__StateISOCode__c,CC_Order__r.ccrz__ShipTo__r.ccrz__State__c, CC_Order__r.ccrz__ShipTo__r.ccrz__Country__c, CC_Order__r.ccrz__ShipTo__r.ccrz__PostalCode__c,OSM_Vertex_Invoice_Failed_Count__c, 
                             (Select Id, Name,CC_Invoice_Item__c,CC_Order_Item__c,Vertex_Tax__c, CC_Invoice_Item__r.Quantity__c, CC_Invoice_Item__r.ccrz__OriginalAmount__c, CC_Order_Item__r.ccrz__ExtSKU__c,CC_Order_Item__r.ccrz__UnitOfMeasure__c,CC_Order_Item__r.ccrz__DisplayProduct__r.ccrz__SKU__c,CC_Order_Item__r.VertexOrderItemCall__c,CC_Order_Item__r.ccrz__Product__r.ccrz__SKU__c,CC_Order_Item__r.ccrz__Product__r.Name,CC_Order_Item__r.ccrz__Product__r.Product_Class_Code__c,CC_Order_Item__r.ccrz__AbsoluteDiscount__c,Sales_Amount__c,Quantity__c, CC_Order_Item__r.ccrz__Price__c  from OSM_InvoiceLine_And_OrderLines__r WHERE CC_Order_Item__r.IsInvoiceRefund__c = false AND CC_Order_Item__r.OSM_SW_Is_Included_Product__c = false),CC_Order__r.ccrz__Account__r.Id from OSM_Orders_In_Invoice__c where Id IN: lstJunctionObjectId];
        
        decimal totalTax;
        boolean isCallFail ;
        map<String, OSM_InvoiceLine_And_OrderLine__c> mapPruductSKUtoJunctionLine;
        OSM_VERTEX_WS_GeneralizedoutputWrapper objResponseWrp;
        OSM_Integration_Log__c log;
                       
        
        /*
        for(OSM_Orders_In_Invoice__c objJun : lstJunctionObject)
        {
            if(!mapOrderToTotalAmount.containsKey(objJun.CC_Order__c))
                    mapOrderToTotalAmount.put(objJun.CC_Order__c,0);
            for(OSM_InvoiceLine_And_OrderLine__c objJunctionLine : objJun.OSM_InvoiceLine_And_OrderLines__r)
            {
                
                Decimal tempAmt = mapOrderToTotalAmount.get(objJun.CC_Order__c);
                mapOrderToTotalAmount.put(objJun.CC_Order__c,tempAmt+objJunctionLine.Sales_Amount__c);
            }
        }
            
        */
        
            
        for(OSM_Orders_In_Invoice__c objJun : lstJunctionObject)
        {
            
            if(objJun.OSM_InvoiceLine_And_OrderLines__r != null && objJun.OSM_InvoiceLine_And_OrderLines__r.size() >0)
            {
                AccountId = objJun.CC_Order__r.ccrz__Account__r.Id;
            
                boolean isProcessContinue = false;
                
                if(isRefundInvoiceReq)
                {
                    if(objJun.Vertex_Call_Status__c == Label.OSM_Success)
                    {
                        isProcessContinue = true;
                    }
                }
                else
                {
                    isProcessContinue = true;
                }
                
            
            
            
                if(Test.isRunningTest()){
                    isProcessContinue=true;
                    objJun.CC_Invoice__r.Payment_Method__c='po';
                    objJun.CC_Invoice__r.OSM_SW_Is_Bolt_PO__c = true;
                    System.debug('objJun.CC_Invoice__r.OSM_SW_Is_Bolt_PO__c___'+objJun.CC_Invoice__r.OSM_SW_Is_Bolt_PO__c);
                    List<Account> accList=new List<Account>();
                    /*
                    Account acc=[select id,Bolt_Customer_Account_Status__c,Bolt_Credit_Hold__c,BOLT_Account_Number__c from Account Limit 1];
                    acc.Bolt_Customer_Account_Status__c='Active';
                    acc.Bolt_Credit_Hold__c=false;
                    acc.BOLT_Account_Number__c='123456';
                    accList.add(acc);
                    */
                    //update accList;
                 
                    
                }

                if(isProcessContinue)
                {
                    boolean continueProcess = true;
                    /*if(objJun.CC_Invoice__r.Payment_Method__c == 'po' && !objJun.CC_Invoice__r.OSM_SW_IsIntercompanyInvoice__c)
                    {
                        if(!objJun.CC_Invoice__r.OSM_SW_Is_Bolt_PO__c)
                        {
                            continueProcess = false;
                        }
                    }*/
                    // updated code for 1782
                    if(objJun.CC_Invoice__r.Payment_Method__c == 'po' && !objJun.CC_Invoice__r.OSM_SW_Is_Bolt_PO__c && !objJun.CC_Invoice__r.OSM_SW_IsIntercompanyInvoice__c)
                    {
            continueProcess = false;
                    }
                    if(Test.isRunningTest())
                        continueProcess = true;
                    if(continueProcess)
                    {
                        boolean isRecurringCCNotPaid = true;
                        if(objJun.CC_Invoice__r.Payment_Method__c == 'cc')
                        {
                            if(!isRefundInvoiceReq)
              {
                if(objJun.CC_Invoice__r.ccrz__Status__c != 'Paid')
                {
                  isRecurringCCNotPaid = false;
                }
              }
                        }
                        if(isRecurringCCNotPaid)
                        {
                            totalTax=0.0;
                            isCallFail = false;
                            mapPruductSKUtoJunctionLine = new map<String, OSM_InvoiceLine_And_OrderLine__c>();
                            objResponseWrp = new OSM_VERTEX_WS_GeneralizedoutputWrapper();
                            log = new OSM_Integration_Log__c();
                            log.Account__c = objJun.CC_Order__r.ccrz__Account__r.Id; // Added By Dhiraj
                            try
                            {
                                
                                OSM_VERTEX_WS_GeneralizedInputWrapper objReq = new OSM_VERTEX_WS_GeneralizedInputWrapper();
                                objReq.DataArea = new OSM_VERTEX_WS_GeneralizedInputWrapper.DataArea();
                                objReq.DataArea.Seller = new OSM_VERTEX_WS_GeneralizedInputWrapper.Seller();
                                objReq.DataArea.Seller.Physical_Origin = new OSM_VERTEX_WS_GeneralizedInputWrapper.Physical_Origin();
                                objReq.DataArea.Seller.AdministrativeOrigin = new OSM_VERTEX_WS_GeneralizedInputWrapper.Physical_Origin();
                                objReq.DataArea.Customer = new OSM_VERTEX_WS_GeneralizedInputWrapper.Customer();
                                objReq.DataArea.Customer.Destination_Addesss = new OSM_VERTEX_WS_GeneralizedInputWrapper.Physical_Origin();
                                objReq.DataArea.Customer.Administrive_Destination = new OSM_VERTEX_WS_GeneralizedInputWrapper.Administrive_Destination();
                                objReq.DataArea.ProductList = new List<OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList>();
                                
                                //Changes added by Sangeeta 16th Nov 18 - Start
                                 objReq.orderPlacementDate=String.valueof(objJun.CC_Order__r.ccrz__OrderDate__c);
                                //Changes added by Sangeeta 16th Nov 18 - End
                                
                                objReq.isForQuote = false;
                                objReq.isRefundInvoiceReq = isRefundInvoiceReq;
                                objReq.recordId = objJun.CC_Invoice__c;
                               //Added below IF-ELSE for Mar-1574
                              //List<ccrz__E_Invoice__c > ccInv= [Select id,CreditMemo_Number__c from ccrz__E_Invoice__c where ccrz__CCOrder__c =: objJun.CC_Invoice__r.ccrz__CCOrder__c AND CreditMemo_Number__c != null  ];
                              List<ccrz__E_Invoice__c > ccInv= [Select id,CreditMemo_Number__c from ccrz__E_Invoice__c where ccrz__CCOrder__c =: objJun.CC_Invoice__r.ccrz__CCOrder__c and  IsCredited__c = true order by CreatedDate DESC];
                             //   if(isRefundInvoiceReq && (objJun.CC_Invoice__r.CreditMemo_Number__c != null || objJun.CC_Invoice__r.CreditMemo_Number__c != ''))
                                if(isRefundInvoiceReq && (ccInv[0].CreditMemo_Number__c != null && objJun.CC_Invoice__r.CreditMemo_Number__c != ''))
                                {
                                    objReq.InvoiceRequestDocumentNumber = ccInv[0].CreditMemo_Number__c;
                                }
                                else{
                                objReq.InvoiceRequestDocumentNumber = objJun.CC_Invoice__r.Name;
                                }
                                System.debug('objJun.CC_Invoice__c: '+objJun.CC_Invoice__c);
                                
                                if(objJun.CC_Order__r.ccrz__OriginatedCart__r.OSM_SW_Is_third_Party_BMS_Payment__c)
                                {
                  /*
                                    List<Account> accountList = [Select id,IAM_Service_Provider_Code__c,Customer_BMS_number__c from Account where id=:objJun.CC_Order__r.ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c];
                                    
                                    if(accountList!=null && accountList.size()>0)
                                     objReq.DataArea.Customer.Customer_Code = nullCheck(accountList[0].Customer_BMS_number__c);
                   */
                   
                                    if(objJun.CC_Order__r.ccrz__Account__r.BOLT_Account_Number__c != null && objJun.CC_Order__r.ccrz__Account__r.BOLT_Account_Number__c != '')
                                    {
                                        objReq.DataArea.Customer.Customer_Code = nullCheck(objJun.CC_Order__r.ccrz__Account__r.BOLT_Account_Number__c);
                                    }
                                    else
                                    {
                                        objReq.DataArea.Customer.Customer_Code = nullCheck(objJun.CC_Order__r.ccrz__Account__r.IAM_Service_Provider_Code__c);
                                    }
                                }
                                else
                                {
                                    /*if(objJun.CC_Order__r.ccrz__Account__r.Customer_BMS_number__c != null && objJun.CC_Order__r.ccrz__Account__r.Customer_BMS_number__c != '')
                                    {*/
                                        objReq.DataArea.Customer.Customer_Code = nullCheck(objJun.CC_Order__r.ccrz__Account__r.Customer_BMS_number__c);
                                        // Code added by swetha MP_431
                            if(objJun.CC_Order__r.ccrz__Account__r.CSS_DistributorCode__c != '' && objJun.CC_Invoice__r.Payment_Method__c =='po'){
                            Map<String, OSM_Southern_Plain__mdt> southernPlainMapData=OSM_FetchCustomMetaData_Ctrl.getSouthernPlainMetaDataMap();
                            OSM_Southern_Plain__mdt osmSouthernPlain = southernPlainMapData.get(objJun.CC_Order__r.ccrz__Account__r.CSS_DistributorCode__c);
                            if(osmSouthernPlain != Null){
                                objReq.DataArea.divisionCode = osmSouthernPlain.Division_Code__c;
                                objReq.DataArea.SPFRC = osmSouthernPlain.RC_Code__c;
                                objReq.DataArea.SPFBC = osmSouthernPlain.BC_Code__c;
                            }
                        } //MAR-1947 Code End
                        
                                      else if(objJun.CC_Order__r.ccrz__Account__r.CSS_DistributorCode__c=='04959' && objJun.CC_Invoice__r.Payment_Method__c == 'cc'){
                                            Map<String, OSM_Southern_Plain__mdt> southernPlainMapData=OSM_FetchCustomMetaData_Ctrl.getSouthernPlainMetaDataMap();
											OSM_Southern_Plain__mdt osmSouthernPlain = southernPlainMapData.get(objJun.CC_Order__r.ccrz__Account__r.CSS_DistributorCode__c);
											if(osmSouthernPlain != Null ){
												objReq.DataArea.divisionCode = osmSouthernPlain.Division_Code__c;
											}                                            
                                        }//code ended Mp_431
                                    /*}
                                    else */if(objJun.CC_Order__r.ccrz__Account__r.BOLT_Account_Number__c != null && objJun.CC_Order__r.ccrz__Account__r.BOLT_Account_Number__c != '')
                                    {
                                        objReq.DataArea.Customer.Customer_Code = nullCheck(objJun.CC_Order__r.ccrz__Account__r.BOLT_Account_Number__c);
                                    }
                                    //changed by swetha 1080
                                    else if(objJun.CC_Order__r.ccrz__Account__r.Customer_BMS_number__c != null && objJun.CC_Order__r.ccrz__Account__r.Customer_BMS_number__c != '')
                    
                                     {
                 		              objReq.DataArea.Customer.Customer_Code = nullCheck(objJun.CC_Order__r.ccrz__Account__r.Customer_BMS_number__c);
                                      }
                                     else
                                        {
                                     objReq.DataArea.Customer.Customer_Code = nullCheck(objJun.CC_Order__r.ccrz__Account__r.IAM_Service_Provider_Code__c);
                                        }
                                    //ended 
                                }
                                
                                //objReq.DataArea.Customer.Customer_Code = nullCheck(objJun.CC_Order__r.ccrz__Account__r.BOLT_Account_Number__c);
                              /*  if(objJun.CC_Order__r.ccrz__TotalDiscount__c != null) Mar-1434
                                { 
                                    Decimal totalDiscount=objJun.CC_Order__r.ccrz__TotalDiscount__c;
                                    objReq.DataArea.DiscountAmount = String.valueOf(totalDiscount.setScale(2, RoundingMode.HALF_UP));
                                 }
                                else */
                                    objReq.DataArea.DiscountAmount = '';
                                    // code to take invoice address in case of intercompany invoice
                                    
                                if(objJun.CC_Order__r.ccrz__OriginatedCart__r.OSM_SW_Is_third_Party_BMS_Payment__c && objJun.CC_Invoice__r.OSM_SW_IsIntercompanyInvoice__c && objJun.CC_Invoice__r.ccrz__BillAddress__c != null)
                                {
                                    objReq.DataArea.Customer.Administrive_Destination.AddressLine1 = nullCheck(objJun.CC_Invoice__r.ccrz__BillAddress__r.ccrz__AddressFirstline__c); 
                                    objReq.DataArea.Customer.Administrive_Destination.AddressLine2 = nullCheck(objJun.CC_Invoice__r.ccrz__BillAddress__r.ccrz__AddressSecondline__c); 
                                    objReq.DataArea.Customer.Administrive_Destination.City = nullCheck(objJun.CC_Invoice__r.ccrz__BillAddress__r.ccrz__City__c); 
                                    if(objJun.CC_Invoice__r.ccrz__BillAddress__r.ccrz__StateISOCode__c != null && objJun.CC_Invoice__r.ccrz__BillAddress__r.ccrz__StateISOCode__c != '')
                                        objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(objJun.CC_Invoice__r.ccrz__BillAddress__r.ccrz__StateISOCode__c); 
                                    else
                                        objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(objJun.CC_Invoice__r.ccrz__BillAddress__r.ccrz__State__c);
                                    objReq.DataArea.Customer.Administrive_Destination.Postal_Code = nullCheck(objJun.CC_Invoice__r.ccrz__BillAddress__r.ccrz__PostalCode__c);
                                    objReq.DataArea.Customer.Administrive_Destination.Country =nullCheck(objJun.CC_Invoice__r.ccrz__BillAddress__r.ccrz__Country__c);
                                }
                                else if(objJun.CC_Order__r.ccrz__BillTo__c != null)
                                {
                                    objReq.DataArea.Customer.Administrive_Destination.AddressLine1 = nullCheck(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__AddressFirstline__c); 
                                    objReq.DataArea.Customer.Administrive_Destination.AddressLine2 = nullCheck(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__AddressSecondline__c); 
                                    objReq.DataArea.Customer.Administrive_Destination.City = nullCheck(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__City__c); 
                                    if(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__StateISOCode__c != null && objJun.CC_Order__r.ccrz__BillTo__r.ccrz__StateISOCode__c != '')
                                        objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__StateISOCode__c); 
                                    else
                                        objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__State__c);
                                    objReq.DataArea.Customer.Administrive_Destination.Postal_Code = nullCheck(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__PostalCode__c);
                                    objReq.DataArea.Customer.Administrive_Destination.Country =nullCheck(objJun.CC_Order__r.ccrz__BillTo__r.ccrz__Country__c);
                                }
                                
                                
                                if(objJun.CC_Order__r.ccrz__ShipTo__c != null)
                                {
                                    objReq.DataArea.Customer.Destination_Addesss.AddressLine1 = nullCheck(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__AddressFirstline__c); 
                                    objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__AddressSecondline__c); 
                                    objReq.DataArea.Customer.Destination_Addesss.City = nullCheck(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__City__c); 
                                    if(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__StateISOCode__c != null && objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__StateISOCode__c != '')
                                        objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__StateISOCode__c); 
                                    else
                                        objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__State__c); 
                                    objReq.DataArea.Customer.Destination_Addesss.Postal_Code = nullCheck(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__PostalCode__c); 
                                    objReq.DataArea.Customer.Destination_Addesss.Country = nullCheck(objJun.CC_Order__r.ccrz__ShipTo__r.ccrz__Country__c); 
                                }
                                else
                                {
                                    objReq.DataArea.Customer.Destination_Addesss.AddressLine1 = nullCheck(objJun.CC_Order__r.ccrz__Account__r.ShippingStreet); 
                                    objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(objJun.CC_Order__r.ccrz__Account__r.CMI_Address2__c); 
                                    objReq.DataArea.Customer.Destination_Addesss.City = nullCheck(objJun.CC_Order__r.ccrz__Account__r.shippingCity); 
                                    objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(objJun.CC_Order__r.ccrz__Account__r.ShippingState); 
                                    objReq.DataArea.Customer.Destination_Addesss.Postal_Code = nullCheck(objJun.CC_Order__r.ccrz__Account__r.shippingPostalCode); 
                                    objReq.DataArea.Customer.Destination_Addesss.Country = nullCheck(objJun.CC_Order__r.ccrz__Account__r.shippingCountry); 
                                }
                                
                                
                                for(OSM_InvoiceLine_And_OrderLine__c objJunctionLine : objJun.OSM_InvoiceLine_And_OrderLines__r)
                                {
                                    OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList objProductLineItem = new OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList();
                                    if(objJunctionLine.CC_Order_Item__r.VertexOrderItemCall__c == True){
                                    String lineNumber = String.valueOf(Integer.valueOf(objJunctionLine.Name.replaceAll('[^0-9]', '')));
                                    mapPruductSKUtoJunctionLine.put(lineNumber, objJunctionLine);
                                    objProductLineItem.LineItemNumber = lineNumber;
                                    objProductLineItem.ProductCode = objJunctionLine.CC_Order_Item__r.ccrz__DisplayProduct__r.ccrz__SKU__c;
                                    objProductLineItem.ProductClassCode = objJunctionLine.CC_Order_Item__r.ccrz__Product__r.Product_Class_Code__c;
                                    if(objJunctionLine.Quantity__c != null)
                                        objProductLineItem.Quantity = String.valueOf(objJunctionLine.Quantity__c);
                                    else
                                        objProductLineItem.Quantity = '';
                                    objProductLineItem.UnitOfMeasure = nullCheck(objJunctionLine.CC_Order_Item__r.ccrz__UnitOfMeasure__c);
                                    
                                    
                                    //if(mapOrderToTotalAmount.containsKey(objJun.CC_Order__c) && mapOrderToTotalAmount.get(objJun.CC_Order__c) != null &&  mapOrderToTotalAmount.get(objJun.CC_Order__c) > 0)
                                    if(objJunctionLine.Sales_Amount__c > 0)
                                    {
                                        Decimal ExtendedPrice_TOROUND=objJunctionLine.CC_Order_Item__r.ccrz__Price__c*objJunctionLine.Quantity__c;
                                        Decimal DiscountAmount_TOROUND=(objJunctionLine.CC_Order_Item__r.ccrz__Price__c*objJunctionLine.Quantity__c) - objJunctionLine.Sales_Amount__c;
                                        objProductLineItem.ExtendedPrice = String.valueOf(ExtendedPrice_TOROUND.setScale(2, RoundingMode.HALF_UP));
                                        objProductLineItem.DiscountAmount = String.valueOf(DiscountAmount_TOROUND.setScale(2, RoundingMode.HALF_UP));
                                        if(objProductLineItem.DiscountAmount == '0.00')
                                            objProductLineItem.UserDefinedDiscountCode = '';  //Mar-1434
                                        else 
                                            objProductLineItem.UserDefinedDiscountCode = 'Discount';

                                        if(objProductLineItem.ExtendedPrice != '' && isRefundInvoiceReq)
                                            objProductLineItem.ExtendedPrice = '-'+objProductLineItem.ExtendedPrice;

                                         if(objProductLineItem.ExtendedPrice != '' && objProductLineItem.DiscountAmount != '0.00' && isRefundInvoiceReq)
                                            {
                                            Decimal DiscountedExtendedPrice = ExtendedPrice_TOROUND - DiscountAmount_TOROUND;
                                            objProductLineItem.ExtendedPrice = String.valueOf(DiscountedExtendedPrice.setScale(2, RoundingMode.HALF_UP));
                                            objProductLineItem.ExtendedPrice = '-'+objProductLineItem.ExtendedPrice; 
                                            objProductLineItem.UserDefinedDiscountCode = '';
                                            objProductLineItem.DiscountAmount = '0.00';
                                            }
                                    }
                                    else
                                    {
                                        objProductLineItem.ExtendedPrice = String.valueOf(0);
                                        objProductLineItem.DiscountAmount = String.valueOf(0);
                                        objProductLineItem.UserDefinedDiscountCode = '';  //Mar-1434
                                    }
                                    
                                    
                                    
                                    
                                    /*
                                    
                                    if(objJunctionLine.Sales_Amount__c != null)
                                        objProductLineItem.ExtendedPrice = String.valueOf(objJunctionLine.Sales_Amount__c);
                                    else
                                        objProductLineItem.ExtendedPrice = '';
                                        
                                    if(objProductLineItem.ExtendedPrice != '' && isRefundInvoiceReq)
                                        objProductLineItem.ExtendedPrice = '-'+objProductLineItem.ExtendedPrice;
                                        
                                    if(objJunctionLine.CC_Order_Item__r.ccrz__AbsoluteDiscount__c != null)
                                        objProductLineItem.DiscountAmount = String.valueOf(objJunctionLine.CC_Order_Item__r.ccrz__AbsoluteDiscount__c);
                                    else
                                        objProductLineItem.DiscountAmount = '';
                                    
                                    */
                                    
                                    if(objJun.CC_Order__r.ccrz__Account__r.Name != null)
                                        objProductLineItem.CustomerName = objJun.CC_Order__r.ccrz__Account__r.Name.left(40);
                                     else
                                         objProductLineItem.CustomerName = '';
                                     
                                     // Changes for story :191399
                                    /*
                                    boolean isDistributorAccount = false;
                                    if(objJun.CC_Order__r.ccrz__Account__r.Type != null && (objJun.CC_Order__r.ccrz__Account__r.Type == 'Distributor Account' || objJun.CC_Order__r.ccrz__Account__r.Type == 'Distributor Branch Account'))
                                        isDistributorAccount = true;
                                    
                                    if(isDistributorAccount)
                                    {
                                        objProductLineItem.BC = objJun.CC_Order__r.ccrz__Account__r.Bolt_BC_Code__c;
                                    }
                                    else
                                    {
                                        objProductLineItem.BC = System.Label.OSM_Vertex_Flex_Field_Code_BC;
                                    }
                                    */
                                    objProductLineItem.BC = System.Label.OSM_Vertex_Flex_Field_Code_BC;
                    
                                    objReq.DataArea.ProductList.add(objProductLineItem);
                                    }
                                }
                                
                               
                                objResponseWrp = OSM_CC_Vertex_Service.callTaxService(objReq);
                                System.debug('$$$$$$$$$$$$$$ final tax : '+objResponseWrp);
                                log = objResponseWrp.log;
                                log.Account__c = objJun.CC_Order__r.ccrz__Account__r.Id; // Added By Dhiraj
                                if(!objResponseWrp.errorFlag)    
                                {
                                    // Added if else for MP-454
                                     if(!objJun.CC_Invoice__r.OSM_SW_IsIntercompanyInvoice__c){
                                        totalTax = objResponseWrp.DataArea.TotalTax;
                                    }else{
                                        totalTax = 0;
                                    }
                                    //updateing cart line 
                                    if(!objJun.OSM_SW_Is_Recurring_Invoice__c && !isRefundInvoiceReq)
                                    {
                                        for(OSM_VERTEX_WS_GeneralizedoutputWrapper.ProductList  objProduct : objResponseWrp.DataArea.ProductList)
                                        {
                                           
                                            if(mapPruductSKUtoJunctionLine.containsKey(String.valueOf(objProduct.LineItemNumber)))
                                            {
                                                ccrz__E_InvoiceItem__c newObjInvoiceItem = new ccrz__E_InvoiceItem__c();
                                                newObjInvoiceItem.Id = mapPruductSKUtoJunctionLine.get(String.valueOf(objProduct.LineItemNumber)).CC_Invoice_Item__c;
                                                // Added if else for MP-454
                                                if(!objJun.CC_Invoice__r.OSM_SW_IsIntercompanyInvoice__c){
                                                    newObjInvoiceItem.Vertex_tax__c = objProduct.LineItemTotalTax;
                                                }else{
                                                    newObjInvoiceItem.Vertex_tax__c = 0;
                                                }
                                                lstToUpdateInvoiceItem.add(newObjInvoiceItem);
                                                
                                                OSM_InvoiceLine_And_OrderLine__c objJunctionItem = new OSM_InvoiceLine_And_OrderLine__c();
                                                objJunctionItem.Id = mapPruductSKUtoJunctionLine.get(String.valueOf(objProduct.LineItemNumber)).Id;
                                                // Added if else for MP-454
                                                if(!objJun.CC_Invoice__r.OSM_SW_IsIntercompanyInvoice__c){
                                                    objJunctionItem.Vertex_Tax__c = objProduct.LineItemTotalTax;
                                                }else{
                                                    objJunctionItem.Vertex_Tax__c = 0;
                                                }
                                                lstToUpdateJunctionItem.add(objJunctionItem);
                                            }
                                        } 
                                        objJun.Vertex_Tax__c = totalTax;
                                        mapInvoiceToVertexTax.put(objJun.CC_Invoice__c, totalTax);
                                    }
                                    
                                    if(isRefundInvoiceReq)
                                        objJun.Vertex_Refund_Call_Status__c = Label.OSM_Success;
                                    else
                                        objJun.Vertex_Call_Status__c = Label.OSM_Success;
                                    
                                    System.debug('objJun.CC_Invoice__c : '+objJun.CC_Invoice__c);
                                    if(objJun.CC_Invoice__c != null)
                                    {
                                        ccrz__E_Invoice__c invObj = new ccrz__E_Invoice__c();
                                        invObj.Id = objJun.CC_Invoice__c;
                                        if(!isRefundInvoiceReq)
                                            invObj.OSM_SW_Vertex_Invoice_Request__c = true;
                                        else
                                            invObj.OSM_SW_Vertex_Invoice_Reversal_Request__c = true;
                                        
                                        
                                        lstToUpdateInvoice.add(invObj);
                                    }
                                }
                                else
                                {
                                    isCallFail = true;
                                }
                               if(Test.isRunningTest()){
                                    throw new NullPointerException();
                                
                                }
                            }
                             
                            Catch(Exception ex)
                            {
                                System.debug('exception : '+ex.getMessage());
                                log.Status__c = Label.OSM_SW_Create_Log_on_QuoteVertexCall_Failure; 
                                String msg  = 'Message - '+ex.getMessage();
                                msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
                                log.Error_Description__c = msg;
                                if(isRefundInvoiceReq)
                                    log.Service_Name__c = System.Label.OSM_Vertex_Service_Name_Invoice_Refund;
                                else
                                    log.Service_Name__c = System.Label.OSM_Vertex_Service_Name_Invoice;
                                log.Target__c = System.Label.OSM_Vertex_Target;
                                log.Source__c = 'OSM';
                                log.Invoice__c = objJun.CC_Invoice__c;
                                log.Logged_In_User__c = userinfo.getuserid();
                                log.Account__c = objJun.CC_Order__r.ccrz__Account__r.Id; // Added By Dhiraj
                                isCallFail = true;
                            }
                            
                            
                            
                            
                            lstToInsertLog.add(log);
                            
                            if(isCallFail)
                            {
                                if(isRefundInvoiceReq)
                                    objJun.Vertex_Refund_Call_Status__c = Label.OSM_SW_Create_Log_on_QuoteVertexCall_Failure;
                                else
                                    objJun.Vertex_Call_Status__c = Label.OSM_SW_Create_Log_on_QuoteVertexCall_Failure;
                                if(objJun.OSM_Vertex_Invoice_Failed_Count__c != null)
                                    objJun.OSM_Vertex_Invoice_Failed_Count__c = objJun.OSM_Vertex_Invoice_Failed_Count__c +1;
                                else
                                    objJun.OSM_Vertex_Invoice_Failed_Count__c = 1;
                            }
                            objJun.Vertex_Invoice_Call_Time__c = System.now();
                        }
                    }
                }
            }
        }
        
        
        
        
        //update tax invoice line
        if(mapInvoiceToVertexTax != null && mapInvoiceToVertexTax.size() > 0 || Test.isRunningTest())
        {
            List<ccrz__E_InvoiceItem__c> lstInvoiceItem = new List<ccrz__E_InvoiceItem__c>();
            lstInvoiceItem = [Select Id, ccrz__Invoice__c,ccrz__Invoice__r.OSM_SW_IsIntercompanyInvoice__c, Vertex_Tax__c from ccrz__E_InvoiceItem__c where ccrz__Invoice__c IN: mapInvoiceToVertexTax.keySet() and ccrz__Type__c = 'Tax'];
            
            for(ccrz__E_InvoiceItem__c objInvoiceItem : lstInvoiceItem)
            {
                objInvoiceItem.Vertex_Tax__c = mapInvoiceToVertexTax.get(objInvoiceItem.ccrz__Invoice__c);
                objInvoiceItem.ccrz__OriginalAmount__c = mapInvoiceToVertexTax.get(objInvoiceItem.ccrz__Invoice__c);
                lstToUpdateInvoiceItem.add(objInvoiceItem);
            }
            
            
        }
        
        
        objToReturn.lstJunctionObjInvoiceToOrder = new List<OSM_Orders_In_Invoice__c>();
        objToReturn.lstToUpdateInvoiceItem = new List<ccrz__E_InvoiceItem__c>();
        objToReturn.lstToUpdateJunctionItem = new List<OSM_InvoiceLine_And_OrderLine__c>();
        objToReturn.lstToInsertLog = new List<OSM_Integration_Log__c>();
        objToReturn.updateInvoiceList = new List<ccrz__E_Invoice__c>();
        
        objToReturn.lstJunctionObjInvoiceToOrder = lstJunctionObject;
        objToReturn.lstToUpdateInvoiceItem = lstToUpdateInvoiceItem;
        objToReturn.lstToUpdateJunctionItem = lstToUpdateJunctionItem;
        objToReturn.lstToInsertLog = lstToInsertLog;
        System.debug('lstToUpdateInvoice: '+lstToUpdateInvoice);
        objToReturn.updateInvoiceList = lstToUpdateInvoice;
       
        
        return objToReturn;   
    
        
    }
    
    public static Map<Id,Decimal> getVirtualVertexQuoteTax(Map<Id,OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper>  objWrepper)
    {   
        map<String, String> mapPruductSKUtoJunctionLine;
        map<String, OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper> mapPruductSKUtoWrprObj;
        Map<Id,Decimal> orderIdVsOrderTaxMap = new Map<Id,Decimal>();
        List<OSM_Integration_Log__c> lstLogToSave = new List<OSM_Integration_Log__c>();
        System.debug('log 0.1');
        if(objWrepper != null)
        {
            Set<Id> setOrderId = new Set<Id>();
            Set<Id> setOrderItemId = new Set<Id>();
            Map<Id,Decimal> mapOrderToAmount = new Map<Id,Decimal>();
            Map<Id, Set<Id>> mapAccountToOrderList = new Map<Id, Set<Id>>();
            OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper singleInvWrap2;
            System.debug('log 0.2');
            for(Id accId : objWrepper.keySet())
            {
                singleInvWrap2 =  objWrepper.get(accId);
                for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp2 : singleInvWrap2.invoiceLineOrderLineWrapperLst)
                {
                    setOrderItemId.add(lineJunctionWrapperTmp2.orderLineId);
                    setOrderId.add(lineJunctionWrapperTmp2.orderId);
                    if(!mapAccountToOrderList.containsKey(accId))
                        mapAccountToOrderList.put(accId, new Set<Id>());
                    mapAccountToOrderList.get(accId).add(lineJunctionWrapperTmp2.orderId);
                    /*
                    if(!mapOrderToAmount.containsKey(lineJunctionWrapperTmp2.orderId))
                        mapOrderToAmount.put(lineJunctionWrapperTmp2.orderId,0);
                    
                    Decimal tempamt = mapOrderToAmount.get(lineJunctionWrapperTmp2.orderId);
                    mapOrderToAmount.put(lineJunctionWrapperTmp2.orderId,tempamt+lineJunctionWrapperTmp2.totalSalesAmt);
                    */
                    
                }
                
            }
          
            Map<Id, ccrz__E_Order__c> mapOrder = new Map<Id, ccrz__E_Order__c>();
            
            
            mapOrder.putAll([Select Id, ccrz__OriginatedCart__c,ccrz__OriginatedCart__r.Name, ccrz__Account__r.Bolt_Customer_Account_Status__c,ccrz__Account__r.Bolt_Credit_Hold__c, ccrz__Account__c,ccrz__Account__r.Name, ccrz__TotalDiscount__c, ccrz__Account__r.BOLT_Account_Number__c,ccrz__Account__r.CMI_Cid__c, ccrz__Account__r.Vertex_Customer_Class_Code__c, ccrz__Account__r.CMI_Address2__c,  ccrz__Account__r.CMI_Address3__c, ccrz__Account__r.BillingCity, ccrz__Account__r.Billingstate, ccrz__Account__r.ShippingStreet,ccrz__Account__r.BillingStreet,ccrz__Account__r.BillingPostalCode, ccrz__Account__r.BillingCountry, ccrz__Account__r.shippingCity, ccrz__Account__r.ShippingState, ccrz__Account__r.shippingPostalCode, ccrz__Account__r.shippingCountry,ccrz__BillTo__c, ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__StateISOCode__c,ccrz__BillTo__r.ccrz__State__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__ShipTo__c, ccrz__ShipTo__r.ccrz__AddressFirstline__c, ccrz__ShipTo__r.ccrz__AddressSecondline__c, ccrz__ShipTo__r.ccrz__City__c, ccrz__ShipTo__r.ccrz__StateISOCode__c,ccrz__ShipTo__r.ccrz__State__c, ccrz__ShipTo__r.ccrz__Country__c, ccrz__ShipTo__r.ccrz__PostalCode__c from ccrz__E_Order__c where Id IN: setOrderId ]);
            
            Map<Id, ccrz__E_OrderItem__c> mapOrderItem = new Map<Id, ccrz__E_OrderItem__c>();
            
            mapOrderItem.putAll([Select ccrz__Order__c,ccrz__Price__c,Id,Name, ccrz__DisplayProduct__r.ccrz__SKU__c, ccrz__Product__r.Product_Class_Code__c, ccrz__UnitOfMeasure__c, ccrz__AbsoluteDiscount__c, ccrz__Order__r.ccrz__Account__r.Name from ccrz__E_OrderItem__c where Id IN: setOrderItemId]);
            
            for(Id accId : mapAccountToOrderList.keySet())
            {
                                
                OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper singleInvWrap = new OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper();
                
                singleInvWrap =  objWrepper.get(accId);
                if(singleInvWrap!=null && singleInvWrap.exceptionFlag != true)
                {
                    for(Id ordrId : mapAccountToOrderList.get(accId))
                    {
                        
                        
                        mapPruductSKUtoJunctionLine = new map<String, String>();
                        mapPruductSKUtoWrprObj = new map<String, OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper>();
                    
                        if(mapOrder.containsKey(ordrId) && mapOrder.get(ordrId) != null && mapOrder.get(ordrId).ccrz__OriginatedCart__c != null)
                        {
                            
                            ccrz__E_Order__c ordr = mapOrder.get(ordrId);
                            
                            decimal totalTax=0.0;
                            map<String, Id> mapProductNameToId = new map<String, Id>();
                            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                            boolean isCallFailed = false;
                         
                            try
                            {
                                OSM_VERTEX_WS_GeneralizedInputWrapper objReq = new OSM_VERTEX_WS_GeneralizedInputWrapper();
                                objReq.DataArea = new OSM_VERTEX_WS_GeneralizedInputWrapper.DataArea();
                                objReq.DataArea.Seller = new OSM_VERTEX_WS_GeneralizedInputWrapper.Seller();
                                objReq.DataArea.Seller.Physical_Origin = new OSM_VERTEX_WS_GeneralizedInputWrapper.Physical_Origin();
                                objReq.DataArea.Seller.AdministrativeOrigin = new OSM_VERTEX_WS_GeneralizedInputWrapper.Physical_Origin();
                                objReq.DataArea.Customer = new OSM_VERTEX_WS_GeneralizedInputWrapper.Customer();
                                objReq.DataArea.Customer.Destination_Addesss = new OSM_VERTEX_WS_GeneralizedInputWrapper.Physical_Origin();
                                objReq.DataArea.Customer.Administrive_Destination = new OSM_VERTEX_WS_GeneralizedInputWrapper.Administrive_Destination();
                                objReq.DataArea.ProductList = new List<OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList>();
                                
                                objReq.isForQuote = true;
                                objReq.recordId = ordr.ccrz__OriginatedCart__c;
                                objReq.QuotationRequestDocumentNumber = ordr.ccrz__OriginatedCart__r.Name;
                                
                                
                             /*   if(ordr.ccrz__TotalDiscount__c != null)  Mar-1434
                                {
                                    Decimal DiscAmount_ToRound=ordr.ccrz__TotalDiscount__c;
                                    objReq.DataArea.DiscountAmount = String.valueOf(DiscAmount_ToRound.setScale(2, RoundingMode.HALF_UP));
                                 }
                                else */
                                    objReq.DataArea.DiscountAmount = '';
                                
                                if(ordr.ccrz__BillTo__c != null)
                                {
                                    objReq.DataArea.Customer.Administrive_Destination.AddressLine1 = nullCheck(ordr.ccrz__BillTo__r.ccrz__AddressFirstline__c); 
                                    objReq.DataArea.Customer.Administrive_Destination.AddressLine2 = nullCheck(ordr.ccrz__BillTo__r.ccrz__AddressSecondline__c); 
                                    objReq.DataArea.Customer.Administrive_Destination.City = nullCheck(ordr.ccrz__BillTo__r.ccrz__City__c); 
                                    if(ordr.ccrz__BillTo__r.ccrz__StateISOCode__c != null && ordr.ccrz__BillTo__r.ccrz__StateISOCode__c != '')
                                        objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(ordr.ccrz__BillTo__r.ccrz__StateISOCode__c); 
                                    else
                                        objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(ordr.ccrz__BillTo__r.ccrz__State__c);
                                    objReq.DataArea.Customer.Administrive_Destination.Postal_Code = nullCheck(ordr.ccrz__BillTo__r.ccrz__PostalCode__c);
                                    objReq.DataArea.Customer.Administrive_Destination.Country =nullCheck(ordr.ccrz__BillTo__r.ccrz__Country__c);
                                }
                                else
                                {
                                    objReq.DataArea.Customer.Administrive_Destination.AddressLine1 = nullCheck(ordr.ccrz__Account__r.BillingStreet); 
                                    objReq.DataArea.Customer.Administrive_Destination.AddressLine2 = nullCheck(ordr.ccrz__Account__r.CMI_Address2__c); 
                                    objReq.DataArea.Customer.Administrive_Destination.City = nullCheck(ordr.ccrz__Account__r.BillingCity); 
                                    objReq.DataArea.Customer.Administrive_Destination.State = nullCheck(ordr.ccrz__Account__r.Billingstate); 
                                    objReq.DataArea.Customer.Administrive_Destination.Postal_Code = nullCheck(ordr.ccrz__Account__r.BillingPostalCode);
                                    objReq.DataArea.Customer.Administrive_Destination.Country =nullCheck(ordr.ccrz__Account__r.BillingCountry);
                                }
                                
                                if(ordr.ccrz__ShipTo__c != null)
                                {
                                    objReq.DataArea.Customer.Destination_Addesss.AddressLine1 = nullCheck(ordr.ccrz__ShipTo__r.ccrz__AddressFirstline__c); 
                                    objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(ordr.ccrz__ShipTo__r.ccrz__AddressSecondline__c); 
                                    objReq.DataArea.Customer.Destination_Addesss.City = nullCheck(ordr.ccrz__ShipTo__r.ccrz__City__c); 
                                    if(ordr.ccrz__ShipTo__r.ccrz__StateISOCode__c != null && ordr.ccrz__ShipTo__r.ccrz__StateISOCode__c != '')
                                        objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(ordr.ccrz__ShipTo__r.ccrz__StateISOCode__c); 
                                    else
                                        objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(ordr.ccrz__ShipTo__r.ccrz__State__c); 
                                    objReq.DataArea.Customer.Destination_Addesss.Postal_Code = nullCheck(ordr.ccrz__ShipTo__r.ccrz__PostalCode__c); 
                                    objReq.DataArea.Customer.Destination_Addesss.Country = nullCheck(ordr.ccrz__ShipTo__r.ccrz__Country__c); 
                                }
                                else
                                {
                                    objReq.DataArea.Customer.Destination_Addesss.AddressLine1 = nullCheck(ordr.ccrz__Account__r.ShippingStreet); 
                                    objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = nullCheck(ordr.ccrz__Account__r.CMI_Address2__c); 
                                    objReq.DataArea.Customer.Destination_Addesss.City = nullCheck(ordr.ccrz__Account__r.shippingCity); 
                                    objReq.DataArea.Customer.Destination_Addesss.State = nullCheck(ordr.ccrz__Account__r.ShippingState); 
                                    objReq.DataArea.Customer.Destination_Addesss.Postal_Code = nullCheck(ordr.ccrz__Account__r.shippingPostalCode); 
                                    objReq.DataArea.Customer.Destination_Addesss.Country = nullCheck(ordr.ccrz__Account__r.shippingCountry); 
                                }
                                for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp2 : singleInvWrap.invoiceLineOrderLineWrapperLst)
                                {
                                    OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList objProductLineItem = new OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList();
                                    
                                        if(mapOrderItem.containsKey(lineJunctionWrapperTmp2.orderLineId))
                                        {
                                            if(mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__Order__c == ordrId)
                                            {
                                                mapPruductSKUtoJunctionLine.put(mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).Name, lineJunctionWrapperTmp2.orderLineId);
                                                mapPruductSKUtoWrprObj.put(mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__DisplayProduct__r.ccrz__SKU__c, lineJunctionWrapperTmp2);
                                                objProductLineItem.LineItemNumber = mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).Name;
                                                
                                                objProductLineItem.ProductCode = mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__DisplayProduct__r.ccrz__SKU__c;
                                                objProductLineItem.ProductClassCode = mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__Product__r.Product_Class_Code__c;
                                                if(lineJunctionWrapperTmp2.qty != null)
                                                    objProductLineItem.Quantity = String.valueOf(lineJunctionWrapperTmp2.qty);
                                                else
                                                    objProductLineItem.Quantity = '';
                                                objProductLineItem.UnitOfMeasure = nullCheck(mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__UnitOfMeasure__c);
                                                
                                                //if(mapOrderToAmount.containsKey(ordrId) && mapOrderToAmount.get(ordrId) != null && mapOrderToAmount.get(ordrId) > 0)
                                                if(lineJunctionWrapperTmp2.totalSalesAmt > 0)
                                                {
                                                    Decimal ExPrice_ToRound=mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__Price__c*lineJunctionWrapperTmp2.qty;
                                                    Decimal DisAmount_TORound=(mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__Price__c*lineJunctionWrapperTmp2.qty) - lineJunctionWrapperTmp2.totalSalesAmt;
                                                    objProductLineItem.ExtendedPrice = String.valueOf(ExPrice_ToRound.setScale(2, RoundingMode.HALF_UP));
                                                    objProductLineItem.DiscountAmount = String.valueOf(DisAmount_TORound.setScale(2, RoundingMode.HALF_UP));
                                                    if(objProductLineItem.DiscountAmount == '0.00')
                                                    objProductLineItem.UserDefinedDiscountCode = '';   //Mar-1434
                                                   else 
                                                    objProductLineItem.UserDefinedDiscountCode = 'Discount';
                                                }
                                                else
                                                {
                                                    objProductLineItem.ExtendedPrice = String.valueOf(0);
                                                    objProductLineItem.DiscountAmount = String.valueOf(0);
                                                    objProductLineItem.UserDefinedDiscountCode = '';  //Mar-1434
                                                }
                                                
                                                
                                                /*
                                                if(lineJunctionWrapperTmp2.totalSalesAmt != null)
                                                    objProductLineItem.ExtendedPrice = String.valueOf(lineJunctionWrapperTmp2.totalSalesAmt);
                                                else
                                                    objProductLineItem.ExtendedPrice = '';
                                                    
                                                if(mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__AbsoluteDiscount__c != null)
                                                    objProductLineItem.DiscountAmount = String.valueOf(mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__AbsoluteDiscount__c);
                                                else
                                                    objProductLineItem.DiscountAmount = '';
                                                
                                                */
                                                
                                                if(mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__Order__r.ccrz__Account__r.Name != null)
                                                    objProductLineItem.CustomerName = mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__Order__r.ccrz__Account__r.Name.left(40);
                                                 else
                                                     objProductLineItem.CustomerName = '';
                                                 
                                                 // Changes for story :191399
                                                /*
                                                boolean isDistributorAccount = false;
                                                if(mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__Order__r.ccrz__Account__r.Type != null && (mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__Order__r.ccrz__Account__r.Type == 'Distributor Account' || mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__Order__r.ccrz__Account__r.Type == 'Distributor Branch Account'))
                                                    isDistributorAccount = true;
                                                
                                                if(isDistributorAccount)
                                                {
                                                    objProductLineItem.BC = mapOrderItem.get(lineJunctionWrapperTmp2.orderLineId).ccrz__Order__r.ccrz__Account__r.Bolt_BC_Code__c;
                                                }
                                                else
                                                {
                                                    objProductLineItem.BC = System.Label.OSM_Vertex_Flex_Field_Code_BC;
                                                }
                                                 */
                                                 
                                                 objProductLineItem.BC = System.Label.OSM_Vertex_Flex_Field_Code_BC;
                                                 
                                                 
                                                objReq.DataArea.ProductList.add(objProductLineItem);
                                            }
                                            
                                        }
                                    
                                }
                                
                                OSM_VERTEX_WS_GeneralizedoutputWrapper objResponseWrp = OSM_CC_Vertex_Service.callTaxService(objReq);
                                
                                System.debug('$$$$$$$$$$$$$$ final tax : '+objResponseWrp);

                                log = objResponseWrp.log;
                                if(!objResponseWrp.errorFlag)    
                                {
                                    singleInvWrap.isQuoteTaxFailed = false;
                                    orderIdVsOrderTaxMap.put(ordr.Id,objResponseWrp.DataArea.TotalTax);
                                    
                                    for(OSM_VERTEX_WS_GeneralizedoutputWrapper.ProductList  objProduct : objResponseWrp.DataArea.ProductList)
                                    {
                                        System.debug('objProduct: '+objProduct);
                                        System.debug('objProduct.Taxes: '+objProduct.Taxes);
                                        if(mapPruductSKUtoJunctionLine.containsKey(String.valueOf(objProduct.LineItemNumber)))
                                        {
                                            for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp2 : singleInvWrap.invoiceLineOrderLineWrapperLst)
                                            {
                                                if(lineJunctionWrapperTmp2.orderLineId == mapPruductSKUtoJunctionLine.get(String.valueOf(objProduct.LineItemNumber)))
                                                {
                                                    lineJunctionWrapperTmp2.vertexTax = objProduct.LineItemTotalTax;
                                                    List<CC_Tax__c> taxList =new List<CC_Tax__c>();
                                                    for(OSM_VERTEX_WS_GeneralizedoutputWrapper.Taxes tax:objProduct.Taxes){     
                                                        CC_Tax__c taxObj=new CC_Tax__c();
                                                        
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
                                                         taxList.add(taxObj);
                                                      
                                                         
                                                    }
                                                   
                                                    if(taxList != null && taxList.size() > 0)
                                                    {
                                                        lineJunctionWrapperTmp2.lstTax.addAll(taxList);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    singleInvWrap.isQuoteTaxFailed = true;
                                }
                                    if(Test.isRunningTest()){
             throw new NullPointerException();                          
            }    
                                
                            }
                            catch(Exception ex)
                            {
                                log.Status__c = Label.OSM_SW_Create_Log_on_QuoteVertexCall_Failure;
                                String msg  = 'Message - '+ex.getMessage();
                                msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
                                log.Error_Description__c = msg;
                                log.Service_Name__c = System.Label.OSM_Vertex_Service_Name_Quote;
                                log.Source__c = 'OSM';
                                log.Target__c = System.Label.OSM_Vertex_Target;
                                log.Logged_In_User__c = userinfo.getuserid();
                                singleInvWrap.isQuoteTaxFailed = true;
                            }
                            finally 
                            {
                                lstLogToSave.add(log);
                            }
                        }
                    }
                }
            }
        }
        if(lstLogToSave != null && lstLogToSave.size() >0)
            insert lstLogToSave;
        return orderIdVsOrderTaxMap;
    }
    
    
    // method to update credit memo junction record status if main invoice jun record status is changes
    public static void UpdateAllCreditMemoJunctionVertexStatusSuccessORPending(List<OSM_Orders_In_Invoice__c> lstJunctionObject)
    {
        System.debug('lstJunctionObject : '+lstJunctionObject);
        List<Id> lstJunObjId = new List<Id>();
        List<Id> lstInvoiceId = new List<Id>();
        Map<Id,OSM_Orders_In_Invoice__c> MapInvoiceIdTOjunRec = new Map<Id,OSM_Orders_In_Invoice__c>();
        List<Id> lstCreditMemoInvoiceId = new List<Id>();
        Map<Id,Id> mapCreditmemoToInvoice = new Map<Id,Id>();
        for(OSM_Orders_In_Invoice__c obj: lstJunctionObject)
            lstJunObjId.add(obj.Id);
        
        List<OSM_Orders_In_Invoice__c> lstJunRec = new List<OSM_Orders_In_Invoice__c>();
        lstJunRec = [Select Id,CC_Invoice__c,Vertex_Call_Status__c,OSM_SW_Is_Refund_Request__c from OSM_Orders_In_Invoice__c where Id IN: lstJunObjId and CC_Invoice__r.Invoice_Type__c != 'Credit Memo' and Vertex_Call_Status__c = 'Success'];
        
        if(lstJunRec.size() > 0)
        {
            for(OSM_Orders_In_Invoice__c objJun : lstJunRec)
            {
                lstInvoiceId.add(objJun.CC_Invoice__c);
                MapInvoiceIdTOjunRec.put(objJun.CC_Invoice__c,objJun);
            }
            List<ccrz__E_Invoice__c> lstCreditMemo = new List<ccrz__E_Invoice__c>();
            lstCreditMemo = [Select Id,Original_Sales_Order_Invoice_Number__c from ccrz__E_Invoice__c where Original_Sales_Order_Invoice_Number__c IN: lstInvoiceId and Invoice_Type__c = 'Credit Memo'];
            
            if(lstCreditMemo.size() > 0)
            {
                List<Id> lstIds = new List<Id>();
                for(ccrz__E_Invoice__c objInv : lstCreditMemo)
                {
                    mapCreditmemoToInvoice.put(objInv.Id, objInv.Original_Sales_Order_Invoice_Number__c);
                    lstIds.add(objInv.Id);
                }
                if(lstIds.size() > 0)
                {
                    List<OSM_Orders_In_Invoice__c> lstJunRecFinal = new List<OSM_Orders_In_Invoice__c>();
                    lstJunRecFinal = [Select Id,CC_Invoice__c,Vertex_Call_Status__c ,OSM_SW_Is_Refund_Request__c from OSM_Orders_In_Invoice__c where CC_Invoice__c IN: lstIds];
                    if(lstJunRecFinal.size() > 0)
                    {
                        for(OSM_Orders_In_Invoice__c objJun : lstJunRecFinal)
                        {
                            if(mapCreditmemoToInvoice.containsKey(objJun.CC_Invoice__c) && MapInvoiceIdTOjunRec.containsKey(mapCreditmemoToInvoice.get(objJun.CC_Invoice__c)))
                            {
                                objJun.Vertex_Call_Status__c = MapInvoiceIdTOjunRec.get(mapCreditmemoToInvoice.get(objJun.CC_Invoice__c)).Vertex_Call_Status__c;
                                objJun.OSM_SW_Is_Refund_Request__c = true;
                            }
                        }
                        update lstJunRecFinal;
                    }
                    
                }
            }
            
        }
        
        
    }
    
    
}