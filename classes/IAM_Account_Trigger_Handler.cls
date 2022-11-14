/************************************************************
Name:  IAM_Account_Trigger_Handler
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is to use this as a ahndler from Trigger. in this we will call 
CDH Sync Customer and Do EDQ service and update and GL service calls                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Karthik Raj Golakaram          23/04/2020        INITIAL DEVELOPMENT 
1.1 -    Nishanth Verma                 23/08/2019       Added changes for OSM.
1.2 -    Karthik Raj Golakaram          10/23/2020     Changes to TEC Locations for CST
*****************************************************/
/********************************************************************************
***********************************************************************************/
Public Class IAM_Account_Trigger_Handler{
    
    //Method for Account after insert Handler
    Public Static Void onAfterInsert(List<Account> triggerNew){
        
         
       //This call update account parent id,distributor code and wwsps region from GL API call.
        Set<id> setAccIdsGL = new Set<id>();
        Map<id,Account> childTecLocations = new Map<id,Account>(); 
        Map<id,Account> mapAccount = new Map<id,Account>([select id, RecordType.Name from Account where id in :  triggerNew]);
        System.debug('AccountGLUpdate ....mapAccount. ' + mapAccount);
        for(Account acc : triggerNew){
            if(mapAccount.containsKey(acc.id)){
                String recTypeName = mapAccount.get(acc.id).RecordType.Name;
                System.debug('looping AccountGLUpdate ....recTypeName. ' + recTypeName);
                System.debug('looping AccountGLUpdate ....acc.accountSource. ' + acc.accountSource);
                if(null != acc.accountSource){
                    if(recTypeName == System.Label.IAM_Record && !acc.IAM_from_Registration__c && !acc.accountSource.equalsIgnoreCase(System.LAbel.IAM_Account_Source_QSOL))
                        setAccIdsGL.add(acc.id);
                        
                }else{
                    if(recTypeName == System.Label.IAM_Record && !acc.IAM_from_Registration__c )
                        setAccIdsGL.add(acc.id);
                }
            }
            //Adding Changes for TEC locations to identify the parent account is TEC location or not
            //add the account ids into a set to create Account access feature of CST.
            if(acc.ParentId==label.IAM_TEC_Location_HQ_ID){
                if(!childTecLocations.ContainsKey(acc.id)){
                    childTecLocations.put(acc.id,acc);
                }
            }

            if(!childTecLocations.isEmpty()){
                System.debug('Printing tech location ids'+childTecLocations);
                IAM_Utility.CreateCSTSubscription(childTecLocations.keySet());
            }
        }
        
        System.debug('triggering AccountGLUpdate ..... ' + setAccIdsGL);
        if(!IAM_contactHelperClass.isCalledGL && setAccIdsGL.size() > 0){
           // IAM_contactHelperClass.AccountGLUpdate(setAccIdsGL);
           }
    }
    
    
    //Method for Account After Update Hanlder
    Public Static void onAfterUpdate(List<Account> triggerNew, List<Account> triggerOld,Map<id,Account> triggerNewMap,Map<id,Account> triggerOldMap){
         System.debug('Printing Account status New'+triggerNew[0].CMI_Account_Status__c);
        System.debug('Printing Account Status Old'+triggerOld[0].CMI_Account_Status__c);
        System.debug('Printing first condition'+((triggerNew[0].CMI_Account_Status__c==System.Label.IAM_Status_Active||triggerNew[0].CMI_Account_Status__c==System.Label.IAM_Inactive_Label)&&triggerNew[0].IAM_ECN__c==null&&triggerNew[0].IAM_Service_Provider_Code__c!=null&& triggerNew[0].IAM_CDH_Sync__c==False&&IAM_CDH_SyncCustomer.sync==false));
        
        System.debug('Printing Condition'+(((triggerNew[0].BillingStreet!=triggerOld[0].BillingStreet)||(triggerNew[0].Name!=triggerOld[0].Name)||(triggerNew[0].CMI_Address2__c!=triggerOld[0].CMI_Address2__c)||(triggerOld[0].IAM_ECN__c!=triggerNew[0].IAM_ECN__c)||triggerOld[0].IAM_Verification_code__c!=triggerNew[0].IAM_Verification_code__c||triggerOld[0].IAM_Verified_Flag__c!=triggerNew[0].IAM_Verified_Flag__c||triggerOld[0].CMI_Account_Status__c!=triggerNew[0].CMI_Account_Status__c||triggerNew[0].BillingCity!=triggerOld[0].BillingCity||triggerNew[0].BillingState!=triggerOld[0].BillingState||triggerNew[0].BillingCountry!=triggerOld[0].BillingCountry||triggerNew[0].BillingPostalCode!=triggerNew[0].BillingPostalCode)&&(triggerOld[0].CMI_Account_Status__c!=System.Label.IAM_Inactive_Label&&triggerNew[0].CMI_Account_Status__c!=System.Label.IAM_Inactive_Label)));
            
                //calling the parser class to get the request body.
                if(((triggerNew[0].CMI_Account_Status__c==System.Label.IAM_Status_Active||triggerNew[0].CMI_Account_Status__c==System.Label.IAM_Inactive_Label)&&triggerNew[0].IAM_ECN__c==null&&triggerNew[0].IAM_Service_Provider_Code__c!=null&& triggerNew[0].IAM_CDH_Sync__c==False&&IAM_CDH_SyncCustomer.sync==false)){
                    System.debug('Printing before CDH Update');
                    String accWrapper = IAM_CDH_SyncCustomer.getCDHOutboundReq(triggerNew[0]);
                    if(System.IsBatch() == false && System.isFuture() == false){
                        
                        //calling the actual service class to make the call out
                        System.debug('Makking a call before cdh sync customer is false');
                        if(IAM_CDH_SyncCustomer.sync==false&&CSS_checkRecursive.runOnce()){
                        System.debug('CDH call out on Account Update ECN null');
                        IAM_CDH_SyncCustomer.CDHOutboundCall(accWrapper, triggerNew[0].id);
                        }
                    } 
                }else if(triggerNew[0].IAM_ECN__c!=null&&triggerNew[0].IAM_CDH_Sync__c==True){
                    //Check if there are any changes in the address, name,phone,address line 2 as such
                    if(((triggerNew[0].BillingStreet!=triggerOld[0].BillingStreet)||(triggerNew[0].Name!=triggerOld[0].Name)||(triggerNew[0].CMI_Address2__c!=triggerOld[0].CMI_Address2__c)||(triggerOld[0].IAM_ECN__c!=triggerNew[0].IAM_ECN__c)||triggerOld[0].IAM_Verification_code__c!=triggerNew[0].IAM_Verification_code__c||triggerOld[0].IAM_Verified_Flag__c!=triggerNew[0].IAM_Verified_Flag__c||triggerOld[0].CMI_Account_Status__c!=triggerNew[0].CMI_Account_Status__c||triggerNew[0].BillingCity!=triggerOld[0].BillingCity||triggerNew[0].BillingState!=triggerOld[0].BillingState||triggerNew[0].BillingCountry!=triggerOld[0].BillingCountry||triggerNew[0].BillingPostalCode!=triggerNew[0].BillingPostalCode)&&(triggerOld[0].CMI_Account_Status__c!=System.Label.IAM_Inactive_Label&&triggerNew[0].CMI_Account_Status__c!=System.Label.IAM_Inactive_Label)){
                        System.Debug('Printing ECN not null and change in Addres ');
                        String accWrapper = IAM_CDH_SyncCustomer.getCDHOutboundReq(triggerNew[0]);
                        if(System.IsBatch() == false && System.isFuture() == false){
                        System.debug('CDH call out on Account Update ECN null');
                        //calling the actual service class to make the call out
                        IAM_CDH_SyncCustomer.CDHOutboundCall(accWrapper, triggerNew[0].id);
                    }
                    }else if(triggerOld[0].CMI_Account_Status__c==System.Label.IAM_Inactive_Label&&triggerNew[0].CMI_Account_Status__c==System.Label.IAM_Status_Active){
                    System.debug('Printing CDH call where accout status changes form inactive to Active');
                    String accWrapper = IAM_CDH_SyncCustomer.getCDHOutboundReq(triggerNew[0]);
                    if(System.IsBatch() == false && System.isFuture() == false){
                    System.debug('CDH call out on Account Update ECN null');
                    //calling the actual service class to make the call out
                    IAM_CDH_SyncCustomer.CDHOutboundCall(accWrapper, triggerNew[0].id);
                    } 
                }else if(triggerOld[0].CMI_Account_Status__c==System.Label.IAM_Status_Active&&triggerNew[0].CMI_Account_Status__c==System.Label.IAM_Inactive_Label){
                    System.debug('Printing CDH call where accout status changes form Active to Inactive');
                    String accWrapper = IAM_CDH_SyncCustomer.getCDHOutboundReq(triggerNew[0]);
                    if(System.IsBatch() == false && System.isFuture() == false){
                    System.debug('CDH call out on Account Update ECN null');
                    //calling the actual service class to make the call out
                    IAM_CDH_SyncCustomer.CDHOutboundCall(accWrapper, triggerNew[0].id);
                    } 
                    }
                  
            }
            //This call update account address and followed by parent id,distributor code and wwsps region from GL API call.
          /*  Set<id> setAccIdsEDQGL = new Set<id>();
            Map<id,Account> mapAccountEDQ = new Map<id,Account>([select id, RecordType.Name from Account where id in :  triggerNew]);
            System.debug('AccountEDQGLUpdate ....mapAccountEDQ. ' + mapAccountEDQ);
            for(Account acc : triggerNew){
                Account oldAccount = triggerOldMap.get(acc.ID);
                if(mapAccountEDQ.containsKey(acc.id)){
                    String recTypeNameEDQ = mapAccountEDQ.get(acc.id).RecordType.Name;
                    System.debug('looping AccountEDQGLUpdate ....recTypeNameEDQ. ' + recTypeNameEDQ);
                    System.debug('looping AccountGLUpdate ....acc.accountSource. ' + acc.accountSource);
                    if(null != acc.accountSource){
                        if((acc.BillingStreet != oldAccount.BillingStreet || acc.BillingCity != oldAccount.BillingCity || 
                                 acc.BillingCountryCode != oldAccount.BillingCountryCode || acc.BillingPostalCode != oldAccount.BillingPostalCode) && recTypeNameEDQ == System.Label.IAM_Record && !acc.IAM_from_Registration__c && !acc.accountSource.equalsIgnoreCase(System.LAbel.IAM_Account_Source_QSOL))
                            setAccIdsEDQGL.add(acc.id);
                    }else{
                        if((acc.BillingStreet != oldAccount.BillingStreet || acc.BillingCity != oldAccount.BillingCity || 
                                 acc.BillingCountryCode != oldAccount.BillingCountryCode || acc.BillingPostalCode != oldAccount.BillingPostalCode) && recTypeNameEDQ == System.Label.IAM_Record && !acc.IAM_from_Registration__c)
                            setAccIdsEDQGL.add(acc.id);
                    }
                }   
            }
            System.debug('triggering AccountEDQGLUpdate ..... ' + setAccIdsEDQGL);
            if(!IAM_contactHelperClass.isCalledEDQGL && setAccIdsEDQGL.size() > 0)
                IAM_contactHelperClass.AccountEDQGLUpdate(setAccIdsEDQGL);*/
        
    }
    
    
    Public static void onBeforeInsertOrUpdate(List<IAM_Application__c> apps,Boolean isBefore,Boolean isInsert,Boolean isUpdate){
    
    }
    
    //Nishant Verma D-3265 OSM
    Public static void createOsmSubcripcritiondefault(List<Account> triggerNew){
        Set<id> accountIds= new Set<id>();
        Map<id,IAM_Application__c> accountsToOSMAccountAccessMap= new Map<id,IAM_Application__c>();
        for(Account acntObj:triggerNew){
            accountIds.add(acntObj.id);
        }
        
        System.debug('Printing account record id'+accountIds);
        List<IAM_Application__c> osmAccountAccessList= [SELECT id,IAM_Application_Name__c,IAM_Account_Name__c FROM IAM_Application__c WHERE IAM_Application_Name__c=:System.Label.IAM_OSM_App_Name AND IAM_Status__c='Active' AND IAM_Account_Name__c=:accountIds];
        if(!osmAccountAccessList.isEmpty()){
            for(IAM_Application__c appAccess : osmAccountAccessList ){
            	if(!accountsToOSMAccountAccessMap.containsKey(appAccess.IAM_Account_Name__c)){
                	accountsToOSMAccountAccessMap.put(appAccess.IAM_Account_Name__c,appAccess);
            	}    
            }	
        }
         
        System.debug('Printing Map of Accounts and Account Access'+accountsToOSMAccountAccessMap);
        List<IAM_Application__c> OsmSubsList = new List<IAM_Application__c>();
        for(Account Objacc : triggerNew){
            if(accountsToOSMAccountAccessMap.isEmpty()||!accountsToOSMAccountAccessMap.ContainsKey(Objacc.id)){
                IAM_Application__c objApp = new IAM_Application__c();
                objApp.IAM_Account_Name__c=Objacc.id;
                ObjApp.IAM_Status__c = 'Active';
                ObjApp.RecordTypeId =Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(System.Label.IAM_OSM_App_Name).getRecordTypeId();
                if(Objacc.type == 'Distributor Account' ||Objacc.type == 'Distributor Branch Account'){
                    ObjApp.IAM_Role__c='OSM Distributor Admin';
                }else{
                    ObjApp.IAM_Role__c=System.Label.IAM_OSM_ContPro_Default_Roles;
                }
                OsmSubsList.add(ObjApp);   
              }
        }
        system.debug('OSM Subcription to be Insert...... '+OsmSubsList);
        try{
            insert OsmSubsList;
        }catch(exception e){
            system.debug('error in insert OSM Subcription '+e);
        }
    }
    
    //change for guidanzDealer Automation
    Public static void guidanzDealerAutomation(List<Account> triggerNew,Map<id,Account> triggerOldMap){
        
        Set<Id> acctIdSet = new Set<Id>();
        for(Account acc : triggerNew){
            if(acc.Is_Partner_Account__c == True && triggerOldMap.get(acc.Id).Is_Partner_Account__c == False){
                acctIdSet.add(acc.Id);
            }
        }
		system.debug('acctIdSet value--->'+acctIdSet);        
        if(acctIdSet.size() > 0){
            IAM_Guidanz_PartnerAccountAutomation.processPartnerAccounts(acctIdSet);
        }
        
    }
}