/**************************************************************************************************************************************
* CT3-237: Test class for class FSL_BatchSendInsitImgNamesToMW,FSL_SendInsitImgNamesToMW, FSL_schBatchSendInsitImgNamesToMW
* @Author: Dinesh Yadav, Created Date: 9 Dec 2020. 
***comment added for sept release***
***************************************************************************************************************************************/ 

@IsTest
public class FSL_schBatchSendInsitImgNamesToMW_Test {
    
    static testMethod void testParse() {
        
        Account acc = new Account();
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.8;
        insert acc;
        
        worktype  wType = new worktype();
        wType.EstimatedDuration = Decimal.valueOf('40.02');
        wType.Name = 'Test';
        insert wType;
        
        Asset  ast = new Asset();
        ast.Account = acc;
        ast.Service_Model__c = 'ISL9 CM2350 L101';
        ast.Unit_Number__c = '1234';
        ast.Make__c = 'KENWORTH';
        ast.Model__c = 'T800';
        ast.Name = '79963830';
        ast.Unit_Type__c = 'EQ8349';
        ast.VIN__c = '1NKDX4TX6JJ180253';
        ast.Type_PSN__c = 'Engines-79963830';
        ast.Application_Description__c = 'AUTOMOTIVE';
        ast.Application_Code__c = '130';
        ast.Engine_Family__c = '56';
        ast.Type__c = 'Engines';
        insert ast;
        
        OperatingHours oh = new OperatingHours();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory serTer1 = new ServiceTerritory();
        serTer1.Name = 'ST005 Mobile';
        serTer1.OperatingHoursId = oh.Id;
        serTer1.IsActive = true;
        serTer1.Location_Code__c = '03522-04893';
        serTer1.FSL_Service_Territory_Code__c = '04893';
        serTer1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer1.Territory__c = 'AUSTRALIA';
        insert serTer1; 
        
        workOrder wo1 = new workOrder();
        wo1.Account = acc;
        wo1.Process_Step__c = 'Intake';
        wo1.Asset = ast;
        wo1.Repair_Location__c = 'Mobile';
        wo1.EditComplaint__c = 'Testing';
        wo1.EditCause__c = 'Testing';
        wo1.EditCorrection__c = 'Testing';
        wo1.EditCoverage__c = 'Testing';
        wo1.ServiceTerritoryid = serTer1.id;
        // wo1.Case = cs;
        wo1.Asset =ast;
        insert wo1;
        
        List<WO_INSITE_Images__c> lstWI = new List<WO_INSITE_Images__c>();
        WO_INSITE_Images__c objWOInsit = new WO_INSITE_Images__c();
        objWOInsit.Eif_Before_Image__c ='I-20190421-111230469-EA2C1D72.eif';
        objWOInsit.Eif_After_Image__c = 'I-20190421-111230101-EB2C1D72.eif';
        objWOInsit.Csv_Before_Image__c = 'I-20191002-111230700-EB2C1D01.csv';
        objWOInsit.Csv_After_Image__c = 'I-20190421-111230101-EB2C1D72.csv';
        objWOInsit.Eif_Before_Image_Present__c = 'New';
        objWOInsit.Csv_Before_Image_present__c = 'New';
        objWOInsit.Eif_After_Image_Present__c = 'New';
        objWOInsit.Csv_After_Image_present__c = 'New'; 
        objWOInsit.Service_Order__c = wo1.id;
        insert objWOInsit;
        lstWI.add(objWOInsit);
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.End_Point__c = 'https//test.com/getQSOLToken';
        conDetails1.Passcode__c = 'IlNPjm4jYGgNKRfNCHPuUlF1gzoxqw0vbUyPkxli+6LQcumQ+uIrDn/hj33/BnXWgLCYx2rYmZqNEEfAngwcaw==';
        conDetails1.Username__c = 'IBghHkWHnx1TU0vBYHwLxDUzeq+2FfPz/ZaCRpoyYJG80u+lyvLG8SGR4cYbXFD8o143XJ1nB4sf+fsfwKdfiA==';
        conDetails1.Name = 'MuleAuthDEV';
        conDetails1.IsActive__c = true;
        conDetails1.Method_Type__c  = 'POST'; 
        conDetails1.Key__c = 'nHvOJHc6KIXtyhErS0q1R2NzDq0XBDC4mLh7rdetqD0=';
        insert conDetails1;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'FSL_Mule_INSITEImages';
        conDetails.End_Point__c = 'https//test.com/Getwarrantydocs';
        conDetails.DocumentType__c='ALL';
        conDetails.Language__c ='en';
        conDetails.BusinessUnit__c ='EBU';
        conDetails.AuthEnv__c ='MuleAuthDEV';
        conDetails.Passcode__c = 'IlNPjm4jYGgNKRfNCHPuUlF1gzoxqw0vbUyPkxli+6LQcumQ+uIrDn/hj33/BnXWgLCYx2rYmZqNEEfAngwcaw==';
        conDetails.Username__c = 'IBghHkWHnx1TU0vBYHwLxDUzeq+2FfPz/ZaCRpoyYJG80u+lyvLG8SGR4cYbXFD8o143XJ1nB4sf+fsfwKdfiA==';
        conDetails.Method_Type__c = 'POST'; 
        conDetails.IsActive__c = true;
        conDetails.Key__c = 'nHvOJHc6KIXtyhErS0q1R2NzDq0XBDC4mLh7rdetqD0=';
        insert conDetails;
        
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        Test.startTest();
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new FSL_schBatchSendInsitImgNamesToMW());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        //Calling batch because execute method is not calling
        FSL_BatchSendInsitImgNamesToMW cb = New FSL_BatchSendInsitImgNamesToMW();
        Database.QueryLocator ql = cb.start(null);
        cb.execute(null,lstWI);
        cb.Finish(null);
        
        String jobId2 = System.schedule('ScheduleApexClassTestLW',  CRON_EXP, new FSL_schBatchSendInsitImgNamesToMWLW());
        
        //Calling batch because execute method is not calling
        FSL_BatchSendInsitImgNamesToMWLastWeek cbl = New FSL_BatchSendInsitImgNamesToMWLastWeek();
        Database.QueryLocator qll = cbl.start(null);
        cbl.execute(null,lstWI);
        cbl.Finish(null);
        Test.stopTest();
    }
}