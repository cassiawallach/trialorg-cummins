/***********************************************************************************************
Name:FSL_NationalAccountMessage
==============================================================================================
==============================================================================================
Purpose:                                                            
-------  
This class is to display National Account message for BMS Users
==============================================================================================
==============================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE                                   
1.0         Vijay                    12/8/2020                         
************************************************************************************************/ 
public class FSL_NationalAccountMessage {
    @AuraEnabled
    public static workOrderWrp getWorkOrderData(String workOrderId) {
        workOrderWrp wrapper = new workOrderWrp();
        List<WorkOrder> workOrderList = [SELECT Id, Account.National_Account__c, Account.National_Account_Message__c
                                         FROM WorkOrder WHERE Id=: workOrderId];
        if(workOrderList.size() > 0){
            wrapper.sObjectList = workOrderList;
        }
        return wrapper;
    }
    
    public class workOrderWrp {
        @AuraEnabled public List<SObject> sObjectList {get;set;}
        
        public workOrderWrp() {
            sObjectList = new List<SObject>();
        }
    } 
}