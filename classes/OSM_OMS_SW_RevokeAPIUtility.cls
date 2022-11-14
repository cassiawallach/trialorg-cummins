/************************************************************
Name:   OSM_OMS_SW_RevokeAPIUtility
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is the business layer Utility class to call Business Layer Handler

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta            10/04/2018     INITIAL DEVELOPMENT          
Redep

*************************************************************/

public class  OSM_OMS_SW_RevokeAPIUtility
{
    public static OSM_ReturnWrapper revokeAPIcallSingleInstance(Id orderItemId,String instanceId)
    {
        OSM_ReturnWrapper objReturn;
        List<String> instanceIdsList=new List<String>();
        Map<Id,OSM_ReturnWrapper> retrunWrapperVsItemIDMap=new Map<Id,OSM_ReturnWrapper>();
        Map<Id,OSM_Order_Item_License__c> idVSOrderItemMap=new Map<Id,OSM_Order_Item_License__c>();
        List<OSM_Order_Item_License__c> listToUpdateItemLicense=new List<OSM_Order_Item_License__c>();
        Map<Id,ccrz__E_OrderItem__c> orderItemIdVsLicenseMap=new Map<Id,ccrz__E_OrderItem__c>();
        List<ccrz__E_OrderItem__c> itemsToUpdateList=new List<ccrz__E_OrderItem__c>();
        String userType = '';
        String requesterId='';
        ID userId = UserInfo.getUserId();
        User usr = [Select ID,Email,FederationIdentifier FROM User Where ID=:userId];
        if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET)
        {
               userType = OSM_SW_General_Util.getuserType(userId);
        } 
        else
        {
               userType = OSM_SW_General_Util.USER_TYPE;
        }
         set<id> orderIdSet=new Set<Id>();
        //querying order item id...
        List<ccrz__E_OrderItem__c> orderItemsList=[Select id,ccrz__Order__c,Name,ccrz__DisplayProduct__c,Contact__c,Contact_IAM_Cummins_login_ID__c,CMI_Account_Number__c,Basic_Tool_Instance_Key_Count__c,Tool_Instance_Count__c,IsRevokeLicenseSucess__c from ccrz__E_OrderItem__c  where id=:orderItemId];
        
        //querying OSM_Order_Item_License__c record..
        List<OSM_Order_Item_License__c> orderItemsLicenseList=[Select id,Name,CC_Order_Item__c,IsRevokeAPISuccess__c,Tool_Instance_Id__c from OSM_Order_Item_License__c  where CC_Order_Item__c=:orderItemId and Id=:instanceId];
        
