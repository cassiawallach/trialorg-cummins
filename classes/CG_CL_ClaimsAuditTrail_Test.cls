@isTest(seealldata = true)
public class CG_CL_ClaimsAuditTrail_Test {

    static testmethod void testmethod1()
    {
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;

        system.runas(new User(Id=UserInfo.getUserId()))
        { 

            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;

            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            //JO = css_testdata.createJobOrder(false);
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
            insert JO;
            system.debug('statusold'+JO.Status__c);
          
            //JO.Status__c = null;
            //JO.Assigned_To__c = null;
            //update JO;
           

            List<css_job_order__history> cjh=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById, 
                                              CreatedBy.Name From css_job_order__history limit 1 ];
            CSS_Job_Order__c cjo=[select id, name,Assigned_To__c,Status__c from CSS_Job_Order__c where id=:cjh[0].parentid];
            //cjo.Assigned_To__c = UserInfo.getUserId();
            cjo.Status__c = null;
            update cjo;
             system.debug('statusnew'+cjo.Status__c);

            List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();

            CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH.CSS_Job_Id__c = cjh[0].parentid;
            cssJH.CSS_New_Value__c = null;
            cssJH.CSS_Old_Value__c = 'Added';
            cssJH.CSS_Field_Name__c = 'DSID_Owner__c';
            insert cssJH;

            CSS_JobHistory__c cssJH1 = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH1.CSS_Job_Id__c = cjh[0].parentid;
            cssJH1.CSS_New_Value__c = null;
            cssJH1.CSS_Old_Value__c = 'Deleted';
            cssJH1.CSS_Field_Name__c = 'VIN__c';
            lstcssJH.add(cssJH1);

            CSS_JobHistory__c cssJH2 = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH2.CSS_Job_Id__c = cjh[0].parentid;
            cssJH2.CSS_New_Value__c = null;
            cssJH2.CSS_Old_Value__c = 'Added JSA form';
            cssJH2.CSS_Field_Name__c = 'Sub_Status__c';
            lstcssJH.add(cssJH2);

            CSS_JobHistory__c cssJH3 = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH3.CSS_Job_Id__c = cjh[0].parentid;
            cssJH3.CSS_New_Value__c = null;
            cssJH3.CSS_Old_Value__c = 'Added JSA form1';
            cssJH3.CSS_Field_Name__c = 'JobLocation__c';
            lstcssJH.add(cssJH3);

            CSS_JobHistory__c cssJH4 = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH4.CSS_Job_Id__c = cjh[0].parentid;
            cssJH4.CSS_New_Value__c = null;
            cssJH4.CSS_Old_Value__c = 'Added JSA form1';
            cssJH4.CSS_Field_Name__c = 'Additional_Tech3__c';
            lstcssJH.add(cssJH4);

            insert lstcssJH;
            css_claims__c claimsobj=css_testdata.createclaims(true,null);
            claimsobj.Status__c='Submitted';
            update claimsobj;
            claimsobj.Pending_Authorization__c='Authorization Required';
            update claimsobj;
            claimsobj.Actual_Technician_Time__c=2.0;
            update claimsobj;

            CSS_PSN__c psnobj = css_testdata.createpsn(true, claimsobj.id);
            psnobj.Application__c='AUTOMOTIVE';
            update psnobj;
            psnobj.PSN__c='79855048';
            update psnobj;
            psnobj.Service_Model__c='ISX15 CM2350 X101';
            update psnobj;
            css_claims__c claims=[select id,name,Status__c,Actual_Technician_Time__c,Pending_Authorization__c from css_claims__c limit 1];
            CSS_Claim_Submission__c claimsubobj = css_testdata.createclaimsub(true, claimsobj.Id);
            claimsubobj.Claim_Number__c=claims.Name;
            update claimsubobj;
            claimsubobj.Claim_Status__c='Submitted';
            update claimsubobj;
            claimsubobj.Claim_Status__c='Applealed/Resubmitted';
            update claimsubobj;

            CSS_Claim_Submission__c claimsubobj1 = css_testdata.createclaimsub(true, claimsobj.Id);
            claimsubobj1.Claim_Number__c=claims.Name;
            update claimsubobj1;
            claimsubobj1.Claim_Status__c='Submitted';
            update claimsubobj1;
            claimsubobj1.Claim_Status__c='In Review';
            update claimsubobj1;
            try{
                css_psn__history psn=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name 
                                      from css_psn__history limit 1];
                css_psn__history psn1=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name 
                                       from css_psn__history where Field!='created' limit 1];
            }
            catch(exception er){

            }
            list<css_psn__history> psnlist =[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name 
                                             from css_psn__history LIMIT 100];
            list<CSS_JobHistory__c> johistlist= [Select Id,CreatedDate,createdby.name,CSS_Job_Id__c,CSS_New_Value__c,CSS_Old_Value__c,CSS_Field_Name__c from CSS_JobHistory__c Order by CreatedDate desc LIMIT 100];



            list<CSS_Claim_Submission__history> claimsublist =[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name from CSS_Claim_Submission__history Order by CreatedDate desc LIMIT 100];

            List<CSS_JobHistory__c> jobHistoryList = [Select Id,CreatedDate,createdby.name,CSS_Job_Id__c,CSS_New_Value__c,CSS_Old_Value__c,CSS_Field_Name__c from CSS_JobHistory__c Order by CreatedDate desc LIMIT 100];

            if(claims != null )
                apexpages.currentPage().getparameters().put('id',claims.id);
            if(johistlist != null && johistlist.size() >0)
            apexpages.currentPage().getparameters().put('jobordID',johistlist[0].CSS_Job_Id__c);
            if(johistlist != null && johistlist.size() >0)
            apexpages.currentPage().getparameters().put('jobordID',johistlist[0].CSS_Job_Id__c);
            if(claimsublist != null && claimsublist.size() >0)
            apexpages.currentPage().getparameters().put('claSubmId',claimsublist[0].id);
            
            test.startTest();
            CG_CL_ClaimsAuditTrail audtrail = new CG_CL_ClaimsAuditTrail();
            if(claimsublist != null && claimsublist.size() >0)
            audtrail.claimSubsId = string.valueOf(claimsublist[0].ParentId);
            if(claimsublist != null && claimsublist.size() >0)
            audtrail.csid = string.valueOf(claimsublist[0].ParentId);
            if(psnlist != null && psnlist.size() >0)
            audtrail.cpid = string.valueOf(psnlist[0].ParentId);
            if(jobHistoryList != null && jobHistoryList.size() >0)
            audtrail.jobId=string.valueOf(jobHistoryList[0].CSS_Job_Id__c);
            //audtrail.psnids = string.valueOf(psn1.ParentId);
            //audtrail.getOneHistory(psn1.ParentId);
            audtrail.getHistories();

            system.assert(string.isBlank(audtrail.claimsid));
            test.stopTest();
        }
    }
    static testmethod void testmethod2()
    {
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            account acc = new account();
            acc.Name = 'test';
            acc.Type = 'Customer';
            acc.CSS_DistributorCode__c = '25270';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c = '25720';
            insert acc;
            list<css_job_order__history> joord = [select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name From css_job_order__history where Field='created' limit 10];
            list<css_job_order__history> joord1 = [select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name From css_job_order__history where Field ='Assigned_To' limit 10];

            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO = css_testdata.createJobOrder(false);
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
            //JO.Status__c = 'Repair';
            //JO.Assigned_To__c = null;
            //update jo;
            List<css_job_order__history> cjh=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById, 
                                              CreatedBy.Name From css_job_order__history where id =:Jo.id limit 1 ];
            //CSS_Job_Order__c cjo=[select id, name,Assigned_To__c,Status__c from CSS_Job_Order__c where id=:cjh[0].parentid];
            //cjo.Assigned_To__c = UserInfo.getUserId();
            jo.Status__c = null;
            update jo;

            List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();

            CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH.CSS_Job_Id__c = cjh[0].parentid;
            cssJH.CSS_New_Value__c ='005test123';
            cssJH.CSS_Old_Value__c = '005Added1';
            cssJH.CSS_Field_Name__c = 'DSID_Owner__c';
            cssJH.System_Modified__c = true;
            //cssJH.Audit_Message__c = null;
            insert cssJH;

            CSS_JobHistory__c cssJH1 = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH1.CSS_Job_Id__c = cjh[0].parentid;
            cssJH1.CSS_New_Value__c = null;
            cssJH1.CSS_Old_Value__c = 'Added JSA form1';
            cssJH1.CSS_Field_Name__c = 'VIN__c';
            cssJH1.Audit_Message__c = null;
            lstcssJH.add(cssJH1);

            CSS_JobHistory__c cssJH2 = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH2.CSS_Job_Id__c = cjh[0].parentid;
            cssJH2.CSS_New_Value__c = null;
            cssJH2.CSS_Old_Value__c = 'Added JSA form1';
            cssJH2.CSS_Field_Name__c = 'Sub_Status__c';
            cssJH2.Audit_Message__c = null;
            lstcssJH.add(cssJH2);

            CSS_JobHistory__c cssJH3 = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH3.CSS_Job_Id__c = cjh[0].parentid;
            cssJH3.CSS_New_Value__c = null;
            cssJH3.CSS_Old_Value__c = 'Added JSA form1';
            cssJH3.CSS_Field_Name__c = 'JobLocation__c';
            cssJH3.Audit_Message__c = null;
            lstcssJH.add(cssJH3);

            CSS_JobHistory__c cssJH4 = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH4.CSS_Job_Id__c = cjh[0].parentid;
            cssJH4.CSS_New_Value__c = null;
            cssJH4.CSS_Old_Value__c = 'Added JSA form1';
            cssJH4.CSS_Field_Name__c = 'Additional_Tech3__c';
            lstcssJH.add(cssJH4);

            insert lstcssJH;
            css_claims__c claimsobj=css_testdata.createclaims(true,null);
            claimsobj.Status__c='Submitted';
            claimsobj.Account__c= acc.id;
            update claimsobj;
            claimsobj.Pending_Authorization__c='Rejection_Comments';
            update claimsobj;
            claimsobj.Actual_Technician_Time__c=2.0;
            update claimsobj;

            CSS_PSN__c psnobj = css_testdata.createpsn(true, claimsobj.id);
            psnobj.Application__c='AUTOMOTIVE';
            update psnobj;
            psnobj.PSN__c='79855048';
            update psnobj;
            psnobj.Service_Model__c='ISX15 CM2350 X101';
            update psnobj;
            css_claims__c claims=[select id,name,Status__c,Actual_Technician_Time__c,Pending_Authorization__c from css_claims__c limit 1];
            CSS_Claim_Submission__c claimsubobj = css_testdata.createclaimsub(true, claimsobj.Id);
            claimsubobj.Claim_Number__c=claims.Name;
            update claimsubobj;
            claimsubobj.Claim_Status__c='Submitted';
            update claimsubobj;
            claimsubobj.Claim_Status__c='Applealed/Resubmitted';
            update claimsubobj;
            try{
                css_psn__history psn1=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name 
                                       from css_psn__history where Field!='created' limit 1];
            }
            catch(exception er){

            }
            list<CSS_Claims__history> chlist = [select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name
                                                from CSS_Claims__history
                                                where Field!='created' Order by CreatedDate desc limit 10];

            //list<css_job_order__history> joord = [select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name From css_job_order__history where Field ='created' limit 10];

            list<CSS_Claim_Submission__history> claimsublist = [select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name from CSS_Claim_Submission__history where Field!='created' Order by CreatedDate desc limit 10];
