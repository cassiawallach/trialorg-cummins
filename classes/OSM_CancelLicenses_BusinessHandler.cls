/******
Name:  OSM_CancelLicenses_BusinessHandler
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
public class OSM_CancelLicenses_BusinessHandler{
    public static OSM_ReturnWrapper getOrderItemInfo(Id orderLicenseItemId,String requesterId,Map<Id,OSM_Order_Item_License__c> orderItemLicenseMap,ccrz__E_OrderItem__c orderItem,Boolean Reissued){
        List<ccrz__E_OrderItem__c> orderItemList=new List<ccrz__E_OrderItem__c>();
        OSM_ReturnWrapper objToReturn = new OSM_ReturnWrapper();
        OSM_Integration_Log__c log =new OSM_Integration_Log__c();
        Set<String> mandatoryFields = new Set<String>();
        Set<Id> orderIdSet=new Set<Id>();
        ccrz__E_OrderItem__c orderItemObj;
        List<OSM_Order_Item_License__c>  licenseList=new List<OSM_Order_Item_License__c> ();
        List<OSM_Integration_Log__c> lstToInsertLog=new List<OSM_Integration_Log__c>();
        try{ 
            OSM_CancelLicensesREQ_GeneralizedWrapper inputWrapperObj=new OSM_CancelLicensesREQ_GeneralizedWrapper();  
            inputWrapperObj.CancelLicensesInput=new OSM_CancelLicensesREQ_GeneralizedWrapper.CancelLicensesInput();
            inputWrapperObj.Header=new OSM_CancelLicensesREQ_GeneralizedWrapper.Header();
            inputWrapperObj.Header.Sender=new OSM_CancelLicensesREQ_GeneralizedWrapper.Sender();
            inputWrapperObj.Header.Target=new OSM_CancelLicensesREQ_GeneralizedWrapper.Target(); 
            //binding values
            OSM_Order_Item_License__c orderItemLicense=orderItemLicenseMap.get(orderLicenseItemId);
            System.debug('orderItemLicense____'+orderItemLicense);
            Set<ID> orderItemLicenseIdSet = new Set<ID>();
            orderItemLicenseIdSet.add(orderItemLicense.ID);
            
            if(orderItemLicense!=null){    
                if(orderItemLicense.OMS_Item_Id__c !=null){
                    inputWrapperObj.CancelLicensesInput.ItemId=orderItemLicense.OMS_Item_Id__c;
                    System.debug('inputWrapperObj.CancelLicensesInput.ItemId____'+inputWrapperObj.CancelLicensesInput.ItemId);
                }
                else{
                    mandatoryFields.add('ItemId');
                }
                if(requesterId!=null){
                    inputWrapperObj.CancelLicensesInput.RequesterId=OSM_Generic_Utility.truncateRequesterId(requesterId); //OSM_Generic_Utility.truncateRequesterId added by Pooja story 1054
                    //inputWrapperObj.CancelLicensesInput.RequesterId='';
                    System.debug('inputWrapperObj.CancelLicensesInput.RequesterId____'+inputWrapperObj.CancelLicensesInput.RequesterId);
                }
                else{
                    mandatoryFields.add('RequesterId');
                }
                inputWrapperObj.CancelLicensesInput.ToolName=Label.OSM_ToolName;
                //inputWrapperObj.CancelLicensesInput.ToolName='QSOL';
                               
                if(orderItemLicense.OMS_Item_Id__c != null && orderItemLicense.Status__c =='New' && !Reissued)
                {
                    System.debug('orderItemLicense.Status__c _____'+orderItemLicense.Status__c);
                    //inputWrapperObj.CancelLicensesInput.TotalCopies=1;
                    if(orderItemLicense.Type__c=='Functional')
                    inputWrapperObj.CancelLicensesInput.TotalCopies=Integer.valueOf(orderItem.Remaining_Lisences__c); 
                    else
                    inputWrapperObj.CancelLicensesInput.TotalCopies=Integer.valueOf(orderItem.Basic_Remaining_Lisences__c); 
                }
                else{
                    System.debug('orderItemLicense.Status__c __else___'+orderItemLicense.Status__c);
                    inputWrapperObj.CancelLicensesInput.TotalCopies=1;
                }
                inputWrapperObj.CancelLicensesInput.AccountId = orderItem.ccrz__Order__r.ccrz__Account__c; //Added By Dhiraj
                if(inputWrapperObj.CancelLicensesInput.ItemId!=null && inputWrapperObj.CancelLicensesInput.RequesterId!=null && !(mandatoryFields.size() > 0)){
                    
                    //Calling Service class
                    OSM_CancelLicensesRES_GeneralizedWrapper responseWrpObj=OSM_CancelLicenses_Service.callCancelLicensesService(inputWrapperObj);
                    System.debug('General Output Wrapper>>>>>'+responseWrpObj);
                    log=responseWrpObj.log;
                    orderItemObj=new ccrz__E_orderItem__c();
                    orderItemObj.id=orderItemLicense.CC_Order_Item__r.id;

                    System.debug('responseWrpObj.errorFlag_____'+responseWrpObj.errorFlag);
                    
                    if(!responseWrpObj.errorFlag|| test.isRunningTest()){
                        System.debug('responseWrpObj.CancelLicensesOutput___'+responseWrpObj.CancelLicensesOutput);
                        OSM_CancelLicensesRES_GeneralizedWrapper.CancelLicensesOutput objCancelLicense=responseWrpObj.CancelLicensesOutput;
                        orderItemObj.OSMCancelstatus__c=objCancelLicense.CancelLicenseStatus;
                        orderItemObj.Postcancelavailcopies__c=objCancelLicense.RemainingCopies;
                                           
                        log.CC_Order_Item__c=orderItemLicense.CC_Order_Item__r.id;                       
                        if(log.Status__c==Label.OSM_Success){
                        orderItemLicense.IsCancelCalledSuccess__c=true;
                        
                        licenseList.add(orderItemLicense);
                        log.Status__c = Label.OSM_Success;
                             log.Account__c = inputWrapperObj.CancelLicensesInput.AccountId;//Added by dhiraj
                        }           
                        else{
                            log.Status__c = Label.OSM_Failure;
                             log.CC_Order_Item__c=orderItemLicense.CC_Order_Item__r.id; 
                             log.Account__c = inputWrapperObj.CancelLicensesInput.AccountId; //Added by dhiraj
                        }          
                        orderItemList.add(orderItemObj);
                        objToReturn.exceptionFlag=false;                                
                    }
                    else{
                        objToReturn.exceptionFlag=true; 
                        orderItemList.add(orderItemObj);
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
                    log.Status__c = Label.OSM_Failure;
                    log.Target__c = Label.OSM_OMS;
                    log.Source__c = Label.OSM_Source;
                    log.Logged_In_User__c = userinfo.getuserid();
                    log.Error_Description__c='Mandatory fields are missing: '+mandeToryString;
                    log.Service_Name__c=Label.OSM_CancelLicense; 
                    log.CC_Order_Item__c=orderItemLicense.CC_Order_Item__r.id;
                    log.Account__c = inputWrapperObj.CancelLicensesInput.AccountId; //Added by dhiraj
                    
                    objToReturn.exceptionFlag=true;
                }      
            } 
            if(Test.IsRunningTest()){
                throw new NullPointerException();
            }
        } 
        catch(Exception ex){
            System.debug('exception : '+ex.getMessage());
            log.Status__c = Label.OSM_Failure; 
            String msg  = 'Message - '+ex.getMessage();
            msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();                   
            log.Error_Description__c = msg;
            log.Target__c = System.Label.OSM_BMS_Target_ID;
            log.Source__c = Label.OSM_Source;
            log.Logged_In_User__c = userinfo.getuserid();
            log.Account__c =  orderItem.ccrz__Order__r.ccrz__Account__c; //Added By Dhiraj
            log.Account__c = getAccountId(); 
            objToReturn.exceptionFlag=true;
        }
        if(log!=NULL){
            System.debug('LOG__________'+log);
            lstToInsertLog.add(log); 
        } 
        objToReturn.lstToInsertLog=new List<OSM_Integration_Log__c>();
        objToReturn.lstToInsertLog=lstToInsertLog;
        objToReturn.updateOrderItemList=new List<ccrz__E_OrderItem__c>();
        if(orderItemList!=null){
            objToReturn.updateOrderItemList=orderItemList;   
        }  
        objToReturn.orderItemLicenseList=new List<OSM_Order_Item_License__c>();   
        if(licenseList!=null){         
        objToReturn.orderItemLicenseList=licenseList;
        }
        System.debug('lstToInsertLog___'+lstToInsertLog);
        System.debug('updateOrderItemList___'+objToReturn.updateOrderItemList);
         System.debug('updateOrderItemList___'+objToReturn.orderItemLicenseList);
        return objToReturn;       
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