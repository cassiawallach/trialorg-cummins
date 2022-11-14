// update by Dhiraj 23rd June 2021
//including again
@isTest
public class OSM_SW_General_Util_Test {
    
   static testMethod void testOSM_SW_ProdDetailUtils_Ctrl(){ 
    User testUser = new User();
        testUser.FirstName = 'Testttt';
        testUser.LastName = 'abc@gg';
        testUser.UserName = System.now().millisecond() + 'test10@test.com';
        testUser.Email = 'test@abc.com';
        testUser.Alias = 'asec_s' ; 
        //testUser.ContactId = contact1.Id;
        testUser.CommunityNickname ='asec_s' ;
        testUser.ProfileId = TestingUtils.SYS_ADMIN_PROFILE_ID;
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.isActive = true;
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US'; 
        testUser.EmailEncodingKey = 'ISO-8859-1';
        
       insert testUser; 
   
    List<PermissionSet> psets = [SELECT ID,Name From PermissionSet WHERE name like '%OSM%'];
     List<PermissionSetAssignment> lstcurrentUserPerSet =    [   SELECT Id, PermissionSet.Name,AssigneeId
                                                                FROM PermissionSetAssignment
                                                                WHERE PermissionSet.Name like '%OSM%'];
      OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET =false;
       OSM_SW_General_Util.getuserType(testUser.Id); 
       OSM_SW_General_Util.getpermissionset(testUser.Id); 
       OSM_SW_General_Util.getuserdetails(testUser.Id); 
       OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET_FOR_CANCEL_BUTTON = false;
       OSM_SW_General_Util.getpermissionset(testUser.Id); 
    for(PermissionSet ps: psets){
        if(ps.Name.equalsIgnoreCase('OSM_Business_Admin')){
            PermissionSetAssignment PSAssinment = new PermissionSetAssignment();
            PSAssinment = new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id );
            insert PSAssinment;
            OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET =false;
            OSM_SW_General_Util.getuserType(testUser.Id);
            OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET_FOR_CANCEL_BUTTON = false;
            OSM_SW_General_Util.getpermissionset(testUser.Id); 
            delete PSAssinment;
        }
        if(ps.Name.equalsIgnoreCase('OSM_Support_Admin')){
            PermissionSetAssignment PSAssinment1 = new PermissionSetAssignment();
            PSAssinment1 = new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id );
            insert PSAssinment1;
            OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET =false;
            OSM_SW_General_Util.getuserType(testUser.Id);
            OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET_FOR_CANCEL_BUTTON = false;
            OSM_SW_General_Util.getpermissionset(testUser.Id); 
            delete PSAssinment1;
        }
        if(ps.Name.equalsIgnoreCase('OSM_Sales_Admin')){
            PermissionSetAssignment PSAssinment2 = new PermissionSetAssignment();
            PSAssinment2 = new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id );
            insert PSAssinment2;
            OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET =false;
            OSM_SW_General_Util.getuserType(testUser.Id);
            OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET_FOR_CANCEL_BUTTON = false;
            OSM_SW_General_Util.getpermissionset(testUser.Id); 
            delete PSAssinment2;
        }
        if(ps.Name.equalsIgnoreCase('OSM_Dealer_Admin')){
            PermissionSetAssignment PSAssinment3 = new PermissionSetAssignment();
            PSAssinment3 = new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id );
            insert PSAssinment3;
            OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET =false;
            OSM_SW_General_Util.getuserType(testUser.Id);
            OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET_FOR_CANCEL_BUTTON = false;
            OSM_SW_General_Util.getpermissionset(testUser.Id); 
            delete PSAssinment3;
        }
        
        if(ps.Name.equalsIgnoreCase('OSM_Distributor_Admin')){
            PermissionSetAssignment PSAssinment4 = new PermissionSetAssignment();
            PSAssinment4 = new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id );
            insert PSAssinment4;
            OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET =false;
            OSM_SW_General_Util.getuserType(testUser.Id);
            OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET_FOR_CANCEL_BUTTON = false;
            OSM_SW_General_Util.getpermissionset(testUser.Id); 
            delete PSAssinment4;
        }
        
        if(ps.Name.equalsIgnoreCase(Label.OSM_SSOEM_Admin)){
            PermissionSetAssignment PSAssinment4 = new PermissionSetAssignment();
            PSAssinment4 = new PermissionSetAssignment(AssigneeId = testUser.id, PermissionSetId = ps.Id );
            insert PSAssinment4;
            OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET =false;
            OSM_SW_General_Util.getuserType(testUser.Id);
            OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET_FOR_CANCEL_BUTTON = false;
            OSM_SW_General_Util.getpermissionset(testUser.Id); 
            delete PSAssinment4;
        }
        
    } 
       system.runAs(testUser){
           try{
               Exception ex;
       OSM_SW_General_Util.maintainErrorLog('ex', 'ServiceName', null);
       OSM_SW_General_Util.maintainErrorLog(ex, 'abc',null);
               
               integer ii = 7/0;
           }Catch(Exception ex){
               OSM_SW_General_Util.maintainErrorLog(ex, 'abc',null);
                //OSM_SW_General_Util.maintainErrorLog(ex, 'abc','abcdef');
               OSM_SW_General_Util.maintainErrorLog('ex', 'ServiceName', null);
               //OSM_SW_General_Util.maintainErrorLog('ex', 'ServiceName', 'accountId');
           }
       }
       Test.startTest();
       OSM_SW_General_Util.getEffEnabled (); 
Test.stopTest();
       
       
}
}