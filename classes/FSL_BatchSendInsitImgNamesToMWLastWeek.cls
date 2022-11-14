/*
@ Author Name: Dinesh Yadav
@ Created Date: Dec 2020
@ Purpose: This batch class used to Send INSITE image names to MW API and update related WO Insite recods based on response. This job will runs every week. 
@ Test Class: FSL_schBatchSendInsitImgNamesToMW_Test
@ Last Modified Date: 
@ CT3-248.
*/
global class FSL_BatchSendInsitImgNamesToMWLastWeek implements Database.Batchable<sObject>, Database.AllowsCallouts{
     
    global Database.QueryLocator start(Database.BatchableContext bc){
        DateTime startvalue = System.Today().addDays(-30);
        DateTime endvalue = System.Now();
        system.debug('startvalue :: '+startvalue+' :: '+endvalue);
        String soqlQuery = 'SELECT Id, Eif_Before_Image__c, Eif_After_Image__c, Csv_Before_Image__c, Csv_After_Image__c, Eif_Before_Image_Present__c, Eif_Before_Image_ModifiedDate_Time__c, Eif_After_Image_Present__c, Eif_After_Image_ModifiedDate_Time__c, Csv_Before_Image_present__c, Csv_Before_Image_ModifiedDate_Time__c, Csv_After_Image_present__c, Csv_After_Image_ModifiedDate_Time__c From WO_INSITE_Images__c where ((Eif_Before_Image__c != null and Eif_Before_Image_Present__c = \'No\') OR (Eif_After_Image__c != null and Eif_After_Image_Present__c = \'No\') OR (Csv_Before_Image__c != null and Csv_Before_Image_present__c = \'No\') OR (Csv_After_Image__c != null and Csv_After_Image_present__c = \'No\')) and LastModifiedDate>=:startvalue and LastModifiedDate<=:endvalue';
        system.debug('soqlQuery :: '+soqlQuery);
        return Database.getQueryLocator(soqlQuery);
    }
     
    global void execute(Database.BatchableContext bc, List<WO_INSITE_Images__c> scope){
        system.debug('Scope:: '+scope);
        
        FSL_SendInsitImgNamesToMW objSendInsite = new FSL_SendInsitImgNamesToMW();
        objSendInsite.SendInsitImgNamesToMW(scope);
    }
     
    global void finish(Database.BatchableContext bc){
         
    }
}