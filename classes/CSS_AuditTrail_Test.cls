@IsTest(seealldata = true)
public class CSS_AuditTrail_Test{
/*
----------------------------------------------------------
Author: Roopa G
Created Date: 1/15/2016 
Updated by: Roopa G
Updated on: 1/15/2016
Description: Intake Audit Trail @TestClass
Change Description:
-----------------------------------------------------------
*/

    static testMethod void CSS_AuditTrail_Test_Method1()
    {    
        //Add test data. 
        Test.startTest();             
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'RoopaTnD';
            JO.Model__c = 'RoopaTestTnD';
            JO.Service_Model_N__c = 20;
            //JO.Shop_s_Work_Order__c = 140;
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'test1234';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.Application__c = 'Fire Truck';
            Jo.Additional_Tech1__c = UserInfo.getUserId();
            Jo.Additional_Tech2__c = UserInfo.getUserId();
            insert(JO);
            JO.Status__c = 'changed';
            update jo;
            
            
            
            List<css_job_order__history> cjh=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById, 
            CreatedBy.Name From css_job_order__history limit 1];
        
            system.debug('cjh List Data'+cjh);
            
         CSS_JobHistory__c cssJH6 = new CSS_JobHistory__c();
            cssJH6.CSS_Job_Id__c = cjh[0].parentid;
            cssJH6.CSS_New_Value__c = 'null';
            cssJH6.CSS_Old_Value__c = 'Added JSA form';
            cssJH6.CSS_Field_Name__c = 'field__c';
            insert cssJH6;
        
        CSS_JobHistory__c cssJH7 = new CSS_JobHistory__c();
            cssJH7.CSS_Job_Id__c = cjh[0].parentid;
            cssJH7.CSS_New_Value__c = 'null';
            cssJH7.CSS_Old_Value__c = 'Added In Shop JSA form';
            cssJH7.CSS_Field_Name__c = 'field__c';
            insert cssJH7;
        
        CSS_JobHistory__c cssJH8 = new CSS_JobHistory__c();
            cssJH8.CSS_Job_Id__c = cjh[0].parentid;
            cssJH8.CSS_New_Value__c = 'null';
            cssJH8.CSS_Old_Value__c = 'Added FieldService JSA';
            cssJH8.CSS_Field_Name__c = 'field__c';
            insert cssJH8;
        
        CSS_JobHistory__c cssJH9 = new CSS_JobHistory__c();
            cssJH9.CSS_Job_Id__c = cjh[0].parentid;
            cssJH9.CSS_New_Value__c = 'null';
            cssJH9.CSS_Old_Value__c = 'Added Marine JSA';
            cssJH9.CSS_Field_Name__c = 'field__c';
            insert cssJH9;
        
        CSS_JobHistory__c cssJH11 = new CSS_JobHistory__c();
            cssJH11.CSS_Job_Id__c = cjh[0].parentid;
            cssJH11.CSS_New_Value__c = 'null';
            cssJH11.CSS_Old_Value__c = 'Added PowerGen JSA';
            cssJH11.CSS_Field_Name__c = 'field__c';
            insert cssJH11;
            
            CSS_Job_Order__c cjo=[select id, name,Assigned_To__c,Status__c from CSS_Job_Order__c where id=:cjh[0].parentid];
            cjo.Assigned_To__c = UserInfo.getUserId();
            cjo.Status__c = 'Repair';
            update cjo;
            
            CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
            cssJH.CSS_Job_Id__c = cjh[0].parentid;
            cssJH.CSS_New_Value__c = 'null';
            cssJH.CSS_Old_Value__c = 'Added';
            cssJH.CSS_Field_Name__c = 'field';
            insert cssJH;
            
            CSS_JobHistory__c cssJH1 = new CSS_JobHistory__c();
            cssJH1.CSS_Job_Id__c = cjh[0].parentid;
            cssJH1.CSS_New_Value__c = 'null';
            cssJH1.CSS_Old_Value__c = 'Added JSA form';
            cssJH1.CSS_Field_Name__c = 'field__c';
            insert cssJH1;

            
            
            List<CSS_JobHistory__c> ccs_jh=[select Id,CreatedDate,createdby.name,CSS_Job_Id__c,CSS_New_Value__c,CSS_Old_Value__c,CSS_Field_Name__c from CSS_JobHistory__c where CSS_Job_Id__c=:cjh[0].parentid];
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(JO);
            CSS_AuditTrail  audit1= new CSS_AuditTrail(stdController);
           
