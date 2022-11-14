/**********************************************************************
Name: FSLStageAssetTrigger
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This Trigger is used to Get Engine data from the Siebel and ERP through Mule connector.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              Related user stories                     
1.0     Ravikanth Macherla         06/10/2019         696, 697, 699, 700          
2.0     Charan                     07/12/2021         PHOEN-35 //removed , After Update     
***********************************************************************/

trigger FSLStageAssetTrigger on FSL_Stage_Asset__c (After Insert) {
    
    if(trigger.isAfter) {
        if(trigger.isInsert) {
            System.debug('Printing in Trigger for insert and Update');
            FSLstageAssetTriggerfunctions.clonestagetoAsset(Trigger.New);
        }
    }
}