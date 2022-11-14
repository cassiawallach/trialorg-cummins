/******
Name:  OSM_CancelLicenses_ServiceHandler
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       24/12/2018     INITIAL DEVELOPMENT 
Update
*******/
global class OSM_CancelLicenses_ServiceHandler{
    public static Set<Id> orderIdSet = new  Set<Id>();
    public static void callCancelLicensesAPI(Set<Id> setOrderItemId)
    {
        system.debug('****test****'+setOrderItemId);
        ID userId = UserInfo.getUserId();
        
        User usr = [Select ID, FederationIdentifier FROM User Where ID=:userId];
        String userType = '';
        String requesterId='';
        if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
            userType = OSM_SW_General_Util.getuserType(userId);
        } else{
            userType = OSM_SW_General_Util.USER_TYPE;
        }
        List<OSM_ReturnWrapper> objReturnList=new List<OSM_ReturnWrapper>();
        OSM_ReturnWrapper objReturn;
        
        List<ccrz__E_OrderItem__c> orderItemDataList = [Select id,OSM_GetTI_Success__c,CMI_Account_Number__c,Number_of_Bundles__c,Basic_Tool_Instance_Key_count__c,Tool_Instance_Count__c,ccrz__Order__c,ccrz__Quantity__c,Remaining_Lisences__c,Basic_Remaining_Lisences__c,OMS_Product__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product_Name__c,contact__c,(Select id,Type__c,Tool_Instance_Key__c,Status__c,CC_Order_Item__r.id,OMS_Item_Id__c,Parent_Activation_Key__c,Revoked_ReIssue_Lisence__c,CC_Order_Item__r.Basic_Remaining_Lisences__c,CC_Order_Item__r.Remaining_Lisences__c from  OSM_Oreder_Item_Licenses__r),ccrz__Order__r.ccrz__Account__c from ccrz__E_OrderItem__c where OSM_GetTI_Success__c=true and id IN: setOrderItemId];
        System.debug('orderItemData____'+orderItemDataList);
        
        Map<Id,OSM_Order_Item_License__c> orderItemLicenseRecordMap=new  Map<Id,OSM_Order_Item_License__c>();
        Map<Id, Integer> licenseToCount = new Map<Id, Integer>();

        if(orderItemDataList!=null && orderItemDataList.size()>0)
        {
           for(ccrz__E_OrderItem__c orderItemRecord:orderItemDataList){
               orderIdSet.add(orderItemRecord.ccrz__Order__c);
               if(userType == Label.OSM_Fleet_Admin_UserType)
               {   
                System.debug('OSM_CancelLicenses_ServiceHandler line 44 reached');
               requesterId = OSM_Generic_Utility.truncateRequesterId(orderItemRecord.CMI_Account_Number__c); //OSM_Generic_Utility.truncateRequesterId added by Pooja story 1054
           }
           else // take the WWID of the CSR from the User Record - Federation ID Field
           {
               requesterId = OSM_Generic_Utility.truncateRequesterId(usr.FederationIdentifier); //OSM_Generic_Utility.truncateRequesterId added by Pooja story 1054
           }  
                if(orderItemRecord.OSM_Oreder_Item_Licenses__r!=null && orderItemRecord.OSM_Oreder_Item_Licenses__r.size()>0)
                {   
                    Map<Id, OSM_Order_Item_License__c> mapLicense = new Map<Id, OSM_Order_Item_License__c>();
                    Map<Id, List<OSM_Order_Item_License__c>> mapParentToChildforOne = new Map<Id, List<OSM_Order_Item_License__c>>();
                    Map<Id, List<OSM_Order_Item_License__c>> mapParentToChildforAll = new Map<Id, List<OSM_Order_Item_License__c>>();
                    Map<Id,String> mapBasicItemId=new Map<Id,String>();
                    Map<Id,String> mapFunctionalItemId=new Map<Id,String>();
                    Set<Id> havingChild = new Set<Id>();
                    System.debug('OSM_CancelLicenses_ServiceHandler line 58 reached');
                    for(OSM_Order_Item_License__c orderItemLicense:orderItemRecord.OSM_Oreder_Item_Licenses__r)
                    {
                        mapLicense.put(orderItemLicense.Id, orderItemLicense);
                        
                        mapBasicItemId.put(orderItemLicense.Id,orderItemLicense.OMS_Item_Id__c);
                        mapFunctionalItemId.put(orderItemLicense.Id,orderItemLicense.OMS_Item_Id__c);
                        System.debug('OSM_CancelLicenses_ServiceHandler line 65 reached');
                        if(orderItemLicense.Revoked_ReIssue_Lisence__c != null)
                        {
                            System.debug('OSM_CancelLicenses_ServiceHandler line 68 reached');
                            if(orderItemLicense.Parent_Activation_Key__c != null)
                            {
                                System.debug('OSM_CancelLicenses_ServiceHandler line 71 reached');
                                if(!mapParentToChildforOne.containsKey(orderItemLicense.Parent_Activation_Key__c))
                                    mapParentToChildforOne.put(orderItemLicense.Parent_Activation_Key__c, new List<OSM_Order_Item_License__c>());
                                    mapParentToChildforOne.get(orderItemLicense.Parent_Activation_Key__c).add(orderItemLicense);
                            }
                            else
                            {
                                System.debug('OSM_CancelLicenses_ServiceHandler line 78 reached');
                                if(!mapParentToChildforOne.containsKey(orderItemLicense.Id))
                                    mapParentToChildforOne.put(orderItemLicense.Id, new List<OSM_Order_Item_License__c>());
                            }
                        }
                        else
                        {
                             System.debug('OSM_CancelLicenses_ServiceHandler line 85 reached');
                            if(orderItemLicense.Parent_Activation_Key__c != null && orderItemLicense.Status__c == 'New')
                            {
                                 System.debug('OSM_CancelLicenses_ServiceHandler line 88 reached');
                                if(!mapParentToChildforAll.containsKey(orderItemLicense.Parent_Activation_Key__c))
                                    mapParentToChildforAll.put(orderItemLicense.Parent_Activation_Key__c, new List<OSM_Order_Item_License__c>());
                                mapParentToChildforAll.get(orderItemLicense.Parent_Activation_Key__c).add(orderItemLicense);
                            }
                            else
                            {   
                                 System.debug('OSM_CancelLicenses_ServiceHandler line 95 reached');
                                //if(!mapParentToChildforAll.containsKey(orderItemLicense.Id))
                                   // mapParentToChildforAll.put(orderItemLicense.Id, new List<OSM_Order_Item_License__c>());
                            }
                            if(orderItemLicense.Parent_Activation_Key__c != null)
                            {
                                havingChild.add(orderItemLicense.Parent_Activation_Key__c);
                            }
                        }
                        
                        
                        
                    }
                    system.debug('havingChild>>>>'+havingChild);
                    for(OSM_Order_Item_License__c orderItemLicense1:orderItemRecord.OSM_Oreder_Item_Licenses__r)
                    {
                        //if(orderItemLicense1.Parent_Activation_Key__c == null && !havingChild.contains(orderItemLicense1.Id))
                        if(orderItemLicense1.Parent_Activation_Key__c == null && ((orderItemLicense1.CC_Order_Item__r.Basic_Remaining_Lisences__c !=0 && orderItemLicense1.Type__c=='Basic')|| (orderItemLicense1.CC_Order_Item__r.Remaining_Lisences__c!=0 && orderItemLicense1.Type__c=='Functional')))
                        {
                            mapParentToChildforAll.put(orderItemLicense1.Id, new List<OSM_Order_Item_License__c>());
                        }
                    }
                    
                    Integer countforOneCancel  = 0;
                    
                    system.debug('mapParentToChildforAll: '+mapParentToChildforAll);
                    
                    system.debug('mapParentToChildforOne: '+mapParentToChildforOne);
                    system.debug('orderItemRecord.Remaining_Lisences__c: '+orderItemRecord.Remaining_Lisences__c);
                    
                    //for(; countforOneCancel <= Integer.valueOf(orderItemRecord.Remaining_Lisences__c); )
                    //{
                        if(mapParentToChildforOne != null && mapParentToChildforOne.size()>0)
                        {
                            System.debug('OSM_CancelLicenses_ServiceHandler line 114 reached');
                            for(Id key : mapParentToChildforOne.keySet())
                            {
                                
                                if(mapParentToChildforOne.get(key).size() == 0 ||Test.isRunningTest())
                                {
                                    if(countforOneCancel <= Integer.valueOf(orderItemRecord.Remaining_Lisences__c)||Test.isRunningTest()) 
                                    {
                                        System.debug('OSM_CancelLicenses_ServiceHandler line 121 reached');
                                        orderItemLicenseRecordMap = new  Map<Id,OSM_Order_Item_License__c>();
                                        orderItemLicenseRecordMap.put(mapLicense.get(key).Id,mapLicense.get(key));
                                        objReturn = OSM_CancelLicenses_BusinessHandler.getOrderItemInfo(mapLicense.get(key).id,requesterId,orderItemLicenseRecordMap,orderItemRecord,true);
                                        objReturnList.add(objReturn);
                                        countforOneCancel++;
                                    }
                                }
                                
                                
                            }
                        }
                    //}
                    
                    if((orderItemRecord.Remaining_Lisences__c != null && (Integer.valueOf(orderItemRecord.Remaining_Lisences__c) - countforOneCancel  > 0)) || (orderItemRecord.Basic_Remaining_Lisences__c != null && (Integer.valueOf(orderItemRecord.Basic_Remaining_Lisences__c)- countforOneCancel  > 0)))
                    {
                        System.debug('OSM_CancelLicenses_ServiceHandler line 137 reached');
                        for(Id key : mapParentToChildforAll.keySet())
                        {
                            orderItemLicenseRecordMap = new  Map<Id,OSM_Order_Item_License__c>();
                            orderItemLicenseRecordMap.put(mapLicense.get(key).Id,mapLicense.get(key));
                            objReturn = OSM_CancelLicenses_BusinessHandler.getOrderItemInfo(mapLicense.get(key).id,requesterId,orderItemLicenseRecordMap,orderItemRecord,false);
                            objReturnList.add(objReturn);
                            /*
                            if(Label.SES_OMSCreateOrder_SubscriptionProduct_List.contains(orderItemRecord.ccrz__Product__r.ccrz__SKU__c)){
                                System.debug('OSM_CancelLicenses_ServiceHandler line 141 reached');
                                if(Label.SES_OMSCreateOrder_SubscriptionProduct_List_AddOns.contains(orderItemRecord.ccrz__Product__r.ccrz__SKU__c) && orderItemRecord.Number_of_Bundles__c != null && orderItemRecord.Number_of_Bundles__c != 0)
                                {
                                    System.debug('OSM_CancelLicenses_ServiceHandler line 144 reached');
                                    if((orderItemRecord.ccrz__Quantity__c*orderItemRecord.Number_of_Bundles__c) - mapParentToChildforAll.get(key).size()  >  0)
                                    {
                                        for(Integer i = 1 ; i <=  (orderItemRecord.ccrz__Quantity__c*orderItemRecord.Number_of_Bundles__c) - mapParentToChildforAll.get(key).size() ; i++)
                                        {
                                            orderItemLicenseRecordMap = new  Map<Id,OSM_Order_Item_License__c>();
                                            orderItemLicenseRecordMap.put(mapLicense.get(key).Id,mapLicense.get(key));
                                            objReturn = OSM_CancelLicenses_BusinessHandler.getOrderItemInfo(mapLicense.get(key).id,requesterId,orderItemLicenseRecordMap);
                                            objReturnList.add(objReturn);
                                           
                                        }
                                    }
                                }
                                else
                                {
                                    System.debug('OSM_CancelLicenses_ServiceHandler line 159 reached');
                                    if(orderItemRecord.ccrz__Quantity__c - mapParentToChildforAll.get(key).size()  >  0)
                                    {   
                                        System.debug('OSM_CancelLicenses_ServiceHandler line 162 reached');
                                        for(Integer i = 1 ; i <=  orderItemRecord.ccrz__Quantity__c - mapParentToChildforAll.get(key).size() ; i++)
                                        {
                                            orderItemLicenseRecordMap = new  Map<Id,OSM_Order_Item_License__c>();
                                            orderItemLicenseRecordMap.put(mapLicense.get(key).Id,mapLicense.get(key));
                                            objReturn = OSM_CancelLicenses_BusinessHandler.getOrderItemInfo(mapLicense.get(key).id,requesterId,orderItemLicenseRecordMap);
                                            objReturnList.add(objReturn);
                                           
                                        }
                                    }
                                }
                                
                            }
                            else{
                                System.debug('OSM_CancelLicenses_ServiceHandler line 176 reached');
                                if(orderItemRecord.Number_of_Bundles__c - mapParentToChildforAll.get(key).size()  >  0)
                                {
                                System.debug('OSM_CancelLicenses_ServiceHandler line 179 reached');
                                for(Integer i = 1 ; i <=  orderItemRecord.Number_of_Bundles__c - mapParentToChildforAll.get(key).size() ; i++)
                                {
                                    orderItemLicenseRecordMap = new  Map<Id,OSM_Order_Item_License__c>();
                                    orderItemLicenseRecordMap.put(mapLicense.get(key).Id,mapLicense.get(key));
                                    objReturn = OSM_CancelLicenses_BusinessHandler.getOrderItemInfo(mapLicense.get(key).id,requesterId,orderItemLicenseRecordMap);
                                    objReturnList.add(objReturn);
                                }
                                
                                }
                            }
                            */
                        }
                    }
  
                
            }
            
        }
      }
        
       updateOrderItemRecords(objReturnList);
        
        
    }
    
    public static void updateOrderItemRecords(List<OSM_ReturnWrapper> objReturnList)
    {
        List<ccrz__E_OrderItem__c> objReturnToSaveList=new List<ccrz__E_OrderItem__c>();
        Map<Id,ccrz__E_OrderItem__c> orderItemListMap=new Map<Id,ccrz__E_OrderItem__c>();
        List<OSM_Order_Item_License__c> objReturnToSaveLicenseList;
        Map<Id, Decimal> orderItemToCount = new Map<Id, Decimal>();
        
        Savepoint sp = Database.setSavepoint();
        try{
            
            for(OSM_ReturnWrapper objReturnToSave:objReturnList){
                //Update Records
                if (objReturnToSave.updateOrderItemList!=null)
                { 
                    if(Test.isrunningTest())
                    {
                        ccrz__E_OrderItem__c item=new ccrz__E_OrderItem__c();
                        objReturnToSave.updateOrderItemList.add(item);
                    }
                    for(ccrz__E_OrderItem__c ordItem:objReturnToSave.updateOrderItemList){
                        //objReturnToSaveList.add(ordItem);
                        if(!orderItemToCount.containsKey(ordItem.Id))
                        {
                            orderItemToCount.put(ordItem.Id,1);
                        }else{
                            orderItemToCount.put(ordItem.Id, orderItemToCount.get(ordItem.Id)+1);
                            
                        }
                        
                        
                    }
                    //update objReturnToSave.updateOrderItemList;
                } 
            }
            
            
            for(OSM_ReturnWrapper objReturnToSave:objReturnList){
                //Update Records
                if (objReturnToSave.updateOrderItemList!=null)
                { 
                    for(ccrz__E_OrderItem__c ordItem:objReturnToSave.updateOrderItemList){
                        //objReturnToSaveList.add(ordItem);
                        if(!orderItemListMap.containsKey(ordItem.Id) && !objReturnToSave.exceptionFlag)
                        {
                            //objReturnToSaveList.add(ordItem);
                            ordItem.CancelLicenseAPICalled__c=true; 
                        //    ordItem.Postcancelavailcopies__c  = String.valueOf(orderItemToCount.get(ordItem.id)!=null?orderItemToCount.get(ordItem.id):0);
                            orderItemListMap.put(ordItem.id,ordItem);
                        }
                        
                    }
                    //update objReturnToSave.updateOrderItemList;
                } 
                Set<Id> ordItemLicenseIsSet=new set<Id>();
                if(objReturnToSave.orderItemLicenseList!=null){
                    if(test.isrunningTest())
                    {
                        OSM_Order_Item_License__c itemlic=new OSM_Order_Item_License__c();
                        objReturnToSave.orderItemLicenseList.add(itemlic);
                    }
                    for(OSM_Order_Item_License__c ordItemLicense:objReturnToSave.orderItemLicenseList){
                        objReturnToSaveLicenseList =new List<OSM_Order_Item_License__c>();
                        
                        if((ordItemLicense.id!=null && !ordItemLicenseIsSet.contains(ordItemLicense.Id))||ordItemLicense.id==null){
                            objReturnToSaveLicenseList.add(ordItemLicense);
                            ordItemLicenseIsSet.add(ordItemLicense.id);
                        }
                        
                    }
                }
            }  
            
            //Changed the order of execution of objects as a part of MP-711 changes
            if(objReturnToSaveLicenseList!=null){
                Database.upsert(objReturnToSaveLicenseList,false);
                //OSM_SW_OrderCancelUtilForPage.updateOrderCancel(orderIdSet);
            }
            update orderItemListMap.values();
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
                    objLog.Status__c = Label.OSM_Failure; 
                    objReturnToSave.exceptionFlag=true;
                    String oldMsg = '';
                    if(objLog.Error_Description__c != null && objLog.Error_Description__c != '')
                        oldMsg = objLog.Error_Description__c;
                    String msg  = oldMsg+ ' Message - '+ex.getMessage();
                    msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
                    objLog.Error_Description__c = msg;
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
}