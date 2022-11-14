/************************************************************
Name:  OSM_SW_IntegrationUpdates 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is integration utility class that will update and reset 
respective failure flags on CC transaction payment record. 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/05/2018     INITIAL DEVELOPMENT          


*************************************************************/

public class OSM_SW_IntegrationUpdates {

    public static ccrz__E_TransactionPayment__c updateCTP = null; //getter setting for cc transaction payment record
    public static Map<Id,ccrz__E_TransactionPayment__c> transactionPaymentToUpdate = new Map<Id,ccrz__E_TransactionPayment__c>();
    public static Map<Id,ccrz__E_TransactionPayment__c> transactionPaymentToReset = new Map<Id,ccrz__E_TransactionPayment__c>();
    
    // 1 - Method to update failure status. This will run when there will be failed response or exception from the services. 
    
    public static void updateIntegrationFlag(Set<Id> ctpNew, String serviceName,String operation){
        //AR Invoice or Cedit Memo
        if(serviceName == label.OSM_Bolt_AR_Invoice){
            system.debug('INSIDE');
            system.debug('ctpNew'+ctpNew);
            List<ccrz__E_TransactionPayment__c> updateCTP = [Select OSM_ARInvoice_Integration_Failure__c, OSM_ARInvoice_Failed_Count__c, Transaction_Status__c, Bolt_AR_Call_Status__c, Bolt_Credit_Memo_Call_Status__c from ccrz__E_TransactionPayment__c where id  IN :ctpNew];
            
                for(ccrz__E_TransactionPayment__c ctp :updateCTP){
                    ctp.OSM_ARInvoice_Integration_Failure__c = True;
                    
                    if(ctp.OSM_ARInvoice_Failed_Count__c == null){
                        ctp.OSM_ARInvoice_Failed_Count__c = 1;
                    }else if(ctp.OSM_ARInvoice_Failed_Count__c != null){
                        ctp.OSM_ARInvoice_Failed_Count__c = ctp.OSM_ARInvoice_Failed_Count__c +1;
                    }
                    
                    system.debug('operation'+operation);
                    /*if(operation == 'FailureCases'){
                        if(ctp.Bolt_AR_Call_Status__c == 'Pending' || ctp.Bolt_AR_Call_Status__c == 'Failure'){
                            ctp.Bolt_AR_Call_Status__c = 'Failure';
                        }else if(ctp.Bolt_Credit_Memo_Call_Status__c == 'Pending' || ctp.Bolt_Credit_Memo_Call_Status__c == 'Failure'){
                            ctp.Bolt_Credit_Memo_Call_Status__c = 'Failure';
                        }
                    }else 
                    if(operation != 'FailureCases'){
                        if(operation == 'Order Placed'){
                            if(ctp.Bolt_AR_Call_Status__c == 'Pending' || ctp.Bolt_AR_Call_Status__c == 'Failure'){
                                ctp.Bolt_AR_Call_Status__c = 'Failure';
                            }
                        }else if(operation == 'Order Cancel'){
                            if(ctp.Bolt_Credit_Memo_Call_Status__c == 'Pending' || ctp.Bolt_Credit_Memo_Call_Status__c == 'Failure'){
                                ctp.Bolt_Credit_Memo_Call_Status__c = 'Failure';
                            }
                        }
                    } */                  
                    
                    transactionPaymentToUpdate.put(ctp.id,ctp);
                }
                system.debug('transactionPaymentToReset'+transactionPaymentToReset);                
                update transactionPaymentToUpdate.values();
            }
        
        //Journal Entry or Journal Entry Reversal
        if(serviceName == label.OSM_Bolt_Journal_Entry){
            system.debug('INSIDE');
            system.debug('ctpNew'+ctpNew);          
            List<ccrz__E_TransactionPayment__c> updateCTP = [Select OSM_JournalEntry_Integration_Failure__c, OSM_JournalEntry_Failed_Count__c,  Transaction_Status__c, Bolt_JE_Call_Status__c, Bolt_JE_Reversal_Call_Status__c from ccrz__E_TransactionPayment__c where id  IN :ctpNew];
            
                for(ccrz__E_TransactionPayment__c ctp :updateCTP){
                    ctp.OSM_JournalEntry_Integration_Failure__c = True;
                    
                    if(ctp.OSM_JournalEntry_Failed_Count__c == null){
                        ctp.OSM_JournalEntry_Failed_Count__c = 1;
                    }else if(ctp.OSM_JournalEntry_Failed_Count__c != null){
                        ctp.OSM_JournalEntry_Failed_Count__c = ctp.OSM_JournalEntry_Failed_Count__c +1;
                    }
                    system.debug('operation'+operation);
                                        
                    /*if(operation == 'FailureCases'){
                        if(ctp.Bolt_JE_Call_Status__c == 'Pending' || ctp.Bolt_JE_Call_Status__c == 'Failure'){
                            ctp.Bolt_JE_Call_Status__c = 'Failure';
                        }else if(ctp.Bolt_JE_Reversal_Call_Status__c == 'Pending' || ctp.Bolt_JE_Reversal_Call_Status__c == 'Failure'){
                            ctp.Bolt_JE_Reversal_Call_Status__c = 'Failure';
                        }
                    }else if(operation != 'FailureCases'){
                        if(operation == 'Order Placed'){
                            if(ctp.Bolt_JE_Call_Status__c == 'Pending' || ctp.Bolt_JE_Call_Status__c == 'Failure'){
                                ctp.Bolt_JE_Call_Status__c = 'Failure';
                            }
                        }else if(operation == 'Order Cancel'){
                            if(ctp.Bolt_JE_Reversal_Call_Status__c == 'Pending' || ctp.Bolt_JE_Reversal_Call_Status__c == 'Failure'){
                                ctp.Bolt_JE_Reversal_Call_Status__c = 'Failure';
                            }
                        }
                    }*/
                    
                    transactionPaymentToUpdate.put(ctp.id,ctp);
                }
                system.debug('transactionPaymentToReset'+transactionPaymentToReset);                
                update transactionPaymentToUpdate.values();
            }
        
        //Order Update Flag 
        if(serviceName == label.OSM_DA_Order_Update){
            system.debug('INSIDE');
            List<ccrz__E_TransactionPayment__c> updateCTP = [Select OSM_Order_Update_Integration_Failure__c, OSM_Order_Update_Failed_Count__c from ccrz__E_TransactionPayment__c where id  IN :ctpNew]; 
                
                if(operation == 'DA Order Update'){
                    for(ccrz__E_TransactionPayment__c ctp :updateCTP){
                        ctp.OSM_Order_Update_Integration_Failure__c = True;
                    
                        if(ctp.OSM_Order_Update_Failed_Count__c == null){
                            ctp.OSM_Order_Update_Failed_Count__c = 1;
                        }else if(ctp.OSM_Order_Update_Failed_Count__c != null){
                            ctp.OSM_Order_Update_Failed_Count__c = ctp.OSM_Order_Update_Failed_Count__c +1;
                        }
                        transactionPaymentToUpdate.put(ctp.id,ctp);
                    }   
                } 
                system.debug('transactionPaymentToReset'+transactionPaymentToReset);                
                update transactionPaymentToUpdate.values();
            } 

        //Order Cancellation Flag   
        if(serviceName == label.DA_Order_Cancellation_Service_Name){
            system.debug('INSIDE');
            List<ccrz__E_TransactionPayment__c> updateCTP = [Select OSM_Order_Cancellation_Failure__c, OSM_Order_Cancellation_Failed_Count__c from ccrz__E_TransactionPayment__c where id  IN :ctpNew];
                
                if(operation == 'DA Order Cancellation'){
                    for(ccrz__E_TransactionPayment__c ctp :updateCTP){
                        ctp.OSM_Order_Cancellation_Failure__c = True;
                    
                        if(ctp.OSM_Order_Cancellation_Failed_Count__c == null){
                            ctp.OSM_Order_Cancellation_Failed_Count__c = 1;
                        }else if(ctp.OSM_Order_Cancellation_Failed_Count__c != null){
                            ctp.OSM_Order_Cancellation_Failed_Count__c = ctp.OSM_Order_Cancellation_Failed_Count__c +1;
                        }
                        transactionPaymentToUpdate.put(ctp.id,ctp); 
                    }   
                } 
                system.debug('transactionPaymentToReset'+transactionPaymentToReset);                
                update transactionPaymentToUpdate.values();
            }       
            
    }
        
