global class OSM_SW_OrderConfCntrl {
  public Contact c{get;set;}
  Public String surl{get;set;}
  Public String currentUSer{get;set;}
  
  global OSM_SW_OrderConfCntrl()
  {
      List<User> uList = [SELECT Id,Profile.Name FROM User WHERE Id=: UserInfo.getUserId()];
      if(uList != null && uList.size()>0)
      {
          currentUSer = uList[0].Profile.Name;
      }
      surl = Label.OSM_Assign_User_Link; 
      if(currentUSer == 'System Administrator')
      {
          surl = Label.OSM_Assign_User_Link; 
      }
      else
      {
          c = new contact();
          List<contact> conList = new List<contact>();
          conList = [SELECT Id,AccountId,LastViewedDate FROM Contact WHERE LastViewedDate !=null ORDER BY LastViewedDate DESC limit 1];
          if(conList != null && conList.size()>0)
          {
              surl = System.URL.getSalesforceBaseUrl()+'/'+ conList[0].AccountId+'';
              //[delegate=https://cumminscss--eidmtst--ccrz.visualforce.com]0013C000008MzsqQAC
              surl = surl.replace('[delegate=', '').replace(']','').replace('Url:','');  
              //surl = surl.replace('[delegate=', '').replace(']',''); 
          }
      }
    
      
     /* String cartIds = ccrz.cc_CallContext.currCartId;
      ccrz__E_Cart__c carts = [select id,ccrz__TotalAmount__c,ccrz__EncryptedId__c,(SELECT id,OSM_Group_Name__c,ccrz__Product__c,ccrz__Quantity__c FROM ccrz__E_CartItems__r where ccrz__cartItemType__c!='Minor') from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartIds];
      List<ccrz__E_CartItem__c> cartItems = carts.ccrz__E_CartItems__r;
*/
      
  }
  //MP-668 Code Start 
  public static PageReference savePdf(ID parentId) {
      PageReference pdf = Page.PdfGeneratorTemplate;
       pdf.getParameters().put('id',parentId);
      Attachment attach = new Attachment();
      Blob body;
      try {
          body = pdf.getContent();
      } catch (VisualforceException e) {
          body = Blob.valueOf('Some Text');
      }
      attach.Body = body;
      attach.Name = 'CCInterCompanyInvoice.pdf';
      attach.IsPrivate = false;
      attach.ParentId = parentId;
      insert attach;
      return new PageReference('/'+parentId);
    }
  @RemoteAction
  global static ccrz.cc_RemoteActionResult callInterCompanyPDF(ccrz.cc_RemoteActionContext ctx, String pageUrl) {
      ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
      ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
      String orderId = pageUrl.substring(pageUrl.indexOf('?o=')+3,pageUrl.indexOf('&portalUser'));
      try{
          orderObj = [Select Id,Name,ccrz__EncryptedId__c from ccrz__E_Order__c where ccrz__EncryptedId__c =: orderId];
          List<ccrz__E_Invoice__c> listInvoics = new List<ccrz__E_Invoice__c>(); 
          listInvoics =[Select id,Name,Original_Sales_Order__c,OSM_SW_IsIntercompanyInvoice__c from ccrz__E_Invoice__c where Original_Sales_Order__c =:orderObj.id];
          for(ccrz__E_Invoice__c inv:listInvoics){
              system.debug('inv---->>>'+inv);
              savePdf(inv.id);
          }
      }
      Catch(Exception ex) {
          System.debug(ex);
      }
      res.success = true;
      return res;       
  }// MP-668 Code End
   @RemoteAction
  global static ccrz.cc_RemoteActionResult addShippingAddress(ccrz.cc_RemoteActionContext ctx,String pageUrl){
      ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
      String storefront = ccrz.cc_CallContext.storefront;
      String accId;
      if(!Test.isRunningTest()){
      accId = ccrz.cc_CallContext.effAccountId;
      }
      result.success = false;
       result.inputContext = ctx;
      Map<String,Object> returnMap = new Map<String,Object>();
      
      //Account acc =[select id, name, (select id,ccrz__EncryptedId__c from  ccrz__E_Orders__r)  from account where id = :ctx.effAccountId];
      ccrz__E_Order__c order = new ccrz__E_Order__c();
      String orderId = pageUrl.substring(pageUrl.indexOf('?o=')+3,pageUrl.indexOf('&portalUser'));
      try{
         order = [select id,ccrz__EncryptedId__c,ccrz__ShipTo__c,ccrz__OriginatedCart__r.ccrz__EncryptedId__c,ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c,ccrz__OriginatedCart__r.Third_Party_BMS_Customer_ID__c,ccrz__OriginatedCart__r.OSM_SW_Is_third_Party_BMS_Payment__c,ccrz__OriginatedCart__r.Third_Party_BMS_Customer_Name__c,(SELECT ID,ccrz__Subscription_End_Date__c,ccrz__Product__c,ccrz__Product__r.Name,ccrz__DisplayProduct__c from ccrz__E_OrderItems__r) from ccrz__E_Order__c where ccrz__EncryptedId__c = :orderId];
         /* if(acc.ccrz__E_Orders__r.size() == 1){
          
          ccrz__E_ContactAddr__c address = new ccrz__E_ContactAddr__c();
          address.id = order.ccrz__ShipTo__c;
          address.Account__c = acc.id;
          upsert address;
          ccrz__E_AccountAddressBook__c accAdd = new ccrz__E_AccountAddressBook__c();
          accAdd.ccrz__AccountId__c = acc.id;
          accAdd.ccrz__Account__c = acc.id;
          accAdd.ccrz__E_ContactAddress__c = address.id;
          accAdd.ccrz__AddressType__c = 'Shipping';
          insert accAdd;
      }*/
          Account acc = new Account();
          if(order.ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c != Null){
              acc =[select id, name,IAM_Service_Provider_Code__c From Account where id =:order.ccrz__OriginatedCart__r.OSM_SW_IAM_Account_Id_For_Third_Party__c];
          }
         
         if(order.ccrz__OriginatedCart__r.OSM_SW_Is_third_Party_BMS_Payment__c){
                  returnMap.put('isthirdpartypayment',true);
                  returnMap.put('thirdpartycustname',order.ccrz__OriginatedCart__r.Third_Party_BMS_Customer_Name__c);
                  returnMap.put('thirdpartycustnum',order.ccrz__OriginatedCart__r.Third_Party_BMS_Customer_ID__c);
                  returnMap.put('thirdpartyIAMNO',acc.IAM_Service_Provider_Code__c);
                  
          }else{
                 returnMap.put('isthirdpartypayment',false);
          }
          /* added by swetha MP-430*/
          /*
        List<ccrz__E_OrderItem__c> orderitems = new List<ccrz__E_OrderItem__c>();
        orderitems =  order.ccrz__E_OrderItems__r;
        System.debug('orderitems-->'+orderitems);
         Map<id,ccrz__E_CartItem__c> idcartmap = new Map<id,ccrz__E_CartItem__c>();  
        ccrz__E_Cart__c carts = [select id, ccrz__EncryptedId__c,(select id,ccrz__Product__c,Subscription_Expiry_Date__c,ccrz__Product__r.Group_Name__c from ccrz__E_CartItems__r) from ccrz__E_Cart__c where ccrz__EncryptedId__c=:order.ccrz__OriginatedCart__r.ccrz__EncryptedId__c];
        List<ccrz__E_CartItem__c> cartItems ;
          if(carts.ccrz__E_CartItems__r.size() >0){
            cartItems =carts.ccrz__E_CartItems__r;  
          }
        for(ccrz__E_CartItem__c cartit:cartItems){
             idcartmap.put(cartit.ccrz__Product__c,cartit);
          }
         system.debug('idcartmap-->'+idcartmap);
         for(ccrz__E_OrderItem__c ord: orderitems){
               if(!ord.ccrz__Product__r.Name.contains('INCAL')){
                   if(idcartmap.containskey(ord.ccrz__Product__c)){
                    ord.ccrz__Subscription_End_Date__c = idcartmap.get(ord.ccrz__Product__c).Subscription_Expiry_Date__c;
                      system.debug('ord.ccrz__Subscription_End_Date__c-->'+ord.ccrz__Subscription_End_Date__c);
                 } 
               }
         }
        
        update orderitems;
*/
          /*
        system.debug('orderitemids-->'+orderitemids);
        system.debug('idordermap-->'+idordermap);
        system.debug('productids-->'+productids);
        system.debug('idordermap-->'+idordermap);
        
      
          List<String> substatus = new List<String>{'Active','Renew'};
           List<ccrz__E_Subscription__c> activeSubs = [SELECT OSM_Display_Product__c, ccrz__SubscriptionProduct__c,
                                                          OSM_Subscription_End_Date__c
                                                          FROM ccrz__E_Subscription__c
                                                          where OSM_Display_Product__c in :productids 
                                                          and ccrz__Storefront__c =: storefront
                                                         and ccrz__SubscriptionStatus__c in :substatus
                                                          and ccrz__Account__c =:  accId order by OSM_Subscription_End_Date__c desc];
          system.debug('activeSubs-->'+activeSubs);
          Map<id,ccrz__E_Subscription__c> idsubmap = new Map<id,ccrz__E_Subscription__c>();
          for(ccrz__E_Subscription__c subs:activeSubs){
             idsubmap.put(subs.OSM_Display_Product__c,subs);
          }

         
           for(ccrz__E_OrderItem__c ord: orderitems){
               if(!ord.ccrz__Product__r.Name.contains('INCAL')){
                   ccrz__E_Subscription__c susbsitem = idsubmap.get(ord.ccrz__DisplayProduct__c); 
                  ord.ccrz__Subscription_End_Date__c = susbsitem.OSM_Subscription_End_Date__c.date();
                   system.debug('sub-->'+susbsitem);
             system.debug('sub.OSM_Subscription_End_Date__c-->'+susbsitem.OSM_Subscription_End_Date__c);
             system.debug('subenddate-->'+ ord.ccrz__Subscription_End_Date__c);
               }
             
             
          }
          
        System.debug('orderitems-->'+orderitems);
        update orderitems;
          */
        /*END MP-430*/  
        result.data = returnMap;
        result.success = true;
       }catch(exception ex){
          system.debug('Error Message'+ex.getMessage());
           CMI_SW_CartTaxWrapper objWrpr1 = new CMI_SW_CartTaxWrapper();
          objWrpr1.isError = true;
          objWrpr1.errorMsg = ex.getMessage();
          returnMap.put('ErrorMsgOrder',objWrpr1);
          result.data = returnMap;
          result.success = false;
       }
     return result;
  }
  
 
  
}