/************************************************************
Name:  OSM_Email_InvoiceForBoltEntry_Ctrl
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
1.0 -   Sharad Sahu         24/12/2018     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_Email_InvoiceForBoltEntry_Ctrl {


    global Id invoiceId {get;}
    global Set<String> orderNumbers{get;set;}
    List<Id> lstOrderItemIds = new List<Id>();
    List<OerderLineItemDetail> lstsubLineItems{get;set;}
    global List<ccrz__E_ProductMedia__c> mediaList {get;set;}
    
    global OSM_Email_InvoiceForBoltEntry_Ctrl() {
        
        orderNumbers = new Set<String>();
        lstsubLineItems = new List<OerderLineItemDetail>(); 

        
    }
    
    global void setInvoiceId(String IdInvoice)
    {
        System.debug('----Inside setInvoiceId-----'+IdInvoice);
        if(IdInvoice!=null && IdInvoice!='')
        {
            
            //List<OSM_Integration_Log__c> objLog = [select Id,Invoice__c from OSM_Integration_Log__c where Id =: IdInvoice ];
            
            
            List<OSM_Orders_In_Invoice__c> orderinInvoices = new List<OSM_Orders_In_Invoice__c>();
            //if(objLog != null && objLog.size() > 0 && objLog[0].Invoice__c != null )
                orderinInvoices = [select id,name,CC_Order__r.Name from OSM_Orders_In_Invoice__c where CC_Invoice__c =: IdInvoice ];
            
            
            if(orderinInvoices != null && orderinInvoices.size() > 0)
            {
                for(OSM_Orders_In_Invoice__c objOrderInvoice : orderinInvoices)
                {
                    orderNumbers.add(objOrderInvoice.CC_Order__r.Name);
                    
                }
                
                
                List<OSM_InvoiceLine_And_OrderLine__c> lstItem = new List<OSM_InvoiceLine_And_OrderLine__c>();
                lstItem = [select Id,CC_Order_Item__c from OSM_InvoiceLine_And_OrderLine__c where OSM_Orders_In_Invoice__c IN: orderinInvoices];
                
                for(OSM_InvoiceLine_And_OrderLine__c obj : lstItem)
                    lstOrderItemIds.add(obj.CC_Order_Item__c);
            }
            
            fetchOrderDetailInfo(lstOrderItemIds);
            
        }
    }
    
    global Set<String> getOrderNumbers(){
       
       return orderNumbers;
    }
      
    
    public void fetchOrderDetailInfo(List<Id> orderItemId)
    {
        set<String> productIds = new Set<String>();
        
        list<ccrz__E_OrderItem__c> OrderItemList = new list<ccrz__E_OrderItem__c>();
        
        try{
        OrderItemList = [select id,Vertex_Tax__c,ccrz__DisplayProduct__c,ccrz__OriginalQuantity__c,ccrz__DisplayProduct__r.ccrz__ShortDesc__c,ccrz__DisplayProduct__r.name,ccrz__Product__r.name,ccrz__Quantity__c,ccrz__Price__c,ccrz__ItemTotal__c,ccrz__ExtSKU__c,ccrz__Order__c from ccrz__E_OrderItem__c where Id IN: orderItemId];
        
        for(ccrz__E_OrderItem__c orditem : OrderItemList){
            productIds.add(orditem.ccrz__DisplayProduct__c);
        }
        List<ccrz__E_ProductMedia__c> mediaList  = [select id,ccrz__MediaType__c, ccrz__Product__c,(SELECT Id, Name, ParentId FROM Attachments) from ccrz__E_ProductMedia__c where ccrz__Product__c IN: productIds and ccrz__MediaType__c = 'Product Image Thumbnail'];
          for(ccrz__E_OrderItem__c orditem : OrderItemList){
            
            OerderLineItemDetail lineItem = new OerderLineItemDetail();
            lineItem.Quantity = orditem.ccrz__OriginalQuantity__c;
            lineItem.name = orditem.ccrz__DisplayProduct__r.name;
            lineItem.price = orditem.ccrz__Price__c;
            lineItem.Total = orditem.ccrz__ItemTotal__c + orditem.Vertex_Tax__c;
            lineItem.tax = orditem.Vertex_Tax__c;
            lineItem.shortDec = orditem.ccrz__DisplayProduct__r.ccrz__ShortDesc__c;         
            for(ccrz__E_ProductMedia__c media : mediaList){
              if(orditem.ccrz__DisplayProduct__c == media.ccrz__Product__c){     
                    for(attachment a:media.attachments) {
                    lineItem.uri = a.id;
                    lineItem.imageUrl = label.OSM_DEV_URL+'/servlet/servlet.FileDownload?file='+a.id;
                 }
                }
            }
            
            lstsubLineItems.add(lineItem);
            
          }
          }catch(exception ex){system.debug(ex+'===>'+ex.getLineNumber());}
         //return lstLineItems;
    
    
    }
    
    
    
    global List<OerderLineItemDetail> getOrderItemList ()
    {
        return lstsubLineItems;
    }
//*****End******

 global Boolean isSandbox() {
    return URL.getSalesforceBaseUrl().getHost().left(2).equalsignorecase('cs');
}

global OerderLineItemDetail orderLineItem {get;set;}

  global Class OerderLineItemDetail{
       global string name { get; set; }
       global string uri { get; set; }
       global string imageUrl { get; set; }
       global Decimal Quantity{get;set;}
       global string shortDec{get;set;}
       global Decimal Price {get;set;}
       global Decimal Total{get;set;}
       global Decimal tax{get;set;}
  }
}