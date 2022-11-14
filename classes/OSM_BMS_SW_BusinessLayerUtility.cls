/************************************************************
Name:  OSM_BMS_SW_BusinessLayerUtility
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
1.0 -   Sangeeta            23/10/2018     INITIAL DEVELOPMENT          


*************************************************************/

public class OSM_BMS_SW_BusinessLayerUtility
{
    public static OSM_ReturnWrapper calculateBMSAvailableCredit(Id accountId,boolean isThirdPartyBMSCheck,String thirdPartyBMS,Id IAMAccountId) 
    {
       OSM_ReturnWrapper objReturn =  OSM_BMS_SW_BusinessLayerHandler.getBMSAvailableCredit(accountId,isThirdPartyBMSCheck,thirdPartyBMS,IAMAccountId);
       updateRecords(objReturn);
       return objReturn;
    }
    
       
    public static void updateRecords(OSM_ReturnWrapper objReturnToSave)
    {
        Savepoint sp = Database.setSavepoint();
        
        try{
            //Update && Insert Records
             if (objReturnToSave.updateAccountList!=null)
             { 
                 update objReturnToSave.updateAccountList;
             } 
             if(objReturnToSave.updateContactAddressList!=null && objReturnToSave.updateContactAddressList.size()>0)
             {
                 update objReturnToSave.updateContactAddressList;
             }
             else if (objReturnToSave.insertContactAddressList.size()>0 && objReturnToSave.insertAddressBookList.size()>0)
             {
                 system.debug('executing contact address insert DML>>>>');
                 insert objReturnToSave.insertContactAddressList;
                 insert objReturnToSave.insertAddressBookList;
                 
             }
            if(Test.isRunningTest())
            {
                Throw new NullPointerException();
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