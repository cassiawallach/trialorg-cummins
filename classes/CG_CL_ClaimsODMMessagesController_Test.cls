@isTest
public class CG_CL_ClaimsODMMessagesController_Test{
    
    public static Testmethod void Method1(){
        
        test.startTest();
        
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId())){
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            Account acc = new Account();
            acc.name='Rtest123';
            acc.CSS_DistributorCode__c='03742';  
            acc.Type='Dealer Account';
            acc.IAM_Service_Provider_Code__c = '03741';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
            
            CSS_claims__c claims = new CSS_Claims__c();
            claims.Account__c = acc.id;
            claims.Status__c='Submitted';
            claims.ESN__c='79462880';
            claims.Customer_Name__c='BRITESTONE COLONY';
            claims.Customer_Code__c='123';
            claims.Location_Code__c='02466-19134';
            claims.Multi_PSN_Claim__c=false;
            claims.ODM_Status_Message__c = 'Passed successfully';
            claims.ODM_Status__c =' PASSED';
            claims.CSS_Job__c = jo.id;
            claims.SRT_Olap_Reason_Msg__c='test';
            claims.EditCorrection__c = '';
            claims.Actual_Technician_Time__c = null;
            claims.ODM_Status_Code__c = '203';
            claims.Mutual_Exclusive_Message__c = 'passed it';
            claims.ODM_Pre_submit_Status_Message__c = 'haha';
            claims.PartsRelatedODMMessage__c='failed';  
            claims.License_Plate_State_Error_message__c = 'Test';
            claims.DupAccessCodePercentReqMsg__c = 'Test';
            claims.CoveragePartsErrMsg__c = 'test';
            claims.CoverageTTMLErrMsg__c = 'test';
            claims.CoverageOCErrMsg__c = 'test';
            claims.CoverageSRTErrMsg__c  ='test';
            claims.DuplicateSRTDetails__c  = 'test';
            claims.ownerId = UserInfo.getUserId();
            insert claims;
            
            id cId=ApexPages.CurrentPage().getParameters().put('id',claims.id);
            
            CSS_Solutions__c solAdd = CSS_TestData.createSolutions(true , jo.Id);
            
            
            CSS_Solution_Component__c solCom = new CSS_Solution_Component__c();
            solCom.Name ='sneha';
            solCom.ODM_Status__c = 'ERROR';
            solCom.ODM_Status_Code__c = 'test';
            solCom.ODM_Status_Message__c = '';
            solCom.Component_Id__c ='F0051000';
            solCom.Service_Job__c = jo.Id;
            solCom.Action__c = 'Repair';
            solCom.Solutions__c = solAdd.id;
            solCom.Quantity__c = 4;
            solCom.type__c='CAM';
            solCom.Selected_Component__c = True;
            solCom.AccountCode__c = 'Test-AccountCode';
            solCom.AccountCodeEdit__c = 'Test-ACEdit';
            solCom.CoveredPartsQty__c = null;
            solCom.AccountCodeType__c='ASAS';
            solCom.Fail_Code_Editable__c='CAM-campaign';
            solcom.Failure_Mode__c  = null;
            solCom.CSS_Claims__c = cId;
            insert solCom;
            
            css_Srt__C srt = new css_Srt__C();
            srt.CSS_Claims__c = cId;
            srt.Component_Id__c = solCom.id;
            //srt.Job_Order__c = jo.id;
            srt.Solution_Number__c = solAdd.id;
            srt.ODM_Status_Code__c = 'test';
            insert srt;
            
            CSS_Parts_Options__c partsRec = new CSS_Parts_Options__c();
            partsRec.selected_part__c=true;
            partsRec.CSS_Claims__c =claims.Id;
            partsRec.Service_partnumber__c='437398900';
            partsRec.Part_Assignment__c = 'Primary';
            partsRec.Parts_Type__c = 'Custom';
            insert partsRec;
            
            CSS_Parts_Options__c partsRec1 = new CSS_Parts_Options__c();
            partsRec1.selected_part__c=true;
            partsRec1.CSS_Claims__c =claims.Id;
            partsRec1.Service_partnumber__c='437398900';
            partsRec1.Part_Assignment__c = 'Primary';
            partsRec1.Parts_Type__c = 'BMS Parts';
            partsRec1.Account_Code__c='emmision warrenty60';
            insert partsRec1;
            
            Map<String,CSS_Parts_Options__c> partERPAccCodeMap = new Map<String,CSS_Parts_Options__c>();
            partERPAccCodeMap.put(partsRec1.Service_partnumber__c+ partsRec1.Account_Code__c,partsRec1);
            
            CG_CL_ClaimsODMMessagesController OD = new CG_CL_ClaimsODMMessagesController();
            OD.splitRelatedStatusMsg();
            //OD.claimsMutuallyExclusiveMsg = 'sneha';
            OD.odmsrtstatusCodeFlag = true;
            OD.odmpartstatusCodeFlag = true;
            OD.odmsolcompsatusCodeFlag = true;
            OD.mutuallyExcSRTFlag = true;
            OD.pendingAuthFlag = true;
            OD.licensePlate = 'test';
            OD.dealerLocation=true;
            OD.dealerCustomer=true;
            OD.splitheaderclaimsRecStatusMsg();
            
            String orgtype=css_utility.getOrgType(userinfo.getUserId());
            boolean isClaimEnabled = css_utility.getclaimsapprove(UserInfo.getUserId());
            
            CG_CL_ClaimsODMMessagesController.claimsSCListWrapper innerclass = new CG_CL_ClaimsODMMessagesController.claimsSCListWrapper();
            innerclass.failcode ='';
            innerclass.odmStatus ='';
            innerclass.odmStatusMsg ='';
            
            CG_CL_ClaimsODMMessagesController.claimsPOListWrapper innerclass1 = new CG_CL_ClaimsODMMessagesController.claimsPOListWrapper();
            innerclass1.partnumber='testing';
            innerclass1.odmStatus='testing';
            innerclass1.odmStatusMsg ='testing'; 
            
            CG_CL_ClaimsODMMessagesController.claimsSRTListWrapper innerclass2 = new CG_CL_ClaimsODMMessagesController.claimsSRTListWrapper();
            innerclass2.failcode ='FAIL';
            innerclass2.odmStatus ='PASSED';
            innerclass2.odmStatusMsg ='PASSED';  
            
            List<CG_CL_ClaimsODMMessagesController.claimsSCListWrapper> wrapclaimsSCList=new List<CG_CL_ClaimsODMMessagesController.claimsSCListWrapper>();
            wrapclaimsSCList.add(innerclass);
            List<CG_CL_ClaimsODMMessagesController.claimsPOListWrapper> wrapclaimsPOList=new List<CG_CL_ClaimsODMMessagesController.claimsPOListWrapper>();
            wrapclaimsPOList.add(innerclass1);
            List<CG_CL_ClaimsODMMessagesController.claimsSRTListWrapper> wrapclaimsSRTList=new List<CG_CL_ClaimsODMMessagesController.claimsSRTListWrapper>();
            wrapclaimsSRTList.add(innerclass2);
            
            CSS_Claims__c claimsRec = new CSS_Claims__c();
            claimsRec.ODM_Status__c='PASSED';
            claimsRec.ODM_Status_Message__c='PASSED';
            claimsRec.ODM_Pre_submit_Status__c='PASSED';
            claimsRec.ODM_Pre_submit_Status_Message__c='PASSED';
            insert claimsRec;
            OD.Cid=claimsRec.Id;
            OD.splitheaderclaimsRecStatusMsg();
            //OD.splitRelatedStatusMsg();
        }  
        test.stoptest();
    }
    
    public static Testmethod void Method2(){
        
        test.startTest();
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            
            CSS_claims__c claims = new CSS_Claims__c();
            claims.Status__c='Submitted';
            claims.ESN__c='79462880';
            claims.Customer_Name__c='BRITESTONE COLONY';
            claims.Customer_Code__c='123';
            claims.Location_Code__c='12345-12345';
            claims.Multi_PSN_Claim__c=false;
            claims.ODM_Status_Message__c = 'Passed successfully';
            claims.ODM_Status__c =' PASSED';
            claims.CSS_Job__c = null;
            claims.EditCorrection__c = '';
            claims.Actual_Technician_Time__c = 0000.0;
            claims.ODM_Status_Code__c = '203';
            claims.ownerId = UserInfo.getUserId();
            claims.ODM_Status_Message__c=null;
            insert claims;
            
            id cId=ApexPages.CurrentPage().getParameters().put('id',claims.id);
            
            CSS_Solution_Component__c solCom = new CSS_Solution_Component__c();
            solCom.Name ='sneha';
            solCom.ODM_Status__c = 'ERROR';
            solCom.ODM_Status_Code__c = 'test';
            solCom.ODM_Status_Message__c = 'success';
            solCom.Component_Id__c ='F0051000';
            solCom.Action__c = 'Repair';
            solCom.Quantity__c = 4;
            solCom.type__c='CAM';
            solCom.Selected_Component__c = True;
            solCom.AccountCode__c = 'Test-AccountCode';
            solCom.AccountCodeEdit__c = 'Test-ACEdit';
            solCom.CoveredPartsQty__c = null;
            solCom.AccountCodeType__c='ASAS';
            solCom.Fail_Code_Editable__c='CAM-campaign';
            solCom.CSS_Claims__c = cId;
            insert solCom;
            
            CG_CL_ClaimsODMMessagesController OD = new CG_CL_ClaimsODMMessagesController();
            // OD.claimsMutuallyExclusiveMsg = 'sneha';
            OD.odmsrtstatusCodeFlag = true;
            OD.odmpartstatusCodeFlag = true;
            OD.odmsolcompsatusCodeFlag = true;
            OD.mutuallyExcSRTFlag = true;
            OD.pendingAuthFlag = true;
            OD.licensePlate = 'test';
            OD.splitheaderclaimsRecStatusMsg();
            String orgtype=css_utility.getOrgType(userinfo.getUserId());
            //}  
            CG_CL_ClaimsODMMessagesController.claimsSCListWrapper innerclass = new CG_CL_ClaimsODMMessagesController.claimsSCListWrapper();
            innerclass.failcode ='';
            innerclass.odmStatus ='';
            innerclass.odmStatusMsg ='';
            
            CG_CL_ClaimsODMMessagesController.claimsPOListWrapper innerclass1 = new CG_CL_ClaimsODMMessagesController.claimsPOListWrapper();
            innerclass1.partnumber='testing';
            innerclass1.odmStatus='testing';
            innerclass1.odmStatusMsg ='testing';   
            
            CG_CL_ClaimsODMMessagesController.claimsSRTListWrapper innerclass2 = new CG_CL_ClaimsODMMessagesController.claimsSRTListWrapper();
            innerclass2.failcode ='FAIL';
            innerclass2.odmStatus ='PASSED';
            innerclass2.odmStatusMsg ='PASSED';   
            
            List<CG_CL_ClaimsODMMessagesController.claimsSCListWrapper> wrapclaimsSCList=new List<CG_CL_ClaimsODMMessagesController.claimsSCListWrapper>();
            wrapclaimsSCList.add(innerclass);
            List<CG_CL_ClaimsODMMessagesController.claimsPOListWrapper> wrapclaimsPOList=new List<CG_CL_ClaimsODMMessagesController.claimsPOListWrapper>();
            wrapclaimsPOList.add(innerclass1);
            List<CG_CL_ClaimsODMMessagesController.claimsSRTListWrapper> wrapclaimsSRTList=new List<CG_CL_ClaimsODMMessagesController.claimsSRTListWrapper>();
            wrapclaimsSRTList.add(innerclass2);
            
            CSS_Claims__c claimsRec = new CSS_Claims__c();
            claimsRec.ODM_Status__c='PASSED';
            claimsRec.ODM_Status_Message__c='PASSED';
            claimsRec.ODM_Pre_submit_Status__c='PASSED';
            claimsRec.ODM_Pre_submit_Status_Message__c='PASSED';
            insert claimsRec;
            
            OD.Cid=claimsRec.Id;
            OD.splitheaderclaimsRecStatusMsg();
            //OD.splitRelatedStatusMsg();
        }
        test.stopTest();
    }
    
    public static testmethod void Method3(){
        
        test.startTest();
        Account acc = new Account();
        acc.name='Rtest123';
        acc.CSS_DistributorCode__c='03742';  
        acc.Type ='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '03741';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
            
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        jo.Account__c = acc.id;
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            
            
            CSS_claims__c claims = new CSS_Claims__c();
            claims.Account__c = acc.id;
            claims.Status__c='Submitted';
            claims.ESN__c='79462880';
            claims.Customer_Name__c='BRITESTONE COLONY';
            claims.Customer_Code__c='123';
            claims.Location_Code__c='12345-12345';
            claims.Multi_PSN_Claim__c=false;
            claims.ODM_Status_Message__c = 'Passed successfully';
            claims.ODM_Status__c =' PASSED';
            claims.CSS_Job__c = jo.id;
            claims.EditCorrection__c = '';
            claims.Actual_Technician_Time__c = null;
            claims.ODM_Status_Code__c = '203';
            claims.Mutual_Exclusive_Message__c = 'passed it';
            claims.ODM_Pre_submit_Status_Message__c = 'haha';
            insert claims;
            
            ApexPages.CurrentPage().getParameters().put('id',claims.id);
            
            CSS_Solutions__c solAdd = CSS_TestData.createSolutions(true , jo.Id);
            
            CSS_Solution_Component__c solCom = new CSS_Solution_Component__c();
            solCom.Name ='sneha';
            solCom.ODM_Status__c = 'ERROR';
            solCom.ODM_Status_Code__c = 'test';
            solCom.ODM_Status_Message__c = 'success';
            solCom.Component_Id__c ='F0051000';
            solCom.Service_Job__c = jo.Id;
            solCom.Action__c = 'Repair';
            solCom.Solutions__c = solAdd.id;
            solCom.Quantity__c = 4;
            solCom.type__c='CAM';
            solCom.Selected_Component__c = True;
            solCom.AccountCode__c = 'Test-AccountCode';
            solCom.AccountCodeEdit__c = 'Test-ACEdit';
            solCom.CoveredPartsQty__c = null;
            solCom.AccountCodeType__c='ASAS';
            solCom.Fail_Code_Editable__c='CAM-campaign';
            solCom.CSS_Claims__c = claims.ID;
            insert solCom;
            
            
            css_Srt__C srt = new css_Srt__C();
            srt.CSS_Claims__c = claims.Id;
            srt.Component_Id__c = solCom.id;
            //srt.Job_Order__c = jo.id;
            srt.Solution_Number__c = solAdd.id;
            srt.ODM_Status_Code__c = 'test';
            srt.isPerformed__c=true;
            srt.Type__c='Repair';
            srt.ODM_Status_Message__c='SRT needs additional information//;;SRT needs additional information';
            insert srt;
            
            CSS_Parts_Options__c pa = new CSS_Parts_Options__c();
            pa.Option_Number__c = 'O-111';
            pa.Service_Job__c = jo.Id;
            pa.selected_part__c = true;
            pa.FailurepartId__c = solCom.Id;
            pa.Part_Assignment__c = 'Primary';
            pa.Solutions__c=solAdd.Id;
            pa.ODM_Status__c='warn';
            pa.ODM_Status_Message__c='null:BEA-382502-OSB Service Callout action received an error response-500';
            pa.ODM_Status_Code__c = 'test';
            pa.Service_partnumber__c = '123';
            pa.selected_part__c = true;
            pa.Type__c='Commercial-Travel';
            pa.Item__c='Ties';
            pa.CSS_Claims__c = claims.id;
            insert pa;
            
            
            CG_CL_ClaimsODMMessagesController OD = new CG_CL_ClaimsODMMessagesController();
            OD.dealerCustomer=true;
            OD.PartsDupMsg=true;
            OD.licensePlateError=true;
            // OD.claimsMutuallyExclusiveMsg = 'sneha';
            OD.odmsrtstatusCodeFlag = true;
            OD.odmpartstatusCodeFlag = true;
            OD.odmsolcompsatusCodeFlag = true;
            OD.mutuallyExcSRTFlag = true;
            OD.pendingAuthFlag = true;
            OD.licensePlate = 'test';
            OD.splitheaderclaimsRecStatusMsg();
            String orgtype=css_utility.getOrgType(userinfo.getUserId());
            boolean isClaimEnabled = css_utility.getclaimsapprove(UserInfo.getUserId());
            //}  
            CG_CL_ClaimsODMMessagesController.claimsSCListWrapper innerclass = new CG_CL_ClaimsODMMessagesController.claimsSCListWrapper();
            innerclass.failcode ='';
            innerclass.odmStatus =''; 
            innerclass.odmStatusMsg ='';
            
            CG_CL_ClaimsODMMessagesController.claimsPOListWrapper innerclass1 = new CG_CL_ClaimsODMMessagesController.claimsPOListWrapper();
            innerclass1.partnumber='testing';
            innerclass1.odmStatus='testing';
            innerclass1.odmStatusMsg ='testing';   
            
            CG_CL_ClaimsODMMessagesController.claimsSRTListWrapper innerclass2 = new CG_CL_ClaimsODMMessagesController.claimsSRTListWrapper();
            innerclass2.failcode ='FAIL';
            innerclass2.odmStatus ='PASSED';
            innerclass2.odmStatusMsg ='PASSED';   
            
            List<CG_CL_ClaimsODMMessagesController.claimsSCListWrapper> wrapclaimsSCList=new List<CG_CL_ClaimsODMMessagesController.claimsSCListWrapper>();
            wrapclaimsSCList.add(innerclass);
            List<CG_CL_ClaimsODMMessagesController.claimsPOListWrapper> wrapclaimsPOList=new List<CG_CL_ClaimsODMMessagesController.claimsPOListWrapper>();
            wrapclaimsPOList.add(innerclass1);
            List<CG_CL_ClaimsODMMessagesController.claimsSRTListWrapper> wrapclaimsSRTList=new List<CG_CL_ClaimsODMMessagesController.claimsSRTListWrapper>();
            wrapclaimsSRTList.add(innerclass2);
            
            CSS_Claims__c claimsRec = new CSS_Claims__c();
            claimsRec.ODM_Status__c='PASSED';
            claimsRec.ODM_Status_Message__c='PASSED';
            claimsRec.ODM_Pre_submit_Status__c='PASSED';
            claimsRec.ODM_Pre_submit_Status_Message__c='PASSED';
            insert claimsRec;
            
            OD.Cid=claimsRec.Id;
            OD.splitheaderclaimsRecStatusMsg();
            OD.splitRelatedStatusMsg();
        }
        test.stopTest();
    }
}