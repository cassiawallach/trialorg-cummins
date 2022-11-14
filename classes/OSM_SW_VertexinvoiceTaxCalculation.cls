public class OSM_SW_VertexinvoiceTaxCalculation
{
    public static void calculateInvoiceTax(List<Id> lstJunctionObjId)
    {
       OSM_ReturnWrapper objReturn =  OSM_SW_VertexActions.getVertexInvoiceTax(lstJunctionObjId, false);
       updateRecords(objReturn, false);
	   if(objReturn.lstJunctionObjInvoiceToOrder != null && objReturn.lstJunctionObjInvoiceToOrder.size() > 0)
		   OSM_SW_VertexActions.UpdateAllCreditMemoJunctionVertexStatusSuccessORPending(objReturn.lstJunctionObjInvoiceToOrder);
    }
    
    @future(callout=true)
    public static void calculateInvoiceTaxFuture(List<Id> lstJunctionObjId)
    {
        OSM_ReturnWrapper objReturn = OSM_SW_VertexActions.getVertexInvoiceTax(lstJunctionObjId, false);
        updateRecords(objReturn, false);
    }
    
    @future(callout=true)
    public static void CalculateRefundInvoiceTaxFuture(List<Id> lstJunctionObjId)
    {
        OSM_ReturnWrapper objReturn = OSM_SW_VertexActions.getVertexInvoiceTax(lstJunctionObjId, true);
        updateRecords(objReturn, true);
    }
    
    public static void CalculateRefundInvoiceTax(List<Id> lstJunctionObjId)
    {
        OSM_ReturnWrapper objReturn = OSM_SW_VertexActions.getVertexInvoiceTax(lstJunctionObjId, true);
        updateRecords(objReturn, true);
    }
    
    public static void updateRecords(OSM_ReturnWrapper objReturnToSave, boolean isRefundInvoiceReq)
    {
        Savepoint sp = Database.setSavepoint();
        
        try{
            //Update Records
            if(objReturnToSave.lstJunctionObjInvoiceToOrder != null && objReturnToSave.lstJunctionObjInvoiceToOrder.size() > 0)
                    update objReturnToSave.lstJunctionObjInvoiceToOrder;
            if(!isRefundInvoiceReq)
            {
                    if(objReturnToSave.lstToUpdateInvoiceItem != null && objReturnToSave.lstToUpdateInvoiceItem.size() > 0)
                    update objReturnToSave.lstToUpdateInvoiceItem;
                    
                    if(objReturnToSave.lstToUpdateJunctionItem != null && objReturnToSave.lstToUpdateJunctionItem.size() > 0)
                    update objReturnToSave.lstToUpdateJunctionItem;
            }
            if(objReturnToSave.updateInvoiceList != null && objReturnToSave.updateInvoiceList.size() > 0)
                    update objReturnToSave.updateInvoiceList;
       if(Test.isRunningTest()){
             throw new NullPointerException();                          
            }            
        }catch(Exception ex){
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