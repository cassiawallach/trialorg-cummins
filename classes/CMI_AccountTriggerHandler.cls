public class CMI_AccountTriggerHandler {
    
    public static void updateAccountAddressInOSMAddressBook(Map<Id,Account> newAccountMap,String operation)
    {
       //operation =Insert will always be called from Order creation during checkout
	   //operation = update will always be called on updated of Billing address changes in account from trigger
	   
	    List<OSM_Integration_Log__c> logLst = new List<OSM_Integration_Log__c>();
	   Savepoint sp=null;
	   try{
			sp = Database.setSavepoint();
	    List<ccrz__E_ContactAddr__c> listToInsertOrUpdate = new List<ccrz__E_ContactAddr__c>();
	    Map<Id,Account> accMap=  new Map<Id,Account>([select id,CMI_Primary_Contact__c,ownerid,owner.firstname,owner.lastname  from account where id in :newAccountMap.keySet()]);
		
		
		
		
	   List<String> primaryConLst = new List<String>();
	   List<Id> ownerIdLst = new List<Id>();
	   for(Id accId : accMap.keySet())
	   {
	      Account acc = accMap.get(accId);
		  ownerIdLst.add(acc.ownerid);
		  if(acc.CMI_Primary_Contact__c!=null){
			primaryConLst.add(acc.CMI_Primary_Contact__c);
		  }
	   }
	   
	   Map<Id,User> ownerMap = new Map<Id,User>([select id,firstname,lastname from user where id in :ownerIdLst]);
	   
	   
	   Map<Id,Contact> primaryConMap = new Map<Id,Contact>([select id,accountId,firstname,lastname,ownerid from contact where id in :primaryConLst]);
		
	  ccrz__E_ContactAddr__c conAddress = null;
	  
	   Map<Id,ccrz__E_ContactAddr__c> contactAddMap = new Map<Id,ccrz__E_ContactAddr__c> ([select id,Account__r.CMI_Primary_Contact__c,Account__r.ownerid,Is_Account_Main_Address__c,ccrz__AddressFirstline__c,ccrz__AddressSecondline__c,ccrz__AddressThirdline__c,ccrz__City__c,ccrz__ContactAddrId__c,ccrz__Country__c,ccrz__CountryISOCode__c,ccrz__FirstName__c,ccrz__LastName__c,ccrz__Partner_Id__c,ccrz__PostalCode__c,ccrz__State__c,ccrz__StateISOCode__c from ccrz__E_ContactAddr__c where Is_Account_Main_Address__c=true and Account__c in :newAccountMap.keySet()]);
	   
	   Map<Id,ccrz__E_ContactAddr__c> accIdVsContactAddress = new Map<Id,ccrz__E_ContactAddr__c>();
	   for(Id key : contactAddMap.keySet())
	   {
	      accIdVsContactAddress.put(contactAddMap.get(key).account__c,contactAddMap.get(key));
	   }
	   
	   Map<Id,ccrz__E_ContactAddr__c> accIdVsContactAddToUpdate = new Map<Id,ccrz__E_ContactAddr__c>();
	   
	   
	    for(Id accId : newAccountMap.keySet())
	   {
			Account acc = newAccountMap.get(accId);
			
			//if operation is insert but Account already has main address then skip the logic
			if(operation=='Insert' && accIdVsContactAddress.containsKey(accId))
			{
					continue;
			}
			
			if(operation=='Update')
			{
				
				if(accIdVsContactAddress.containsKey(accId))
				{
				  //in case address is found then turn off the main address flag and create a new 
				  //contact address which can be used for next recurring invoice
				  
				  conAddress = accIdVsContactAddress.get(accId);
				  conAddress.Is_Account_Main_Address__c= false;
				  listToInsertOrUpdate.add(conAddress);
				  
				}
			
					System.debug('Contact Address could not be found.');
					conAddress =  new ccrz__E_ContactAddr__c();
					conAddress.Is_Account_Main_Address__c= true;
					System.debug('Contact Address could not be found after.');
					
			}
			else if(operation=='Insert')
			{
				//operatio is insert then create a new address
				//this will be called from Insert Account or on order placed...
				
				conAddress =  new ccrz__E_ContactAddr__c();
				conAddress.Is_Account_Main_Address__c= true;
				
			}
			
           System.debug('=conAddress='+conAddress);
			
			for(String key : primaryConMap.keySet())
			{
					Contact con = primaryConMap.get(key);
					//get the primary contact for the account
					if(con.accountid==acc.id)
					{
					   conAddress.ccrz__FirstName__c = con.firstname;
					   conAddress.ccrz__LastName__c = con.lastname;
					   conAddress.ownerid = con.ownerid;
					   break;
					}
				  
			}
			 System.debug('Step1==conAddress='+conAddress);
			 System.debug('Step1==accMap='+accMap);
			  System.debug('Step1==ownerMap='+ownerMap);
			 System.debug('===Step 1conAddress.ccrz__FirstName__c==='+conAddress.ccrz__FirstName__c);
			 
			if(conAddress.ccrz__FirstName__c=='' || conAddress.ccrz__FirstName__c==null)
			{
				System.debug('===conAddress.ccrz__FirstName__c==='+conAddress.ccrz__FirstName__c);
				conAddress.ownerId = accMap.get(accId).ownerId;
				conAddress.ccrz__FirstName__c = ownerMap.get(accMap.get(accId).ownerid).firstname;
				conAddress.ccrz__LastName__c = ownerMap.get(accMap.get(accId).ownerid).lastname;
				
			}
			
			
			conAddress.ccrz__AddressFirstline__c  = acc.BillingStreet;
			conAddress.ccrz__City__c = acc.BillingCity;
			conAddress.ccrz__State__c =  acc.BillingState;
			conAddress.ccrz__PostalCode__c =  acc.BillingPostalCode;
			conAddress.ccrz__Country__c = acc.BillingCountry;
			conAddress.ccrz__Partner_Id__c=acc.id;
			conAddress.Account__c = acc.id;
            System.debug('Step2==conAddress='+conAddress);
			listToInsertOrUpdate.add(conAddress);
			
		}
	   
	   
		if(listToInsertOrUpdate.size()>0){
		System.debug('=====listToInsertOrUpdate===='+listToInsertOrUpdate);
		String errorMsgStrBuilder = '';
	  	
			List<Database.UpsertResult> srList = Database.upsert(listToInsertOrUpdate,false);
			
			
			// Iterate through each returned result
			
			for (Database.UpsertResult sr : srList) {
				errorMsgStrBuilder='';
				if (sr.isSuccess()) {
					// Operation was successful, so get the ID of the record that was processed
					System.debug('Successfully Update addressbook for account. Contact Address ID: ' + sr.getId());
					
				}
				else {
					// Operation failed, so get all errors
					
					for(Database.Error err : sr.getErrors()) {
						
						errorMsgStrBuilder = errorMsgStrBuilder + err.getMessage();
						errorMsgStrBuilder = errorMsgStrBuilder + '\n';
						System.debug('The following error has occurred.');                    
						System.debug(err.getStatusCode() + '---:---Message---> ' + err.getMessage());
						System.debug('fields that affected this error: ' + err.getFields());
					}
					
					OSM_Integration_Log__c log = new OSM_Integration_Log__c(Error_Description__c=errorMsgStrBuilder,Logged_In_User__c=UserInfo.getUserId(),Status__c='Error',Service_Name__c='Contact Address Creation');
					logLst.add(log);
					
				}
			}
			
		}	
	   
	   }catch(Exception ex){
			Database.rollback(sp);
			 String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();
			OSM_Integration_Log__c log1 = new OSM_Integration_Log__c(Error_Description__c=errorMsg,Logged_In_User__c=UserInfo.getUserId(),Status__c='Error',Service_Name__c='Contact Address Creation');
			logLst.add(log1);
			
	   }
	   finally{
			
			if(logLst.size()>0)
			{
			   insert logLst;
			}
	     
	   }
	   
        
        
    }

    /*
    public static void changeQuoteSharing(Map<String,String>OldtoNewSalesRep, Map<String,String>newToOldSalesrep, Set<String>accounts){
        
        Map<String, String> OldtoNewSales = new Map<String, String>();
        Map<String, String> usertoManager = new Map<String, String>();
        Map<String, String> newtoManager = new Map<String, String>();
        Map<String, String> ManagertoUser = new Map<String, String>();
        Map<String,List<String>> ManagertoUsers = new Map<String,List<String>>();
        for(User usr : [Select id, ManagerId from User where id IN: newToOldSalesrep.keySet() OR id IN: OldtoNewSalesRep.keySet()]){
            if(usr.ManagerId != null){
                    usertoManager.put(usr.Id,usr.ManagerId);
                	ManagertoUser.put(usr.ManagerId, usr.Id);
                if(ManagertoUsers.keySet().Contains(usr.ManagerId)){
                    List<String> users= ManagertoUsers.get(usr.ManagerId);
                    users.add(usr.Id);
                    ManagertoUsers.put(usr.ManagerId, users);
                }else{
                    ManagertoUsers.put(usr.ManagerId, new List<String>{usr.Id});
                }
               }
       		 }
        
		List<ccrz__E_RequestForQuote__Share> sharedEFQ = [ Select id, ParentId, UserOrGroupId 
                                                          from ccrz__E_RequestForQuote__Share where UserOrGroupId IN: ManagertoUsers.keySet()];
        for(ccrz__E_RequestForQuote__Share rfqShare : sharedEFQ){
            if(ManagertoUsers.keySet().Contains(rfqShare.UserOrGroupId)){
                for(String strKey : ManagertoUsers.keySet()){
                    Set<String> userSets = new Set<String>();
                    userSets.addAll(ManagertoUsers.get(strKey));
                    for(String sUser : userSets){
                        if(OldtoNewSalesRep.keySet().Contains(sUser)){
                            rfqShare.UserOrGroupId = usertoManager.get(OldtoNewSalesRep.get(sUser));
                            break;
                        }
                    }
                }
            }
            
        }
        
        if(sharedEFQ.size()>0){
            Database.update(sharedEFQ, false);
        }
        
     Set<String>quoteStatus = new Set<String>{'Requested','In Progress', 'Sent', 'Accepted'};
            //ccrz__E_RequestForQuote__c  objRFQ = OSM_SW_ProdDetailUtils_Ctrl.getAccountProductQuote(accountId,store,prodIds,quoteStatus);
            List<ccrz__E_RequestForQuote__c>  accountRFQs = OSM_SW_ProdDetailUtils_Ctrl.getAccountsQuote(accounts,quoteStatus, OldtoNewSalesRep.keySet());
        for(ccrz__E_RequestForQuote__c  rfq : accountRFQs){
            rfq.OwnerId = OldtoNewSalesRep.get(rfq.OwnerId);
            rfq.OSM_Sales_Admin__c = usertoManager.get(OldtoNewSalesRep.get(rfq.OwnerId));
        }
        if(accountRFQs.size()>0){
            Database.update(accountRFQs,false);
        }
    }
    */
}