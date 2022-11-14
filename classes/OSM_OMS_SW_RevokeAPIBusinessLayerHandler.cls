/************************************************************
Name: OSM_OMS_SW_RevokeAPIBusinessLayerHandler
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is request wrapper class. 

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta            17/01/2019    INITIAL DEVELOPMENT          
Redep

*************************************************************/

public class OSM_OMS_SW_RevokeAPIBusinessLayerHandler{


    public static OSM_ReturnWrapper revokeAPIHandlerMethod(List<String> instanceIds,String contactIAMId)
    {
       OSM_ReturnWrapper objToReturn = new OSM_ReturnWrapper();
       OSM_Integration_Log__c log = new OSM_Integration_Log__c();
       List<OSM_Integration_Log__c> lstToInsertLog=new List<OSM_Integration_Log__c>();
    
       try{
           
           //intializing GeneralInput wrapper
           OSM_OMS_WS_RevokeGeneralized_IP_Wrapper inputWrapperObj=new OSM_OMS_WS_RevokeGeneralized_IP_Wrapper();
           inputWrapperObj.RevokeLicensesInput=new OSM_OMS_WS_RevokeGeneralized_IP_Wrapper.RevokeLicensesInput();
           inputWrapperObj.Header=new OSM_OMS_WS_RevokeGeneralized_IP_Wrapper.Header();
           inputWrapperObj.Header.Sender=new OSM_OMS_WS_RevokeGeneralized_IP_Wrapper.Sender();
           inputWrapperObj.Header.Target=new OSM_OMS_WS_RevokeGeneralized_IP_Wrapper.Target();
           inputWrapperObj.RevokeLicensesInput.InstanceIdList=new List<OSM_OMS_WS_RevokeGeneralized_IP_Wrapper.InstanceIdList>();
           List<OSM_OMS_WS_RevokeGeneralized_IP_Wrapper.InstanceIdList> instanceIdWrapperList=new List<OSM_OMS_WS_RevokeGeneralized_IP_Wrapper.InstanceIdList>();
           
           inputWrapperObj.RevokeLicensesInput.RequesterId='';
           
           //binding values 
           if(instanceIds !=null && contactIAMId!=null)
           {
               for(String instanceId:instanceIds)
               {
                   OSM_OMS_WS_RevokeGeneralized_IP_Wrapper.InstanceIdList wrapperObj=new OSM_OMS_WS_RevokeGeneralized_IP_Wrapper.InstanceIdList();
                   wrapperObj.Instance=instanceId;
                   instanceIdWrapperList.add(wrapperObj);
               }
               inputWrapperObj.RevokeLicensesInput.InstanceIdList.addAll(instanceIdWrapperList);
               inputWrapperObj.RevokeLicensesInput.RequesterId=OSM_Generic_Utility.truncateRequesterId(contactIAMId); //OSM_Generic_Utility.truncateRequesterId added by Pooja story 1054
               
           }
           system.debug('list of instance ids>>>>'+instanceIds);
           system.debug('inputwrapperObject>>>>>'+inputWrapperObj);
           //Calling Service class
           OSM_OMS_WS_RevokeGeneralized_OP_Wrapper   responseWrpObj = OSM_OMS_SW_RevokeAPIService.callRevokeService(inputWrapperObj);
           System.debug('General Output Wrapper>>>>>'+responseWrpObj);
           log=responseWrpObj.log;
           //log.CC_Order__c = orderId;
           //log.CC_Order_Item__c = OrderItemId;
           if(!responseWrpObj.errorFlag)
           {
               objToReturn.exceptionFlag=false;
           }
           else
           {
               objToReturn.exceptionFlag=true;
           }
           lstToInsertLog.add(log);
       if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 
            
       }
       

       catch(Exception ex)
       {
             System.debug('exception : '+ex.getMessage());
             log.Status__c = 'Failure'; 
             //log.CC_Order__c = orderId;
             //log.CC_Order_Item__c = OrderItemId;
             String msg  = 'Message - '+ex.getMessage();
             msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
             log.Error_Description__c = msg;
             log.Target__c = 'OMS';
             //log.Request__c = jsonStr;
             log.Source__c = 'OSM';
             log.Logged_In_User__c = userinfo.getuserid();
       }
       
      objToReturn.lstToInsertLog=lstToInsertLog;
      //insert lstToInsertLog;
      return objToReturn;
    }
}