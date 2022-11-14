/******
Name:  OSM_GetTI_BusinessHandler
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       14/01/2019     INITIAL DEVELOPMENT 
*******/
public class OSM_GetTI_BusinessHandler{
    public static OSM_ReturnWrapper updateOMSToolInstance(Id orderItemId,Map<Id,ccrz__E_OrderItem__c> orderItemMap, OSM_Order_Item_License__c itemLicenses,Id instanceRecordId){
            
            List<ccrz__E_OrderItem__c> orderItemList=new List<ccrz__E_OrderItem__c>();
            OSM_ReturnWrapper objToReturn = new OSM_ReturnWrapper();
            OSM_Integration_Log__c log =new OSM_Integration_Log__c();
            Set<String> mandatoryFields = new Set<String>();
            Set<Id> orderIdSet=new Set<Id>();
            ccrz__E_OrderItem__c orderItemObj;
            OSM_Order_Item_License__c orderItemLicense;
            List<OSM_Order_Item_License__c> orderItemLicenseList=new List<OSM_Order_Item_License__c>();
            List<OSM_Integration_Log__c> lstToInsertLog=new List<OSM_Integration_Log__c>();
        	String AccId; //Added by Dhiraj
            try{ 
                OSM_OMS_WS_GetTI_GenInputWrapper inputWrapperObj= new OSM_OMS_WS_GetTI_GenInputWrapper();  
                inputWrapperObj.GetTIFromLicenseKeyInput=new OSM_OMS_WS_GetTI_GenInputWrapper.GetTIFromLicenseKeyInput();
                inputWrapperObj.Header=new OSM_OMS_WS_GetTI_GenInputWrapper.Header();
                inputWrapperObj.Header.Sender=new OSM_OMS_WS_GetTI_GenInputWrapper.Sender();
                inputWrapperObj.Header.Target=new OSM_OMS_WS_GetTI_GenInputWrapper.Target(); 
                inputWrapperObj.Header.Message=new OSM_OMS_WS_GetTI_GenInputWrapper.Message();     
                //binding values
                ccrz__E_OrderItem__c orderItem=orderItemMap.get(orderItemId);
                System.debug('orderItem____'+orderItem);
                Set<ID> orderItemIdSet = new Set<ID>();
                orderItemIdSet.add(orderItem.ID);
               
                if(itemLicenses != null){    
                     if(itemLicenses.OMS_Item_Id__c!=null){
                          inputWrapperObj.Header.Message.MessageID= itemLicenses.OMS_Item_Id__c;
                          System.debug('__MESSAGEID__'+ inputWrapperObj.Header.Message.MessageID);
                         inputWrapperObj.GetTIFromLicenseKeyInput.AccountId = orderItem.ccrz__Order__r.ccrz__Account__c; //Added By Dhiraj
                         AccId = orderItem.ccrz__Order__r.ccrz__Account__c; //Added By Dhiraj
                     }
                     else{
                          mandatoryFields.add('MessageID');
                      }
                   inputWrapperObj.Header.Message.Timestamp = OSM_Generic_Utility.getRequiredDateFormat(System.today(), 'yyyy-MM-dd');
                   inputWrapperObj.GetTIFromLicenseKeyInput.ToolName = 'INSITE';  
                   if(itemLicenses != null){ 
                        inputWrapperObj.GetTIFromLicenseKeyInput.ActivationKey = itemLicenses.Activation_Key__c;
                    }
                    else{
                    mandatoryFields.add('ActivationKey');
                    }
                    System.debug('mandatoryFields__size_'+mandatoryFields.size());
                    System.debug('inputWrapperObj.Header.Message.MessageID______'+inputWrapperObj.Header.Message.MessageID);
                    System.debug('inputWrapperObj.GetTIFromLicenseKeyInput.ActivationKey_____'+inputWrapperObj.GetTIFromLicenseKeyInput.ActivationKey);
                     if(inputWrapperObj.Header.Message.MessageID!=null && inputWrapperObj.GetTIFromLicenseKeyInput.ActivationKey!=null && !(mandatoryFields.size() > 0)){
                          System.debug('mandatoryFields__insideloop_'+mandatoryFields.size());
       
                                        //Calling Service class
                                        OSM_OMS_WS_GetTI_GenOutputWrapper responseWrpObj= OSM_OMS_WS_GetTI.callOMSGetTIService(inputWrapperObj);                                    
                                        System.debug('General Output Wrapper>>>>>'+responseWrpObj);
                                        log=responseWrpObj.log;
                                        if(!responseWrpObj.errorFlag){
                                        List<String> ToolInstanceList=new List<String>();
                                        List<String> InstanceIdList=new List<String>();
                                            Integer active = 0;
                                            System.debug('toolList_____'+responseWrpObj.GetTIFromLicenseKeyOutput.ToolInstListInfo.ToolInstList);
                                         for(OSM_OMS_WS_GetTI_GenOutputWrapper.ToolInstList toolInstList:responseWrpObj.GetTIFromLicenseKeyOutput.ToolInstListInfo.ToolInstList){
                                               if(toolInstList.InstanceID!=null && toolInstList.InstanceID!='')
                                               {
                                                     orderItemLicense=new OSM_Order_Item_License__c();
                                                     if(active == 0){
                                                         //orderItemLicense.Id = itemLicenses.Id;
                                                     }
                                                     orderItemLicense.Tool_Instance_Key__c=toolInstList.ToolInstance;
                                                     orderItemLicense.Tool_Instance_Id__c=toolInstList.InstanceID;
                                                     orderItemLicense.CC_Order_Item__c=orderItem.id;
                                                     orderItemLicense.Activation_Key__c = itemLicenses.Activation_Key__c;
                                                     orderItemLicense.OMS_Item_Id__c = itemLicenses.OMS_Item_Id__c;
                                                     orderItemLicense.Parent_Activation_Key__c = itemLicenses.Id;
                                                     orderItemLicense.Type__c=itemLicenses.Type__c;
                                                    
                                                     active++;
                                                     if(instanceRecordId != null){
                                                         orderItemLicense.Parent_Activation_Key__c = instanceRecordId;
                                                     }
                                                     System.debug('orderItemLicenseList__________'+orderItemLicenseList);
                                                    
                                                    orderItemLicenseList.add(orderItemLicense);
                                                }
                                            }
                                            
                                            
                                                                                   
                                            
    
                                        log.CC_Order_Item__c=orderItem.id;                       
                                        orderItem.OSM_GetTI_Success__c=true;
                                        
                                        orderItemList.add(orderItem);                      
                                        
                                        objToReturn.exceptionFlag=false;
    
                                    }else{
                                        objToReturn.exceptionFlag=true;
                                        
                                        if(log.Error_Code__c=='1129')
                                        {
                                            objToReturn.exceptionMessage='NoActiveToolInstance';
                                            orderItem.OSM_GetTI_Success__c=true;
                                            orderItemList.add(orderItem); 
                                        }
                                        else
                                        {
                                            orderItem.OSM_GetTI_Success__c=false;
                                            orderItemList.add(orderItem);
                                        }
                                    }
                         }  
                         else{
                            String mandeToryString;
                            for(String valueStr : mandatoryFields)
                            {
                                if(mandeToryString != null)
                                    mandeToryString = mandeToryString+', '+valueStr;
                                    else
                                    mandeToryString = valueStr;    
                            } 
                            log.Account__c = orderItem.ccrz__Order__r.ccrz__Account__c; //Added By Dhiraj
                            log.Status__c = 'Failure';
                            log.Target__c = 'OMS';
                            log.Source__c = 'OSM';
                            log.Logged_In_User__c = userinfo.getuserid();
                            log.Error_Description__c='Mandatory fields are missing: '+mandeToryString;
                            log.Service_Name__c='OMS_GetTIFromLicenseKey_Service'; 
                            log.CC_Order_Item__c=orderItem.id;
                            objToReturn.exceptionFlag=true;
                        }      
                    } 
                     if(Test.IsRunningTest()){
                        throw new NullPointerException();
                    }
                } 
                catch(Exception ex){
                    System.debug('exception : '+ex.getMessage());
                    log.Status__c = 'Failure'; 
                    String msg  = 'Message - '+ex.getMessage();
                    msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();                   
                    log.Error_Description__c = msg;
                    log.Target__c = 'OMS';
                    log.Source__c = 'OSM';
                     log.Account__c = AccId; //Added By Dhiraj
                    log.Logged_In_User__c = userinfo.getuserid();
                 }
                if(log!=NULL){
                     System.debug('LOG__________'+log);
                     lstToInsertLog.add(log); 
                } 
                objToReturn.lstToInsertLog=new List<OSM_Integration_Log__c>();
                objToReturn.lstToInsertLog=lstToInsertLog;
                objToReturn.updateOrderItemList=new List<ccrz__E_OrderItem__c>();
                objToReturn.updateOrderItemList=orderItemList;
                objToReturn.orderItemLicenseList=new List<OSM_Order_Item_License__c>();
                objToReturn.orderItemLicenseList=orderItemLicenseList;              
                 System.debug('lstToInsertLog___'+lstToInsertLog);
                 System.debug('updateOrderItemList___'+objToReturn.updateOrderItemList);
            return objToReturn;       
     }
    
    }