       if(orderItemsList!=null && orderItemsList.size()>0 )
       {   
           for(ccrz__E_OrderItem__c orderItem:orderItemsList)
           {
               
               if(orderItemsLicenseList!=null && orderItemsLicenseList.size()>0)
               {
                   instanceIdsList.add(orderItemsLicenseList[0].Tool_Instance_Id__c);
                    if(userType == Label.OSM_Fleet_Admin_UserType)
                    {
                        requesterId = OSM_Generic_Utility.truncateRequesterId(orderItem.CMI_Account_Number__c); //OSM_Generic_Utility.truncateRequesterId added by Pooja story 1054
                }
                else // take the WWID of the CSR from the User Record - Federation ID Field
                {
                         requesterId = OSM_Generic_Utility.truncateRequesterId(usr.FederationIdentifier); //OSM_Generic_Utility.truncateRequesterId added by Pooja story 1054
                }  
                   //calling Revoke API's handler method and passing instance ids list
                   objReturn =  OSM_OMS_SW_RevokeAPIBusinessLayerHandler.revokeAPIHandlerMethod(instanceIdsList,requesterId);
                   retrunWrapperVsItemIDMap.put(orderItemsLicenseList[0].id,objReturn);
                   idVSOrderItemMap.put(orderItemsLicenseList[0].id,orderItemsLicenseList[0]);
                   orderItemIdVsLicenseMap.put(orderItemsLicenseList[0].id,orderItem);
               }
                orderIdSet.add(orderItem.ccrz__Order__c);
           }
        
       }
       //getting updated item record..
        //List<ccrz__E_OrderItem__c> updatedOrderItem=[Select id,Name,ccrz__DisplayProduct__c,Contact__c,Contact_IAM_Cummins_login_ID__c,CMI_Account_Number__c,Basic_Tool_Instance_Key_Count__c,Tool_Instance_Count__c,IsRevokeLicenseSucess__c from ccrz__E_OrderItem__c  where id=:orderItemId];
        //system.debug('updated item>>>'+updatedOrderItem);
       Map<Id,ccrz__E_Order__c> orderMap=new Map<Id,ccrz__E_Order__c>([select id,Revoked_OR_Reissued_By__c,Rvoked_OR_Reissued_User_Email__c from ccrz__E_Order__c where id in:orderIdSet]);
       List<ccrz__E_Order__c> updatedOrderList=new List<ccrz__E_Order__c>();
       for(Id itemId:retrunWrapperVsItemIDMap.keySet())
       {

           OSM_Order_Item_License__c orderItemLicense=idVSOrderItemMap.get(itemId);
           ccrz__E_OrderItem__c orderItemRecord=orderItemIdVsLicenseMap.get(itemId);
           if(retrunWrapperVsItemIDMap.get(itemId)!=null)
           {
               if(retrunWrapperVsItemIDMap.get(itemId).exceptionFlag==true)
               {
                   //orderItemLicense.IsRevokeAPISuccess__c=false;
                   objReturn.exceptionFlag=true;
                   orderItemRecord.IsRevokeLicenseSucess__c=false;
                   
               }
               else
               {
                   orderItemRecord.IsRevokeLicenseSucess__c=true;
                   //orderItemLicense.IsRevokeAPISuccess__c=true;
                   objReturn.exceptionFlag=false;
                   orderItemLicense.Status__c='Revoked/ReIssue';
                   /*if(updatedOrderItem !=null && updatedOrderItem.size()>0 && updatedOrderItem[0].Basic_Tool_Instance_Key_Count__c==0 && updatedOrderItem[0].Tool_Instance_Count__c==0)
                   {
                      updatedOrderItem[0].IsRevokeLicenseSucess__c=true;
                       
                   }*/
                   if(orderMap!=null)
                   {
                     orderMap.get(orderItemsList[0].ccrz__Order__c).Revoked_OR_Reissued_By__c=userType;
                     orderMap.get(orderItemsList[0].ccrz__Order__c).Rvoked_OR_Reissued_User_Email__c=usr.email;
                     //updatedOrderList.add(orderMap.get(orderItemsList[0].ccrz__Order__c));
                   }
               }
                   
           }
          
           listToUpdateItemLicense.add(orderItemLicense);
         
           itemsToUpdateList.add(orderItemRecord);
       }
       if(objReturn!=null)
       {
           objReturn.orderItemLicenseList=listToUpdateItemLicense;
           objReturn.orderItemsToUpdateList=itemsToUpdateList;
           updateRecords(objReturn);
           system.debug('final objReturn record to update 1>>>>'+objReturn);
           system.debug('final objReturn item record to update 1>>>>'+objReturn.orderItemLicenseList);
       }
       updatedOrderList.addAll(orderMap.values());
       if(updatedOrderList!=null)
       {
       update updatedOrderList;
       }
       
