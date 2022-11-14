/**********************************************************************
Name: FSL_serviceOrderContactTriggerHandler
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Arpita Sarangee      06/08/2020      INITIAL DEVELOPMENT                     
***********************************************************************/
public class FSL_serviceOrderContactTriggerHandler {
    
    public static Boolean isSOCInsert=false;
    public static Boolean isoptin=false;

    
    
    public static void insertServiceOrderContactList(List<ServiceOrderContact__c> newSOCs){
        //Vijay Mudam CT4-98 optiIn checkbox must be checked start
        
       // Set<Id> newSOCsallInsertedIds = trigger.newMap.keySet();
       // system.debug('allInsertedIds '+newSOCsallInsertedIds );
       
        
        set<id> conIds=new set<Id>();
        set<id> soIds=new set<Id>();
        for(ServiceOrderContact__c soc:newSOCs){
            if(soc.Payer_Contact__c != null){
                    conIds.add(soc.Payer_Contact__c);
                } 
            if(soc.Service_Order__c != null)
                soIds.add(soc.Service_Order__c);
        }
        
        String payerContactError = System.Label.FSL_Duplicate_Payer_Error;
        
        map<Id,contact> ConAccountMap=new map<Id,contact>([select id,AccountId from contact where Id in: conIds]);
                map<Id,WorkOrder> soMap=new map<Id,WorkOrder>([select id,ContactId from WorkOrder where Id in: soIds]);
        
        for(ServiceOrderContact__c soc:newSOCs){
            if(soc.Payer_Contact__c != null && ConAccountMap.containskey(soc.Payer_Contact__c)){
                if(ConAccountMap.get(soc.Payer_Contact__c).AccountId == soc.Account__c && soMap.get(soc.Service_Order__c).ContactId == soc.Payer_Contact__c && soc.Payer_Contact_Flag__c == True)
                    soc.Opt_In__c=True;
                // soc.IsOptinTrue__c= True;
                else if((ConAccountMap.get(soc.Payer_Contact__c).AccountId == soc.Account__c || ConAccountMap.get(soc.Payer_Contact__c).AccountId == soc.Payer_Account__c) && soc.Payer_Contact_Flag__c == false)
                    soc.Opt_In__c=True;                                        
                else
                    soc.Opt_In__c=False;
            }            
        } 
        //Vijay Mudam CT4-98 optIn checkbox must be checked end
        Set<Id> WOIds = new Set<Id>();
        Set<Id> payerConId = new Set<Id>();
        List<ServiceOrderContact__c> insertSOCList = new List<ServiceOrderContact__c>();
        if(newSOCs != null){
            for(ServiceOrderContact__c soc:newSOCs){
                WOIds.add(soc.Service_Order__c);
            }
        }
        if(WOIds != null){
            for(ServiceOrderContact__c soc : [select id, name, Payer_Account__c, Payer_Contact__c, Payer_Contact__r.Name from ServiceOrderContact__c where Service_Order__c IN: WOIds]){
                if(soc.Payer_Contact__c != null){
                    payerConId.add(soc.Payer_Contact__c);
                }           
            }
        }
        system.debug('payerConId***'+payerConId);
        if(newSOCs != null && newSOCs.size()>0){            
            for(ServiceOrderContact__c soc : newSOCs){
                system.debug('soc.Payer_Contact__c****'+soc.Payer_Contact__c);
                if(soc.Payer_Contact__c != null){
                    if(payerConId == null || !payerConId.contains(soc.Payer_Contact__c)) {
                        system.debug('inside111***');
                        ServiceOrderContact__c socObj = new ServiceOrderContact__c();
                        socObj.Payer_Account__c = soc.Payer_Account__c;
                        socObj.Payer_Contact__c = soc.Payer_Contact__c;
                        socObj.Service_Order__c = soc.Service_Order__c;
                        socObj.Payer_Contact_Flag__c = true;
                        socObj.Opt_In__c =True;
                        
                        insertSOCList.add(socObj);
                    }
                    else{
                        soc.addError(payerContactError);
                    }
                }
            }
        }
        if(insertSOCList != null && insertSOCList.size()>0){
            if(!isSOCInsert){
                insert(insertSOCList);
            }               
        }
    }
        public static void insertServiceOrderContactListUpdate(List<ServiceOrderContact__c> newSOCs,Map<Id,ServiceOrderContact__c> oldSOCMap){
        
       // Set<Id> newSOCsallInsertedIds = trigger.newMap.keySet();
       // system.debug('allInsertedIds '+newSOCsallInsertedIds );
        
        set<id> conIds=new set<Id>();
        set<id> soIds=new set<Id>();
        for(ServiceOrderContact__c soc:newSOCs){
            if(soc.Payer_Contact__c != null){
                    conIds.add(soc.Payer_Contact__c);
                } 
            if(soc.Service_Order__c != null)
                soIds.add(soc.Service_Order__c);
     
                
        }
        map<Id,contact> ConAccountMap=new map<Id,contact>([select id,AccountId from contact where Id in: conIds]);
                map<Id,WorkOrder> soMap=new map<Id,WorkOrder>([select id,ContactId from WorkOrder where Id in: soIds]);
        Set<Id> WOIds = new Set<Id>();
        Set<Id> payerConId = new Set<Id>();
        List<ServiceOrderContact__c> insertSOCList = new List<ServiceOrderContact__c>();
        if(newSOCs != null){
            for(ServiceOrderContact__c soc:newSOCs){
                WOIds.add(soc.Service_Order__c);
            }
        }
        if(WOIds != null){
            for(ServiceOrderContact__c soc : [select id, name, Payer_Account__c, Payer_Contact__c, Payer_Contact__r.Name from ServiceOrderContact__c where Service_Order__c IN: WOIds]){
                if(soc.Payer_Contact__c != null){
                    payerConId.add(soc.Payer_Contact__c);
                }           
            }
        }
        system.debug('payerConId***'+payerConId);
        if(newSOCs != null && newSOCs.size()>0){            
            for(ServiceOrderContact__c soc : newSOCs){
                system.debug('soc.Payer_Contact__c****'+soc.Payer_Contact__c);
                if(soc.Payer_Contact__c != null){
                    if(payerConId == null || !payerConId.contains(soc.Payer_Contact__c)) {
                        system.debug('inside111***');
                        ServiceOrderContact__c socObj = new ServiceOrderContact__c();
                        socObj.Payer_Account__c = soc.Payer_Account__c;
                        socObj.Payer_Contact__c = soc.Payer_Contact__c;
                        socObj.Service_Order__c = soc.Service_Order__c;
                        socObj.Payer_Contact_Flag__c = true;
                        socObj.Opt_In__c =True;
                        
                        insertSOCList.add(socObj);
                    }
                    else{
                        System.debug('new value    '+soc.Opt_In__c);
                        System.debug('old value    '+oldSOCMap.get(soc.id).Opt_In__c);
                        /*if(!(soc.Opt_In__c == oldSOCMap.get(soc.id).Opt_In__c)){
                            return; 
                        }
                        soc.addError('Payer Contact already exists');*/
                        if((soc.Opt_In__c == oldSOCMap.get(soc.id).Opt_In__c) && ((soc.Service_Order__c != oldSOCMap.get(soc.id).Service_Order__c ) || (soc.Payer_Account__c != oldSOCMap.get(soc.id).Payer_Account__c ) || (soc.Account__c != oldSOCMap.get(soc.id).Account__c) || (soc.Payer_Contact__c!= oldSOCMap.get(soc.id).Payer_Contact__c))){
                            soc.addError('Payer Contact already exists');
                        }
                       
                      
                    }
                }
            }
        }
        if(insertSOCList != null && insertSOCList.size()>0){
            if(!isSOCInsert){
                Insert(insertSOCList);
            }               
        }
    }

