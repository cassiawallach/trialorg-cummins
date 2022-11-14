@IsTest(seealldata = true)
public class CSS_Job_Detail_Test{
/*
----------------------------------------------------------
Author: Roopa G
Created Date:09/2/2016  
Updated by: Roopa G
Updated on: 09/2/2016
Description: Test Class for Header-2 Tabs based on the profiles
Change Description:
-----------------------------------------------------------
*/

    static testMethod void CSS_Job_Detail_Test_Method1()
    {    
        //Add test data. 
        Test.startTest();             
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
                JO.Customer_Name__c = 'RoopaTnD';
                JO.Model__c = 'RoopaTestTnD';
                JO.Service_Model_N__c = 20;
           //     JO.Shop_s_Work_Order__c = 140;
                //JO.Status__c = 'Repair Complete';
                JO.Unit_Number__c = 'test1234';
                Jo.Assigned_To__c = UserInfo.getUserId();
                Jo.Additional_Tech1__c = UserInfo.getUserId();
                Jo.Additional_Tech2__c = UserInfo.getUserId();
            insert(JO);
            // Add Test Data to selected tabs
            String var2='HOME';
            // Added test data - Santosh
            CSS_Job_Detail jobDetail= new CSS_Job_Detail ();
                jobDetail.redirect();
            
            ApexPages.currentPage().getParameters().put('fEdit','Previous');    
            CSS_Job_Detail jobDetail1= new CSS_Job_Detail ();
                jobDetail1.redirect();
                
            //ApexPages.currentPage().getParameters().put('id',jo.id); 
            ApexPages.currentPage().getParameters().put('nto',var2); 
            ApexPages.currentPage().getParameters().put('fEdit',var2);
            
            CSS_Job_Detail detail12= new CSS_Job_Detail ();
                detail12.redirect(); 
           
            CSS_Job_Detail detail= new CSS_Job_Detail ();
                detail.redirect();
            
            String var='DET';    
            ApexPages.currentPage().getParameters().put('id',jo.id); 
            ApexPages.currentPage().getParameters().put('nto',var);
            ApexPages.currentPage().getParameters().put('fEdit',var2);
            
            CSS_Job_Detail detail1= new CSS_Job_Detail ();
                detail1.redirect();  
                
                String var1='HOME';    
            ApexPages.currentPage().getParameters().put('id',jo.id); 
            ApexPages.currentPage().getParameters().put('nto',var1);  
            ApexPages.currentPage().getParameters().put('fEdit',var1);
            
            CSS_Job_Detail detail2= new CSS_Job_Detail ();
                detail2.redirect();
       
        Test.stopTest();
    }
    static testMethod void CSS_Job_Detail_Test_Method2()
    {    
        //Add test data. 
        Test.startTest();             
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'RoopaTnD';
        JO.Model__c = 'RoopaTestTnD';
        JO.Service_Model_N__c = 20;
        //     JO.Shop_s_Work_Order__c = 140;
        JO.Status__c = 'Repair';
        JO.chevron_page__c = 'rj';
        JO.Unit_Number__c = 'test1234';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.Additional_Tech1__c = UserInfo.getUserId();
        Jo.Additional_Tech2__c = UserInfo.getUserId();
        insert(JO);
        // Add Test Data to selected tabs
        String var2='NEWJOB';
        // Added test data - Santosh
        CSS_Job_Detail jobDetail= new CSS_Job_Detail ();
        jobDetail.redirect();
        
        ApexPages.currentPage().getParameters().put('fEdit','Previous');    
        CSS_Job_Detail jobDetail1= new CSS_Job_Detail ();
        jobDetail1.redirect();
        
        //ApexPages.currentPage().getParameters().put('id',jo.id); 
        ApexPages.currentPage().getParameters().put('nto',var2); 
        ApexPages.currentPage().getParameters().put('fEdit',var2);
        
        CSS_Job_Detail detail12= new CSS_Job_Detail ();
        detail12.redirect(); 
        
        CSS_Job_Detail detail= new CSS_Job_Detail ();
        detail.redirect();
        
        String var='DET';    
        ApexPages.currentPage().getParameters().put('id',jo.id); 
        ApexPages.currentPage().getParameters().put('nto',var);
        ApexPages.currentPage().getParameters().put('fEdit',var2);
        
        CSS_Job_Detail detail1= new CSS_Job_Detail ();
        detail1.redirect();  
        
        String var1='NEWJOB';    
        ApexPages.currentPage().getParameters().put('id',jo.id); 
        ApexPages.currentPage().getParameters().put('nto',var1);  
        ApexPages.currentPage().getParameters().put('fEdit',var1);
        
        CSS_Job_Detail detail2= new CSS_Job_Detail ();
        detail2.redirect();
        
        Test.stopTest();
    }
    static testMethod void CSS_Job_Detail_Test_Method3()
    {    
        //Add test data. 
        Test.startTest();             
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        Id JoId=ApexPages.CurrentPage().getParameters().put('id',Jo.id);
        JO.Customer_Name__c = 'RoopaTnD';
        JO.Model__c = 'RoopaTestTnD';
        JO.Service_Model_N__c = 20;
        //     JO.Shop_s_Work_Order__c = 140;
        JO.Previous_Status__c = 'Repair';
        JO.chevron_page__c = 'jo';
        JO.Status__c = 'Repair';
        JO.Unit_Number__c = 'test1234';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.Additional_Tech1__c = UserInfo.getUserId();
        Jo.Additional_Tech2__c = UserInfo.getUserId();
        Jo.Id = JoId;
        insert(JO);
        // Add Test Data to selected tabs
        
        String var2='NEWCLAIM';
        // Added test data - Santosh
        CSS_Job_Detail jobDetail= new CSS_Job_Detail ();
        jobDetail.redirect();
        
        ApexPages.currentPage().getParameters().put('fEdit','Previous');    
        CSS_Job_Detail jobDetail1= new CSS_Job_Detail ();
        jobDetail1.redirect();
        
        //ApexPages.currentPage().getParameters().put('id',jo.id); 
        ApexPages.currentPage().getParameters().put('nto',var2); 
        ApexPages.currentPage().getParameters().put('fEdit',var2);
        
        CSS_Job_Detail detail12= new CSS_Job_Detail ();
        detail12.redirect(); 
        
        CSS_Job_Detail detail= new CSS_Job_Detail ();
        detail.redirect();
        
        String var='DET';    
        ApexPages.currentPage().getParameters().put('id',jo.id); 
        ApexPages.currentPage().getParameters().put('nto',var);
        ApexPages.currentPage().getParameters().put('fEdit',var2);
        
        CSS_Job_Detail detail1= new CSS_Job_Detail ();
        detail1.redirect();  
        
        String var1='NEWCLAIM';    
        ApexPages.currentPage().getParameters().put('id',jo.id); 
        ApexPages.currentPage().getParameters().put('nto',var1);  
        ApexPages.currentPage().getParameters().put('fEdit',var1);
        
        CSS_Job_Detail detail2= new CSS_Job_Detail ();
        detail2.redirect();
        
        Test.stopTest();
    }
    

}