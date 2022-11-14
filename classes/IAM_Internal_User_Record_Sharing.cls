/**********************************************************************************
***********************************************************************************
Class Name: IAM_Internal_User_Record_Sharing
Description : When user is created, it shares the access of newly added location on this User. 
If user is moving from one location to other location, it deletes access for previous location 
and share access for newly moved location.
**************************************************************************************
**************************************************************************************/

public class IAM_Internal_User_Record_Sharing {
        
    /* It is called on User after insert trigger. It creats AccountShare access for the user location */
    public static void shareAccountRecords(User newUserObj){
        try {
            if(newUserObj.ProfileId == Label.IAM_Distributor_Profile_ID) {
				createAccountShareRecords(newUserObj.CompanyName, newUserObj.Id);
            }
        } catch(Exception e){
            System.debug('Printing Exception'+e);
            IAM_ErrorHandling.IAMerrorCapture(newUserObj.Id, Label.IAM_Identity_Sharing, e.getStackTraceString());
        } 
    }
    
    /* It is called on User after update trigger. If user is moved from one location to other, it 
    creats AccountShare access for new user location and delete AccountShare access for old location. */
    public static void shareAccountRecordsOnUpdate(User newUserObj, User oldUserObj){
        try{
            if(oldUserObj.UserRoleId != newUserObj.UserRoleId 
               && newUserObj.ProfileId == Label.IAM_Distributor_Profile_ID) {
                createAccountShareRecords(newUserObj.CompanyName, newUserObj.Id);    
                    
                if(oldUserObj.CompanyName != ''){
                    Set<id> idsTodelete = new Set<id>();
                    List<AccountShare> acntShareToDelete=new List<AccountShare>(); 
                    List<Account> acnt = getAccountList(oldUserObj.CompanyName);
                    System.debug('Printing Account Name'+acnt);
                    if(!acnt.isEmpty()){
                        /*if Account is not empty.then query all records whose parent is present account id
                        With these accounts we should be able to share Contacts as well. */
                        List<Account> acntToDelete = getChildAccountList(acnt[0].id);
                        System.debug('Pritning Number of Accounts'+acntToDelete.Size());
                        for(Account a:acntToDelete){
                            idsTodelete.add(a.id);
                        }
                        
                        if(!idsToDelete.isEmpty()){
                            acntShareToDelete = [
                                SELECT id
                                     , Accountid
                                  FROM AccountShare
                                 WHERE AccountId=:idsToDelete
                            ];
                            System.debug('Printing account share to Delete'+acntShareToDelete);
                            if(!acntShareToDelete.isEmpty()){
                                delete acntShareToDelete;
                            }
                        }
                    } 
                }
            }
        } catch(Exception e){
            System.debug('Printing Exception'+e);
            IAM_ErrorHandling.IAMerrorCapture(newUserObj.Id, Label.IAM_Identity_Sharing, e.getStackTraceString());
        }      
    }
    
    /* Generic method to create AccountShare records for created/updated User */
	public static void createAccountShareRecords(String companyName, Id userId) {

		if(!String.isEmpty(companyName)) {
			List<Account> acnt = getAccountList(companyName);
			
			System.debug('Printing Account Name'+acnt);
			if(!acnt.isEmpty()){
				/* if Account is not empty.then query all records whose parent is present account id */
				/* With these accounts we should be able to share Contacts as well. */
				List<Account> acntToShare = getChildAccountList(acnt[0].id);
				System.debug('Pritning Number of Accounts'+acntToShare.Size());
				/* Once we get records from all the objects then need to check for the insertion into respective Sharing Objects. */
				if(!acntToShare.isEmpty()){

					/* insertion of records to Account Sharing. */
					acntToShare.add(acnt[0]);
					List<AccountShare> accShare = new List<AccountShare>();
					for(Account a:acntToShare){
						AccountShare share = new AccountShare();
						/* It should be edit because there might be some fields that users may edit. */
						share.AccountAccessLevel = Label.IAM_Access_Edit;
						share.AccountID = a.id;
						share.OpportunityAccessLevel = Label.IAM_Access_Edit;
						share.RowCause = Label.IAM_Row_Cause_Manual;
						share.UserOrGroupId = userId;
						accShare.add(share);
					}
					if(!accShare.isEmpty()){
					   System.debug('Data Insertion');
						insert accShare; 
					}
					/* end of insertion */
				}
			}
		}
	}
	
    /* Return child accounts for given parent account */
	public static List<Account> getChildAccountList(Id parentId) {
		return [
			SELECT Id
				 , Name
				 , OwnerId
				 , Type
			  FROM Account
			 WHERE ParentId = :parentId
		];
	}
	
    /* Return accounts with given company name */
	public static List<Account> getAccountList(String companyName) {
		return [
			SELECT Id
				 , Name
				 , recordType.Name
			  FROM Account
			 WHERE Name = :companyName
		];
	}
}