if(chlist != null && chlist.size() >0) {
                     apexpages.currentPage().getparameters().put('id',chlist[0] !=null ? chlist[0].ParentId : null);
            }
            if(joord != null && joord.size() >0) {
                apexpages.currentPage().getparameters().put('jobordID',joord[0] !=null ? joord[0].ParentId : null);
            }
            if(claimsublist != null && claimsublist.size() >0) {
                apexpages.currentPage().getparameters().put('claSubmId',claimsublist[0] !=null ? claimsublist[0].ParentId:null); 
            }
           
             string id = apexpages.currentPage().getparameters().put('id',claimsobj.id);
           
            test.startTest();
            CG_CL_ClaimsAuditTrail audtrail = new CG_CL_ClaimsAuditTrail();
            date d = system.today();
            audtrail.claimsNumber = 'test123';
            audtrail.creditDate = d;
            audtrail.psnids = '79464646';
            audtrail.strField='Assigned_To';
            if(joord != null && joord.size() >0) 
            audtrail.jobId=joord[0].ParentId;
            if(claimsublist != null && claimsublist.size() >0) 
            audtrail.claimSubsId = claimsublist[0].ParentId;
            
            audtrail.getHistories();
           
            
             CG_CL_ClaimsAuditTrail.cHistories  audit3= new CG_CL_ClaimsAuditTrail.cHistories(d,'test','test','test',true);
             List<CG_CL_ClaimsAuditTrail.cHistoriesFinal> LCH = new  List<CG_CL_ClaimsAuditTrail.cHistoriesFinal>();
             CG_CL_ClaimsAuditTrail.cHistoriesFinal CHF = new  CG_CL_ClaimsAuditTrail.cHistoriesFinal();
             LCH.add(CHF);
            //audtrail.getOneHistory(null);
            
            test.stopTest();
        }
    }
        static testmethod void testmethod3()
    {
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        test.startTest();
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
                       
            Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19135';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
            
            css_claims__c claimsobj=new css_claims__c();
            claimsobj.Customer_Name__c = 'Oliver trucks';
            claimsobj.Status__c='Submitted';
            claimsobj.Account__c= acc.id;
            insert claimsobj;
            
            claimsobj.Pending_Authorization__c='Rejection_Comments';
            update claimsobj;
            claimsobj.Actual_Technician_Time__c=2.0;
            update claimsobj;
            
            css_claims__c claims=[select id,name,Customer_Name__c,Status__c, IsDealerCreatedClaim__c from css_claims__c where Customer_Name__c = 'Oliver trucks'  limit 1];
            system.debug('Akakaka'+claims);
            
            
            

            CSS_PSN__c psnobj = css_testdata.createpsn(true, claimsobj.id);
            psnobj.Application__c='AUTOMOTIVE';
            update psnobj;
            psnobj.PSN__c='79855048';
            update psnobj;
            psnobj.Service_Model__c='ISX15 CM2350 X101';
            update psnobj;
           
            
            
            
            
            list<css_job_order__history> joord = [select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name From css_job_order__history where Field ='created' limit 1];
            list<css_job_order__history> joord1 = [select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name From css_job_order__history where Field!='Assigned_To' limit 1];

            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            //JO = css_testdata.createJobOrder(false);
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
            //JO.Status__c = 'Repair';
            //JO.Assigned_To__c = null;
            //update jo;
            List<css_job_order__history> cjh=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById, 
                                              CreatedBy.Name From css_job_order__history where id =:Jo.id limit 1 ];
            //CSS_Job_Order__c cjo=[select id, name,Assigned_To__c,Status__c from CSS_Job_Order__c where id=:cjh[0].parentid];
            //cjo.Assigned_To__c = UserInfo.getUserId();
            jo.Status__c = null;
            update jo;
            
            string cId = apexpages.currentPage().getparameters().put('id',claims.id);

            List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();

            CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH.CSS_Job_Id__c = jo.id;
            cssJH.CSS_New_Value__c = null;
            cssJH.CSS_Old_Value__c = 'Added';
            cssJH.CSS_Field_Name__c = 'DSID_Owner__c';
            cssJH.System_Modified__c = true;
            cssJH.Audit_Message__c = null;
            insert cssJH;

            CSS_JobHistory__c cssJH1 = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH1.CSS_Job_Id__c = cjh[0].parentid;
            cssJH1.CSS_New_Value__c = null;
            cssJH1.CSS_Old_Value__c = 'Added JSA form1';
            cssJH1.CSS_Field_Name__c = 'VIN__c';
            //cssJH1.Audit_Message__c = null;
            lstcssJH.add(cssJH1);

            CSS_JobHistory__c cssJH2 = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH2.CSS_Job_Id__c = cjh[0].parentid;
            cssJH2.CSS_New_Value__c = null;
            cssJH2.CSS_Old_Value__c = 'Added JSA form1';
            cssJH2.CSS_Field_Name__c = 'Sub_Status__c';
           // cssJH2.Audit_Message__c = null;
            lstcssJH.add(cssJH2);

            CSS_JobHistory__c cssJH3 = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH3.CSS_Job_Id__c = cjh[0].parentid;
            cssJH3.CSS_New_Value__c = null;
            cssJH3.CSS_Old_Value__c = 'Added JSA form1';
            cssJH3.CSS_Field_Name__c = 'JobLocation__c';
            //cssJH3.Audit_Message__c = null;
            lstcssJH.add(cssJH3);

            CSS_JobHistory__c cssJH4 = new CSS_JobHistory__c();
            if(cjh != null && cjh.size() >0)
            cssJH4.CSS_Job_Id__c = cjh[0].parentid;
            cssJH4.CSS_New_Value__c = null;
            cssJH4.CSS_Old_Value__c = 'Added JSA form1';
            cssJH4.CSS_Field_Name__c = 'Additional_Tech3__c';
            lstcssJH.add(cssJH4);

            insert lstcssJH;
           
            
            CSS_Claim_Submission__c claimsubobj = css_testdata.createclaimsub(true, claimsobj.Id);
            claimsubobj.Claim_Number__c=claims.Name;
            update claimsubobj;
            claimsubobj.Claim_Status__c='Submitted';
            update claimsubobj;
            claimsubobj.Claim_Status__c='Applealed/Resubmitted';
            update claimsubobj;
            try{
                css_psn__history psn1=[select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name 
                                       from css_psn__history where Field!='created' limit 1];
            }
            catch(exception er){

            }
            list<CSS_Claims__history> chlist = [select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name
                                                from CSS_Claims__history
                                                where Field!='created' Order by CreatedDate desc limit 10];

            //list<css_job_order__history> joord = [select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name From css_job_order__history where Field ='created' limit 10];

            list<CSS_Claim_Submission__history> claimsublist = [select ParentId,OldValue, NewValue,IsDeleted,Field,CreatedDate,CreatedById,CreatedBy.Name from CSS_Claim_Submission__history where Field!='created' Order by CreatedDate desc limit 10];
