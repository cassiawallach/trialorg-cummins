/*************************************************************
Name:  IAM_autoRenewschedulableBatch
Copyright © 2019  Cummins
=============================================================
Purpose:                                                            
AutoRenewal of Qsol/EDS/CST subscriptions
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -    Lavanya Javvadi         10/02/2022        INITIAL DEVELOPMENT  
********************************************************************************
*********************************************************************************/ 
global class IAM_autoRenewschedulableBatch implements Database.Batchable<sobject>, schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
		//DateTime beforeTime = System.Now().addHours(-2);
		//Using Configured custom label for filtering
		DateTime beforeTime = System.Now().addHours(Integer.valueOf(System.Label.IAM_autoRenewschedulableBatch));
		//Fetch the IAM_Application__c records which are created in last 2 hours time today.
		String Query = 'Select Id, IAM_Application_Name__c,IAM_Subscription_Name__c, IAM_Account_Name__c, IAM_Status__c, IAM_Role__c,IAM_Subscription_End_Date__c,IAM_Qsolexpiration__c from IAM_Application__c where createdDate >= :beforeTime AND (IAM_Application_Name__c = \'QuickServe Online\' OR IAM_Application_Name__c = \'EDS\' OR IAM_Application_Name__c = \'Cummins Service Training\' )';
		return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<IAM_Application__c> scope) {
		if(scope.size() > 0){
			IAM_autoRenewschedulableBatch.newAutorenewSubscriptions(scope);
		}
    }

    global void finish(Database.BatchableContext BC) {
	
    }

    global void execute(SchedulableContext SC) {
		database.executebatch(new IAM_autoRenewschedulableBatch(), 50);
    }
	
	public static void newAutorenewSubscriptions(list<IAM_Application__c> apps){    
		try{ 
		//this method is to auto renew the user access and features records if the QSOL,EDS or CST application subscriptions are renewed
			
			
			set<Id> setOfids = new set<Id>();
			set<Id> accessFeatureids = new set<Id>();
			Set<Id> accessFeatureActiveIds = new Set<id>();
            
			list<String> roleList = new list<String>();
			list<String> appList = new list<String>();
			list<IAM_Contact_Provisioning__c> existUsrAccess = new list<IAM_Contact_Provisioning__c>();
			map<IAM_Application__c,IAM_Application__c> mapOldAccessNewAccess = new map<IAM_Application__c,IAM_Application__c>(); //this map will store old access feature record with the matching(duplicate) expired access feature record
			map<Id,IAM_Application__c> mapOldAccessNewAccessId = new map<Id,IAM_Application__c>();
			//map<IAM_Application__c,String> mapRole = new map<IAM_Application__c,String>();
			//map<IAM_Application__c,String> mapAppName = new map<IAM_Application__c,String>();
			map<String,IAM_Application__c> duplicateAccAccess = new map<String,IAM_Application__c>();
			//Map<Id,IAM_Application__c> latestAccountAccess = new Map<Id,IAM_Application__c>();
            Map<String, IAM_Application__c> latestAccountAccess = new Map<String, IAM_Application__c>();
			Map<Id, List<IAM_Contact_Provisioning__c>> mapListOfUserAccessToAccAccessID = new Map<Id, List<IAM_Contact_Provisioning__c>>();
		//to create a list of account ids, list of roles, list of application to run a query later to fetch existing old account access and feature records
			for(IAM_Application__c childobj :apps){
				
				if((childobj.IAM_Application_Name__c == 'QuickServe Online' || childobj.IAM_Application_Name__c == 'EDS' || childobj.IAM_Application_Name__c == 'Cummins Service Training') && childobj.IAM_Status__c == 'Active'){
					setOfids.add(childobj.IAM_Account_Name__c);
                    accessFeatureActiveIds.add(childobj.Id);
					roleList.add(childobj.IAM_Role__c);
                    System.debug('RoleList '+ roleList);
					appList.add(childobj.IAM_Application_Name__c);
                    System.debug('appList '+ appList);
					//mapRole.put(childobj,childobj.IAM_Role__c);
					//mapAppName.put(childobj,childobj.IAM_Application_Name__c);
					
					//Creating below key to identify the existing duplicate account access feature record w.r.t role,application name and account id
					String key = childobj.IAM_Role__c + childobj.IAM_Application_Name__c + childobj.IAM_Account_Name__c;
					duplicateAccAccess.put(key,childobj);
				
                }
				
			}
            /*Duplicate prevention Logic*/
            for(IAM_Contact_Provisioning__c activeUser : [select Id, name,IAM_Role__c,IAM_Application_Name__c,
                                                              IAM_Qsolexpiration__c,IAM_Account_Application__c,IAM_Account_Application__r.IAM_Subscription_End_Date__c,
                                                              IAM_Contact__r.AccountId,IAM_End_Date__c,IAM_Reject_Reason__c,RecordTypeID  
                                                              from IAM_Contact_Provisioning__c where IAM_Account_Application__c in :accessFeatureActiveIds AND IAM_Status__c ='Active']) {
                                                                 if(mapListOfUserAccessToAccAccessID.containsKey(activeUser.IAM_Account_Application__c)) {
                                                                        List<IAM_Contact_Provisioning__c> listOfUserAccess = mapListOfUserAccessToAccAccessID.get(activeUser.IAM_Account_Application__c);
                                                                     	listOfUserAccess.add(activeUser);
                                                                     	mapListOfUserAccessToAccAccessID.put(activeUser.IAM_Account_Application__c,listOfUserAccess);
                                                                   }
                                                                  else{
                                                                      mapListOfUserAccessToAccAccessID.put(activeUser.IAM_Account_Application__c, new List<IAM_Contact_Provisioning__c> {activeUser} );
                                                                  }
                }
			if(!setOfids.isEmpty()) {
				
				//to find the existing account access and feature records with the same role,application name and account id
				list<IAM_Application__c> existInactAccAccess = [select Id, name,IAM_Role__c,IAM_Application_Name__c,IAM_Account_Name__c from IAM_Application__c
												 where IAM_Account_Name__c in :setOfids AND IAM_Role__c in :roleList AND IAM_Application_Name__c in :appList AND IAM_Status__c = 'Inactive' ORDER BY LastModifiedDate ASC];
				//listofMatchingAccAccess = new list<IAM_Application__c>();

				 // To get Latest Latemodified Account Access record - Ravi - 29/06/2021
				 for(IAM_Application__c latestrec : existInactAccAccess){
                    String key = latestrec.IAM_Role__c + latestrec.IAM_Application_Name__c + latestrec.IAM_Account_Name__c;
					//latestAccountAccess.put(latestrec.IAM_Account_Name__c,latestrec);
					latestAccountAccess.put(key,latestrec);
                    //System.debug('Lastest Modified subscription Name :'+latestAccountAccess.get(key).Name+ 'Date :'+latestAccountAccess.get(key).LastModifiedDate);
				}
				//performing inactive subcriptions records from lastest modified to rest of subscription in a same account
				for(IAM_Application__c parent : latestAccountAccess.values()) {
					//the list queried above will have addtional records w.r.t filters. creating the same key to identify the exact match
					String key = parent.IAM_Role__c + parent.IAM_Application_Name__c + parent.IAM_Account_Name__c;
					IAM_Application__c duplicate = duplicateAccAccess.get(key);
					
					if(duplicate != null)
					{	system.debug('duplicate account access and feature@@@'+parent.id);
						//listofMatchingAccAccess.add(parent);
						accessFeatureids.add(parent.id);
						//now we have the exact duplicate records which are inactive
						mapOldAccessNewAccess.put(parent,duplicateAccAccess.get(key)); //we are creating map of new Account access feature & expired Account access feature. Using this ,while inserting user feature access records we can associate it with the Account Access feature record.
						mapOldAccessNewAccessId.put(parent.Id,duplicateAccAccess.get(key));
						
						
						
					}
				}
			} 
			if(!accessFeatureids.isEmpty()) {
				//We will now query on exsiting user feature and access associated to the exact duplicate Account access and features records
				
				existUsrAccess = [select Id, name,IAM_Role__c,IAM_Application_Name__c,IAM_Qsolexpiration__c,IAM_Account_Application__c,IAM_Account_Application__r.IAM_Subscription_End_Date__c,IAM_Contact__r.AccountId,IAM_End_Date__c,IAM_Reject_Reason__c,RecordTypeID  from IAM_Contact_Provisioning__c where IAM_Account_Application__c in :accessFeatureids AND IAM_Status__c ='Inactive'];
				
			}
			
			if(!existUsrAccess.isEmpty()) {
				List<IAM_Contact_Provisioning__c> toBeInsertedList = new List<IAM_Contact_Provisioning__c>();
				for(IAM_Contact_Provisioning__c usrfeature : existUsrAccess){
                   // checking if active subscription id is having active user assigment or not
                     if(!mapListOfUserAccessToAccAccessID.containsKey(mapOldAccessNewAccessId.get(usrfeature.IAM_Account_Application__c).Id)) {
                        if(usrfeature.IAM_End_Date__c == usrfeature.IAM_Account_Application__r.IAM_Subscription_End_Date__c && usrfeature.IAM_Reject_Reason__c =='Subscription Expired' && usrfeature.IAM_Contact__r.AccountId == mapOldAccessNewAccessId.get(usrfeature.IAM_Account_Application__c).IAM_Account_Name__c){
       
                                system.debug('usrfeature to be cloned@@@'+usrfeature.id);
                                IAM_Contact_Provisioning__c toBeInserted = new IAM_Contact_Provisioning__c();
                                toBeInserted = usrfeature.clone(false,false,false,false);
                                toBeInserted.IAM_Status__c = 'Active';
                                toBeInserted.IAM_Start_Date__c = system.today();
                                toBeInserted.IAM_Account_Application__c = mapOldAccessNewAccessId.get(usrfeature.IAM_Account_Application__c).Id;
                                toBeInserted.IAM_End_Date__c = mapOldAccessNewAccessId.get(usrfeature.IAM_Account_Application__c).IAM_Subscription_End_Date__c;
                                toBeInserted.IAM_Reject_Reason__c = '';
                                toBeInserted.RecordTypeID = usrfeature.RecordTypeID; //adding this due to bad picklist error
                                toBeInserted.IAM_Subscription_Name__c = mapOldAccessNewAccessId.get(usrfeature.IAM_Account_Application__c).IAM_Subscription_Name__c;
                                toBeInserted.IAM_Qsolexpiration__c = mapOldAccessNewAccessId.get(usrfeature.IAM_Account_Application__c).IAM_Qsolexpiration__c;
                                toBeInsertedList.add(toBeInserted);
                            
                            
						
						}
                    }
					
					
				}
				insert toBeInsertedList;
                for(IAM_Contact_Provisioning__c rec:toBeInsertedList){
                    system.debug(toBeInsertedList);
                }
				
			}
		  }
		  
		  catch(exception ex){
			System.debug('Printing exception'+ex.getStackTraceString());
			if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
				system.debug('AN EXCEPTION OCCURED'+ ex.getdmlMessage(0));
			}
			else{
				system.debug('AN EXCEPTION OCCURED INSIDE ELSE');
			}
		}
    

}
}