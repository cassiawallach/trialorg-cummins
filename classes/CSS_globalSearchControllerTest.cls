/**********************************************************************
Name:CSS_globalSearchControllerTest
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
Test Class created for testing the CSS_globalSearchController functionality                                                           
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                 
1.0 -   Sandeep           02-11-2016      INITIAL DEVELOPMENT         
***********************************************************************/

@isTest
public class CSS_globalSearchControllerTest{

    static testMethod void css_globalSearchControllerProTest(){
         
        Id currentUserID=UserInfo.getUserId();
        list<user> userids = [select id,name from user limit 3];
        test.startTest();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'Satish';
           // JO.Model__c = 'CumminsBasic';
         //   JO.Service_Model_N__c = 01152016;
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'unitNo123';
            JO.Assigned_To__c = UserInfo.getUserId();
            JO.Additional_Tech1__c = userids[0].id;
            JO.Additional_Tech2__c = userids[1].id;
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
            // checking the search results list
            //System.assert(customerNameMatch.size()>0);
            glbSearchCon.redirect();
    
        // Searching Primary Techinican
            ApexPages.currentPage().getParameters().put('srch',UserInfo.getName());
            String primaryTech = ApexPages.currentPage().getParameters().get('srch');
        	ApexPages.currentPage().getParameters().put('sFilter','All');
            System.assertEquals(true,primaryTech!=null);
            CSS_globalSearchController primaryTechSearch = new CSS_globalSearchController();
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
            addTech19Search.performingSearch();
            list<CSS_Job_Order__c> addTech19Match = glbSearchCon.JoList;
        
         // Searching Unit Number
            ApexPages.currentPage().getParameters().put('srch',UserInfo.getName());
            String addTech11 = ApexPages.currentPage().getParameters().get('srch');
        	ApexPages.currentPage().getParameters().put('sFilter','UN');
            System.assertEquals(true,addTech11!=null);
            CSS_globalSearchController addTech11Search = new CSS_globalSearchController();
            addTech11Search.performingSearch();
            list<CSS_Job_Order__c> addTech11Match = glbSearchCon.JoList;
            
         // Searching WO
            ApexPages.currentPage().getParameters().put('srch',UserInfo.getName());
            String addTech10 = ApexPages.currentPage().getParameters().get('srch');
        	ApexPages.currentPage().getParameters().put('sFilter','WO');
            System.assertEquals(true,addTech10!=null);
            CSS_globalSearchController addTech10Search = new CSS_globalSearchController();
            addTech10Search.performingSearch();
            list<CSS_Job_Order__c> addTech10Match = glbSearchCon.JoList;
            
             // Searching Name
            ApexPages.currentPage().getParameters().put('srch',UserInfo.getName());
            String addTech14 = ApexPages.currentPage().getParameters().get('srch');
        	ApexPages.currentPage().getParameters().put('sFilter','Name');
            System.assertEquals(true,addTech14!=null);
            CSS_globalSearchController addTech14Search = new CSS_globalSearchController();
            addTech14Search.performingSearch();
            list<CSS_Job_Order__c> addTech14Match = glbSearchCon.JoList;
            
        // Searching for All Fields
           ApexPages.currentPage().getParameters().put('srch',Jo.Customer_Name__c);
            String JobNum = ApexPages.currentPage().getParameters().get('srch');
        	ApexPages.currentPage().getParameters().put('sFilter','Job');
            System.assertEquals(true,JobNum!=null);
            CSS_globalSearchController JobNumSearch = new CSS_globalSearchController();
        	JobNumSearch.roleName = 'CFSE';
        	JobNumSearch.roleName = 'ABC';
            JobNumSearch.vCFSEFlg = true;
            JobNumSearch.performingSearch();
            list<CSS_Job_Order__c> JobNumMatch = glbSearchCon.JoList;        
        	test.stopTest();
    }
    
    static testmethod void css_globalSearchControllerCFSE(){
        list<user> cfseuser = [select id,name from user where UserRole.Name like 'CFSE%' limit 3];
        Test.startTest();
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
            JO1.Customer_Name__c = 'Test';          
            JO1.Status__c = 'Repair Complete';
            JO1.Unit_Number__c = 'unitNo1234';
        	JO1.ESN__c='75007009';
            //JO1.Assigned_To__c = UserInfo.getUserId();
            //JO1.Additional_Tech1__c = userids[0].id;
            //JO1.Additional_Tech2__c = userids[1].id;
            insert(JO1);
        ApexPages.currentPage().getParameters().put('srch',JO1.Customer_Name__c);
        ApexPages.currentPage().getParameters().put('sFilter','All');
        String joNum = ApexPages.currentPage().getParameters().get('srch');
        System.assertEquals(true,joNum!=null);
        CSS_globalSearchController glbCfse = new CSS_globalSearchController();
        glbCfse.roleName = 'CFSE';
        glbCfse.roleName = 'ABC';
        
        glbCfse.vCFSEFlg = true;
        glbCfse.performingSearch();
        list<CSS_Job_Order__c> cfseMatch = glbCfse.JoList;
        // checking the search results list
        //System.assert(cfseMatch.size()>0);
        glbCfse.redirect();
        Test.stopTest();
    }
    
