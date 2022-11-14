@isTest
public class dbu_CustomerInfoDetailsCtrl_Test 
{
    
	static testMethod void testfetchCustomerInfoDetails() 
    {  
        //userrole
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin;
        
        System.runAs(admin) {         
        Set<String> customerUserTypes = new Set<String> {'CSPLiteUser','PowerPartner','PowerCustomerSuccess','CustomerSuccess'};
            
            //Account
            Account acc = new Account (Name = 'newAcc1');  
            Insert acc;
            
        	String orgId = UserInfo.getOrganizationId();  
            String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
            String uniqueName = orgId + dateString + randomInt;   
            /*
        	//Contact
        	Contact con = new Contact (
            AccountId = acc.id,
            FirstName = 'testFirstName',
            Email = 'test@test.com',
            Phone = '1234567890',
            dbu_Company_Name__c = 'testcompany',
            LastName = 'portalTestUser',
            Username__c = uniqueName + '@test' + orgId + '.org'
            );
            Insert con;
			*/
	        Contact con = new Contact(LastName = 'testFirstName', FirstName = 'myname' ,AccountId = acc.id, dbu_Company_Name__c = 'tenance');  
            con.Username__c = uniqueName + '@test' + orgId + '.org'; 
            insert con;            
        	String myJSON = JSON.serialize(con);
            
        	//User
        	//User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
			   //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
                Profile p = [select Id,name from Profile where UserType in :customerUserTypes limit 1];
                //Id profileId = [Select Id From Profile Where Name='IAM User'].id;
               
            
                User newUser = new User(
                //UserRoleId = ur.Id,
                profileId = p.id,
                username = uniqueName +'newUser@yahoortfgcvdfg.com',
                email = 'pb@ff.com',
                emailencodingkey = 'UTF-8',
                localesidkey = 'en_US',
                languagelocalekey = 'en_US',
                timezonesidkey = 'America/Los_Angeles',
                alias='nuser',
                lastname='lastname',
                contactId = con.id
                );
                System.debug('newUser >>>' + newUser);
                Insert newUser;  
  				
          /*  
        user usr                                =   new User();
        usr.FirstName                           =   'Kazar';
        usr.LastName                            =   'lastname';
        usr.Alias                               =   'Tsr';
        usr.CompanyName                         =   'testcompany';
        usr.Username                            =   'testemail'+Math.round(Math.random()*Math.pow(10, 7))+'@testemail.com';
        usr.Email                               =   'testemail'+Math.round(Math.random()*Math.pow(10, 7))+'@testemail.com';
        usr.Country                             =   'United States';
        usr.CommunityNickname                   =   'community';
        usr.TimeZoneSidKey                      =   'America/Panama';
        usr.LocaleSidKey                        =   'en_US';
        //objUser.FederationIdentifier                =   FEDID;

        usr.ProfileId                           =   p.Id;
        usr.ContactId                           =   con.id;
        usr.Phone                               =   '1234567890';
        usr.EmailEncodingKey                    =   'UTF-8';
        usr.CSS_User_MultiLocValues__c          =   'null-P';
        usr.UserGroup__c                        =   'EDS_User';
        usr.IAM_UID__c                          =   'pb@ff.com';
        usr.IAM_Abocode__c                      =   '1';
        usr.IAM_Final_Approver__c               =   'N';
        usr.IAM_WorkGroup_id__c                 =   'null-P';
        usr.tableauId__c                        =   'lastname';
        usr.activeEquipmentDuration__c          =   '21';
        usr.sessionTimeout__c                   =   '86400000';
        usr.LanguageLocaleKey					=	'en_US';
        //objUser.UserRoleId							=	ID.valueof((string.valueof(userrole.Id)));
        usr.PortalRole 							= 'Manager';
        usr.IsActive = true;
        usr.ccrz__CC_CurrencyCode__c 			=	'USD';
        insert usr;   
            */
              Test.startTest();  
                    dbu_CustomerInfoDetailsCtrl.fetchCustomerInfoDetails(newUser.Id);
                    dbu_CustomerInfoDetailsCtrl.fetchUserInfoDetails(newUser.Id);
                	dbu_CustomerInfoDetailsCtrl.updateContactRecord(myJSON);
                    //Contact conupdate = new Contact ();
                    //conupdate= [SELECT Id,dbu_Company_Name__c,FirstName,LastName,Email,Phone FROM Contact where Id =: newUser.Id];
                    //dbu_CustomerInfoDetailsCtrl.updateContactRecord(conupdate.FirstName);          
                    //System.assertEquals(testAcc.CreatedDate, yesterday);  
              Test.stopTest();  
         
        }
    }
}