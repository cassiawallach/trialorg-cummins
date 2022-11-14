/**********************************************************************
Name:CG_CL_ClaimsWarranty_Test
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
this is test class for CG_CL_ClaimsWarranty Controller.
===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR                      DATE                DETAIL                                 
1.0 -      Rajasekhar Hindupur      02/14/2018           INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest(seealldata=true)
public class CG_CL_ClaimsWarranty_Test{
    public static Testmethod void CG_CL_ClaimsWarranty_Method(){
        test.startTest();
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
        
        string cId;
        //css_job_order__c jo = css_testdata.createJobOrder(true);
        //CSS_claims__c claims = css_testdata.createclaims(true,jo.id);
        Account Acc = new Account();
        Acc.Name = 'Test Account';
        Acc.Region__c = 'NORTH AMERICA';
        Acc.Territory__c = 'UNITED STATES';
        Acc.IAM_Service_Provider_Code__c = '12345';
        Acc.CSS_DistributorCode__c = '12345';
        
        insert Acc;
        css_header_nav__c ch = new css_header_nav__c(SetupOwnerId = UserInfo.getUserId(), Name = 'Ritesh');
            ch.RSWButtonEnable__c = true;
            insert ch;
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Status__c='Submitted';
        claims.ESN__c='79462880';
        claims.Customer_Name__c='BRITESTONE COLONY';
        claims.Customer_Code__c='123';
        claims.Location_Code__c='12345-12345';
        claims.Multi_PSN_Claim__c=true;
            claims.FieldActionWebServiceResult__c='Error';
        insert claims;
      /*  CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='TestSRTS'+Math.random();
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Diagnostic_notes__c = 'solutions diagnostic notes';
        solAdd.Repair_Notes__c = 'Repair Notes';
        solAdd.Repair_Response__c = 'Repair Successful.';
        solAdd.Rank__c = 3;
        insert soladd;*/
        List<CSS_Solution_Component__c> solComps=new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solAdd;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAM';
        AddsolComp.CSS_Claims__c=claims.id;
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        AddsolComp.Type__c='ATC';
        AddsolComp.Status__c = 'Approved';
        // solcomp.Claim_FailCode__c=
        AddsolComp.Selected_Component__c=true;
        AddsolComp.AccountCodeType__c='Test-AccountCode2';
        AddsolComp.AccountCodeEdit__c = 'Test-AccountCode';
        AddsolComp.AccountCode__c = 'Test-AccountCode1';
        upsert AddsolComp;
        solComps.add(AddsolComp);
        //insert solComps;
        CSS_PSN__c psn=css_testdata.createpsn(true,claims.id);
        //system.debug('JO ID---'+JO.ID);
        //cId=ApexPages.CurrentPage().getParameters().get('id');
        //PageReference pageRef = new PageReference('/apex/CG_ClaimsWarranty?id=');
        PageReference pageRef = Page.CG_ClaimsWarranty;
        pageRef.getParameters().put('id', claims.Id);
        Test.setCurrentPage(pageRef); 
        
        //String id = ApexPages.currentPage().getParameters().get('id');
        CG_CL_ClaimsWarranty claimsWar = new CG_CL_ClaimsWarranty();
        css_utility.getRegionTerritory('12345-12345');
        PageReference pageRef1=claimsWar.nvClaimsIntake();
        PageReference pageRef2=claimsWar.nvClaimsVH();
        PageReference pageRef3=claimsWar.nvClaimsCC();
        PageReference pageRef4=claimsWar.nvClaimsFC();
        PageReference pageRef5=claimsWar.nvClaimsPOC();
        PageReference pageRef6=claimsWar.nvClaimsSRTs();
        PageReference pageRef7=claimsWar.nvClaimsJobNotes();
        PageReference pageRef8=claimsWar.nvClaimsVS();
        PageReference pageRef9=claimsWar.nvClaimsPSN();
        claimsWar.pgSave();
        claimsWar.nvClaimsMulti_PSN();
        test.stopTest();
    }
    }
    }