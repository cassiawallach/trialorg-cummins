/***********************************************************************
    Name:CG_GetWarrantyDetailesHelper_Test
    Copyright Â© 2019  Cummins
    ================================================================
    ================================================================
    Purpose:                                                            
    -------  
    This class is used for testing CG_GetWarrantyDetailesHelper class 
    ================================================================
    ================================================================
    History                                                            
    -------                                                            
    VERSION  AUTHOR             DATE              DETAIL                                 
    1.0      Miruthula K     25/07/2019        INITIAL DEVELOPMENT                    
**************************************************************************/

@isTest
public class CG_GetWarrantyDetailesHelper_Test{
    
    static testmethod void GetWarrantyDetailsMethod()
    {
        CSS_Job_Order__c  JO = new CSS_Job_Order__c();
        Jo.Customer_Name__c = 'Oliver Trucking';
        Insert JO;
        
        CSS_Claims__c Claims = new CSS_Claims__c();
        claims.Location_Code__c = '12345-12345';
        claims.ReconEngineFlag__c = 'N';
       // claims.OwnerId = UserInfo.getUserId();
        //insert Claims;
        
          String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            claims = CSS_TestData.createclaims(true,joorder.Id);
        }
        
       
        
        list<CSS_PSN__c> lstPSN = new list<CSS_PSN__c>();
        CSS_PSN__c PSN = new CSS_PSN__c();
        PSN.CSS_Claims__c = claims.id;
        PSN.PSN__c = '794646464';
        PSN.Failure_Date__c = system.today();
        PSN.ApplicationCode__c = '130';
        PSN.Mileage__c = 30;
        PSN.Mileage_Measure__c = 'Miles';
        PSN.Warranty_Start_Date__c = (system.today()) - 90;
        lstPSN.add(PSN);
        insert lstPSN;
        
        List<CSS_Solution_Component__c> ScList = new  List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c SC = new CSS_Solution_Component__c();
        SC.Service_Job__c = Jo.id;
        SC.Type__c = 'CAMPAIGN';
        ScList.add(SC);
        
        CSS_Solution_Component__c SC1 = new CSS_Solution_Component__c();
        SC1.CSS_Claims__c = claims.id;
        SC1.Type__c = 'CAMPAIGN';
        SC1.System_Code__c = 'TH';
        SC1.Component_Code__c = 'AC';
        SC1.Component_Id__c = '2062';
        ScList.add(SC1);
        insert SCList;
        
        set<id> SID = new Set<id>();
        SID.add(JO.id);
        SID.add(Claims.id);
        
        Test.startTest();
        CG_GetWarrantyDetailesHelper GW = new CG_GetWarrantyDetailesHelper();
        CG_GetWarrantyDetailesHelper.getWarrantyDetailesForJob(SID);
        CG_GetWarrantyDetailesHelper.getWarrantyDetailesForPSN(SID);
        Test.stopTest();
    }
    
}