if(chlist != null && chlist.size() >0) {
                     apexpages.currentPage().getparameters().put('id',chlist[0] !=null ? chlist[0].ParentId : null);
            }
            if(joord != null && joord.size() >0) {
                apexpages.currentPage().getparameters().put('jobordID',joord[0] !=null ? joord[0].ParentId : null);
            }
            if(claimsublist != null && claimsublist.size() >0) {
                apexpages.currentPage().getparameters().put('claSubmId',claimsublist[0] !=null ? claimsublist[0].ParentId:null); 
            }
           
         
            CG_CL_ClaimsAuditTrail audtrail = new CG_CL_ClaimsAuditTrail();
            audTrail.claimsRec = claims;
            if(joord != null && joord.size() >0) 
            audtrail.jobId=joord[0].ParentId;
            if(claimsublist != null && claimsublist.size() >0) 
            audtrail.claimSubsId = claimsublist[0].ParentId;
            
            audtrail.getHistories();
            //audtrail.getOneHistory(null);
            
            test.stopTest();
        }
    } 
    @isTest(seealldata = false) 
    static  void testmethod4()
    {
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            account acc = new account();
            acc.Name = 'test';
            acc.Type = 'Customer';
            acc.CSS_DistributorCode__c = '25270';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c = '25720';
            insert acc;
         
            
          

            
            css_claims__c claimsobj=css_testdata.createclaims(false,null);
            claimsobj.Status__c='Submitted';
            claimsobj.Account__c= acc.id;
           // update claimsobj;
            claimsobj.Pending_Authorization__c='Rejection_Comments';
            //update claimsobj;
            claimsobj.Actual_Technician_Time__c=2.0;
            claimsobj.Catastrophic__c=false;
            insert claimsobj;
            CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
          
            cssJH.CSS_Job_Id__c = claimsobj.id;
            cssJH.CSS_New_Value__c ='005test123';
            cssJH.CSS_Old_Value__c = '005Added1';
            cssJH.CSS_Field_Name__c = 'DSID_Owner__c';
            cssJH.System_Modified__c = true;
            cssJH.Audit_Message__c = null;
            insert cssJH;

            
           
          
            
           string cId = apexpages.currentPage().getparameters().put('id',claimsobj.id);
           
            test.startTest();
            CG_CL_ClaimsAuditTrail audtrail = new CG_CL_ClaimsAuditTrail();
            date d = system.today();
            audtrail.claimsNumber = 'test123';
            audtrail.creditDate = d;
            audtrail.psnids = '79464646';
            audtrail.strField='Assigned_To';
          
          
            
            audtrail.getHistories();
           
            
        
            
            test.stopTest();
        }
    }
    
   

}