    public static void ServiceOrderContactAfterInsert(List<ServiceOrderContact__c> newSOCs){
        Set<Id> set_OrderId = new Set<Id>();
        Set<Id> set_ServiceContactId = new Set<Id>();
        for(ServiceOrderContact__c serviceCont : newSOCs){
            if(serviceCont.Service_Order__c != null){
                set_OrderId.add(serviceCont.Service_Order__c);
                set_ServiceContactId.add(serviceCont.Payer_Contact__c );
            }
        }
        //Added by Vijay
        for(WorkOrder wo:[select id,ContactId from WorkOrder where Id in: set_OrderId]){
                set_ServiceContactId.add(wo.ContactId); 
        }//Added by Vijay

        if(set_OrderId.size() > 0){
        
         
            List<ServiceOrderContact__c> list_ServiceContactToUpdate = new List<ServiceOrderContact__c>();
            for(ServiceOrderContact__c serCont : [SELECT Id,Payer_Contact__c ,Is_Inserted_Account_contact_del__c ,Opt_In__c,Payer_Contact_Flag__c  FROM ServiceOrderContact__c 
                                                    WHERE Service_Order__c IN :set_OrderId AND Payer_Contact__c NOT IN : set_ServiceContactId]){
              
               
               if (serCont.Is_Inserted_Account_contact_del__c == True){
                    if(serCont.Opt_In__c) {
                        serCont.Opt_In__c = false;
                        list_ServiceContactToUpdate.add(serCont);
                    }
                    
                }
              
            }
            if(list_ServiceContactToUpdate.size() > 0){
                Database.update(list_ServiceContactToUpdate, false);
            }
                     
        }
    } 


}