    static testmethod void css_globalSearchControllerDFSEAll(){
        list<user> dfseuser = [select id,name from user where UserRole.Name like 'DFSE%' limit 3];
        Test.startTest();
        CSS_Job_Order__c JO2 = new CSS_Job_Order__c();
            JO2.Customer_Name__c = 'TestDfse';          
            JO2.Status__c = 'Repair Complete';
            JO2.Unit_Number__c = 'unitNo234';
        	JO2.ESN__c='75007009';
            //JO1.Assigned_To__c = UserInfo.getUserId();
            //JO1.Additional_Tech1__c = userids[0].id;
            //JO1.Additional_Tech2__c = userids[1].id;
            insert(JO2);
        ApexPages.currentPage().getParameters().put('srch',JO2.Customer_Name__c);
        ApexPages.currentPage().getParameters().put('sFilter','All');
        String jo2Num = ApexPages.currentPage().getParameters().get('srch');
        System.assertEquals(true,jo2Num!=null);
        CSS_globalSearchController glbDfse = new CSS_globalSearchController();
        glbDfse.searchStr1 = 'test';
        glbDfse.roleName = 'DFSE';
        glbDfse.roleName = 'CFSE';
        glbDfse.roleName ='Factory';
        glbDfse.roleName ='Customer Support Organization';
        glbDfse.roleName ='ADVANCED';
        
        glbDfse.vDFSEFlg = true;
        glbDfse.performingSearch();
        list<CSS_Job_Order__c> dfseMatch = glbDfse.JoList;
        // checking the search results list
        //System.assert(dfseMatch.size()>0);
        glbDfse.redirect();
        Test.stopTest();
    }
    
    static testmethod void css_globalSearchControllerDFSE(){
        list<user> dfseuser = [select id,name from user where UserRole.Name like 'DFSE%' limit 3];
        Test.startTest();
        CSS_Job_Order__c JO3 = new CSS_Job_Order__c();
            JO3.Customer_Name__c = 'ESNDfse';          
            JO3.Status__c = 'Repair Complete';
            JO3.Unit_Number__c = 'unitNo234';
        	JO3.ESN__c='75007009';
            //JO1.Assigned_To__c = UserInfo.getUserId();
            //JO1.Additional_Tech1__c = userids[0].id;
            //JO1.Additional_Tech2__c = userids[1].id;
            insert(JO3);
        ApexPages.currentPage().getParameters().put('srch',JO3.ESN__c);
        ApexPages.currentPage().getParameters().put('sFilter','PSN');
        String ESN = ApexPages.currentPage().getParameters().get('srch');
        System.assertEquals(true,ESN!=null);
        CSS_globalSearchController glDfse = new CSS_globalSearchController();
        glDfse.roleName = 'DFSE';
        glDfse.vDFSEFlg = true;
        glDfse.performingSearch();
        list<CSS_Job_Order__c> dfseMatch1 = glDfse.JoList;
        // checking the search results list
        //System.assert(dfseMatch1.size()>0);
        glDfse.redirect();
        Test.stopTest();
    }
    
        static testmethod void css_globalSearchControllerException(){
        list<user> dfseuser = [select id,name from user where UserRole.Name like 'DFSE%' limit 3];
        Test.startTest();
        CSS_Job_Order__c JO3 = new CSS_Job_Order__c();
            JO3.Customer_Name__c = 'Truck';          
            JO3.Status__c = 'Repair Complete';
            JO3.Unit_Number__c = 'unitNo2';
        	JO3.ESN__c='75007009';
            //JO1.Assigned_To__c = UserInfo.getUserId();
            //JO1.Additional_Tech1__c = userids[0].id;
            //JO1.Additional_Tech2__c = userids[1].id;
            insert(JO3);
        ApexPages.currentPage().getParameters().put('srch','1');
        ApexPages.currentPage().getParameters().put('sFilter','PSN');
        String ESN = ApexPages.currentPage().getParameters().get('srch');
        System.assertEquals(true,ESN!=null);
        CSS_globalSearchController glDfse = new CSS_globalSearchController();
        glDfse.roleName = 'DFSE';
        glDfse.vDFSEFlg = true;
        glDfse.performingSearch();
        list<CSS_Job_Order__c> dfseMatch1 = glDfse.JoList;
        // checking the search results list
        //System.assert(dfseMatch1.size()>0);
        glDfse.redirect();
        Test.stopTest();
    }
    
}