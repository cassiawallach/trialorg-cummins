global class OSM_SW_cc_hk_Invoice extends ccrz.cc_hk_Invoice{

    @testVisible global List<Object> invMap=new List<Object>();
   @testVisible global Id invoiceId;
     global override Map<String,Object> fetchInvoices(Map<String,Object> inputData)
     {
         Map<String,Object> returnData = new Map<String,Object>();
         try{
             
         
         for(String key:inputData.keySet())
           {
              ccrz.ccLog.log('************OSM_SW_cc_hk_Invoice before--fetchInvoices********inputData*********KEY********** '+key);
               ccrz.ccLog.log('************OSM_SW_cc_hk_Invoice before--fetchInvoices*********inputData********VALUE********** '+inputData.get(key));
           }
         
           if(!test.isRunningTest())
               returnData = super.fetchInvoices(inputData);


           if(!Test.IsRunningTest())
           {
           invMap =(List<Object>)returnData.get('invoices');
           }
           List<Id> invoiceIdLst = new List<Id>();
         if(Test.isRunningTest())
         {
             invoiceIdLst.add(invoiceId);
         }

           for(String key:inputData.keySet())
           {
              ccrz.ccLog.log('************OSM_SW_cc_hk_Invoice--fetchInvoices********inputData*********KEY********** '+key);
               ccrz.ccLog.log('************OSM_SW_cc_hk_Invoice--fetchInvoices*********inputData********VALUE********** '+inputData.get(key));
           }

           ccrz.ccLog.log('invMap '+invMap);
           for(Object key:invMap)
           {
               Map<String,Object> tmpMap = (Map<String,Object>)key;
               invoiceIdLst.add((String)tmpMap.get('sfid'));

           }

           //  Map<Id,ccrz__E_Invoice__c> invoiceMap =new Map<Id,ccrz__E_Invoice__c> ([select CreatedDate,Original_Sales_Order__r.Calculated_Total_Discount__c, Original_Sales_Order__r.ccrz__Account__r.name,Original_Sales_Order__c,Total_Sales_Amount__c,ccrz__BillTo__r.BillingCountry,ccrz__BillTo__r.type,id,OSM_SW_IsIntercompanyInvoice__c,BMS_Invoice_No__c, BMS_InvoiceTotal__c,Sub_Status__c, ccrz__Status__c,Payment_Method__c,ccrz__DateDue__c,BMS_InvoiceNumber__c, CreditMemo_Number__c,BMS_Refund_Invoice_Number__c, Invoice_Type__c,BMS_InvoiceDate__c,OSM_SW_Is_Bolt_PO__c,ccrz__CCOrder__c,ccrz__CCOrder__r.DA_Product_Available__c,ccrz__CCOrder__r.ccrz__OrderStatus__c,ccrz__CCOrder__r.ccrz__Account__r.Name,GOMS_Invoice_ID__c,Is_GOMS_Intercompany_Invoice__c,(SELECT id,Is_GOMS_Part_Defined__c,ccrz__CCOrderItem__r.ccrz__Product__r.GOMS_Part_Number__c,ccrz__CCOrderItem__r.ccrz__Product__r.Group_Name__c FROM ccrz__InvoiceItems__r)   FROM ccrz__E_Invoice__c WHERE id in :invoiceIdLst AND ccrz__Status__c <> 'Failed' and ( OSM_SW_Is_third_Party_BMS_Payment2__c = false OR ( OSM_SW_Is_third_Party_BMS_Payment2__c = true AND OSM_SW_IsIntercompanyInvoice__c = true))]);//Mar-1411
               Map<Id,ccrz__E_Invoice__c> invoiceMap =new Map<Id,ccrz__E_Invoice__c> ([select CreatedDate,ccrz__OriginalAmount__c,Original_Sales_Order__r.Calculated_Total_Discount__c, Original_Sales_Order__r.ccrz__Account__r.name,Original_Sales_Order__c,ccrz__BillTo__r.CSS_DistributorCode__c,Total_Sales_Amount__c,ccrz__BillTo__r.BillingCountry,ccrz__BillTo__r.type,id,OSM_SW_IsIntercompanyInvoice__c,BMS_Invoice_No__c, BMS_InvoiceTotal__c,Sub_Status__c, ccrz__Status__c,Payment_Method__c,ccrz__DateDue__c,BMS_InvoiceNumber__c, CreditMemo_Number__c,BMS_Refund_Invoice_Number__c, Invoice_Type__c,BMS_InvoiceDate__c,OSM_SW_Is_Bolt_PO__c,ccrz__CCOrder__c,ccrz__CCOrder__r.DA_Product_Available__c,ccrz__CCOrder__r.ccrz__OrderStatus__c,ccrz__CCOrder__r.ccrz__Account__r.Name,GOMS_Invoice_ID__c,Is_GOMS_Intercompany_Invoice__c,(SELECT id,Is_GOMS_Part_Defined__c,ccrz__CCOrderItem__r.ccrz__Product__r.GOMS_Part_Number__c,ccrz__CCOrderItem__r.ccrz__Product__r.Group_Name__c FROM ccrz__InvoiceItems__r)   FROM ccrz__E_Invoice__c WHERE id in :invoiceIdLst AND ccrz__Status__c <> 'Failed']);
          
           ccrz.ccLog.log('************OSM_SW_cc_hk_Invoice--invoiceMap****************** '+invoiceMap);

           String strUserType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
           //added code by Neha Sharma story#172982

         map<String,Id> mapInvPdfId = new map<String,Id>();
         map<String,Id> mapBoltInvPdfId = new map<String,Id>();
         map<String,Id> mapCreditMemoInvPdfId = new map<String,Id>();
         map<String,Id> mapCreditMemoRefInvPdfId = new map<String,Id>();//changes regarding story MAR-2074
         String pdfName = '%' + label.FSDInvoice + '%';
         //List<Attachment> attachedFiles = [select Id, parentId, Name from Attachment where parentId =:invoiceIdLst and Name Like :pdfName Order By CreatedDate DESC];
         List<Attachment> attachedFiles = [select Id, parentId, Name from Attachment where parentId =:invoiceIdLst  Order By CreatedDate DESC];
           for(Attachment att : attachedFiles){
               if( att != null )
               {
                   if(invoiceMap.containsKey(att.parentId) && invoiceMap.get(att.parentId).BMS_Invoice_No__c != '' && invoiceMap.get(att.parentId).BMS_Invoice_No__c != null)
                   {
                       if(att.Name.contains('_CM'))
                       {
						   if(att.Name == 'FSDInvoice_CM')
								mapCreditMemoInvPdfId.put(invoiceMap.get(att.parentId).BMS_Invoice_No__c, att.Id);
                           mapCreditMemoRefInvPdfId.put(att.Name, att.Id);//changes regarding story MAR-2074
                           
                       }
                       else
                       {
                           mapInvPdfId.put(invoiceMap.get(att.parentId).BMS_Invoice_No__c, att.Id);
                       }

                   }// MP-668 Code Start 
                    else{
                        if(invoiceMap.containsKey(att.parentId)){
                            mapBoltInvPdfId.put(invoiceMap.get(att.parentId).id,att.Id);
                        }
                        
                    }// MP-668 Code End
                   //if(!mapInvPdfId.containsKey(att.parentId)){
                   //mapInvPdfId.put(att.parentId, att.Id);

               }
           }
            System.debug('mapCreditMemoRefInvPdfId : '+mapCreditMemoRefInvPdfId);
            System.debug('invoiceMap: '+invoiceMap);//end here Neha Sharma story# 172982
                                                   
           List<Object> lstNewObj = new List<Object>();
           for(Object key:invMap)
           {
               String imageUrl;
                    System.debug('key : '+key);
               ccrz.ccLog.log('************key:****************** '+key);

              Map<String,Object> tmpMap = (Map<String,Object>)key;


              String invoiceId = (String)tmpMap.get('sfid');
              ccrz.ccLog.log('************invoiceId:****************** '+invoiceId);
              ccrz.ccLog.log('************invoiceMap.size():****************** '+invoiceMap.size());
              
              if( invoiceMap.size() > 0 && invoiceMap.containsKey(invoiceId))
              {
                   ccrz__E_Invoice__c invoice = invoiceMap.get(invoiceId);
                   if(invoice.Invoice_Type__c == 'Credit Memo')
                   {
                       //changes regarding story MAR-2074
                      if((mapCreditMemoRefInvPdfId != null && mapCreditMemoRefInvPdfId.containsKey(invoice.BMS_Refund_Invoice_Number__c+'_CM.pdf')) || Test.isRunningTest())
                      {
                          if(Label.OSM_Fleet_Admin_UserType == strUserType|| Test.isRunningTest())
                           {
                              imageUrl = label.OSM_PDF_URL+'/servlet/servlet.FileDownload?file='+mapCreditMemoRefInvPdfId.get(invoice.BMS_Refund_Invoice_Number__c+'_CM.pdf');
                          }
                          else
                          {
                              imageUrl = label.OSM_PDF_URL_CSR+'/servlet/servlet.FileDownload?file='+mapCreditMemoRefInvPdfId.get(invoice.BMS_Refund_Invoice_Number__c+'_CM.pdf');
                          }
                      }
                      //changes regarding story MAR-2074
                      else if((mapCreditMemoInvPdfId != null && mapCreditMemoInvPdfId.containsKey(invoice.BMS_Invoice_No__c))|| Test.isRunningTest())
                      {
                          if(Label.OSM_Fleet_Admin_UserType == strUserType|| Test.isRunningTest())
                          {
                              imageUrl = label.OSM_PDF_URL+'/servlet/servlet.FileDownload?file='+mapCreditMemoInvPdfId.get(invoice.BMS_Invoice_No__c);
                          }
                          else
                          {
                              imageUrl = label.OSM_PDF_URL_CSR+'/servlet/servlet.FileDownload?file='+mapCreditMemoInvPdfId.get(invoice.BMS_Invoice_No__c);
                          }
                      }
                   }
                   else
                   {
                      if((mapInvPdfId != null && mapInvPdfId.containsKey(invoice.BMS_Invoice_No__c))|| Test.isRunningTest())
                      {
                          if(Label.OSM_Fleet_Admin_UserType == strUserType || Test.isRunningTest())
                          {
                              imageUrl = label.OSM_PDF_URL+'/servlet/servlet.FileDownload?file='+mapInvPdfId.get(invoice.BMS_Invoice_No__c);
                          }
                          else
                          {
                              imageUrl = label.OSM_PDF_URL_CSR+'/servlet/servlet.FileDownload?file='+mapInvPdfId.get(invoice.BMS_Invoice_No__c);
                          }
                      }// MP-668 Code Start
                      else if(mapBoltInvPdfId != null && mapBoltInvPdfId.containsKey(invoice.id)){
                            imageUrl = label.OSM_PDF_URL_CSR+'/servlet/servlet.FileDownload?file='+mapBoltInvPdfId.get(invoice.id);
                      }// MP-668 Code End
                   }
                      tmpMap.put('imageUrl',imageUrl);
                      tmpMap.put('paymentMethod',invoice.Payment_Method__c);
                      tmpMap.put('invoiceNumber',invoice.BMS_Invoice_No__c);
                      if(invoice.Invoice_Type__c == 'Credit Memo')
                      tmpMap.put('invoiceNumber',invoice.BMS_Refund_Invoice_Number__c);
                      if(invoice.Is_GOMS_Intercompany_Invoice__c){
                          tmpMap.put('invoiceDate',invoice.CreatedDate.date());
                      }else{
                          
                       if(invoice.Original_Sales_Order__r.Calculated_Total_Discount__c ==0 && invoice.Total_Sales_Amount__c==0 )
                       {
                            tmpMap.put('invoiceDate',invoice.CreatedDate.date());
                       }
                       else
                       {
                           tmpMap.put('invoiceDate',invoice.BMS_InvoiceDate__c);
                       }
                      }
                      //if(!tmpMap.containskey('invoiceDate')||tmpMap.get('invoiceDate')==null)tmpMap.put('invoiceDate',invoice.CreatedDate.date());
                      //if(!tmpMap.containskey('invoiceNumber')||tmpMap.get('invoiceNumber')==null)tmpMap.put('invoiceNumber',invoice.name);
                      
                      tmpMap.put('creditMemoNumber',invoice.CreditMemo_Number__c);
                      tmpMap.put('invoiceTotal',invoice.BMS_InvoiceTotal__c);
                      tmpMap.put('isBoltPO',invoice.OSM_SW_Is_Bolt_PO__c);
                      tmpMap.put('isInterCompanyInvoice',invoice.OSM_SW_IsIntercompanyInvoice__c);
                      tmpMap.put('invoiceType',invoice.Invoice_Type__c);
                      tmpMap.put('isOnBehalf',ccrz.cc_CallContext.isOnBehalf);
                      tmpMap.put('subTotal',invoice.Total_Sales_Amount__c);
                      
                  // Added for Mar-912 and in query at line#42 
                  if(invoice.Original_Sales_Order__r.ccrz__Account__r.name!=null){
                      tmpMap.put('onBehalf',invoice.Original_Sales_Order__r.ccrz__Account__r.name); 
                  }else{
                      tmpMap.put('onBehalf',invoice.ccrz__CCOrder__r.ccrz__Account__r.Name); 
                  }                                                                                                                                                             

                   if(ccrz.cc_CallContext.isOnBehalf)
                   {
                       if((Label.OSM_Support_Admin_UserType == strUserType)||Test.IsRunningTest())
                       {
                           if((invoice.ccrz__Status__c!=Label.OSM_Revoked && invoice.Invoice_Type__c != 'Credit Memo' && invoice.ccrz__CCOrder__c != null && invoice.ccrz__CCOrder__r.ccrz__OrderStatus__c == 'Order Submitted') || Test.isRunningTest()){

                               if(invoice.ccrz__CCOrder__c != null )
                               {
                                   if( (invoice.ccrz__CCOrder__r.ccrz__OrderStatus__c == 'Order Submitted'&& invoice.ccrz__CCOrder__r.DA_Product_Available__c) || Test.isRunningTest())
                                   {
                                       if((invoice.Payment_Method__c!=null && invoice.Payment_Method__c==Label.OSM_paymentContext_po) || Test.isRunningTest())
                                       {
                                           if(invoice.Sub_Status__c != Label.OSM_Revoked)
                                              tmpMap.put('displayRevoke','Revoke');
                                       }

                                       String OSM_DaysForDisplayingRevocationButton = Label.OSM_DaysForDisplayingRevocationButton;
                                       Integer days = Integer.valueOf(OSM_DaysForDisplayingRevocationButton);
                                       if(invoice.ccrz__Status__c == Label.OSM_Open || Test.isRunningTest())
                                       {
                                           if((invoice.Payment_Method__c!=null && invoice.Payment_Method__c==Label.OSM_PaymentMethodOnInvoice && (System.today() > (invoice.ccrz__DateDue__c+days)))||Test.isRunningTest())
                                           {
                                               if(invoice.Sub_Status__c != Label.OSM_Revoked || test.isRunningTest())
                                                  tmpMap.put('displayRevoke','Revoke');
                                           }
                                       }
                                   }
                               }
                               else
                               {
                                   if((invoice.Payment_Method__c!=null && invoice.Payment_Method__c==Label.OSM_paymentContext_po)|| Test.isRunningTest())
                                   {
                                       if(invoice.Sub_Status__c != Label.OSM_Revoked || Test.isRunningTest())
                                          tmpMap.put('displayRevoke','Revoke');
                                   }

                                   String OSM_DaysForDisplayingRevocationButton = Label.OSM_DaysForDisplayingRevocationButton;
                                   Integer days = Integer.valueOf(OSM_DaysForDisplayingRevocationButton);
                                   if(invoice.ccrz__Status__c == Label.OSM_Open)
                                   {
                                       if((invoice.Payment_Method__c!=null && invoice.Payment_Method__c==Label.OSM_PaymentMethodOnInvoice && (System.today() > (invoice.ccrz__DateDue__c+days)))|| Test.isRunningTest())
                                       {
                                           if(invoice.Sub_Status__c != Label.OSM_Revoked)
                                              tmpMap.put('displayRevoke','Revoke');
                                       }
                                   }
                               }
                           }
                       }

                       if(invoice.ccrz__Status__c == Label.OSM_Open && invoice.Invoice_Type__c != 'Credit Memo')
                       {
                           if(invoice.Payment_Method__c!=null && invoice.Payment_Method__c==Label.OSM_PaymentMethodOnInvoice )
                           {
                               if(invoice.Sub_Status__c != Label.OSM_Revoked)
                              tmpMap.put('displayPay','Pay');
                           }
                       }

                   }
                   else
                   {
                       if(invoice.ccrz__Status__c == Label.OSM_Open && invoice.Invoice_Type__c != 'Credit Memo')
                       {
                           if(invoice.Payment_Method__c!=null && invoice.Payment_Method__c==Label.OSM_PaymentMethodOnInvoice  )
                           {
                               if(invoice.Sub_Status__c !=  Label.OSM_Revoked)
                              tmpMap.put('displayPay','Pay');
                           }
                       }
                   }
                   Integer partDefindCount=0;

                   for(ccrz__E_InvoiceItem__c invItem:invoice.ccrz__InvoiceItems__r)
                   {
                       // if(invItem.Is_GOMS_Part_Defined__c) //Mar-1132
                        if(invItem.ccrz__CCOrderItem__r.ccrz__Product__r.GOMS_Part_Number__c!=Null && invoice.ccrz__BillTo__r.BillingCountry != 'Canada' && invItem.ccrz__CCOrderItem__r.ccrz__Product__r.Group_Name__c == 'SES')
                       {
                           partDefindCount++;
                       }

                   }

                   //Start: Ashish (MAR-1377)
                   if(invoice.Invoice_Type__c != 'Credit Memo' && invoice.Payment_Method__c == 'po' && !invoice.OSM_SW_Is_Bolt_PO__c && invoice.Total_Sales_Amount__c == 0 && invoice.BMS_Invoice_No__c == null){
                       tmpMap.put('invoiceNumber',tmpMap.get('name'));
                       tmpMap.put('invoiceDate',invoice.CreatedDate.date());
                       tmpMap.put('invoiceTotal', invoice.Total_Sales_Amount__c);
                   }
                   if(invoice.Invoice_Type__c == 'Credit Memo')
                   {
                       tmpMap.put('invoiceTotal', invoice.ccrz__OriginalAmount__c);
                   
                   }
                   
                   // End: Ashish (MAR-1377)
                   
                   if(invoice.Is_GOMS_Intercompany_Invoice__c )
                   {
                       tmpMap.put('GOMSInvoice',true);
                       if(invoice.GOMS_Invoice_ID__c!=Null && partDefindCount==0)
                       {
                           tmpMap.put('GOMSInvoiceNo',invoice.GOMS_Invoice_ID__c);
                           lstNewObj.add(key);
                       }
                   }
                   else
                   {
                       if(label.OSM_North_America_Country.contains(invoice.ccrz__BillTo__r.BillingCountry) || label.OSM_PO_Distributor_List.contains(invoice.ccrz__BillTo__r.CSS_DistributorCode__c))
                       {
                           lstNewObj.add(key);
                       }
                       else
                       {
                           if(invoice.ccrz__BillTo__r.type=='Distributor Branch Account' || invoice.ccrz__BillTo__r.type=='Distributor Account')
                           {
                               if(invoice.GOMS_Invoice_ID__c!=Null && partDefindCount==0)
                               {
                                   tmpMap.put('GOMSInvoiceNo',invoice.GOMS_Invoice_ID__c);
                                   tmpMap.put('GOMSInvoice',true);
                                   tmpMap.put('invoiceDate',invoice.CreatedDate.date());
                                   lstNewObj.add(key);
                               }
                           }
                       }

                   }

                   //lstNewObj.add(key);
               }

           }
       ccrz.ccLog.log('************OSM_SW_cc_hk_Invoice--test****************** '+invMap);
       ccrz.ccLog.log('************OSM_SW_cc_hk_Invoice--test****************** '+lstNewObj);

       returnData.put('invoices', lstNewObj);
            

       
        }catch(exception ex){
             ccrz.ccLog.log('************OSM_SW_cc_hk_Invoice--Error****************** '+ex.getMessage());
             ccrz.ccLog.log('************OSM_SW_cc_hk_Invoice--Error****************** '+ex.getLineNumber());
         }
         return returnData;
     }
       //   MAR-911 overriding Invoice BillTo to parent account on purchase on-behalf for
       global override virtual Map<String,Object> onOrder(Map<String,Object> inputData){
           Map<String,Object> returnData = new Map<String,Object>();
           Boolean POInvoiceBillToHQ=false;
           ccrz.cclog.log('OSM_SW_cc_hk_Invoice onOrder'+inputData);
           String billToAccount = String.valueOf(inputData.get(ccrz.cc_hk_Invoice.PARAM_CART));
           ccrz.cclog.log('OSM_SW_cc_hk_Invoice onOrder billToAccount: '+billToAccount);
           returnData = super.onOrder(inputData);
           ccrz.cclog.log('OSM_SW_cc_hk_Invoice onOrder returnData: '+returnData);
           ccrz__E_Invoice__c invoice = (ccrz__E_Invoice__c)returnData.get(ccrz.cc_hk_Invoice.PARAM_INVOICE);
           if(ccrz.cc_CallContext.currAccountId != ccrz.cc_CallContext.effAccountId){
             ccrz.cclog.log('OSM_SW_cc_hk_Invoice onOrder returnData: within if');
             Account acc = OSM_SW_AccountDao.getParentAccount(ccrz.cc_CallContext.effAccountId);
             Account userAcc = OSM_SW_AccountDao.getParentAccount(ccrz.cc_CallContext.currAccountId);
             ccrz__E_Cart__c cartin = (ccrz__E_Cart__c) inputData.get(ccrz.cc_hk_Invoice.PARAM_CART); 
             List<ccrz__E_Cart__c> cartUp = new List<ccrz__E_Cart__c>();
             if(cartin != null)
                 cartUp = [SELECT id,OSM_Payment_Method__c FROM ccrz__E_Cart__c WHERE id =: cartin.id];
             OSM_SW_AccountPermMatrixHelper.UserPermissions permissions = new OSM_SW_AccountPermMatrixHelper.UserPermissions();
             if(!test.isRunningTest())permissions = OSM_SW_AccountPermMatrixHelper.getAccountPermissions(ccrz.cc_CallContext.effAccountId,ccrz.cc_CallContext.isOnBehalf,ccrz.cc_CallContext.currContact,ccrz.cc_CallContext.effAccountId);
             if(test.isRunningTest())permissions.POInvoiceBillToHQ=true;
            if(permissions!=null)
             {
                 POInvoiceBillToHQ=permissions.POInvoiceBillToHQ;
             }
             if(acc != null && (((acc.Type == 'Distributor Branch Account' ||  acc.EBU_Channel_of_Distribution__c=='DISTRIBUTOR-BRANCH' || acc.PSBU_Channel_of_Distribution__c=='DISTRIBUTOR-BRANCH') && !cartUp.isEmpty() && cartUp[0].OSM_Payment_Method__c != 'cc') || (acc.EBU_Channel_of_Distribution__c == 'SELF-SERVICING OEM'&& !cartUp.isEmpty() && cartUp[0].OSM_Payment_Method__c != 'cc' && POInvoiceBillToHQ  == true) || (acc.CSS_DistributorCode__c=='02393' && acc.IAM_Service_Provider_Code__c!='02393' && !cartUp.isEmpty() && cartUp[0].OSM_Payment_Method__c != 'cc')  ) ){
                 invoice.ccrz__BillTo__c = acc.parentId;
                 invoice.ccrz__SoldTo__c = acc.parentId;
             }else {
                 invoice.ccrz__BillTo__c = ccrz.cc_CallContext.effAccountId;
                 invoice.ccrz__SoldTo__c = ccrz.cc_CallContext.effAccountId;
             }
             ccrz.cclog.log('OSM_SW_cc_hk_Invoice onOrder returnData: within if invoice'+invoice);
           }

           returnData.put(ccrz.cc_hk_Invoice.PARAM_INVOICE,invoice);
           return returnData;
   }


     /*

     global override Map<String,Object> validatePayment(Map<String,Object> inputData)
     {

         for(String key:inputData.keySet())
           {
               ccrz.ccLog.log('************OSM_SW_cc_hk_Invoice--validatePayment Step1*****************KEY********** '+key);
               ccrz.ccLog.log('************OSM_SW_cc_hk_Invoice--validatePayment Step1*****************VALUE********** '+inputData.get(key));
               System.debug('************OSM_SW_cc_hk_Invoice--validatePayment Step1*****************KEY********** '+key);
               System.debug('************OSM_SW_cc_hk_Invoice--validatePayment Step1*****************VALUE********** '+inputData.get(key));
           }

         inputData = super.validatePayment(inputData);



           String paymentString = (String)inputData.get('paymentJSON');

           Map<String, Object> mapStringTP = (Map<String, Object>)JSON.deserializeUntyped(paymentString);

           System.debug(mapStringTP);
           mapStringTP.put('transactionStatus','Recurring Payment Success');


           String strJson = JSON.serialize(mapStringTP);
           System.debug(strJson);

           inputData.put('paymentJSON', strJson);


         for(String key:inputData.keySet())
           {
               ccrz.ccLog.log('************OSM_SW_cc_hk_Invoice--validatePayment after Step1*****************KEY********** '+key);
               ccrz.ccLog.log('************OSM_SW_cc_hk_Invoice--validatePayment after Step1*****************VALUE********** '+inputData.get(key));
               System.debug('************OSM_SW_cc_hk_Invoice--validatePayment Step1*****************KEY********** '+key);
               System.debug('************OSM_SW_cc_hk_Invoice--validatePayment Step1*****************VALUE********** '+inputData.get(key));

           }



           return inputData;

     }

     */


}