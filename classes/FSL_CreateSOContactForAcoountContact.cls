public class FSL_CreateSOContactForAcoountContact { 
    
    //Below methods is to insert records into Communication Object based on the service order Acoount Contact
    public static Boolean isSOCInsert=false;
    @InvocableMethod(label='CreateserviceOrderContactForAcoountContact' description='CreateserviceOrderContactForAcoountContact' category='WorkOrder')
    //public static void insertServiceOrderContactList(List<workOrder> newWOs){
   public static List<workOrder> insertServiceOrderContactList(List<workOrder> newWOs){
      /* for(ServiceOrderContact__c  LstSoc:[select id,Is_Inserted_Account_contact_del__c from ServiceOrderContact__c where Is_Inserted_Account_contact_del__c =true]){
                 ServiceOrderContact__c socObj = new ServiceOrderContact__c();
               
                update LstSoc;
            }*/
      
            
        Set<Id> payerConList = new Set<Id>();
        Set<Id> WOIds = new Set<Id>();
        
        List<ServiceOrderContact__c> insertSOCList = new List<ServiceOrderContact__c>();
        if(newWOs != null){
           for(workOrder wo:newWOs){
                WOIds.add(wo.Id);
            }
            for(ServiceOrderContact__c soc : [select id, name, Payer_Contact__c, Payer_Contact__r.Name from ServiceOrderContact__c where Service_Order__c IN: WOIds]){
                if(soc.Payer_Contact__c != null){
                    payerConList.add(soc.Payer_Contact__c);
                }           
            }
           
      
        
        
        if(newWOs != null && newWOs.size()>0){            
            for(WorkOrder wo : newWOs){
               // if(wo.Payer_ContactID__c != null){
                   // if(payerConList == null || (!payerConList.contains(wo.Payer_contactId__c))) {
                        
                        ServiceOrderContact__c socObj = new ServiceOrderContact__c();
                        
                        socObj.Payer_Account__c = wo.Payer__c;
                        socObj.Account__c = wo.AccountId; // As part of stroy CT4-98                       
                        socObj.Payer_Contact__c = wo.ContactID;
                        socObj.Service_Order__c = wo.Id;
                        socObj.Payer_Contact_Flag__c = true;
                        socObj.Opt_In__c= false;
                        socObj.Is_Inserted_Account_contact_del__c =true;
                        insertSOCList.add(socObj);
                   // }
                //}
            } 
            insert insertSOCList ;
           
             
        }
      /*  if(insertSOCList != null && insertSOCList.size()>0){
            if(!isSOCInsert){
                insert(insertSOCList);
                isSOCInsert=true;
            }               
        }*/
       
    } 
     return null;    
 }
 }