       return objReturn;
        
        
        
    }
    public static OSM_ReturnWrapper revokeAPIcall(Set<Id> orderItemList)
    {
       
       OSM_ReturnWrapper objReturn;
       List<OSM_ReturnWrapper> returnWrapperList=new List<OSM_ReturnWrapper>();
       Map<Id,OSM_ReturnWrapper> retrunWrapperVsItemIDMap=new Map<Id,OSM_ReturnWrapper>();
       Map<Id,ccrz__E_OrderItem__c> idVSOrderItemMap=new Map<Id,ccrz__E_OrderItem__c>();
       List<ccrz__E_OrderItem__c> orderItemsToUpdateList=new List<ccrz__E_OrderItem__c>();
       List<OSM_Order_Item_License__c> licenseUpdateList=new List<OSM_Order_Item_License__c>();
       List<OSM_Integration_Log__c> logsList=new List<OSM_Integration_Log__c>();
       //Sharad to make license status revoke for all order item
        Map<Id, List<OSM_Order_Item_License__c>> mapOrderItemIdToLstLicense = new Map<Id, List<OSM_Order_Item_License__c>>();
       //List<ccrz__E_OrderItem__c> orderItemsToUpdateList=new List<ccrz__E_OrderItem__c>();
       //List<String> instanceIdsList=new List<String>();
       system.debug('item ids>>>>'+orderItemList);
       set<id> orderIdSet=new Set<Id>();
       List<ccrz__E_OrderItem__c> orderItemsList=[Select id,ccrz__Order__c,Name,Contact__c,ccrz__OrderItemStatus__c,ccrz__DisplayProduct__c,IsRevokeLicenseSucess__c,CMI_Account_Number__c,Contact_IAM_Cummins_login_ID__c,OMS_Instance_ID__c,(Select id,Status__c,Name,CC_Order_Item__c,IsRevokeAPISuccess__c,Tool_Instance_Id__c from OSM_Oreder_Item_Licenses__r where Status__c='New' and Tool_Instance_Id__c!=null) from ccrz__E_OrderItem__c  where id IN: orderItemList];
      
       String userType = '';
       String requesterId='';
       ID userId = UserInfo.getUserId();
       User usr = [Select ID,email,FederationIdentifier FROM User Where ID=:userId];
        
        if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET)
        {
               userType = OSM_SW_General_Util.getuserType(userId);
        } 
        else
        {
               userType = OSM_SW_General_Util.USER_TYPE;
        }
       
       if(orderItemsList!=null && orderItemsList.size()>0)
       {
           for(ccrz__E_OrderItem__c orderItemRecord:orderItemsList)
           {
             
               List<String> instanceIdsList=new List<String>();
               if(orderItemRecord.OSM_Oreder_Item_Licenses__r!=null && orderItemRecord.OSM_Oreder_Item_Licenses__r.size()>0)
               {   
                   for(OSM_Order_Item_License__c orderItemLicense:orderItemRecord.OSM_Oreder_Item_Licenses__r)
                   {
                       
                    if(orderItemLicense.Tool_Instance_Id__c!=null)
                    {
                        instanceIdsList.add(orderItemLicense.Tool_Instance_Id__c);

                        if(!mapOrderItemIdToLstLicense.containsKey(orderItemRecord.Id))
                            mapOrderItemIdToLstLicense.put(orderItemRecord.Id, new List<OSM_Order_Item_License__c>());
                        mapOrderItemIdToLstLicense.get(orderItemRecord.Id).add(orderItemLicense);
                    }
                       
                        
                       
                   }
               }
               if(userType == Label.OSM_Fleet_Admin_UserType)
               {
                requesterId = OSM_Generic_Utility.truncateRequesterId(orderItemRecord.CMI_Account_Number__c); //OSM_Generic_Utility.truncateRequesterId added by Pooja story 1054
              }
                else // take the WWID of the CSR from the User Record - Federation ID Field
              {
                requesterId = OSM_Generic_Utility.truncateRequesterId(usr.FederationIdentifier); //OSM_Generic_Utility.truncateRequesterId added by Pooja story 1054
              }    
               //calling Revoke API's handler method and passing instance ids list
                objReturn =  OSM_OMS_SW_RevokeAPIBusinessLayerHandler.revokeAPIHandlerMethod(instanceIdsList,requesterId );
                       
                retrunWrapperVsItemIDMap.put(orderItemRecord.id,objReturn);
                idVSOrderItemMap.put(orderItemRecord.id,orderItemRecord);
                orderIdSet.add(orderItemRecord.ccrz__Order__c);
           }
         
       }
       Map<Id,ccrz__E_Order__c> orderMap=new Map<Id,ccrz__E_Order__c>([select id,Revoked_OR_Reissued_By__c,Rvoked_OR_Reissued_User_Email__c from ccrz__E_Order__c where id in:orderIdSet]);
       List<ccrz__E_Order__c> updatedOrderList=new List<ccrz__E_Order__c>();
       for(Id itemId:retrunWrapperVsItemIDMap.keySet())
       {
          ccrz__E_OrderItem__c orderItemRecordToUpdate=idVSOrderItemMap.get(itemId);
           if(retrunWrapperVsItemIDMap.get(itemId)!=null)
           {
               if(retrunWrapperVsItemIDMap.get(itemId).exceptionFlag==true)
               {
                   orderItemRecordToUpdate.IsRevokeLicenseSucess__c=false;
                   //orderItem.OMS_Revoke_API_failure__c=true;
               }
               else
               {
                   orderItemRecordToUpdate.IsRevokeLicenseSucess__c=true;
                   //orderItemRecordToUpdate.ccrz__OrderItemStatus__c='Revoked';
                   if(mapOrderItemIdToLstLicense.containsKey(orderItemRecordToUpdate.Id))
                   {
                       for(OSM_Order_Item_License__c licenseObj : mapOrderItemIdToLstLicense.get(orderItemRecordToUpdate.Id))
                       {
                           licenseObj.Status__c='Revoked';
                           licenseUpdateList.add(licenseObj);
                           if(orderMap!=null)
                           {
                             orderMap.get(orderItemRecordToUpdate.ccrz__Order__c).Revoked_OR_Reissued_By__c=userType;
                             orderMap.get(orderItemRecordToUpdate.ccrz__Order__c).Rvoked_OR_Reissued_User_Email__c=usr.email;
                             //updatedOrderList.add(orderMap.get(orderItemRecordToUpdate.ccrz__Order__c));
                           }
                           
                       }
                   }
                   
                   
                   
               }
                   
           }
           if(retrunWrapperVsItemIDMap.get(itemId)!=null && retrunWrapperVsItemIDMap.get(itemId).lstToInsertLog!=null && retrunWrapperVsItemIDMap.get(itemId).lstToInsertLog.size()>0 )
           {
               logsList.add(retrunWrapperVsItemIDMap.get(itemId).lstToInsertLog[0]);
           }
          
           orderItemsToUpdateList.add(orderItemRecordToUpdate);
           //updatedOrderList.add(orderMap.get(orderItemRecordToUpdate.ccrz__Order__c));
       }
       
       
       if(objReturn!=null)
       {
           objReturn.orderItemsToUpdateList=orderItemsToUpdateList;
           objReturn.orderItemLicenseList=licenseUpdateList;
           objReturn.lstToInsertLog=logsList;
           updateRecords(objReturn);
           system.debug('final objReturn record to update 2>>>>'+objReturn);
           system.debug('final objReturn item record to update 2>>>>'+objReturn.orderItemsToUpdateList);
       }
       updatedOrderList.addAll(orderMap.values());
       if(updatedOrderList!=null)
       {
       update updatedOrderList;
       }
       return objReturn;
    }
    public static void updateRecords(OSM_ReturnWrapper objReturnToSave)
    {
        Savepoint sp = Database.setSavepoint();
        
        try{
            //Update && Insert Records
             if (objReturnToSave.orderItemsToUpdateList!=null)
             { 
                 update objReturnToSave.orderItemsToUpdateList;
             } 
             //Update && Insert Records
             if (objReturnToSave.orderItemLicenseList!=null)
             { 
                 update objReturnToSave.orderItemLicenseList;
             } 
            
           }
            catch(Exception ex)
            {
                System.debug('Exception in DML>>>>'+ex);
                Database.rollback(sp);
                for(OSM_Integration_Log__c objLog : objReturnToSave.lstToInsertLog)
                {
                    objLog.Status__c = 'Failure'; 
                    
                    String oldMsg = '';
                    if(objLog.Error_Description__c != null && objLog.Error_Description__c != '')
                        oldMsg = objLog.Error_Description__c;
                    String msg  = oldMsg+ ' Message - '+ex.getMessage();
                    msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
                    objLog.Error_Description__c = msg;
                }
            }
            finally 
            {
                if(objReturnToSave.lstToInsertLog !=  null && objReturnToSave.lstToInsertLog.size() > 0)
                    insert objReturnToSave.lstToInsertLog;
            }
    }
       
  
}