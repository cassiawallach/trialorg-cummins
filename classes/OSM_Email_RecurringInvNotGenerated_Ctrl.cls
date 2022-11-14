/************************************************************
Name:  OSM_Email_RecurringInvNotGenerated_Ctrl
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Email Template data handler class 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad Sahu         26/03/2019     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_Email_RecurringInvNotGenerated_Ctrl {


    global Id logId {get;}
    List<Id> lstOrderItemIds = new List<Id>();
    List<LineItemDetail> lstLineItems{get;set;}
    global List<ccrz__E_ProductMedia__c> mediaList {get;set;}
    
    global OSM_Email_RecurringInvNotGenerated_Ctrl() {
        lstLineItems = new List<LineItemDetail>();
    }
    
    global void setLogId(String logId)
    {
        System.debug('----Inside setLogId-----'+logId);
        if(logId!=null && logId!='')
        {
            try
            {
               List<OSM_Integration_Log__c> objLogList =  new List<OSM_Integration_Log__c>();
               objLogList = [select Id,Request__c from OSM_Integration_Log__c where Id =: logId ];
                
                Map<Id, LineItemDetail> mapSubIdToLineItemDetail = new Map<Id, LineItemDetail>();
                
                
                if(objLogList != null && objLogList.size() > 0)
                {
                
                    List<Object> cObjMap = (List<Object>) JSON.deserializeUntyped(objLogList[0].Request__c);
                    System.debug(cObjMap);
                    for(Object obj : cObjMap)
                    {
                        System.debug('Lines');
                        Map<String, Object> newObj = (Map<String, Object>)obj;
                        
                        LineItemDetail objcls = new LineItemDetail();
                        objcls.Quantity = Integer.valueOf(newObj.get('quantity'));
                        objcls.price = ((Decimal)newObj.get('price'))/objcls.Quantity;
                        objcls.Total = (Decimal)newObj.get('price');
                        
                        mapSubIdToLineItemDetail.put((String)newObj.get('subscription'), objcls);
                    }
                    
                    if(mapSubIdToLineItemDetail != null && mapSubIdToLineItemDetail.size() > 0)
                    {
                        
                        Map<Id,ccrz__E_Subscription__c> mapSubsc = new Map<Id,ccrz__E_Subscription__c>();
                        Map<Id,ccrz__E_ProductMedia__c> mapProductToMedia = new Map<Id,ccrz__E_ProductMedia__c>();
                        
                        mapSubsc.putAll([Select Id, OSM_Display_Product__c, OSM_Display_Product__r.ccrz__ShortDesc__c, OSM_Display_Product__r.name from ccrz__E_Subscription__c where Id IN: mapSubIdToLineItemDetail.keySet()]);
                        if(mapSubsc != null && mapSubsc.size() > 0 )
                        {
                            List<Id> productIds = new List<Id>();
                            
                            for(ccrz__E_Subscription__c objSub : mapSubsc.values())
                            {
                                productIds.add(objSub.OSM_Display_Product__c);
                            }
                            
                            List<ccrz__E_ProductMedia__c> mediaList  = [select id,ccrz__MediaType__c, ccrz__Product__c,(SELECT Id, Name, ParentId FROM Attachments) from ccrz__E_ProductMedia__c where ccrz__Product__c IN: productIds and ccrz__MediaType__c = 'Product Image Thumbnail'];
                            
                            for(ccrz__E_ProductMedia__c objMedia : mediaList)
                            {
                                mapProductToMedia.put(objMedia.ccrz__Product__c, objMedia);
                            }
                            
                            for(String key :  mapSubIdToLineItemDetail.keySet())
                            {
                                if(mapSubsc.containsKey(key) && mapProductToMedia.containsKey(mapSubsc.get(key).OSM_Display_Product__c))
                                {
                                    mapSubIdToLineItemDetail.get(key).name = mapSubsc.get(key).OSM_Display_Product__r.name;
                                    mapSubIdToLineItemDetail.get(key).shortDec = mapSubsc.get(key).OSM_Display_Product__r.ccrz__ShortDesc__c;
                                    for(attachment a : mapProductToMedia.get(mapSubsc.get(key).OSM_Display_Product__c).attachments) {
                                        mapSubIdToLineItemDetail.get(key).uri = a.id;
                                        mapSubIdToLineItemDetail.get(key).imageUrl = label.OSM_DEV_URL+'/servlet/servlet.FileDownload?file='+a.id;
                                    }
                                    
                                }
                            }
                            
                        }
                        
                        for(String key :  mapSubIdToLineItemDetail.keySet())
                        {
                            lstLineItems.add(mapSubIdToLineItemDetail.get(key));
                        }
                        
                    }
                }
            }catch(exception ex){system.debug(ex+'===>'+ex.getLineNumber());}
        }
        
    }
    
      
    
    global List<LineItemDetail> getItemList()
    {
        return lstLineItems;
    }

    global Boolean isSandbox() {
        return URL.getSalesforceBaseUrl().getHost().left(2).equalsignorecase('cs');
    }

  global Class LineItemDetail{
       global string name { get; set; }
       global string uri { get; set; }
       global string imageUrl { get; set; }
       global Decimal Quantity{get;set;}
       global string shortDec{get;set;}
       global Decimal Price {get;set;}
       global Decimal Total{get;set;}
  }
}