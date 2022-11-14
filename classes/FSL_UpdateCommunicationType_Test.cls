/**********************************************************************
Name: FSL_UpdateCommunicationType_Test
Copyright Â© 2021  Cummins
======================================================
======================================================
Purpose: Test Class To update the communication type to Manual communication in service order, when button is clicked on custom component.                                                         
-------  
======================================================a
======================================================a
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Mani Kumar Kaki      06/05/2021     INITIAL DEVELOPMENT*/
@istest(SeeAllData=true)
public  class FSL_UpdateCommunicationType_Test {
@istest(SeeAllData=true)
  public static void updatingType(){
           String Communication = 'Manual Communication';
        WorkOrder ObjWorkOrd = new WorkOrder();
        ObjWorkOrd = [select id,Communication_Type__c from WorkOrder WHERE Communication_Type__c !=: Communication Limit 1];
           FSL_UpdateCommunicationType.updateType(ObjWorkOrd.Id);
         
    }

}