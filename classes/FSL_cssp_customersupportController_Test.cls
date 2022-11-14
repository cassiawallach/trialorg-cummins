@isTest
public class FSL_cssp_customersupportController_Test {
    
    static testMethod void customersupportControllerMehod1(){
        
        FSL_Cummins_Care_Number__mdt CCN = [SELECT DeveloperName,MasterLabel,
                                            Cummins_Care_Numbers__c,
                                            ActiveCheck__c,
                                            Asia_and_Europe__c
                                            FROM FSL_Cummins_Care_Number__mdt 
                                            WHERE ActiveCheck__c = true and MasterLabel != null limit 1];
        
        FSL_cssp_customersupportController.getMetaData(CCN.MasterLabel);
        FSL_cssp_customersupportController.fetchUser();
    }
    
}