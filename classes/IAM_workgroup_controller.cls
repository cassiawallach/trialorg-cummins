/*
*This class is used to add/removed work group ids for a 
* selected contact/user from the Site admin Page
*/
public with sharing class IAM_workgroup_controller{
      
      //To hold the selected contact id from the url  
        public String SelectedContact_id{get;set;}
      
        public  Contact con{get;set;}
      
        public list<AccountAndWorkGroupIdexist> ListOfActiveAccountsLoggedUserHavingAccessFor{get;set;}
      
        public List < Account > Accnt {
        get;
        set;
    }
      //Constructure starts
    public IAM_workgroup_controller(){
        
        //get the selected contact id from the Url arams       
        SelectedContact_id = ApexPages.Currentpage().getParameters().get('contact_id');  
          
        //Initialize the Account list with empty array
        ListOfActiveAccountsLoggedUserHavingAccessFor = new list<AccountAndWorkGroupIdexist>();
         
        //Selected User Details
        con = [select id,IAM_Work_Group_Id__c from Contact where id=:SelectedContact_id];
       
        System.debug('con  '+con );
        System.debug('SelectedContact_id '+SelectedContact_id);
        //fetch Active Accounts based on the loggedin user info 
        List < Account > lstAccounts = new list<Account>();
         
             //Get Current User Info.Set Username 

        List < user > objUser = [select ContactId, username,
            firstname, lastname, Name, ProfileId, IAM_SP_Code__c,IAM_Account_Number__c from user where id =: Userinfo.getUserid() Limit 1
        ];  
    
      //this is to get the user owner accounts whose tableu id is null means he will be the owner of those accounts.
        if (objUser[0].IAM_Account_Number__c == null || objUser[0].IAM_Account_Number__c == '') {
            //Query to display list of accounts added by karthik
            lstAccounts = [Select IAM_Service_Provider_Code__c, CMI_Region__c, id, Name, CMI_Address2__c, CMI_Account_Status__c, CMI_Billing_Address__c, Location__c, Sic, ParentId from Account where ownerid =: objUser[0].id];
        }

        //this is to get the Parent account id
        else if (objUser[0].IAM_Account_Number__c != null &&
            objUser[0].IAM_Account_Number__c.isNumeric()) {
            Accnt = [Select id,Name, ParentId, CMI_Region__c from Account where CMI_CId__c =: objUser[0].IAM_Account_Number__c];
            if (Accnt.size() > 0) {
                lstAccounts = [Select IAM_Service_Provider_Code__c, id, CMI_Region__c, Name, CMI_Address2__c, CMI_Account_Status__c, CMI_Billing_Address__c, Location__c, Sic, ParentId from Account where ParentId =: Accnt[0].Id OR ownerid =: objUser[0].id OR IAM_Service_Provider_Code__c =: objUser[0].IAM_SP_Code__c];
            }
        } else {
            lstAccounts = [Select IAM_Service_Provider_Code__c, CMI_Region__c,
                id, Name, CMI_Address2__c, CMI_Account_Status__c, CMI_Billing_Address__c, Location__c, Sic, ParentId from Account where ownerid =: objUser[0].id
            ];
        }
         //Accountlogic
        list<Account> AllAccounts = new list<Account>();
        map<id,Account> Acclist_2 = new map<id,Account>();
        map<id,Account> Acclist_3 = new map<id,Account>();
        map<id,Account> Acclist_4 = new map<id,Account>();
        map<id,Account> Acclist_5 = new map<id,Account>();
        
        map<id,Account> Acclist_6 = new map<id,Account>();
        map<id,Account> Acclist_7 = new map<id,Account>();
        map<id,Account> Acclist_8 = new map<id,Account>();
     
        if (lstAccounts.size() > 0) {
            list <String> Accids = new list <String> ();
            for (Account acc: lstAccounts) {
                Accids.add(acc.id);
            }
            
            map <id,Account> Acclist_1 = new map<id, Account> ([Select IAM_Service_Provider_Code__c, CMI_Region__c,
                id, Name, CMI_Address2__c, CMI_Account_Status__c, CMI_Billing_Address__c, Location__c, Sic, ParentId from Account where ParentId in: Accids
            ]);

            if (Acclist_1.keyset().size() > 0) {
                lstAccounts.addAll(Acclist_1.values());
                Acclist_2 = new map <id,Account> ([Select IAM_Service_Provider_Code__c, id, Name, CMI_Address2__c, CMI_Account_Status__c, CMI_Billing_Address__c, Location__c, Sic, ParentId, CMI_Region__c from Account where ParentId in: Acclist_1.keyset()]);
                if (Acclist_2.keyset().size() > 0) {

                    lstAccounts.addAll(Acclist_2.values());
                    Acclist_3 = new map <id,Account> ([Select IAM_Service_Provider_Code__c, id, Name, CMI_Address2__c, CMI_Account_Status__c, CMI_Billing_Address__c, Location__c, Sic, ParentId, CMI_Region__c from Account where ParentId in: Acclist_2.keyset()]);

                    if (Acclist_3.keyset().size() > 0) {

                        lstAccounts.addAll(Acclist_3.values());
                        Acclist_4 = new map<id,Account> ([Select IAM_Service_Provider_Code__c, id, Name, CMI_Address2__c, CMI_Account_Status__c, CMI_Billing_Address__c, Location__c, Sic, ParentId, CMI_Region__c
                            from Account where ParentId in: Acclist_3.keyset()
                        ]);

                        if (Acclist_4.keyset().size() > 0) {

                            lstAccounts.addAll(Acclist_4.values());
                            Acclist_5 = new map<id,Account> ([Select IAM_Service_Provider_Code__c, id, Name, CMI_Address2__c, CMI_Account_Status__c, CMI_Billing_Address__c, Location__c, Sic, ParentId, CMI_Region__c
                                from Account where ParentId in: Acclist_4.keyset()
                            ]);
                            if (Acclist_5.keyset().size() > 0) {

                                lstAccounts.addAll(Acclist_5.values());
                                    Acclist_6 = new map<id,Account> ([Select IAM_Service_Provider_Code__c, id, Name, CMI_Address2__c, CMI_Account_Status__c, CMI_Billing_Address__c, Location__c, Sic, ParentId, CMI_Region__c
                                from Account where ParentId in: Acclist_5.keyset()
                                ]);
                                if (Acclist_6.keyset().size() > 0) {
                                   lstAccounts.addAll(Acclist_6.values());
                                    
                                               Acclist_7 = new map <id,Account> ([Select IAM_Service_Provider_Code__c, id, Name, CMI_Address2__c, CMI_Account_Status__c, CMI_Billing_Address__c, Location__c, Sic, ParentId, CMI_Region__c
                                    from Account where ParentId in: Acclist_6.keyset() ]);
                                    if (Acclist_7.keyset().size() > 0) {
                                        lstAccounts.addAll(Acclist_7.values());
                                                   Acclist_8 = new map <id,Account> ([Select IAM_Service_Provider_Code__c, id, Name, CMI_Address2__c, CMI_Account_Status__c, CMI_Billing_Address__c, Location__c, Sic, ParentId, CMI_Region__c
                                        from Account where ParentId in: Acclist_7.keyset() ]);
                                        if (Acclist_8.keyset().size() > 0) {
                                                lstAccounts.addAll(Acclist_8.values());
                                        }
                                 
                                    }
                        
                                }

                            }

                        }

                    }
                    
                }

            }

        }

        set <Account> uniqueAcc = new set <Account> ();
        uniqueAcc.addAll(lstAccounts);
        lstAccounts = new list < Account > ();
        lstAccounts.addAll(uniqueAcc);
        try{
        user loggedUser = [select id,ContactId,contact.AccountId from user where id=:userinfo.getuserId()];
        if(null!=contact.AccountId){
        Account parentAcc = [Select IAM_Service_Provider_Code__c, id, Name, CMI_Address2__c, CMI_Account_Status__c, CMI_Billing_Address__c, Location__c, Sic, ParentId, CMI_Region__c
                                from Account where id=:loggedUser.contact.AccountId];
          lstAccounts.add(parentAcc);                      
          }
        }catch(exception ex){
            system.debug(ex.getMessage());
        }
        System.debug('lstAccounts==================>>' + lstAccounts);

        for(Account Acc:lstAccounts){//[select id,Name,IAM_Service_Provider_Code__c,IAM_Work_Group_ID__c,Location from Account where IAM_Work_Group_ID__c!=null limit 10]) {
                //check is 'IAM_Work_Group_ID__c ' is null or not 
                // and based on that populate the 'isWorkGroupidExist ' boolean
            if(Acc.CMI_Account_Status__c =='Active'){
                boolean isWorkGroupidExist = (null==con.IAM_Work_Group_Id__c)?false:(con.IAM_Work_Group_Id__c.contains(Acc.Location__c )?true:false);
                ListOfActiveAccountsLoggedUserHavingAccessFor.add(new AccountAndWorkGroupIdexist(isWorkGroupidExist ,Acc));
            } 
         }
                  
                
      }
      
    public class AccountAndWorkGroupIdexist{
        public Boolean isWorkGroupIdExist{get;set;}
        public Account EachAccount{get;set;}
        public AccountAndWorkGroupIdexist(Boolean isWorkGroupIdExist,Account EachAccount){
               this.isWorkGroupIdExist = isWorkGroupIdExist;
               this.EachAccount = EachAccount;                               
        }
      
    }
      
     public pagereference AssignIdmGroupId(){
      
        string workgrpName = con.IAM_Work_Group_Id__c;
        string workgrpNameFinal ='';
        con.IAM_Work_Group_Id__c = '';
        for(AccountAndWorkGroupIdexist eachAcc:ListOfActiveAccountsLoggedUserHavingAccessFor){
              
            System.debug('eachAcc.isWorkGroupIdExist '+eachAcc.isWorkGroupIdExist);
            if(eachAcc.isWorkGroupIdExist){
                if(workgrpName != NULL && workgrpName.ContainsAny('-p')) {
                    workgrpNameFinal += eachAcc.EachAccount.IAM_Service_Provider_Code__c+'-s'+','; 
                    System.debug('workgroupid undi');                
                }
                else{                
                    con.IAM_Work_Group_Id__c += eachAcc.EachAccount.IAM_Service_Provider_Code__c+'-s'+',';
                    System.debug('workgroupid ledu'); 
                }
            }         
        }
            
        if(workgrpName != NULL && workgrpName.ContainsAny('-p')) {
            con.IAM_Work_Group_Id__c = workgrpName+','+workgrpNameFinal;
        }
        update con;
        return null;
    }

}