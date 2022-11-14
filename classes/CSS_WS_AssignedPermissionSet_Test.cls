@isTest
private class CSS_WS_AssignedPermissionSet_Test {

    @isTest static void testAssignedPermissionSet() {
        
        Profile profile_admin =[SELECT Id, usertype FROM Profile where name='CSS_WS_Force_Warranty' Limit 1];
        User userTest = new User(
            Username = System.now().millisecond() + 'testuser@test.com',
            ProfileId = profile_admin.Id,
            Alias = 'testuser',
            Email = 'testuser@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            IsActive = true,
            LanguageLocaleKey = 'en_US');
        insert userTest;
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'CSS_WS_Factory_Warranty_Manager_2' LIMIT 1];
        insert new PermissionSetAssignment(AssigneeId = userTest.id, PermissionSetId = ps.Id );
        
        Test.startTest();
        System.runAs(userTest){

            //Permission assigned
            Boolean test_result_factory = CSS_WS_AssignedPermissionSet.PermissionSetName('CSS_WS_Factory_Warranty_Manager_2');
            System.assertEquals(test_result_factory, true);
                            
            //Permission not assigned
            Boolean test_result_other = CSS_WS_AssignedPermissionSet.PermissionSetName('Other');
            System.assertEquals(test_result_other, false);

        }
        Test.stopTest();             

    }
}