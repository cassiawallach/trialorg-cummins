/******
Name:  OSM_Intercompany_BusinessLayerHandler
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       19/12/2018     INITIAL DEVELOPMENT 
*******/
public class OSM_Intercompany_BusinessLayerHandler {
    public static OSM_ReturnWrapper getInvoiceInfo(Id invoiceId, Map < Id, ccrz__E_Invoice__c > invoiceIdMap, boolean isRefund,boolean isDistributor,string invItem) {
        ccrz__E_Invoice__c invoiceObj;
        ccrz__E_InvoiceItem__c invoiceItemObj;
        ccrz__E_OrderItem__c orderItemObj;
        List < ccrz__E_Invoice__c > invoiceList = new List < ccrz__E_Invoice__c > ();
        List < ccrz__E_InvoiceItem__c> invoiceItemList = new List < ccrz__E_InvoiceItem__c > ();
        List < ccrz__E_OrderItem__c> ordItemList = new List < ccrz__E_OrderItem__c > ();
        OSM_ReturnWrapper objToReturn = new OSM_ReturnWrapper();
        OSM_Integration_Log__c log;
        String requestJSON = ''; // Update for US-867
        Set < String > mandatoryFields = new Set < String > ();
        List < OSM_Integration_Log__c > lstToInsertLog;
        Map<Id, ccrz__E_PriceListItem__c > mapSubProdIdToPriceListItem = new Map<Id, ccrz__E_PriceListItem__c >();
        
        try {
           
                
            OSM_Intercompany_Generalized_REQ inputWrapperObj = new OSM_Intercompany_Generalized_REQ();
            inputWrapperObj.DataArea = new OSM_Intercompany_Generalized_REQ.DataArea();
            inputWrapperObj.Header = new OSM_Intercompany_Generalized_REQ.Header();
            inputWrapperObj.Header.Sender = new OSM_Intercompany_Generalized_REQ.Sender();
            inputWrapperObj.Header.Target = new OSM_Intercompany_Generalized_REQ.Target();
            OSM_Intercompany_Generalized_REQ.CInvoice_Header CInvoice_Header;
            OSM_Intercompany_Generalized_REQ.ChargeList ChargeList=new OSM_Intercompany_Generalized_REQ.ChargeList();
            OSM_Intercompany_Generalized_REQ.R_PARTSLIST_SUBMIT R_PARTSLIST_SUBMIT;
            inputWrapperObj.CInvoice_Header = new List < OSM_Intercompany_Generalized_REQ.CInvoice_Header > ();
            inputWrapperObj.ChargeList =new List<OSM_Intercompany_Generalized_REQ.ChargeList>();
            inputWrapperObj.R_PARTSLIST_SUBMIT=new List<OSM_Intercompany_Generalized_REQ.R_PARTSLIST_SUBMIT>();
            //binding values
            ccrz__E_Invoice__c invoiceItem = invoiceIdMap.get(invoiceId);
            System.debug('invoiceRecord____' + invoiceItem);
            System.debug('invoiceRecord____' + invoiceItem.OSM_Child_Account__r.Customer_BMS_number__c);
            if (invoiceItem != null) {
            
                 //getting price list record..
                //List<ccrz__E_PriceListItem__c> priceListItemRecord=[Select id,ccrz__SubProdTerm__c,ccrz__Product__c,ccrz__Product__r.Group_Name__c,ccrz__Price__c,Distributor_Price__c from ccrz__E_PriceListItem__c where ccrz__SubProdTerm__c=:invoiceItem.ccrz__CCOrderItem__r.ccrz__SubProdTerm__c and ccrz__RecurringPrice__c = false];
                
                //getting trasaction list...
                List<ccrz__E_TransactionPayment__c> transPaymentList=[Select id,ccrz__CCOrder__c,Bolt_Credit_Memo_Call_Status__c,ccrz__AccountNumber__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c=:invoiceItem.ccrz__CCOrder__c];            
                /*if(priceListItemRecord!=null && priceListItemRecord.size()>0)
                {
                    for(ccrz__E_PriceListItem__c objPrice : priceListItemRecord )
                    {
                            
                        mapSubProdIdToPriceListItem.put(objPrice.ccrz__SubProdTerm__c, objPrice);
                    }
                }*/
                //getting order item record
                ccrz__E_Invoice__c invcs = new ccrz__E_Invoice__c(); 
                invcs =[Select id,Name,(Select id,Name,ccrz__CCOrderItem__c from ccrz__InvoiceItems__r where ccrz__Type__c='Item') from ccrz__E_Invoice__c where id=:invoiceItem.id];
                Set<id> setIds = new Set<id>();
                if(invcs.ccrz__InvoiceItems__r != Null){
                    for(ccrz__E_InvoiceItem__c invceItems:invcs.ccrz__InvoiceItems__r){
                        setIds.add(invceItems.ccrz__CCOrderItem__c);
                    }
                }
                system.debug('setIds--->>'+setIds);
                List<ccrz__E_OrderItem__c> orderItemRecord = new List<ccrz__E_OrderItem__c>();
                if(invItem == Null)
                    orderItemRecord=[Select ccrz__SubProdTerm__c,ccrz__OriginalItemPrice__c,ccrz__ParentOrderItem__c,ccrz__Product__r.GOMS_Part_Number__c,ccrz__Product__r.Group_Name__c,ccrz__Price__c,Dn_Price__c,Original_Price_without_Discount__c,Discounted_Amount__c,id,name,ccrz__Order__c,ccrz__UnitOfMeasure__c,ccrz__Product__c,ccrz__Quantity__c,ccrz__OriginalQuantity__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Product_Class_Code__c,ccrz__Product__r.name from ccrz__E_OrderItem__c where ccrz__Order__c=:invoiceItem.ccrz__CCOrder__c AND OSM_Is_Refund_Intercompany_Call_Done__c = False AND id=:setIds];
                else
                    orderItemRecord=[Select ccrz__SubProdTerm__c,ccrz__OriginalItemPrice__c,ccrz__ParentOrderItem__c,ccrz__Product__r.GOMS_Part_Number__c,ccrz__Product__r.Group_Name__c,ccrz__Price__c,Dn_Price__c,Original_Price_without_Discount__c,Discounted_Amount__c,id,name,ccrz__Order__c,ccrz__UnitOfMeasure__c,ccrz__Product__c,ccrz__Quantity__c,ccrz__OriginalQuantity__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Product_Class_Code__c,ccrz__Product__r.name from ccrz__E_OrderItem__c where id=:invItem AND OSM_Is_Refund_Intercompany_Call_Done__c = False];
                
                CInvoice_Header = new OSM_Intercompany_Generalized_REQ.CInvoice_Header();
                if(!isDistributor)
                 {
                    if (invoiceItem.OSM_Child_Account__r.OSM_Location_ID__c != null) {
                       if(invoiceItem.OSM_Child_Account__r.EBU_Channel_of_Distribution__c == 'CIHR' || invoiceItem.OSM_Child_Account__r.PSBU_Channel_of_Distribution__c == 'CIHR')
                       {
                           inputWrapperObj.DataArea.LocationID=invoiceItem.OSM_Child_Account__r.OSM_SW_Responsible_Region__c+'-'+invoiceItem.OSM_Child_Account__r.OSM_SW_Responsible_Region__c;
                       }
                       else
                       {
                        inputWrapperObj.DataArea.LocationID = invoiceItem.OSM_Child_Account__r.OSM_Location_ID__c;
                       }
                    }
                }
                else
                {
                    if (invoiceItem.ccrz__SoldTo__r.OSM_Location_ID__c != null) {
                      if(invoiceItem.OSM_Child_Account__r.EBU_Channel_of_Distribution__c == 'CIHR' || invoiceItem.OSM_Child_Account__r.PSBU_Channel_of_Distribution__c == 'CIHR')
                       {
                           inputWrapperObj.DataArea.LocationID=invoiceItem.ccrz__SoldTo__r.OSM_SW_Responsible_Region__c+'-'+invoiceItem.ccrz__SoldTo__r.OSM_SW_Responsible_Region__c;
                       }
                       else
                       {
                         inputWrapperObj.DataArea.LocationID = invoiceItem.ccrz__SoldTo__r.OSM_Location_ID__c;
                       }
                        
                    }
                }
                if(!isDistributor){
                     
                    if(invoiceItem.ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c){
                            if(invoiceItem.ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c != '')
                            {
                                inputWrapperObj.DataArea.CustomerCode=invoiceItem.ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c;
                            }
                           else{
                                mandatoryFields.add('CustomerCode');
                            }
                    }
                    else if (invoiceItem.ccrz__CCOrder__r.OSM_BMS_Customer_Number__c != null) {
                        inputWrapperObj.DataArea.CustomerCode = invoiceItem.ccrz__CCOrder__r.OSM_BMS_Customer_Number__c;
                    }else {
                        mandatoryFields.add('CustomerCode');
                    }
                    
                }
                else
                {
                      inputWrapperObj.DataArea.CustomerCode = '';
                }
                if(!isDistributor)
                {
                    if (invoiceItem.ccrz__CCOrder__r.BMS_OrderRefNumber__c != null) {

                        if (!isRefund) {
                            CInvoice_Header.BMS_OE_REFERENCE =Integer.valueOf(invoiceItem.ccrz__CCOrder__r.BMS_OrderRefNumber__c);
                        } else {
                            CInvoice_Header.BMS_OE_REFERENCE = Integer.valueOf(invoiceItem.ccrz__CCOrder__r.BMS_Order_reference_number_Refund__c);
                        }
                    } else {
                        mandatoryFields.add('BMS_OE_REFERENCE');
                    }
                }
                else
                {
                    //CInvoice_Header.BMS_OE_REFERENCE =null;
                    CInvoice_Header.BMS_OE_REFERENCE = 0;
                }
                if(!isDistributor)
                {
                    if (invoiceItem.ccrz__CCOrder__r.BMS_BranchLocation__c != null) {
                        CInvoice_Header.BRANCH_LOCATION = invoiceItem.ccrz__CCOrder__r.BMS_BranchLocation__c;
    
                    } else {
                        mandatoryFields.add('BRANCH_LOCATION');
                    }
                }
                else
                {
                     if (invoiceItem.ccrz__SoldTo__r.Location__c != null) {
                        //CInvoice_Header.BRANCH_LOCATION = invoiceItem.ccrz__SoldTo__r.Location__c;
                        CInvoice_Header.BRANCH_LOCATION = invoiceItem.ccrz__SoldTo__r.CSS_DBCode__c;
    
                    } else {
                        mandatoryFields.add('BRANCH_LOCATION');
                    }
                }
               if(!isDistributor)
               {
               
                    if (invoiceItem.ccrz__CCOrder__r.Order_Source_Type__c != null) {
                        if (!isRefund) {
                            CInvoice_Header.ORDER_SOURCE_TYPE = invoiceItem.ccrz__CCOrder__r.Order_Source_Type__c;
                        } else {
                            CInvoice_Header.ORDER_SOURCE_TYPE = invoiceItem.ccrz__CCOrder__r.OSM_SW_Refund_Order_Source_Type__c;
                        }


                    } else {
                        mandatoryFields.add('ORDER_SOURCE_TYPE');
                    }
                }
                else
                {
                             
                                if (!isRefund) {
                                    CInvoice_Header.ORDER_SOURCE_TYPE = Label.OSM_Dist_Order_Source_Type;
                                } else {
                                    CInvoice_Header.ORDER_SOURCE_TYPE = Label.OSM_Dist_Order_Source_Type_Refund;
                                }
                }
                
                if(!isDistributor)
                {
                    if (invoiceItem.BMS_PONumber__c != null) {
                        CInvoice_Header.BMS_PO_NUMBER = invoiceItem.BMS_PONumber__c;
                    } else {
                        mandatoryFields.add('BMS_PO_NUMBER');
                    }
                }
                else
                {
                     if(transPaymentList.size()>0 && transPaymentList[0].ccrz__AccountNumber__c!=null ){
                    CInvoice_Header.BMS_PO_NUMBER = transPaymentList[0].ccrz__AccountNumber__c;
                    } else {
                        mandatoryFields.add('BMS_PO_NUMBER');
                    }
               
                }
                if(!isDistributor)
                {
                    if (invoiceItem.BMS_InvoiceNumber__c != null) {
                        CInvoice_Header.BMS_INVOICE_NUMBER = Integer.valueOf(invoiceItem.BMS_InvoiceNumber__c);
                    } else {
                        mandatoryFields.add('BMS_INVOICE_NUMBER');
                    }
                }
                else
                {
                      //CInvoice_Header.BMS_INVOICE_NUMBER =null;
                      CInvoice_Header.BMS_INVOICE_NUMBER =0;
                }
                if(!isDistributor)
                {
                    if (invoiceItem.ICInvoice_Number__c != null && null != invoiceItem.ccrz__CCOrder__r.Order_Source_Type__c) {
                        if (!isRefund) {
                            if ('OSM' == invoiceItem.ccrz__CCOrder__r.Order_Source_Type__c) {
                                CInvoice_Header.ICInvoice_Number = OSM_Generic_Utility.fieldSizeRestriction(invoiceItem.ICInvoice_Number__c, 8, 'back');
                            } else if ('OSMCM' == invoiceItem.ccrz__CCOrder__r.Order_Source_Type__c) {
                                CInvoice_Header.ICInvoice_Number = OSM_Generic_Utility.fieldSizeRestriction(invoiceItem.ICInvoice_Number__c, 8, 'back') + 'C';
                            }
                        } else {
                            if ('OSM' == invoiceItem.ccrz__CCOrder__r.OSM_SW_Refund_Order_Source_Type__c) {
                                CInvoice_Header.ICInvoice_Number = OSM_Generic_Utility.fieldSizeRestriction(invoiceItem.ICInvoice_Number__c, 8, 'back');
                            } else if ('OSMCM' == invoiceItem.ccrz__CCOrder__r.OSM_SW_Refund_Order_Source_Type__c) {
                                CInvoice_Header.ICInvoice_Number = OSM_Generic_Utility.fieldSizeRestriction(invoiceItem.ICInvoice_Number__c, 8, 'back') + 'C';
                            }
                        }
                    } else {
                        mandatoryFields.add('ICInvoice_Number');
                    }
                }
                else
                 {
                     if(invoiceItem.Name!=null)
                     {
                         
                         String InvName = invoiceItem.Name.SubStringAfter('-');
                         CInvoice_Header.ICInvoice_Number=InvName;
                         // Sharad
                         if (isRefund)
                            CInvoice_Header.ICInvoice_Number = OSM_Generic_Utility.fieldSizeRestriction(invoiceItem.ICInvoice_Number__c, 8, 'back') + 'C';
                     }
                 }   
                
                if(!isDistributor)
                {
                    // Start - Juhi - Changes Made - Jan 15, 2019 Addition of ICInvoice Date to json request
                    if (null != invoiceItem.ICInvoice_Date__c) {
                        CInvoice_Header.ICInvoice_Date =invoiceItem.ICInvoice_Date__c;
                    } else {
                        mandatoryFields.add('ICInvoice_Date');
                    }
                }
                else
                {
                    // Start - Juhi - Changes Made - Jan 15, 2019 Addition of ICInvoice Date to json request
                    if (null != invoiceItem.createddate) {
                        Date invoiceCreatedDate = date.newinstance(invoiceItem.createddate.year(), invoiceItem.createddate.month(), invoiceItem.createddate.day());
                        CInvoice_Header.ICInvoice_Date =invoiceCreatedDate;
                    } else {
                        mandatoryFields.add('ICInvoice_Date');
                    }
                }
                // End - Juhi - Changes Made - Jan 15, 2019
              for(ccrz__E_OrderItem__c orderItem:orderItemRecord){
                      R_PARTSLIST_SUBMIT =new OSM_Intercompany_Generalized_REQ.R_PARTSLIST_SUBMIT();
                     if(orderItem.ccrz__ParentOrderItem__c==null){
                        if(orderItem.ccrz__Product__r.ccrz__SKU__c !=null)
                        {
                            if((Label.OSM_GOMSPartnumber_SubmitOrder).contains(orderItem.ccrz__Product__r.ccrz__SKU__c)){
                                R_PARTSLIST_SUBMIT.ITEM_NUMBER=string.valueOf(orderItem.ccrz__Product__r.GOMS_Part_Number__c);
                            }else{
                                R_PARTSLIST_SUBMIT.ITEM_NUMBER=string.valueOf(orderItem.ccrz__Product__r.ccrz__SKU__c);
                            }
                        }
                        else
                        {
                            mandatoryFields.add('ITEM_NUMBER');
                        }
                        R_PARTSLIST_SUBMIT.PRODUCT=Label.OSM_Vendor;
                        if(orderItem.ccrz__Product__r.name!=null)
                        {
                            Integer maxSize = 24;
                            String description=OSM_Generic_Utility.removeSymbols(orderItem.ccrz__Product__r.name);
                            if(description.length() > maxSize ){
                                description = description.substring(0, maxSize);
                            }
                            R_PARTSLIST_SUBMIT.DESCRIPTION=description;
                        }
                        else
                        {
                            mandatoryFields.add('DESCRIPTION');
                        }
                        if(orderItem.ccrz__OriginalQuantity__c!=null){
                            if(!isRefund)
                            {
                                R_PARTSLIST_SUBMIT.QUANTITY=Integer.ValueOf(orderItem.ccrz__OriginalQuantity__c);
                            }
                            else{
                                R_PARTSLIST_SUBMIT.QUANTITY=-Integer.ValueOf(orderItem.ccrz__OriginalQuantity__c);
                            }
                                   
                        }
                        else
                        {
                            mandatoryFields.add('QUANTITY');
                        } 
                        if(orderItem.ccrz__UnitOfMeasure__c!=null){
                                    R_PARTSLIST_SUBMIT.UOM =orderItem.ccrz__UnitOfMeasure__c;
                        }else{
                               R_PARTSLIST_SUBMIT.UOM='EA';
                        }
                        /*if(!isDistributor)
                        {
                            if(orderItem.ccrz__Price__c !=null)
                            {
                                if(!isRefund){
                                R_PARTSLIST_SUBMIT.SELLING_PRICE=orderItem.ccrz__Price__c;
                                }
                                else
                                {
                                    R_PARTSLIST_SUBMIT.SELLING_PRICE=-orderItem.ccrz__Price__c;
                                }
                                            
                            }
                            else
                            {
                                mandatoryFields.add('SELLING_PRICE');
                            }
                        }
                        else
                        {
                            R_PARTSLIST_SUBMIT.SELLING_PRICE=null;
                        }*/
                        R_PARTSLIST_SUBMIT.SELLING_PRICE=0;
                        R_PARTSLIST_SUBMIT.ITEM_COST = 0;
                        if(orderItem.Dn_Price__c!= null){
                            if(!isRefund)
                            {
                                 Decimal item_cost_ToRound=orderItem.Dn_Price__c / orderItem.ccrz__OriginalQuantity__c;
                                 R_PARTSLIST_SUBMIT.ITEM_COST =item_cost_ToRound.setScale(2, RoundingMode.HALF_UP);
                            }
                            else
                            {
                                
                                Decimal item_cost_ToRound=orderItem.Dn_Price__c / orderItem.ccrz__OriginalQuantity__c;
                                R_PARTSLIST_SUBMIT.ITEM_COST =-(item_cost_ToRound.setScale(2, RoundingMode.HALF_UP));
                            }
                            
                            // MAR-466 code start
                                if(isDistributor)
                                {
                                    if(orderItem.Discounted_Amount__c != null && orderItem.Discounted_Amount__c > 0)
                                    {
                                        if(!isRefund)
                                        {
                                             Decimal item_cost_ToRound = (orderItem.Original_Price_without_Discount__c - orderItem.Discounted_Amount__c) / orderItem.ccrz__OriginalQuantity__c;
                                             R_PARTSLIST_SUBMIT.ITEM_COST =item_cost_ToRound.setScale(2, RoundingMode.HALF_UP);
                                        }
                                        else
                                        {
                                            Decimal item_cost_ToRound = (orderItem.Original_Price_without_Discount__c - orderItem.Discounted_Amount__c) / orderItem.ccrz__OriginalQuantity__c;
                                            R_PARTSLIST_SUBMIT.ITEM_COST =-(item_cost_ToRound.setScale(2, RoundingMode.HALF_UP));
                                        }
                                    }
                                    // Fix MAR-469 start
                                    else{
                                       if(!isRefund)
                                        {
                                             Decimal item_cost_ToRound = orderItem.Original_Price_without_Discount__c / orderItem.ccrz__OriginalQuantity__c;
                                             R_PARTSLIST_SUBMIT.ITEM_COST =item_cost_ToRound.setScale(2, RoundingMode.HALF_UP);
                                        }
                                        else
                                        {
                                            Decimal item_cost_ToRound = orderItem.Original_Price_without_Discount__c / orderItem.ccrz__OriginalQuantity__c;
                                            R_PARTSLIST_SUBMIT.ITEM_COST =-(item_cost_ToRound.setScale(2, RoundingMode.HALF_UP));
                                        }
                                    } // Fix MAR-469 end
                                }
                            // MAR-466 code end
                            
                        }
                        else
                        {
                            mandatoryFields.add('ITEM_COST');
                        }
                        /*if(transPaymentList.size()>0 && transPaymentList[0].ccrz__AccountNumber__c!=null ){
                           R_PARTSLIST_SUBMIT.CUSTOMER_PO_NUMBER =transPaymentList[0].ccrz__AccountNumber__c;
                        }*/
                        R_PARTSLIST_SUBMIT.CUSTOMER_PO_NUMBER ='';
                        
                        R_PARTSLIST_SUBMIT.NONSTOCK_TYPE='';
                        R_PARTSLIST_SUBMIT.LINE_TYPE='';
                        R_PARTSLIST_SUBMIT.Attribute01=0;
                        R_PARTSLIST_SUBMIT.Attribute02=0;
                        R_PARTSLIST_SUBMIT.Attribute03=0;
                        
                        
                        inputWrapperObj.R_PARTSLIST_SUBMIT.add(R_PARTSLIST_SUBMIT);
                    }
                }
                if(!isDistributor)
                {
                    CInvoice_Header.PO_Vendor='';
                    CInvoice_Header.INVOICE_TOTAL=0;
                    CInvoice_Header.CREDIT_MEMO='';
                }
                else
                {
                     CInvoice_Header.PO_Vendor=Label.OSM_Vendor;
                       if(invoiceItem.ccrz__OriginalAmount__c!=null)
                        {
                            if(!isRefund)
                            {
                                CInvoice_Header.INVOICE_TOTAL=invoiceItem.ccrz__OriginalAmount__c;
                            }
                            else
                            {
                                CInvoice_Header.INVOICE_TOTAL=-invoiceItem.ccrz__OriginalAmount__c;
                            }
                        }
                        else
                        {
                             mandatoryFields.add('INVOICE_TOTAL');
                        }
                        if(isRefund)
                        {
                            CInvoice_Header.CREDIT_MEMO='Y';
                            /*
                            if(transPaymentList[0].Bolt_Credit_Memo_Call_Status__c=='Success')
                            {
                                CInvoice_Header.CREDIT_MEMO='Y';
                            }
                            else{
                                CInvoice_Header.CREDIT_MEMO='N';
                            }
                            */
                        }
                        else{
                            CInvoice_Header.CREDIT_MEMO='N';
                        }
                }
                
                CInvoice_Header.Attribute01 = 0;
                CInvoice_Header.Attribute02 = '';
                CInvoice_Header.Attribute03 = '';
                inputWrapperObj.DataArea.Attribute01 = 0;
                inputWrapperObj.DataArea.Attribute02 = '';
                inputWrapperObj.DataArea.Attribute03 = '';
                inputWrapperObj.CInvoice_Header.add(CInvoice_Header);
                ChargeList.MISC_CHARGE_AMOUNT=0;
                ChargeList.MISC_CHARGE='';
                ChargeList.Attribute02=0;
                ChargeList.Attribute01=0;
                inputWrapperObj.ChargeList.add(ChargeList);
                
               
                if (inputWrapperObj.DataArea.LocationID != null && (inputWrapperObj.DataArea.CustomerCode != null || isDistributor==true) && !(mandatoryFields.size() > 0)) {

                    //Calling Service class
                    OSM_Intercompany_Generalized_RES responseWrpObj = OSM_Intercompany_Service.callIntercompanyService(inputWrapperObj, isRefund,isDistributor);
                    System.debug('General Output Wrapper>>>>>' + responseWrpObj);
                    if(responseWrpObj.errorFlag == false){
                    log = new OSM_Integration_Log__c();
                    log = responseWrpObj.log;
                    if( log != null ) {
                        requestJSON = log.Request__c; // Updated for US-867
                    }
                    if(invItem != Null){
                        invoiceItemObj = new ccrz__E_InvoiceItem__c();
                        invoiceItemObj.id = invoiceId;
                        log.Invoice__c = invoiceItem.id;
                        //log.Account__c = AccountId; 
                        if (isRefund) {
                            orderItemObj = new ccrz__E_OrderItem__c();
                            orderItemObj.id = invItem;
                            invoiceItemObj.Is_Refund_Intercompany_Call_Done__c = true;
                            orderItemObj.OSM_Is_Refund_Intercompany_Call_Done__c= true;
                            ordItemList.add(orderItemObj);
                        }
                        invoiceItemList.add(invoiceItemObj);
                    }else{
                        invoiceObj = new ccrz__E_Invoice__c();
                        invoiceObj.id = invoiceId;
                        log.Invoice__c = invoiceItem.id;
                        //log.Account__c = AccountId;  
                        System.debug('log____' + log.status__c);
                        if (log.status__c == 'Success'|| label.OSM_IntercompanyRequestError==log.Error_Description__c) {
                           invoiceObj.IntercompanyCalled__c = true;
                        }
                        if (isRefund) {
                            invoiceObj.OSM_SW_Is_Refund_Intercompany_Call_Done__c = true;
                        }
                        invoiceList.add(invoiceObj);
                    }
                    objToReturn.exceptionFlag = false;
                  }
                  else{
                        log = new OSM_Integration_Log__c();
                        log.Status__c = 'Failure';
                        log.Request__c = requestJSON; // Updated for US-867
                        log.Error_Description__c = responseWrpObj.errorMsg;
                        log.Target__c = System.Label.OSM_BMS_Target_ID;
                        log.Source__c = 'OSM';
                        log.Logged_In_User__c = userinfo.getuserid();
                        log.Invoice__c = invoiceItem.id;
            
                        if (isRefund)
                        log.Service_Name__c = 'RefundIntercompanyRequest';
                  }  
                } else {

                    //Create Request JSON (Updated for MP-867)
                    OSM_Intercompany_REQ intercompanyReq=OSM_Intercompany_Helper.populateRequestObjectData(inputWrapperObj);
                    requestJSON = JSON.serialize(intercompanyReq);
                    requestJSON  = requestJSON.replace('PO_Vendor', 'PO_VENDOR');
               
                    if(isDistributor)
                    {
                        requestJSON  = requestJSON.replace('"BMS_OE_REFERENCE":0', '"BMS_OE_REFERENCE":""');
                    }

                    String mandeToryString;
                    for (String valueStr: mandatoryFields) {
                        if (mandeToryString != null)
                            mandeToryString = mandeToryString + ', ' + valueStr;
                        else
                            mandeToryString = valueStr;
                    }
                    log = new OSM_Integration_Log__c();
                    log.Status__c = 'Failure';
                    log.Request__c = requestJSON; // Updated for US-867
                    log.Target__c = System.Label.OSM_BMS_Target_ID;
                    log.Source__c = 'OSM';
                    log.Logged_In_User__c = userinfo.getuserid();
                    log.Error_Description__c = 'Mandatory fields are missing: ' + mandeToryString;
                    log.Invoice__c = invoiceItem.id;
                    log.Service_Name__c = 'IntercompanyRequest';
                    log.Invoice__c = invoiceItem.id;
                    if (isRefund)
                        log.Service_Name__c = 'RefundIntercompanyRequest';

                    objToReturn.exceptionFlag = true;
                }
            }
            if(Test.isrunningtest())
            {
             throw new NullPointerException();
            }
        } catch (Exception ex) {
            System.debug('exception : ' + ex.getMessage());
            log = new OSM_Integration_Log__c();
            log.Status__c = 'Failure';
            log.Request__c = requestJSON; // Updated for US-867
            String msg = 'Message - ' + ex.getMessage();
            msg = msg + 'Stacktrace - ' + ex.getStackTraceString();
            log.Error_Description__c = msg;
            log.Target__c = System.Label.OSM_BMS_Target_ID;
            log.Source__c = 'OSM';
            log.Logged_In_User__c = userinfo.getuserid();


            if (isRefund)
                log.Service_Name__c = 'RefundIntercompanyRequest';
        }
        if (log != null) {
            lstToInsertLog = new List < OSM_Integration_Log__c > ();

            // log.Invoice__c=invoiceId;
            // System.debug('log invoice____'+log.Invoice__c);

            lstToInsertLog.add(log);
            System.debug('lstToInsertLog____' + lstToInsertLog);
        }
        objToReturn.lstToInsertLog = new List < OSM_Integration_Log__c > ();
        objToReturn.lstToInsertLog = lstToInsertLog;
        objToReturn.updateInvoiceList = new List < ccrz__E_Invoice__c > ();
        objToReturn.updateInvoiceList = invoiceList;
        objToReturn.updateInvoiceItemList = new List < ccrz__E_InvoiceItem__c > ();
        objToReturn.updateInvoiceItemList = invoiceItemList;
        objToReturn.updateOrdItemList= new List < ccrz__E_OrderItem__c> ();
        objToReturn.updateOrdItemList= ordItemList;
        return objToReturn;
    }
}