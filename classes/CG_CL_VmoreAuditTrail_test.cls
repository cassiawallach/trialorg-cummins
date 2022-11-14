@isTest(seealldata = false)
public class CG_CL_VmoreAuditTrail_test{
    /*static testMethod void testingMethods(){
        Test.startTest();             
        CSS_Job_Order__c JOB = CSS_TestData.createJobOrder(true);
        CG_CL_VmoreAuditTrail  audit234= new CG_CL_VmoreAuditTrail ();
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Old_Value__c = 'Added';
        insert cssJH;
        system.debug('cssJH>>>'+cssJH);
        audit234.getOneHistory(JOB.Id);
        Test.stopTest();
    }


    static testMethod void testingMethods12(){
        CSS_Job_Order__c JOB = CSS_TestData.createJobOrder(true);

        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Job_Id__c = JOB.Id;
        cssJH.CSS_Old_Value__c = 'Deleted';
        insert cssJH;
        CG_CL_VmoreAuditTrail  audit234= new CG_CL_VmoreAuditTrail ();
        system.debug('cssJH>>>'+cssJH);
        audit234.getOneHistory(JOB.Id);

    }

    static testMethod void testingMethods123(){
        CSS_Job_Order__c JOB = CSS_TestData.createJobOrder(true);

        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Old_Value__c = 'Added JSA form';
        insert cssJH;
        system.debug('cssJH>>>'+cssJH);
        CG_CL_VmoreAuditTrail  audit234= new CG_CL_VmoreAuditTrail ();
        audit234.getOneHistory(JOB.Id);
    }

    static testMethod void testingMethods1234(){
        CSS_Job_Order__c JOB = CSS_TestData.createJobOrder(true);

        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Old_Value__c = 'Added In Shop JSA form';
        insert cssJH;
        system.debug('cssJH>>>'+cssJH);
        CG_CL_VmoreAuditTrail  audit234= new CG_CL_VmoreAuditTrail ();
        audit234.getOneHistory(JOB.Id);
    }


    static testMethod void testingMethods22(){
        CSS_Job_Order__c JOB = CSS_TestData.createJobOrder(true);

        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Old_Value__c = 'Added FieldService JSA';
        insert cssJH;
        system.debug('cssJH>>>'+cssJH);
        CG_CL_VmoreAuditTrail  audit234= new CG_CL_VmoreAuditTrail ();
        audit234.getOneHistory(JOB.Id);
    }


    static testMethod void testingMethods24(){
        CSS_Job_Order__c JOB = CSS_TestData.createJobOrder(true);

        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Old_Value__c = 'Added Marine JSA';
        insert cssJH;
        system.debug('cssJH>>>'+cssJH);
        CG_CL_VmoreAuditTrail  audit234= new CG_CL_VmoreAuditTrail ();
        audit234.getOneHistory(JOB.Id);
    }

    static testMethod void testingMethods32(){
        CSS_Job_Order__c JOB = CSS_TestData.createJobOrder(true);

        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Old_Value__c = 'Added PowerGen JSA';
        insert cssJH;
        system.debug('cssJH>>>'+cssJH);
        CG_CL_VmoreAuditTrail  audit234= new CG_CL_VmoreAuditTrail ();
        audit234.getOneHistory(JOB.Id);
    }

    static testMethod void testingMethods42(){
        CSS_Job_Order__c JOB = CSS_TestData.createJobOrder(true);

        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Old_Value__c = 'testing';
        insert cssJH;
        system.debug('cssJH>>>'+cssJH);
        CG_CL_VmoreAuditTrail  audit234= new CG_CL_VmoreAuditTrail ();
        audit234.getOneHistory(JOB.Id);
    }

    static testMethod void testingMethods52(){
        CSS_Job_Order__c JOB = CSS_TestData.createJobOrder(true);

        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Old_Value__c = 'testing';
        cssJH.CSS_Field_Name__c = 'VIN__c';
        insert cssJH;
        system.debug('cssJH>>>'+cssJH);
        CG_CL_VmoreAuditTrail  audit234= new CG_CL_VmoreAuditTrail ();
        audit234.getOneHistory(JOB.Id);
    }

    static testMethod void testingMethods62(){
        CSS_Job_Order__c JOB = CSS_TestData.createJobOrder(true);

        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Old_Value__c = 'testing';
        cssJH.CSS_Field_Name__c = 'Sub_Status__c';
        insert cssJH;
        system.debug('cssJH>>>'+cssJH);
        CG_CL_VmoreAuditTrail  audit234= new CG_CL_VmoreAuditTrail ();
        audit234.getOneHistory(JOB.Id);
    }

    static testMethod void testingMethods65562(){
        CSS_Job_Order__c JOB = CSS_TestData.createJobOrder(true);

        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Old_Value__c = 'testing';
        cssJH.CSS_Field_Name__c = 'JobLocation__c';
        insert cssJH;
        system.debug('cssJH>>>'+cssJH);
        CG_CL_VmoreAuditTrail  audit234= new CG_CL_VmoreAuditTrail ();
        audit234.getOneHistory(JOB.Id);
    }

    static testMethod void testingMethods2246(){
        CSS_Job_Order__c JOB = CSS_TestData.createJobOrder(true);

        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Old_Value__c = 'testing';
        cssJH.CSS_Field_Name__c = 'Additional_Tech3__c';
        insert cssJH;
        system.debug('cssJH>>>'+cssJH);
        CG_CL_VmoreAuditTrail  audit234= new CG_CL_VmoreAuditTrail ();
        audit234.getOneHistory(JOB.Id);

    }
    
    
     static testMethod void testingMethods2734(){
        CSS_Job_Order__c JOB = CSS_TestData.createJobOrder(true);

        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Field_Name__c = 'DSID_Owner__c';
        insert cssJH;
        system.debug('cssJH>>>'+cssJH);
        CG_CL_VmoreAuditTrail  audit234= new CG_CL_VmoreAuditTrail ();
        audit234.getOneHistory(JOB.Id);

    }

    static testMethod void CG_CL_VmoreAuditTrail_Method2()
    {    
        //Add test data. 
        Test.startTest();             
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'wenchin';
        JO.Model__c = 'wenchin';
        JO.Service_Model_N__c = 20;
        //JO.Shop_s_Work_Order__c = 140;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test1234';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.Application__c = 'Fire Truck';
        Jo.Additional_Tech1__c = UserInfo.getUserId();
        Jo.Additional_Tech2__c = UserInfo.getUserId();
        insert(JO);
        JO.Status__c = '';
        update jo;

        List<css_job_order__history> cjhr=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById, 
                                           CreatedBy.Name From css_job_order__history limit 1];
        system.debug('Rajesh+cjhr'+cjhr);

        css_job_order__history jh = new css_job_order__history();
        jh.ParentId=jo.Id;
        jh.Field = 'Created';
        insert jh;

        List<css_job_order__history> cjh = new List<css_job_order__history> ();
        cjh.add(jh);

        system.debug('cjh List Data'+cjh);


        CSS_Job_Order__c cjo=[select id, name,Assigned_To__c,Status__c from CSS_Job_Order__c where id=:cjh[0].parentid];
        cjo.Assigned_To__c = UserInfo.getUserId();
        cjo.Status__c = 'Repair';
        update cjo;

        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Job_Id__c = cjhr[0].parentid;
        cssJH.CSS_New_Value__c = 'Test';
        cssJH.CSS_Old_Value__c = 'Deleted';
        cssJH.CSS_Field_Name__c = 'field';
        insert cssJH;

        CG_CL_VmoreAuditTrail  audit1= new CG_CL_VmoreAuditTrail();

        ApexPages.currentPage().getParameters().put('id',cjhr[0].ParentId);
        system.debug('rajesh+cjhr[0].ParentId'+cjhr[0].ParentId);
        CG_CL_VmoreAuditTrail  audit= new CG_CL_VmoreAuditTrail ();
        audit.vMore_JobId=cjhr[0].ParentId;
        audit.getOneHistory(cjhr[0].ParentId);

        cssJH.CSS_New_Value__c = null;
        cssJH.CSS_Field_Name__c = 'Assigned_To__c';
        update cssJH;


        CG_CL_VmoreAuditTrail  audit2= new CG_CL_VmoreAuditTrail ();
        audit2.vMore_JobId=cjhr[0].ParentId;
        audit2.getOneHistory(cjhr[0].ParentId);



        CG_CL_VmoreAuditTrail.cHistories  audit3= new CG_CL_VmoreAuditTrail.cHistories('test','test','test');

        Test.stopTest();
    }*/
    static testMethod void CG_CL_VmoreAuditTrail_Method2_1()
    {    
        //Add test data. 
        
        
                    
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'wenchin';
        JO.Model__c = 'wenchin';
        JO.Service_Model_N__c = 20;
        //JO.Shop_s_Work_Order__c = 140;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test1234';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.Application__c = 'Fire Truck';
        Jo.Additional_Tech1__c = UserInfo.getUserId();
        Jo.Additional_Tech2__c = UserInfo.getUserId();
        jo.DSID__c = 'DSBVN9295';
        jo.Service_Model__c ='DSBVN9295';
        insert(JO);
        
        List<css_job_order__history> chList = new List<css_job_order__history>();
        css_job_order__history jh = new css_job_order__history();
        jh.ParentId=jo.Id;
        jh.Field = 'Created';
        chList.add(jh);
        
        css_job_order__history jh1 = new css_job_order__history();
        jh1.ParentId=jo.Id;
        jh1.Field = 'Service_Model__c';
        chList.add(jh1);
        
        css_job_order__history jh2 = new css_job_order__history();
        jh2.ParentId=jo.Id;
        jh2.Field = 'Additional_Tech1__c';
        chList.add(jh2);
        
        
       insert chList;
       
       List<CSS_JobHistory__c> JoHistList = new List<CSS_JobHistory__c>();
       CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Job_Id__c = jo.Id;
        cssJH.CSS_New_Value__c = 'Test';
        cssJH.CSS_Old_Value__c = 'Added';
        cssJH.CSS_Field_Name__c = 'field';
        JoHistList.add(cssJH);
        
        CSS_JobHistory__c cssJH1 = new CSS_JobHistory__c();
        cssJH1.CSS_Job_Id__c = jo.Id;
        cssJH1.CSS_New_Value__c = 'Test';
        cssJH1.CSS_Old_Value__c = 'Deleted';
        cssJH1.CSS_Field_Name__c = 'field';
        JoHistList.add(cssJH1);
        
        CSS_JobHistory__c cssJH2 = new CSS_JobHistory__c();
        cssJH2.CSS_Job_Id__c = jo.Id;
        cssJH2.CSS_New_Value__c = 'Test';
        cssJH2.CSS_Old_Value__c = 'Added JSA form';
        cssJH2.CSS_Field_Name__c = 'field';
        JoHistList.add(cssJH2);
        
        CSS_JobHistory__c cssJH3 = new CSS_JobHistory__c();
        cssJH3.CSS_Job_Id__c = jo.Id;
        cssJH3.CSS_New_Value__c = 'Test';
        cssJH3.CSS_Old_Value__c = 'Added In Shop JSA form';
        cssJH3.CSS_Field_Name__c = 'field';
        JoHistList.add(cssJH3);
        
        CSS_JobHistory__c cssJH4 = new CSS_JobHistory__c();
        cssJH4.CSS_Job_Id__c = jo.Id;
        cssJH4.CSS_New_Value__c = 'Test';
        cssJH4.CSS_Old_Value__c = 'Added FieldService JSA';
        cssJH4.CSS_Field_Name__c = 'field';
        JoHistList.add(cssJH4);
        
        CSS_JobHistory__c cssJH5 = new CSS_JobHistory__c();
        cssJH5.CSS_Job_Id__c = jo.Id;
        cssJH5.CSS_New_Value__c = 'Test';
        cssJH5.CSS_Old_Value__c = 'Added Marine JSA';
        cssJH5.CSS_Field_Name__c = 'field';
        JoHistList.add(cssJH5);
        
        CSS_JobHistory__c cssJH6 = new CSS_JobHistory__c();
        cssJH6.CSS_Job_Id__c = jo.Id;
        cssJH6.CSS_New_Value__c = 'Test';
        cssJH6.CSS_Old_Value__c = 'Added PowerGen JSA';
        cssJH6.CSS_Field_Name__c = 'field';
        JoHistList.add(cssJH6);
        
        CSS_JobHistory__c cssJH7 = new CSS_JobHistory__c();
        cssJH7.CSS_Job_Id__c = jo.Id;
        cssJH7.CSS_New_Value__c = 'Test';
        cssJH7.CSS_Old_Value__c = 'Test';
        cssJH7.CSS_Field_Name__c = 'DSID_Owner__c';
        JoHistList.add(cssJH7);
        
        CSS_JobHistory__c cssJH8 = new CSS_JobHistory__c();
        cssJH8.CSS_Job_Id__c = jo.Id;
        cssJH8.CSS_New_Value__c = 'Test';
        cssJH8.CSS_Old_Value__c = 'Test';
        cssJH8.CSS_Field_Name__c = 'VIN__c';
        JoHistList.add(cssJH8);
        
        CSS_JobHistory__c cssJH9 = new CSS_JobHistory__c();
        cssJH9.CSS_Job_Id__c = jo.Id;
        cssJH9.CSS_New_Value__c = 'Test';
        cssJH9.CSS_Old_Value__c = 'Test';
        cssJH9.CSS_Field_Name__c = 'Sub_Status__c';
        JoHistList.add(cssJH9);
        
        CSS_JobHistory__c cssJH10 = new CSS_JobHistory__c();
        cssJH10.CSS_Job_Id__c = jo.Id;
        cssJH10.CSS_New_Value__c = 'Test';
        cssJH10.CSS_Old_Value__c = 'Test';
        cssJH10.CSS_Field_Name__c = 'JobLocation__c';
        JoHistList.add(cssJH10);
        
        CSS_JobHistory__c cssJH11 = new CSS_JobHistory__c();
        cssJH11.CSS_Job_Id__c = jo.Id;
        cssJH11.CSS_New_Value__c = 'Test';
        cssJH11.CSS_Old_Value__c = 'Test';
        cssJH11.CSS_Field_Name__c = 'Additional_Tech3__c';
        JoHistList.add(cssJH11);
        
        CSS_JobHistory__c cssJH12 = new CSS_JobHistory__c();
        cssJH12.CSS_Job_Id__c = jo.Id;
        cssJH12.CSS_New_Value__c = '';
        cssJH12.CSS_Old_Value__c = 'Test';
        cssJH12.CSS_Field_Name__c = 'Additional_Tech5__c';
        JoHistList.add(cssJH12);
        
        insert JoHistList;
        
        Test.startTest(); 
        
        ApexPages.currentPage().getParameters().put('id',jo.Id);
        CG_CL_VmoreAuditTrail  audit2= new CG_CL_VmoreAuditTrail ();
        audit2.vMore_JobId=jo.Id;
        audit2.getOneHistory(jo.Id);
        
        CG_CL_VmoreAuditTrail.cHistories  audit3= new CG_CL_VmoreAuditTrail.cHistories('test','test','test');

        Test.stopTest();
    }

}