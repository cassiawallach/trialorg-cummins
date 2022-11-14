trigger CMI_AccountTrigger  on Account (before insert,after Update,after insert,before Update) {
    System.debug('Prinitng trigger context is before'+Trigger.isBefore);
    System.debug('Prinitng trigger context is After'+Trigger.isAfter);
    System.debug('Prinitng trigger context is insert'+Trigger.isInsert);
    System.debug('Prinitng trigger context is Update'+Trigger.isUpdate);

   new IAM_AccountTriggerHandlerNew().run();
   
    /* List<Account> acntNew= new List<Account>();
    
    for(Account acnt:Trigger.New){
        if(acnt.RecordTypeId==Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId()||acnt.RecordtypeId==Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId()){
            acntNew.add(acnt);
        }
    }
    
    if(!acntNew.isEmpty()){
        List<IAM_Trigger_Switches__mdt> triggerSwitch=[select id,IAM_Active__c,Label from IAM_Trigger_Switches__mdt where Label='IAM_Account_Trigger_Switch'];  
        if(triggerSwitch[0].IAM_Active__c){
            
            //Logic for Trigger Insert      
            if(Trigger.isInsert){
                List<Account> TriggerNewInsert= new List<Account>();
                for(Account a:Trigger.New){
                    if(a.RecordTypeId==Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId()||a.RecordtypeId==Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId()){
                        TriggerNewInsert.add(a);
                    }
                }
                if(Trigger.isAfter){
                    if(!TriggerNewInsert.isEmpty()){
                        IAM_Account_Trigger_Handler.onAfterInsert(TriggerNewInsert);
                        IAM_CopyHQSubsciptionsOnCIHRLocation.copyHQLocationAppsonCIHR(TriggerNewInsert, true, null, null);
                        IAM_Account_Trigger_Handler.createOsmSubcripcritiondefault(TriggerNewInsert); //Nishant Verma D-3265 OSM
                    }
                }
            }
            
            //Logic For Trigger Update
            if(Trigger.isUpdate){
                List<Account> TriggerNewUpdate= new List<Account>();
                Map<id,Account> TriggerNewMapUpdate= new Map<id,Account>();
                List<Account> TriggerOldUpdate= new List<Account>();
                Map<id,Account> TriggerOldMapUpdate= new Map<id,Account>();
                map<id,Boolean> isActiveAccMap=new map<id,Boolean> ();
                map<id,Account> tableidMap=new map<id,Account> ();
                Set<id> setDeactiveids=new Set<id> ();
                map<id,Account> tabledeactivateidMap=new map<id,Account> ();
                
                for(Account a:Trigger.New){
                    if(a.RecordTypeID==Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId()||a.RecordTypeId==Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId()){
                        TriggerNewUpdate.add(a);
                        TriggerNewMapUpdate.put(a.id,a);
                        if(Trigger.oldMap.get(a.Id).CMI_Account_Status__c!=a.CMI_Account_Status__c){
                            if( a.CMI_Account_Status__c=='Active')
                            {
                                isActiveAccMap.put(a.id,true);
                                tableidMap.put(a.id,a);
                            }
                            else if( a.CMI_Account_Status__c=='Inactive')
                            {
                                setDeactiveids.add(a.id);
                                tabledeactivateidMap.put(a.id,a);
                            }
                            //LstAccIds.add(objAcc.id);
                        }
                    }
                }
                
                for(account aOld:Trigger.Old){
                    if(aOld.RecordtypeId==Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId()||aOld.RecordTypeId==Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId()){
                        TriggerOldUpdate.add(aOld);
                        TriggerOldMapUpdate.put(aOld.id,aOld);
                    }
                }   
                
                if(Trigger.isAfter){
                    if(isActiveAccMap.size()>0)
                    {
                        list<contact> lstCont=[select email,FirstName,LastName,AccountId,CMI_TableauId__c,Username__c,CMI_Contact_Type__c from contact where AccountId=:isActiveAccMap.keyset() and CMI_Contact_Type__c='Primary' and Account.Recordtype.Name='IAM'];
                        if(lstCont!=null && lstCont.size()>0){
                            CMI_CreateUsersHelper.CreateUsers(lstCont,isActiveAccMap,tableidMap,true,'CMI_AccountTrigger');
                            Account ObjAcc = tableidMap.get(lstCont[0].AccountId);
                            system.debug('ObjAcc======'+ObjAcc);
                            system.debug('ObjAcc.CMI_Account_Status__c======'+ObjAcc.CMI_Account_Status__c);
                            if(ObjAcc.CMI_Account_Status__c=='Active')
                            {
                                CMI_CreateUsersHelper.sendmails(ObjAcc.id,lstCont[0].id,ObjAcc.CMI_Cummins_Support_Email__c,'CMI_SupportActivate',true);
                                //CMI_CreateUsersHelper.sendmails(ObjAcc.id,lstCont[0].id,ObjAcc.CMI_Cummins_Support_Email__c,'CMI_BCC_Email',true);
                            }
                            if(ObjAcc.CMI_Account_Status__c=='Inactive')
                            {
                                CMI_CreateUsersHelper.sendmails(ObjAcc.id,lstCont[0].id,ObjAcc.CMI_Cummins_Support_Email__c,'CMI_SupportDeactivate',false);
                                
                            }
                        }
                        
                        
                    }
                    if(setDeactiveids.size()>0)
                    {
                        list<contact> lstCont=[select email,FirstName,LastName,AccountId from contact where AccountId=:setDeactiveids and CMI_Contact_Type__c= 'Primary'and Account.Recordtype.Name='IAM'];
                        if(!lstCont.isEmpty()){
                            Account ObjAcc = tabledeactivateidMap.get(lstCont[0].AccountId);         
                            if(ObjAcc.CMI_Account_Status__c=='Inactive')
                            {
                                CMI_CreateUsersHelper.sendmails(ObjAcc.id,lstCont[0].id,ObjAcc.CMI_Cummins_Support_Email__c,'CMI_SupportDeactivate',false);
                            }   
                        }                     
                    }
                    if(!TriggerNewUpdate.isEmpty()){
                        IAM_Account_Trigger_Handler.onAfterUpdate(TriggerNewUpdate,TriggerOldUpdate,TriggerNewMapUpdate,TriggerNewMapUpdate);
                        IAM_CopyHQSubsciptionsOnCIHRLocation.copyHQLocationAppsOnCIHR(TriggerNewUpdate, false, TriggeroldMapUpdate, TriggernewMapUpdate);
                    }
                    
                    //OSM Logic
                    if(Trigger.isafter){
                        
                        if(Trigger.IsUpdate){
                            
                            Map<Id,Account> accWithChangedAddressMap = new Map<Id,Account>();
                            for(Id accId :trigger.newMap.keySet())
                            {
                                Account newAcc =  trigger.newMap.get(accId);
                                Account oldAcc =  trigger.oldMap.get(accId);
                                
                                if(oldAcc.BillingStreet!=oldAcc.BillingStreet || oldAcc.BillingCity!= newAcc.BillingCity ||  oldAcc.BillingState!=newAcc.BillingState ||oldAcc.BillingPostalCode!= newAcc.BillingPostalCode ||  oldAcc.BillingCountry!=newAcc.BillingCountry)
                                {
                                    accWithChangedAddressMap.put(accId,newAcc);
                                }
                                
                            }
                            System.debug('======Account===='+accWithChangedAddressMap);
                            if(accWithChangedAddressMap.size()>0){
                                // CMI_AccountTriggerHandler.updateAccountAddressInOSMAddressBook(accWithChangedAddressMap,'Update');
                            }
                            
                            
                            /* Start - Added by Vineet on 31st-Aug-2018 to Share Quore records to changed Salesuser and respective manager*/
                            //CMI_AccountTrigger
                           /* if(Trigger.IsUpdate){
                                
                                Map<Id,Account> accWithChangedSalesRep = new Map<Id,Account>();
                                Map<String,String>NewtoOldSalesRep = new Map<String, String>();
                                Map<String,String>oldtoNewSalesRep = new Map<String, String>();
                                Set<String>accounts = new Set<String>();
                                for(Account newAccount :trigger.new)
                                {
                                    Account oldAccount = trigger.oldMap.get(newAccount.Id);
                                    if(newAccount.IAM_Cummins_Support_User__c != null && oldAccount.IAM_Cummins_Support_User__c != null 
                                       && newAccount.IAM_Cummins_Support_User__c != oldAccount.IAM_Cummins_Support_User__c ){
                                           
                                           oldtoNewSalesRep.put(oldAccount.IAM_Cummins_Support_User__c,newAccount.IAM_Cummins_Support_User__c);
                                           NewtoOldSalesRep.put(newAccount.IAM_Cummins_Support_User__c, oldAccount.IAM_Cummins_Support_User__c);
                                           accounts.add(newAccount.Id);
                                       }
                                    
                                }
                                
                                if(!NewtoOldSalesRep.isEmpty() && !oldtoNewSalesRep.isEmpty()){
                                    // Changed Quote sharing to new salesrep
                                    //CMI_AccountTriggerHandler.changeQuoteSharing(OldtoNewSalesRep, newToOldSalesrep,accounts);
                                }
                            } 
                            /* End - Added by Vineet on 31st-Aug-2018 to Share Quore records to changed Salesuser and respective manager*/
                        //}
                        //end OSM Changes
                   // }
               // }
                
           // }
       // }
   // }*/
}