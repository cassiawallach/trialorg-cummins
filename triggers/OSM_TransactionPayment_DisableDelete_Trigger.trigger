trigger OSM_TransactionPayment_DisableDelete_Trigger on ccrz__E_TransactionPayment__c (before delete) 
{
    if( Trigger.isDelete )
    {
        if(Trigger.isBefore)
        {
            for(ccrz__E_TransactionPayment__c transactionPayment : Trigger.old)
            {
                transactionPayment.addError('ERROR : You do not have delete permission');                
            }
        }
    }
}