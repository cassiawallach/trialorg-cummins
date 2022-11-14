public class FSL_CL_UpdateAssetDetails { 
    @AuraEnabled
    public static void updateAssetDetails (String serviceReqId) { 
        
        List<WorkOrder> serOrdListToUpdt = new List<WorkOrder>(); 
        List<FSL_IA_FC__c> IArecList = new List<FSL_IA_FC__c>();
        
        for (Case cs : [SELECT Id, AssetId, Service_Model__c, IAS_Number__c, Make__c, Model__c, 
                        Product_Mileage__c, Product_Mileage_Unit__c, Product_Hours__c, 
                        (SELECT Id FROM WorkOrders) 
                        FROM Case WHERE Id=:serviceReqId]) {
                            for (WorkOrder serOrd : cs.WorkOrders) {
                                serOrd.AssetId = cs.AssetId;
                                serOrd.Service_Model__c = cs.Service_Model__c;
                                serOrd.Make__c = cs.Make__c;
                                serOrd.Model__c = cs.Model__c;
                                serOrd.IAS_Number__c = cs.IAS_Number__c;
                                /*if(cs.Product_Mileage__c != null) {
                                    serOrd.Mileage__c  = cs.Product_Mileage__c;
                                }
                                
                               // serOrd.Mileage_Measure__c  = cs.Product_Mileage_Unit__c;  added new comment for test class
                                if(cs.Product_Hours__c != null) {
                                    serOrd.CSS_Hours__c  = cs.Product_Hours__c;
                                }*/
                                
                                List<FSL_IA_FC__c> IaRecords =[SELECT Id, Name, Fault_Code_Type__c, Prioritized_FC_SO__c, Non_Prioritized_FC_SO__c, 
                                                               UnPrioritized_FC_SR__c, Prioritized_FC_SR__c 
                                                               FROM FSL_IA_FC__c 
                                                               WHERE Prioritized_FC_SR__c =: serviceReqId 
                                                               OR UnPrioritized_FC_SR__c =: serviceReqId];
                                for(FSL_IA_FC__c iaRec:IaRecords) {
                                    if(iaRec.Fault_Code_Type__c == 'Primary' || iaRec.Fault_Code_Type__c == 'Related') {
                                        iaRec.Prioritized_FC_SO__c = serOrd.Id;
                                        IArecList.add(iaRec);
                                    }
                                    if(iaRec.Fault_Code_Type__c == 'Non Prioritized') {
                                        iaRec.Non_Prioritized_FC_SO__c = serOrd.Id;
                                        IArecList.add(iaRec);
                                    }
                                }
                                serOrdListToUpdt.add(serOrd);
                            }
                        }
        update IArecList;
        update serOrdListToUpdt;
        
        Case cs = new Case(Id = serviceReqId);
        cs.IsAssetDetUpdated__c = true;
        update cs;
    }
    
    @AuraEnabled
    public static WorkOrder fetchServiceOrder (String serviceReqId) {             
        for (Case cs : [SELECT Id, AssetId, Service_Model__c, IAS_Number__c, Make__c, Model__c, 
                        Product_Mileage__c, Product_Mileage_Unit__c, Product_Hours__c, 
                        (SELECT Id, AssetId FROM WorkOrders) 
                        FROM Case WHERE Id=:serviceReqId]) {
                            if(NULL != cs.WorkOrders && !cs.WorkOrders.isEmpty()) {
                                return cs.WorkOrders.get(0);
                            }                                
                        }
        return new WorkOrder();
    }
}