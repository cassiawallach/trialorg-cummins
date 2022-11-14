@isTest
public class CSS_globalSearchController_Test {
    static testMethod void css_globalSearchControllerProTest(){
         
       
        Test.startTest();  
        UserRole empRole = [Select Id From UserRole Where Name = 'DFSE-CUMMINS CENTRAL' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kalll2l', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12ll', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = empRole.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal010@testorg.com', user_Location__c = '56270-56270',CSS_User_MultiLocValues__c='56270-56270',isActive = true);
        User u1 = new User(Alias = 'kallll3l', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12l', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = empRole.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal110@testorg.com', user_Location__c = '56270-56270',CSS_User_MultiLocValues__c='56270-56270',isActive = true);
        list<user> userids = new list<user>();
        userids.add(u);
        userids.add(u1);
        
        insert userids;
        System.runAs(u) {
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'Satish';
           // JO.Model__c = 'CumminsBasic';
         //   JO.Service_Model_N__c = 01152016;
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'unitNo123';
            //JO.Assigned_To__c = UserInfo.getUserId();
            JO.Assigned_To__c = userids[0].id;
            JO.Additional_Tech1__c = userids[0].id;
            JO.Additional_Tech2__c = userids[1].id;
            JO.CSS_Job_Location_Code__c = '56270-56270';
            insert(JO);
                                
        PageReference pageRef = Page.CSS_globalSearch;
        Test.setCurrentPage(pageRef);
        //test.startTest();
        // Searching customer name
            ApexPages.currentPage().getParameters().put('srch',JO.Customer_Name__c);
            ApexPages.currentPage().getParameters().put('sFilter','All');
            String custName = ApexPages.currentPage().getParameters().get('srch');
            System.assertEquals(true,custName!=null);
            CSS_globalSearchController glbSearchCon = new CSS_globalSearchController();
            list<CSS_Job_Order__c> customerNameMatch = glbSearchCon.JoList;
            glbSearchCon.searchStr1 = JO.Name;
            // checking the search results list
            //System.assert(customerNameMatch.size()>0);
            glbSearchCon.redirect();
    
        // Searching Primary Techinican
            ApexPages.currentPage().getParameters().put('srch',UserInfo.getName());
            String primaryTech = ApexPages.currentPage().getParameters().get('srch');
            ApexPages.currentPage().getParameters().put('sFilter','All');
            System.assertEquals(true,primaryTech!=null);
            CSS_globalSearchController primaryTechSearch = new CSS_globalSearchController();
            primaryTechSearch.searchStr1 = JO.Name;
            primaryTechSearch.performingSearch();
            list<CSS_Job_Order__c> primaryTechMatch = glbSearchCon.JoList;
            // checking the search results list
           // System.assert(primaryTechMatch.size()>0);
         
        // Searching AdditionalTech1
            ApexPages.currentPage().getParameters().put('srch',UserInfo.getName());
            String addTech1 = ApexPages.currentPage().getParameters().get('srch');
            ApexPages.currentPage().getParameters().put('sFilter','All');
            System.assertEquals(true,addTech1!=null);
            CSS_globalSearchController addTech1Search = new CSS_globalSearchController();
            addTech1Search.searchStr1 = JO.Name;
            addTech1Search.performingSearch();
            list<CSS_Job_Order__c> addTech1Match = glbSearchCon.JoList;
            // checking the search results list
           // System.assert(addTech1Match.size()>0);
         
        // Searching AdditionalTech2
            ApexPages.currentPage().getParameters().put('srch',UserInfo.getName());
            String addTech2 = ApexPages.currentPage().getParameters().get('srch');
            ApexPages.currentPage().getParameters().put('sFilter','All');
            System.assertEquals(true,addTech2!=null);
            CSS_globalSearchController addTech2Search = new CSS_globalSearchController();
            addTech2Search.searchStr1 = Jo.Name;
            addTech2Search.performingSearch();
            list<CSS_Job_Order__c> addTech2Match = glbSearchCon.JoList;
            // checking the search results list
         //   System.assert(addTech2Match.size()>0);
         
           // Searching Location
            ApexPages.currentPage().getParameters().put('srch',UserInfo.getName());
            String addTech19 = ApexPages.currentPage().getParameters().get('srch');
            ApexPages.currentPage().getParameters().put('sFilter','LOC');
            System.assertEquals(true,addTech19!=null);
            CSS_globalSearchController addTech19Search = new CSS_globalSearchController();
            addTech19Search.searchStr1 = Jo.Name;
            addTech19Search.performingSearch();
            list<CSS_Job_Order__c> addTech19Match = glbSearchCon.JoList;
        
         // Searching Unit Number
            ApexPages.currentPage().getParameters().put('srch',UserInfo.getName());
            String addTech11 = ApexPages.currentPage().getParameters().get('srch');
            ApexPages.currentPage().getParameters().put('sFilter','UN');
            System.assertEquals(true,addTech11!=null);
            CSS_globalSearchController addTech11Search = new CSS_globalSearchController();
            addTech11Search.searchStr1 = Jo.Name;
            addTech11Search.performingSearch();
            list<CSS_Job_Order__c> addTech11Match = glbSearchCon.JoList;
            
         // Searching WO
            ApexPages.currentPage().getParameters().put('srch',UserInfo.getName());
            String addTech10 = ApexPages.currentPage().getParameters().get('srch');
            ApexPages.currentPage().getParameters().put('sFilter','WO');
            System.assertEquals(true,addTech10!=null);
            CSS_globalSearchController addTech10Search = new CSS_globalSearchController();
            addTech10Search.searchStr1 = Jo.Name;
            addTech10Search.performingSearch();
            list<CSS_Job_Order__c> addTech10Match = glbSearchCon.JoList;
            
             // Searching Name
            ApexPages.currentPage().getParameters().put('srch',UserInfo.getName());
            String addTech14 = ApexPages.currentPage().getParameters().get('srch');
            ApexPages.currentPage().getParameters().put('sFilter','Name');
            System.assertEquals(true,addTech14!=null);
            CSS_globalSearchController addTech14Search = new CSS_globalSearchController();
            addTech14Search.searchStr1 = Jo.Name;
            addTech14Search.performingSearch();
            list<CSS_Job_Order__c> addTech14Match = glbSearchCon.JoList;
            
        // Searching for All Fields
           ApexPages.currentPage().getParameters().put('srch',Jo.Customer_Name__c);
            String JobNum = ApexPages.currentPage().getParameters().get('srch');
            ApexPages.currentPage().getParameters().put('sFilter','Job');
            System.assertEquals(true,JobNum!=null);
            CSS_globalSearchController JobNumSearch = new CSS_globalSearchController();
            JobNumSearch.searchStr1 = Jo.Name;
            JobNumSearch.roleName = 'CFSE';
            JobNumSearch.roleName = 'ABC';
            JobNumSearch.vCFSEFlg = true;
            JobNumSearch.performingSearch();
            list<CSS_Job_Order__c> JobNumMatch = glbSearchCon.JoList;  
        }
            test.stopTest();
    }
    static testMethod void css_globalSearchControllerProTest2(){
         
       
        Test.startTest();  
        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kalll4l', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12ll', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = empRole.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal0010@testorg.com', user_Location__c = '56270-56270',CSS_User_MultiLocValues__c='56270-56270',isActive = true);
        User u1 = new User(Alias = 'kallll5l', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12l', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = empRole.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal0110@testorg.com', user_Location__c = '56270-56270',CSS_User_MultiLocValues__c='56270-56270',isActive = true);
        list<user> userids = new list<user>();
        userids.add(u);
        userids.add(u1);
        
        insert userids;
        System.runAs(u) {
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'Satish';
           // JO.Model__c = 'CumminsBasic';
         //   JO.Service_Model_N__c = 01152016;
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'unitNo123';
            //JO.Assigned_To__c = UserInfo.getUserId();
            JO.Assigned_To__c = userids[0].id;
            JO.Additional_Tech1__c = userids[0].id;
            JO.Additional_Tech2__c = userids[1].id;
            JO.CSS_Job_Location_Code__c = '56270-56270';
            insert(JO);
                                
        PageReference pageRef = Page.CSS_globalSearch;
        Test.setCurrentPage(pageRef);
        //test.startTest();
        // Searching customer name
            ApexPages.currentPage().getParameters().put('srch',JO.Customer_Name__c);
            ApexPages.currentPage().getParameters().put('sFilter','All');
            String custName = ApexPages.currentPage().getParameters().get('srch');
            System.assertEquals(true,custName!=null);
            CSS_globalSearchController glbSearchCon = new CSS_globalSearchController();
            list<CSS_Job_Order__c> customerNameMatch = glbSearchCon.JoList;
            glbSearchCon.searchStr1 = JO.Name;
            // checking the search results list
            //System.assert(customerNameMatch.size()>0);
            glbSearchCon.redirect();
    
        // Searching Primary Techinican
            ApexPages.currentPage().getParameters().put('srch',UserInfo.getName());
            String primaryTech = ApexPages.currentPage().getParameters().get('srch');
            ApexPages.currentPage().getParameters().put('sFilter','All');
            System.assertEquals(true,primaryTech!=null);
            CSS_globalSearchController primaryTechSearch = new CSS_globalSearchController();
            primaryTechSearch.searchStr1 = JO.Name;
            primaryTechSearch.performingSearch();
            list<CSS_Job_Order__c> primaryTechMatch = glbSearchCon.JoList;
            // checking the search results list
           // System.assert(primaryTechMatch.size()>0);
         
     
        }
            test.stopTest();
    }
    static testMethod void css_globalSearchControllerProTest3(){
         
       
        Test.startTest();  
        UserRole empRole = [Select Id From UserRole Where Name LIKE '%ADVANCED-CENTRAL - DES MOINES%' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kalll4l', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12ll', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = empRole.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal0010@testorg.com', user_Location__c = '56270-56270',CSS_User_MultiLocValues__c='56270-56270;56270-56270',isActive = true);
        User u1 = new User(Alias = 'kallll5l', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12l', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = empRole.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal0110@testorg.com', user_Location__c = '56270-56270',CSS_User_MultiLocValues__c='56270-56270',isActive = true);
        list<user> userids = new list<user>();
        userids.add(u);
        userids.add(u1);
        
        insert userids;
        System.runAs(u) {
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'Satish';
           // JO.Model__c = 'CumminsBasic';
         //   JO.Service_Model_N__c = 01152016;
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'unitNo123';
            //JO.Assigned_To__c = UserInfo.getUserId();
            JO.Assigned_To__c = userids[0].id;
            JO.Additional_Tech1__c = userids[0].id;
            JO.Additional_Tech2__c = userids[1].id;
            JO.CSS_Job_Location_Code__c = '56270-56270';
            insert(JO);
                                
        PageReference pageRef = Page.CSS_globalSearch;
        Test.setCurrentPage(pageRef);
        //test.startTest();
        // Searching customer name
            ApexPages.currentPage().getParameters().put('srch',JO.Customer_Name__c);
            ApexPages.currentPage().getParameters().put('sFilter','All');
            String custName = ApexPages.currentPage().getParameters().get('srch');
            System.assertEquals(true,custName!=null);
            CSS_globalSearchController glbSearchCon = new CSS_globalSearchController();
            list<CSS_Job_Order__c> customerNameMatch = glbSearchCon.JoList;
            glbSearchCon.searchStr1 = JO.Name;
            // checking the search results list
            //System.assert(customerNameMatch.size()>0);
            glbSearchCon.redirect();
    
        // Searching Primary Techinican
            ApexPages.currentPage().getParameters().put('srch',UserInfo.getName());
            String primaryTech = ApexPages.currentPage().getParameters().get('srch');
            ApexPages.currentPage().getParameters().put('sFilter','All');
            System.assertEquals(true,primaryTech!=null);
            CSS_globalSearchController primaryTechSearch = new CSS_globalSearchController();
            primaryTechSearch.searchStr1 = JO.Name;
            primaryTechSearch.performingSearch();
            list<CSS_Job_Order__c> primaryTechMatch = glbSearchCon.JoList;
            // checking the search results list
           // System.assert(primaryTechMatch.size()>0);
         
     
        }
            test.stopTest();
    }
    static testMethod void css_globalSearchControllerProTest4(){
         
       
        Test.startTest();  
        UserRole empRole = [Select Id From UserRole Where Name LIKE '%TECHNICIAN-EAST - BRONX%' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kalll4l', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12ll', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = empRole.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal0010@testorg.com', user_Location__c = '56270-56270',CSS_User_MultiLocValues__c='56270-56270;56270-56270',isActive = true);
        User u1 = new User(Alias = 'kallll5l', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12l', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = empRole.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal0110@testorg.com', user_Location__c = '56270-56270',CSS_User_MultiLocValues__c='56270-56270',isActive = true);
        list<user> userids = new list<user>();
        userids.add(u);
        userids.add(u1);
        
        insert userids;
        System.runAs(u) {
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'Satish';
           // JO.Model__c = 'CumminsBasic';
         //   JO.Service_Model_N__c = 01152016;
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'unitNo123';
            //JO.Assigned_To__c = UserInfo.getUserId();
            JO.Assigned_To__c = userids[0].id;
            JO.Additional_Tech1__c = userids[0].id;
            JO.Additional_Tech2__c = userids[1].id;
            JO.CSS_Job_Location_Code__c = '56270-56270';
            insert(JO);
               list<CSS_Job_Order__c> JOList  = [select id,Name,Creator_Location__c from CSS_Job_Order__c where id =:JO.id ];
            string locationc = JOList[0].Creator_Location__c;                  
        PageReference pageRef = Page.CSS_globalSearch;
        Test.setCurrentPage(pageRef);
        //test.startTest();
        // Searching customer name
            ApexPages.currentPage().getParameters().put('srch',JO.Customer_Name__c);
            ApexPages.currentPage().getParameters().put('sFilter','Jobs');
            String custName = ApexPages.currentPage().getParameters().get('srch');
            System.assertEquals(true,custName!=null);
            CSS_globalSearchController glbSearchCon = new CSS_globalSearchController();
            list<CSS_Job_Order__c> customerNameMatch = glbSearchCon.JoList;
            glbSearchCon.searchStr1 = JOList[0].Name;
           
            // checking the search results list
            //System.assert(customerNameMatch.size()>0);
            glbSearchCon.redirect();
    
        // Searching Primary Techinican
            ApexPages.currentPage().getParameters().put('srch',UserInfo.getName());
            String primaryTech = ApexPages.currentPage().getParameters().get('srch');
            ApexPages.currentPage().getParameters().put('sFilter','All');
            System.assertEquals(true,primaryTech!=null);
            CSS_globalSearchController primaryTechSearch = new CSS_globalSearchController();
            primaryTechSearch.searchStr1 = JO.Name;
            primaryTechSearch.performingSearch();
            list<CSS_Job_Order__c> primaryTechMatch = glbSearchCon.JoList;
            // checking the search results list
           // System.assert(primaryTechMatch.size()>0);
         
     
        }
            test.stopTest();
    }

}