    // 2 - Method to update success status. This will run when there will be success response or no exception from services used. 
    public static void resetIntegrationFlag(Set<Id> ctpNew, String serviceName,String operation){
        //AR Invoice or Credit Memo
        if(serviceName == label.OSM_Bolt_AR_Invoice){
            system.debug('INSIDE');
            system.debug('ctpNew'+ctpNew);          
            List<ccrz__E_TransactionPayment__c> updateCTP = [Select OSM_ARInvoice_Integration_Failure__c, Transaction_Status__c, Bolt_AR_Call_Status__c, Bolt_Credit_Memo_Call_Status__c from ccrz__E_TransactionPayment__c where id IN :ctpNew];
            for(ccrz__E_TransactionPayment__c ctp :updateCTP){
                ctp.OSM_ARInvoice_Integration_Failure__c = False;
                
                    system.debug('operation'+operation);
                    /*if(operation == 'FailureCases'){
                        if(ctp.Bolt_AR_Call_Status__c == 'Pending' || ctp.Bolt_AR_Call_Status__c == 'Failure'){
                            ctp.Bolt_AR_Call_Status__c = 'Success';
                        }else if(ctp.Bolt_Credit_Memo_Call_Status__c == 'Pending' || ctp.Bolt_Credit_Memo_Call_Status__c == 'Failure'){
                            ctp.Bolt_Credit_Memo_Call_Status__c = 'Success';
                        }
                    }else 
                    if(operation != 'FailureCases'){
                        if(operation == 'Order Placed'){
                            if(ctp.Bolt_AR_Call_Status__c == 'Pending' || ctp.Bolt_AR_Call_Status__c == 'Failure'){
                                ctp.Bolt_AR_Call_Status__c = 'Success';
                            }
                        }else if(operation == 'Order Cancel'){
                            if(ctp.Bolt_Credit_Memo_Call_Status__c == 'Pending' || ctp.Bolt_Credit_Memo_Call_Status__c == 'Failure'){
                                ctp.Bolt_Credit_Memo_Call_Status__c = 'Success';
                            }
                        }
                    }*/
                    
                transactionPaymentToReset.put(ctp.id,ctp);  
            }
            system.debug('transactionPaymentToReset'+transactionPaymentToReset);
            update transactionPaymentToReset.values();
        }
        
        //Journal Entry or Journal Entry Reversal
        if(serviceName == label.OSM_Bolt_Journal_Entry){
            system.debug('INSIDE');
            system.debug('ctpNew'+ctpNew);          
            List<ccrz__E_TransactionPayment__c> updateCTP = [Select OSM_JournalEntry_Integration_Failure__c, Transaction_Status__c, Bolt_JE_Call_Status__c, Bolt_JE_Reversal_Call_Status__c from ccrz__E_TransactionPayment__c where id  IN :ctpNew]; 
            for(ccrz__E_TransactionPayment__c ctp :updateCTP){
                ctp.OSM_JournalEntry_Integration_Failure__c = False;
                
                    system.debug('operation'+operation);
                    /*if(operation == 'FailureCases'){
                        if(ctp.Bolt_JE_Call_Status__c == 'Pending' || ctp.Bolt_JE_Call_Status__c == 'Failure'){
                            ctp.Bolt_JE_Call_Status__c = 'Success';
                    }else if(ctp.Bolt_JE_Reversal_Call_Status__c == 'Pending' || ctp.Bolt_JE_Reversal_Call_Status__c == 'Failure'){
                            ctp.Bolt_JE_Reversal_Call_Status__c = 'Success';
                        }
                    }else if(operation != 'FailureCases'){
                        if(operation == 'Order Placed'){
                            if(ctp.Bolt_JE_Call_Status__c == 'Pending' || ctp.Bolt_JE_Call_Status__c == 'Failure'){
                                ctp.Bolt_JE_Call_Status__c = 'Success';
                            }
                        }else if(operation == 'Order Cancel'){
                            if(ctp.Bolt_JE_Reversal_Call_Status__c == 'Pending' || ctp.Bolt_JE_Reversal_Call_Status__c == 'Failure'){
                                ctp.Bolt_JE_Reversal_Call_Status__c = 'Success';
                            }
                        }
                    }*/
                    
                transactionPaymentToReset.put(ctp.id,ctp);              
            }
            system.debug('transactionPaymentToReset'+transactionPaymentToReset);
            update transactionPaymentToReset.values();
        }
        
        //Order Update Flag
        if(serviceName == label.OSM_DA_Order_Update){
            system.debug('INSIDE');
            List<ccrz__E_TransactionPayment__c> updateCTP = [Select OSM_Order_Update_Integration_Failure__c from ccrz__E_TransactionPayment__c where id  IN :ctpNew];
            
            if(operation == 'DA Order Update'){
                for(ccrz__E_TransactionPayment__c ctp :updateCTP){
                    ctp.OSM_Order_Update_Integration_Failure__c = False;    
                    transactionPaymentToReset.put(ctp.id,ctp);
                }   
            }                 
            update transactionPaymentToReset.values();
        }
        
        
        //Order Cancellation Flag
        if(serviceName == label.DA_Order_Cancellation_Service_Name){
            system.debug('INSIDE');
            List<ccrz__E_TransactionPayment__c> updateCTP = [Select OSM_Order_Cancellation_Failure__c from ccrz__E_TransactionPayment__c where id  IN :ctpNew];   
            
            if(operation == 'DA Order Cancellation'){
                for(ccrz__E_TransactionPayment__c ctp :updateCTP){
                    ctp.OSM_Order_Cancellation_Failure__c = False;
                    transactionPaymentToReset.put(ctp.id,ctp);
                }   
            }           
            update transactionPaymentToReset.values();
        }
        
    }
    
    
    public static void updateIntegrationFlag(Map<Id, Decimal> ctpNew, String serviceName,String operation){
        //AR Invoice or Cedit Memo
        if(serviceName == label.OSM_Bolt_AR_Invoice){
            system.debug('INSIDE');
            system.debug('ctpNew'+ctpNew);
            List<ccrz__E_TransactionPayment__c> updateCTP = [Select Id, OSM_ARInvoice_Integration_Failure__c, OSM_ARInvoice_Failed_Count__c, Transaction_Status__c, Bolt_AR_Call_Status__c, Bolt_Credit_Memo_Call_Status__c, AR_Amount__c from ccrz__E_TransactionPayment__c where id  IN :ctpNew.keySet()];
            
            for(ccrz__E_TransactionPayment__c ctp :updateCTP){
                ctp.OSM_ARInvoice_Integration_Failure__c = True;
                
                if(ctp.OSM_ARInvoice_Failed_Count__c == null){
                    ctp.OSM_ARInvoice_Failed_Count__c = 1;
                }else if(ctp.OSM_ARInvoice_Failed_Count__c != null){
                    ctp.OSM_ARInvoice_Failed_Count__c = ctp.OSM_ARInvoice_Failed_Count__c +1;
                }
                
                system.debug('operation'+operation);
                if(operation == 'FailureCases'){
                    if(ctp.Bolt_AR_Call_Status__c == 'Pending' || ctp.Bolt_AR_Call_Status__c == 'Failure'){
                        ctp.Bolt_AR_Call_Status__c = 'Failure';
                        //ctp.AR_Amount__c = ctpNew.get(ctp.Id);
                    }else if(ctp.Bolt_Credit_Memo_Call_Status__c == 'Pending' || ctp.Bolt_Credit_Memo_Call_Status__c == 'Failure'){
                        ctp.Bolt_Credit_Memo_Call_Status__c = 'Failure';
                    }
                }else if(operation != 'FailureCases'){
                    if(operation == 'Order Placed'){
                        if(ctp.Bolt_AR_Call_Status__c == 'Pending' || ctp.Bolt_AR_Call_Status__c == 'Failure'){
                            ctp.Bolt_AR_Call_Status__c = 'Failure';
                            //ctp.AR_Amount__c = ctpNew.get(ctp.Id);
                        }
                    }else if(operation == 'Order Cancel'){
                        if(ctp.Bolt_Credit_Memo_Call_Status__c == 'Pending' || ctp.Bolt_Credit_Memo_Call_Status__c == 'Failure'){
                            ctp.Bolt_Credit_Memo_Call_Status__c = 'Failure';
                        }
                    }
                }                   
                
                transactionPaymentToUpdate.put(ctp.id,ctp);
            }
            system.debug('transactionPaymentToReset'+transactionPaymentToReset);                
            update transactionPaymentToUpdate.values();
        }
        
        //Journal Entry or Journal Entry Reversal
        if(serviceName == label.OSM_Bolt_Journal_Entry){
            system.debug('INSIDE');
            system.debug('ctpNew'+ctpNew);          
            List<ccrz__E_TransactionPayment__c> updateCTP = [Select Id, OSM_JournalEntry_Integration_Failure__c, OSM_JournalEntry_Failed_Count__c,  Transaction_Status__c, Bolt_JE_Call_Status__c, Bolt_JE_Reversal_Call_Status__c, JE_Batch_Amount__c from ccrz__E_TransactionPayment__c where id  IN :ctpNew.keySet()];
            
            for(ccrz__E_TransactionPayment__c ctp :updateCTP){
                ctp.OSM_JournalEntry_Integration_Failure__c = True;
                
                if(ctp.OSM_JournalEntry_Failed_Count__c == null){
                    ctp.OSM_JournalEntry_Failed_Count__c = 1;
                }else if(ctp.OSM_JournalEntry_Failed_Count__c != null){
                    ctp.OSM_JournalEntry_Failed_Count__c = ctp.OSM_JournalEntry_Failed_Count__c +1;
                }
                system.debug('operation'+operation);
                                    
                if(operation == 'FailureCases'){
                    if(ctp.Bolt_JE_Call_Status__c == 'Pending' || ctp.Bolt_JE_Call_Status__c == 'Failure'){
                        ctp.Bolt_JE_Call_Status__c = 'Failure';
                        //ctp.JE_Batch_Amount__c = ctpNew.get(ctp.Id);
                    }else if(ctp.Bolt_JE_Reversal_Call_Status__c == 'Pending' || ctp.Bolt_JE_Reversal_Call_Status__c == 'Failure'){
                        ctp.Bolt_JE_Reversal_Call_Status__c = 'Failure';
                    }
                }else if(operation != 'FailureCases'){
                    if(operation == 'Order Placed'){
                        if(ctp.Bolt_JE_Call_Status__c == 'Pending' || ctp.Bolt_JE_Call_Status__c == 'Failure'){
                            ctp.Bolt_JE_Call_Status__c = 'Failure';
                            //ctp.JE_Batch_Amount__c = ctpNew.get(ctp.Id);
                        }
                    }else if(operation == 'Order Cancel'){
                        if(ctp.Bolt_JE_Reversal_Call_Status__c == 'Pending' || ctp.Bolt_JE_Reversal_Call_Status__c == 'Failure'){
                            ctp.Bolt_JE_Reversal_Call_Status__c = 'Failure';
                        }
                    }
                }
                
                transactionPaymentToUpdate.put(ctp.id,ctp);
            }
            system.debug('transactionPaymentToReset'+transactionPaymentToReset);                
            update transactionPaymentToUpdate.values();
        }
    }
            
    
    public static void resetIntegrationFlag(Map<Id, Decimal> ctpNew, String serviceName,String operation){
        //AR Invoice or Credit Memo
        if(serviceName == label.OSM_Bolt_AR_Invoice){
            system.debug('INSIDE');
            system.debug('ctpNew'+ctpNew);          
            List<ccrz__E_TransactionPayment__c> updateCTP = [Select Id, OSM_ARInvoice_Integration_Failure__c, Transaction_Status__c, Bolt_AR_Call_Status__c, Bolt_Credit_Memo_Call_Status__c, AR_Amount__c from ccrz__E_TransactionPayment__c where id IN :ctpNew.keySet()];
            for(ccrz__E_TransactionPayment__c ctp :updateCTP){
                ctp.OSM_ARInvoice_Integration_Failure__c = False;
                
                    system.debug('operation'+operation);
                    if(operation == 'FailureCases'){
                        if(ctp.Bolt_AR_Call_Status__c == 'Pending' || ctp.Bolt_AR_Call_Status__c == 'Failure'){
                            ctp.Bolt_AR_Call_Status__c = 'Success';
                            ctp.AR_Amount__c = ctpNew.get(ctp.Id);
                        }else if(ctp.Bolt_Credit_Memo_Call_Status__c == 'Pending' || ctp.Bolt_Credit_Memo_Call_Status__c == 'Failure'){
                            ctp.Bolt_Credit_Memo_Call_Status__c = 'Success';
                        }
                    }else if(operation != 'FailureCases'){
                        if(operation == 'Order Placed'){
                            if(ctp.Bolt_AR_Call_Status__c == 'Pending' || ctp.Bolt_AR_Call_Status__c == 'Failure'){
                                ctp.Bolt_AR_Call_Status__c = 'Success';
                                ctp.AR_Amount__c = ctpNew.get(ctp.Id);
                            }
                        }else if(operation == 'Order Cancel'){
                            if(ctp.Bolt_Credit_Memo_Call_Status__c == 'Pending' || ctp.Bolt_Credit_Memo_Call_Status__c == 'Failure'){
                                ctp.Bolt_Credit_Memo_Call_Status__c = 'Success';
                            }
                        }
                    }
                    
                transactionPaymentToReset.put(ctp.id,ctp);  
            }
            system.debug('transactionPaymentToReset'+transactionPaymentToReset);
            update transactionPaymentToReset.values();
        }
        
        //Journal Entry or Journal Entry Reversal
        if(serviceName == label.OSM_Bolt_Journal_Entry){
            system.debug('INSIDE');
            system.debug('ctpNew'+ctpNew);          
            List<ccrz__E_TransactionPayment__c> updateCTP = [Select Id, OSM_JournalEntry_Integration_Failure__c, Transaction_Status__c, Bolt_JE_Call_Status__c, Bolt_JE_Reversal_Call_Status__c, JE_Batch_Amount__c from ccrz__E_TransactionPayment__c where id  IN :ctpNew.keySet()]; 
            for(ccrz__E_TransactionPayment__c ctp :updateCTP){
                ctp.OSM_JournalEntry_Integration_Failure__c = False;
                
                    system.debug('operation'+operation);
                    if(operation == 'FailureCases'){
                        if(ctp.Bolt_JE_Call_Status__c == 'Pending' || ctp.Bolt_JE_Call_Status__c == 'Failure'){
                            ctp.Bolt_JE_Call_Status__c = 'Success';
                            ctp.JE_Batch_Amount__c = ctpNew.get(ctp.Id);
                    }else if(ctp.Bolt_JE_Reversal_Call_Status__c == 'Pending' || ctp.Bolt_JE_Reversal_Call_Status__c == 'Failure'){
                            ctp.Bolt_JE_Reversal_Call_Status__c = 'Success';
                        }
                    }else if(operation != 'FailureCases'){
                        if(operation == 'Order Placed'){
                            if(ctp.Bolt_JE_Call_Status__c == 'Pending' || ctp.Bolt_JE_Call_Status__c == 'Failure'){
                                ctp.Bolt_JE_Call_Status__c = 'Success';
                                ctp.JE_Batch_Amount__c = ctpNew.get(ctp.Id);
                            }
                        }else if(operation == 'Order Cancel'){
                            if(ctp.Bolt_JE_Reversal_Call_Status__c == 'Pending' || ctp.Bolt_JE_Reversal_Call_Status__c == 'Failure'){
                                ctp.Bolt_JE_Reversal_Call_Status__c = 'Success';
                            }
                        }
                    }
                    
                transactionPaymentToReset.put(ctp.id,ctp);              
            }
            system.debug('transactionPaymentToReset'+transactionPaymentToReset);
            update transactionPaymentToReset.values();
        }
    }
}