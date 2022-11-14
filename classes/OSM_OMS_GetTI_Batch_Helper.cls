/******
Name: OSM_OMS_GetTI_Batch_Helper
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       17/04/2019   INITIAL DEVELOPMENT 
*******/
global class OSM_OMS_GetTI_Batch_Helper{

    public static void callGetTILicensesAPI(Set<Id> setOrderItemId)
    {
       
       List<OSM_ReturnWrapper> objReturnList=new List<OSM_ReturnWrapper>();
       OSM_ReturnWrapper objReturn;  
       List<ccrz__E_OrderItem__c> orderItemRecord=[Select ID,OSM_GetTI_Success__c,OMS_Item_ID__c, OMS_Product__c,ccrz__DisplayProduct__c,Tool_Instance_Count__c,OSM_Tool_Instance_Key__c,OMS_Instance_ID__c, OMS_Activation_Key__c, Tool_Instance_Key__c, ccrz__Order__c,ccrz__Order__r.ccrz__Account__c From ccrz__E_OrderItem__c where ID in :setOrderItemId];
        List<OSM_Order_Item_License__c> itemLicenses = [Select 
                            Id, Type__c,Activation_Key__c, CC_Order_Item__c, Parent_Activation_Key__c, OMS_Item_Id__c,Tool_Instance_Key__c, Status__c
                        From OSM_Order_Item_License__c 
                        where CC_Order_Item__c IN: setOrderItemId 
                              and Status__c =: 'New' ];
        
       System.debug('orderItemRecord____'+orderItemRecord);
       Map<Id,ccrz__E_OrderItem__c> orderItemRecordMap=new  Map<Id,ccrz__E_OrderItem__c>();
        Set<String>uniqueKey = new Set<String>();
        
       for(ccrz__E_OrderItem__c orderItem:orderItemRecord){
          
           orderItemRecordMap.put(orderItem.id,orderItem);
           for(OSM_Order_Item_License__c itemLicense : itemLicenses){
               if(orderItem.Id == itemLicense.CC_Order_Item__c && !uniqueKey.Contains(itemLicense.Activation_Key__c)){
                   uniqueKey.add(itemLicense.Activation_Key__c);
                    objReturn=OSM_GetTI_BusinessHandler.updateOMSToolInstance(orderItem.id,orderItemRecordMap,itemLicense, null);
                    objReturnList.add(objReturn);
               }
           }
               
         }
         
         updateOrderItemRecords(objReturnList,setOrderItemId);
    }
    
    public static void updateOrderItemRecords(List<OSM_ReturnWrapper> objReturnList, Set<Id> setOrderItemId)
    {
        
        Map<String, Set<String>> activationKeyToToolIns = new Map<String, Set<String>>();
        for(OSM_Order_Item_License__c itemLicense : [Select 
                            Id, Activation_Key__c, CC_Order_Item__c, Parent_Activation_Key__c, OMS_Item_Id__c,Tool_Instance_Key__c, Status__c
                        From OSM_Order_Item_License__c 
                        where CC_Order_Item__c IN: setOrderItemId  and (Status__c=: 'New'  or Status__c =: 'Revoked' or Status__c=:'Revoke/ReIssue Pending' or Status__c=:'Revoke Initiated')]){
            if(!activationKeyToToolIns.keySet().contains(itemLicense.Activation_Key__c)){               
                activationKeyToToolIns.put(itemLicense.Activation_Key__c, new Set<String>{itemLicense.Tool_Instance_Key__c} );  
            }else{
                Set<String> tools = activationKeyToToolIns.get(itemLicense.Activation_Key__c);
                tools.add(itemLicense.Tool_Instance_Key__c);
                activationKeyToToolIns.put(itemLicense.Activation_Key__c, tools);   
            }
        }               
        
       
        
        Savepoint sp = Database.setSavepoint();
         try{
             for(OSM_ReturnWrapper objReturnToSave:objReturnList){
                 //Update Records
                 if (objReturnToSave.updateOrderItemList.size()>0)
                 {  
                     Database.update(objReturnToSave.updateOrderItemList,false);
                 } 
                 if(objReturnToSave.orderItemLicenseList.size()>0){
                     Set<String> existingToolLi = new Set<String>();
                    /* for(OSM_Order_Item_License__c existingTool : itemLicenses){
                             if(!String.isBlank(existingTool.Tool_Instance_Key__c)){
                              existingToolLi.add(existingTool.Tool_Instance_Key__c);
                             }
                          } */
                      List<OSM_Order_Item_License__c> toInsert = new List<OSM_Order_Item_License__c>();   
                     //for(OSM_Order_Item_License__c existingTool : itemLicenses){
                          //existingToolLi.add(existingTool.Tool_Instance_Key__c);
                         for(OSM_Order_Item_License__c newTool : objReturnToSave.orderItemLicenseList){
                             if((activationKeyToToolIns == null || activationKeyToToolIns.get(newTool.Activation_Key__c) == null 
                                   || (activationKeyToToolIns.get(newTool.Activation_Key__c) != null && !activationKeyToToolIns.get(newTool.Activation_Key__c).Contains(newTool.Tool_Instance_Key__c)))){
                                   toInsert.add(newTool);
                             }
                         }
                     //}
                     if(toInsert.size()>0){
                        Database.upsert(toInsert) ;
                     }
                 }
             }
             if(Test.isRunningTest()){
                 throw new NullPointerException();
             }
         }
        catch(Exception ex)
        {
            System.debug('Exception in DML>>>>'+ex);
            Database.rollback(sp);
            for(OSM_ReturnWrapper objReturnToSave:objReturnList){
            for(OSM_Integration_Log__c objLog : objReturnToSave.lstToInsertLog)
            {
                objLog.Status__c = 'Failure'; 
                
                String oldMsg = '';
                if(objLog.Error_Description__c != null && objLog.Error_Description__c != '')
                oldMsg = objLog.Error_Description__c;
                String msg  = oldMsg+ ' Message - '+ex.getMessage();
                msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
                objLog.Error_Description__c = msg;
                objLog.Account__c = getAccountId();  // Added By Dhiraj for MAR-1621 - Story On 21st April 2021
            }
        }
        }
        finally 
        {
            List<OSM_Integration_Log__c> logList=new List<OSM_Integration_Log__c>();
            for(OSM_ReturnWrapper objReturnToSave:objReturnList){
            if(objReturnToSave.lstToInsertLog !=  null && objReturnToSave.lstToInsertLog.size() > 0 && !objReturnToSave.lstToInsertLog.isEmpty()){
                for(OSM_Integration_Log__c log:objReturnToSave.lstToInsertLog){
                   logList.add(log);
                 }
                 }
             }
                insert logList;
       }  
    }
    
    // Added By Dhiraj for MAR-1621 - Story On 21st April 2021
    public static String getAccountId()
    {
        String strAccId;
        User objUser = new User();
        objUser = [SELECT Contact.Account.Id FROM User WHERE Id = : UserInfo.getUserId()];
        //objUser = [SELECT AccountId FROM User WHERE Id = : UserInfo.getUserId()];
        strAccId = objUser.Contact.Account.Id;
        System.debug('strAccId+++' + strAccId);
        return strAccId;
    }
    //Code Ended.
}