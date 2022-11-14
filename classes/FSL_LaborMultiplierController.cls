/**********************************************************************
Name:FSL_LaborMultiplierController
Copyright Â© 2022  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is used for prepopulate the Labor Multiplier value when user creates new Asset 
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Divyasri Srirangam         2/07/2022                       
***********************************************************************/
public class FSL_LaborMultiplierController {
    @AuraEnabled
    Public static FSL_Labor_Multiplier__c getLaborMultiplierDetails(){
        FSL_Labor_Multiplier__c laborMultiplierObj;
        Try{
            laborMultiplierObj=[select id,Description__c,Multiplier_Values__c from FSL_Labor_Multiplier__c where
                                Name='TIER B' LIMIT 1];
            system.debug('laborMultiplierObj'+laborMultiplierObj);
        }Catch(Exception ex){
            System.debug('exception'+ex.getMessage());
        } 
        return laborMultiplierObj;
    }

}