//Test class for the class OSM_SW_ProductCatalogue_Ctrl
/*
Update 25 March Sharad
Update 26 March Sharad
Update
reupdate
/******************************************************/
@isTest
public class OSM_SW_ProductCatalogue_Ctrl_Test {
    
    static testmethod void testOSM_SW_ProductCatalogue_Ctrl(){
        
        /* Create Test Data */
        TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
        TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        //User usr=OSM_TestDataCreationUtility.getPortalUser();
         Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1 ].id; 
        //User Record
        User user1=TestingUtils.createUser('test21t21',SYS_ADMIN_PROFILE_ID,true);
        Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
        //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
         
       UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner2 = new User(
        UserRoleId = portalRole.Id,
        ProfileId = profile1.Id,
        Username ='test24446@test.com',
        Alias = 'batman',
        Email='bruce.wayne@wayneenterprises.com',
        EmailEncodingKey='UTF-8',
        Firstname='Bruce',
        Lastname='Wayne',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US',
        TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner2);

        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];

        //System.runAs ( portalAccountOwner1 ) {
        //Create account
        Account portalAccount1 = new Account(
        Name = 'TestAccount',
        OwnerId = portalAccountOwner2.Id
        );
        System.runAs(portalAccountOwner2){
            Database.insert(portalAccount1);
        }

        //Create contact
        Contact contact1 = new Contact(
        FirstName = 'Test123',
        Lastname = 'McTesty123',
        Username__c = 'testUserName12399@gmail.com',
        IAM_Contact_Status__c='Pending',
        AccountId = portalAccount1.Id,
        Email ='test@123test.com'
        );
        System.runAs(portalAccountOwner2){
            Database.insert(contact1);
        }

        //Create user
        //Profile portalProfile = [SELECT Id FROM Profile Limit 1];
        
        
        User testUser = new User();
        testUser.FirstName = 'TesttttSan';
        testUser.LastName = 'lastttSan';
        testUser.UserName = 'test2San@test.com';
        testUser.Email = 'bruce.wayne@wayneenterprises.com';
        testUser.Alias = 'bati';
        testUser.ContactId = contact1.Id;
        testUser.CommunityNickname = 'test12345San';
        testUser.ProfileId =portal_PROFILE_ID;
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.isActive = true;
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        //testUser.UserRoleId = portalRole.Id;
        
        
            System.runAs(portalAccountOwner2){
                insert testUser;
          
        }
        

        System.RunAs(usr){
        //User testUser=TestingUtils.createPortalUser('test',SYS_ADMIN_PROFILE_ID,true);
        // Create CC Products
        List<ccrz__E_Product__c> lstCCProducts = new List<ccrz__E_Product__c>();
        for(Integer i=0; i<2; i++){
            ccrz__E_Product__c ccproducts = new ccrz__E_Product__c();
            ccproducts.Name = 'TestCCProduct' + i;
            ccproducts.ccrz__SKU__c = '100-1' + i;
            ccproducts.ccrz__StartDate__c = System.today().addMonths(-1);
            ccproducts.ccrz__EndDate__c = System.today().addMonths(4);
            ccproducts.ccrz__Quantityperunit__c = 1;
            ccproducts.Group_Name__c = 'DA';
            ccproducts.ccrz__ShortDesc__c = 'Test CC product Short Desc';
            ccproducts.ccrz__ProductStatus__c = 'Released';
            ccproducts.Product_Class_Code__c = 'SW-Web Access';
            lstCCProducts.add(ccproducts);
        }
        insert lstCCProducts;
        //System.debug('###lstCCProducts: '+lstCCProducts);
        System.assertNotEquals(lstCCProducts,null,'success');
          
        //Create CC Category
        
        /*Parent category*/
        ccrz__E_Category__c ccParentCategory = new ccrz__E_Category__c();
        ccParentCategory.Name = 'parentCategory';
        ccParentCategory.ccrz__CategoryID__c = '000111';
        ccParentCategory.ccrz__EndDate__c = System.today().addMonths(4);
        ccParentCategory.ccrz__Sequence__c = 0;
        ccParentCategory.ccrz__StartDate__c = System.today().addDays(-1);
        insert ccParentCategory ;
        
        /*Child Category*/
        ccrz__E_Category__c ccChildCategory = new ccrz__E_Category__c();
        ccChildCategory.Name = 'childCategory';
        ccChildCategory.ccrz__CategoryID__c = '777777';
        ccChildCategory.ccrz__EndDate__c = System.today().addMonths(4);
        ccChildCategory.ccrz__Sequence__c = 100;
        ccChildCategory.ccrz__StartDate__c = System.today().addDays(-1);
        ccChildCategory.ccrz__ParentCategory__c = ccParentCategory.Id;
       insert ccChildCategory ;
          
          
        //Create CC Featured Products
        List<ccrz__E_FeaturedProduct__c> lstCCFeaturedProducts = new List<ccrz__E_FeaturedProduct__c>();
        for(Integer i=0; i<2; i++){
            ccrz__E_FeaturedProduct__c ccFeaturedProducts = new ccrz__E_FeaturedProduct__c();
            ccFeaturedProducts.Name = 'TestCCFeaturedProduct' + i;
            ccFeaturedProducts.ccrz__Product__c = lstCCProducts[i].Id ;
            ccFeaturedProducts.ccrz__Storefront__c = 'DefaultStore; SoftwareStore';
            ccFeaturedProducts.CC_Category__c = ccChildCategory.Id;
            ccFeaturedProducts.ccrz__Enabled__c= true;
            ccFeaturedProducts.ccrz__Type__c = 'Featured';
            lstCCFeaturedProducts.add(ccFeaturedProducts);
        }
        insert lstCCFeaturedProducts ;
        //System.debug('###lstCCFeaturedProducts: '+lstCCFeaturedProducts);
        System.assertNotEquals(lstCCFeaturedProducts,null,'success');
        
        //Create CC Products Media
        List<ccrz__E_ProductMedia__c> lstCCProductsMedia = new List<ccrz__E_ProductMedia__c>();
        for(Integer i=0; i<1; i++){
            ccrz__E_ProductMedia__c ccProductsMedia = new ccrz__E_ProductMedia__c();
            ccProductsMedia.ccrz__Product__c = lstCCProducts[i].Id;
            ccProductsMedia.ccrz__MediaType__c = 'Product Search Image';
          lstCCProductsMedia.add(ccProductsMedia);
        }
        insert lstCCProductsMedia ;
        //System.debug('###lstCCProductsMedia:'+lstCCProductsMedia);
        System.assertNotEquals(lstCCProductsMedia,null,'success');
        
        // Create E Category Media
        ccrz__E_CategoryMedia__c eCategoryMedia = new ccrz__E_CategoryMedia__c();
        eCategoryMedia.ccrz__Category__c = ccChildCategory.Id;
        insert eCategoryMedia;
        //System.debug('###eCategoryMedia:'+eCategoryMedia);
        
        // Create Attachment Data for CC Products Media
        Attachment attachPM=new Attachment();       
        attachPM.Name='Unit Test Attachment';
        Blob bodyBlobPM=Blob.valueOf('Unit Test Attachment Body');
        attachPM.body=bodyBlobPM;
        attachPM.parentId=lstCCProductsMedia[0].Id;
        insert attachPM;
        
        List<Attachment> attachmentsPM=[select id, name from Attachment where parent.id=:lstCCProductsMedia[0].Id];
        //System.debug('###attachmentsPM' +attachmentsPM);
        System.assertEquals(1, attachmentsPM.size());
        
        // Create Attachment Data for CC Category Media
        Attachment attachCM=new Attachment();       
        attachCM.Name='Unit Test Attachment';
        Blob bodyBlobCM=Blob.valueOf('Unit Test Attachment Body');
        attachCM.body=bodyBlobCM;
        attachCM.parentId=eCategoryMedia.Id;
        insert attachCM;
        
        List<Attachment> attachmentsCM=[select id, name from Attachment where parent.id=:eCategoryMedia.Id];
        //System.debug('###attachmentsCM' +attachmentsCM);
        System.assertEquals(1, attachmentsCM.size());
        // Start Test
        
          Test.startTest();
        
            String userId = System.UserInfo.getUserId();
            String inputString = userId+'/'+ ccChildCategory.Id;
        
            // Pass current page paramenters
            PageReference pageRef = Page.ccrz__Products;
            pageRef.getParameters().put('categoryId',String.valueOf(ccChildCategory.Id));
            Test.setCurrentPage(pageRef);  
            String testCategoryId= ApexPages.currentPage().getParameters().get('categoryId');
            //System.debug('###testCategoryId: '+testCategoryId);
            System.assert(String.isNotBlank(testCategoryId));
            
            // Create RemoteActionContext Class Data
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront='SoftwareStore';
            objRemotCtx.currentCartId=testCompletedTransactionSetUpRes1.cart.ccrz__EncryptedId__c;
            //objRemotCtx.portalUserId=testCompletedTransactionSetUpRes1.objSetupDate.objUserID;
            objRemotCtx.portalUserId=testUser.id;
            //objRemotCtx.effAccountId=testAccount.id;
            
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
        
            OSM_SW_ProductCatalogue_Ctrl objOSM_SW_ProductCatalogue_Ctrl = new OSM_SW_ProductCatalogue_Ctrl();
            OSM_SW_ProductCatalogue_Ctrl.getFeaturedProductsForCategory(objRemotCtx,inputString);
            OSM_SW_ProductCatalogue_Ctrl.getImageForCategory(objRemotCtx,ccChildCategory.Id);
        //Stop Test
        Test.stopTest();
      }  
    }
}