            ApexPages.currentPage().getParameters().put('id',cjh[0].ParentId);
            CSS_AuditTrail  audit= new CSS_AuditTrail ();
            audit.vMore_JobId=cjh[0].ParentId;
            audit.getOneHistory(cjh[0].ParentId);
            audit.getHistories();
            
          cssJH.CSS_New_Value__c = null;
            cssJH.CSS_Field_Name__c = 'Assigned_To__c';
            update cssJH;
            CSS_AuditTrail  audit2= new CSS_AuditTrail ();
            audit2.vMore_JobId=cjh[0].ParentId;
            audit2.getOneHistory(cjh[0].ParentId);
            audit.getHistories();
            
             
           
        Test.stopTest();
    }
    
    
    static testMethod void CSS_AuditTrail_Test_Method2()
    {    
        //Add test data. 
        Test.startTest();             
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'RoopaTnD';
            JO.Model__c = 'RoopaTestTnD';
            JO.Service_Model_N__c = 20;
            //JO.Shop_s_Work_Order__c = 140;
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'test1234';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.Application__c = 'Fire Truck';
            Jo.Additional_Tech1__c = UserInfo.getUserId();
            Jo.Additional_Tech2__c = UserInfo.getUserId();
        Jo.Date_In__c = system.today();
            insert(JO);
            JO.Status__c = 'changed';
            update jo;
        
        List<css_job_order__history> cjhr=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById, 
            CreatedBy.Name From css_job_order__history limit 1];
            // system.debug('Rajesh+cjhr'+cjhr);
            
            css_job_order__history jh = new css_job_order__history();
            jh.ParentId=jo.Id;
            jh.Field = 'Created';
            insert jh;
            
           List<css_job_order__history> cjh = new List<css_job_order__history> ();
            cjh.add(jh);
            
           // List<css_job_order__history> cjh=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById, 
            //CreatedBy.Name From css_job_order__history limit 1];
        List<css_job_order__history> cjh2=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById, 
            CreatedBy.Name From css_job_order__history limit 1];
           // system.debug('cjh1 List Data'+cjh);
            
           CSS_JobHistory__c cssJH2 = new CSS_JobHistory__c();
            cssJH2.CSS_Job_Id__c = cjh[0].parentid;
            cssJH2.CSS_New_Value__c = 'null';
            cssJH2.CSS_Old_Value__c = 'Added JSA form';
            cssJH2.CSS_Field_Name__c = 'field__c';
            insert cssJH2;
            
            CSS_Job_Order__c cjo=[select id, name,Assigned_To__c,Status__c from CSS_Job_Order__c where id=:cjh[0].parentid];
            cjo.Assigned_To__c = UserInfo.getUserId();
            cjo.Status__c = 'Repair';
            update cjo;
            
            CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
            cssJH.CSS_Job_Id__c = cjhr[0].parentid;
            cssJH.CSS_New_Value__c = 'null';
            cssJH.CSS_Old_Value__c = 'Deleted';
            cssJH.CSS_Field_Name__c = 'field';
            insert cssJH;
                    
            List<CSS_JobHistory__c> ccs_jh=[select Id,CreatedDate,createdby.name,CSS_Job_Id__c,CSS_New_Value__c,CSS_Old_Value__c,CSS_Field_Name__c from CSS_JobHistory__c where CSS_Job_Id__c=:cjh[0].parentid];
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(JO);
            CSS_AuditTrail  audit1= new CSS_AuditTrail(stdController);
           
            ApexPages.currentPage().getParameters().put('id',cjhr[0].ParentId);
            system.debug('rajesh+cjhr[0].ParentId'+cjhr[0].ParentId);
            CSS_AuditTrail  audit= new CSS_AuditTrail ();
            audit.vMore_JobId=cjhr[0].ParentId;
            audit.getOneHistory(cjhr[0].ParentId);
            audit.getHistories();
            
          cssJH.CSS_New_Value__c = null;
            cssJH.CSS_Field_Name__c = 'Assigned_To__c';
            update cssJH;
            CSS_AuditTrail  audit2= new CSS_AuditTrail ();
            audit2.vMore_JobId=cjhr[0].ParentId;
            audit2.getOneHistory(cjhr[0].ParentId);
            audit.getHistories();
            
            
             CSS_AuditTrail.cHistories  audit3= new CSS_AuditTrail.cHistories('test','test','test');

             
           
        Test.stopTest();
    }
    
    
    static testMethod void CSS_AuditTrail_Test_Method3()
    {    
        //Add test data. 
        Test.startTest();             
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'roopadt';
            JO.Model__c = 'RoopaTestTnD';
            JO.Service_Model_N__c = 20;
            //JO.Shop_s_Work_Order__c = 140;
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'test1234';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.Application__c = 'Fire Truck';
            Jo.Additional_Tech1__c = UserInfo.getUserId();
            Jo.Assigned_To__c = UserInfo.getUserId();
            insert(JO);
            JO.Status__c = 'changed';
            JO.Assigned_To__c = null;
            update jo;
            
            //CSS_Job_Order__c jo1 = [select id from CSS_Job_Order__c where id=:jo.id];
            
            //List<css_job_order__history> cjh = new List<css_job_order__history> ();
            
            List<css_job_order__history> cjh=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById, 
            CreatedBy.Name From css_job_order__history limit 1 ];
        
           
          CSS_JobHistory__c cssJH5 = new CSS_JobHistory__c();
            cssJH5.CSS_Job_Id__c = cjh[0].parentid;
            cssJH5.CSS_New_Value__c = 'null';
            cssJH5.CSS_Old_Value__c = 'Added JSA form';
            cssJH5.CSS_Field_Name__c = 'field__c';
            insert cssJH5;
            
            CSS_Job_Order__c cjo=[select id, name,Assigned_To__c,Status__c from CSS_Job_Order__c where id=:cjh[0].parentid];
            cjo.Assigned_To__c = UserInfo.getUserId();
            cjo.Status__c = 'Repair';
            update cjo;
            
            List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
            
            CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
            cssJH.CSS_Job_Id__c = cjh[0].parentid;
            cssJH.CSS_New_Value__c = '005';
            cssJH.CSS_Old_Value__c = 'Added1';
            cssJH.CSS_Field_Name__c = 'DSID_Owner__c';
            insert cssJH;
            
            CSS_JobHistory__c cssJH1 = new CSS_JobHistory__c();
            cssJH1.CSS_Job_Id__c = cjh[0].parentid;
            cssJH1.CSS_New_Value__c = '005';
            cssJH1.CSS_Old_Value__c = 'Added JSA form1';
            cssJH1.CSS_Field_Name__c = 'VIN__c';
            lstcssJH.add(cssJH1);
            
            CSS_JobHistory__c cssJH2 = new CSS_JobHistory__c();
            cssJH2.CSS_Job_Id__c = cjh[0].parentid;
            cssJH2.CSS_New_Value__c = null;
            cssJH2.CSS_Old_Value__c = 'Added JSA form1';
            cssJH2.CSS_Field_Name__c = 'Sub_Status__c';
            lstcssJH.add(cssJH2);
            
            CSS_JobHistory__c cssJH3 = new CSS_JobHistory__c();
            cssJH3.CSS_Job_Id__c = cjh[0].parentid;
            cssJH3.CSS_New_Value__c = null;
            cssJH3.CSS_Old_Value__c = 'Added JSA form1';
            cssJH3.CSS_Field_Name__c = 'JobLocation__c';
            lstcssJH.add(cssJH3);
            
            CSS_JobHistory__c cssJH4 = new CSS_JobHistory__c();
            cssJH4.CSS_Job_Id__c = cjh[0].parentid;
            cssJH4.CSS_New_Value__c = null;
            cssJH4.CSS_Old_Value__c = 'Added JSA form1';
            cssJH4.CSS_Field_Name__c = 'Additional_Tech3__c';
            lstcssJH.add(cssJH4);
            
            insert lstcssJH;

            
            
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(JO);
            CSS_AuditTrail  audit1= new CSS_AuditTrail(stdController);
           
            ApexPages.currentPage().getParameters().put('id',cjh[0].ParentId);
            CSS_AuditTrail  audit= new CSS_AuditTrail ();
            audit.vMore_JobId=cjh[0].ParentId;
            audit.getOneHistory(cjh[0].ParentId);
            audit.getHistories();
            
          cssJH.CSS_New_Value__c = null;
            cssJH.CSS_Field_Name__c = 'Assigned_To__c';
            update cssJH;
            CSS_AuditTrail  audit2= new CSS_AuditTrail ();
            audit2.vMore_JobId=cjh[0].ParentId;
            audit2.getOneHistory(cjh[0].ParentId);
            audit.getHistories();
            
           
        Test.stopTest();
    }
    

}