@isTest
public class CSS_AuditTrailReviewPageController_Test
{
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
            cssJH6.CSS_Job_Id__c = jo.id;
            cssJH6.CSS_New_Value__c = 'null';
            cssJH6.CSS_Old_Value__c = 'Added JSA form';
            cssJH6.CSS_Field_Name__c = 'field__c';
            insert cssJH6;
        
        CSS_JobHistory__c cssJH7 = new CSS_JobHistory__c();
            cssJH7.CSS_Job_Id__c = jo.id;
            cssJH7.CSS_New_Value__c = 'null';
            cssJH7.CSS_Old_Value__c = 'Added In Shop JSA form';
            cssJH7.CSS_Field_Name__c = 'field__c';
            insert cssJH7;
        
        CSS_JobHistory__c cssJH8 = new CSS_JobHistory__c();
            cssJH8.CSS_Job_Id__c = jo.id;
            cssJH8.CSS_New_Value__c = 'null';
            cssJH8.CSS_Old_Value__c = 'Added FieldService JSA';
            cssJH8.CSS_Field_Name__c = 'field__c';
            insert cssJH8;
        
        CSS_JobHistory__c cssJH9 = new CSS_JobHistory__c();
            cssJH9.CSS_Job_Id__c = jo.id;
            cssJH9.CSS_New_Value__c = 'null';
            cssJH9.CSS_Old_Value__c = 'Added Marine JSA';
            cssJH9.CSS_Field_Name__c = 'field__c';
            insert cssJH9;
        
        CSS_JobHistory__c cssJH11 = new CSS_JobHistory__c();
            cssJH11.CSS_Job_Id__c = jo.id;
            cssJH11.CSS_New_Value__c = 'null';
            cssJH11.CSS_Old_Value__c = 'Added PowerGen JSA';
            cssJH11.CSS_Field_Name__c = 'field__c';
            insert cssJH11;
            
            CSS_Job_Order__c cjo=[select id, name,Assigned_To__c,Status__c from CSS_Job_Order__c where id=:jo.id];
            cjo.Assigned_To__c = UserInfo.getUserId();
            cjo.Status__c = 'Repair';
            update cjo;
            
            CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
            cssJH.CSS_Job_Id__c = jo.id;
            cssJH.CSS_New_Value__c = 'null';
            cssJH.CSS_Old_Value__c = 'Added';
            cssJH.CSS_Field_Name__c = 'field';
            insert cssJH;
            
            CSS_JobHistory__c cssJH1 = new CSS_JobHistory__c();
            cssJH1.CSS_Job_Id__c = jo.id;
            cssJH1.CSS_New_Value__c = 'null';
            cssJH1.CSS_Old_Value__c = 'Added JSA form';
            cssJH1.CSS_Field_Name__c = 'field__c';
            insert cssJH1;

            
            
            List<CSS_JobHistory__c> ccs_jh=[select Id,CreatedDate,createdby.name,CSS_Job_Id__c,CSS_New_Value__c,CSS_Old_Value__c,CSS_Field_Name__c from CSS_JobHistory__c where CSS_Job_Id__c=:jo.id];
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(JO);
         //   CSS_AuditTrailReviewPageController  audit1= new CSS_AuditTrailReviewPageController(stdController);
           
            ApexPages.currentPage().getParameters().put('id',jo.id);
            CSS_AuditTrailReviewPageController  audit= new CSS_AuditTrailReviewPageController ();
            audit.vMore_JobId=jo.id;
            audit.getOneHistory(jo.id);
            audit.getHistories();
            
          cssJH.CSS_New_Value__c = null;
            cssJH.CSS_Field_Name__c = 'Assigned_To__c';
            update cssJH;
           // CSS_AuditTrail  audit2= new CSS_AuditTrail ();
           // audit2.vMore_JobId=cjh[0].ParentId;
           // audit2.getOneHistory(cjh[0].ParentId);
           // audit.getHistories();
            
             CSS_AuditTrailReviewPageController.cHistories  audit3= new CSS_AuditTrailReviewPageController.cHistories('test','test','test','technotes');
           
        Test.stopTest();
    }
}