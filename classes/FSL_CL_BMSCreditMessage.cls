/***********************************************************************************************
Name:FSL_CL_BMSCreditMessage
==============================================================================================
==============================================================================================
Purpose:                                                            
-------  
This class is to display Customer Credit message for BMS Users
==============================================================================================
==============================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE                                   
1.0         PiyushR                    03/26/2019                         
************************************************************************************************/ 
public class FSL_CL_BMSCreditMessage {
	@AuraEnabled
    public static payerWrapper getPayerDetails(String workOrderId) {
        payerWrapper wrapper = new payerWrapper();
        List<WorkOrder> workOrderList = [SELECT Id, Payer__c, Payer__r.Name, Payer__r.PaymentType__c, Payer__r.BMSAvailableCredit__c,
                                         Payer__r.FSL_Amount_Due__c, Payer__r.FSL_Credit_Limit__c FROM WorkOrder where Payer__r.PaymentType__c = 'Charge' AND Id=: workOrderId];
        if(workOrderList.size() > 0){
            wrapper.paymentType = workOrderList[0].Payer__r.PaymentType__c;
            wrapper.avilableCredit = string.valueOf(workOrderList[0].Payer__r.BMSAvailableCredit__c);
            wrapper.dueAmount = string.valueOf(workOrderList[0].Payer__r.FSL_Amount_Due__c);
            wrapper.creditLimit = string.valueOf(workOrderList[0].Payer__r.FSL_Credit_Limit__c);
        } else {
            wrapper.paymentType = '';
            wrapper.avilableCredit = '';
            wrapper.dueAmount = '';
            wrapper.creditLimit = '';
        }
        
        return wrapper;
    }
    
    public class payerWrapper {
        @AuraEnabled public String paymentType{get;set;}
        @AuraEnabled public String avilableCredit{get;set;}
        @AuraEnabled public String dueAmount{get;set;}
        @AuraEnabled public String creditLimit{get;set;}
    } 
}